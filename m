Return-Path: <kvm+bounces-53067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3D5B0D0BD
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 06:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 903F1542FED
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 04:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3594228C2D6;
	Tue, 22 Jul 2025 03:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="jpw39Ig5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025AC5223
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156794; cv=none; b=jO6mWrkId0paMWVRn1voryBUV9oQN/FXAQsrZXRGNX12M02HqDInqOKWp3XVavwWLwvo4y6h/MHQSxj2QukVq/76KWJHImu3lIwa3lj6DZYVhbVVKlErb/C+HTGTgBhaja7OT89o1bZboZuD5a/JBM6kFbxdy4b1pNem84pXr3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156794; c=relaxed/simple;
	bh=VaDzM9N9oBZ6M6v3zgmJ2Cwq3toByIhtEg86PpE28iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZHTn8II62rweVmurqDRjLEgRY3rnTbCXZ4pZSmD+JmZYDEz56EujhRlDocfCn2CPjUuLcq7yLj7RaYCzVADm4OpTQOHFejDf30kDD7J7hKRm4n6JzX8r7umEpdlv7ylkfxfq6gr9/lEQppcOYpFQQjIc5buP+LzsFdueVM3+qLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=jpw39Ig5; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e2a3873132so40696645ab.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1753156792; x=1753761592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azXxDouz3VhvVI25kVzCdndCbjprC2M8LL1OP84oLB4=;
        b=jpw39Ig55IgWohtnhEkHGGRxDLGeR6Ob/kTjju0WWjtsZlL2Ae/qE+1QBhLucF22SG
         TkqaSbemXgQyuI2IpTQczUBpjXTb32DQrqAAWqH9fX/sPLO7U8xFJEuogBlYt2ov0iZa
         PNHYT+EtlAqaWB3YvT549K4Rc5ydUR5IIJOEUlkBchrJxMMI+WQB07+V38KWdenvhbHL
         gsbIiSOrXvVv23wKWx2EknpsZgGVsSb/4P8/Y7Eey9d8HvnBG7OaU2YubM2wmrzBU2O3
         /Z3TvdeDYcMiTA+LgdX94tMuJ/ud3mWIH1+2BeDa1P4cbgeKvQp/Nc4ASX9wFD1CpTXh
         BudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753156792; x=1753761592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=azXxDouz3VhvVI25kVzCdndCbjprC2M8LL1OP84oLB4=;
        b=jUIaGTXXfZ1e/os+CTMy6Ilh6eD2sWSAL3EWKA/idYVL4YBZxnRtDE4FrCDTjq69Fc
         PSGwfu4em5el/G9+aIIAWzlDPp7+rJkvrF7TCbsM2sfUYYbTIm/n2T3PHe3d8IGE7g19
         i6VOg8FC3RmlfAX4kjshg3n/BLjxMUOUc831ctmZXFqpMT+w9/GYrqsTUNTwxErwYCTG
         we3eLpevuqAPdLWiGFk8X4gqs/ODG5RSqqzFJmJDphafg76fCqGu0kn6pIzKsguyqkQp
         sBiTpIC0DoQLJeUCqYeQhAN4nLNSJiff88q8OgpHaVWIwEXb642RGpsKWq4rFO30rOMI
         RdTw==
X-Forwarded-Encrypted: i=1; AJvYcCWPal3kg26fvjYE+sG+ZCFxmJbVZN+Y7DMvswKvqZ5MPIM8sBLA+pBC4ayrRTXQR/9sCo4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhrte0bAyhIVcutu8eJXwKcafn0i6JoJUSYS124/5lPoegfbzA
	wN5o8rD6wsQDlBPnFw1fm80NF5lpDX51r0JncWG3UIv02Ke5ozGfF6JvKFW6uIp2URueX9SBgGC
	bqNnOj3eBniVnhZN8I/sQSkJr7Brd58O+t9Ew72v76g==
X-Gm-Gg: ASbGncvclLAEmRDxSySXw43N+6nSwsjzFjydhKbgsx1IUY2lMjON74UadSYtM8mIxKZ
	mTyc9eLW8moSzg4SPC+mLJYyGgb3vm6aKV5UJPnjo/uqRAKwh1D0T4MPYH5mOphAMJ4mVuw+4tT
	MkbPsi8U5FiU17cmyld12GEDOlDQ/zO5r5y7wnPMQ8rEEsKLC+0WTgDaIJvLWLnBY3JD96GcxJX
	iKEf/sF
