Return-Path: <kvm+bounces-66187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0ADCC93B8
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 19:13:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ECCDB30412C7
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 18:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC4333A6EC;
	Wed, 17 Dec 2025 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iu7vhMYN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B242765F5
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995154; cv=none; b=ga4V4VfusGPUxdqXj65q7mhAe9nGp1IKC+nJQaHRz0hTpmZa856mm44IRNvMh7s+/1BASepGTTePaXlUhotEx4V1ZjbIzFTV/zqa9kmw/BNKtLka/gZQ1bCC3iWTYU6iDXqro4Z0holmsjpVDsn1mhZPTvDgky7MfIj+jctOjvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995154; c=relaxed/simple;
	bh=+7N+VHpTGzHKRYSzDk2OOTGyoErfwnToIvY7+I5OyWA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l2INmTykG+KcwfuzIh4nQbPNDoVkapmWb3Ka3Q+N9g7JtvJQmM+Zt/dT/4ntmS4y1+vAMyi4WiylS9dlDlUEQ1+xqC/g6k31o6KV/Rl5FONaahUCvUKiUBodgwlrGAMAzSrG44hG6X3mgKVentRmevM7uuNDVFIWLvQ6v1eN6k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iu7vhMYN; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5957c929a5eso8767003e87.1
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 10:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765995149; x=1766599949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFgy+A0O8xnRgJd7v+RUa9QU+8qq09tdOiliLPIqEb4=;
        b=Iu7vhMYNgxbF12w4HqrH0YR9nOf1UVbPkz8Nkuo+p1MRcl1gf3rUHEnA5TvhReMU7T
         N42IMGKa1/vB0ngF3/TXDsAzMDRGvN6PS925tFybHU3LqllK4S3R9yf1nVvu11McOx8o
         v2LcjzDbZEzYQTxitGVftesUc0L11eHmexMKiQbsR5yPWwLilDyEQfhAMA4h9U6LutB4
         P4PRIHmT+tGX2LAZEnouynClP+dHCHe+Q/MMKeqjzDjBZGZJPhh8qElPF7ID71D+Yrm7
         Jq8SdtBNh1FbXnrW2y3wFm8vUE9jHbPt9td/fUytFuPUnJ193vgoB3q+xN/cgtVuJz87
         YJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765995149; x=1766599949;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFgy+A0O8xnRgJd7v+RUa9QU+8qq09tdOiliLPIqEb4=;
        b=GDeANEH9IpUQhy4qByP607I3+M2IGNhot5VKlRxqJqUIZtZ54ygbVsrLEFchajMilD
         B39xsycCflKYBZa9tIKX3j1ASXefWHQzQ3S2QLPie76lJvTgAR4sSGxY1B7NfZhGKU4c
         NRSRQvIA/lD8Db9181ZqqMr55ftDjmAnlneFLWRe/lcV+iG3+RpZQr7z72GF3RH/gd3u
         P8BDDLl/9K6zmcbFC4aq0mrX5F6cp1PontSJvcOG7ypoS6m+cIrtjc6yVV4n0Xh+JtqQ
         uh9bUFQ0atVHfk+f0mm+/eEGMnSrVEIQ8usQfiKX7fC0nfj3XALUa4eXFyosNtRC9ORY
         ZtCg==
X-Gm-Message-State: AOJu0YyCA+BeaY1G+TzxsdjH+LK/VDtoJsHCR4FuSuchPmSoRepS2E51
	paAXEqfl6Qol2uyIg/GhaxZ3wZmuNf2p9PLdthwhJagOnXtXuIKYr8SR
X-Gm-Gg: AY/fxX7W9Oao3mJsG7uOOvv5ULFnDALEMzhTkAjJf7LxjtyBMNJ8Tbe0xncZ43A+LQV
	ZOg0Rwz9RjsnwnPAhSU87a+1Yqw+n1YLGmrXrjX9U52zHgvyzlvdmn69o+DO4V4cm4hRs6tdNHZ
	TodieJVV69uH2+BevOOry69DOQxJY26ROnTJGwouaj/rW+Y4tbDttyYy/t9hMCTQlT+rQ0NguWB
	rtK2SFTzO9RC/Imrq8SZ0YZtaK0R623A3d5U07sHr23OMXEFK7abnaCIupkf6vZvVJrfccqO/JT
	VfwCORhEBqy6N3DhXV7NBozjP6e/HyrugGIO8I41+zsMWC8BsRbyzUuV4BJg9obWCmuBGzLruNW
	ILP++KGu7umsjjO9bdm33smX6A1qu6lNYVD9zcagaHaPyumPP9djjYXVbi+N3+FrvNak2YwEM8J
	w21cMSRnV1FOs=
X-Google-Smtp-Source: AGHT+IFfAzzjL2doo80fXCqAexQGKSYqtRni1yb9UdVue4KNR9zAwS0Jwg1qOwIOBuF7UQ4BiHcjjQ==
X-Received: by 2002:a19:f60b:0:b0:598:ffd9:9da with SMTP id 2adb3069b0e04-598ffd90b06mr3767074e87.7.1765995148960;
        Wed, 17 Dec 2025 10:12:28 -0800 (PST)
Received: from Ubuntu-2204-jammy-amd64-base.. ([2a01:4f9:6a:4e9f::2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5990da790efsm2591419e87.102.2025.12.17.10.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 10:12:28 -0800 (PST)
From: Melbin K Mathew <mlbnkm1@gmail.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH net v4 0/4] vsock/virtio: fix TX credit handling
Date: Wed, 17 Dec 2025 19:12:02 +0100
Message-Id: <20251217181206.3681159-1-mlbnkm1@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes TX credit handling in virtio-vsock:

Patch 1: Fix potential underflow in get_credit() using s64 arithmetic
Patch 2: Cap TX credit to local buffer size (security hardening)
Patch 3: Fix vsock_test seqpacket bounds test
Patch 4: Add stream TX credit bounds regression test

The core issue is that a malicious guest can advertise a huge buffer
size via SO_VM_SOCKETS_BUFFER_SIZE, causing the host to allocate
excessive sk_buff memory when sending data to that guest.

On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
32 guest vsock connections advertising 2 GiB each and reading slowly
drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB; the system only
recovered after killing the QEMU process.

With this series applied, the same PoC shows only ~35 MiB increase in
Slab/SUnreclaim, no host OOM, and the guest remains responsive.
-- 
2.34.1

