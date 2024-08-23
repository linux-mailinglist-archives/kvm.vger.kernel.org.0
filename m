Return-Path: <kvm+bounces-24934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF0495D596
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 20:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DA771C226AB
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 18:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67364192D6F;
	Fri, 23 Aug 2024 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sFbdNYcq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DA21925A2
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724439234; cv=none; b=qkAH83/hB9xcY3l8Buq5pb4XIKMZyDNC9p/BpCaW61rccPhBfzm2vTPXnmk9rQnC9pCtXFkKOnh0bjFn6umfFBEVqfc4afUbGKS1qdaphoUwP8shYed6BO5WUxS47WSVFDwDIwihfeG3d1JuvsEd33WVvpAgUwUyIPSe46EubGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724439234; c=relaxed/simple;
	bh=uHc5J3RzDDJvtU0LNEUNZxZe+FsaP8Fvj2w4uMXoM3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=luRx8bV42nM7LcYBai2XBs5bxr+b4QkJkZpIgHm6dJarZBpnLSef7e1pYxEP7j6ZYmpG3B+TQOsmSyUQ70RGqIFBB0uDHRlG/5Lh8e7yS9H/G8Br3irHccAo95GqUfWG5GvhavG2CeTzMnGHHwSfLRh5yz5rT3a4sQP+75YEitg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sFbdNYcq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d3df5f6c80so2181975a91.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 11:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724439232; x=1725044032; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZETR8JbkOV1DUbkusF4BDItYK3NtrFWqCwoBAa+9Gio=;
        b=sFbdNYcqRmcKQ7HFOIGjvBRzSpspUOI2JNCBeFWs7buuZLHBBBT77n7QnjF57WUhSg
         21o3944SEu9w3XR0w6Ifzj0h/8HRAOFdFjZ1HO424hXQjXlt6ODHwARoOrp7DwG1ig9Q
         fLmULbOBg8j6pud/pYXsNBFIVDsvoWycfGvakhyMp4EexZSK2rhHn3uKGQeaP6nTcnKk
         vQdmyPQ9dbuMfSSDroQTo90mh6eXSH59DFsl5j50GtIXpihIn8X08K5fMieheSmMKYKQ
         /djCbtgOYYuCrhzxjs7jeojY4iuMhV5KSmITyf4h5lpkOC+fOIzVa8DpqGdCmRz4VChi
         zW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724439232; x=1725044032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZETR8JbkOV1DUbkusF4BDItYK3NtrFWqCwoBAa+9Gio=;
        b=d/t8r/kdrWYukWmM5RKWjevfnIvGDF4cvN9+ftt33wipggX3Tb9tTb+vI+a6frEdHI
         ncLb5CIOI56xL7ymUNInNtDHQTgNH73D0TTFnpxA7pQuMBLZCV4DfAmad8ecCYLTqZnm
         jYaiozWLdJrl4jemiH4yzZQkovT2ZuiXcUzmqDJjNj+mukoaLACP7VWER7wniNw92quC
         rr2/bqjMzzNrRZFppsa4r5K2GcDcHZ+3mIGMSj3eroIWSz72k1K4w2LHl1eBdMZb/OZS
         5NbF/kLxVWgiIMJEdSxf0ZffT7Nt5sVc/XgTVbczBY/FFLakJP9+ATFMy0dqwjjZZ3uM
         dN/g==
X-Forwarded-Encrypted: i=1; AJvYcCU/P02hb72Spz9ki7isXvU7PBfqIplz/c1D4nadWpMOKK2e3LU3jzhScuPQdo4qZc7iDrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFDWHHrnWKXLOMPqns2MGQUvY2C4ZAmb5tMi4yCVlUcb7ZAprA
	1heEbFZqx080Wx1L8BqC1aSTylSp1KTU3wU9szBqqS/q92ApPpjymlsDxIzwNLm3nRoELZd0Y3f
	e5uqf3Lh47Q==
X-Google-Smtp-Source: AGHT+IFrE3/dZuZEWBYCH+nx6VHpdfBAScy4icMsZdcE+pOFSv5UyNOPdpTb+8GRWuu32pm/OiOLJ4TxN42mBw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a17:90b:33c4:b0:2d3:d084:6da3 with SMTP
 id 98e67ed59e1d1-2d646d90759mr26893a91.3.1724439232349; Fri, 23 Aug 2024
 11:53:52 -0700 (PDT)
Date: Fri, 23 Aug 2024 11:53:11 -0700
In-Reply-To: <20240823185323.2563194-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823185323.2563194-1-jmattson@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823185323.2563194-3-jmattson@google.com>
Subject: [PATCH v3 2/4] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
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
index cabd6b58e8ec..0ed131f160dc 100644
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
2.46.0.295.g3b9ea8a38a-goog


