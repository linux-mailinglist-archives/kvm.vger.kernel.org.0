Return-Path: <kvm+bounces-20344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5ABF913CDB
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 18:46:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FEEA2831F0
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 16:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D713183094;
	Sun, 23 Jun 2024 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P/ISI/IL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ADF18306D
	for <kvm@vger.kernel.org>; Sun, 23 Jun 2024 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719161194; cv=none; b=C6hQwSP7X7XVEPaO5SrymuopQ/nuU+BZyiIzzkjAya9IT8DAI3XgdVULxkk7DjdzghOKfDhzj/jgCg96f+FpuIVNYzVlTjo57lXNK/4CaJzev1Rwn47m7tXYDBfrLiWAZ0nWq24urtx3Yt9lJAMhgqZ/qCqNoBvh8kjqs5IDjts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719161194; c=relaxed/simple;
	bh=TpYgag2AWfY+r8n0EVy95+D1bg1611Qel1rooGm/U+U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XQgE1MRXz4QbDOdLrSeC6T+Ad2DhFU6VQUyUf4ygo7n1IHsKCuerpoGxJZ2VP62DbeSvC/5xGn1+gWrb8Yx7qf2n0QU8xUlAo4sPneovMIPpYHD4gfEMHyoT+WfcB2FNox2uJB9mtR19s4sNxJRUwJtJZZXoNhJiFyRkqrBqH1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P/ISI/IL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f9a774d7e1so37598655ad.3
        for <kvm@vger.kernel.org>; Sun, 23 Jun 2024 09:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719161192; x=1719765992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2v8/X8JxGRN8NdNpnyhVNdtUd4APq1zc20IQH5DoRuQ=;
        b=P/ISI/ILXUXc2Ba2NKZaM2muxUQYwwuhpDJ0Axpt7g8uqOv8vYiNKylvmrqt1rJJN2
         7GNyj/TfnpIiRBiRHklv+sXbeAcW3Z0f5L04Z5GMETcNARSw1oiipiFWFCf+YJOlj6Z1
         gIX2FrFxZjKacH+YtGufC1Sj1DqdRijr7PWtf8bp7GBbQlc+eSgbDWYuet0MfoAW2Go7
         eokWErzDeRU2jxm1uFgEZ9WiLbiuWSoTB0FjeP77XkACEitO4+8R7j7vXHohxiUwTmuq
         p8AFfw28oshC0VzxF40glem/zHzYOV6d6y3slf21JRZKleWIAVCycddj/Zcx4VNkDSwJ
         IqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719161192; x=1719765992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2v8/X8JxGRN8NdNpnyhVNdtUd4APq1zc20IQH5DoRuQ=;
        b=isA0smnsv1VxMvErh5Qsvz390xIddkoNP8taxkr38WJ3i3kZjV26HFljK7yy8/ikQp
         q9WA1JgpljLYuT3+fmuFpsMqOaHr/3yxv4Ps7MfmuV+8GRZ+uvAeQXsvx/mtHRDIhCgx
         +kiWIDgFdAQVK4bgibO4ixs3h405D1uV0dAI0bHZL23OwU49ODjireiYzIw5bgSp1oMG
         6rgJpiiCrzr3IFAlYcVejiL+bzKddarGCxM1ivFo5bKCLnjxbxVylSP2gdJQcG1zRR5L
         RQzlm0iF0+1Osd/JkBf/uSj92kg6wy1h1npJJDMKx1VCk8IsA9/UB66s04Xf1fmebtDU
         Othw==
X-Gm-Message-State: AOJu0YwqqvuQKmkBV9EKBoOTHZAa9L6CcsyyM21QfhYzbwesHF3FVt3s
	5KnEUf1Io7ayu6NkwaKnFhnQ8+tmvZ0UyPFl67wJAMjHdRqyugyKk64Cs4Ztqs3R2AvNMc6cajq
	wMoVGPROdbWS3TGZWJQ==
X-Google-Smtp-Source: AGHT+IHwJfMeb6Uv/DNFCAk3a9X1skCCHl4ZuNGhDYw35DtC/v/kvgSjh4eYTWru9eh+bqoYw7yDcBUJW7HUkF0r
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2a3:200:c9fa:2a0a:34fc:4e66])
 (user=changyuanl job=sendgmr) by 2002:a17:902:e752:b0:1f9:aafc:1ebb with SMTP
 id d9443c01a7336-1fa1d6b39f4mr5288725ad.13.1719161191876; Sun, 23 Jun 2024
 09:46:31 -0700 (PDT)
Date: Sun, 23 Jun 2024 09:45:41 -0700
In-Reply-To: <20240623164542.2999626-1-changyuanl@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240623164542.2999626-1-changyuanl@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240623164542.2999626-3-changyuanl@google.com>
Subject: [PATCH 3/3] Documentation: Correct the VGIC V2 CPU interface addr
 space size
From: Changyuan Lyu <changyuanl@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Jonathan Corbet <corbet@lwn.net>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	Changyuan Lyu <changyuanl@google.com>
Content-Type: text/plain; charset="UTF-8"

In arch/arm64/include/uapi/asm/kvm.h, we have

  #define KVM_VGIC_V2_CPU_SIZE		0x2000

So the CPU interface address space should cover 8 KByte not 4 KByte.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 Documentation/virt/kvm/devices/arm-vgic.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic.rst b/Documentation/virt/kvm/devices/arm-vgic.rst
index 40bdeea1d86e7..19f0c6756891f 100644
--- a/Documentation/virt/kvm/devices/arm-vgic.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic.rst
@@ -31,7 +31,7 @@ Groups:
     KVM_VGIC_V2_ADDR_TYPE_CPU (rw, 64-bit)
       Base address in the guest physical address space of the GIC virtual cpu
       interface register mappings. Only valid for KVM_DEV_TYPE_ARM_VGIC_V2.
-      This address needs to be 4K aligned and the region covers 4 KByte.
+      This address needs to be 4K aligned and the region covers 8 KByte.
 
   Errors:
 
-- 
2.45.2.741.gdbec12cfda-goog


