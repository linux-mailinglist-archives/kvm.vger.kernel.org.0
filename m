Return-Path: <kvm+bounces-6740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFAE839BE4
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 23:12:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80D251F2A1E8
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 22:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B22404F203;
	Tue, 23 Jan 2024 22:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g062aeWH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7174E1D0
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 22:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706047947; cv=none; b=XR3dQo3/VRQT83rG5UWFGwYjx6yKXyHHQrqt4x3NiahdXjDayp2PV2B+6JvL9QGnGIjB5nG8ruIkYAdSFylceA2PrEoVQxeN7Vs5dntqxdg5+duBBUZaUTMmNf5rRCKCLNJy2/cQfmtCxRHFciHwaKN5ehac03p5WRH7HtqxVjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706047947; c=relaxed/simple;
	bh=yQx9UthoJeKm1WZYjbBJ01OFS6LBdI2HlCCVfimdaT8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eJK7Zmz5hypoqHAJP7rus0zi3b3dK71Juun3HBBYVPIcPHByNZUF997W4rs+Z+wtTtPD9Xv/E5lCxs9t9wT7Awz6BjqS0U4ZcqMVyEVYJQhS9SAlFk2eIcSX6DWf3OG2RKvM9CaRe8sWunw+Tk4oXvlEcvZ+mL0Mhcx72vcV6r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g062aeWH; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f6c12872fbso77673977b3.1
        for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 14:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706047945; x=1706652745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxlcqEi9GPSMvEkZ9TLbFMdD/IrKZGyQ1yOZzIdu8Ao=;
        b=g062aeWHJ/f59eGp3G4MeV1vBg4sYUnRdNQAJ93h4lLiWRXdH1vzSEu17AOuBonxTC
         d4r0kIMpXea5i2beHHMH4nYudY6+MTnD0BLNEYExmycgFmEw6GQdRdPMRQWVv/YjaIhq
         /ftSu74hNYvpbjGsOJ/B8uiX8gOgTL9jRle2/WLAGsIFxn/73DYFgHvpZGnKXK53de/h
         y0L7x6Ua7HJb2E7EH3ZfbkRougIkTPV0aXM/HukB2WV6DfODT72K+RnJKpfJ6Ozw8qOT
         1vY8UeLmqihHKsTnhqnfSpLY5cOQ7mc7pQ8VHOmBx/2qdr72NkvV60Ty8EzNfSzXgUiM
         e6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706047945; x=1706652745;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wxlcqEi9GPSMvEkZ9TLbFMdD/IrKZGyQ1yOZzIdu8Ao=;
        b=DWClLrRDpfxwge8zvSi76Om2kIh3jaLwpUxOXv6avgBB7VMHox8ljc2BclhkHCKCM4
         ATmBr+G9YmD7XnSvayfb4G/C+QVbgBcFjPObLbUKmpHlrwy/zPXJ0penDabCCJmUkHAL
         a9pV8eJMonZWAYkQJ+/NEN05TIqWrQODBUJoWMTFvCB/bify+/YQelYxqIEgO5Y78mgD
         WBd3a7dH2yvs9xF1WJJbapvq4235EKP9ifYmb7cly4h9y1JgBTxYhv93xEB66fztsbzB
         fwQa47IS//CM/svQjfklM4zwFJvHMAQEFAX6oP8QWupL3DbWYmiUbCOs67Bu9XR4XUsC
         wXMQ==
X-Gm-Message-State: AOJu0Yz7jE5gKWILmnmvihisQYpG/6DJr8nbnrEcfC+O6MK3bQkMJinA
	PfwlZrJkejs+HG7v3rT8rc3eVeS7WzEOgvQxxlBVcifnTSM8FCGCdAVDMdZgdZPalTNBVwAFeUs
	D7bCVFA==
X-Google-Smtp-Source: AGHT+IGgFmgGBBNeO2m9PkEd4cL5jCRH6Usqn1jPECOTfs20TGpyuBXu86a6mZmLv1CFWTpB7sobJsKumjfr
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a81:a096:0:b0:5e6:27ee:67fb with SMTP id
 x144-20020a81a096000000b005e627ee67fbmr2249829ywg.4.1706047945575; Tue, 23
 Jan 2024 14:12:25 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Tue, 23 Jan 2024 22:12:20 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240123221220.3911317-1-mizhang@google.com>
Subject: [PATCH] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix type length error since pmu->fixed_ctr_ctrl is u64 but the local
variable old_fixed_ctr_ctrl is u8. Truncating the value leads to
information loss at runtime. This leads to incorrect value in old_ctrl
retrieved from each field of old_fixed_ctr_ctrl and causes incorrect code
execution within the for loop of reprogram_fixed_counters(). So fix this
type to u64.

Fixes: 76d287b2342e ("KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()")
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a6216c874729..315c7c2ba89b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -71,7 +71,7 @@ static int fixed_pmc_events[] = {
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
-	u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
+	u64 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
 	int i;
 
 	pmu->fixed_ctr_ctrl = data;

base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.43.0.429.g432eaa2c6b-goog


