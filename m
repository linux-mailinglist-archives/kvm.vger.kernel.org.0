Return-Path: <kvm+bounces-13436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE518967B7
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 10:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0B4D1F21A3F
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 08:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4716183A0A;
	Wed,  3 Apr 2024 08:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LoaKepvw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B72823DF
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 08:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712131535; cv=none; b=shoim89Ox5KFoHhfotkbkjjq6+DlRBxZP0jWgopPVPiNMVyUNFqK0HIRNUoSNXn9Pd1yPVHGlak1np9LXiFzowREecCytWrEY3W383UfUXJrJKfEPv5YuAdlhgsiKmVmfRDc9DyxnxgljD55Z0ik0BKLXlpJJ4upuNoGEtMdvHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712131535; c=relaxed/simple;
	bh=+BS7mctHpN9iWLFPEwC2/74zIoWzY97OXSTjHAOIU1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E7v/Gjj/Ilx22hwOwcBTIeelMLst7z7g1S5IP0pvh0nLBUHrwIzFX6xTZDXsPB6wJPmaDdMlLoIgd4cvbXaBnb4R8Fur8b06Nmvp/0RH6HoClFeiYQkUQaAuFZYwYe8qA8Bij+Qbbo60bPHmrcw3R/ix9LtZRUQLQN/FQOhvh+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LoaKepvw; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5d3912c9a83so3636559a12.3
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 01:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712131533; x=1712736333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLadZMY/1E+aj61iqE390ie32fUnJXqsMN5cFXtebck=;
        b=LoaKepvwpIgMgTETh3kzvXiZiZwSk+B9o73db2yUsrHf0PeqmmT4O4FXUjdiF6lgH9
         +SJTk8Gp6utJJzIeThkrwLJp0MkiycHvkrPfjfaUDYF9G0kuF2olWU0A9/MGQcI/1YHq
         ePSbSQa4NDp1GdSg5ozbKaFx6dny/viVqIQhIhfawKkC8GCzYZ86G/Np1ZnrHtrEdzFG
         Ia31qc9p6AvwgtLwXeT23pDuQCNoDayhHtGguhQ//jSZsvEW+nsWqQ8tNS7uMugcnWK2
         0qApW4wFGj1MmdZNsRCk5LFO9sekAdwsTLJCTs9wmR3OsbpnYZmHXW5TFHHWYI76Z315
         17Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712131533; x=1712736333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLadZMY/1E+aj61iqE390ie32fUnJXqsMN5cFXtebck=;
        b=Uy/QV30zeZWDXBSIebFbiMMq/9q628cxcs+B4tU+zh5T6GcpGwx5EZiEqUaWOPdp3n
         Hkd1lhXQLTKhb3RxzmgG8dBDri1uPCROx3ED7KDYFves0nV3/Lycw8sJPaxeZ7OGG5Xz
         IeN7/9/+lFx+PahOdA5/Km9XPwIutXySbKoqe3Pi8O8tXxbGQsm46EQtIu6NFkM2smcA
         tneJ4gPaA+4BeDkmHy729wVGvQsZ2h2Qk4hcSq2/7yy4BfCITjrARfiW/dHLN1TGmDxT
         ZJEKzqilldgjgHOG29KqjlcGAmW5xzpj5KpgER1sjI48Ytjz2iJ5/olJ7scj/GilD+7k
         DhCg==
X-Forwarded-Encrypted: i=1; AJvYcCU1YIWLWcKLK4g9rJ/cVWD48j9HmglatUps074ePI3KvrgIlTsbQaoOTPUsxSHUTpDA7V/8HqoZUbiwSNMIzaodPidR
X-Gm-Message-State: AOJu0YxpwrjihsCyHRem+qFA1z6hua1457MVV02Z+wPpIIy7hDKCkVnr
	RR2JLXy9WGCq2VTtITRGAc10/scTRHCusAJzOxgfUp4F4G5jA/ZvRnf0/7pxOK8=
X-Google-Smtp-Source: AGHT+IHYBgMwEeWVbd4P9PNDRXwi0PIWRTlB15cj+AGKTpxTy9q1IU7RrYP0KIGaFYPVod/3S9sbOg==
X-Received: by 2002:a05:6a21:3294:b0:1a5:6a85:8ce9 with SMTP id yt20-20020a056a21329400b001a56a858ce9mr2619252pzb.12.1712131533285;
        Wed, 03 Apr 2024 01:05:33 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b001e0b5d49fc7sm12557229plg.161.2024.04.03.01.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 01:05:32 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <akaher@vmware.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Alexey Makhalov <amakhalov@vmware.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v5 10/22] RISC-V: KVM: No need to update the counter value during reset
Date: Wed,  3 Apr 2024 01:04:39 -0700
Message-Id: <20240403080452.1007601-11-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240403080452.1007601-1-atishp@rivosinc.com>
References: <20240403080452.1007601-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The virtual counter value is updated during pmu_ctr_read. There is no need
to update it in reset case. Otherwise, it will be counted twice which is
incorrect.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index cee1b9ca4ec4..b5159ce4592d 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -397,7 +397,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	int i, pmc_index, sbiret = 0;
-	u64 enabled, running;
 	struct kvm_pmc *pmc;
 	int fevent_code;
 
@@ -432,12 +431,9 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				sbiret = SBI_ERR_ALREADY_STOPPED;
 			}
 
-			if (flags & SBI_PMU_STOP_FLAG_RESET) {
-				/* Relase the counter if this is a reset request */
-				pmc->counter_val += perf_event_read_value(pmc->perf_event,
-									  &enabled, &running);
+			if (flags & SBI_PMU_STOP_FLAG_RESET)
+				/* Release the counter if this is a reset request */
 				kvm_pmu_release_perf_event(pmc);
-			}
 		} else {
 			sbiret = SBI_ERR_INVALID_PARAM;
 		}
-- 
2.34.1


