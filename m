Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D346D271E70
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 10:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIUI5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 04:57:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgIUI5i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 04:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600678656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtDGrtlEykQ6KPjGLzoVNEGTLi0Wn2lMDIF84aVaKUY=;
        b=WAawBeRFjLfRsbEZ/N70nce8rafjibNTvK1YN9IGb++llZw7DNsD+/ncyLsUatnbnjBkeD
        YSXXrLhGPl0dW9L2U3Xnhw3dbmVXvRH/NVIFy9e5KTiOqtZOFXEDUfo5aphTs0Q9ue1AN3
        8Smgd5mRTNsW08z8P4u6U6Y0zfXkNNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-XYppMNu8OM6FHcbYzkTZzg-1; Mon, 21 Sep 2020 04:57:34 -0400
X-MC-Unique: XYppMNu8OM6FHcbYzkTZzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50567802B6B;
        Mon, 21 Sep 2020 08:57:32 +0000 (UTC)
Received: from starship (unknown [10.35.206.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68D9B61177;
        Mon, 21 Sep 2020 08:57:28 +0000 (UTC)
Message-ID: <2b6a4042a0a75cbc5e00b32752afa9965abd697d.camel@redhat.com>
Subject: Re: [PATCH v4 2/2] KVM: nSVM: implement ondemand allocation of the
 nested state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date:   Mon, 21 Sep 2020 11:57:27 +0300
In-Reply-To: <5a3538861a65973f9ae6e2d0798ac17f52428ded.camel@redhat.com>
References: <20200917101048.739691-1-mlevitsk@redhat.com>
         <20200917101048.739691-3-mlevitsk@redhat.com>
         <20200917162942.GE13522@sjchrist-ice>
         <d9c0d190-c6ea-2e21-92ca-2a53efb86a1d@redhat.com>
         <20200920161602.GA17325@linux.intel.com>
         <c35cbaca-2c34-cd93-b589-d4ab782fc754@redhat.com>
         <5a3538861a65973f9ae6e2d0798ac17f52428ded.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-21 at 10:53 +0300, Maxim Levitsky wrote:
> On Sun, 2020-09-20 at 18:42 +0200, Paolo Bonzini wrote:
> > On 20/09/20 18:16, Sean Christopherson wrote:
> > > > Maxim, your previous version was adding some error handling to
> > > > kvm_x86_ops.set_efer.  I don't remember what was the issue; did you have
> > > > any problems propagating all the errors up to KVM_SET_SREGS (easy),
> > > > kvm_set_msr (harder) etc.?
> > > I objected to letting .set_efer() return a fault.
> > 
> > So did I, and that's why we get KVM_REQ_OUT_OF_MEMORY.  But it was more
> > of an "it's ugly and it ought not to fail" thing than something I could
> > pinpoint.
> > 
> > It looks like we agree, but still we have to choose the lesser evil?
> > 
> > Paolo
> > 
> > > A relatively minor issue is
> > > the code in vmx_set_efer() that handles lack of EFER because technically KVM
> > > can emulate EFER.SCE+SYSCALL without supporting EFER in hardware.  Returning
> > > success/'0' would avoid that particular issue.  My primary concern is that I'd
> > > prefer not to add another case where KVM can potentially ignore a fault
> > > indicated by a helper, a la vmx_set_cr4().
> 
> The thing is that kvm_emulate_wrmsr injects #GP when kvm_set_msr returns any non zero value,
> and returns 1 which means keep on going if I understand correctly (0 is userspace exit,
> negative value would be a return to userspace with an error)
> 
> So the question is if we have other wrmsr handlers which return negative value, and would
> be affected by changing kvm_emulate_wrmsr to pass through the error value.
> I am checking the code now.
> 
> I do agree now that this is the *correct* solution to this problem.
> 
> Best regards,
> 	Maxim Levitsky


So those are results of my analysis:

WRMSR called functions that return negative value (I could have missed something,
but I double checked the wrmsr code in both SVM and VMX, and in the common x86 code):

vmx_set_vmx_msr - this is only called from userspace (msr_info->host_initiated == true),
so this can be left as is

xen_hvm_config - this code should probably return 1 in some cases, but in one case,
it legit does memory allocation like I do, and failure should probably kill the guest
as well (but I can keep it as is if we are afraid that new behavier will not be
backward compatible)

What do you think about this (only compile tested since I don't have any xen setups):

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 36e963dc1da61..66a57c5b14dfd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2695,24 +2695,19 @@ static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
        u32 page_num = data & ~PAGE_MASK;
        u64 page_addr = data & PAGE_MASK;
        u8 *page;
-       int r;
 
-       r = -E2BIG;
        if (page_num >= blob_size)
-               goto out;
-       r = -ENOMEM;
+               return 1;
+
        page = memdup_user(blob_addr + (page_num * PAGE_SIZE), PAGE_SIZE);
-       if (IS_ERR(page)) {
-               r = PTR_ERR(page);
-               goto out;
+       if (IS_ERR(page))
+               return PTR_ERR(page);
+
+       if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
+               kfree(page);
+               return 1;
        }
-       if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE))
-               goto out_free;
-       r = 0;
-out_free:
-       kfree(page);
-out:
-       return r;
+       return 0;
 }


The msr write itself can be reached from the guest through two functions,
from kvm_emulate_wrmsr which is called in wrmsr interception from both VMX and SVM,
and from em_wrmsr which is called in unlikely case the emulator needs to emulate a wrmsr.

Both should be changed to inject #GP only on positive return value and pass the error
otherwise.

Sounds reasonable? If you agree I'll post the patches implementing this.

Best regards,
	Maxim Levitsky



