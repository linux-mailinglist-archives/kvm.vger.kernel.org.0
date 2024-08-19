Return-Path: <kvm+bounces-24473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C4E9560B2
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 03:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57B2EB232F3
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 01:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A721BC20;
	Mon, 19 Aug 2024 01:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SKi3hA9G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B09FC02
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 01:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724029331; cv=none; b=OjR7rmqFz+fJEoofIPsg3ycl16U8sjExS8hDTTgCkWpSqous+M/hWsRG8VEdYgOaFkblhkF+jKymtpfdU70yRAFIsKyyjFRk/oWTQRsuOk6dijBDUqpUqnQMA8mobZL50PHgF2nlOI2vjSoiHTtXJEabQmufFIv/qLQdM/kJX1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724029331; c=relaxed/simple;
	bh=2kzd7G/Pe4tgcXPkQ62/SfYOrC0tBK4PckC6GHZzlpQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rnYbMUCL7COrlTDw6QOYK9C0oxczewNUcLDlTwKhG1nISc5MQjOlu60wFg99UU7Hm+W85AjBLGLRakoRlfbeNv1OFOz9WUFOK/Lep32b0VpSqM9G/02uVIP6RF6Aop8DtoZOEwaYoYQOnI5iu4e2kgZ/JJNnbVwjKLi46pfwicE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SKi3hA9G; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-2d3c05ec278so2537611a91.0
        for <kvm@vger.kernel.org>; Sun, 18 Aug 2024 18:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724029329; x=1724634129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/E8CEOT1/HPFlUo2VocSkNU3W/VJweNzQb1pGEp2ypE=;
        b=SKi3hA9GXNajkfoz+j8VzRLZqcp9rkB70/CvYX7y4wFUxpCKOjc/AUWp7qP/iXkDS8
         DDnK5NBIfTgQbhwxOS72vDYC2IeiTuqWfTpSyiuXhZwntEUCxTuP+pUWHUUi31vL0LNE
         8upXRIK0YON/dBZsEXt2iVdLKfs7LA0cPRZVnMa4cTDuuSVZFIC4e5RGtRKs8s3OY1tp
         3P3I++HWJLEkj5uAGRc8OuCQApJFpMF+wo1s5VzFrx+5OeEuCzsU3MiCHP44bDUiG19t
         LVtFcbn6GkEr3w9i8en4FzVjTddJF6ckMWtMKx+mRqJ34deFdpQdlXQtMDqTubH/+x9A
         HdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724029329; x=1724634129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/E8CEOT1/HPFlUo2VocSkNU3W/VJweNzQb1pGEp2ypE=;
        b=RdsT7aisaPZUBgyGkkqo5RsdhsMc8Ipu7/UAYC8t+aohjuGbMaSg5w3EO7zkHE59kN
         5TK6dTutoja/671ltuK5oFw6LIQWvs5wMUjMB81BPc93FOBMolyAuWHE5GHXCOKMf49m
         UTrtnzR5K2+vubtIC4Xpkru0BPZN/xVpT21i1zbbQIyAfDVxMKhNNM2aetjiBwFPlKxa
         q6NAwcccOkc/3vtESwlVv1EiVTVNOUabt8IVnk719FAwYykwCqh+ArA8nuiBxQ9J1N1G
         nsYUTDcviBxJEfuLCcBv7c0Ir78USdOkK7n6OAGETBrx4N5vbCK99V2t29Fm75EsfRAh
         PcNA==
X-Gm-Message-State: AOJu0YwvKRFrp0XV9fw0BlPrASVwZO+XP3W19b1G8gGmb3VdvxFCkvRg
	99zDqcceHOs79zLInHrBoDBRCeJentL1aJ2kPKu9y5noN7cXubeTOVtuWKYBdFo=
X-Google-Smtp-Source: AGHT+IHxS0GbvV7xNnO4bQgzcxFvajkhLAO6ZeoXSGD83R55yiFchewdRw3VST/JdWphv4SeNie2ng==
X-Received: by 2002:a17:90b:1091:b0:2cf:cc13:471a with SMTP id 98e67ed59e1d1-2d3e04128ebmr7483026a91.43.1724029328839;
        Sun, 18 Aug 2024 18:02:08 -0700 (PDT)
Received: from localhost.localdomain ([45.63.58.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3ac7f2276sm9834708a91.29.2024.08.18.18.02.07
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 18:02:08 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool 1/4] x86: Set the correct srcbusirq of pci irq mptable
Date: Mon, 19 Aug 2024 09:01:54 +0800
Message-ID: <20240819010154.13808-1-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The srcbusirq should be pci device number where the
interrupt originates.   Fix it.

Fixes: f83cd16 ("kvm tools: irq: replace the x86 irq rbtree with the PCI device tree")
Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 x86/mptable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/mptable.c b/x86/mptable.c
index f13cf0f..f4753bd 100644
--- a/x86/mptable.c
+++ b/x86/mptable.c
@@ -180,7 +180,7 @@ int mptable__init(struct kvm *kvm)
 		unsigned char srcbusirq;
 		struct pci_device_header *pci_hdr = dev_hdr->data;
 
-		srcbusirq = (pci_hdr->subsys_id << 2) | (pci_hdr->irq_pin - 1);
+		srcbusirq = (dev_hdr->dev_num << 2) | (pci_hdr->irq_pin - 1);
 		mpc_intsrc = last_addr;
 		mptable_add_irq_src(mpc_intsrc, pcibusid, srcbusirq, ioapicid, pci_hdr->irq_line);
 
-- 
2.44.0


