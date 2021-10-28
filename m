Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223A143E4FE
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhJ1PZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhJ1PZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 11:25:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF93C061348
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:22:32 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t11so4641944plq.11
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wq2fDK4Y1PYwyFg0KcaMcSGyQtEXNmJj70LIwShSA+Q=;
        b=CZX8flQtIVS05QrpK8YoB5qywUviOPjv2q2uZ4eYLf+8b9f3ZmF23ddtLnEJyiYkpa
         apiZF4s4CJRnLoq8tgZVPWnCXtqReuMEko2ICe02Aj9lKpXGnJSBM2snTQDnxmPjjs18
         nErNOdhiP6p0jHsyCm7eNWqRgcv7HnJPkXYvcAUGjcegiAIN7h/UGFem+7ofSHiaTrCD
         885Sqqon8TODsp4DRZ0YcCyh1KJO0caYUvtUsRdTOGRp8MQNDd/YOM/RHbHBbuoDzSO1
         /RBYfRiXn7f5zXDOF3n4RKU/40f/YzkCitydxImHYpSeo20H4iK79qsytq2Vhca3uAxY
         u9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wq2fDK4Y1PYwyFg0KcaMcSGyQtEXNmJj70LIwShSA+Q=;
        b=w3TBlWnVCrDNYKBo8vYVFA+7plALJxUZz+/j1vbRH8D7JxgWf6I1W8z5oWFEzSpr4S
         mDKck+qRb3PpNlAxZx61IvciRlumNAE/m7wvbGz/hPF0/JlgEJxKcODeO7KleAjDoI+2
         Ep+XAT8ft3l+bi3Bkr7vn4qK+gJsBfHuh0imqm20TiaSOSkZpGFa+DVH2Dj5Cv9Ol+Wa
         Lhdx9NkKkHO1Pd48GM3F9ERacIjzjxYf52QKdNp723+se+KQ3gvglSZa2TjVlSIwO502
         DiM7v9i/DkRTBQGe0+nqXpXMUrfjc+iQrEI2HrSD5n1YiKhRZYmJqDrtj8yeZ4oaBo1I
         f7LA==
X-Gm-Message-State: AOAM53278kze52bDabl+Xtmv+Ub7QZeIeKt3FlvW8FwlhuFEcAI1Dyxd
        jOcOBkJiHYJK6EcnUrtt5yE/yg==
X-Google-Smtp-Source: ABdhPJzMzl5yGCkZYibocwnByVzQKmmQKSZmgPXRr65ajBmCV+xq9SIKT52tvNqaOt+05b5mMNH+mw==
X-Received: by 2002:a17:902:a5c2:b0:140:14bb:8efd with SMTP id t2-20020a170902a5c200b0014014bb8efdmr4572984plq.31.1635434551473;
        Thu, 28 Oct 2021 08:22:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g13sm4229663pfv.20.2021.10.28.08.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 08:22:30 -0700 (PDT)
Date:   Thu, 28 Oct 2021 15:22:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 23/37] KVM: nVMX: Add helper to handle TLB flushes on
 nested VM-Enter/VM-Exit
Message-ID: <YXrAM9MNqgLTU6+m@google.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-24-sean.j.christopherson@intel.com>
 <CAJhGHyD=S6pVB+OxM7zF0_6LnMUCLqyTfMK4x9GZsdRHZmgN7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyD=S6pVB+OxM7zF0_6LnMUCLqyTfMK4x9GZsdRHZmgN7Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-me :-)

On Thu, Oct 28, 2021, Lai Jiangshan wrote:
> On Sat, Mar 21, 2020 at 5:29 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> > +       if (!nested_cpu_has_vpid(vmcs12) || !nested_has_guest_tlb_tag(vcpu)) {
> > +               kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> > +       } else if (is_vmenter &&
> > +                  vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> > +               vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> > +               vpid_sync_context(nested_get_vpid02(vcpu));
> > +       }
> > +}
> 
> (I'm sorry to pick this old email to reply to, but the problem has
> nothing to do with this patch nor 5c614b3583e7 and it exists since
> nested vmx is introduced.)
> 
> I think kvm_mmu_free_guest_mode_roots() should be called
> if (!enable_ept && vmcs12->virtual_processor_id != vmx->nested.last_vpid)
> just because prev_roots doesn't cache the vpid12.
> (prev_roots caches PCID, which is distinctive)
> 
> The problem hardly exists if L1's hypervisor is also kvm, but if L1's
> hypervisor is different or is also kvm with some changes in the way how it
> manages VPID.

Indeed.  A more straightforward error case would be if L1 and L2 share CR3, and
vmcs02.VPID is toggled (or used for the first time) on the L1 => L2 VM-Enter.

The fix should simply be:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index eedcebf58004..574823370e7a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1202,17 +1202,15 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
         *
         * If a TLB flush isn't required due to any of the above, and vpid12 is
         * changing then the new "virtual" VPID (vpid12) will reuse the same
-        * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
-        * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
-        * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
-        * guest-physical mappings, so there is no need to sync the nEPT MMU.
+        * "real" VPID (vpid02), and so needs to be flushed.  Like the !vpid02
+        * case above, this is a full TLB flush from the guest's perspective.
         */
        if (!nested_has_guest_tlb_tag(vcpu)) {
                kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
        } else if (is_vmenter &&
                   vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
                vmx->nested.last_vpid = vmcs12->virtual_processor_id;
-               vpid_sync_context(nested_get_vpid02(vcpu));
+               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
        }
 }
