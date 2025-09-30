Return-Path: <kvm+bounces-59113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC14BAC004
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08ACF3C624F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA642F3C3A;
	Tue, 30 Sep 2025 08:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n9GHEKVu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0892EC0A5
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220547; cv=none; b=YNKu7qXP/v74KB+tSTlXFMtRAVakMm8UWP1dwLe9NxEZ1buAa9NWb0lYNwSC0Ti1n1q3vI+8N+yX6AhEM+Yv0j78WnPaZgg7XnQ9RMPwPHizCXsKdHxd4YEqO+K4TJ42+4KCetP2S/Aq3wleJaMvRBcHu/RinszdNJVw0Arv8Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220547; c=relaxed/simple;
	bh=Kd3qG8yteLnzqTqa5lNxN+xIix6uNUkVKZrS5PpxcpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5NYdezEOrmW8m3+EuQSvEqf98xZ2OE7RVWNdZk0LSEKgBYRcbBulWMfjuWyfjhZcvfbgX9JdwP5fGNY1MPy3OjWPVfEzthbOK5AiBAvFCjoXVLX8shmQZoormHHlIpnXz8O4fqq7VUBRGUmF+ZoEYmOBX4NgAs7LSDti83dErs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n9GHEKVu; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e2562e8cbso43193785e9.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220544; x=1759825344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbEYNZgIU6LqvkF49qge8kIj2C3i6K2S813tsyxbWwg=;
        b=n9GHEKVuG+2821QW44LYjqWkXbqo5Na3z0PJptkUyEE9M+foWEKOePE6Ww/rk8Uy7S
         Jv/wr0NO2s5iCSHA1qOKjIwbbHShh8vhoJ3brRcQ+nwaw0dI1HQcvX45xp8yo8RQo6y+
         FbjxnF9Q7D4R2tgziAME6/b3g7B6uXS2SX73ILScQpG7IVykvYJuRSGqOJnKoMLMujws
         PppHwnYyG31PZi1ppAbN+kI8wedmsQ3Rh69JbuSUdVfj6Duq1XoKvmlvgYTrtnLcvgKS
         YrUCBJYRAAGE72L8y3ri9TqP2BsiqvDCUl7LRVE6KzLwqHetsPShXJqRd8YVLpk82Phn
         ZRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220544; x=1759825344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbEYNZgIU6LqvkF49qge8kIj2C3i6K2S813tsyxbWwg=;
        b=xB7wUX/a4UZXrcav4axz8bQGYF/8lUJev0ClWUslCBdsK7rM/JM6e63lk24D39RtYQ
         2K03Ac7zN6oEyB/19DIq+ZwXoqF/tkojJNIYz6wuEJYBZyJx7cCj+hLyVjGfhEMyU4R7
         3uWZ010p0QHRV2UzB1iD+0KbdJfX5O7fEpPv6yErI7b+56Q1SWxxt/D2XYHmfMJiiobp
         FfN9E4XuPTHLsRp9OERS3iw7bpNnwVYNPi3vi1LBKOhgkfeVhgZRpo/hKxV4pJkGisC2
         J24yLaEYolRCkFjp3x+Vg8cCoXfxHtuL/qMPFewVoyeY9xaQxejg5ULoys8nSKqJLVly
         aRww==
X-Forwarded-Encrypted: i=1; AJvYcCVmKh8Ibagjuv9M1Wa9e5STDsEwYxOoBzFmUU0EidBBMQmnY3lMmdo7+9apXyHIyiUu6TE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQpu84Tc1W21sS3MwAgjmyhDr/upl5sCeHLfD7jcxyKPXZI+af
	jC6ORvmyc5owxuIKtYq6v67Ic++PacE4LmgvtaYXb9nJbEbCRCYkqFjRjORaVKo1RYc=
X-Gm-Gg: ASbGncvijXrkRCUM/sofvfHvKsTzfpvMVW8d06Hknj6J0amrWWxRXgP873er5aJa/8F
	lbYSqOowRVs2oalT3W1HvzJZdNBBCjhhoU06EmLWS9A0Xqq1dk7uY1Iede9c5bafriNW+5HliUh
	7SNcGLEzO05NlvxEag5ZD6l0c5Q8OdNFeeg7pSj0vSGL2Js9ph1IyGkPUoMYr6XMhdAVdB0Jn8R
	SCrP4J1kDtIj5wTymQFk2l4xrdvCGVcVAbCdHm2iqopcGYopZNoY/VStMyZ5H1BNw/A9vbeV7bD
	y7IlNCkl1qiLaoSzWQldEa0H87Lz0EFEgPs/+pO/8bzoAlGz+/hB48vsKrbND+pRPG53ICAI+4D
	veOyu8e+LEKMUyhud/Bpq0hEesARABHJH5oR16DMykAWmSNe6AjdhJjrGrTuGZjsQAt1CWqkyIB
	xuBCMPzSWZDkUmDG1kOr/xWzS5anxW+XI=
X-Google-Smtp-Source: AGHT+IHMDbDhZ1qtfUqSvwy3OGcigy6OI6LXsB/syBvCuQ6w6sDdxi+R3qorHEXGNas+XOrL9i5DRg==
X-Received: by 2002:a05:600c:4fca:b0:46e:4ac4:b7b8 with SMTP id 5b1f17b1804b1-46e4ac4ba51mr119307915e9.25.1759220543603;
        Tue, 30 Sep 2025 01:22:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31e97sm259738545e9.14.2025.09.30.01.22.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:23 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 10/18] target/i386/whpx: Replace legacy cpu_physical_memory_rw() call
Date: Tue, 30 Sep 2025 10:21:17 +0200
Message-ID: <20250930082126.28618-11-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930082126.28618-1-philmd@linaro.org>
References: <20250930082126.28618-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Get the vCPU address space and convert the legacy
cpu_physical_memory_rw() by address_space_rw().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/whpx/whpx-all.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 2a85168ed51..82ba177c4a5 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -788,8 +788,11 @@ static HRESULT CALLBACK whpx_emu_mmio_callback(
     void *ctx,
     WHV_EMULATOR_MEMORY_ACCESS_INFO *ma)
 {
-    cpu_physical_memory_rw(ma->GpaAddress, ma->Data, ma->AccessSize,
-                           ma->Direction);
+    CPUState *cpu = (CPUState *)ctx;
+    AddressSpace *as = cpu_addressspace(cs, MEMTXATTRS_UNSPECIFIED);
+
+    address_space_rw(as, ma->GpaAddress, MEMTXATTRS_UNSPECIFIED,
+                     ma->Data, ma->AccessSize, ma->Direction);
     return S_OK;
 }
 
-- 
2.51.0


