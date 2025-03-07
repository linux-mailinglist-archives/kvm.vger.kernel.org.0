Return-Path: <kvm+bounces-40313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF54DA5628F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04EAA16B970
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12831C861C;
	Fri,  7 Mar 2025 08:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="JXIzcxpy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A898B1B4132
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741336142; cv=none; b=hoAoQ/qvTx7oR0jpW4OY6sfUKDg+nM45qw0WiK9SnXOfRywq+yMKLJi3LOO9jNxfrcLSy//KLGgOGZ8yTzDBEZF850fRCsD62e6bewwa0PZMd5xEYcWog1Rf/fpDmSqGv+ce4uEPLzoF9r/taQ/VKpD5q+SzBtKJA7ei8xUQrfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741336142; c=relaxed/simple;
	bh=KAEABgo5QmoLhvA8/dKPBOR8Bq/G4TG267wdgb4RRRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j6DbIggkcr3xO6GcibqG34Uf8VXFYOFP2V00y9bVEdptez8O5EAxUtBbUtfvm9pbpEiPBmrZJsRY189qj/D5qbI4X5V6QdA69b+ayXfUXLCKFGDWY1FIB+/dg0mF9Y71iP34lEJF7WdzyU6v7vezjO6Rsryki7hg5Cde/A+0IYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=JXIzcxpy; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d434c84b7eso12493885ab.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 00:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1741336140; x=1741940940; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8YlIiXhwG4KRcbOBdAmDvGTlkxDSVAhUX3csscpKyVg=;
        b=JXIzcxpy78b0xaUVjp3wfEieVyGJm2NHqskgLNwsnlMM/iZcVIrOkC16ADVEmBvzWl
         u8l9zkNdxmZY+oEfrc1EJ7poDiHhKOaevHsVjvjieiy2XTOo5kLec4d7GGhym6bWoigp
         pfahh5/GHmMxk0pinEBCf/+b7Aoq6WDopJi874UsEDWRotKjE/QMc5sCJUzjO6m3d8vZ
         rsiC6QjGRI3EheREKzJ/oIs2RgQviy9vu7w/8n51XCg/RL3gIJidCdLWijT8BZhjiIVh
         CVvuoz1uFM9FqgcyvP+jxDldV8erjtTT0iX403hoQggrnvt212WgMZJrSReoyE8kDwj2
         zjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741336140; x=1741940940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8YlIiXhwG4KRcbOBdAmDvGTlkxDSVAhUX3csscpKyVg=;
        b=aT27xEzP24vJZ2AO62UpeDoOuDn3kkacDrZlyLNfqbRyFV+XkybJmzJxgd123UI9Lw
         E+GGt4ivO5o8Vhk3w0MMindkFh6l+SMW4qpT0vrPYvwd1P+ot87QbfpbI0r7Bsqt9a0v
         jrjrRFCLreAoHdU2q0VfXdANABkTT019+uL983HDtsqqwoGOKtZs6HFwNnGJr6p1t0E7
         xkJ1c6BSxHt4w52XY8zcnVIcZdG1Qjd5G+g55V1US9+8aL/18LSSjcPgB4seimEoqVj7
         0/TjmDBxLEcIC3ZrjLGNRpvYLNZL1iJ++vJiJBmhNQ4UoQ/nY9qQzgUGU4H2Pj/IYJfz
         Fgkg==
X-Forwarded-Encrypted: i=1; AJvYcCXX+bAeqlUUNQI2xeZ9brCcgsJMaj1F/vFRscmmdXYAiZdDaSsMGlCEiNIjwKcRRJ6xKE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxigk5iO0qSH7c8R48gwJ6oTAWDcYg0NipgmgNX/ZkKjH+tsbf9
	OouQ99eHOan4AwVUaIzUxUMC4w8upn2v8ENwBTpquGZPyvGVOoHyKiAu66ln2ExNDrI9ADp+XOH
	ljh1LWdXfXyOvwda20VH0zNSzXQk/miaaxAau1g==
X-Gm-Gg: ASbGncsZsyXN6MdI8AhUtn7JyFfAH8r2CfQtPOnDgOPBr9DEPR9BrnFBP7m8eVO3n0H
	JE0VvjKKC+JVcrTTvPExl6YpEPQTRDAUNz51ymyHwx2VIMJxcdBoMAm5SYfj4TzDDy4Gt0hxGeO
	DnfFSum4dfLzl888lBuOXvieJP7uo=
X-Google-Smtp-Source: AGHT+IHpyge1YXB1VBykLP/dh9ft8HFAB3zzw6CmKWnhV8/XYcR00xSa4YW+S5Z3jF04shZ9TO0vf5OuS0Vy70VC954=
X-Received: by 2002:a05:6e02:16c7:b0:3d0:239a:c46a with SMTP id
 e9e14a558f8ab-3d44194816cmr30189715ab.9.1741336139186; Fri, 07 Mar 2025
 00:28:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303-kvm_pmu_improve-v2-0-41d177e45929@rivosinc.com>
In-Reply-To: <20250303-kvm_pmu_improve-v2-0-41d177e45929@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 7 Mar 2025 13:58:46 +0530
X-Gm-Features: AQ5f1JqfLRDl2sXghMrs9tGiGCXrhEWfy1IvZjbEz2be6tiJtFVbpcg_wKAhY44
Message-ID: <CAAhSdy3KncYJhPAa20oH=bB1Zi5-=sD8m69OYFS451q3_EMiEA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] RISC-V KVM PMU fix and selftest improvement
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 4, 2025 at 4:23=E2=80=AFAM Atish Patra <atishp@rivosinc.com> wr=
ote:
>
> This series adds a fix for KVM PMU code and improves the pmu selftest
> by allowing generating precise number of interrupts. It also provided
> another additional option to the overflow test that allows user to
> generate custom number of LCOFI interrupts.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> Changes in v2:
> - Initialized the local overflow irq variable to 0 indicate that it's not=
 a
>   allowed value.
> - Moved the introduction of argument option `n` to the last patch.
> - Link to v1: https://lore.kernel.org/r/20250226-kvm_pmu_improve-v1-0-74c=
058c2bf6d@rivosinc.com
>
> ---
> Atish Patra (4):
>       RISC-V: KVM: Disable the kernel perf counter during configure
>       KVM: riscv: selftests: Do not start the counter in the overflow han=
dler
>       KVM: riscv: selftests: Change command line option
>       KVM: riscv: selftests: Allow number of interrupts to be configurabl=
e

Queued this series for Linux-6.15.

Thanks,
Anup

>
>  arch/riscv/kvm/vcpu_pmu.c                        |  1 +
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 81 ++++++++++++++++--=
------
>  2 files changed, 57 insertions(+), 25 deletions(-)
> ---
> base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
> change-id: 20250225-kvm_pmu_improve-fffd038b2404
> --
> Regards,
> Atish patra
>

