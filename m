Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9124CC613
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiCCTjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbiCCTjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:12 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9D449F15
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:38:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso5470970pjq.1
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 11:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=M9gCpDsUpLGqQcUkdGHYkjRzuoDu54KLsE+14sxkm3c=;
        b=RvBfaAqZtgNzfep6vsHoWlPFtU7qMWhDRPJJk35YQu1rluHwIC/xz6ez3wKGG6PC0A
         8sm9grasluAZncFRknNM7jwjd0z3mdD6BzdQccr4tgt+ZCpCdhkGZw7deQsW/RecZkjv
         73HGm7fc9c+EO42e071G6qD6/JASyVDkWa624RsLekL+0u06uOXqDQYxefF/hv1I+4BC
         Fs9s6suRG3RJSYTBZHHj5vrCJvSZgmWqhitnaiGmTOHRtbmL2xCIhLQSj68yNkl46pP8
         hCsDhMIstFRh0hz6fHAS9pAtnBtajLOf/v44yepvJARYbt+wX3nlAgd6Ja0ReT0ngfmv
         +2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=M9gCpDsUpLGqQcUkdGHYkjRzuoDu54KLsE+14sxkm3c=;
        b=ijnruFe+J1Jgl1derB3IrkD278aWiu9uTjTn2TdGUpemPoinXxKBA8PHiKc2ZXPWJT
         QEfF2DqLnww6/nfJZUdFMEqw/Kq/HrSbcLl5gKYbMxDdbrJt+CoafhOf9t7+z2quHgUF
         KVh0RNK2231W6LBDhzfJAq6f2od6PC8/5biy6QnfLcd8ybynEz4Bn2YK7I8HemS/I2FG
         aRVXclhEBanpYGr273Cy3RJhK9ezerVyKQxLKRbw3xXQAFiBp6M5YUwHY0Z9PZFHMd0+
         CK591ideTzTGdsk+dtQZJCTUtU+syNCoM9tPq10494OdVL6uS143gOgTyeg8fCJ/t1qV
         MDBg==
X-Gm-Message-State: AOAM5300YX/UsAD61OmHCnv+Wqp+g7o+eMh5Ky8W2ioFKLysHlxmOY+X
        QpLhLlLEE16RSHBgat4j1qIK6PAfILEDzA==
X-Google-Smtp-Source: ABdhPJzYw5BOAQJxGoynOgUYpzsVApgErc8BTD7uxvGNhfW+ShvWmc6fU3tS42tm/T8H5lK/StVxCg==
X-Received: by 2002:a17:90b:1a81:b0:1bc:ec26:40a6 with SMTP id ng1-20020a17090b1a8100b001bcec2640a6mr7024774pjb.0.1646336305747;
        Thu, 03 Mar 2022 11:38:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090acd0500b001b9c05b075dsm8750694pju.44.2022.03.03.11.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 11:38:25 -0800 (PST)
Date:   Thu, 3 Mar 2022 19:38:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Subject: Re: [PATCH 4/4] KVM: x86: lapic: don't allow to set non default apic
 id when not using x2apic api
Message-ID: <YiEZJ6tg0+I+MdW5@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-5-mlevitsk@redhat.com>
 <Yh5QJ4dJm63fC42n@google.com>
 <6f4819b4169bd4e2ca9ab710388ebd44b7918eed.camel@redhat.com>
 <Yh5b3eBYK/rGzFfj@google.com>
 <297c8e41f512587230a54130a71ddfd9004c9507.camel@redhat.com>
 <eae0b69fb8f5c47457fac853cc55b41a30762994.camel@redhat.com>
 <YiDx/uYAMSZDvobO@google.com>
 <df1ed2b01c74310bd4918196ba632e906e4c78f1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df1ed2b01c74310bd4918196ba632e906e4c78f1.camel@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Maxim Levitsky wrote:
> On Thu, 2022-03-03 at 16:51 +0000, Sean Christopherson wrote:
> > On Wed, Mar 02, 2022, Maxim Levitsky wrote:
> > > When APIC state is loading while APIC is in *x2apic* mode it does enforce that
> > > value in this 0x20 offset is initial apic id if KVM_CAP_X2APIC_API.
> > >  
> > > I think that it is fair to also enforce this when KVM_CAP_X2APIC_API is not used,
> > > especially if we make apic id read-only.
> > 
> > I don't disagree in principle.  But, (a) this loophole as existing for nearly 6
> > years, (b) closing the loophole could break userspace, (c) false positive are
> > possible due to truncation, and (d) KVM gains nothing meaningful by closing the
> > loophole.
> > 
> > (d) changes when we add a knob to make xAPIC ID read-only, but we can simply
> > require userspace to enable KVM_CAP_X2APIC_API (or force it).  That approach
> > avoids (c) by eliminating truncation, and avoids (b) by virtue of being opt-in.
> > 
> 
> (a) - doesn't matter.

