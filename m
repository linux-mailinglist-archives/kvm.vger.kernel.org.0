Return-Path: <kvm+bounces-32280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5169D5107
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 17:56:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B80B284B5E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 16:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6B11AA783;
	Thu, 21 Nov 2024 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hmBbTUNw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E01A01DD
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 16:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732208165; cv=none; b=HGL5YzopPEazL5s10JLxCKa7w5lVtujAEjaiLmwbm+7AFtaFfM4cvOVgV/2an9lehm1piey/fMlLLJv4Tt1HjcXm6QS+/WsuFbRmdSjKj9mANAuEWVBnNHASCby4r6UvY030gu7O4zqLp+RDfKMrYUNBX+6mHIx0i2FkEdgfhBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732208165; c=relaxed/simple;
	bh=qmonLSoIS8Q9OhyvMAgmPPLJTYtpZ8xKEyMv/uvwuEs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iqy9duZqlPAjpxe5Sm/Nk7OS3z/zjbKUMDq0A5Y6Acrt0jMv2055SoFuWjwPVQtIoiMn6FTkl0OfvctyBE0S91eafyRXxOJYyRixLWq7XiHHpYgBJbmWAQDSMJGzw0xNi7/tSr2vGQfnL5J9gguAHZAVvQF2MoNqbjndP7A0zAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hmBbTUNw; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fbb11b2741so1219974a12.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 08:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732208162; x=1732812962; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xCdmDeIAVGCNJqlBrou3ftDi64ooRpwqgbbNhTS8NEw=;
        b=hmBbTUNwBz/gvopudBenZY/k0iSkfjrSEdEsntdn1elhjCYMRhgl2dsLV1r0r2yNw2
         YUh/gPvjv6DM4MbvRRRI9WQCY08DYqdgFwbHOWR5QARqbFHZOHEd546ajNlrnLiT9Y66
         1bhV1Fz2MRhToHSc0M2VWoNZJrMvB0bM4gb1K1J1y8nKcuEsRkFd23WUBqJezlM433oz
         VVR4PBirOOmhQnAg6KjOdeE97UADRWhSf8XDUb6xdSngY7z9waSNxpdOcAThTqa2xwcP
         RSA08cO9ffsVurgSh7NENRguknwmGXHTmnUnz370UkDN5UWzu7Gd6D4B5TtooK7lUd1c
         6NpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732208162; x=1732812962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xCdmDeIAVGCNJqlBrou3ftDi64ooRpwqgbbNhTS8NEw=;
        b=vpus12Q6Lb05AdjL6roev6FGpz7kQlvlMkDOhoHVzDsSKjFeOVfV249mZskibk+n1a
         Mu+mKUFjdgg4oE3tdgxvZurak/VL2QuQG+mPau1CMfUWgKHukvWzDFGDMPmhgnxLqM/g
         OKNl5cCXWWbSZllSYi0CnwsfYnApZCHO8ikFiL8czzjCLEJyCoeyD6Yktx11YGGlKsFU
         l/sO32fBIudSXZaGgenyOZ0XZNtI9ho6ChgW9hAuEF3YxcvxDTocn7ugB8MGVC2b5Ooo
         ui695XbM44gQuC+mPH0dqD4b1pAaoEiOdsxpdle2vHMHGijq0wSQXs8IJTY1oDUF+UAo
         xakQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGIIugSGFmsU6+Z5ojiPnYNeiBzLuYDL2EKy+R33koGgMEjRzBJHkqLjB9TTPgAFOKJHk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwcXK117Rs9FiSt3LwuiBDw0V5x5O4gHDOC9e/3OWTqXN75PCO
	csZriziusCyjo00jS7wqZGsglyVrHKGFNlcYrgKDx4R1NQmu37PT7L89+qbADDhJ5qj+SWCYDyh
	CAg==
X-Google-Smtp-Source: AGHT+IFqEsligkGchTJZhybD3Y0vv5VNcJq7bQyFJvUo4pq53y15aqidl0xciPVfBBvJOVGUC2XRSozGo9A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:ec0c:0:b0:7ea:e735:3bec with SMTP id
 41be03b00d2f7-7fba7d39c32mr4294a12.7.1732208162150; Thu, 21 Nov 2024 08:56:02
 -0800 (PST)
