Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71E8268112
	for <lists+kvm@lfdr.de>; Sun, 13 Sep 2020 21:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgIMT5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Sep 2020 15:57:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52802 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725939AbgIMT5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Sep 2020 15:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600027066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AnQUrC5RFDS1NkkiXdpsHOytgHvj46aOm9NEG/36P0o=;
        b=NnuDJtZadKE2bZAqd28heEIOW8f76vS9x46fiLfUDvDgKJlbTueZjU8FF27mJBu3Mgbxbx
        bwwOlbtVR4X3vB57V+HdTfXfVSj1af2Fja2H6iNrnGCXrlXf5L/H6K0Y2wzTxBaGE8Dy5z
        jt1n0oA6HbLjAmBQADPkVQhqZPT5JE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-hYGJhNNrN0KiChyJnzycow-1; Sun, 13 Sep 2020 15:57:45 -0400
X-MC-Unique: hYGJhNNrN0KiChyJnzycow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71CE01882FA8;
        Sun, 13 Sep 2020 19:57:43 +0000 (UTC)
Received: from starship (unknown [10.35.206.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A95BA75133;
        Sun, 13 Sep 2020 19:57:39 +0000 (UTC)
Message-ID: <ce09f2e9dd8c7315d847b92064cc4ff0dfae12ac.camel@redhat.com>
Subject: Re: [PATCH v3 8/8] KVM: nSVM: implement ondemand allocation of the
 nested state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Sun, 13 Sep 2020 22:57:38 +0300
In-Reply-To: <58f9d2c1-0739-5b72-ee21-285474666c58@redhat.com>
References: <20200827171145.374620-1-mlevitsk@redhat.com>
         <20200827171145.374620-9-mlevitsk@redhat.com>
         <58f9d2c1-0739-5b72-ee21-285474666c58@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2020-09-12 at 18:32 +0200, Paolo Bonzini wrote:
> On 27/08/20 19:11, Maxim Levitsky wrote:
> > +	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > +	if (!hsave_page)
> > +		goto error;
> > +
> 
> I think an error here should be just an internal error userspace exit,
> or a -ENOMEM from KVM_RUN; not a #GP in the guest[1].  However, that's
> difficult to plug into KVM.  Can you instead allocate nested state if
> KVM_SET_CPUID2 sets the SVM bit?  Returning -ENOMEM from KVM_SET_CPUID2
> is more likely to be something that userspace copes with.

This would be a bit sad thing to do, as it would allocate nested state for each
guest where it is enabled in CPUID, which is IMHO already the default or soon to be.

Currently nested KVM is nice to only enable EFER.SVME when a vm is created (in svm_hardware_enable)
which means that with this on demand nested state allocation, we only use nested state
for guests that actually use nested as opposed to be merely enabled.

About injecting the #GP,
I probably can make the guest triple fault instead if we consider this to be better solution.
in terms of not allowing to continue guest execution.
I somehow thought that guest will already be killed on emulation failure,
but now I do see that kvm_emulate_wrmsr and that it injects a #GP

What do you think?

> 
> I queued patches 1-5, and 7 for 5.9-rc.

Thanks!

Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> [1] Though in practice an order 0 allocation will never fail
> 


