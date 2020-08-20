Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6111924B77C
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 12:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbgHTKzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 06:55:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45605 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731632AbgHTKzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 06:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597920881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uYbV8VLkse7x10+SVN80YNuWWr3hGT+D+KMqbsymh68=;
        b=bEalcz2TSjkbqphrh0n8iI1SQaEP45V9yiGJAGfX3QJxBdOPKQmNhhu5GRbEAkwwWShWZU
        wT6K2m1LtAjWanaphIHjqzx21VmIlfjnREpbsJnxwcCLcmbEqfW0Wx525XiwhXwDhlg26G
        0/iNGnttdTzdR8vokuTiRZpcBXEXXbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-hWJLFjQNPwmPnM0BmojkMA-1; Thu, 20 Aug 2020 06:29:11 -0400
X-MC-Unique: hWJLFjQNPwmPnM0BmojkMA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1304C186A56B;
        Thu, 20 Aug 2020 10:27:06 +0000 (UTC)
Received: from starship (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31B405D9F1;
        Thu, 20 Aug 2020 10:26:57 +0000 (UTC)
Message-ID: <76c13e7d8f3c26583411fc6d42f50c98e92ebc1c.camel@redhat.com>
Subject: Re: [PATCH 8/8] KVM: nSVM: read only changed fields of the nested
 guest data area
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 20 Aug 2020 13:26:57 +0300
In-Reply-To: <be88aaae-c776-32d2-fa69-00c6aace787d@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
         <20200820091327.197807-9-mlevitsk@redhat.com>
         <53afbfba-427e-72f5-73a6-faea7606e78e@redhat.com>
         <33166884f54569ab47cc17a4c3e01f9dbc96401a.camel@redhat.com>
         <be88aaae-c776-32d2-fa69-00c6aace787d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 12:18 +0200, Paolo Bonzini wrote:
> On 20/08/20 12:05, Maxim Levitsky wrote:
> > > You probably should set clean to 0 also if the guest doesn't have the
> > > VMCBCLEAN feature (so, you first need an extra patch to add the
> > > VMCBCLEAN feature to cpufeatures.h).  It's probably best to cache the
> > > guest vmcbclean in struct vcpu_svm, too.
> > Right, I totally forgot about this one.
> > 
> > One thing why I made this patch optional, is that I can instead drop it,
> > and not 'read back' the saved area on vmexit, this will probably be faster
> > that what this optimization does. What do you think? Is this patch worth it?
> > (I submitted it because I already implemented this and wanted to hear opinion
> > on this).
> 
> Yeah, good point.  It's one copy either way, either on vmexit (and
> partly on vmentry depending on clean bits) or on vmentry.  I had not
> considered the need to copy from vmcb02 to the cached vmcb12 on vmexit. :(
> 
> Let's shelve this for a bit, and revisit it once we have separate vmcb01
> and vmcb02.  Then we might still use the clean bits to avoid copying
> data from vmcb12 to vmcb02, including avoiding consistency checks
> because we know the vmcb02 data is legit.
It makes sense I guess. The vmcb02 would then play the role of the cache of
vmcb12

> 
> Patches 1-5 are still worthwhile, so you can clean them up and send them.
> 
> Paolo

OK, on it now.

Best regards,
	Maxim Levitsky
> 


