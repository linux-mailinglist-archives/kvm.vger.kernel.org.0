Return-Path: <kvm+bounces-72628-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDYyHSN9p2nYhwAAu9opvQ
	(envelope-from <kvm+bounces-72628-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:30:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD671F8E95
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 734AE301CA99
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80AE62FAC0E;
	Wed,  4 Mar 2026 00:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fLkkth2d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA5F2F6925
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772584214; cv=none; b=DvGCyv6Xuy4GlIg25+bk8n53LfbtQUPbhhDbqHF4bTbJpNoA0HrSCK6xP6FhPy2M9i0nT6hQHT5Rb/H4IInnvaDr0iGYoDz6SWNK9D/p1uIrP2wuR7wmsSi6Sfytupx6lS8ZOqvjfXGnlfHjBCroj3la0zms8wRB8xd8BZWBXUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772584214; c=relaxed/simple;
	bh=3tPhoIC6Bu08Eim7X/y0ycnEkAVtQrk7kENmz9hQFhI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XbkwqHDGzjVJZcUrqrYbwSfa4z9QhQT/iMDv71DXW/mvcG89ik1pWuY1nU+2rM5PGd6iaHUbwLORlhytjzU8KNew6wb/ioVb5fNYFJESu+Ub/w0Pr5ZJJYY/y0ts6qh7Lk87L7h1XHOC3prrDK5YAPfh0geUAV8dEPzLEpaDlJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fLkkth2d; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4e20a414so140772395ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772584212; x=1773189012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vN42vQciUoJdrWBNVw0ChEaojXRkmaJ1ILHWzzE+t7o=;
        b=fLkkth2d7UKpGE8FWBJ+oucBHZpmo6hmeuJZi0ykCVPrcQcNz0eRsWICe4BbjK4ggk
         6cjn7tPuBJ2inKYBoG+4DpqSwEZkgxp5oLrViwTFyQSAIUSj4mdchfyYROk629dgQmwj
         e1fvv0bLIsj9KsVcyYPR5WAwOzjB0nFDfAL07B81HMmtDJACUn2Ho7Ff3BqK8vlDsaov
         8vvpJ4I45OkmK0cU7jL4+kVipT2FoNBBPdt58zutNzdZ4mp+RR5vVDZEGywMmazRsFzJ
         6gOAwt7kta1XaNaEsE6VWSQWPRDtPPY7GxzUAsxEfmSYXatClSfZSnQR08KBplRaHwXD
         gxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772584212; x=1773189012;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vN42vQciUoJdrWBNVw0ChEaojXRkmaJ1ILHWzzE+t7o=;
        b=SjxvuoNcMzv/Pa0ZzrfkSGQbRQmYIt2MtdT6uTd7cDc0jU5ZAngTyP+Si4aWBu0OaN
         BwUemsuN+bVAOU2bCcRCMXTyASQXaKAMGUywJX4SfYs1XEdyNqq9OUjXKEeeSTd/SZgh
         z7TpMESu38rfP4g0qmQS1AqYvAr2J23ri3KRHgskI5+y2eFMOAdoSbqeSrcRCRuMFcaK
         FMs63YLL+wBImFy0sSlSJJGI9RTBd63l63fwzgALD+RnIUgmIgX3WhLwK44+HBJdASiG
         uK14zGwEPwWvJMMzyPuPEzfkN5Y6YuUqSUS8+Mb+qhmNCgR3rELQ+CS2YdGsRWc7mVl+
         wT9g==
X-Gm-Message-State: AOJu0Yw/OEPZS/1Rs0xRBn7+HP/OaZpl7Km1eiSG75OYIAa/YTZt9u12
	y8YK+Dc3LeDT8ij5aG+K92kdBmGxfALVdYdcqDf1oZFI0W4XL3cwuVconVKJ6xlQVlUs6+TmtYR
	IO2NPUA==
X-Received: from plho18.prod.google.com ([2002:a17:903:23d2:b0:2ae:5645:97f9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3201:b0:2aa:d11d:5c36
 with SMTP id d9443c01a7336-2ae6aaf2100mr3173705ad.30.1772584212206; Tue, 03
 Mar 2026 16:30:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Mar 2026 16:30:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304003010.1108257-1-seanjc@google.com>
Subject: [PATCH v5 0/2] KVM: nSVM: Intercept STGI/CLGI as needed to inject #UD
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5BD671F8E95
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72628-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

The STGI/CLGI fixes from Kevin's broader "Align SVM with APM defined behaviors"
series.

v5:
 - Separate the STGI/CLGI fixes from everything else.
 - Apply the Intel compatibiliy weirdness only to VMLOAD/VMSAVE (to fixup
   SYSENTER MSRs).
 - Re-remove STGI/CLGI intercept clearing in init_vmcb().

v4:
  - https://lore.kernel.org/all/20260228033328.2285047-1-chengkev@google.com
  - Dropped "KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and SVM Lock
    and DEV are not available" as per Sean
  - Added back STGI and CLGI intercept clearing in init_vmcb to maintain
    previous behavior on intel guests. Previously intel guests always
    had STGI and CLGI intercepts cleared if vgif was enabled. In V3,
    because the clearing of the intercepts was moved from init_vmcb() to
    the !guest_cpuid_is_intel_compatible() case in
    svm_recalc_instruction_intercepts(), the CLGI intercept would be
    indefinitely set on intel guests. I added back the clearing to
    init_vmcb() to retain intel guest behavior before this patch.
  - In "Raise #UD if VMMCALL instruction is not intercepted" patch:
      - Exempt Hyper-V L2 TLB flush hypercalls from the #UD injection,
        as L0 intentionally intercepts these VMMCALLs on behalf of L1
	via the direct hypercall enlightenment.
      - Added nested_svm_is_l2_tlb_flush_hcall() which just returns true
        if the hypercall was a Hyper-V L2 TLB flush hypercall.

v3:
  - https://lore.kernel.org/kvm/20260122045755.205203-1-chengkev@google.com/
  - Elaborated on 'Move STGI and CLGI intercept handling' commit message
    as per Sean
  - Fixed bug due to interaction with svm_enable_nmi_window() and 'Move
    STGI and CLGI intercept handling' as pointed out by Yosry. Code
    changes suggested by Sean/Yosry.
  - Removed open-coded nested_svm_check_permissions() in STGI
    interception function as per Yosry

v2:
  - https://lore.kernel.org/all/20260112174535.3132800-1-chengkev@google.com
  - Split up the series into smaller more logical changes as suggested
    by Sean
  - Added patch for injecting #UD for STGI under APM defined conditions
    as suggested by Sean
  - Combined EFER.SVME=0 conditional with intel CPU logic in
    svm_recalc_instruction_intercepts

Kevin Cheng (2):
  KVM: SVM: Move STGI and CLGI intercept handling
  KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled

 arch/x86/kvm/svm/svm.c | 53 +++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 13 deletions(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0.473.g4a7958ca14-goog


