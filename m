Return-Path: <kvm+bounces-41876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F296A6E7A7
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 01:41:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89517175222
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 00:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0B71519BC;
	Tue, 25 Mar 2025 00:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="JV9ajm4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CDE219E4
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 00:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742863246; cv=none; b=L/njrp7PzGeIs9jhpkBvmRSkMNAoWaFAJWwGnBoCKGjwYFCswjMs3jpGacA4pCEV0IecD7BCqg9PM/mZtwFX/hVXlJQeGac+3Fbh3O821uuzlsibkKoq7S/P+IUu6nQNf4OgTNJTA8aMFQZXfWhXqDY8fAZjesRGY/socimNZT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742863246; c=relaxed/simple;
	bh=pMsuxiH98R/tg+nSDDe//UswCW249ayBOYttHK7f3/c=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=iu8KFe6pnOvWO4+s0UsI+muWJlg7I4w4HePS4gkg6AzaEhUl7AC+C9d93uN7ovf1EJmM6v1wtjUnY8Wa8Oi2XpM9iYMydPaolEOt96YsL/1R830gQarTnOkn6C+LaZWOhz4MX7AyNf+Y9ur2NLREmGik4I5UJDZPMCZzizqXq3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=JV9ajm4O; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2240b4de12bso25690525ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742863243; x=1743468043; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aYO6bJ8zL5aeSIvQoR3y8gnTb2GfsftmkAHE8LswBPM=;
        b=JV9ajm4OTiy0bUJ43a/mQtuA3yzfwiiln6r766hp/oFwojHHs/HOolyUtWepeVZ0Df
         EsV5YH0pUBRTpLIpJSnnh6YDFL60amJHa/o2upLkj9Fsx5+YvsL+xjgND1h6SUvzHXxC
         WNquyagCXTiclFSOBw+R91XqQCzEkdDIN4Y0z4sk0Aq7P8jpXMsNpx6AlB6WeukreYSq
         f9E5tnpK91Q1cK6vPJnpYblv/Yk0rE27TN1xXWG20shGFWTIIC06qkxN02h7mqNRKkak
         VUqqj7QIvRRlt31hnxCNrtFI3kMZKz1GPJ9Qk+8u21xHumDMFdBD9TpjExk6SvcUB2/i
         6jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742863243; x=1743468043;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYO6bJ8zL5aeSIvQoR3y8gnTb2GfsftmkAHE8LswBPM=;
        b=YpH7cxw/ikqNHsWLVpMIdo6JlAmLIJ2lF9wIeKobMTvWloMO3PfePt3LwHlclpv+nc
         OIsrPmdzoV44D3dM0+TXgN8xN3gHfTGL78rbbbVRZ9MEe6i3RPvTX37duxO1kXB5km9W
         chQPr0aKX4u9yOlbr7nVdlBlL1k8XHh8roIrC2sF2U7feJuwEInSK1VJ00OVRPW2S6yy
         pxfixBFxnpr72tmdRsZtld/SPbE2Y6f1eM/dIoett44l2yC/9yAo5SMyThVu5tGiW4S/
         5+vHlEDVDw+4WT9qLY7mo3PJAP3Rwzq5oJ48LShV/CrQ9MKqaBCJ07VviIrXhLE3my4o
         ilkQ==
X-Gm-Message-State: AOJu0YyTfI+brixmdcqyc5cNEHiMgTTHpfTe2leZhOLyRh3k8R7bh3o3
	9BlyrXQyNkf47iFIG+JHQgbikYK5/v/TQ9PiHtrixKJ5GDM3IhidZMLL6uC/T6w=
X-Gm-Gg: ASbGnctFmaVaFja7TcXnXEwu5Iefwb+hBgNy13U8tr6ruzMmJrqneugOiOf1aZPvjXo
	1Dpp4SgodvF79AOQQIH/8EZoZDb8xdv/nYjJ40CfbbUqmGMNEI2SamUxgRwFxrc4JWZIAaB43Gc
	W80RsPrBeYge5L6q0myjA3oM4cJPivLeYAoZD/DTsdXETbz3jve2xkAh3hntjPNS7s0shu+Mjc5
	2N42EJuk/6W6f6qExxXCA3ws91+VTo9H9hvSB9fcydD5Wp8vLKUD7GWGs5o/DyIrUicWnbuS+E2
	Hpv7kBSZIa/y6uJF4IM1DQ4fr5VbW/A4iS4ScEUbNMrOUeZd/umOeMdtQQ==
X-Google-Smtp-Source: AGHT+IGKaAQwHsi3qvX4TbcKN8G3Y8mGa16DOUEDVHL9bvh5YTIWSFdZiwuzP2GQ1p/HXxhaFtJWOA==
X-Received: by 2002:a05:6a00:8017:b0:736:4536:26cc with SMTP id d2e1a72fcca58-73905a2786bmr26107578b3a.23.1742863242520;
        Mon, 24 Mar 2025 17:40:42 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390600a501sm8705513b3a.79.2025.03.24.17.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 17:40:42 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH 0/3] RISC-V KVM selftests improvements
Date: Mon, 24 Mar 2025 17:40:28 -0700
Message-Id: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHz74WcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDYyMT3eyy3Pji1Jy0ktTikvjM3IKi/LJUXcuk1JQkyzSDRLMUYyWg1oK
 i1LTMCrCx0bG1tQBKyBZkZgAAAA==
X-Change-ID: 20250324-kvm_selftest_improve-9bedb9f0a6d3
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

This series improves the following tests.
1. Get-reg-list : Adds vector support
2. SBI PMU test : Distinguish between different types of illegal exception

The first patch is just helper patch that adds stval support during
exception handling.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Atish Patra (3):
      KVM: riscv: selftests: Add stval to exception handling
      KVM: riscv: selftests: Decode stval to identify exact exception type
      KVM: riscv: selftests: Add vector extension tests

 .../selftests/kvm/include/riscv/processor.h        |   1 +
 tools/testing/selftests/kvm/lib/riscv/handlers.S   |   2 +
 tools/testing/selftests/kvm/riscv/get-reg-list.c   | 111 ++++++++++++++++++++-
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |  32 ++++++
 4 files changed, 145 insertions(+), 1 deletion(-)
---
base-commit: b3f263a98d30fe2e33eefea297598c590ee3560e
change-id: 20250324-kvm_selftest_improve-9bedb9f0a6d3
--
Regards,
Atish patra