X-Google-Smtp-Source: AGHT+IHpX4gv3L9qRgmkg5vRrd6Bn1uOwCgW3ASTBkfj3oy85sashnMtNel4xRNvCLmx3HyMPs1rhWWMG3wCUitrJq8=
X-Received: by 2002:a05:6e02:1a2d:b0:3e2:9f01:a87f with SMTP id
 e9e14a558f8ab-3e29f01aacamr172092815ab.22.1753156791976; Mon, 21 Jul 2025
 20:59:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
In-Reply-To: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 22 Jul 2025 09:29:40 +0530
X-Gm-Features: Ac12FXzjUPyCjGixcXNmSF9Z7RGo8cjqQ1deNGPVZVPzKJzPPazl7D1wVYDTxbU
Message-ID: <CAAhSdy2XM+3UQD0FZehJnmCbjwRMCZQpt1cEkb4gmJu+LFsaKQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] Add SBI v3.0 PMU enhancements
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Tue, Jul 22, 2025 at 8:45=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> SBI v3.0 specification[1] added two new improvements to the PMU chaper.
> The SBI v3.0 specification is frozen and under public review phase as
> per the RISC-V International guidelines.
>
> 1. Added an additional get_event_info function to query event availablity
> in bulk instead of individual SBI calls for each event. This helps in
> improving the boot time.
>
> 2. Raw event width allowed by the platform is widened to have 56 bits
> with RAW event v2 as per new clarification in the priv ISA[2].
>
> Apart from implementing these new features, this series improves the gpa
> range check in KVM and updates the kvm SBI implementation to SBI v3.0.
>
> The opensbi patches have been merged. This series can be found at [3].
>
> [1] https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/v3.0=
-rc7/riscv-sbi.pdf
> [2] https://github.com/riscv/riscv-isa-manual/issues/1578
> [3] https://github.com/atishp04/linux/tree/b4/pmu_event_info_v4
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> Changes in v4:
> - Rebased on top of v6.16-rc7
> - Fixed a potential compilation issue in PATCH5.
> - Minor typos fixed PATCH2 and PATCH3.
> - Fixed variable ordering in PATCH6
> - Link to v3: https://lore.kernel.org/r/20250522-pmu_event_info-v3-0-f7bb=
a7fd9cfe@rivosinc.com
>
> Changes in v3:
> - Rebased on top of v6.15-rc7
> - Link to v2: https://lore.kernel.org/r/20250115-pmu_event_info-v2-0-8481=
5b70383b@rivosinc.com
>
> Changes in v2:
> - Dropped PATCH 2 to be taken during rcX.
> - Improved gpa range check validation by introducing a helper function
>   and checking the entire range.
> - Link to v1: https://lore.kernel.org/r/20241119-pmu_event_info-v1-0-a4f9=
691421f8@rivosinc.com
>
> ---
> Atish Patra (9):
>       drivers/perf: riscv: Add SBI v3.0 flag
>       drivers/perf: riscv: Add raw event v2 support
>       RISC-V: KVM: Add support for Raw event v2
>       drivers/perf: riscv: Implement PMU event info function
>       drivers/perf: riscv: Export PMU event info function
>       KVM: Add a helper function to validate vcpu gpa range
>       RISC-V: KVM: Use the new gpa range validate helper function
>       RISC-V: KVM: Implement get event info function
>       RISC-V: KVM: Upgrade the supported SBI version to 3.0
>
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |   3 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +-
>  arch/riscv/include/asm/sbi.h          |  13 +++
>  arch/riscv/kvm/vcpu_pmu.c             |  75 ++++++++++++-
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
>  arch/riscv/kvm/vcpu_sbi_sta.c         |   6 +-
>  drivers/perf/riscv_pmu_sbi.c          | 191 +++++++++++++++++++++++++---=
------
>  include/linux/kvm_host.h              |   2 +
>  include/linux/perf/riscv_pmu.h        |   1 +
>  virt/kvm/kvm_main.c                   |  21 ++++
>  10 files changed, 258 insertions(+), 59 deletions(-)

Are you okay with this series going through the KVM RISC-V tree ?

Regards,
Anup

