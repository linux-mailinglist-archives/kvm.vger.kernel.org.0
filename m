Return-Path: <kvm+bounces-21351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D97EF92DAD1
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16A061C21496
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FCC15A858;
	Wed, 10 Jul 2024 21:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hREZIi62"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17F814B943;
	Wed, 10 Jul 2024 21:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646763; cv=none; b=N2IEf7ZwvAOOcYr4Q1h61hxdVsKB0eXcLnnqbFRFWPz1F+U237WmYtS/m/1KbYtitoxCHuljvXRBA7ClpeqaR3wrPDb2kdA1qXFR/RNEwBoDCKCitdck+3+BvYeUoXKHc+R5wbBBtq+W33nLfVM5U9pmcq+ZdTww3fDNaw+Nx2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646763; c=relaxed/simple;
	bh=UfwlPBtk149XzS/tcMuqUXOpP079VnWFi28qU26z4ck=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jcdLL/TOaz7o6XYgK5lHEh4oF8YlApVmC/PTjacrgkTWs9AGvSoOfLU4oaf9VDHvE0T4q61j81SvJO3+5NAgThEhbqDQmXAhc2zcDRoDQWSZI5lBnC9z+ab6nsIChjEvNdGxJpvjFk/6vP+FPTmfmKnm0/oKXO/yJnZutMpNoqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hREZIi62; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7a05b7c8e38so15094085a.0;
        Wed, 10 Jul 2024 14:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646761; x=1721251561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJWi8Leq2jo3M3Yc8XcwnzkcrKsxdOFNGRCXzkErj3E=;
        b=hREZIi62+exxFbPdFihwK7zhI1JD35yBcnGfImJNcyYmsDZCZxWBu00lxjr4WTkEbM
         X//gdNVT4JBmwrww60uspbZkVYl1fXkbbWsSzt1c3aYj1D2OBobFxu7suadKXXq1WlY0
         AjXBKLq7LjSnxeDfZrDoTjvhOEOBglUQAh6aagoxaYDec2YRFULy+K/7qLaA6VtqNxn3
         VMpBKaMyWtdcRkAsF3VMXcglgkgQygS2GNjJAoPa+pg+PWXZjWSPgpogVFvawq+39Y3r
         vMyz6xXzGOEn1PvnmpZCsOnZZe+i1onYiBegZtuLEcBB9cs0vb6ZCjXd09rP186sZp23
         mBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646761; x=1721251561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJWi8Leq2jo3M3Yc8XcwnzkcrKsxdOFNGRCXzkErj3E=;
        b=sTMG2yFjSp1NnrTwriIGk2LWCPWY2EPnEczBZCYnevFVYcssV55OluAn9raMrhrBrX
         Ds8A2eHw8WbAwgg40cyNmUyUmY+eGdR4uIaUeYs+65zHmouTUgFrPtqS0uJd00H2Ouyr
         TQLn2JtrU3pd+PK7c1ytGu/c827pxHe1trdiaV1OzBgeTtJbAD3L+7FENi3vSW5GAuLY
         4gAkaICj3ZCzxJEMSXwbDX+uU7rU46ClaXZFVbqKW3DX9qTJaVNcQYuw1jW5cboROQjI
         MuyVenW/EOkTAkQsszawsQK5743j1cOt5KdxA9Wtu9YpqnOysm855KikJD123RXyxIby
         rnNg==
X-Forwarded-Encrypted: i=1; AJvYcCUk2XCuOWQUhEQ9TXuVAd/KyXRpuTiESGMq1f/GADsgO4xM853gtCx8bcxO8MxT4LwK2s1VsO8ow0K0llKDE2egLvLGVi+NGuZfpg1NgZVHoJxXDNg8fHFUr6Odw5LUHGGpLkSExzTSpAJbEZ2rHb2P7g15dACC3V4j+yHsLdakrZtaFEj5/T8GfyuH2Eo/eyoB4NFisVY51I8pL/ydxcFPwf7f5MuUp2S7QzMs
X-Gm-Message-State: AOJu0Ywg5jRlGeU49WOPw66yDbnHbVfbSVYI65BgLFzmAtRAWzwqgy9K
	TAcPI5TzmWifM0/rmNX1hzNUyn+4tg/Vtzkh6LIzR8gdSuXld1cG
X-Google-Smtp-Source: AGHT+IEeRGnHtiCEw+KM2q98xiDSRuWiiJOOgf2jpC5OHvHQB6LFE7ca10rhiE0Y5d3kMoOxfyhvtw==
X-Received: by 2002:a05:620a:2186:b0:79c:119e:2b44 with SMTP id af79cd13be357-79f19a51d7fmr733112885a.3.1720646760834;
        Wed, 10 Jul 2024 14:26:00 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:00 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 06/14] virtio/vsock: add VIRTIO_VSOCK_TYPE_DGRAM
Date: Wed, 10 Jul 2024 21:25:47 +0000
Message-Id: <20240710212555.1617795-7-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

This commit adds the datagram packet type for inclusion in virtio vsock
packet headers. It is included here as a standalone commit because
multiple future but distinct commits depend on it.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 include/uapi/linux/virtio_vsock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 64738838bee5..331be28b1d30 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -69,6 +69,7 @@ struct virtio_vsock_hdr {
 enum virtio_vsock_type {
 	VIRTIO_VSOCK_TYPE_STREAM = 1,
 	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
+	VIRTIO_VSOCK_TYPE_DGRAM = 3,
 };
 
 enum virtio_vsock_op {
-- 
2.20.1


