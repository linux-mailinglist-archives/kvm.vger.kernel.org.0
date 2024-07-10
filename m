Return-Path: <kvm+bounces-21355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CDD92DAED
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C2851F21CFB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2DEE161936;
	Wed, 10 Jul 2024 21:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjOqV43h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026FE15ADA0;
	Wed, 10 Jul 2024 21:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646766; cv=none; b=UjDfHbyKqnYnpFAWgtCRqIfzqyOqIavyyxkIxo8iKMlDZclZwUxxugQNMvYgojtEP9XYQRQ86xpHB1zGG/HbJL374erIQ1XJ93/djN+x+wz3DIQ6i2Qiw6oQNKDgrn7PMqXC3zMHj1Liw/GeoeIzLB+deKPBlr8oWH6VCLYwH38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646766; c=relaxed/simple;
	bh=gwtanEC2pGzN60xOeGZgf6/7sgGtmktz1APYPkOQvwU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OoGJGVEKGyMHCmplKBqrGwx9/4xmQABxUR+NOhrqYRp0T72R0wU6nl+dKAj7jVMO1yNbcqiCj3oQxfRzzLBFi5pywpwL0K4x9GQdAMygkuMU9PM0JX2jRECDdXxWYU4+MluAHiwmhhGZU1x8x1J8XJaxq9qQ2NHID78zNxWraTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjOqV43h; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-79f16cad2a7so15057385a.0;
        Wed, 10 Jul 2024 14:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646764; x=1721251564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmWB6RITNr1rCqVWevMLNgD0qATYDnpZgKWdiv490xA=;
        b=LjOqV43hq3Bm7C0EIUGsX+/h6yM9baE89GWr1ZQ3kJMPRuVEHnvWQyTZADKwJ/Nc84
         zr6AE8HGwCuAc0Fzbq5ViVTwqDX18rbMCOLmrYZMv304faKnIcEWwFvzALpyVdb4ljV3
         cj3sB4/CBI3iLsAxFv/pVkUf6PObevinnqebX+1skVw0vlSCL/EiWjAqF1z5kTt4LzVn
         8DxJj6kj9iPo3LywyxzLmtI8kF3/hpL2midlM9XCfD/Z/zwBLPzOwxx3USlcbPKGVNwV
         oG+ZFxgZjNlNa1muqUBBSFcZMlevZ6C9ljladXFbzlIVRPpYofWFgQIVRVNgErcjIn/H
         6x1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646764; x=1721251564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RmWB6RITNr1rCqVWevMLNgD0qATYDnpZgKWdiv490xA=;
        b=d1Fnvr/ZIww4DHJryiYm/Rd4E/yTebcJbqbooP44LnwwXb0anwBpDgA5gBykap4TkV
         u9qFf4tj1UngOphk19ojr9xiNoybH+OTRc3Xwb12KYYFE9oq/hpDS7cyrNAi8YeCCbZR
         NdVB118SHw1tW9PRWeOIQsaK6knTY+FyIC32oMrcP5GQrluo3fK8w6zdscRhPiFpHk+8
         yXZe/majFk2XKX2RLbojNTuMH5HAAN+ysjh31cjtjS1ejmrCEka26v7gWWpS1gsYg3To
         ljG6efoezqUq4iG3XoxX6z4teFBgjN+6nH29T76LoIsp7I/ym4/wNqLC5V38WMRS0VL8
         aNtg==
X-Forwarded-Encrypted: i=1; AJvYcCUIfkzulaFYGtn2qSsjyQlwBznzMOSy1n6G8ZK5Rh+T3jmpy8OQ9IIovBpIIOg1CegZOlLYRCgqAYQOcz6sRHweVreHUab9OfssDW5/2Ymr5lrGVuOjTOnNGZ7Y1nV9Nz914lpJjv4gt16ZuapadALc+eEKa1hDl0sNOurvpHw6AK+2f7o4fw3yT2iprqNS3W1ew01gBlnrCm3z3IMmxoG2Iu/B+q3C2fLPT1vH
X-Gm-Message-State: AOJu0YxQ4UWlV5dprlD5o9WQGEuh3orA/jZxtfpn+l9WvWkgPPGLLN1h
	3cr0T3IEOZaIqeEdN/E2ta6rJqUUKLNqAtZQzDfydipjgw8QyHHT
X-Google-Smtp-Source: AGHT+IG777NGw+WgU0m269DXuwpGYmePB845UKK+Uaz17xBp/iDpuOJlJWqnyMj0N84ol+h/zJHD9g==
X-Received: by 2002:a05:620a:51d4:b0:79e:ffce:47df with SMTP id af79cd13be357-79f19c023e0mr644384385a.78.1720646763945;
        Wed, 10 Jul 2024 14:26:03 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:03 -0700 (PDT)
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
Subject: [RFC PATCH net-next v6 10/14] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
Date: Wed, 10 Jul 2024 21:25:51 +0000
Message-Id: <20240710212555.1617795-11-amery.hung@bytedance.com>
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

This commit adds a feature bit for virtio vsock to support datagrams.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 include/uapi/linux/virtio_vsock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 331be28b1d30..27b4b2b8bf13 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -40,6 +40,7 @@
 
 /* The feature bitmap for virtio vsock */
 #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
+#define VIRTIO_VSOCK_F_DGRAM		3	/* SOCK_DGRAM supported */
 
 struct virtio_vsock_config {
 	__le64 guest_cid;
-- 
2.20.1


