Return-Path: <kvm+bounces-20635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BB191B8FE
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56178287AF2
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 07:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3EE143864;
	Fri, 28 Jun 2024 07:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="V9frxGw+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB0614532C
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 07:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719561126; cv=none; b=Fyc8FCxaJJPwzJdsXQdgIuE1Gfn7Q2/mnyWaT8wMpkHWxFQlVmOTblPTQAGNfYGqL3qWp2pa8OSEvAfj/TIA0c7sNV8TevNoenSfiXLDiJ+Jq7aGhKD3TFh+3PGeVkk9ELpuAp47Zl9359yJNBuPBIXGfGWXGxi8j4mR7M0qhPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719561126; c=relaxed/simple;
	bh=EQnkaeiVzliUJR5h0Fr7U2mwCLH2PFeHVytjBFr15sU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=BNZFalcn3zx+SifAgr8h1Qnop7oqJrpu3i91EihRCAOr4MiJxD368GcVqaNI/EGSMvKuy9smNbBOatWpoelPZV3kHxFSHR+BrTvaCeqwXaunGBTQ2/0bV1wf5aETasBPkLkWC+5VBYcT1OtcdsuOHfrjYFLuKTpyj4oqdtI7J9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=V9frxGw+; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5b53bb4bebaso155115eaf.0
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 00:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1719561123; x=1720165923; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lfk2FSfAfTy7rTZuEBD/W0oaye5LlvyVrrLcE/eP+AI=;
        b=V9frxGw+TWEPYHSq8Ar0+9i1u/B0YCPIVI9rYp9DOiWE31J1CGdiQGj/GQ3CEVHD0C
         xp7lIYqpStplazpxgegnvev/YPmkIZapqNuRpM5JsL7f8YSahFUYg5cQuLjfqgzSBJOR
         Imuds7Elk3WBXUiGsHwp2umzi7JgScSstm6+RzkFNvUyB4fDWEmJr3yp8pzh/47zp5xh
         eQkJZ5CTByhwz/ZrykwMiS0npXypSr04L10tsWSwcD73QmKu3/tyLGepj83UWmVi6cea
         eYitJAeo3Rnt/nyY+KrLpFhdo8yvNNMZOoQOqaBVKq7Nr55+MkSpfovM3tRRO9uPgD8m
         JBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719561123; x=1720165923;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lfk2FSfAfTy7rTZuEBD/W0oaye5LlvyVrrLcE/eP+AI=;
        b=JuwyXWkh3jaPFxyPEAo8SF+qvs0NoNtduhpDYFBBzI0UQPSPfbHYOpzNVe92ZNQuXI
         cElWPC3/h+G26H3CNrlG/zZ+MtWSI5V2iQ7qkGX16u/+QObccLhzA5o0GZiIl8NBULAq
         pq4SrnWdZMZ6/NP2mbL3llHK3e+AOJ7qnqrhFDfTZgGcXQwKFjMeWzmdj4RvpWBovPno
         WaSqdkXfdT1fDfuW2tG0EyetNN5yMsOiBg5GhdPWzNYAVDywZW4w8NjXoAbn1tC17ic2
         wuNFc6bx+COEQxOYsI89uIBhnQof+2xLO6QdAXc0c3fUuiFML9LQDViq5Il2ocgZ012x
         2PSg==
X-Forwarded-Encrypted: i=1; AJvYcCX3Y3gezxs7+neLreBb99iR+ETvLoSsbWzTlCF8TFVjBEdP866eUuFQu3OSTtodXpg8IYz6D5PZDB0BI93wwg69fHcT
X-Gm-Message-State: AOJu0Yz1S3GD3rC/nvUc6GZRgt9qNNp/CJkjraZUgLzGRMmEvDnYai2h
	6XitzL5B130c8qcjEAZxJJyairgsMSZaTz3fj8LYlSC9KRj8mv/gfvXT2/ltx1Q=
X-Google-Smtp-Source: AGHT+IGJY3zwz2Dh3ONBt7zBT44037cWL19x8gYpDsscR2++QxJYS7DFgyh8r/X4g1UFT/8YlTY5Ng==
X-Received: by 2002:a05:6358:9497:b0:1a6:5ef1:c372 with SMTP id e5c5f4694b2df-1a65ef1c9c7mr603886655d.26.1719561123194;
        Fri, 28 Jun 2024 00:52:03 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c69b53bf2sm685068a12.2.2024.06.28.00.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 00:52:02 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v4 0/3] Assorted fixes in RISC-V PMU driver
Date: Fri, 28 Jun 2024 00:51:40 -0700
Message-Id: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIxrfmYC/2WNwQrCMBBEf6Xs2UhImho8+R+llJps7B7alKwEp
 eTfjQVPHt8Mb2YHxkTIcG12SJiJKa4V2lMDbp7WBwrylUFJ1cpOGbEQu3HDFMZAL2RhnLkEY4y
 3ykK1toRHUaV+qDwTP2N6HwdZf9PfVve3lbWQwqMOFr21frrfEuXItLqziwsMpZQPn0Cn3bEAA
 AA=
To: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org
Cc: Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Samuel Holland <samuel.holland@sifive.com>, 
 Palmer Dabbelt <palmer@rivosinc.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, Atish Patra <atishp@rivosinc.com>, garthlei@pku.edu.cn
X-Mailer: b4 0.15-dev-13183

