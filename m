Return-Path: <kvm+bounces-60556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B9FBF2772
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D692718C2283
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB7A299A9E;
	Mon, 20 Oct 2025 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="he4OPorl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5421D2882B2
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978064; cv=none; b=Mjni0G/S7wn1Zq2fXTV5lKBCuw4mwQi22mNT3vovUC/fei3Ju4kkwsX/IAKii8YTBWDaxiiE0ujY4zOQMLIh8YHe9bS9+YIP7i5/PEEEVGyzDesVnHuTmDA0gDu1H6aJArzHUJ886CF2SN7Ha5dHMw/DaQubNb48btsnDxe3vNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978064; c=relaxed/simple;
	bh=F8ZdKqCUkWnsHutIEohQCtijUBZ361J+n8QK9owT3uU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=j+VAaTxA5DXCn54xYywrcJXjjhdvhPFvxF/BzPa1dmqf91Lml6dNW4a67Slz1v0WbqJ9ISmT9kBOqYTeCd/RShd2InZga2jlKdVrLxhAzTXJAp7TkhMHgaOzuJ6bVBbYIUTxAGCXS21Vsd677ZK8XQGd+WGEwa0QpqQIK9f9Wn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=he4OPorl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-336b646768eso5189606a91.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 09:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760978063; x=1761582863; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fYQ/Yn18Ayoanetc7EMDhQDCxuQe3WF4K+kRhMHbYxk=;
        b=he4OPorl1MSCAjUR+EoQbxO+764x2Pzb9OfmOlbjcK8GF3Qqj5nApUNmafQX3BRO34
         N3B4iBTFoZgbJjqhnGgqfrOWii5G02LTM83eN/fmIeVVTP+/wRA8nfez4U2HsAkmBOKq
         nGv89b7VQsSFJWvcjVnmVwCs1fLyPWiHFQPbhzvW6N0zGb59UXtci+CZHYvK3DySmk4r
         FeZXLrMFSWUKewQNMwjLbXmjq9FTzl/VUe9yWQghti5Sw3Qh6iCciEniSImzyYLfOKT0
         mrBLGxdh2m8Me60/uvs+WVNE1Ab+8BhGgXL0wEW/CSv/55d/p6fXU1gK+HjH09J1UaID
         g3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978063; x=1761582863;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fYQ/Yn18Ayoanetc7EMDhQDCxuQe3WF4K+kRhMHbYxk=;
        b=Y5Ck895zyMmeqle1mYDkcW3uOYHDo/JNMgdwGNT+wt+jOQJKUR/xs+7Ljm8/o5COKq
         nF69hpHd6cPmPMfGq9rMow1qklfoydvY6BpSMkZ36mkY3fGTknIJrzQJtkLUefzFBgEi
         QOGcqZRNEV+qTZAtDAuwSp7xf11qzk+HhieOt2agT5agRcfylwIPzEsTmbO8RlmSQHou
         ymmPXh/TcmcofoAWkxjx0Dym10vBN+kVPnP5SAEXET6iWpE7N+3N7Y3neBp1xk8Zx8B3
         a979E5Jfw84N7J/GdTtZXEQ+P3JzK0errz2KozzNsQDy1PmSwcBt4k3CoBhDxyyf9juP
         R7Gg==
X-Forwarded-Encrypted: i=1; AJvYcCU8wVcCTQ8zBCLnpaCRZGV4nCixKFAa3bWX1Woqk01lOmcsTFrQVjcpX6Esv5YKmZo3Ej0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpE6xd4mk7ROw2Zdfw5Pbhl/4vMCwAleQkYHjCeX5yxhynsyTa
	Zqb2kA/hgIyoHK5wwv4IgN0VFlv/l9ePUO1b8tCODlVu28QjQYkXboF8A2jeQjsIIdMCRieuFwj
	f2g8kKA==
X-Google-Smtp-Source: AGHT+IHoYRl16lpIP+uyPt5I3BM/0tRyAePCPWMvseRm11XXxQgSDztnBAGX8rG9UOp1y8nNUE8XiktEjVA=
X-Received: from pjxd18.prod.google.com ([2002:a17:90a:c252:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fc4:b0:33b:b453:c8f0
 with SMTP id 98e67ed59e1d1-33bcf8f9008mr16976543a91.25.1760978062794; Mon, 20
 Oct 2025 09:34:22 -0700 (PDT)
Date: Mon, 20 Oct 2025 09:33:07 -0700
In-Reply-To: <20251001001529.1119031-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001001529.1119031-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
Message-ID: <176097608821.439830.10295341588067424162.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: SVM: Handle EferLmsleUnsupported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Perry Yuan <perry.yuan@amd.com>, Sohil Mehta <sohil.mehta@intel.com>, 
	"Xin Li (Intel)" <xin@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 30 Sep 2025 17:14:06 -0700, Jim Mattson wrote:
> It is no longer the case that EFER.LMSLE is supported by all SVM-capable
> processors. AMD enumerates the absence of this feature by CPUID
> Fn8000_0008_EBX[EferLmlseUnsupported](bit 20)=1.
> 
> Advertise this defeature bit to userspace via KVM_GET_SUPPORTED_CPUID,
> and don't allow a guest to set EFER.LMSLE on hardware that doesn't
> support the feature.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/2] KVM: x86: Advertise EferLmsleUnsupported to userspace
      https://github.com/kvm-x86/linux/commit/4793f990ea15
[2/2] KVM: SVM: Disallow EFER.LMSLE when not supported by hardware
      https://github.com/kvm-x86/linux/commit/c53c632592a4

--
https://github.com/kvm-x86/linux/tree/next

