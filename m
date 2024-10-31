Return-Path: <kvm+bounces-30228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 28AC59B83BA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:54:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D46811F226F1
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895681CC888;
	Thu, 31 Oct 2024 19:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rf1dY3lO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022B61A2562
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404446; cv=none; b=kybojnaLyztST4f6tDULY4JtkoHoPNTvg+CM2mo9mor/Kb2WN9+ojpmqps9Zn7IzfzfrlY33ie1XGu7MFOFwIRFiGc0KjaryyAOUa8oD52HXlALIt4egakqB0YzovYAkoMR+v8BT9c9oxPYHIBJVFHzlxV86IDlqPuPXE++HeYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404446; c=relaxed/simple;
	bh=YkBRNFEsN35dGfxgWRIwToGQglmdje/bR992AmSVZ2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b4yKrFjrvUPNIOAXFHqnaI2r660o9moIYo5RNb3I2Oya8r2MtbgtUZQO+EtF8EXBVx/s2U40dB7Djf9Rf0jd+l+ZCRLaXorGC96aVKU0ptBJ7CHL2baPZEDoj0eAEQXo+HhOonDc3uFdsMw4ymQfbLhwChS4fZd5hvbs1mOelrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rf1dY3lO; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20c94f450c7so17394785ad.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404443; x=1731009243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tMWwOWR8YlKBIDqnosPHW958i6emqG1WTA/8O+fCvsI=;
        b=rf1dY3lORaeWFkqbnf4zpb6HSwlpXXhCjenwOa7KG4sKjuop7nd9dpiLNRPxmPO8bp
         I2Us7KEdcyI6A0jPjnnqdkIgP0qzimfnT6FKPtB0kYLH9LDz+2ROKHXPSjYdW2YYmMxg
         gObfUfIgb8yE95U9JImyfm74GgBfmlfaFjUlUepqouroQESl2ww+ofIPmv1Kuk8oFlSz
         fjCI6FYHDeZMVapP0w+BZUoBO/UQlddw2JzSjms8Ju+97YCEEIJfooneNbetQGN2IB7n
         hKvDlhUpsGD16hOe4sfwp+eVmFB37G+3RlpnKRHbVG9Aisp8v/xNh/AEME/GrjS2lxxC
         fWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404443; x=1731009243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tMWwOWR8YlKBIDqnosPHW958i6emqG1WTA/8O+fCvsI=;
        b=aQMgIChfszKR97YO61Y8Vb01dsN7GcKn79Y22zy9paFfld/DUirn07KQXh0DlGs9fD
         kWTWCpV4+PFq+f/i/Yvrmjy+N0rGGfYeslG0nPQgy5Aez3g4e7pBSFQihdpuPGqEmKmZ
         JiHAHxqweIhKnY6VtFbUeprKWbAsX2rUSZ7lKUz8lZxN9WC+s/dG94PVolGv4zxDc89f
         FuuU9gCEM3Yk6kSb271Cx06WtLBumYD0nImw1bImmsUUFU58Nv4v9F20h98JjQp9Iqf+
         ObOV6vBkLrx8ZkfRq67Qa0B5FpDJuobeyLpvvswEnKi5OO+zLO4IlowJzYCY4Gq9wbzS
         ONmg==
X-Forwarded-Encrypted: i=1; AJvYcCVV0tEVxzLfHmcfu2OSRL6dephBpUff7qLOqLL5rNWXazZAZY8+/M5JtQuvM6OHPC8M7O8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+PkG1kEkz+K0+lVrfmHCdT+2bGf+Y8V3VFGPOZu3o/xU174Bs
	SPD/Bzbmp90NkQPU+DIMxHxb+ffzgUpvQA2eenFzoeAGvWgzGFa1PsY9+uu0rxP1kYk1wb5qTXr
	IwA==
X-Google-Smtp-Source: AGHT+IHkmW04UVeplfmm6k9u29eDQmh1Q5dvhWh8Q5TKZvWf4BSK1EHAifK51R77vzNuuNteTnsMapgSrJE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:2310:b0:20c:686e:28c6 with SMTP id
 d9443c01a7336-210f729e85fmr710135ad.0.1730404443326; Thu, 31 Oct 2024
 12:54:03 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:33 -0700
In-Reply-To: <20241011214353.1625057-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011214353.1625057-1-jmattson@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039500211.1507616.16831780895322741303.b4-ty@google.com>
Subject: Re: [PATCH v5 0/4] Distinguish between variants of IBPB
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jpoimboe@kernel.org, kai.huang@intel.com, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com, 
	sandipan.das@amd.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 11 Oct 2024 14:43:49 -0700, Jim Mattson wrote:
> Prior to Zen4, AMD's IBPB did not flush the RAS (or, in Intel
> terminology, the RSB). Hence, the older version of AMD's IBPB was not
> equivalent to Intel's IBPB. However, KVM has been treating them as
> equivalent, synthesizing Intel's CPUID.(EAX=7,ECX=0):EDX[bit 26] on any
> platform that supports the synthetic features X86_FEATURE_IBPB and
> X86_FEATURE_IBRS.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] x86/cpufeatures: Clarify semantics of X86_FEATURE_IBPB
      https://github.com/kvm-x86/linux/commit/43801a0dbb38
[2/4] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
      https://github.com/kvm-x86/linux/commit/99d252e3ae3e
[3/4] KVM: x86: Advertise AMD_IBPB_RET to userspace
      https://github.com/kvm-x86/linux/commit/df9328b0ef66
[4/4] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
      https://github.com/kvm-x86/linux/commit/d66e266427e4

--
https://github.com/kvm-x86/linux/tree/next

