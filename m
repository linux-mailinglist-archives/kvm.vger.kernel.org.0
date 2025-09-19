Return-Path: <kvm+bounces-58268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C28B8B887
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF3751CC1FC8
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74340321F27;
	Fri, 19 Sep 2025 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v1+IY7lD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C3B314B89
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321259; cv=none; b=XkxK3l70zSXN8yfwWzsNoED09NpQiVRXgYBUeIiSGuZxYsxRvNqoan3wFsWZ43wwCb7pKVLUSzjdXB+SDeNlGJIp16CTBR95U10nSHCAlwlgfRpIIwCwbRLGp0R65EpjzQwsRWOF9tOVrBPmY3YRcpgedh0J3mWi785DZmNnffE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321259; c=relaxed/simple;
	bh=YWutoHj6w4COgn2+/X6HQXHVNZltIoT7LPB1tDxHCkY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Em4A5lutTEqJoxpC2QmRXVN9PMCHWUrmXpKJZQ2QSMDvviaGFp3XDnk9NOG4DQHz9ullOCnUQ2kF1G0FrpBJPGCdyzc8Zwo2sm3+nFM/1061jq4wKKJsQiIvdDUtbU6TJ5djuwPk3TaAMLy/8n3znszfK60dpd9BJUnnqNUnaTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v1+IY7lD; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77c3fca2db2so2662942b3a.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321257; x=1758926057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VYZLHKF8pF5KDs3SsZEerHn8ojDfpKPYyWB28d/RJk8=;
        b=v1+IY7lDiteZ7bMd0KONkBV5/52n6suxCbwybR9Op3oDqAC+bPCL47bDOVWCNfpzeY
         zFsSFm/DF15uhD0QX0UaHfMCXgNQSndZCpTOBNvD5E38PZPqwjz92UNMO7pobMlULKXY
         3Ory0Qi+tOx0QvUrAcp4SWl/goSjDWgrLM7bfHFhvxs2exz7Zuvcsu2QpVzzqhOyj86s
         gE2BRMCJsGW3R3D3mV6iYIY0nJtMoAijmAaidxfFOiOdUd+x8oio73el2UN2KMMjuPsQ
         gTp56EUzT8xIWkYsz3vdkrkbbPy4M7Vv/dQeK/SQsx6io3I++01XaEipcNa6T16LD+xO
         4JrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321257; x=1758926057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VYZLHKF8pF5KDs3SsZEerHn8ojDfpKPYyWB28d/RJk8=;
        b=IKjxSvNr69IpaWMuePNrSHfWNFhTZFXyO5xkUWZZV+vyMRpgFdP+azQe9gude0hAnR
         F/axZBaJIkXdHokPRosiL3c8dpLx07rIy/MDw7b1jvNRWGiTQpfsd+dZCz8/2lUEv2m7
         /fVS2ptnH98gAPwo1TGOWxkIML2kV+HnmHat7NE9bAJm7iSPIZeUkG2Y3hbYwF/yHHnN
         zN3UrRasFnts1yI/P0ec+SHdjQPOQStXO4w3JUfTHM3b2TpPeVkpGp9oTHh/Tpev6Yhk
         Ff5ncV42vlkyICPIYIADaaeSBVTxoqobL8and3g5Dh0ApLf52fV8nnslb/VAXRk2Kkq+
         PUUA==
X-Gm-Message-State: AOJu0Yxa8it1FEKOKYzff2u88kj6BgZ0HP4K5Q3Wh6Cc5HZcubX9yVFa
	22SyzegJz8uWCzTG3Va5DTRhBoAXHInBtgQGpimq3xrnNjxyPHCu3Q8WqIJMNJkttqFEaLDjcLb
	9PXO2VQ==
X-Google-Smtp-Source: AGHT+IHtxklkKMMTcCO+WLaxD30r3xUhNsd0DkrdB/jDO3hy+P4nkad/sYddyvamMtLnm9uHw94OGdFNKz4=
X-Received: from pfbg17.prod.google.com ([2002:a05:6a00:ae11:b0:77f:138f:8b8f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e13:b0:77c:ddd1:749e
 with SMTP id d2e1a72fcca58-77e4eab77fdmr5276946b3a.19.1758321257328; Fri, 19
 Sep 2025 15:34:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:47 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-41-seanjc@google.com>
Subject: [PATCH v16 40/51] KVM: SVM: Enable shadow stack virtualization for SVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: John Allen <john.allen@amd.com>

Remove the explicit clearing of shadow stack CPU capabilities.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d48bf20c865b..54ca0ec5ea57 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5262,10 +5262,7 @@ static __init void svm_set_cpu_caps(void)
 	kvm_set_cpu_caps();
 
 	kvm_caps.supported_perf_cap = 0;
-	kvm_caps.supported_xss = 0;
 
-	/* KVM doesn't yet support CET virtualization for SVM. */
-	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 	kvm_cpu_cap_clear(X86_FEATURE_IBT);
 
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
-- 
2.51.0.470.ga7dc726c21-goog


