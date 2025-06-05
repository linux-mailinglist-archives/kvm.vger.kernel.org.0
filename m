Return-Path: <kvm+bounces-48524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99820ACF27B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FFC516FFFD
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9294E192D87;
	Thu,  5 Jun 2025 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2szhSny8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B0D1C6FFD
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749135781; cv=none; b=uM/RnBXWYivB8eFtrTGoLBfMF2ZUysDiO5taXXQX9/laFTheIkb4I/dn0AKXPE5Mi4RfhH6lrpnGXyZHfg3CD9PMScMWs5EpRK66gvlhF2fFPkEbQ1sFVUSmeqKy2E4+k1nOuEf5JEXH7VG0GNaHRxln65cR+dtxc2fP3SDRpQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749135781; c=relaxed/simple;
	bh=3jeQmiKt06GXrIHfpjh0oQlnOaSY9Kr4rz+umFvQdDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LRaQoZJ/CKkFq26VYx404jy/xn48Ww8BHio5ay3X7F3I+//jVQ2K8ditRtBWU/Hs808RBu5ftdEOKAW4ciT+gM8tJ4paRbQ6NHr6YT7YLKsjc9o7S2Rfo7VTM/2wp4YqL9SY+OaJwbLtSIzNJ5geLdm+Mzsgbd+gVI6HITiW37Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2szhSny8; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747d143117eso927399b3a.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749135780; x=1749740580; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xzwm5+cjAdLoNMVYNUU/eCk5jF9CVdW14YhkjiBUlxs=;
        b=2szhSny82pKwCPNLkhnPekv6Mjfv73thO5bcbAUI/U1LKBLCB+tOnXn3JU4w3Mg73R
         QgS7GpwRGVshPnbeUHYq6F4g7J6GgLCSWnaah/RPIuKHqhoqssqFzHewdGie820TYKdu
         ctlidgviDwhEQF/CEzxOKXP/twZJS/J6NJlki47oodXDKfpvKHHEdDc+nNUkWI+j4fKu
         2RaUaLAFVs/IipHoIoMyQWyiggkbzNOCxV90qQ93uTbFei020kS4PTPLU7DOhinVjwZ4
         JGGkwbiK3jK5okR0Zs1RyDv6DiTt3Yn2R6oh6EKBewh3Yv7HWsYw7YHs+3BXrlOJY7CP
         nQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749135780; x=1749740580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xzwm5+cjAdLoNMVYNUU/eCk5jF9CVdW14YhkjiBUlxs=;
        b=tL2fIbeZ5VRn/6DDDCO7ehEXZTfW4Yn1R7UAzDFFrXCsQr6mDsffLjqHlU16fTbxjw
         nsH4ky8SnGOFejR8kw4ndKrKaTZPPsYpmQaxRCHIHjVuzJWbCiPgqn+jb9SDTMQCwOPZ
         Tl46XBxPRCYtnlLJNtO5io5qK5RTmSx7bl6qXcgL+25NWre31O6EyVH9zJSfin3nQKvf
         8fYAUh3Te63jCZ1ToGchZ8CmRhFdT8R+McLgAMCV6d9Bzzd9ZNJfIVDuV2GUbBSd06HH
         5fHgaDQzn/ppEWNva//qQcbz6s96EGoOJduVnlEp73dw3g4iXldCrtIjIBdIaz83PtJb
         o4LA==
X-Gm-Message-State: AOJu0YxgQJ0J8XQGNnBop6Cg5Qsmv6Hhuv4nIEtZINYoV1wq4PioBcuF
	Zw1l24DVP5HpmumnlY2Ek4J4jLrXmxhwT2fxZSo1azzPEDRRMq7Ho8SGPVS58FVTuRz7ZPLmXRS
	pVijcNhk6c5X8WtaJd7vUik0pYVMeNC/cNQTE72z22m5veUfQ1Z32ZsDuoJvP3o1ArH4B4eIF4f
	M1qALOtuU1hPST3GZm18gojXb8udrStxFczMPJFyC5K7Ui8bqPkoHJOGaALOw=
X-Google-Smtp-Source: AGHT+IHb5hKDUYrgVOzSrfCbbqZtDuSQIRve0rxtHVkUEsiBbiESd9WvsZr9lyVAILAcpiMtqMiFe+S0tlpgh2kuCw==
X-Received: from pfvx14.prod.google.com ([2002:a05:6a00:270e:b0:747:9faf:ed39])
 (user=dionnaglaze job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:b53:b0:747:ee09:1fb4 with SMTP id d2e1a72fcca58-74827f09679mr61292b3a.15.1749135779455;
 Thu, 05 Jun 2025 08:02:59 -0700 (PDT)
Date: Thu,  5 Jun 2025 15:02:36 +0000
In-Reply-To: <20250605150236.3775954-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605150236.3775954-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250605150236.3775954-3-dionnaglaze@google.com>
Subject: [PATCH v6 2/2] kvm: sev: If ccp is busy, report busy to guest
From: Dionna Glaze <dionnaglaze@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>, 
	Thomas Lendacky <Thomas.Lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The ccp driver can be overloaded even with guest request rate limits.
The return value of -EBUSY means that there is no firmware error to
report back to user space, so the guest VM would see this as
exitinfo2 = 0. The false success can trick the guest to update its
message sequence number when it shouldn't have.

Instead, when ccp returns -EBUSY, that is reported to userspace as the
throttling return value.

Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e45f0cfae2bd..0ceb7e83a98d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4060,6 +4060,11 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	 * the PSP is dead and commands are timing out.
 	 */
 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
+	if (ret == -EBUSY) {
+		svm_vmgexit_no_action(svm, SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, fw_err));
+		ret = 1;
+		goto out_unlock;
+	}
 	if (ret && !fw_err)
 		goto out_unlock;
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


