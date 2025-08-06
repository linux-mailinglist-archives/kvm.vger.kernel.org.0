Return-Path: <kvm+bounces-54137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3215B1CB30
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 19:42:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29F6C562B45
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 17:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554A129C341;
	Wed,  6 Aug 2025 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="goQlNm06"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF2925A2DE
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754502150; cv=none; b=P6oMbHgC4ydfyk5qk4hwFfJZ6Hytlfa2O0EjK0gAhFTExLnLBXXGfF6OtZDgvRSjKHuJK4q+VFe4ieb1WEV+AOZSKgXLP3IHn1gfDL23Iwd7XUbc1VpEc7AM8jPs32jsseBVYH0KQk3/RT9ba5zKUH9fpWdEC9zwXL1liHK98Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754502150; c=relaxed/simple;
	bh=1CPu9lCy0nvdi/L1p1/8uO3fkzxuerfbGvnecx5wZ3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=iQd4mUOC7+jJX1k88di1cS2DdX3xUbIAzSy1E1ZUD8+zjMtkEYPPrtbCIYB44BMdYOPByfjw7qtXGaB7XXp7TV/ynda+srQspdEzcENvXk8f4YyUDTM0JDRvYVgh+Jf3pfcfLJ+EuO4is8si5SsihPkniV6MwsNEyDNlqGZRVt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=goQlNm06; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-315af08594fso211683a91.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 10:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754502148; x=1755106948; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kF9bpK1qdUp80ZClzRswKI8Qf4Ua9KldMhdifkuZo5A=;
        b=goQlNm06WHZgJRapjTxt7R/TcRyiYavrMYBtU4hmo4uzkAlMJbeCxB8csRwzAolnN8
         ZPP9NIY5cRfYYFplGmGxSempalR2O8dG3LqmC9fjh8daHyrXw8lHwdOrOjMyBuBI/z5h
         URx7jDzp2kDdknl4430tJud1f8asOCruSHZKnZAJg1+lu9Qz8Uo5xrA99PoXRgXUdpB/
         SJS4aHJcbiMIz61P+Vb76QYkNHL4JKa1GyFQtmVMcTylJmdbsh4hU/9VQzrAJzwaowfA
         VKd2ilHFkvRAfQA+WlTkCTuxdcwBjnzQGMRzkQX3C9GlTCcH0UH2ZrG3pOJvQppveL7+
         6mpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754502148; x=1755106948;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kF9bpK1qdUp80ZClzRswKI8Qf4Ua9KldMhdifkuZo5A=;
        b=hOP2oDkBLmEi2qrc46x63UpazjyEVXGPdSMLy0nkfngykYhFbvW7OS29+D+DyupVHo
         VR7nx2Kixv9kuDSpW4AeksGZE4A5/nwitfBuWckdfLqEpgC8RaFM0iVTKUzUZVt9D40D
         dAVLJbUgvqX/ze92xgN9wwDjTS8gHqvghniWqrW8rdYsh1sEZOs3rBTt9rn+jY/kUKnu
         WPCFxsegRbyFI6hpNpxjtzHQx4OLAg3NBTVVLO8x/FLc6dCazp2DpkBmFxNJAa5dcKa+
         6bI+qzX4CPV4PAZH4bb2fenbYa6rlrJTNZOeOClaYoC7akVsTBsYse0RapVP6RRZB7eT
         If5A==
X-Forwarded-Encrypted: i=1; AJvYcCUewVLom5gI+gz+hZ2hsAqqGMfIURCZ3wVB5DpQVo4gYC6yecdcyqS1cpoElabfRexjXE8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjPAaKot7UqDE332sI2GYIKMZKQ2uDPk2wCxyxFH0VofBagq6+
	bMeYSfsSOFZgDUyEzifn/stNg7CFGMFKWnX7wOFECOVUI9HnNdFx9NIZOU9KMiuVUZxoaqQAylN
	V9/frkQ==
X-Google-Smtp-Source: AGHT+IGxbih1aPqy3gB/PvUjHaW+i+ljUGZQWDmJCtPz45aIX373xGbdvRWIDafeWxu+TILTrn0k5Ma/L1w=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:31c:2fe4:33ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c8:b0:321:1680:e056
 with SMTP id 98e67ed59e1d1-32166e093f3mr4752885a91.9.1754502148561; Wed, 06
 Aug 2025 10:42:28 -0700 (PDT)
Date: Wed, 6 Aug 2025 10:42:27 -0700
In-Reply-To: <20250805190526.1453366-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com> <20250805190526.1453366-6-seanjc@google.com>
Message-ID: <aJOUA36kOYklPzXt@google.com>
Subject: Re: [PATCH 05/18] KVM: x86: Unconditionally handle
 MSR_IA32_TSC_DEADLINE in fastpath exits
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 05, 2025, Sean Christopherson wrote:
> Stating the obvious, this allows handling MSR_IA32_TSC_DEADLINE writes in
> the fastpath on AMD CPUs.

Got around to measuring this via the KUT vmexit "tscdeadline_immed" test.  Without
the mediated PMU, the gains are very modest: ~2550 => ~2400 cycles.  But with the
mediated PMU and its heavy context switch, the gains are ~6100 => ~2400 cycles.

