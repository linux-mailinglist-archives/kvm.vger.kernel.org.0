Return-Path: <kvm+bounces-50800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EACBAE96E1
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02B8E169B9B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213A125C838;
	Thu, 26 Jun 2025 07:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="AyM2fv0B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A20925BF08
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923313; cv=none; b=oCqBh4wmc6gJokO5zLLPV4s0o6XSS890KkVkb7h+90EOXtVlfTdlqo3KlnuK+Ie1qVzlyHRp/G0WwepZicBA2/VKEWDqfU6jx7c3sPAwc2kirnANWevz216EkRinPcENM3D3jA7xh3zjAdJSS97N9UuY/2ZkFW86HmeA/5aP6p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923313; c=relaxed/simple;
	bh=r0K9+nazhXUNKosRg/kJXUbushA0bau/Hzsri+HOV8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u51BJwwLNmRBHkbOnRCc6Q3abHoXHy0Wo/k3Hfxe95ezbHuWvNFFvy9iw4eoxwTEca3FMK2CsY6zAYQuHr4IF7Be4D4aTnJ7q0kLCQmIsP8RqWJr2WM7gk0yriXnNGNeTBgPa4UqWERMbSAbRZL9Q6C12NxDDmOTaes4f56+xV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=AyM2fv0B; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4530921461aso4339845e9.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923309; x=1751528109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ERHrvPoMw8sjsxKs7INuECWsGvkFg5YhY8pVecZ4tU=;
        b=AyM2fv0BEWiBl7VB8TCdmgzwp3YLrQo7j7NlwStKhrWp5TpgFJvBWEE6vI3DFWljiI
         I2uARBw4qdGFx0ANMXJneZj+Otgva0d8gUc8Gbt8wOZOo6lt9txBRAqpGcUeGI4CCMCB
         qM3G8Tn24d+Y22fq8PjtlWpeH5iZS/z8YnMpBBgVUZHxEBtzxh4X/PQxuIC3kHEOvQ55
         EgG+3YMJYNlUfvkzqrzCaxb+7WqJyvQRiMOL3vfGP0fqEcjI5X0ssHGrRTLOq2sr/0ws
         tpAd0lA+EeJw1r5G0ubaBsShhyX70c5lUgnbrcbd4xbLaVkpuDUoRp7X32u8wGRxxN6a
         +Tzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923309; x=1751528109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ERHrvPoMw8sjsxKs7INuECWsGvkFg5YhY8pVecZ4tU=;
        b=Ui9+nMdvMjSlXo1tqdc+RHSJpm1kWmVZlk8xvMXqA7vqQdu4qeL873H63jGWcaXVU2
         YzBn3ufQiz/pGQi3FRt+tqXyYk8jBZHiT2JFHbg1hGwuy7ASeLx9QfkuEcRzGl9hAQEI
         EvxZ6rrMd/RnD5RCI7LkFuPCPkTXk7/r8cYft92RW3zfODslNahHoOpVd35AcNK9bMMp
         8xPxYRT5LF1cSx3RmqyBJtar9u4VnADs9aq0KZAc3j6byY6umTyMbrQTSCNkv7DC3kLG
         Jj4NoDcGFqkBkIUIZpIdyScHPcyi+RGWWUNUerOI8KBY7FRP0qzMF8CyYCTuKtJIxqO9
         ekpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlW0PNlOEBXlbRnDYEzrDPHPviEZGCyyRnBTSKqKLBjA9U7kZJ1I/yqpnjZhpVhL34oJE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZf7d6csrUjVTPbTGY7qDZDfb45lKzXjaccZohOOxDT1XdEVN+
	ub0AnYt0jdIe2DAK3UF1PRqpfp3s8df7JT7iSa0uv+YBKB2yVWCQrq9TaRfS2llVjTo=
X-Gm-Gg: ASbGncs0l/mZQv2EvEgWhJqCboQEmDw3/GRhirPPxTsx64rJ7mKEZ3FXimCdjxq76sR
	V6GW/KwRKJ1XhK8LzqlUu54BXL/GiMP/4+oBQta4lopusMKVonf/yfV9xabMPbDlxXp5zccndcM
	Nu8mjV5xoC78IDc3GdOt050JvjWXkFTPFnpiG0iPmq3tWkW5gTVyODx+DYUVwvBiwXYmqriGfwO
	p8rMShDiaadX6VgjrdCWZu0TDdMrqP0iYhkePNlOdO3lUrXRa8QuMqTtlI3dJ88P4rBDPKxqjKj
	87gLsduQBuT7uqST0jZKxyGYbpJtmElw5mopYpqxjvbyppfCtiWHMMh8liD9uvPmplTAsLWmCvB
	wHY21psXCMD4Ptee4qFxaxkbQgEUJonx4LhwjHOlOOcvw22fGyQ2aIgM=
X-Google-Smtp-Source: AGHT+IHCgaP0+CUElwoAooIwpZWdXkyuRlrbzcx4F4xHFOj6E8gO3cqU/O0VnTvqUkuNlpBfWa2FIg==
X-Received: by 2002:a05:600c:4f86:b0:43c:f1b8:16ad with SMTP id 5b1f17b1804b1-45388790f91mr28855645e9.30.1750923308990;
        Thu, 26 Jun 2025 00:35:08 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:08 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 07/13] x86: cet: Validate writing unaligned values to SSP MSR causes #GP
Date: Thu, 26 Jun 2025 09:34:53 +0200
Message-ID: <20250626073459.12990-8-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

Validate that writing invalid values to SSP MSRs triggers a #GP exception.
This verifies that necessary validity checks are performed by the hardware
or the underlying VMM.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/cet.c b/x86/cet.c
index 61db913d3985..72af7526df69 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -56,6 +56,7 @@ int main(int ac, char **av)
 	char *shstk_virt;
 	unsigned long shstk_phys;
 	pteval_t pte = 0;
+	u8 vector;
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
@@ -100,5 +101,9 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
 
+	/* SSP should be 4-Byte aligned */
+	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
+	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
+
 	return report_summary();
 }
-- 
2.47.2


