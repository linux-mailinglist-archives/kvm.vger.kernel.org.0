Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7831DF41
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 19:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhBQSvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 13:51:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232565AbhBQSvT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 13:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613587793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvTxX1REm63UaLhg9YAlB+lmeLiEF7o4BY5lOTT8ELs=;
        b=LUQ0F13gyz1lVyv1qN1h2xmnbcv7i4XMnD0TIcTBxp/Li59buYReUXsZav0tmdZQpXTq02
        81lr1PBJMWod6f3jVfSOCShCpEOsPrjL3azH7blfCUerZ+PV6MC57hNNtIz6Cgwr4wI9ac
        LajBA1dEkMY4cd+U4gAt5OO15km1Dv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-fBaqKlkSMXCxqFuipNmVUw-1; Wed, 17 Feb 2021 13:49:49 -0500
X-MC-Unique: fBaqKlkSMXCxqFuipNmVUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 106F980402C;
        Wed, 17 Feb 2021 18:49:48 +0000 (UTC)
Received: from starship (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2CFE60C5F;
        Wed, 17 Feb 2021 18:49:44 +0000 (UTC)
Message-ID: <334212ae74dcf1ecf112ff00cfea61b92342d287.camel@redhat.com>
Subject: Re: [PATCH 4/7] KVM: nVMX: move inject_page_fault tweak to
 .complete_mmu_init
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Wed, 17 Feb 2021 20:49:43 +0200
In-Reply-To: <5a8bea9b-deb1-673a-3dc8-f08b679de4c5@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
         <20210217145718.1217358-5-mlevitsk@redhat.com>
         <YC1ShhSZ+6ST63nZ@google.com>
         <5a8bea9b-deb1-673a-3dc8-f08b679de4c5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-02-17 at 18:37 +0100, Paolo Bonzini wrote:
> On 17/02/21 18:29, Sean Christopherson wrote:
> > All that being said, I'm pretty we can eliminate setting 
> > inject_page_fault dynamically. I think that would yield more 
> > maintainable code. Following these flows is a nightmare. The change 
> > itself will be scarier, but I'm pretty sure the end result will be a lot 
> > cleaner.

I agree with that.

> 
> I had a similar reaction, though my proposal was different.
> 
> The only thing we're changing in complete_mmu_init is the page fault 
> callback for init_kvm_softmmu, so couldn't that be the callback directly 
> (i.e. something like context->inject_page_fault = 
> kvm_x86_ops.inject_softmmu_page_fault)?  And then adding is_guest_mode 
> to the conditional that is already in vmx_inject_page_fault_nested and 
> svm_inject_page_fault_nested.

I was thinking about this a well, I tried to make an as simple as possible
solution that doesn't make things worse.
> 
> That said, I'm also rusty on _why_ this code is needed.  Why isn't it 
> enough to inject the exception normally, and let 
> nested_vmx_check_exception decide whether to inject a vmexit to L1 or an 
> exception into L2?
> 
> Also, bonus question which should have been in the 5/7 changelog: are 
> there kvm-unit-tests testcases that fail with npt=0, and if not could we 
> write one?  [Answer: the mode_switch testcase fails, but I haven't 
> checked why].

I agree with all of this. I'll see why this code is needed (it is needed,
since I once removed it accidentaly on VMX, and it broke nesting with ept=0,
in exact the same way as it was broken on AMD).

I''l debug this a bit to see if I can make it work as you suggest.


Best regards,
	Maxim Levitsky
> 
> 
> Paolo
> 


