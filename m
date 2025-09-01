Return-Path: <kvm+bounces-56520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E932B3EE5A
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 21:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 304597AFE5B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 19:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACEE3321F26;
	Mon,  1 Sep 2025 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SNxZcUlV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805F745C0B
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 19:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756754202; cv=none; b=sf2hHlGvRa8+5ihZtVeuQOqKfYhSwQzofSs5QxiNJSdF8FHMc+eCMbPaur2aJ57MuJ3a6K7fNHLoTvHrSd4+PCR475Trzw6EpY9Yl32MxTvHzxfwhksYGOhWUNXz6qNCkFBi+v7Fhf+nqCLUMDor8TfydstPM7OSp2NLU2stgZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756754202; c=relaxed/simple;
	bh=emVQb/nP+lLVWaTB9qb8A8fdBisYAbLIpQk8DA/49xs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HducBho4zpK3TdHVtIKn1s+txkYXyNVe4Z0LYwPHqc2RTgY3oquW4UpXht9ztcCv+/EUJSvgxAQ/u1sofJRBIkjDezvX0fr7vkq2MXCAMbU5CbapFpfLy8Xj/Bf41JiOhbmbwgUAJ1VYtLlX190l6vZljSJbkSGSCl2fsldeciY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SNxZcUlV; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c72281674so2999933a12.3
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 12:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756754201; x=1757359001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v/cDOfjJq1EkYmNa/Gbni2L6YrspyG8pFR//2Lc47Gk=;
        b=SNxZcUlVfVCpRt4aGA65Vr6PKbvjvmT+2T+WLD6+LnZM8MCR6dxq3kwwKewLlHCOBF
         CvlE3dOsURUzWqF/NtNl0nnlpQaaO0y2uikPMMX26f2kDky8g/Txh1ll30pOIEpKbEdq
         OHlao30jwb3GUc3pYCL3e80xR/iWAky5dbOqNLmejkYrYKHLUQL0BZf5roLq4+OrX4+B
         BxmfpOLaW293d1rFlo/GY4uT5AwIc0b1lYsm1cq1/I4J0Bq/OXGltwAwIkM2TXO5dghH
         x31jjBItGn8rrnfEgN9Jh/tEmykJBbNnpGiCytpNkOeUfjrWAgAGeQD515+nnpFohLb/
         n4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756754201; x=1757359001;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v/cDOfjJq1EkYmNa/Gbni2L6YrspyG8pFR//2Lc47Gk=;
        b=WXWKDkJgItZQWIye05QTz7wxkaOV6o/h9CMiIl9WrefuIQg7AmErvzB5uS9sW6HwKT
         cNqa3OspqlM9KHNrcsUQiSNJfdTwr8YPL1uXRsKBVt22ehCLMkeHiIirxek8PUFnim2d
         4XJICSXg2YUP9zBMTT5UGdHole+vZYluEFSqg1EunOIfxj11ZE/YihoTPGMEKS8ebMZ1
         C+4NXiO0pPeXopyd0HeD5sgCcGswf/BPhSFQwmJQX67va99mL+5NJLl9nKVM4sG5tbfw
         TmlqzBdhovFK2H4aiN01mB/Q7vNJAC8hTqkX6ztUDvyPfXhfeHzCu7X/B1Tkp2bMJL92
         DNLw==
X-Forwarded-Encrypted: i=1; AJvYcCW5ihYZzdLLbM5D0rszMFGXcaKR6HN5qC2S9xLjBisfGGZO8aEMFO5zT9qu+SpJg/JiaSk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBXh8gzOv/XQk1SoNrwf3Kmz2Rh2q2JZ5ECQdA2JtfayRkQ9JB
	HXqpOecLppZmreqVq4w2Kf6yXEfaA+BJTnboTSeZEFEuuXJftmpmavyIOalIvzr0/coXfDGG9Uf
	FfA==
X-Google-Smtp-Source: AGHT+IFBehxccmY6P3WUNdAudSMYMDls3w+IAV/u6ENkFf1eu/6U3mKHoh4N54IqPGrSeQVbaHCKLSaL6A==
X-Received: from pfbih20.prod.google.com ([2002:a05:6a00:8c14:b0:771:f406:9f46])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d97:b0:243:cc87:f290
 with SMTP id adf61e73a8af0-243d6fc0e1emr11733424637.60.1756754200767; Mon, 01
 Sep 2025 12:16:40 -0700 (PDT)
Date: Mon,  1 Sep 2025 19:16:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250901191619.183116-1-praan@google.com>
Subject: [PATCH] MAINTAINERS: Add myself as VFIO-platform reviewer
From: Pranjal Shrivastava <praan@google.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, clg@redhat.com, 
	Mostafa Saleh <smostafa@google.com>, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"

While my work at Google Cloud focuses on various areas of the kernel,
my background in IOMMU and the VFIO subsystem motivates me to help with
the maintenance effort for vfio-platform (based on the discussion [1])
and ensure its continued health.

Link: https://lore.kernel.org/all/aKxpyyKvYcd84Ayi@google.com/ [1]
Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 840da132c835..eebda43caffa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26464,6 +26464,7 @@ F:	drivers/vfio/pci/pds/
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 R:	Mostafa Saleh <smostafa@google.com>
+R:	Pranjal Shrivastava <praan@google.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/platform/
-- 
2.51.0.318.gd7df087d1a-goog


