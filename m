Return-Path: <kvm+bounces-17733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A3B8C9185
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 17:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F84DB20F69
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 15:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A8A433C7;
	Sat, 18 May 2024 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=utexas.edu header.i=@utexas.edu header.b="FMzHi8a5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A0C1E51F
	for <kvm@vger.kernel.org>; Sat, 18 May 2024 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716045567; cv=none; b=m+s//lnBKXgsPp5nmpO6xQG1hTgarOLwKON0we8idPIIphF6E2L34EUBJrloeVJMol3J8gV/c2Q5JzHlhBEgjGAw7aW4cjaoiHZcEFpM3Vo5FdG0hWTP/jwBuMg99c6z6mKSf1ZTFw84dHqQuoI9ewAeEzKSeXcVjqpDqGs/OTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716045567; c=relaxed/simple;
	bh=pfMVO62mbfSA2hHcn2IEujKHBMscJbTyrMrRW9shWVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KMnxFKVgyVoFF78flRJ50K5KWCrGucSxckSIEc+h4ZqvsxeIshsZRbDIZ801tPr7J9332TqrE+vPoC3DOWpt2DraJ2Q0tH/CX8f2Czr5dlh1E+3hQycBzDRgoB8gdW9e2+BFpDsq7WXyddi3c3Kcn0t5SGyjmi6eF3ar5gz/Zco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=utexas.edu; spf=pass smtp.mailfrom=utexas.edu; dkim=pass (2048-bit key) header.d=utexas.edu header.i=@utexas.edu header.b=FMzHi8a5; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=utexas.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=utexas.edu
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6a077a861e7so13067906d6.2
        for <kvm@vger.kernel.org>; Sat, 18 May 2024 08:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=utexas.edu; s=google; t=1716045564; x=1716650364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKjOLLarc8bz1NAGUyB7AbZH8+7lIARnCen/FDmG78c=;
        b=FMzHi8a5QzhBFeco+bNSHEM1Qp5dHTTr8hr431nVW4SpWqhdKnvojFVf5MDRwmKGpf
         SnsXpmAaChJx/WkebRNgKL1ljs4ZyRFAwHYM8kXuQfGck3kyUrqsysmu8E+gERZ0phtx
         f+E27mxawlW8lhFZJCqahr0G+O7eKT2WgDckDWOXzCii5mTM/PZTfH1hSCesIOY6WUvR
         fNtCcpMhZ1SGHzRirjkBEk4iI212oI7lsRwuFRDjZGlot7cQ7YLsG6rZT4sI83TPeIy1
         6y0aKE1VqMJKhsrRWpJ2Ew3yVb2WnKx58f775P1KbKmHByGFNn+HB1hpogLhsh+td316
         FFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716045564; x=1716650364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mKjOLLarc8bz1NAGUyB7AbZH8+7lIARnCen/FDmG78c=;
        b=knRJJvY7dCTNaYAA8QKAq9JrWamGuhIh+l1w0ZEN4DiI2RKqPZ7yujl/G8ASpLuiEL
         ywxRgQACOnL2k9xjFODynYk2JfrOHNGjdq/fqD99MRlYtefhK3dmrMn0saiue+bskJWl
         7407RNOsS7vLBSzvXkjMvxcK68iXMjw74indDGijnZlfTM/51Ja8qQ0nIMN96YkSRUyk
         h7286ASBHwcmW7ywPyOKNQsB8h4OsysnV3ftU1zmgGQbdiJcN3BFTVSAKkKyedAIBN9P
         u0voCmmhyvYUS5It0APxveP5hvZKTAQLYXj4hjGr/kwb58dIezPIIdk4wm/Z3KI/t0qk
         2mMw==
X-Gm-Message-State: AOJu0YyQy89xC3bGrUv7h3Yonh9AkjdoP1bpJ+0cfW1QewHwXoi0zGuU
	qmv/ItctPZFGX8bHxSooZjAUUTsWWxiZNSuFXxexZdgY/PDI4Egq7VkUUdokkys=
X-Google-Smtp-Source: AGHT+IHg8FDZP+SigbLsZrzo7wA5DzSA+ztMMtVVC5XgWzAcRWTnMiUeZ1oXjm7dE3CUhWzrzKdXWQ==
X-Received: by 2002:ad4:4f53:0:b0:6a3:2949:c496 with SMTP id 6a1803df08f44-6a32949c669mr188608896d6.21.1716045564226;
        Sat, 18 May 2024 08:19:24 -0700 (PDT)
Received: from localhost ([165.204.78.25])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f1d7040sm94526876d6.107.2024.05.18.08.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 May 2024 08:19:23 -0700 (PDT)
From: Michael Roth <mdroth@utexas.edu>
X-Google-Original-From: Michael Roth <michael.roth@amd.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ashish.kalra@amd.com,
	thomas.lendacky@amd.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH] KVM: SEV: Fix guest memory leak when handling guest requests
Date: Sat, 18 May 2024 10:04:57 -0500
Message-Id: <20240518150457.1033295-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <58492a1a-63bb-47d2-afef-164557d15261@redhat.com>
References: <58492a1a-63bb-47d2-afef-164557d15261@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before forwarding guest requests to firmware, KVM takes a reference on
the 2 pages the guest uses for its request/response buffers. Make sure
to release these when cleaning up after the request is completed.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---

Hi Paolo,

Sorry for another late fix, but I finally spotted this while looking over
the code again today. I've re-tested attestation guest requests with this
applied (after applying the other pending fix) and everything looks good.

-Mike

 arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 41e383e30797..e57faf7d04d1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3933,11 +3933,16 @@ static int snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest_reques
 		return -EINVAL;
 
 	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
-	if (is_error_noslot_pfn(resp_pfn))
+	if (is_error_noslot_pfn(resp_pfn)) {
+		kvm_release_pfn_clean(req_pfn);
 		return -EINVAL;
+	}
 
-	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
+		kvm_release_pfn_clean(req_pfn);
+		kvm_release_pfn_clean(resp_pfn);
 		return -EINVAL;
+	}
 
 	data->gctx_paddr = __psp_pa(sev->snp_context);
 	data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
@@ -3948,11 +3953,16 @@ static int snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest_reques
 
 static int snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data)
 {
-	u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
+	u64 req_pfn = __sme_clr(data->req_paddr) >> PAGE_SHIFT;
+	u64 resp_pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
+
+	kvm_release_pfn_clean(req_pfn);
 
-	if (snp_page_reclaim(pfn) || rmp_make_shared(pfn, PG_LEVEL_4K))
+	if (snp_page_reclaim(resp_pfn) || rmp_make_shared(resp_pfn, PG_LEVEL_4K))
 		return -EINVAL;
 
+	kvm_release_pfn_dirty(resp_pfn);
+
 	return 0;
 }
 
@@ -3970,14 +3980,11 @@ static int __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t resp_gpa
 		return ret;
 
 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err);
-	if (ret)
-		return ret;
 
-	ret = snp_cleanup_guest_buf(&data);
-	if (ret)
-		return ret;
+	if (snp_cleanup_guest_buf(&data))
+		return -EINVAL;
 
-	return 0;
+	return ret;
 }
 
 static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
-- 
2.25.1


