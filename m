Return-Path: <kvm+bounces-32765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D899DBF28
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 05:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FCF5164B08
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 04:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DEBB155A34;
	Fri, 29 Nov 2024 04:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="KEsnprUQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5827422EE4
	for <kvm@vger.kernel.org>; Fri, 29 Nov 2024 04:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732856373; cv=none; b=qUEp9Sl3/vpPaLQ2Stuyh9rEKagUt+ZZnieXCi0O2ySOFfHJZ+nZSCrnsZ8qXLxIz3jEBTaZJs6GPO5UT+q2avN865zfbz3K4nJH8P1snBbcqQ+hJEGZSsB2b7/YUEJzkdCZBGvN1oLrgNkvlI0/8ECB9hRkG4xsm07Y+suQRiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732856373; c=relaxed/simple;
	bh=7UjT75LFpcvIYRPoI3a+aZIACPWwjFkjaNV0i1Hnjvw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tCK8vPU41J5vwmEU7LaUiw8cwvB+q/1HscRy2IzIWrUlmhDEPNaI+BVatzYRKE7nNdjln8Sndtre7helYY8RY2cbjquSgYS+Nwy4GhZP+3/fRmp+ka3v2QFlljODg7TQp437/8+8Z02tCqKOgd4gyLkXbPPrTmpuaDR25vVU3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=KEsnprUQ; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7b65db9b69fso85272185a.2
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 20:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1732856368; x=1733461168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tf7WtVWN+GZPkD0L+hxuC1OVxaF32A+8u4oJ7JcoqUc=;
        b=KEsnprUQcwTGAU9agoRTjt7ohfwJt9XpN7A/y4NE2ELO7EzCiflwCLJYWL5oWK1Ia4
         A9EFuhQc9i2Ln25WkbhhEUhWCqKFGILE5HUhVlwPKWUVAKlCB+sK9IXyMkocoRt1Ep/V
         Nh4l7W1Jk0J9/a645PjbFe9TbX0gG/VHjejLjzzRN7jzl22cJ9DN+0QhptYTLCKM+OMr
         C67v1z3kg7RjFKHZpYog9e187l/4VFbIfLG4g8PwjGE7Mr+EneJLrjh2TaaehH8Y5Nmy
         iJTA7q9BS4ZSiyHRWJooKDO2Cs0f4YxPYayBQOkMkDUN9iZN2LaJsMMHXfT137fjhEo4
         nx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732856368; x=1733461168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tf7WtVWN+GZPkD0L+hxuC1OVxaF32A+8u4oJ7JcoqUc=;
        b=FkyGMC3ademF9bpcam78Yk6IJW+CSbli5YD2nY7a1hRlauW0IKGhzUyZB69zBLVWc3
         gQI4Myd3pT48SGrXdDP1RW9wKVCoWBqBQ96KQdtyWjCQsWfVns2mn5i0MlM0TPJrc5Vd
         7EsDjATCGhUVifcQO9/AN8WnZGPuwqbLZI0XYLhO5l1mKE1f8he3LLW8rCOQ7VTrIvX0
         TYQcYOVWvUoxhSPyLSvHPnqhCw/33wBcgpRNRLHszJegxFbQz0cnHHK0SmUVhYfs26Ed
         8jcg+t5RjyGA2ypwBJfIYkNYa0flMpVktuQwOuq44tJo2CEDzm8GYV7YGHhuRTbVblCE
         lmBA==
X-Gm-Message-State: AOJu0YwsVBvfaEVcuj3Wak/PCDdmSlilDzBpGRXUfjfoEeF7fon4exha
	AS9D2Y6g6Q5w3lLNVwkpX7JKlOOiRYOMr/4MGqO2hTnZsFunO2fS61/HsON6x2/caqEKodoDjt4
	fhA==
X-Gm-Gg: ASbGncu/ZNwn1E5Ovw2sOdVlhsTzioAuOC2A0wL7iRXuDoPUahBYAKWS1hIs7xVjKfy
	MPw/RaB6Ex0SzC0inezFoyNlCldSp7srmFGMwWRmRh/bOEWL7XmADGXe8YHR9uPGmUmYbED/lcc
	HvMM7YkEcJrQTC7LwXN8tS/mgiJ4Ys9ByAhE9EwvWuiWZoTPOSl9KJg2hqiFx6+rsDOLe7GS3Fp
	saGd6bENl53RqQ15tKfBhzRW1hI1bHwxTvIZRt4BHE5SA8Y/EoyiqW6Nz1geVMEcj6E2KrwGurn
X-Google-Smtp-Source: AGHT+IFwpmZWcW0omfD5TV3Ni72teFcADTBL1PAFqqH4HcdzFhqVJC7b/o+qFozZyZpPcVthEYqy5g==
X-Received: by 2002:a05:620a:688f:b0:7af:cf07:905b with SMTP id af79cd13be357-7b67c256cf8mr1168748485a.2.1732856368662;
        Thu, 28 Nov 2024 20:59:28 -0800 (PST)
Received: from aus-ird.local.tenstorrent.com ([38.104.49.66])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-466c4254853sm13113741cf.86.2024.11.28.20.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 20:59:27 -0800 (PST)
From: Cyril Bur <cyrilbur@tenstorrent.com>
To: kvm@vger.kernel.org
Cc: Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool v2] riscv: Use the count parameter of term_putc in SBI_EXT_DBCN_CONSOLE_WRITE
Date: Fri, 29 Nov 2024 04:59:26 +0000
Message-Id: <20241129045926.2961198-1-cyrilbur@tenstorrent.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently each character of a string is term_putc()ed individually. This
causes a round trip into opensbi for each char. Very inefficient
especially since the interface term_putc() does accept a count.

This patch passes a count to term_putc() in the
SBI_EXT_DBCN_CONSOLE_WRITE path.

Signed-off-by: Cyril Bur <cyrilbur@tenstorrent.com>
---
V2: Reworked the calculation of length as a variable. No significant
change

 riscv/kvm-cpu.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index 0c171da..8f55c8e 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -178,15 +178,16 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 				break;
 			}
 			vcpu->kvm_run->riscv_sbi.ret[1] = 0;
-			while (str_start <= str_end) {
-				if (vcpu->kvm_run->riscv_sbi.function_id ==
-				    SBI_EXT_DBCN_CONSOLE_WRITE) {
-					term_putc(str_start, 1, 0);
-				} else {
-					if (!term_readable(0))
-						break;
-					*str_start = term_getc(vcpu->kvm, 0);
-				}
+			if (vcpu->kvm_run->riscv_sbi.function_id ==
+			    SBI_EXT_DBCN_CONSOLE_WRITE) {
+				int length = (str_end - str_start) + 1;
+
+				term_putc(str_start, length, 0);
+				vcpu->kvm_run->riscv_sbi.ret[1] += length;
+				break;
+			}
+			while (str_start <= str_end && term_readable(0)) {
+				*str_start = term_getc(vcpu->kvm, 0);
 				vcpu->kvm_run->riscv_sbi.ret[1]++;
 				str_start++;
 			}
-- 
2.34.1


