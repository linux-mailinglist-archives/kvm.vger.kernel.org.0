Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807EA355A03
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 19:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346769AbhDFRJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 13:09:13 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45674 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346779AbhDFRJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 13:09:09 -0400
Received: from zn.tnic (p200300ec2f0a0d00e4e63576b95994ce.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:d00:e4e6:3576:b959:94ce])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F13B71EC013E;
        Tue,  6 Apr 2021 19:08:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617728940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=X/4il9+u5NGx6e8joEGNncq67rj1sofT2TPhRQbDZwU=;
        b=AaUvkI0XbqUzMXBrdhT5EaG9z/qWVZ9lPo8sMa5BEmBRwAetBFc+iSrSEqK+y2RCLxa5dr
        Db3PR7DPTGuB1yboTXPhaZoEoHIcdZ+le0Jcpj79fT+JAwF3zV34soN7lDqJGSh5GrEJqo
        3bGbbqi0IlB7it3ISDdXxLHP7EuS6ng=
Date:   Tue, 6 Apr 2021 19:08:58 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <20210406170858.GN17806@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
 <20210405090759.GB19485@zn.tnic>
 <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
 <20210406073917.GA17806@zn.tnic>
 <20210406205958.084147e365d04d066e4357c1@intel.com>
 <20210406090901.GH17806@zn.tnic>
 <20210406212424.86d6d4533b144d4621ecb385@intel.com>
 <20210406093211.GI17806@zn.tnic>
 <20210406214152.8c4d40679bd6a5e9b632637f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210406214152.8c4d40679bd6a5e9b632637f@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 09:41:52PM +1200, Kai Huang wrote:
> > Ok, I'll make the changes and you can redo the KVM rest ontop.
> > 
> 
> Thank you!

I.e., something like this:

---
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Fri, 19 Mar 2021 20:23:08 +1300
Subject: [PATCH] x86/sgx: Add helpers to expose ECREATE and EINIT to KVM

The host kernel must intercept ECREATE to impose policies on guests, and
intercept EINIT to be able to write guest's virtual SGX_LEPUBKEYHASH MSR
values to hardware before running guest's EINIT so it can run correctly
according to hardware behavior.

Provide wrappers around __ecreate() and __einit() to hide the ugliness
of overloading the ENCLS return value to encode multiple error formats
in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
of SGX virtualization, and reflect ENCLS execution result to guest by
setting up guest's GPRs, or on an exception, injecting the correct fault
based on return value of __ecreate() and __einit().

Use host userspace addresses (provided by KVM based on guest physical
address of ENCLS parameters) to execute ENCLS/EINIT when possible.
Accesses to both EPC and memory originating from ENCLS are subject to
segmentation and paging mechanisms.  It's also possible to generate
kernel mappings for ENCLS parameters by resolving PFN but using
__uaccess_xx() is simpler.

 [ bp: Return early if the __user memory accesses fail. ]

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lkml.kernel.org/r/20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com
---
 arch/x86/include/asm/sgx.h     |   7 ++
 arch/x86/kernel/cpu/sgx/virt.c | 117 +++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 3b025afec0a7..954042e04102 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -365,4 +365,11 @@ struct sgx_sigstruct {
  * comment!
  */
 
+#ifdef CONFIG_X86_SGX_KVM
+int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
+		     int *trapnr);
+int sgx_virt_einit(void __user *sigstruct, void __user *token,
+		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
+#endif
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 259cc46ad78c..7d221eac716a 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -257,3 +257,120 @@ int __init sgx_vepc_init(void)
 
 	return misc_register(&sgx_vepc_dev);
 }
