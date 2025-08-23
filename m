Return-Path: <kvm+bounces-55568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7864B32A36
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 18:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F14F681346
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 16:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2A82E8DE0;
	Sat, 23 Aug 2025 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DAwdmn+Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52DD2E7BCD
	for <kvm@vger.kernel.org>; Sat, 23 Aug 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755964804; cv=none; b=KryD2sc9/1yzCx1a4HRuhEsDtdt6Ddrm7m/qdthXr4/kXk+vGKpC9wm9JdZaWI+WJvvWptiRGc0hg7gvPV7vL3iCu4/Lg92cEivtf2Brp2mBdok/X/TP4z+FpXAum5+GAz4CjA2ZqdfgFZ7RqsfOshRo7bPAQNd59HTQ2TzN0RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755964804; c=relaxed/simple;
	bh=dK+CR3Hpw7kGgKQtXxubea1aCAm20tR0xK1kEUaSbEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DAY9hiAwxgOHnc7k3R8TJwrwj/Tv/vN0k0iYkfvvb5ocDxqKObNvU5ZUiPvcofNKj59VUlERuIkTmyiO/jJKc7owwB4WgEfEQ6EWQuPGZsiY2OwaL7MH6HTI5MvA4ZfxitbVzOKyRgIL208kaxchzDCBGqmHIX5j16tv9imejDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DAwdmn+Q; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e6cbb991aso2697398b3a.1
        for <kvm@vger.kernel.org>; Sat, 23 Aug 2025 09:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755964801; x=1756569601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H24QVG/T3cxixN5Hjl4PI98/BCvc+2mgYT4CjAn1N5o=;
        b=DAwdmn+QCIub+wf1aZmp/lmq0EDc+wYhJLul6JPZyMaV+fo5gzKKZHXq6UpLu7X2lk
         JDwMStIX87HbFPsASqH1M+k0s5uCa3NNbgKMLx/vu4cptnXAEYL6+v6y8sSOKdLSLTJc
         6jY3y4brA9v8TsLZeA0Xg/l4Yvce2yGtkVhhmOf47IY2S3WXkrHHAHP4OATI1Ik16rQE
         BVRtXDtviTvEjOVBEAHLMbH20EptaavlhhVbDr+kaaeMlYTP3nH9I5RptYHyx7iFxarx
         t933K4c7T7YYNhrUsyA1GSVJg+mlWDyuY2UshqHVds4/+T3jYEDpxfFggz7bzw6c9RLL
         8bcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755964801; x=1756569601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H24QVG/T3cxixN5Hjl4PI98/BCvc+2mgYT4CjAn1N5o=;
        b=hiCEJHX98W70ADBuYcuG2j2dQ6X7K7I3UnJPQ0Zf6LGQqLMFUvlPz5tKuScdb+DkFy
         ku0EDytJtr81tOiI38CD0rNkUTEYaNxnMkYtWut/Bvton+jJs7sYRP+HojzgR7Kr241R
         VrbBMIOIeu4WOtUgtDUGWvXH0OYqyHG+0spwKcDW0Hsbwz6C5mFBu0HuvDi+hlJRhHe1
         KvcFfrYAjHbrVGb2zcuz9kVZZ80QbLgSU6xnGOdDi3YcRjJYyfAqWUtQoQeIud/g52mZ
         Yd960M4d6voo9bzuf2TrnDIaDtCTR184YVecPaTsLhSNRNLp58TAShFf7VFGSZ1TPq7I
         ZytQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnm0nRZ/FWy5jXe+pkO8uzRHacpGLY7Xo9hgW5dOljAeMCV9p6xX3Yht7Vy03Tu8LMMO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM3678komSGKui93YaHjIBxzZaVgrVy540zZD06j6vfou9aGtp
	1fPVoQ8zFSHkrFNahhFgYUpwT2v1CJBzmENLToJHGQqSfX/hyKJoc65sCIX8W5xPh5Y=
X-Gm-Gg: ASbGncv2ysbVM+51xbZ/3eTW8zBireSEHDWc4tm07k8wKDuWaxJu/8gXFkJ5oE2IDio
	0GDFZ11ECdQ1ANMlwyvDrJ9KujgZf322GICHsObxgjMYbvLy/16M+R5i9Q3dbo1aluAn59VXIrb
	XkuOxDUF5PraxuYWR7v1HGXUoShqsj8pvA0GjpWfXziiZKDEWlKViGVtoZjd/MtKDRPYnSAAv+r
	5Muc468VLm1Z+dKyldIvAsiCGqrcivC8TArGXYM7sWqHZBjkaToQFun5rtA0Fk0LVZvGFLW0bd1
	+jswFzNc0k103Io5mn6IDzmc2p4GUCtgr1W1p44ngGKblZeEN2lTAX72aLrKASGtAUsz9uZzjnS
	xTgg777eWjhfc3GhtaGGUEiM+8k4JjyFtcAQ0+cg3dKjE+1z36IN+R1jnz00JoawnVCP6TpUc
X-Google-Smtp-Source: AGHT+IHHBn4yz0Tv2mtxye/b3d+njwhsYjSP/E2IAAVTTBKNql/cK/uY7eFReM62Y2BttpdFYMcwWg==
X-Received: by 2002:a05:6a20:1592:b0:23f:fe66:5d2a with SMTP id adf61e73a8af0-24340bce2c1mr9575921637.27.1755964800673;
        Sat, 23 Aug 2025 09:00:00 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77040214b81sm2804464b3a.93.2025.08.23.08.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Aug 2025 09:00:00 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 0/6] ONE_REG interface for SBI FWFT extension
Date: Sat, 23 Aug 2025 21:29:41 +0530
Message-ID: <20250823155947.1354229-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds ONE_REG interface for SBI FWFT extension implemented
by KVM RISC-V. This was missed out in accepted SBI FWFT patches for
KVM RISC-V.

These patches can also be found in the riscv_kvm_fwft_one_reg_v3 branch
at: https://github.com/avpatel/linux.git

Changes since v2:
 - Re-based on latest KVM RISC-V queue
 - Improved FWFT ONE_REG interface to allow enabling/disabling each
   FWFT feature from KVM userspace

Changes since v1:
 - Dropped have_state in PATCH4 as suggested by Drew
 - Added Drew's Reviewed-by in appropriate patches

Anup Patel (6):
  RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
  RISC-V: KVM: Introduce feature specific reset for SBI FWFT
  RISC-V: KVM: Introduce optional ONE_REG callbacks for SBI extensions
  RISC-V: KVM: Move copy_sbi_ext_reg_indices() to SBI implementation
  RISC-V: KVM: Implement ONE_REG interface for SBI FWFT state
  KVM: riscv: selftests: Add SBI FWFT to get-reg-list test

 arch/riscv/include/asm/kvm_vcpu_sbi.h         |  22 +-
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h    |   1 +
 arch/riscv/include/uapi/asm/kvm.h             |  15 ++
 arch/riscv/kvm/vcpu.c                         |   3 +-
 arch/riscv/kvm/vcpu_onereg.c                  |  60 +----
 arch/riscv/kvm/vcpu_sbi.c                     | 172 +++++++++++--
 arch/riscv/kvm/vcpu_sbi_fwft.c                | 227 ++++++++++++++++--
 arch/riscv/kvm/vcpu_sbi_sta.c                 |  63 +++--
 .../selftests/kvm/riscv/get-reg-list.c        |  32 +++
 9 files changed, 467 insertions(+), 128 deletions(-)

-- 
2.43.0