Date: Thu, 21 Nov 2024 08:56:00 -0800
In-Reply-To: <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726602374.git.ashish.kalra@amd.com> <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
 <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com> <ZwlMojz-z0gBxJfQ@google.com>
 <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com> <Zz5aZlDbKBr6oTMY@google.com>
 <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com> <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com>
Message-ID: <Zz9mIBdNpJUFpkXv@google.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com, 
	davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 21, 2024, Ashish Kalra wrote:
> On 11/20/2024 5:43 PM, Kalra, Ashish wrote:
> > 
> > On 11/20/2024 3:53 PM, Sean Christopherson wrote:
> >> On Tue, Nov 19, 2024, Ashish Kalra wrote:
> >>> On 10/11/2024 11:04 AM, Sean Christopherson wrote:
> >>>> On Wed, Oct 02, 2024, Ashish Kalra wrote:
> >>>>> Yes, but there is going to be a separate set of patches to move all ASID
> >>>>> handling code to CCP module.
> >>>>>
> >>>>> This refactoring won't be part of the SNP ciphertext hiding support patches.
> >>>>
> >>>> It should, because that's not a "refactoring", that's a change of roles and
> >>>> responsibilities.  And this series does the same; even worse, this series leaves
> >>>> things in a half-baked state, where the CCP and KVM have a weird shared ownership
> >>>> of ASID management.
> >>>
> >>> Sorry for the delayed reply to your response, the SNP DOWNLOAD_FIRMWARE_EX
> >>> patches got posted in the meanwhile and that had additional considerations of
> >>> moving SNP GCTX pages stuff into the PSP driver from KVM and that again got
> >>> into this discussion about splitting ASID management across KVM and PSP
> >>> driver and as you pointed out on those patches that there is zero reason that
> >>> the PSP driver needs to care about ASIDs. 
> >>>
> >>> Well, CipherText Hiding (CTH) support is one reason where the PSP driver gets
> >>> involved with ASIDs as CTH feature has to be enabled as part of SNP_INIT_EX
> >>> and once CTH feature is enabled, the SEV-ES ASID space is split across
> >>> SEV-SNP and SEV-ES VMs. 
> >>
> >> Right, but that's just a case where KVM needs to react to the setup done by the
> >> PSP, correct?  E.g. it's similar to SEV-ES being enabled/disabled in firmware,
> >> only that "firmware" happens to be a kernel driver.
> > 
> > Yes that is true.
> > 
> >>
> >>> With reference to SNP GCTX pages, we are looking at some possibilities to
> >>> push the requirement to update SNP GCTX pages to SNP firmware and remove that
> >>> requirement from the kernel/KVM side.
> >>
> >> Heh, that'd work too.
> >>
> >>> Considering that, I will still like to keep ASID management in KVM, there are
> >>> issues with locking, for example, sev_deactivate_lock is used to protect SNP
> >>> ASID allocations (or actually for protecting ASID reuse/lazy-allocation
> >>> requiring WBINVD/DF_FLUSH) and guarding this DF_FLUSH from VM destruction
> >>> (DEACTIVATE). Moving ASID management stuff into PSP driver will then add
> >>> complexity of adding this synchronization between different kernel modules or
> >>> handling locking in two different kernel modules, to guard ASID allocation in
> >>> PSP driver with VM destruction in KVM module.
> >>>
> >>> There is also this sev_vmcbs[] array indexed by ASID (part of svm_cpu_data)
> >>> which gets referenced during the ASID free code path in KVM. It just makes it
> >>> simpler to keep ASID management stuff in KVM. 
> >>>
> >>> So probably we can add an API interface exported by the PSP driver something
> >>> like is_sev_ciphertext_hiding_enabled() or sev_override_max_snp_asid()
> >>
> >> What about adding a cc_attr_flags entry?
> > 
> > Yes, that is a possibility i will look into. 
> > 
> > But, along with an additional cc_attr_flags entry, max_snp_asid (which is a
> > PSP driver module parameter) also needs to be propagated to KVM, that's
> > what i was considering passing as parameter to the above API interface.

Doh, right, I managed to forget about those module params.

> Adding a new cc_attr_flags entry indicating CTH support is enabled.
> 
> And as discussed with Boris, using the cc_platform_set() to add a new attr
> like max_asid and adding a getter interface on top to return the
> max_snp_asid.

