Return-Path: <kvm+bounces-59058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0780EBAB49C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:13:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 590037A42A9
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E3C24BD1A;
	Tue, 30 Sep 2025 04:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q9mRj9rQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A129138DE1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205618; cv=none; b=DKuO2LZgi4G+erSfafJmyKM0L8D8VkEKafVavyQi57t3JLiplUyhtVvSgdUFmmpyOQT0oX4nn5b1Ds+44f+xlGGzeTb+br0lgyNEmLQSNtRVYZt/TRi3/ucuFRXeMnTE6CvaEoKuUvQAcbLlFUw8D9Hrbowvher4YW5lzG99hp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205618; c=relaxed/simple;
	bh=m2XlauSQwy6iP5O9cTVakYNdS+D0tVNg0YUz0E937M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=or6KotDI3ou6ecAhAr6Hxq2zcVRQK2U90Di4e3QQ12NN/j+040pQaFLd+jn9sFvK8Sc53afT7vSuZSYpueXM3TLwIPdjsFWoxhNfdWAtajT2QEXUvIklxvcWNIm4vfjdKaZhMCDnqYDzo/bW3vMwQZy1a/KkoNUYxw19G6REyNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q9mRj9rQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso35636955e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205615; x=1759810415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6r7ywVdtgg6puBO7GNeh9QBn+ePwbPPQeAATrRMKjs=;
        b=Q9mRj9rQjWGj2YphMU+3hTb82cGgjQ1tPjvjazoOit6M25l8xkcb1ALT0V0ul8q+yk
         yCN94877Q3nIjSnf9gYYBEwcJ/2Ybz+Jr2QjfRelGqdC+7SRTUOp7sSPkr8/ItT+R8yV
         t5lGJ1BLGsGsaIrO1ocZDIdD1cRDrjeyDaNbI7kUes9VTzoQmJITfet5SIwwgC9hoaCb
         SK70gma8EBnftwZrYQbHrzePnRH+e1h9KLdWL6dOXu3aE1TB2e+mJabNU6nYCPQmtXD2
         CR338p5t7p/AAMxKKdF9qe+Bi2TQV9s1jYFvWKb58sdc+5wLvRbDOl1RGg3w6xHun8kp
         cTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205615; x=1759810415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6r7ywVdtgg6puBO7GNeh9QBn+ePwbPPQeAATrRMKjs=;
        b=qjDrf5ZP+GRTkLuS3OrQBUaqlTJl369vrdmDn0vgAnTCGcvsU3lG4hhExng2ZG1Grp
         7C3ZOoxTpFjeIZC5IRAzqaEYziubtfhapSc/vTDMwWCZX2tvSiouiym8MkBUsq90JoQv
         HlhkMHMSePsqa1WAAK1vNJGJM0f8PPYQMK+x7dxPxX0mcBDIyAoUQevnqN4nza2tQikG
         PxlCsAvw5bx7z/GWxXn7T34h8tjUT8THF7RF9l96GL/CjaCFkzaqyfqoApA/NThCnYRC
         476+ghh+wgJA4LSNznHsJOKenLLlu6X5iiYFaR4jgHsYD1OZWFVERZA7nNuxpdegJj5n
         ec4g==
X-Forwarded-Encrypted: i=1; AJvYcCXBdFUMO9aRoxA5kyjzanHv+zTckhIb0rt1xrWDM+LTjJC+J8KCrIUaKJw3jBz4IFn5FW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7mvTsW4tTYV2WieZiDMiPwLOIS1LubuYzZNmcm7pRcLFnnDLT
	IXsWN3w/kxnGwuTpCT6jeBZ5pu75YuQYFY6DAkONHPNOYKdg3exNfAlLyHccxUtHE4M=
X-Gm-Gg: ASbGncvp05xzvsqiUzUQmVvUVo9Q7j9R42jYPc0yw7P4xet81oAouFlb9p5UlZ1GveW
	mPuaNNqJ1gGS6Ayzzaq/HZJ+lX3wv2ozfZN7zzeTDYju3nncUQ0bGLuVXbONaz7HvxcB4/G9kOv
	UJGQDHCKhRE3AgiCy50Nr9u6QOJzS7ispoTZ+4B61MR7u0FXwwGHoVTZ/k9kqsYpKljvklMWng/
	ZarZNpmX9cVtZ45hDOBqw5F+F8NT25UPHUXweJITNDcYoHZsLr818EQsXvUbVymBxAnyNm/jl3a
	oVEsmAW5Wz6x5QTKV6t3x9K8wzXT7216sPSmvMfuI2dfACSnpLwsBv6oxaIfSH0fXOKRh2HX4WT
	8jXww/QQANwHVYEIpPoPkvaXY+lCdXdAcHiEKq4pCQQbOxNIYXrAhgnQ5iNFNImsEWdEVJNt0Wb
	VeHV3Nt5P0l2kEGEN8fVcZhh8Ogm9ompE=
X-Google-Smtp-Source: AGHT+IGBpgGcnWw+C0SOcyJxraGAzm/jw0VAg2sebXTPvNY3JrfVFmYx+CN+ELmzscd2IQVrEVRZAA==
X-Received: by 2002:a5d:5f54:0:b0:403:4b6f:546e with SMTP id ffacd0b85a97d-40e47ee04bfmr14022629f8f.30.1759205614864;
        Mon, 29 Sep 2025 21:13:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb89065b5sm20717307f8f.17.2025.09.29.21.13.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:13:33 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	Eric Farman <farman@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 01/17] docs/devel/loads-stores: Stop mentioning cpu_physical_memory_write_rom()
Date: Tue, 30 Sep 2025 06:13:09 +0200
Message-ID: <20250930041326.6448-2-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930041326.6448-1-philmd@linaro.org>
References: <20250930041326.6448-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update the documentation after commit 3c8133f9737 ("Rename
cpu_physical_memory_write_rom() to address_space_write_rom()").

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 docs/devel/loads-stores.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/docs/devel/loads-stores.rst b/docs/devel/loads-stores.rst
index 9471bac8599..f9b565da57a 100644
--- a/docs/devel/loads-stores.rst
+++ b/docs/devel/loads-stores.rst
@@ -474,7 +474,7 @@ This function is intended for use by the GDB stub and similar code.
 It takes a virtual address, converts it to a physical address via
 an MMU lookup using the current settings of the specified CPU,
 and then performs the access (using ``address_space_rw`` for
-reads or ``cpu_physical_memory_write_rom`` for writes).
+reads or ``address_space_write_rom`` for writes).
 This means that if the access is a write to a ROM then this
 function will modify the contents (whereas a normal guest CPU access
 would ignore the write attempt).
-- 
2.51.0


