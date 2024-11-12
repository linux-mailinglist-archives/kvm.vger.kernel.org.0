Return-Path: <kvm+bounces-31687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EE19C65F5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06565B28BF2
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9713121C168;
	Tue, 12 Nov 2024 23:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YP0vFrgg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0846F21E13B
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 23:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453802; cv=none; b=s9uHU4mIK8Bxms5WmMl/EBQ6pwc13PKllGcmUpqSIQTJn5vG0YeRhLQztndl7nOnsO3Od61j/pbM/y8zJYD1EjdUnqioZxJw6MDsMJaLKg4XHV4pl6eYPQGJ6xag7Lpn3r375wyz/j3dBX4h6tGVR0G2pZI0xlIY9fGr1D2T6Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453802; c=relaxed/simple;
	bh=nrQ932Y51OSd35PUGLLbau3Ik/xAjs0b/JpSV31X09E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qhULOHxoO4hbbFNvuiHdWTTOGVY3WOUC/faECXcB9JMnOG1KhhevQy4RMfOlsP70/2X8DPTW7fdrocuuedbNoss2nuvR8acG4wWOb+o8S4Im9OranX0vq4WnQFOW2snXMbO7MQ79+kjKPWO9OPVih9c836c3MurUqAset+pwiQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YP0vFrgg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02fff66a83so9836514276.0
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 15:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731453800; x=1732058600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt+/i8WOI79fmEsLhJLm2DSvIqfPWJS+0C7yUqoIIto=;
        b=YP0vFrgg2SAOHtUbdnkmodfrms4ov+Yd2zQ8Ngou9kTROtOCkOS6zZDf/G0bDbp/yy
         Izb2c3TGG1GqKu5ENaRlI5RRssUCwaRifKckUZPFI5ucxCrn8LqPt9iE4i/y2Jv4Yj3n
         /7T1SFucX1vjrXpGsOPt/+0Kr7WlaEyBUeA23VOsVtoYItLNWSudK00/IUpoDe+TuBR6
         kC6sBtlFb8jS1xIaaG1pt6k0kxs8rDR5lipbBciE8Vp+AhVyPlKJ383MnHJ0InUToTCb
         tu2zQWS8HlARffU2I94s2tvRoWl3u0pKuQNNH7i+vBQ60q0Q5cnTsXlm++us8OpkVA8T
         tOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731453800; x=1732058600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt+/i8WOI79fmEsLhJLm2DSvIqfPWJS+0C7yUqoIIto=;
        b=tL1IrM3V+S1eRv6tVAUumKwSEvmVzwqk+QZ0pcD7DLuy2zs5uYGjSnWoIqhf25meSe
         zQ6PgIDhOG+hnE+s2c+lPKMnMDBhA/4ev6dLxSuL3HWGlpfMvImAP5/8UqFFU7LSadkX
         4VVRdWxH1Y6Y7r6B0Q61fOtT5pZrzt9k6Z2sZUk1FlIaKDpBBpOpBYrWwsPvia05FfMj
         RHZlDE1KASb//yDfZ6fg3zYLbxqYJVh7on3XkY+8vhkwv58JB4uT/xXGvHaVjTBs+CKK
         7/6YeWBWGNTHDZpKazvEKbGwj150MnHCQR7RZqxcylEZYC0LBXNL10R8dg2zc8/0Plt5
         OCAA==
X-Forwarded-Encrypted: i=1; AJvYcCUrSoY2PImqATwvSyA7FxT2PUX2zD4OzLXMEVVY493XOomND21bn8c21QC2Xh4tu1YrtpA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAEAmbl/GscD0cyVcXWb+/QtAmaQBAB444PnCsTMwv74PXygbp
	fyq+kk1U+b2AACEqIi7pL/HE4J7oOjUFgI0LOqGlDb39VdC2ZzGRFF64PCIV57pvFg63a1iDfJj
	jeeUJDEplBJKuhWPBHrUYcw==
X-Google-Smtp-Source: AGHT+IFdlks+cHVJJN0Pm1E8tmmOb+T06jth8P3+F/l88/NwWk3D7aE601eTKR+ZXuZ8P7m48FGAuSVd9gtK10Y6+A==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:6902:1342:b0:e2b:da82:f695 with
 SMTP id 3f1490d57ef6-e35ed2520d6mr631276.6.1731453799997; Tue, 12 Nov 2024
 15:23:19 -0800 (PST)
