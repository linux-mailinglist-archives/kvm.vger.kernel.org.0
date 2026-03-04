Return-Path: <kvm+bounces-72625-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iDZgMVJ7p2kshwAAu9opvQ
	(envelope-from <kvm+bounces-72625-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:22:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF021F8DAF
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C34A4304A893
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275D82E8DEB;
	Wed,  4 Mar 2026 00:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vAPYuxdC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB223C39A
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583748; cv=none; b=ZUyv34azGb/a5CBNieoZqFYvFhhBTAkZ174aSAtiGvoPFFfDrg54oFTOoD+bh6c2PWpTConDG3k4R1+eawBv7k2jRUebLXmjER1mJYp/oyld2YQsPF3d5ATiWkKqIOCm2nNCr3c+Vl8RI1RjVHGN+noYkRnVN7WKEq9d3RdggrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583748; c=relaxed/simple;
	bh=hrLuHfEFfqljp6L0TPvigKRlF2qr+lrHeNI/UpHPiFc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZaXygaKmMK77U2jJTguq/6MXXxOvu4tWpYMbjsBnO6z6RvV1egmw9Ie0LBlTd61b1AfUz//a5t+dz2yRRmC598EdEtCsBZ1+tQwZe3AO8VI8AGF3+tmh1iAwbyxyj3Pd0Vk64O/RnTMz5j620HVTCxBpTF2eR+ki/kXqx7ty6eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vAPYuxdC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4f27033cso26772785ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772583746; x=1773188546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eMEjPTiLGkOdiy+nHp64M5wsR6mjZFUC7u+wIwROkjg=;
        b=vAPYuxdCVFnUvj9bJR0VFo3LTCG12P8/BP/8g+gf+KxSey3MjyyH5q4az6csuAXQVK
         I9SBjv6dVmkCOTth9opH+B7x8/UOliP41sGGpJaHDSZvbyuTlEDsIvdk5/99gN4RIu5i
         ZvwA1xVRCFUMshRL6pOi3uqsN+J4ZZwTSyD+87wB388HrfixnsfPyKGvxpXJ9OOJuxGp
         zoUnAIp85XKjUyxr6OFSmcn/DiEyRNPW29k1e0MCpeUBTnUCW66+Ggx3Onw+LEZwHRW2
         AqJF+XT0Ec94/n7mkZ6pHWIU6uu21nJ07kWZKyds0F02TSJOmML5Cvi5gNr5gwvOnRSQ
         SkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772583746; x=1773188546;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eMEjPTiLGkOdiy+nHp64M5wsR6mjZFUC7u+wIwROkjg=;
        b=J//NL7AegOP+Otl5/IAHpCa8hIGK2lpJm31HGzybVw2oCOWi85u8Pwc1Mf1BQBs/D4
         ZZqMStJAjcsa6TH2UcjaWrpRq1lfbia2VdhYSBAYN7z7zLtixUI3u0diq+wS+6MyQvX6
         uCGDrPVdF9VHQ9i5lyrtURki/R7sHJgE4T+PDIo11AZLrGUTx76ogPMKWoVnJY1atTC4
         KpcyWnNkb1n7RencKUb19T8EPjZB73yYwg6cj+KZpDCA5KOZ1h7sDvAdXWyYX5Lp8JGb
         AuX1T1sjEa2U63GtENClagW7h6RCUREyZraRTyeiI3Ba2GaL+TwbbtbrtgdeRiejYuSt
         sFJg==
X-Gm-Message-State: AOJu0YxMobMX3JfIxs7LY+PKNP41OaNiF9aKDiCw4xZPSjXXfLAj1ife
	flZQgRH8oq1S6LiYUYNE2Z/1v51paSSwWvMz9Pt1nkygDqtVsL0CJFydb2+/b8D+IdnoWVLeup4
	RnPedsw==
X-Received: from plpg12.prod.google.com ([2002:a17:902:934c:b0:2a9:63f4:124])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a67:b0:2ae:5dcb:6db5
 with SMTP id d9443c01a7336-2ae6a9c6e60mr2405675ad.9.1772583745927; Tue, 03
 Mar 2026 16:22:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Mar 2026 16:22:21 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304002223.1105129-1-seanjc@google.com>
Subject: [PATCH v5 0/2] KVM: nSVM: Fix #UD on VMMCALL issues.
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7CF021F8DAF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72625-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

The VMMCALL fixes from Kevin's broader "Align SVM with APM defined behaviors"
series.

v5:
 - Separate the VMMCALL fixes from everything else.
 - Rewrite the changelog to make clear this is fixing only the Hyper-V case.
 - Add a patch to always intercept VMMCALL, because letting it #UD natively
   does more harm than good.

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

Kevin Cheng (1):
  KVM: nSVM: Raise #UD if unhandled VMMCALL isn't intercepted by L1

Sean Christopherson (1):
  KVM: nSVM: Always intercept VMMCALL when L2 is active

 arch/x86/kvm/hyperv.h     |  8 --------
 arch/x86/kvm/svm/hyperv.h |  9 ++++++++-
 arch/x86/kvm/svm/nested.c | 11 +----------
 arch/x86/kvm/svm/svm.c    | 19 ++++++++++++++++++-
 4 files changed, 27 insertions(+), 20 deletions(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0.473.g4a7958ca14-goog


