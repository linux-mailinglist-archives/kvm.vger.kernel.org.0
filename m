Return-Path: <kvm+bounces-58250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1DFB8B814
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBCC7E284A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C052F619F;
	Fri, 19 Sep 2025 22:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LRwzIf3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E4D2F4A16
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321226; cv=none; b=iqY7uu8dMYMe+fMRJKXhr84MFVtIOcU/MtyMJf5icpk1GLX7Z7gAdJDaAEXZ+VX8hA3ARVmuVK1Lc3BaCRlwvd9LSOjWyWLsfGDATFhxwYzY6XOM8Cm+K2ghfpwAtpXIAej44FVnpHNXD9KqYoHYNpI965bgS53LXefjhuTXVPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321226; c=relaxed/simple;
	bh=1g+suQtn60veXfeytSPxGzA9zEex48KEjHyupko4/EE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HMsWe4NyZ/sCRR6yUc50r16XyAPXtVx4p9cUO0n6D2b7vVngb/M/wo3Fd8hlOhYSOof5Z7JjZwTIxDIvW6fUQZ6eczOO8I6Y/uG/8qXo34658pUBMwtoZoxmu2hc+Ha6TiYpXigk+cWSWlZJjCca03D7cQAS0T0AB+up7m22jUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LRwzIf3Y; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b55153c5ef2so1334507a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321224; x=1758926024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Fx9hg+85vjiGkpy9V7/uhZK1m1ipmBfIS5//YWebLXI=;
        b=LRwzIf3Y9yR9ElzLHd2dFdY2bAmouRnEJRQfuy3ro6tx04tm5fo1qsXdK/kbEvkH25
         F2qTRP/BuCQi3LvT78OKgNOfdCcKM8KhDA7ZlX1F63LEHycL5H8Wht1pd3wYJy02C1re
         nixelWzgWqP/YvxMjg+brC1NBaPkqfO+c0GXnYRno4P82v0foEkx7q2chFl8cjQLIfFo
         eAtSutDEDlmMNDjRqerYvppPbTbibhtrvRIBUV/KUsRPG57V30K0lY3mat0N4cbwF5/9
         mGnvkyvbUM9ydS1bWpt469uiouneqrBca7Vuif1Bx38pgg3CAI8vPIu4RVffZsFNnG3F
         qYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321224; x=1758926024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fx9hg+85vjiGkpy9V7/uhZK1m1ipmBfIS5//YWebLXI=;
        b=UGTSz35OzD6Ef4mJcyJB9TeJp7UzjTT50jtlIWXjrGim16gcnLhXw7H0gScSRM46oL
         X8ACH8ohArzJzOVA8LWUfn7E1Oj6jYAAHb5nW8S6Jq/EXs20rXYM9GpQRLrZ8tN1FMoz
         +z4xkNQj6/zDpEGGhnYboQMS9cu2VfmDNkwDxZf2XYhrJSjqNRlwmXkI0GYoBZkQ397c
         1u48FeWLGLF4rg9WLna4YPPPRyMqK0s1RvlNdVTKsT3p4be8VLxkRo8YmZRwhQCPzWxY
         i/pCf46JDiBeDaQGVwSZkP8v87jhAcorBu36IrS6/vSGpAa7yvlcDdotgk4uZa6ti0gA
         /aaw==
X-Gm-Message-State: AOJu0YyaIlu1ECoqQ0wBr9SVnVpRYS1J3Y8qjI2wNVpKEUud1TZrXAwW
	1WvYFCQIePCSBc/x+GEqOKLYynnKxwfGvbsX7UlfKWd4Iw7R2aH31639/2iY+d6Oip7+1hf0vri
	PAEQgOA==
X-Google-Smtp-Source: AGHT+IEhZFpddRJqAtv3ixHm1tklJi/Tv5LlRaFO2FnSMxXxfU+E3oTG1YYf+oq6xBsrKCc/j4UqdgAp1jE=
X-Received: from pjj4.prod.google.com ([2002:a17:90b:5544:b0:327:d54a:8c93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2589:b0:261:f6d2:e733
 with SMTP id adf61e73a8af0-2925bace0f5mr7496586637.16.1758321224632; Fri, 19
 Sep 2025 15:33:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:29 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-23-seanjc@google.com>
Subject: [PATCH v16 22/51] KVM: x86/mmu: Pretty print PK, SS, and SGX flags in
 MMU tracepoints
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Add PK (Protection Keys), SS (Shadow Stacks), and SGX (Software Guard
Extensions) to the set of #PF error flags handled via
kvm_mmu_trace_pferr_flags.  While KVM doesn't expect PK or SS #PFs in
particular, pretty print their names instead of the raw hex value saves
the user from having to go spelunking in the SDM to figure out what's
going on.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmutrace.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index f35a830ce469..764e3015d021 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -51,6 +51,9 @@
 	{ PFERR_PRESENT_MASK, "P" },	\
 	{ PFERR_WRITE_MASK, "W" },	\
 	{ PFERR_USER_MASK, "U" },	\
+	{ PFERR_PK_MASK, "PK" },	\
+	{ PFERR_SS_MASK, "SS" },	\
+	{ PFERR_SGX_MASK, "SGX" },	\
 	{ PFERR_RSVD_MASK, "RSVD" },	\
 	{ PFERR_FETCH_MASK, "F" }
 
-- 
2.51.0.470.ga7dc726c21-goog