Actually, IMO, the behavior of _sev_platform_init_locked() and pretty much all of
the APIs that invoke it are flawed, and make all of this way more confusing and
convoluted than it needs to be.

IIUC, SNP initialization is forced during probe purely because SNP can't be
initialized if VMs are running.  But the only in-tree user of SEV-XXX functionality
is KVM, and KVM depends on whatever this driver is called.  So forcing SNP
initialization because a hypervisor could be running legacy VMs make no sense.
Just require KVM to initialize SEV functionality if KVM wants to use SEV+.

	/*
	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
	 * so perform SEV-SNP initialization at probe time.
	 */
	rc = __sev_snp_init_locked(&args->error); 

Rather than automatically init SEV+ functionality, can we instead do something
like the (half-baked pseudo-patch) below?  I.e. delete all paths that implicitly
init the PSP, and force KVM to explicitly initialize the PSP if KVM wants to use
SEV+.  Then we can put the CipherText and SNP ASID params in KVM.

That would also allow (a) registering the SNP panic notifier if and only if SNP
is actually initailized and (b) shutting down SEV+ in the PSP when KVM is unloaded.
Arguably, the PSP should be shutdown when KVM is unloaded, irrespective of the
CipherText and SNP ASID knobs.  But with those knobs, it becomes even more desirable,
because it would allow userspace to reload *KVM* in order to change the CipherText
and SNP ASID module params.  I.e. doesn't require unloading the entire CCP driver.

If dropping the implicit initialization in some of the ioctls would break existing
userspace, then maybe we could add a module param (or Kconfig?) to preserve that
behavior?  I'm not familiar with what actually uses /dev/sev.

Side topic #1, sev_pci_init() is buggy.  It should destroy SEV if getting the
API version fails after a firmware update.

Side topic #2, the version check is broken, as it returns "success" when
initialization quite obviously failed.

	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
		return 0;
	}

---
 drivers/crypto/ccp/sev-dev.c | 102 +++++++++--------------------------
 include/linux/psp-sev.h      |  19 ++-----
 2 files changed, 28 insertions(+), 93 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index af018afd9cd7..563cc235b095 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -69,10 +69,6 @@ static char *init_ex_path;
 module_param(init_ex_path, charp, 0444);
 MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
 
-static bool psp_init_on_probe = true;
-module_param(psp_init_on_probe, bool, 0444);
-MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
-
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
@@ -1306,11 +1302,13 @@ static int __sev_platform_init_locked(int *error)
 	return 0;
 }
 
-static int _sev_platform_init_locked(struct sev_platform_init_args *args)
+int sev_platform_init(int *error)
 {
 	struct sev_device *sev;
 	int rc;
 
+	guard(mutex)(&sev_cmd_mutex)
+
 	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;
 
@@ -1319,36 +1317,17 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	/*
-	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
-	 * so perform SEV-SNP initialization at probe time.
-	 */
-	rc = __sev_snp_init_locked(&args->error);
+	rc = __sev_snp_init_locked(error);
 	if (rc && rc != -ENODEV) {
 		/*
 		 * Don't abort the probe if SNP INIT failed,
 		 * continue to initialize the legacy SEV firmware.
 		 */
 		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
-			rc, args->error);
+			rc, *error);
 	}
 
-	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
-	if (args->probe && !psp_init_on_probe)
-		return 0;
-
-	return __sev_platform_init_locked(&args->error);
-}
-
-int sev_platform_init(struct sev_platform_init_args *args)
-{
-	int rc;
-
-	mutex_lock(&sev_cmd_mutex);
-	rc = _sev_platform_init_locked(args);
-	mutex_unlock(&sev_cmd_mutex);
-
-	return rc;
+	return __sev_platform_init_locked(error);
 }
 EXPORT_SYMBOL_GPL(sev_platform_init);
 
@@ -1441,16 +1420,12 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	int rc;
 
 	if (!writable)
 		return -EPERM;
 
-	if (sev->state == SEV_STATE_UNINIT) {
-		rc = __sev_platform_init_locked(&argp->error);
-		if (rc)
-			return rc;
-	}
+	if (sev->state == SEV_STATE_UNINIT)
+		return -ENOTTY;
 
 	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
 }
