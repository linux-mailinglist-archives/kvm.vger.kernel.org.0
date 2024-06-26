Return-Path: <kvm+bounces-20526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC56917997
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 09:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE69D1C23465
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 07:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E911815D5AB;
	Wed, 26 Jun 2024 07:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Tw4JfwyF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26F3158A31
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 07:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719386660; cv=none; b=F8NTbkivrG78uam8SP2ut8wbyTt9X909s592sokthAVbavpzIBe2O5gBcBDcQwJdyHs0Clj04dILRDnNsmBVo75AKZghtgtoIt1AjegqgitMXq5KllPSLS7rQ9KkFFyfxS9l203l3PjpW9NF8PLTMhRwHVXxQ0UpXO4dsvSqu+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719386660; c=relaxed/simple;
	bh=NhkPaFQ1fyCKRoLhxvrtcHqX8f0uoPMpiHzutsB8doU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=SQKSaeAXyztoLG2Bz8TGsJCTPkCX32eH/o0K8YAXiiuh/2wX1AlFWBb/SwDm3rE+lQ8/uup2mySEwSbgaZA/SU3iCHBgYufTugTtRIvRHuyi98x8kjpk7ug6a3ELeIPbRm+p3wzQFTNSKvUNVbVGzQ29d/I79pqimBsVydj9exU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Tw4JfwyF; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3d5288e6513so3309147b6e.0
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 00:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1719386656; x=1719991456; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=28+2R0YMNVN2b8FjjSAlDFHsrFLhKCgCE06SYvvPxuY=;
        b=Tw4JfwyFpY/N57Y+C4MYSvorTbf1CTjpjX9xb+HseZkpBGys886or+qqQf6zfAUNrI
         B8cRVl/Mm13/UDJOMimxizbj+mKClfUtLm0iSlOkG6FvNfzxJV23Yk9JuK9hwW6IEztm
         jsUePxzhXmsbPfdM8elM9Gf2dgj8gtdou2gGBe/AeGUGWhVuCq2MtHLqNv9J7nzGOCMZ
         kuP0bLM7wOyv2ydv0w2Emb9/7DXtvgXEPT/nibXy9UC+IaFtuMtKG3ZMYaY0Vy79UE4w
         N+CVAMALKgP+jwc3xfrEJ4toZ/LDnGEeAH8ejskNyWXHK8awGoIeaxoEJqbFxdM4Ftni
         W/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719386656; x=1719991456;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=28+2R0YMNVN2b8FjjSAlDFHsrFLhKCgCE06SYvvPxuY=;
        b=u0wGbZUJh6yYcQdNYoZn8TX9sXAAH0g35UZhdL5rExohl5oD24WjVlsqVXk7FPB71E
         pM2rDU7bsf+AJo+hcEC4In8HFHhPj+zU9xy9uialvKCyq2YjFaRatCece4Ia3vs77sn/
         lX/QISqBNQCoXfvowFaBhF7VT92c/c8JbqXdCPN0ITgJZc8P76RXaesYOQlBz4Si8D8U
         nd06fcsjNIymfHZJIFnJsgEMs+R8Q/+HkTw8XhFa7Y72yWLI6Pid896kJ64S6LkrRPbL
         Dz1e+wzXx3s9+N9XbgYiJPYQupO7XStJln7k2LTIbXcZRwVyPnZ8469tpRyYY2vHzp2v
         95bA==
X-Forwarded-Encrypted: i=1; AJvYcCW+bgu+a9b9P5TC90HpLAwexQCgwU3PyxqtBXQJ4zeoP5O/daK+uLYTr3moOQf5ckjpXNVCF6KH1GmXqNXWDtQmA82T
X-Gm-Message-State: AOJu0Ywq9akma/4VjXNn8HjIHBsiHceZAOcHYDjsEfthp5btkBCv5Go+
	ByQHv5Z3nQKC4O4+35U9OsbAYkKCDJNibOlfZr8ssCOvJzu3m/JO5y2j6cqAseQ=
X-Google-Smtp-Source: AGHT+IHjdai+QGS6HcsrCB7cdgiPaThjZ4KTE2hdtBxgDxRzNsR46vLc5RHtMevlnVOBtgqAi78eZg==
X-Received: by 2002:a05:6870:b4a4:b0:254:b6f0:21b6 with SMTP id 586e51a60fabf-25d06bb45d2mr9741006fac.10.1719386655791;
        Wed, 26 Jun 2024 00:24:15 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-706984a721csm2692218b3a.37.2024.06.26.00.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 00:24:15 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 0/3] Assorted fixes in RISC-V PMU driver
Date: Wed, 26 Jun 2024 00:23:00 -0700
Message-Id: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANTBe2YC/x3LQQqAIBBA0avErBPCmpKuEiFhY80iEwciEO+et
 Hx8fgahxCQwNxkSPSx8h4q+bcCdWzhI8V4NutNDN2pUF4uzkZK3nl8ShQ4nj4i70QbqFRP9oU7
 LWsoHP3tXwWEAAAA=
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
to its own patch. I also changed a error message in kvm vcpu_pmu from
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