Yes, it absolutely matters.  If KVM_CAP_X2APIC_API was added in the 5.17 cycle
then I would not be objecting because there is zero chance of breaking userspace.

> (b) - if userspace wants to have non default apic id with x2apic mode,
>       which (*)can't even really be set from the guest - this is ridiculous.
>  
>       (*) Yes I know that in *theory* user can change apic id in xapic mode
>       and then switch to x2apic mode - but I really doubt that KVM
>       would even honor this - there are already places which assume
>       that this is not the case. In fact it would be nice to audit KVM
>       on what happens when userspace does this, there might be a nice
>       CVE somewhere....
>  
> (c) - without KVM_CAP_X2APIC_API, literally just call to KVM_GET_LAPIC/KVM_SET_LAPIC
> will truncate x2apic id if > 255 regardless of my patch - literally this cap
> was added to avoid this.
> What we should do is to avoid creating cpu with vcpu_id > 256 when this cap is not set…

Yes, but _rejecting_ that behavior is a change in KVM's ABI.  That's why (a) matters.

> (d) - doesn't matter - again we are talking about x2apic mode in which apic id is read only.

It does matter that changes that potentially break userspace provide value to KVM.
Not theoretical, make us feel warm and fuzzy value, but actual value to KVM or
userspace.  KVM is no worse off for this loophole.  For userspace, at best this
will break a flawed but functional setup.

Concretely, the below example of using x2APIC with an ID > 255 works because KVM
calculates its APIC maps using what KVM thinks is the x2APIC ID. 

With your proposed change, KVM_SET_LAPIC will fail and we've broken a functional,
if sketchy, setup.  Is there likely to be such a real-world setup that doesn't
barf on the inconsistent x2APIC ID?  Probably not, but I don't see any reason to
find out.

==== Test Assertion Failure ====
  lib/kvm_util.c:1953: ret == 0
  pid=837 tid=837 errno=22 - Invalid argument
     1	0x0000000000403c0e: vcpu_ioctl at kvm_util.c:1952
     2	0x0000000000401548: main at smm_test.c:151
     3	0x00007ff76518ebf6: ?? ??:0
     4	0x0000000000401829: _start at ??:?
  vcpu ioctl 1140895375 failed, rc: -1 errno: 22 (Invalid argument)


diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index a626d40fdb48..cce44d99c919 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -19,7 +19,7 @@
 #include "vmx.h"
 #include "svm_util.h"

-#define VCPU_ID              1
+#define VCPU_ID              256

 #define PAGE_SIZE  4096

@@ -56,7 +56,7 @@ static inline void sync_with_host(uint64_t phase)
 static void self_smi(void)
 {
        x2apic_write_reg(APIC_ICR,
-                        APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
+                        ((uint64_t)VCPU_ID << 32) | APIC_INT_ASSERT | APIC_DM_SMI);
 }

 static void l2_guest_code(void)
@@ -72,14 +72,10 @@ static void guest_code(void *arg)
 {
        #define L2_GUEST_STACK_SIZE 64
        unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
-       uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
        struct svm_test_data *svm = arg;
        struct vmx_pages *vmx_pages = arg;

        sync_with_host(1);
-
-       wrmsr(MSR_IA32_APICBASE, apicbase | X2APIC_ENABLE);
-
        sync_with_host(2);

        self_smi();
@@ -139,12 +135,21 @@ int main(int argc, char *argv[])
        struct kvm_run *run;
        struct kvm_x86_state *state;
        int stage, stage_reported;
+       struct kvm_lapic_state lapic;

        /* Create VM */
        vm = vm_create_default(VCPU_ID, 0, guest_code);

        run = vcpu_state(vm, VCPU_ID);

+       vcpu_set_msr(vm, VCPU_ID, MSR_IA32_APICBASE,
+                    vcpu_get_msr(vm, VCPU_ID, MSR_IA32_APICBASE) | X2APIC_ENABLE);
+
+       vcpu_ioctl(vm, VCPU_ID, KVM_GET_LAPIC, &lapic);
+       TEST_ASSERT(*((u32 *)&lapic.regs[0x20]) == 0,
+                   "x2APIC ID == %u", *((u32 *)&lapic.regs[0x20]));
+       vcpu_ioctl(vm, VCPU_ID, KVM_SET_LAPIC, &lapic);
+
        vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SMRAM_GPA,
                                    SMRAM_MEMSLOT, SMRAM_PAGES, 0);
        TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, SMRAM_GPA, SMRAM_MEMSLOT)
