Return-Path: <kvm+bounces-55053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0117B2CFB6
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA6151C416B9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05561277CAE;
	Tue, 19 Aug 2025 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="actnGd3y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A625B30E
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645207; cv=none; b=TGZfOtpNJDm9JlQ08QeXRfrgyznvY1ntXyldhN+2MLY/3L3cbURIM+wwfRLDf02OwwvVFFUpB+LuETEBYWLL2PJJS2g+JtwsPOWP83nEjzhLWCV5EuJaO5HzfEK3uKVP6CSar1mX+asH32S37ZKHWyzj8T4DWnXWLC7TPRBTIBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645207; c=relaxed/simple;
	bh=p++GG/ObvF+SS6gDWcAUbzhAmmexypAi0D1ulUdCK2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c8FeH/Qz18rVdK1zAYs/DVOiRKae5nBXulK/AAxdjNVp4o/Q+yPQiRAuusKKch5/R2Bu1sgy5jNzDLD7EvmP/yU3d9Cht7uOyIXQPyTXfjZiMvvTfU5O2zhgaPmk9q4btPmUUuMjeQZeZEVHKzy3DghGsqzfXjZ3giHXy5C+Pfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=actnGd3y; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445806dc88so146324205ad.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645205; x=1756250005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P2AqbEbgJChiE/jeWfGZrim3Ra7yr8HvmGOhQDLGFW0=;
        b=actnGd3yCrKjoDrW61rmtJzlaKTZNC3l4ezee3UamZAxONX1fGgZVIDxpal8rvrz6+
         bBpVfrk+C9ocYqj5YROJ9wCCAS2lAU2J+/04P53KtDNBzIvxqTG8qdT2cEWZCMMc9guC
         9hPYSwxIgRJc4ftXLHdsGXFz3F/ZyP7k5qvtL16Hzn0Xd+xfgeDDUt7lQZopsQ/7duRL
         AFd1iMLL4t+j4CUuz8mc9STA1uvqsqYaeuDbWhcM8yVs4lAgznJWVa5Jr9mfN5i9WMrp
         4/z7aqj5S0kvFUT/54CcfYvPZhh492rGL8mA2RUfjuYphEtCtq2tfskFTBSJyYiEArRh
         rV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645205; x=1756250005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P2AqbEbgJChiE/jeWfGZrim3Ra7yr8HvmGOhQDLGFW0=;
        b=ZkIQjDGQ1gTaMX1XvfBMEOxRoUBkO2kuOROjhw9HR4pIjPxk41WjB8mWH/dcpPuroZ
         mH8T7EWTGoUq96JiCLZH1+7fDAYpOaj0HkaehpKN6o1PvP6onj18ehUdaIR0K128NBuo
         Q9UMju9R0c58mOtSYhnmZP/EcinR3+b93aB/uY4gVpk3laui7Kb1q14MT23mGJ9mxl9n
         ogxmHk0nmwIv/Ql1/2fybW9LaJ4cyNsA3q5XfJIVZSBzvSL55HzssGz4hhSkhQ7AUr88
         x1BST/suHBF7zoS9MsIkN2/rGWaSUPaUyUvnTDL+iLpblcctKHiBEFhhrDScH4b6Pz0A
         Z5dg==
X-Forwarded-Encrypted: i=1; AJvYcCWWpOaKnwSOIAQdk0fvitx2GjfT4h51ynlDFBUr7MmtM4PbZKP6Ew1hnhmk+DC5HuTwnkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOGDZs+10ina+oDEk9EhMq8FCzNwmmaBUVrukXIYI3lB4TzrB1
	aIl1z+PKgjGKVLb5UKUYH43bOqj1NUKSNad1lrD/ZSLsmc/9PuHDYAZ+euuLKKZRiujLtI2hC/q
	TKwynGw==
X-Google-Smtp-Source: AGHT+IELQdhlYrR//sHGRCKXtQ83DOPYrULud3cOubQ8r5LmPFAQWcs6NmK7qDt0JhFzp/fYFETvlZziMrY=
X-Received: from plbmo11.prod.google.com ([2002:a17:903:a8b:b0:243:93a:a69])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d503:b0:243:3c4:ccaa
 with SMTP id d9443c01a7336-245ef137424mr9793635ad.19.1755645205360; Tue, 19
 Aug 2025 16:13:25 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:11:53 -0700
In-Reply-To: <20250807144943.581663-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807144943.581663-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564425450.3063067.5245793553248033855.b4-ty@google.com>
Subject: Re: [PATCH] KVM: remove redundant __GFP_NOWARN
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Qianfeng Rong <rongqianfeng@vivo.com>
Cc: willy@infradead.org
Content-Type: text/plain; charset="utf-8"

On Thu, 07 Aug 2025 22:49:43 +0800, Qianfeng Rong wrote:
> Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
> GFP_NOWAIT implicitly include __GFP_NOWARN.
> 
> Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
> `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
> redundant flags across subsystems.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] KVM: remove redundant __GFP_NOWARN
      https://github.com/kvm-x86/linux/commit/cf6a8401b6a1

--
https://github.com/kvm-x86/linux/tree/next

