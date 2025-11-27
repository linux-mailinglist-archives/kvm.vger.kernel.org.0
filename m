Return-Path: <kvm+bounces-64797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A76C8C690
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:11:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 43CD834E178
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3B87D098;
	Thu, 27 Nov 2025 00:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zb2sdPql"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E7122083
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 00:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764202307; cv=none; b=DsBltyYUX4zB9PeXff6zAKMmJB9Mj+gGFp2mrdnMJARAiIUCDrfN2NXLC1SmdB7ZuGq+MJjawL35dJlvSpVD0ef+wVQE8cHFUmmPqlthF+DNtqlZlMVDNOV7PeZ46tki3gOVus1/0Tw6LMzQ7c/fld6ZhsyeuHcSVWzxJLPZhBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764202307; c=relaxed/simple;
	bh=U/Qt0fwjclNcK05dUhaILvGCRr9iYZXeQ5XH9CgeTa4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IiEFVWVAtASat0gTvgAhn3gNEI5Ru03mk53BzdOmqsyf4m9yY1V8lCf5B7aHfjsB3Hx+jJyz9tg/FuGVfQJbfZ5o0XUYxyPCUJQLncPLgTeioKxnt/0/X8eFx1AHtenvTgIn8C+aX3/3vbpS9590yyr31epKxoBhVZEOYF/WWOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zb2sdPql; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4779a637712so1431565e9.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 16:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764202304; x=1764807104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Npjor9zv99QfGBBPEe2AIBP/GoEg83/ki3BWEuhSPRU=;
        b=Zb2sdPqlx6Gf9ieMKb0TEUN+rBWJ2Or1Mgff4ydNYIBa8EFhBeAoKdRAtw7NLtxAhC
         QE1wJ46J/HawHjPlZJBtAQdPBJmiKdbzFBpJVZ6G0ZnGuz2SPJaB7C1oeFrpV5zF3plv
         ZKDva1m3lGXZevKUrENEmnklhitb8tmGLgQ89e7dgK6xCw8I6aUZPNQUPfR4/yHFzfDr
         wKHK6qFFM7uSUN6TvStccpJGkunQ06Qbz2EvltXS3DqU6KGa9yant2tE1qhONW0QpOp6
         z1yABfy/WUrmgrchntkuZBXLr33+xOWlKCTYW3AhP6Dkc5GR6Uk+YaeYziINAYfLnUnF
         dRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764202304; x=1764807104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Npjor9zv99QfGBBPEe2AIBP/GoEg83/ki3BWEuhSPRU=;
        b=q9Ga+xWlvgnWf/g1BExXqCGvhYTptoO8hSVhpX6E1NcjCFRlWqnuvmmUPKnfNWDOws
         f2yN9nxJYqn7vOBGPFCoNBfOd5rHB7wDVJoez3pxLle2sPekYtDi5ZRw/SXbGGHDHP2C
         gdgWClhUTrbEOf2F1S+MIsNrbpWI+EdwthKpsv43D/yXhxQq4AmbUL+6uDrGy+TTP/LX
         o5JadGcyNFPkJVZUrCLidSsQuwUt332rJKmNK2YAf4Rg5JefMmNQY+Op4kV6iAlBSiC1
         h5qsr4Zbhif9AKjcVk6f8tJAuVIjq0bJND93XEzyK9775hcbCPYmxW/48LIXf55miaJb
         4xUw==
X-Gm-Message-State: AOJu0YzE44C2fu/K01oYSbyvmFMqqmhzC2jk2Bj2/q/2OEz5FA5HYdCH
	/cS8EyHvi3rp+CjKjEz4pFJOAxzNSX/qK9l76nc3HaQSSBTHu/MZ7T/z
X-Gm-Gg: ASbGnct7GhadLfm7ds5g/mhTmy/W8yhHgG6jLtWTvthyRpEA5QIlgMG1MjCY0d7Lj55
	q121EydihQI0auw5KV0kXG9ACU23XjxLi7OAdM6NJ/3qd3erJNjCBA9LPgp6JiR1BW4X2ZF5CvJ
	qS8/F7OW+aP7Pd3WstZkUTRyL7bKlQY6tpBLrXGe7D4YSs1fOPi93LJ/qu+xkv+yZn1cM8yMmqP
	hemTi7efINnHbbKe+tuBOocNbTUird6To1OcQngoxCcwa8WjjsaExjnBjtk3trIvWgP01a/Sga2
	ZbF5EJJroG0VZy9lwLErW8dhSKniRyABXfZxUSQUoxG3j2MrwbfZlNbA+ikgVVVM2p6xG/LAyoN
	a+Xtm9YElHFwpofx8iecRNdkj0QrV1LE36AvSfZCX3foQV9CFYdbOjbC2chYCXshhS0I2dDjieJ
	MgFNr6EM1dvfthlyh2w8uB8kzM9h/w07mUkoVPJMtRe2exUSCRcLz2afhpyGpYT1QASZfTJz+P
X-Google-Smtp-Source: AGHT+IFfNXdmYVNGq0Jx4N8NyOWnTBj4yEXNWpHEsVPE37ptyjckjYJVFSpElqvAAd7D1yUotu9bSQ==
X-Received: by 2002:a05:600c:4e87:b0:46d:a04:50c6 with SMTP id 5b1f17b1804b1-477c01ebc76mr206612645e9.30.1764202304263;
        Wed, 26 Nov 2025 16:11:44 -0800 (PST)
Received: from localhost.localdomain ([197.153.73.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790b0cc1d6sm65937725e9.12.2025.11.26.16.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 16:11:43 -0800 (PST)
From: redacherkaoui <redacherkaoui67@gmail.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	redahack12-glitch <redahack12@gmail.com>,
	REDA CHERKAOUI <redacherkaoui67@gmail.com>
Subject: [PATCH] KVM: coalesced_mmio: Fix out-of-bounds write in coalesced_mmio_write()
Date: Thu, 27 Nov 2025 01:11:32 +0100
Message-ID: <20251127001132.13704-1-redacherkaoui67@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: redahack12-glitch <redahack12@gmail.com>

The coalesced MMIO ring stores each entry's MMIO payload in an 8-byte
fixed-size buffer (data[8]). However, coalesced_mmio_write() copies
the payload using memcpy(..., len) without verifying that 'len' does not
exceed the buffer size.

A malicious or buggy caller could therefore trigger a write past the end
of the data[] array and corrupt adjacent kernel memory inside the ring
page.

Add a bounds check to reject writes where len > sizeof(data).

Signed-off-by: REDA CHERKAOUI <redacherkaoui67@gmail.com>
---
 virt/kvm/coalesced_mmio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 375d6285475e..4f302713de9e 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -68,6 +68,14 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 
 	/* copy data in first free entry of the ring */
 
+	/* Prevent overflow of the fixed 8-byte data[] field */
+	if (len > sizeof(ring->coalesced_mmio[insert].data)) {
+		spin_unlock(&dev->kvm->ring_lock);
+		pr_warn_ratelimited("KVM: coalesced MMIO write too large (%d > %zu)\n",
+				    len, sizeof(ring->coalesced_mmio[insert].data));
+		return -E2BIG;
+	}
+
 	ring->coalesced_mmio[insert].phys_addr = addr;
 	ring->coalesced_mmio[insert].len = len;
 	memcpy(ring->coalesced_mmio[insert].data, val, len);
-- 
2.43.0


