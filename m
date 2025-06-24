Return-Path: <kvm+bounces-50549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 914EDAE6FF2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 771C01891096
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA842EF283;
	Tue, 24 Jun 2025 19:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Bwdt0xZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C432A2EB5D9
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794121; cv=none; b=kJwjzCg7SApkGyMg3QOyARk1lF7gpGdJAYVjVkgTjj4OnePu1lukQGClRPZHI7HARwmQVODxEAmhlU1XR1p7rgcJaE+4jEk5sS0Qv7Ucnp7i2MuytAb8IJF0NPZV5V5q4IT2Th0QeMHkoF/TbjJmbo4/0vhLVcsA7lKEzms4U9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794121; c=relaxed/simple;
	bh=c/7QgBTrR2qs6GVSzENovKFJo2GjCJmS+ATCJzF80rc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZRFE6gV8GwxHz7qFnKF4t7fijp5UwrxT+SJi9iI/NjA329bDJAr8x4aJRFyuX3qhik9doWnhHIO1gnqe4/+eoNy2RHAw4amQreLgzFaR+S3vhTFhLoLQlWIYVgafbi7FcU4OGrOc3A5D7JWJFKhEbCaLoJaC137mCOci7pubmcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Bwdt0xZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2369dd58602so50352955ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794119; x=1751398919; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e64Qv/Pt5ojv2npJzdDOICaLHvJLt0TAvdvtcs2VlQE=;
        b=2Bwdt0xZoUmk7EtuyLGtFBGwNp4ccXalG49eIC6gX6mrMfa3eMH6RJGhEPl/D/wuQL
         WugBDFur7pKvWcBram7qHgwqArtUuyfTy4pNmtclDNGHomyLiApHvBA6Yt4KD3J4GU7W
         Nh+/Gjjd3GwBz5ovLg1WvUpaRnoO5agTWxoUH+AzRzHlVwLtsrDGjfvvehcfga5VBd5L
         JC1NfqXa7fCyHg0/9cysmBlBB7QPoH5YKd8t3dgFt49DORnx4oST2PwUe9/GB/ojHnYo
         3aASpqsDRVcTfg3ZJ2RS06dv0zCLZAI+DOFck+lntd0azdK7HUYz7aB4a97SZkybG/IJ
         d6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794119; x=1751398919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e64Qv/Pt5ojv2npJzdDOICaLHvJLt0TAvdvtcs2VlQE=;
        b=U0c1UqnkPObo4T/q1sTHQD8T9glHkdjq7JUXKPSdGpD1iFZZRtFQwqFdCWmHG0QO9R
         vqH/dALG8jAERGO26tSlqY7GcdcSsMTrNAWR0366cUEJd99bubHTYMJGiPf6wPymQf1H
         m8dmVfGKCYmPW5IVDpFKJs6f6vZBOSZ3VzgcUZMd4+5M6YYBTVxwUV1cao/3jQkxpg5N
         O8oxmRY5QYraFdiuk5XswJ/dGsackGl/qVU5rnUCa62mk1FSMCH3IGbUgJwNdFBV8kZe
         D7SPQYD5BEJBMKq0qkqMSGE+M/gtERuCu/SpsAPi4EiSzPw+FC/D7Srxsr2rWq26NE2+
         EBFQ==
X-Gm-Message-State: AOJu0YzMHEDzmb+nTaBC7V2gdLWHOSYQBugiCWN/A+3AYzcAWoMtfndT
	bRisvV7fxnnFxP6+bJIUSLVPDjRN7qvxB/Tb9wtRlgz8HMF6mkcI2botzfY+KDd4+UA2dlRiZBA
	XOzjjTw==
X-Google-Smtp-Source: AGHT+IEVTUFFWM+7ReoOwe5q9bU7aGMuWtAYW9EM8tyJI0p++Z5ywj3KuSfop6I7e3jDpuwYECcsURxtmbU=
X-Received: from plkk15.prod.google.com ([2002:a17:902:c40f:b0:234:9673:1d13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef52:b0:236:6e4f:d439
 with SMTP id d9443c01a7336-23823ff236emr7903665ad.23.1750794119123; Tue, 24
 Jun 2025 12:41:59 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:36 -0700
In-Reply-To: <20250602234851.54573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250602234851.54573-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079322774.520923.14554474229751214016.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Exempt nested EPT page tables from !USER,
 CR0.WP=0 logic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jon Kohler <jon@nutanix.com>, Sergey Dyasli <sergey.dyasli@nutanix.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 02 Jun 2025 16:48:51 -0700, Sean Christopherson wrote:
> Exempt nested EPT shadow pages tables from the CR0.WP=0 handling of
> supervisor writes, as EPT doesn't have a U/S bit and isn't affected by
> CR0.WP (or CR4.SMEP in the exception to the exception).
> 
> Opportunistically refresh the comment to explain what KVM is doing, as
> the only record of why KVM shoves in WRITE and drops USER is buried in
> years-old changelogs.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Exempt nested EPT page tables from !USER, CR0.WP=0 logic
      https://github.com/kvm-x86/linux/commit/ffced8922050

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

