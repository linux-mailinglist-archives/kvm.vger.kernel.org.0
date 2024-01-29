Return-Path: <kvm+bounces-7333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93463840510
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 13:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 164F61F22030
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260F060DE5;
	Mon, 29 Jan 2024 12:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdxzEoBB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ABF60253
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706531628; cv=none; b=RnnJi0evNL7pekM90Sdv79W17TwXs7TkkUIImesZAkjlKft3zGDrU5GpACfGkkAN9jbB8vqYbKFQxqVv8IKcGJ8dyxn3jJ6v7fUeK1xfUJgCa5qtcMwx1G34WLyUT3fteOvXlffe9O+kooGC3ViDNjJqx1rWacFGfBkvf5yhjgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706531628; c=relaxed/simple;
	bh=sqzR2ktZHVLe14Jg7P2BZw37ENDc+7SaqjpRxCRk2R4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X4c5v7lxCf3Fqvl4Go2bIpoFAfq50sbefWPXSHNbRuQoeigTvC07D07VHOWSWm6Rb7oYTHJjSaeL9ffMKgutk7uIgdyRLfhtayKlOCFAK20ncN972oH7EDG+Cm+byOxYF2+aNBtmPhwFtB/BMNMztBJp5MluUUBMgreJM2mT/Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdxzEoBB; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6de029f88d8so1965749b3a.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 04:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706531626; x=1707136426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NuQMnb4dk+seYoTQCa3cjCXYt3cJXYs8acmmZyBmKk4=;
        b=ZdxzEoBBW6DbAePTWcu4NKxirccO4piZaYqp7/k/yIYpl+v1UrTT+nhgYG1B+yOP8v
         cwMqhbzwaoqSAPB8DmoqhcYFytqZ1qmajKgjWHkdjyq7rQQfhFEECIDAp17jAW3+dRpw
         7Bu9F9aRxlXRfPmtMDmwHwaz1AKvaEEFfxJswlxhISVviY++92TOLhkhSwm/Hg90lfxC
         wza94bQpcSIeyHe9YrNh0pXWLa3zPiZtCggmniIgq5VVZwGw02ftqelHLp3tZ4dg+q96
         3K1LGS4Ymi3twhJ0eRPD4v2Rnct/12gSOUGAHTKWTAzvlaYwg7ZhjjX6eXooOiZedWuc
         oGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706531626; x=1707136426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NuQMnb4dk+seYoTQCa3cjCXYt3cJXYs8acmmZyBmKk4=;
        b=p50wiVDhmYqoJoE0cWf18WLex64pMI312u7PJ+M9OmO1HACcwFuSUecMaQqr0b//ni
         ExIo17563zUFEz52PbGAcKx5RSfQ46HBL4fpLA15ZxiGUXfcKXlAzI57Y9mlJoCVr/EZ
         MQOqrji0JHK0Y1snsirxUdYi8qcRt9VoeZRzdzCUnEBbjpd4qDtmCZR/2/vg8DaQJncy
         rWaFKG+at1/+N0V3YjeorbPeA0ELOQLNxfqffq5MNH8jA/tf0eAJ16gLoelVL292C4Oz
         E00dpq5niQf1QHTmGGiYh8XhXzeS6b6VBvItqw7a+U/mgXSUuEJihp7IIM7LSiQ+z2qJ
         lz7w==
X-Gm-Message-State: AOJu0YyVKPgD/3Wl0nDKcSZmp8EGuP4wSjtMVcRF7IeEwN1zeIhW33kt
	PublPI93w04sH+LJrNxpZm4EvKqcgro+HXujgcwVzrHHByPoqJJVCvuQ2q5CX1U=
X-Google-Smtp-Source: AGHT+IHrOy6+HOSCXr2qfxZcbE75Pe6GcrGZYIZm8b4+ZQjdECH+3tCfoBZbDvZ33+f6A9pKzPsHUg==
X-Received: by 2002:a05:6a00:2d94:b0:6d9:b302:d2ae with SMTP id fb20-20020a056a002d9400b006d9b302d2aemr4835408pfb.15.1706531625944;
        Mon, 29 Jan 2024 04:33:45 -0800 (PST)
Received: from localhost.localdomain ([43.129.20.31])
        by smtp.gmail.com with ESMTPSA id ks2-20020a056a004b8200b006db3149eacasm5742340pfb.104.2024.01.29.04.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 04:33:45 -0800 (PST)
From: Tengfei Yu <moehanabichan@gmail.com>
To: kvm@vger.kernel.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	moehanabichan@gmail.com
Subject: [PATCH kvmtool] x86: Enable in-kernel irqchip before creating PIT
Date: Mon, 29 Jan 2024 20:33:10 +0800
Message-Id: <20240129123310.28118-1-moehanabichan@gmail.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
support via KVM_CREATE_IRQCHIP.

Signed-off-by: Tengfei Yu <moehanabichan@gmail.com>
---
 x86/kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/kvm.c b/x86/kvm.c
index 328fa75..71ebb1e 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -150,10 +150,6 @@ void kvm__arch_init(struct kvm *kvm)
 	if (ret < 0)
 		die_perror("KVM_SET_TSS_ADDR ioctl");
 
-	ret = ioctl(kvm->vm_fd, KVM_CREATE_PIT2, &pit_config);
-	if (ret < 0)
-		die_perror("KVM_CREATE_PIT2 ioctl");
-
 	if (ram_size < KVM_32BIT_GAP_START) {
 		kvm->ram_size = ram_size;
 		kvm->ram_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path, ram_size);
@@ -175,6 +171,10 @@ void kvm__arch_init(struct kvm *kvm)
 	ret = ioctl(kvm->vm_fd, KVM_CREATE_IRQCHIP);
 	if (ret < 0)
 		die_perror("KVM_CREATE_IRQCHIP ioctl");
+
+	ret = ioctl(kvm->vm_fd, KVM_CREATE_PIT2, &pit_config);
+	if (ret < 0)
+		die_perror("KVM_CREATE_PIT2 ioctl");
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
-- 
2.39.3


