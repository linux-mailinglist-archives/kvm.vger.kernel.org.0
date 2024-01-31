Return-Path: <kvm+bounces-7627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2016844D96
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EE97B2D75B
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380B73BB4D;
	Wed, 31 Jan 2024 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nE6k6GwO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7797C3BB27
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706745378; cv=none; b=CR3sfBdXqOf4NZXnBqu2y2NlJqfno0UVvKllvrgSY+oElQ5b+Tt4Fm8H/4ATSUNGMqE/o81+OqdpxaSkefvVzfoF403Gw/34oXlk3jrDJpQ3rLjiON0YxRWjGsNIqq753JlN2a8Nxak4Txdd20a4hyAsYzxJdnjKKNRj/dL6o0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706745378; c=relaxed/simple;
	bh=Y2eTrWyIvoI9BY4Vorbbz847bJmJSiZQnQACclMHzyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ftqt6YvA1cKVDilFZaJXsqtgEykBh6n9akfRd2ODTrJyUZl3PFZziOxLKwExiTOQIW2xRBKcHb2f0Q6hHsAcgiHuKGxdu8kzMJdIT9q6DavGSNikrHgmxJ8WoiRGIqYOpxd21P+xBVHuZ+CZKZh/VfVMU27U/e1gM8V/1faaSVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nE6k6GwO; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60403a678f2so6268047b3.3
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706745375; x=1707350175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wDrpEbS6CmtfJ+E5uJL5CN/JlvMOfJl9phijYT5xNg4=;
        b=nE6k6GwOgPbzqBzDgNDXdpItFoEceXrLJfmpvHlwcgPlaUbtKdpXDQIZbJkpbJ8XN3
         YQlCPCTG49J0ezo4eRtgwoplBXIgraqjEuogEM3OgshhL6XRok1l3lxP4ssI6pcF0jWA
         A4TAD/fV0uJ2mhwU61jYzyU3vt0XMy2H7Zez8nmR7AUsXycLTttGvyrNd+B8YPQ64nvb
         XpdM6zlwXClEJlVlrCwYeGgzZ9DZQwIeWKEyXI4YPsqn8G86B6ilsOjetPE7zbR1Ug6K
         2zFRg1EkP/oXdeppVZan34sZ5Uy9ohgNVVFIDNPIdwVFABl7gBJywozQ7lki4uk8ybMh
         2XgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706745375; x=1707350175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wDrpEbS6CmtfJ+E5uJL5CN/JlvMOfJl9phijYT5xNg4=;
        b=pU8ow6E10Z+Ns7VIWzMDBxsCnk4531G5sTOxH6/ur80/BEaxOi+jHN6LgH28HZ3FAz
         jNzYJmbHWInDyUMzutdIbfQpdxcXucqU2joVaP4TS5dr9aeV/tBekOL8SyjZKU/Ef/7a
         IigvDQyU2Zog10MedmhMHg7+LGnP4jRWqeQPb/7/13Q6IsuAdrbRXVIg0ffN67J8DBiu
         jHG2/vGcJFvYCd+ZRdIQL6pOBjIM6h7S1Egt7KpVszq1ck1sp4XpkNdl/m0/FJiO3s3W
         KMqgPA9m80HVr+IzcNP9NVd6qoxDMk4cX9C7HDjIJntCkT9c+FuiZjMicOPfn11fHBUq
         jaHA==
X-Gm-Message-State: AOJu0YyRHiGbX0E8DnxazzAqURrwqkEd+yNi6AGN+CTIYfuTRQHV7E99
	pwBMCIMoILG8jrjptldOolTYNzB/I/4ibz9vCS4k6nL4vZhFEGPKd7LMoyP/eq4MP/vY2vutp97
	aYg==
X-Google-Smtp-Source: AGHT+IGbEnNEURC9jLZidxPUnwtX4/73UpoOEZWNy8Mqhjwh4iVtL4GbanNwrnNPMoZFVk33EXFFZMNkdNI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:9e:b0:603:ea10:c37c with SMTP id
 be30-20020a05690c009e00b00603ea10c37cmr719982ywb.7.1706745375516; Wed, 31 Jan
 2024 15:56:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 31 Jan 2024 15:56:07 -0800
