Return-Path: <kvm+bounces-45467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D90AA9E20
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 23:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52530189F529
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C422741B9;
	Mon,  5 May 2025 21:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="g40iMQg1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A91156F45
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 21:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746480511; cv=none; b=lPJZgN02w03R6DWmHqWSajzXdPPfcPMvbf0ObS4AKZ217Teg5nZNSq2394uUdIb3XzIcPVPGbSYbYJZILPXJSFSvebrQh3ZriFP5zatsqQNRbnLMj37kKMaoiysECpZrvrTWu4I0NdpbXqZ0+CpqM1uVKB0RkmgYFnyIcLvckZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746480511; c=relaxed/simple;
	bh=f1hYP84SUeIeWVw/aO7ZbaGocyQWnnY64RH/tbZs0VA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=U8vGdrCcrvnvFqWZFdqrP2vtTjHQfr5WYpESPusekxjRedt8b3NA3HXvAtGqTHM2zg+b06Nuxs/CfR+cW98wsMjhEMgVILdVbgS0ERx37rJfKR/h84YMZPqtjTX+660+7tuJlB0YwZip2a0mD6l70RYeMFePz/wSWI8/7pcY578=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=g40iMQg1; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-73972a54919so4576711b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 14:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746480508; x=1747085308; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=26hdnx+Qx/nkLZaujdf27gbYCjpgudGZl7RnEQteaII=;
        b=g40iMQg1ZFuesIP1/B8Evx+4b3rzsfZ7sYHMNEncogXbdTBP5c29r5EUGIr283Kk0W
         mw37q3tVxu1NV6cRnMR/5rHH6BJNEDyv7xV9Qn7yD3fji0eBow67EIdO5dCSH+OdH5zG
         7ioRlPoVy8iSiOlFbSc1EFT2UE+BttLfoF54CChXr3gq30TtbFHFtTjEve0ke8ZLwHa3
         j+iTafkF7Lrr5UfPXe5q7VHKTjBtaF3lBw7ulFBeMqlK7J3jhrCIUYwTGH36PNh7+F23
         BHlYojmAnl0QxwEUM452mspfpOgywYbfJg3lzl/9MHr9Tm6/pliVDpvMxgqcBY71UAV3
         S+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746480508; x=1747085308;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=26hdnx+Qx/nkLZaujdf27gbYCjpgudGZl7RnEQteaII=;
        b=uwCT+PKBA5B1G+WnB5yT4hLYld1j+fLCmyKEzVexVs6pjlWf55We12l/ydZx1/MxAI
         cT0KJ3QzAzJ0+fQagIc/hamfl21sx7fsniEblTQdHXzdk2JtuXzEyPWw5RbPuOQ8ljiH
         d+GLY7QH27gOFu4JMSyCn1FsJB64AUehA51+b6Ikxs7gj9PjYbX7txjso3cATAmsEZXC
         d7Lr2hK524txE2Jsc9YfmCkLUMjXG/cbM2aU8E4josjqja+I0rvvlHlO5wfuJyMRHCy8
         bwdbRYym6ai+KSTbQNCMo2aYjNE1PADPjMs7Bz+nVW76FRAs7zNFdR94ZwwVHioSPyCf
         Cubg==
X-Forwarded-Encrypted: i=1; AJvYcCXS0O2qTFeL+JUksi3CoiOxxVvcRss9z3PLqcPKQG+md3/lwE+GmcjX4aErfXseuwKaYI8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTQNRrdS92oPCMGntCpH2UZ/T9K7d3fcWThfbu5CCVhh9M7Efp
	WMEJNk2nIS4Jd8MgNqy9LTnNDcS4z8xHS55wYw3pMZkdLMBoEDkt61hIbyMpf/0=
X-Gm-Gg: ASbGncvxcTDGZiGwT+soBsJxFnIwUtNaL9Fn6GBR5ygk+gsPeAyknJ/j5cjUiwelgRZ
	YCoY5TlGrgGLzENOWDZZ6U6s2Z7psijiO/eGCvTQ51+06bWO4mIJORJUryoFk6Sag8IPI25dO2p
	Z/bBKsNXIIaRzzGzkV5i2+eXlPGgMtw4jbmaJNTcajkD1WsXI4xdfVy5kIcq7+b1yUqfYLMGjhw
	Nyt4fgNc9lTKEMh7Qa8CBpM38aOuvGtaQIgpXsjq97Y3lNrtP2HBjR3ur1ZD7+LuENG9X1GjjWE
	DooGWRBCOPxKbujFvhmzQFB5gs0lwU2QezUgKK0DcGm8jpWu5I3JMA==
