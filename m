Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E841472D40
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 14:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbhLMN30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 08:29:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231784AbhLMN3Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 08:29:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639402165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ceoqArSaP6ZEr1raActJLXti4o2vCE8jCmahCCH2dQ=;
        b=euO4JIz5Z7ToziL66AMiBxsVHRPkwVraNz1u5iKEZj3JIxGcynvmHOcI67AgEgyhXZK5z9
        UBAuliVHu+3OMxEgRKdvwVb6FITilS60OCQUsYB0EdSgUJbRZOd/GgjXSGa3Tand8tTMny
        8L6HU+Z3xdvrOhw1IhyivJfltbKpaAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-7KOqA8moP4Ozlz00U9eu6Q-1; Mon, 13 Dec 2021 08:29:19 -0500
X-MC-Unique: 7KOqA8moP4Ozlz00U9eu6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 652F3802C9B;
        Mon, 13 Dec 2021 13:29:18 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 251EE100164A;
        Mon, 13 Dec 2021 13:29:13 +0000 (UTC)
Message-ID: <0080a4ca56f67fd24edaa64a925d5d700fd016d5.camel@redhat.com>
Subject: Re: [PATCH v2 1/5] KVM: nSVM: deal with L1 hypervisor that
 intercepts interrupts but lets L2 control EFLAGS.IF
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Mon, 13 Dec 2021 15:29:12 +0200
In-Reply-To: <6ce77eaf-ed2e-9092-0822-84caddd4a80c@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
         <20211213104634.199141-2-mlevitsk@redhat.com>
         <0d893664-ff8d-83ed-e9be-441b45992f68@redhat.com>
         <74c548c61aeb4afba3acb4143fcb91d92e7de8d6.camel@redhat.com>
         <6ce77eaf-ed2e-9092-0822-84caddd4a80c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-12-13 at 14:15 +0100, Paolo Bonzini wrote:
> On 12/13/21 14:07, Maxim Levitsky wrote:
> > > Right, another case is when CLGI is not trapped and the guest therefore
> > > runs with GIF=0.  I think that means that a similar change has to be
> > > done in all the *_allowed functions.
> > 
> > I think that SVM sets real GIF to 1 on VMentry regardless if it is trapped or not.
> 
> Yes, the issue is only when CLGI is not trapped (and vGIF is disabled).

Yes, but I just wanted to clarify that GIF is initially enabled on VM entry
regardless if it is trapped or not, after that the guest can indeed disable
the GIF if CLGI/STGI is not trapped and vGIF disabled.

> 
> > However if not trapped, and neither EFLAGS.IF is trapped, one could enter a guest
> > that has EFLAGS.IF == 0, then the guest could disable GIF, enable EFLAGS.IF,
> > and then enable GIF, but then GIF enablement should trigger out interrupt window
> > VINTR as well.
> 
> While GIF=0 you have svm_nmi_blocked returning true and svm_nmi_allowed 
> returning -EBUSY; that's wrong isn't it?

Yes, 100% agree, patch (and unit test for this as well) is on the way!

Best regards.	
	Maxim Levitsky
> 
> Paolo
> 


