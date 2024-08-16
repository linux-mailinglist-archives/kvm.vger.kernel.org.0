Return-Path: <kvm+bounces-24421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8248C9550C8
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:26:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B83A8B2178E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3668E1C3F1C;
	Fri, 16 Aug 2024 18:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wJtZHI5c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60B2F43
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832767; cv=none; b=d9ylJ7dcV64xIjSslQzdFkwhjS7JFSacYETkXn/ON4QSy/7rvxYPM24EuNWICrrBasnzjuK8kxBl0P3OIEm0dgjbUdMSJR7mXldI3IJUz9MjJ/2OfqQJkHk09q80geZ8bU0eBfir11sOGI4m9yIQis1rT5BJZjpseKWQI6m0N28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832767; c=relaxed/simple;
	bh=UpzadmpD5JAWm7JbXK79TiN9tBl/ICyRxDFsukaWQOQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aJXjyd0GGomayfJouvkPPc2Mxk18LzaoubKKCShrvfxMLuZMKn6u6AsBDgfXReRqa3kapcxhUCyFQxZ6juC/Gx9YHl7xcRGS0Kt1CG9+XSraGi7ww31b8UWuvKp5WQrB+tGyc48cXHv4IyMOq3avHO6gevR3HrrUkVz6JACmSSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wJtZHI5c; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b3825748c2so8791727b3.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723832764; x=1724437564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vHU41TdFfuYSxHFsH0hBT59EzOX4pM0RwY0qoH1omnY=;
        b=wJtZHI5cZJeo4CjdwaXHO8G5sGwfDwMwfrQi0ox/oO6twFWrMLVtIwnftmIOZpgsRK
         oUCCAOriz1X289HRNoQrbOZWLIFNZ38vHGiukv+hzzCBUyx3p6wStRh6R92YkAHlHNfs
         FS/mzOVSYePmhLfr8Lo+gTXt9Ze+zO4kkZyzRQz0sFbrPkgPjiCFoN4bwrjC2dC+Ex7c
         NTODFMpxcRWxkzgOhSGIdya18gZElmtPY5A3oN+wQ+W7udT/evRjD+vbdKmeicxoJWVH
         eMnwLpN/IakUOLWDpoXRw5/dBfA/8b9CsIfNpWfPja9wf6e4hjBcQMrIWaXgF8hCJqi/
         /LBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832764; x=1724437564;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vHU41TdFfuYSxHFsH0hBT59EzOX4pM0RwY0qoH1omnY=;
        b=iBi7GYzHmsefWJAyixgO8/BvnHqXZxOpkCLMGbLFXBWz/1Dr7D2rpJdFPbZAqvDk/W
         HQbJ1pf991fRIiDLG+vPF4UuXLz9ZUt6zWhCI78DdE7M5glALT9i470jFNiBESgE4H6a
         ttOO6AlTUgw0yMM5yprTTCdqS8SPWPEZOqkBbpBTeqFpBvuI/Kq3nA/Wf9oAZi9M7IZ7
         XlrO+RdWxeDRJmzvwB6VcHyHY32rrqzOCh42EYY8mVwr/UubqqNwWKXxHB8V08uPUsBP
         GpE4aNiPg/1R+scTCSG/RW/srwgqvAq6dPjJwKSqQ5DJdEE5OaYlKkG2YLHOZWg+ZkJW
         VK/w==
X-Forwarded-Encrypted: i=1; AJvYcCW35vTUoWlOLQMzhoju1qTObZUewAyEFIUGgWJFJhl74ENREiuXAk6yvxVIgUGgbmy0A1owcnxttvHtc7fPBDMwWPOj
X-Gm-Message-State: AOJu0Yy3KmB7PxRCsAu3XHZXIFtJ8wWgthpz2F/CrizC/yrncfiewYDn
	iymQ4HYsbyQwZyhSbIYtYd/kd8NRXf2COBQ6M7xjbm56szBw0bTK60p1KnvocTzq/PCzvU3s88c
	B9FdESSH/WA==
X-Google-Smtp-Source: AGHT+IEJc+hFQIAnQCVr0tRCdxFBw2gcFs1n3D9qIS2qPVf+9CWDN63ejNRhGhy2SGZLXx61jxNCjlGe4UDROQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a81:a253:0:b0:650:a16c:91ac with SMTP id
 00721157ae682-6b1bd17dbaemr975007b3.8.1723832763870; Fri, 16 Aug 2024
 11:26:03 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:25:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Message-ID: <20240816182533.2478415-1-jmattson@google.com>
Subject: [PATCH v2 1/2] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Daniel Sneddon <daniel.sneddon@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"

AMD's initial implementation of IBPB did not clear the return address
predictor. Beginning with Zen4, AMD's IBPB *does* clear the return
address predictor. This behavior is enumerated by
CPUID.80000008H:EBX.IBPB_RET[bit 30].

Define X86_FEATURE_AMD_IBPB_RET for use in KVM_GET_SUPPORTED_CPUID,
when determining cross-vendor capabilities.

Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..e5bcb428dcf9 100644
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
2.46.0.184.g6999bdac58-goog