Date: Tue, 12 Nov 2024 23:22:46 +0000
In-Reply-To: <20241112232253.3379178-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112232253.3379178-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241112232253.3379178-8-dionnaglaze@google.com>
Subject: [PATCH v6 7/8] KVM: SVM: Use new ccp GCTX API
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Michael Roth <michael.roth@amd.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Guest context pages should be near 1-to-1 with allocated ASIDs. With the
GCTX API, the ccp driver is better able to associate guest context pages
with the ASID that is/will be bound to it.

This is important to the firmware hotloading implementation to not
corrupt any running VM's guest context page before userspace commits a
new firmware.

CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Ashish Kalra <ashish.kalra@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: John Allen <john.allen@amd.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Michael Roth <michael.roth@amd.com>
CC: Luis Chamberlain <mcgrof@kernel.org>
CC: Russ Weight <russ.weight@linux.dev>
CC: Danilo Krummrich <dakr@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rafael@kernel.org>
CC: Tianfei zhang <tianfei.zhang@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 60 ++++++++----------------------------------
 1 file changed, 11 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d0e0152aefb32..5e6d1f1c14dfd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2156,51 +2156,12 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 	}
 }
 
-/*
- * The guest context contains all the information, keys and metadata
- * associated with the guest that the firmware tracks to implement SEV
- * and SNP features. The firmware stores the guest context in hypervisor
- * provide page via the SNP_GCTX_CREATE command.
- */
-static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
-{
-	struct sev_data_snp_addr data = {};
-	void *context;
-	int rc;
-
-	/* Allocate memory for context page */
-	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
-	if (!context)
-		return ERR_PTR(-ENOMEM);
-
-	data.address = __psp_pa(context);
-	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
-	if (rc) {
-		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
-			rc, argp->error);
-		snp_free_firmware_page(context);
-		return ERR_PTR(rc);
-	}
-
-	return context;
-}
-
-static int snp_bind_asid(struct kvm *kvm, int *error)
-{
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_snp_activate data = {0};
-
-	data.gctx_paddr = __psp_pa(sev->snp_context);
-	data.asid = sev_get_asid(kvm);
-	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
-}
-
 static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_snp_launch_start start = {0};
 	struct kvm_sev_snp_launch_start params;
-	int rc;
+	int rc, asid;
 
 	if (!sev_snp_guest(kvm))
 		return -ENOTTY;
@@ -2226,7 +2187,8 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
 		return -EINVAL;
 
-	sev->snp_context = snp_context_create(kvm, argp);
+	asid = sev_get_asid(kvm);
+	sev->snp_context = sev_snp_create_context(argp->sev_fd, asid, &argp->error);
 	if (IS_ERR(sev->snp_context))
 		return PTR_ERR(sev->snp_context);
 
@@ -2241,7 +2203,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 
 	sev->fd = argp->sev_fd;
-	rc = snp_bind_asid(kvm, &argp->error);
+	rc = sev_snp_activate_asid(sev->fd, asid, &argp->error);
 	if (rc) {
 		pr_debug("%s: Failed to bind ASID to SEV-SNP context, rc %d\n",
 			 __func__, rc);
@@ -2865,23 +2827,23 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 static int snp_decommission_context(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_snp_addr data = {};
-	int ret;
+	int ret, error;
 
 	/* If context is not created then do nothing */
 	if (!sev->snp_context)
 		return 0;
 
-	/* Do the decommision, which will unbind the ASID from the SNP context */
-	data.address = __sme_pa(sev->snp_context);
+	/*
+	 * Do the decommision, which will unbind the ASID from the SNP context
+	 * and free the context page.
+	 */
 	down_write(&sev_deactivate_lock);
-	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	ret = sev_snp_guest_decommission(sev->fd, sev->asid, &error);
 	up_write(&sev_deactivate_lock);
 
-	if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret))
+	if (WARN_ONCE(ret, "Failed to release guest context, ret %d fw err %d", ret, error))
 		return ret;
 
-	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
 	return 0;
-- 
2.47.0.277.g8800431eea-goog


