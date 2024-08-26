Return-Path: <kvm+bounces-25031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BEB95EA35
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 09:17:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F11A1F21A83
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 07:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E5313B7A3;
	Mon, 26 Aug 2024 07:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zMJid53t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225FA13AD20
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 07:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724656625; cv=none; b=urlqc+GjrnC6DQ2SW9I5cewT/K1yLMIr8ks5WJ3Jcpmc0lUsjCLfssVzwfETk12dT9dMVf+KkIWHkWjEMMa1CBvs5vHMoUryd6rpsyhmP074PC63UALgap4gPMYxLhY6FBBE/1r48uItvaQAy68BefWuBAnYDRQoa+LSP/+wBxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724656625; c=relaxed/simple;
	bh=FwDerl9XfOepzosKt3JEHoXPHsvu6Cl6My4q4umLuAQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JepUPkoV53vkJbKrW+rbVLj5T7qe5eD+7dUSQfvvzqh0GZEmUxgqIjIBf9xgzVmDgjemktS/wf9n5HbvZ8tw0vtL0rVdOKsoiY/H9th1xszQ7pcc+RzYIJacznj3NMg7Am/BgLv1dXn/yjkhrHgocpsp5gOwnrWsTHrX7P8oATE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zMJid53t; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6c3982a0c65so75717877b3.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724656623; x=1725261423; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UlAkpThGXQLvVPx+k8dqLCpxi8en9zSnxpsu3M8WXYc=;
        b=zMJid53tpcWt43X2JLusCAyiQLgL6b/54PsIBLumkvGOMPFGuEBiVoWDSf/W6CwotL
         UFMf/N2a9fdsbghEA1zwtYZ++eNQloWnhYNqFTCpuvR4Er2gXA0rCZzGMtFjv7HwmjNh
         Ye5xt/gL9PGzcI/6bBTVSYOFAQ2gB3F5QaxliS3mgXcAKfh3DvYmrwj6tGVdzOtSO4nl
         vvVzyrZ8wVdiyttg55L0HKxoclF53Sh61BKhf4za34AIxsk6D3W4OGQrGEMxCJCDZgap
         3jR5UuoxZ9ndP2Sax23qp3sYE1avdaGxaEY9y++sxb7/dkygCve2xiBsaLyiKxIyi29D
         GUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724656623; x=1725261423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UlAkpThGXQLvVPx+k8dqLCpxi8en9zSnxpsu3M8WXYc=;
        b=B9T28hOgkOdhL/nxM/sk1yOqGRrla0RY9aEsSqW02TQLjp+28HzwP/AqiOv7MJKAEq
         +QJxMvIzjasJzScZv/XXvXTyTgN4P+595Z4HuSVJYYwRRmkDobTx73/z8mZiCg9nh8T9
         E7TfQWj3+4usEUN/p9IYr3YgASITYLpAou+53Lr1+kDMznebRfjJvAuhDakFaXOdqOZv
         o8RtFAT/ijKAbuu+YT396gHYLDCjzUvZQBGtguxWXB77xA4KCvc7uGIn9ezkuf6jQ455
         Eh5OPgXPtqPwqD9rsYrKJG7msEOZ5si+aueDDk6vbKFWx2v8eeZsqoALoi7h1LTmYpia
         L4vg==
X-Gm-Message-State: AOJu0YwBzyBmyIVMU1lFqTdNBMz5ObT6Rq1eyS09KxBJpXv4pZlVX5kr
	CfwB1wmpSIiYtHz2GUkTS7aMF9Vfdr6p57AMz84CWxXGLT06k84gNfiN2aUpNgm/kCBo9czhjPw
	mEA1EEmJ9nwrOpj3hmw==
X-Google-Smtp-Source: AGHT+IGTv9O5nWsMNvAuvREulYcA7bXvWQ9CujjRqJDianvCbgB7Y8UFv1A0WfQ112BR7wvtStav+ASLkpwyAOMW
X-Received: from manojvishy.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:413f])
 (user=manojvishy job=sendgmr) by 2002:a81:dc07:0:b0:691:41f5:7f3d with SMTP
 id 00721157ae682-6c627f0b1e1mr463277b3.4.1724656623018; Mon, 26 Aug 2024
 00:17:03 -0700 (PDT)
Date: Mon, 26 Aug 2024 07:16:40 +0000
In-Reply-To: <20240826071641.2691374-1-manojvishy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826071641.2691374-1-manojvishy@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826071641.2691374-4-manojvishy@google.com>
Subject: [PATCH v1 3/4] vfio: Add VFIO_DMA_MAP_FLAG_SYS_CACHE to control
 device access to system cache
From: Manoj Vishwanathan <manojvishy@google.com>
To: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, Alex Williamson <alex.williamson@redhat.com>, 
	linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	David Dillow <dillow@google.com>, Manoj Vishwanathan <manojvishy@google.com>
Content-Type: text/plain; charset="UTF-8"

This new flag allows controlling whether a device buffers should be mapped to
sys cache for mapped DMA regions.

Signed-off-by: Manoj Vishwanathan <manojvishy@google.com>
---
 include/uapi/linux/vfio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf190..494611a046d3 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1560,6 +1560,7 @@ struct vfio_iommu_type1_dma_map {
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
 #define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
+#define VFIO_DMA_MAP_FLAG_SYS_CACHE (1 << 6)	/* Sys Cache able from device */
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
-- 
2.46.0.295.g3b9ea8a38a-goog