X-Google-Smtp-Source: AGHT+IHEMWsBZWNumu9i00+bT5zqJ+OBY6gmgedReBkU4n6QkDfOYR7NZTzbvbGaF1bdlf+ezbf61Q==
X-Received: by 2002:a05:6a20:ce48:b0:1f5:51d5:9ef3 with SMTP id adf61e73a8af0-20e96ae5978mr12840533637.20.1746480508080;
        Mon, 05 May 2025 14:28:28 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058dedcc4sm7370367b3a.79.2025.05.05.14.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 14:28:27 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 05 May 2025 14:27:38 -0700
Subject: [PATCH] MAINTAINERS: Update Atish's email address
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250505-update_email_address-v1-1-1c24db506fdb@rivosinc.com>
X-B4-Tracking: v=1; b=H4sIAEktGWgC/x2MSwqAMBDFriKztlALfq8iUop96oA/OiqCeHeLZ
 JVF8pAgMISa5KGAi4W3NUqWJtRPbh2h2Ecno02uI+rcvTtgsTierfM+QEQVval1VlclqpJiugc
 MfP/btnvfD8uL+XRmAAAA
X-Change-ID: 20250505-update_email_address-6c2901987e87
To: Anup Patel <anup@brainfault.org>
Cc: linux-kernel@vger.kernel.org, KVM General <kvm@vger.kernel.org>, 
 kvm-riscv@lists.infradead.org, 
 linux-riscv <linux-riscv@lists.infradead.org>, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

My personal upstream email account was previously based on gmail which
has become difficult to manage upstream activities lately.

Update it to the more reliable linux.dev account.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 .mailmap    | 3 ++-
 MAINTAINERS | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/.mailmap b/.mailmap
index 9afde79e1936..f7a81702309e 100644
--- a/.mailmap
+++ b/.mailmap
@@ -105,7 +105,8 @@ Arun Kumar Neelakantam <quic_aneela@quicinc.com> <aneela@codeaurora.org>
 Ashok Raj Nagarajan <quic_arnagara@quicinc.com> <arnagara@codeaurora.org>
 Ashwin Chaugule <quic_ashwinc@quicinc.com> <ashwinc@codeaurora.org>
 Asutosh Das <quic_asutoshd@quicinc.com> <asutoshd@codeaurora.org>
-Atish Patra <atishp@atishpatra.org> <atish.patra@wdc.com>
+Atish Patra <atish.patra@linux.dev> <atishp@atishpatra.org>
+Atish Patra <atish.patra@linux.dev> <atish.patra@wdc.com>
 Avaneesh Kumar Dwivedi <quic_akdwived@quicinc.com> <akdwived@codeaurora.org>
 Axel Dyks <xl@xlsigned.net>
 Axel Lin <axel.lin@gmail.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 5f8688630c01..cb8cd92a1ce8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13071,7 +13071,7 @@ F:	arch/powerpc/kvm/
 
 KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
 M:	Anup Patel <anup@brainfault.org>
-R:	Atish Patra <atishp@atishpatra.org>
+R:	Atish Patra <atish.patra@linux.dev>
 L:	kvm@vger.kernel.org
 L:	kvm-riscv@lists.infradead.org
 L:	linux-riscv@lists.infradead.org
@@ -20878,7 +20878,7 @@ F:	arch/riscv/boot/dts/sifive/
 F:	arch/riscv/boot/dts/starfive/
 
 RISC-V PMU DRIVERS
-M:	Atish Patra <atishp@atishpatra.org>
+M:	Atish Patra <atish.patra@linux.dev>
 R:	Anup Patel <anup@brainfault.org>
 L:	linux-riscv@lists.infradead.org
 S:	Supported

---
base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
change-id: 20250505-update_email_address-6c2901987e87
--
Regards,
Atish patra


