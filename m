Return-Path: <kvm+bounces-28656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89AEC99AE30
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 23:44:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB0981C24A3A
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297A31D174A;
	Fri, 11 Oct 2024 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="viQ1NERE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08761D1753
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728683062; cv=none; b=DmR59Ykj7/7kljPrY2bK8Jm3M3FS9fFk01enMb8CnevN8vXozDpOmeXonWR/qfuQOzXSwKiMi1rfTfCQADWOiKlMq+S2kX5SjOX4asjUWT1xm0GI6jfRDb8SYft7/S2D7CCmplWGLmYkHDo/M0eky9/Hg29GhQx3W6GBqATQ/jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728683062; c=relaxed/simple;
	bh=/I8VUdkvAJLQEJj8WKw3N5lQy7af0guee/AI5dqcmnk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SrU24w79rCI+m/koe1qmWniIp36n1HpGLKTFHnYTFLT2oNUZeRZQqjSIfpcGCR4a63w/IV/h/cXMdEhUnraNOXdjXur7yySnV9sf+3XYWkp3BGI/OFD1Fca3jrFqEWJc3tQjyb3H96iWN7PVO/Jggyl7apmQH6FqL/qhWujg52U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=viQ1NERE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e17bb508bb9so3934805276.2
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 14:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728683060; x=1729287860; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ReiYQhELm2YErEhhfOQ8zhEV99f32bvRKL1jPZXBWs=;
        b=viQ1NEREgI5h1siaIjSs8guClpel1RcMNwfh58eMeYRhKJEX2DUakmJ9E+Z6KAO+Y7
         vH7fGUaOeh7gMSQY3d3Kv4vecLYlqNqHdQStZ8FhPhSL1Dmxt8MuyuIVU5icV/nwLlZe
         2XHhp35yT41hD5zb+uljrUANMce4ETKmFs0p2ikt32qfQvqRQDg5aSeiADkHXeDIKgeq
         z4wuKTCi/Dof1oVD7JVYS/QvL+0lw+qkrRYoJN+FFxxSY54zD832kRFVGE9lvblu9eJA
         +Qqp8OJ0xfN5rS6sfctOddX0PnXjfAoSX6C4vhw9kziWjzxMc0Wrd1QPYOwyZDlhZiPR
         HhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728683060; x=1729287860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ReiYQhELm2YErEhhfOQ8zhEV99f32bvRKL1jPZXBWs=;
        b=J6LofEfi6rQ4aNZ+R6P/oBRIJmEaNB8mRNI34zGPGE9K1cvigujD+IZSl5A5k//rXO
         BhEPL+b394gKdxNQjb4xRcdBPQ/49wrxOEggSOVKC/ITJD/PQVC2W3x8/L458tMOSVf3
         NHQT3lJWGP/EBY4jEyDRUDnawb3wk44+u38QjaIc+AwLHjT4Zb9tr6ajwZ7fKxCXkcoC
         MGMEft7VRY6oPXUMPiOHrj/RbkW4tl34NE6hmaAAjpXsi9lvOIxraTkspTs5plxGrfc9
         t+sjjvmB8oxpZ/dtK6NtxXdL5iyDrqLQhuN6MwjCHdrdhZ+pZG1LqTIfnkGrB0qspSlm
         VuCw==
X-Gm-Message-State: AOJu0YzeWP7YTdZcUu3OJJpSDn1y6LSfUSza9ZD8mupLEGMnluN9l2rT
	qtasA53/z0fxWY8obBJJJO+BVgUSEiDpSRwGb/zOiyIN86/7yfQeuYWNXnVc+1A9V6Wt6ROCcmq
	AM0TTaPUaEaGVoh6/a6tYY6WBlC5KyqzI8QKfMwIkE3ULRkJfQzw/uApJZtMDIpWukjYVmATAAw
	+gDt/4pcTWpbmGSUp5+7dsmgDDlAMbsuk+gxWYwBU=
X-Google-Smtp-Source: AGHT+IFNjTU5JA4y1ucXDSMX706MXDSEHDMsE+i5BoQ5Q0Kts10PVFaN7ZNX1L99lyAXtbkbDoxswNpwL0J9HQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a25:86d0:0:b0:e25:5cb1:77cd with SMTP id
 3f1490d57ef6-e291a32d32cmr14230276.10.1728683059203; Fri, 11 Oct 2024
 14:44:19 -0700 (PDT)
Date: Fri, 11 Oct 2024 14:43:51 -0700
In-Reply-To: <20241011214353.1625057-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011214353.1625057-1-jmattson@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011214353.1625057-3-jmattson@google.com>
Subject: [PATCH v5 2/4] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
From: Jim Mattson <jmattson@google.com>
To: kvm@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jpoimboe@kernel.org, kai.huang@intel.com, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com, 
	sandipan.das@amd.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org, 
	Jim Mattson <jmattson@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

AMD's initial implementation of IBPB did not clear the return address
predictor. Beginning with Zen4, AMD's IBPB *does* clear the return
address predictor. This behavior is enumerated by
CPUID.80000008H:EBX.IBPB_RET[bit 30].

Define X86_FEATURE_AMD_IBPB_RET for use in KVM_GET_SUPPORTED_CPUID,
when determining cross-vendor capabilities.

Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 644b3e1e1ab6..a222a24677d7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -348,6 +348,7 @@
 #define X86_FEATURE_CPPC		(13*32+27) /* "cppc" Collaborative Processor Performance Control */
 #define X86_FEATURE_AMD_PSFD            (13*32+28) /* Predictive Store Forwarding Disable */
 #define X86_FEATURE_BTC_NO		(13*32+29) /* Not vulnerable to Branch Type Confusion */
+#define X86_FEATURE_AMD_IBPB_RET	(13*32+30) /* IBPB clears return address predictor */
 #define X86_FEATURE_BRS			(13*32+31) /* "brs" Branch Sampling available */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
-- 
2.47.0.rc1.288.g06298d1525-goog