+
+/**
+ * sgx_virt_ecreate() - Run ECREATE on behalf of guest
+ * @pageinfo:	Pointer to PAGEINFO structure
+ * @secs:	Userspace pointer to SECS page
+ * @trapnr:	trap number injected to guest in case of ECREATE error
+ *
+ * Run ECREATE on behalf of guest after KVM traps ECREATE for the purpose
+ * of enforcing policies of guest's enclaves, and return the trap number
+ * which should be injected to guest in case of any ECREATE error.
+ *
+ * Return:
+ * -  0:	ECREATE was successful.
+ * - <0:	on error.
+ */
+int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
+		     int *trapnr)
+{
+	int ret;
+
+	/*
+	 * @secs is an untrusted, userspace-provided address.  It comes from
+	 * KVM and is assumed to be a valid pointer which points somewhere in
+	 * userspace.  This can fault and call SGX or other fault handlers when
+	 * userspace mapping @secs doesn't exist.
+	 *
+	 * Add a WARN() to make sure @secs is already valid userspace pointer
+	 * from caller (KVM), who should already have handled invalid pointer
+	 * case (for instance, made by malicious guest).  All other checks,
+	 * such as alignment of @secs, are deferred to ENCLS itself.
+	 */
+	if (WARN_ON_ONCE(!access_ok(secs, PAGE_SIZE)))
+		return -EINVAL;
+
+	__uaccess_begin();
+	ret = __ecreate(pageinfo, (void *)secs);
+	__uaccess_end();
+
+	if (encls_faulted(ret)) {
+		*trapnr = ENCLS_TRAPNR(ret);
+		return -EFAULT;
+	}
+
+	/* ECREATE doesn't return an error code, it faults or succeeds. */
+	WARN_ON_ONCE(ret);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sgx_virt_ecreate);
+
+static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
+			    void __user *secs)
+{
+	int ret;
+
+	/*
+	 * Make sure all userspace pointers from caller (KVM) are valid.
+	 * All other checks deferred to ENCLS itself.  Also see comment
+	 * for @secs in sgx_virt_ecreate().
+	 */
+#define SGX_EINITTOKEN_SIZE	304
+	if (WARN_ON_ONCE(!access_ok(sigstruct, sizeof(struct sgx_sigstruct)) ||
+			 !access_ok(token, SGX_EINITTOKEN_SIZE) ||
+			 !access_ok(secs, PAGE_SIZE)))
+		return -EINVAL;
+
+	__uaccess_begin();
+	ret = __einit((void *)sigstruct, (void *)token, (void *)secs);
+	__uaccess_end();
+
+	return ret;
+}
+
+/**
+ * sgx_virt_einit() - Run EINIT on behalf of guest
+ * @sigstruct:		Userspace pointer to SIGSTRUCT structure
+ * @token:		Userspace pointer to EINITTOKEN structure
+ * @secs:		Userspace pointer to SECS page
+ * @lepubkeyhash:	Pointer to guest's *virtual* SGX_LEPUBKEYHASH MSR values
+ * @trapnr:		trap number injected to guest in case of EINIT error
+ *
+ * Run EINIT on behalf of guest after KVM traps EINIT. If SGX_LC is available
+ * in host, SGX driver may rewrite the hardware values at wish, therefore KVM
+ * needs to update hardware values to guest's virtual MSR values in order to
+ * ensure EINIT is executed with expected hardware values.
+ *
+ * Return:
+ * -  0:	EINIT was successful.
+ * - <0:	on error.
+ */
+int sgx_virt_einit(void __user *sigstruct, void __user *token,
+		   void __user *secs, u64 *lepubkeyhash, int *trapnr)
+{
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC)) {
+		ret = __sgx_virt_einit(sigstruct, token, secs);
+	} else {
+		preempt_disable();
+
+		sgx_update_lepubkeyhash(lepubkeyhash);
+
+		ret = __sgx_virt_einit(sigstruct, token, secs);
+		preempt_enable();
+	}
+
+	/* Propagate up the error from the WARN_ON_ONCE in __sgx_virt_einit() */
+	if (ret == -EINVAL)
+		return ret;
+
+	if (encls_faulted(ret)) {
+		*trapnr = ENCLS_TRAPNR(ret);
+		return -EFAULT;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sgx_virt_einit);
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
