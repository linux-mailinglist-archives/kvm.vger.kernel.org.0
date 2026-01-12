Return-Path: <kvm+bounces-67806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F96D14740
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4D2753042FD2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87BCE37E312;
	Mon, 12 Jan 2026 17:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X2U9sS/3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F385283FD8
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239682; cv=none; b=QDAEzy7hV87ZO+vt2isl+AQq6sJCDWne6sHqj6Dho/V9otU4mxinU8mgaUZ6puON/pN0gtwOhIP/VjjRorci76ziKN22jEbXFUAzPQD8s9DGVwhVMPcdoljflhpwAQK3Db80vFxMX7BHabaa13l2FlPOFXkM/XV4QxPR+j+QeTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239682; c=relaxed/simple;
	bh=zhqTsd5ok8dD+3LkytZb8NSNe2fmkzHc20Cg+IZR1ao=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gcU5Z9KibUvL2pwEC5tFoRcE+SPPYb3kFmb/df7peEa5n+8rbugtT8Z2FUxU3L8oc1Tmbxv9t38yPK4iEXW2yiLzG7U1F3TPhRCrWoDXbnUel26RII5cH1Xg9MUOChCe+nfxbkEZQknBL/SMPdllMAz3EH24OsExVyMM1P5oiFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X2U9sS/3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0dabc192eso66113515ad.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239681; x=1768844481; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=61NDD85iUyghiJ6HL+UGaXo/6Wt+xTCM8G0Rn5C1K4I=;
        b=X2U9sS/3WlTcRY1rQFFKLI96umA10milXsFwK/sasGOimojZ6bSk5bWUu4TX5H1hdr
         ZoKiLYSqt5nkdTuRpRjL/hZcYMzk7b+WwxERuW2KyAmv+zCJDbH8CnayOIjXmbxzxQ4w
         5KVhZywFZxliSDwcRN7sO85kCJHJNzz2yqhFZRrkaPPosydU9w3aeXHe4tWQAdOQhW+F
         9vJ9JtXU2bN9DspwaaqUBf9R7hbhseOACtiieiLBQlnFO7d8BrwGSzv/t3dAG3I0mEKf
         I9wdBG8oKJkPyKimv4pZ1hZTdAQG/Fcf0PZQtLGmwX7Eb4uoDa4z76J4ocWuUQ3bgPsx
         dwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239681; x=1768844481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=61NDD85iUyghiJ6HL+UGaXo/6Wt+xTCM8G0Rn5C1K4I=;
        b=hbr6iBrrf79ygSKTREObzZV4lXEXgQ4LsBtA1coLkfBxHQRSmEq9C092TU7MIUA4CV
         JKyfRKLCqA8Kh4SYVcKFrjOz1jejUGsCTYGZ5FKlQcbTieZ8LATHg3hq8QRtwPfwUjlY
         6k3zO/3rhpE4Muyulsx1LzFw5egjnfzkCOw5UAjtDQL9/7Pad3t8W/pjhKaF1Zg/97O5
         mg/fLjYxtW5ztwegQbcujnkFLkSCxC4ezkxLB0x4i5JOGNdoS0p4Luf7REl0bHIqHW8X
         mwVqdnwj7AwypLABUz9XCbcFke/1r5oBTj4DXdE3lH4GFR80JKJ+9WnvKC7cO7aV3rCz
         KtLA==
X-Gm-Message-State: AOJu0Yw18kGWTiFOpv/iEkBWoHCFsAZy57TPhYCuQb/821/YINurZXye
	XE/JVPtON4YCPNQIeAnP1uTkaUtfm6sdiKmQy0sPi31wob+tB4GeoWj5haaBtB3lglrVWVlgWTk
	crHqTDQ==
X-Google-Smtp-Source: AGHT+IHwMoR/mtF8ifVYHegg69CMk88H/+z3j6NrxvTX8HsBNA0Q7Omcm96jvsraeGT4GeaEvjiborlia5o=
X-Received: from plaq12.prod.google.com ([2002:a17:903:204c:b0:2a0:9081:40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc43:b0:295:fe17:83e
 with SMTP id d9443c01a7336-2a3ee4428c3mr187483475ad.19.1768239680706; Mon, 12
 Jan 2026 09:41:20 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:52 -0800
In-Reply-To: <20251205224937.428122-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205224937.428122-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823924809.1374312.10892154373822814026.b4-ty@google.com>
Subject: Re: [PATCH v4] KVM: selftests: Test TPR / CR8 sync and interrupt masking
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>, Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Dec 2025 14:49:37 -0800, Sean Christopherson wrote:
> Add a few extra TPR / CR8 tests to x86's xapic_state_test to see if:
>   * TPR is 0 on reset,
>   * TPR, PPR and CR8 are equal inside the guest,
>   * TPR and CR8 read equal by the host after a VMExit
>   * TPR borderline values set by the host correctly mask interrupts in the
>     guest.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Test TPR / CR8 sync and interrupt masking
      https://github.com/kvm-x86/linux/commit/0b28194c4c8e

--
https://github.com/kvm-x86/linux/tree/next

