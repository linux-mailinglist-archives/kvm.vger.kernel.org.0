Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96D06552FA
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 17:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiLWQ5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 11:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiLWQ5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 11:57:01 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE271D3;
        Fri, 23 Dec 2022 08:56:58 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 62AA51EC0724;
        Fri, 23 Dec 2022 17:56:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1671814616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=eIrwyfehmxU3S8OfAsjHXXxAvKGYqWtRXnlHsmPvMIs=;
        b=sQpLqtBZNyzt9lCkh02Tv1TArmXNvAYkccThgPqKToX+E4uRVMeRWpB6DQOtn0UgGq7QfH
        xnfQYy4dQI8JTVvBFgPDRc1+UI8QVqekXcGosVLwwJkrENFYZi9w4fEUexsMn6EYHGTJQO
        Vhfz7bb9sk0ICgmVHhqqvOh8tEjrjhY=
Date:   Fri, 23 Dec 2022 17:56:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Message-ID: <Y6Xd0ruz3kMij/5F@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-4-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-4-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:39:55PM -0600, Michael Roth wrote:
> +       bool (*private_mem_enabled)(struct kvm *kvm);

This looks like a function returning boolean to me. IOW, you can
simplify this to:

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 82ba4a564e58..4449aeff0dff 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -129,6 +129,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1da0474edb2d..1b4b89ddeb55 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1574,6 +1574,7 @@ struct kvm_x86_ops {
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
+	bool (*private_mem_enabled)(struct kvm *kvm);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce362e88a567..73b780fa4653 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4680,6 +4680,14 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static bool svm_private_mem_enabled(struct kvm *kvm)
+{
+	if (sev_guest(kvm))
+		return kvm->arch.upm_mode;
+
+	return IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING);
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
 
@@ -4760,6 +4768,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
 
+	.private_mem_enabled = svm_private_mem_enabled,
+
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
 	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 823646d601db..9a1ca59d36a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12556,6 +12556,11 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(__x86_set_memory_region);
 
+bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return static_call(kvm_x86_private_mem_enabled)(kvm);
+}
+
 void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 {
 	kvm_mmu_pre_destroy_vm(kvm);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
