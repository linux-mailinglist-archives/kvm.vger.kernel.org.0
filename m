Return-Path: <kvm+bounces-70366-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEz2I1wPhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70366-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:45:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E82D4F7CFA
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:44:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 45E573011528
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D8D333291C;
	Thu,  5 Feb 2026 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PQJ+eijR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CCD334372
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327821; cv=none; b=Ib+QEE4X1W+H+4CmWOBOqx1VqojCR1+E2vRVOsI4kvK4vgHlY7iJdfRNjW7yg436oiMcIymCQnZ0Ec1nbXEYyHZob+F68tjwi+u1aeDv532hngY/T5cMyZmBcQkGO9aWh1rkQirm8dcWqBlax9wt2sMPV14LyKhe2/9ZCiSLlMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327821; c=relaxed/simple;
	bh=//1gJ9AADdkcXusZWlVgojFG22OU4StZISH4Uz81e5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vf3CQ47/sLQYoBB0SE2z7pKaM+zBW7tSQ3CKZUg5GtC91msg59xX27Pv+srjzAd9afD4vTyUcekWV7ObNrSuO+A+5y/x2naEsT3QZz25umXplV8xk9E5ljtpmv86LRw8OdZb6ZPs/43v8HAhE++AKXiimn0BKbyEd9nE7o+cvCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PQJ+eijR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-353a5c295e4so1851242a91.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327821; x=1770932621; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zeNAWI4t8RbEksTte5HEam/g+zHUdM8Hnj9AjmiEzPY=;
        b=PQJ+eijRx4H8jK6nVyGF6gJGPv8IVrMjwgn+MFAfrWOvVSYwXXsnZfiMFOfXHxw8zZ
         o1N/HLrqJTHsSjxcSRQoyW3IVvZxFLmyJcmBXTiQcxrejuXSjcCH7ByYnRqQOLFNdx0b
         VSh5CaCS4Qnxe1PwFu3528IgeyA7734s/FBMHiM0oPIPmflcyi2Nv/W6WbSzMDY2yezE
         zgKnhm6+yrHs4sNFuA7Nirv7sd+NaPCE2hU0x7dkiIt9Y41tpVw9iv4+LL6bBAeupBYh
         vT9QvAE4YYCXL2XNdVnTbsB3kBOuNNTGkJVbQzIG5AN5se4opiiDwivR3jmrNwkSlp50
         4DhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327821; x=1770932621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeNAWI4t8RbEksTte5HEam/g+zHUdM8Hnj9AjmiEzPY=;
        b=RalSNl8MPVCycivVEnXf+ofX+9kGunTk3//WDLP9Lf+wC9ud0kiL2UZqsalQUXYwNI
         N2KqnZFoxiilBWWvDE3DqxFHtEF1oX8AtlaqwkZ8St3CtWRWzMv6IRgDfzg8Bf4XmTXl
         GXqLF3B5MqCnOxTXK8R3+Yzho0a9HKvTt61w5QFEgnFFPc6QoG5Jro92G7jke/ZHhNo7
         Dh9yNko0xn6M1jhEJKs7f2V0Bgn/ST3Izhmu+k1vsgPGoQK92+/78gly7arcwo924Vqn
         /P36UCxXVMkXbPGF2CD6tx4IXskz6s/PrYiWWouvzuBaUMjJXgr+UblhLqZUv81keQDK
         Bfjg==
X-Forwarded-Encrypted: i=1; AJvYcCUzg9PPvsIOqVg73qkONxJPInHmPDvPX2lvxYcZOLMcnJpJiMEaAN0abWRTiH0v1d0YI2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVGwc84zpkviZih9CLzPrna5v4femFbS3FXgGWuDRv8Q1CHZRz
	sWcZNHAsAeMdZZIp2Hvuqlm3BUkZJeXzFVh/nhT7p5URUYXMKCK9dEN9KFVIBQ1WAtQBV5FV7Db
	PXSjVLh/SlZYnuw==
X-Received: from pjbqe9.prod.google.com ([2002:a17:90b:4f89:b0:352:de4e:4038])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28cc:b0:352:dbcc:d74c with SMTP id 98e67ed59e1d1-354b30ace04mr594953a91.15.1770327820720;
 Thu, 05 Feb 2026 13:43:40 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:02 -0800
In-Reply-To: <20260205214326.1029278-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-3-jmattson@google.com>
Subject: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70366-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E82D4F7CFA
X-Rspamd-Action: no action

Cache g_pat from vmcb12 in svm->nested.gpat to avoid TOCTTOU issues, and
add a validity check so that when nested paging is enabled for vmcb12, an
invalid g_pat causes an immediate VMEXIT with exit code VMEXIT_INVALID, as
specified in the APM, volume 2: "Nested Paging and VMRUN/VMEXIT."

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 4 +++-
 arch/x86/kvm/svm/svm.h    | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f72dbd10dcad..1d4ff6408b34 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1027,9 +1027,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
+	svm->nested.gpat = vmcb12->save.g_pat;
 
 	if (!nested_vmcb_check_save(vcpu) ||
-	    !nested_vmcb_check_controls(vcpu)) {
+	    !nested_vmcb_check_controls(vcpu) ||
+	    (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat))) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 986d90f2d4ca..42a4bf83b3aa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -208,6 +208,9 @@ struct svm_nested_state {
 	 */
 	struct vmcb_save_area_cached save;
 
+	/* Cached guest PAT from vmcb12.save.g_pat */
+	u64 gpat;
+
 	bool initialized;
 
 	/*
-- 
2.53.0.rc2.204.g2597b5adb4-goog