This series contains 3 fixes out of which the first one is a new fix
for invalid event data reported in lkml[2]. The last two are v3 of Samuel's
patch[1]. I added the RB/TB/Fixes tag and moved 1 unrelated change
to its own patch. I also changed an error message in kvm vcpu_pmu from
pr_err to pr_debug to avoid redundant failure error messages generated
due to the boot time quering of events implemented in the patch[1]

Here is the original cover letter for the patch[1]

Before this patch:
$ perf list hw

List of pre-defined events (to be used in -e or -M):

  branch-instructions OR branches                    [Hardware event]
  branch-misses                                      [Hardware event]
  bus-cycles                                         [Hardware event]
  cache-misses                                       [Hardware event]
  cache-references                                   [Hardware event]
  cpu-cycles OR cycles                               [Hardware event]
  instructions                                       [Hardware event]
  ref-cycles                                         [Hardware event]
  stalled-cycles-backend OR idle-cycles-backend      [Hardware event]
  stalled-cycles-frontend OR idle-cycles-frontend    [Hardware event]

$ perf stat -ddd true

 Performance counter stats for 'true':

              4.36 msec task-clock                       #    0.744 CPUs utilized
                 1      context-switches                 #  229.325 /sec
                 0      cpu-migrations                   #    0.000 /sec
                38      page-faults                      #    8.714 K/sec
         4,375,694      cycles                           #    1.003 GHz                         (60.64%)
           728,945      instructions                     #    0.17  insn per cycle
            79,199      branches                         #   18.162 M/sec
            17,709      branch-misses                    #   22.36% of all branches
           181,734      L1-dcache-loads                  #   41.676 M/sec
             5,547      L1-dcache-load-misses            #    3.05% of all L1-dcache accesses
     <not counted>      LLC-loads                                                               (0.00%)
     <not counted>      LLC-load-misses                                                         (0.00%)
     <not counted>      L1-icache-loads                                                         (0.00%)
     <not counted>      L1-icache-load-misses                                                   (0.00%)
     <not counted>      dTLB-loads                                                              (0.00%)
     <not counted>      dTLB-load-misses                                                        (0.00%)
     <not counted>      iTLB-loads                                                              (0.00%)
     <not counted>      iTLB-load-misses                                                        (0.00%)
     <not counted>      L1-dcache-prefetches                                                    (0.00%)
     <not counted>      L1-dcache-prefetch-misses                                               (0.00%)

       0.005860375 seconds time elapsed

       0.000000000 seconds user
       0.010383000 seconds sys

After this patch:
$ perf list hw

List of pre-defined events (to be used in -e or -M):

  branch-instructions OR branches                    [Hardware event]
  branch-misses                                      [Hardware event]
  cache-misses                                       [Hardware event]
  cache-references                                   [Hardware event]
  cpu-cycles OR cycles                               [Hardware event]
  instructions                                       [Hardware event]

$ perf stat -ddd true

 Performance counter stats for 'true':

              5.16 msec task-clock                       #    0.848 CPUs utilized
                 1      context-switches                 #  193.817 /sec
                 0      cpu-migrations                   #    0.000 /sec
                37      page-faults                      #    7.171 K/sec
         5,183,625      cycles                           #    1.005 GHz
           961,696      instructions                     #    0.19  insn per cycle
            85,853      branches                         #   16.640 M/sec
            20,462      branch-misses                    #   23.83% of all branches
           243,545      L1-dcache-loads                  #   47.203 M/sec
             5,974      L1-dcache-load-misses            #    2.45% of all L1-dcache accesses
   <not supported>      LLC-loads
   <not supported>      LLC-load-misses
   <not supported>      L1-icache-loads
   <not supported>      L1-icache-load-misses
   <not supported>      dTLB-loads
            19,619      dTLB-load-misses
   <not supported>      iTLB-loads
             6,831      iTLB-load-misses
   <not supported>      L1-dcache-prefetches
   <not supported>      L1-dcache-prefetch-misses

       0.006085625 seconds time elapsed

       0.000000000 seconds user
       0.013022000 seconds sys

Changes in v4:

- Added SoB tags.
- Improved the commit message in patch 1
- Link to v3: https://lore.kernel.org/r/20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com

Changes in v3:
 - Added one more fix
 - Separated an unrelated change to its own patch.
 - Rebase and Added RB/TB/Fixes tag.
 - Changed a error message in kvm code to avoid unnecessary failures
   at guest booting.
Changes in v2:
 - Move the event checking to a workqueue to make it asynchronous
 - Add more details to the commit message based on the v1 discussion

[1] https://lore.kernel.org/linux-riscv/20240418014652.1143466-1-samuel.holland@sifive.com/
[2] https://lore.kernel.org/all/CC51D53B-846C-4D81-86FC-FBF969D0A0D6@pku.edu.cn/

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Atish Patra (1):
      drivers/perf: riscv: Do not update the event data if uptodate

Samuel Holland (2):
      drivers/perf: riscv: Reset the counter to hpmevent mapping while starting cpus
      perf: RISC-V: Check standard event availability

 arch/riscv/kvm/vcpu_pmu.c    |  2 +-
 drivers/perf/riscv_pmu.c     |  2 +-
 drivers/perf/riscv_pmu_sbi.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 43 insertions(+), 5 deletions(-)
---
base-commit: 55027e689933ba2e64f3d245fb1ff185b3e7fc81
change-id: 20240625-misc_perf_fixes-5c57f555d828
--
Regards,
Atish patra


