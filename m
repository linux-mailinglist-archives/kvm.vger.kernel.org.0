Return-Path: <kvm+bounces-66830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FFECE9560
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:17:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2A2F2302573A
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8438C2E62CE;
	Tue, 30 Dec 2025 10:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hzo/ukVG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZviZVR0u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A59259CAF
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089763; cv=none; b=RBuXTExMlatzaDlnXer8TQia6l+auR+6BVrQhVmVWGb/FkoewF9ug+Vh/POHoJhwK2nhAuvRrZI3Sjme/gSej8FgDzC5FzVVLa5ab5Hdwak0WI01TISeybhL9db5qcGKyMPWzE55GHbPi6a01WH567ZS8pqb3Mu1fRDRbmzx+po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089763; c=relaxed/simple;
	bh=PKPLA1kpbL7fJYEUVDcqch/rjberNxsCb/G2InoSmIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU4I08hCu4JE5C7K2khDXVKTZ+CATmAOfvcwWiIkuwom0bqrVCrhi2LTmAUQLjC2BKCtcwWJ/Ggp3AfhyUyhtd/P0gkF36Ua62N2XtTMfFznPtD49gjFuOoWqcmVZ5EgmFMMgN1Ph2uhWPfNOJrofBHa0IJXgjzdILOoOitsHYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hzo/ukVG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZviZVR0u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vlUDEgWO93Cmk0Xa8O4C3C5KUT8jOBeRcuReRJ9yK0k=;
	b=Hzo/ukVGpCpZFTerO6TPVTUe75x9pQ1BR1LptdEzWoyEQ/osq2e8qbvA7igncJP60Lnn8M
	cAmlIoq9purJRZszQ7iImNMTkvCoPlaZd4humItpsA8OY7yk+kDS7DCURt5KOhFT3wU3pq
	/MrPGTP9IJ8w/QKJNIwqFSmI5wmFvcc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-MiHXSH_JPPyaRpC4uGhf2g-1; Tue, 30 Dec 2025 05:15:58 -0500
X-MC-Unique: MiHXSH_JPPyaRpC4uGhf2g-1
X-Mimecast-MFC-AGG-ID: MiHXSH_JPPyaRpC4uGhf2g_1767089757
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4775d8428e8so82528085e9.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089757; x=1767694557; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vlUDEgWO93Cmk0Xa8O4C3C5KUT8jOBeRcuReRJ9yK0k=;
        b=ZviZVR0uqwFPJZivYXOhQ8AGvYAcXNGBSibAk7l/oSytGm4r+M2JydcqprJdVhVB+i
         ZIT2OgPtUxe4Ig/8PWscY5IluLSBlXeJMmo+M56+KQ6c49gz2d2R7M70UIA+wjl3sUEv
         9DMWprpyUREi6QHA3BAWnf8/4i8ze2sC62tcCLFtwzaJTOjTblCtfgXkdREJ9nHMD/06
         Ztkp862/yqlkCUXHjZQ3n0HMHaYrj9VVf1a8iVtpAbXtdj4Iiyfu5/PERkeOruvDUwWd
         FjsncdDmsrzS2crWBCEZC6A1v6x2xG2aNO2eHqDBYyRno+5IpaPdaciAPF6ItsqB1e6t
         PySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089757; x=1767694557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlUDEgWO93Cmk0Xa8O4C3C5KUT8jOBeRcuReRJ9yK0k=;
        b=Ux+vMK0vWX/NVpZwqv+/VJXitcN4CBjXcIg7aaPjCA8SE/fGGQx3TFSRGk08tlHUas
         hlewOOsY1s/vytkhsk5qBXG0ILT6VSUenimieLoBFJAp+HxoaV3u10BZ2Yal/+EMXQ5f
         G/8B0YvUT8P28nPRVwVPJQ7lUOfbyHoD27DWeO4ctIwAfmLUGuJzYgRhpfZ/9+bExxyT
         gs9QeBypZ7Ml23VSmAKcj6Bets45p5n2K5WQ8DAmwiFRoeMiLbBvOnNd/ZKVgt8xAwJI
         cT6SOa0BI0LcpzQBpjCvzNQxAx5BAPniz/kWfxycKtbpfnNzExNj4unUmyRTfMlyH2TL
         UzwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCCmvVrsiAOARbIMZnfcI+hH0oF7Tmi/3SZflpfvnFU89MbjkIjqUMurU3ZBkSPkbe4Jc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd+VaX2dwTKGZFGKXJSiuF9xt/b3GIznWrsuxARsUZG3X9FRKI
	K6Ji1lEQkavPza2yRhBC7+hFQcmlyyvtUSBmXxeJXA0Es9IQjZsQMhDtIO8PzuZ3Mvzt0w9Mw3i
	uHejhc/4Pvtw8P8Vnzo1AHeUoHObzpoX2Xzhnmc6FSk4hfA1Mk8uNzA==