@@ -1467,6 +1442,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
+	if (sev->state == SEV_STATE_UNINIT)
+		return -ENOTTY;
+
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
@@ -1489,12 +1467,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	data.len = input.length;
 
 cmd:
-	if (sev->state == SEV_STATE_UNINIT) {
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			goto e_free_blob;
-	}
-
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
 	 /* If we query the CSR length, FW responded with expected data. */
@@ -1584,7 +1556,6 @@ static int sev_get_firmware(struct device *dev,
 	return -ENOENT;
 }
 
-/* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW */
 static int sev_update_firmware(struct device *dev)
 {
 	struct sev_data_download_firmware *data;
@@ -1732,6 +1703,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
+	if (sev->state == SEV_STATE_UNINIT)
+		return -ENOTTY;
+
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
@@ -1754,16 +1728,8 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	data.oca_cert_address = __psp_pa(oca_blob);
 	data.oca_cert_len = input.oca_cert_len;
 
-	/* If platform is not in INIT state then transition it to INIT */
-	if (sev->state != SEV_STATE_INIT) {
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			goto e_free_oca;
-	}
-
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
-e_free_oca:
 	kfree(oca_blob);
 e_free_pek:
 	kfree(pek_blob);
@@ -1882,15 +1848,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	void __user *input_pdh_cert_address;
 	int ret;
 
-	/* If platform is not in INIT state then transition it to INIT. */
-	if (sev->state != SEV_STATE_INIT) {
-		if (!writable)
-			return -EPERM;
-
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			return ret;
-	}
+	if (sev->state != SEV_STATE_INIT)
+		return -ENOTTY;
 
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
@@ -2296,6 +2255,9 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 {
 	int error;
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
+
 	__sev_platform_shutdown_locked(NULL);
 
 	if (sev_es_tmr) {
@@ -2390,9 +2352,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_platform_init_args args = {0};
 	u8 api_major, api_minor, build;
-	int rc;
 
 	if (!sev)
 		return;
@@ -2406,27 +2366,18 @@ void sev_pci_init(void)
 	api_minor = sev->api_minor;
 	build     = sev->build;
 
-	if (sev_update_firmware(sev->dev) == 0)
-		sev_get_api_version();
+	/* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW. */
+	if (sev_update_firmware(sev->dev))
+		return;
+
+	if (sev_get_api_version())
+		goto err;
 
 	if (api_major != sev->api_major || api_minor != sev->api_minor ||
 	    build != sev->build)
 		dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
-
-	/* Initialize the platform */
-	args.probe = true;
-	rc = sev_platform_init(&args);
-	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			args.error, rc);
-
-	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
-		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
-
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2443,7 +2394,4 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
-
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..def40f7ea01d 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -790,19 +790,6 @@ struct sev_data_snp_shutdown_ex {
 	u32 rsvd1:31;
 } __packed;
 
-/**
- * struct sev_platform_init_args
- *
- * @error: SEV firmware error code
- * @probe: True if this is being called as part of CCP module probe, which
- *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
- *  unless psp_init_on_probe module param is set
- */
-struct sev_platform_init_args {
-	int error;
-	bool probe;
-};
-
 /**
  * struct sev_data_snp_commit - SNP_COMMIT structure
  *
@@ -817,7 +804,7 @@ struct sev_data_snp_commit {
 /**
  * sev_platform_init - perform SEV INIT command
  *
- * @args: struct sev_platform_init_args to pass in arguments
+ * @error: SEV firmware error code
  *
  * Returns:
  * 0 if the SEV successfully processed the command
@@ -826,7 +813,7 @@ struct sev_data_snp_commit {
  * -%ETIMEDOUT if the SEV command timed out
  * -%EIO       if the SEV returned a non-zero return code
  */
-int sev_platform_init(struct sev_platform_init_args *args);
+int sev_platform_init(int *error);
 
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
@@ -951,7 +938,7 @@ void snp_free_firmware_page(void *addr);
 static inline int
 sev_platform_status(struct sev_user_data_status *status, int *error) { return -ENODEV; }
 
-static inline int sev_platform_init(struct sev_platform_init_args *args) { return -ENODEV; }
+static inline int sev_platform_init(int *error) { return -ENODEV; }
 
 static inline int
 sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }

base-commit: 43fb83c17ba2d63dfb798f0be7453ed55ca3f9c2
-- 