In-Reply-To: <20240131235609.4161407-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131235609.4161407-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240131235609.4161407-3-seanjc@google.com>
Subject: [PATCH v4 2/4] KVM: SVM: Use unsigned integers when dealing with ASIDs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Convert all local ASID variables and parameters throughout the SEV code
from signed integers to unsigned integers.  As ASIDs are fundamentally
unsigned values, and the global min/max variables are appropriately
unsigned integers, too.

Functionally, this is a glorified nop as KVM guarantees min_sev_asid is
non-zero, and no CPU supports -1u as the _only_ asid, i.e. the signed vs.
unsigned goof won't cause problems in practice.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 18 ++++++++++--------
 arch/x86/kvm/trace.h   | 10 +++++-----
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7c000088bca6..04c4c14473fd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -84,9 +84,10 @@ struct enc_region {
 };
 
 /* Called with the sev_bitmap_lock held, or on shutdown  */
-static int sev_flush_asids(int min_asid, int max_asid)
+static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 {
-	int ret, asid, error = 0;
+	int ret, error = 0;
+	unsigned int asid;
 
 	/* Check if there are any ASIDs to reclaim before performing a flush */
 	asid = find_next_bit(sev_reclaim_asid_bitmap, nr_asids, min_asid);
@@ -116,7 +117,7 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
 }
 
 /* Must be called with the sev_bitmap_lock held */
-static bool __sev_recycle_asids(int min_asid, int max_asid)
+static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
 {
 	if (sev_flush_asids(min_asid, max_asid))
 		return false;
@@ -143,8 +144,9 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
-	int asid, min_asid, max_asid, ret;
+	unsigned int asid, min_asid, max_asid;
 	bool retry = true;
+	int ret;
 
 	WARN_ON(sev->misc_cg);
 	sev->misc_cg = get_current_misc_cg();
@@ -188,7 +190,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 	return ret;
 }
 
-static int sev_get_asid(struct kvm *kvm)
+static unsigned int sev_get_asid(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
@@ -284,8 +286,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
+	unsigned int asid = sev_get_asid(kvm);
 	struct sev_data_activate activate;
-	int asid = sev_get_asid(kvm);
 	int ret;
 
 	/* activate ASID on the given handle */
@@ -2312,7 +2314,7 @@ int sev_cpu_init(struct svm_cpu_data *sd)
  */
 static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 {
-	int asid = to_kvm_svm(vcpu->kvm)->sev_info.asid;
+	unsigned int asid = to_kvm_svm(vcpu->kvm)->sev_info.asid;
 
 	/*
 	 * Note!  The address must be a kernel address, as regular page walk
@@ -2630,7 +2632,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
-	int asid = sev_get_asid(svm->vcpu.kvm);
+	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
 
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813e..b82e6ed4f024 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -732,13 +732,13 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
  * Tracepoint for nested #vmexit because of interrupt pending
  */
 TRACE_EVENT(kvm_invlpga,
-	    TP_PROTO(__u64 rip, int asid, u64 address),
+	    TP_PROTO(__u64 rip, unsigned int asid, u64 address),
 	    TP_ARGS(rip, asid, address),
 
 	TP_STRUCT__entry(
-		__field(	__u64,	rip	)
-		__field(	int,	asid	)
-		__field(	__u64,	address	)
+		__field(	__u64,		rip	)
+		__field(	unsigned int,	asid	)
+		__field(	__u64,		address	)
 	),
 
 	TP_fast_assign(
@@ -747,7 +747,7 @@ TRACE_EVENT(kvm_invlpga,
 		__entry->address	=	address;
 	),
 
-	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx",
+	TP_printk("rip: 0x%016llx asid: %u address: 0x%016llx",
 		  __entry->rip, __entry->asid, __entry->address)
 );
 
-- 
2.43.0.429.g432eaa2c6b-goog