X-Gm-Gg: AY/fxX4ZiQtC9JLAveis7nSdgFSmNtEn1IXHu/L7UfDoja+mPMkCDDBfCVqa4xXOMtH
	4IL1DvKHN74mroU66NfvE3F9ouLdIR8sZtyLUnqiOh8xa7/e1z6HUWFR/U65VTfvhtvNy7ytEcD
	GfUeaLAR840R6q/0fSjxXvoRE3mi1OEfGuP7p1V8ojnFOWfnvXLGF2AR655l8avwSfGSUkBf324
	JjLZyqWm08amXwb7HNkGaEf7C0N4hp39tPpogMQEN8RTdJ10cmGLusTVT4zfBMBstKf1a7rIAGU
	Tifi/t9N+12Pqp9p9jdvGvDyhlN1KsOmKbaIDcX3hIGICwCortxWr/XrnwQiIX/otqaAbd3uCT+
	8YYocYB4Gzfdncv4RgLGCzWe+cwA4HOIQIQ==
X-Received: by 2002:a05:600c:3b0e:b0:477:b0b9:3129 with SMTP id 5b1f17b1804b1-47d1955b7d1mr374948105e9.3.1767089757021;
        Tue, 30 Dec 2025 02:15:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFcsewURuffZ55cO3Q+sj2TN55Hu1ppUSdeqHbu2iFeBFoCSmT0tG7gytPk3ITCZSUZTYC9tQ==
X-Received: by 2002:a05:600c:3b0e:b0:477:b0b9:3129 with SMTP id 5b1f17b1804b1-47d1955b7d1mr374947795e9.3.1767089756491;
        Tue, 30 Dec 2025 02:15:56 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3a6c6ebsm263705445e9.4.2025.12.30.02.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:15:56 -0800 (PST)
Date: Tue, 30 Dec 2025 05:15:53 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 03/13] dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <1f271a22a3aae6afb97c5f9ae35b1802eaa036a7.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

When multiple small DMA_FROM_DEVICE or DMA_BIDIRECTIONAL buffers share a
cacheline, and DMA_API_DEBUG is enabled, we get this warning:
	cacheline tracking EEXIST, overlapping mappings aren't
supported.

This is because when one of the mappings is removed, while another
one is active, CPU might write into the buffer.

Add an attribute for the driver to promise not to do this,
making the overlapping safe, and suppressing the warning.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/dma-mapping.h | 7 +++++++
 kernel/dma/debug.c          | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 47b7de3786a1..8216a86cd0c2 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -78,6 +78,13 @@
  */
 #define DMA_ATTR_MMIO		(1UL << 10)
 
+/*
+ * DMA_ATTR_CPU_CACHE_CLEAN: Indicates the CPU will not dirty any cacheline
+ * overlapping this buffer while it is mapped for DMA. All mappings sharing
+ * a cacheline must have this attribute for this to be considered safe.
+ */
+#define DMA_ATTR_CPU_CACHE_CLEAN	(1UL << 11)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 138ede653de4..7e66d863d573 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -595,7 +595,8 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 	if (rc == -ENOMEM) {
 		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
-	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+	} else if (rc == -EEXIST &&
+		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
 		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
-- 
MST


