Return-Path: <kvm+bounces-38219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC6BAA36A6B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8BD2167472
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9A219F135;
	Sat, 15 Feb 2025 00:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qyAxXNkA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606A619DF66
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580933; cv=none; b=cpByijFCZWJDSLzJUJjz2UQys/WfvE7ZzfgNbJM8/LLudUKG9dsLCKx/dNwxok1Q1S7yJb+Hr+FaIQcWDyBfQ4b2/y8vKlBtD769XX0g7T8fhG5iM9fc/v6n+bmJdBpovYSW3jbxkUTs6NKtHKczSYmNpkvnUhDyQJy0vuBjtVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580933; c=relaxed/simple;
	bh=68VFRIl+xc1L/75j6iY0S/Wl8JQROicz/5dOe9oHHq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h3SzfgFYWu6F4udVrlWVPJtvDd3wDIDjLX290jwQLq0BUE8XDq8+38HnhvqXs/k9aomOJKElvap08MR6wIOOEhuwExZrEs/gsU4WefV4VSSUPkpukpudkIXwZjW+jkm0NcqO1T4lhOKTCJsQVMD0858YsCcJz7dcpKpYm6R3TN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qyAxXNkA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so5451850a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580931; x=1740185731; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=56aQ2Qk/DRzp8WAxYWFnCTM+2eFzUvnAZXywRsNSxP0=;
        b=qyAxXNkAXJKoatmWb4gThI4Da7BD9WSUCEzzb+HdWnlthe1iclUdZ8MuEjCcZexbUn
         F2O1G1zo+2AMY/IRoT34AZKE5algiZtQJo0bHvWiBLsKnZCIf/w6IMyNvtfcUXzetUCB
         SaabB4VEUhCmxFaqKKyA0EcXbl7jHeDebl8urt6YU3M5JbyqQPino+nUTJis7xDUu7wg
         i92CcQR5RXmcvQGrPoCiRvqte/DENOTuselpqNImzikVP82WXG5HJMOdPSW7fdUlvXxy
         Y7NkcLiKR82KJHaT46zvUHzQIu9eF/ccoArwgVQu4lxwGIl4PnIeVs6+mWT+LX8RZp7A
         Fxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580931; x=1740185731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=56aQ2Qk/DRzp8WAxYWFnCTM+2eFzUvnAZXywRsNSxP0=;
        b=fiI20qTC+xHpwOpg38GXLF9fnGcTgBSo/hxr7k5OGSj5z3PGvokmnpJ5YRww+Varzg
         O61uInwy7yOjQIKvrwjRkSBlUstcnwID7Wxs29upoxvmB0MrG9TuAhCzO7oTVRRdOMjT
         UX6z+zETfKD97ZfsGT/eCwEo4Lc83MnVNorIAyNXbCtNR4PNEF1oLDZF/MoEC1foi4Uw
         G0Hb8aSKjwQ0gU7HlrKwLT93dTcd4M1PeSme0fFl5or4yVCfLAZR/DKt1Q2xDicdEbfl
         sZPp5owt11Ka2OQHW+1jl0l44t4SiCGePoy/R97zuYDLwYhxe29ehINk1InDgOH1/opG
         7Ctw==
X-Gm-Message-State: AOJu0YxVrEYXPAW6+R30aw5Yt6LtTqU+1mYhqJhlXj9EYfM8Dn3QFB+L
	tjXPcRm4aBjDMH2H1K5gOsL9NNjezxikAdk12+mGxu5q49DOqLpqFs9pnRZIGD1J7/eOrjlQ6GN
	Bng==
X-Google-Smtp-Source: AGHT+IGyvtQQWXADk8lCEzYp1fU93ug028j5fgeYFEMqyAAIAbECiz5cr2OJW16LXlMaGwRDbntzJJta9go=
X-Received: from pfva12.prod.google.com ([2002:a05:6a00:c8c:b0:730:85ac:c785])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7303:b0:1ee:8c93:c90e
 with SMTP id adf61e73a8af0-1ee8cb4f81cmr2586629637.17.1739580931606; Fri, 14
 Feb 2025 16:55:31 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:22 -0800
In-Reply-To: <20250124075055.97158-1-znscnchen@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124075055.97158-1-znscnchen@gmail.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958009882.1187766.16417682288945996638.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Remove unused iommu_domain and
 iommu_noncoherent from kvm_arch
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Ted Chen <znscnchen@gmail.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 24 Jan 2025 15:50:55 +0800, Ted Chen wrote:
> Remove the "iommu_domain" and "iommu_noncoherent" fields from struct
> kvm_arch, which are no longer used since commit ad6260da1e23 ("KVM: x86:
> drop legacy device assignment").
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Remove unused iommu_domain and iommu_noncoherent from kvm_arch
      https://github.com/kvm-x86/linux/commit/dfcbcd864edc

--
https://github.com/kvm-x86/linux/tree/next

