Return-Path: <kvm+bounces-59071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C845BAB4D8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 118073C2A1B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC6C158DAC;
	Tue, 30 Sep 2025 04:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bf24sZ+x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626A22EB10
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205696; cv=none; b=FB8CP9MykM3OPKA38mX53o4gedAVofUORBIZ4prca+v9p2eP59/csWdQ/hJPAhF29hsKjKFpPaA/0WPz5YawhP4Pr58ejNnrEGBX9tzYuyMpFnPOQkCj8oWW9HtNv/EHI4TPsP+zx+06L5oTHHN8sWb2/fiVv7zNQ7JAUFQ39so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205696; c=relaxed/simple;
	bh=9n4Eqyt5JnPjPyu8+HVhzBeQ0IZmT+fevn1ZcKpEW5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UC9uGJxsGMMl7LTFFbLJItW6aransImBWyEQf0yTYX2cAZXO4CdYbGJKxw+mmWpa13StoKMW/euDDW/3b91LlaNrV20gORAncmiss09jd7nPdDrPbp6WealRL+bJzI9Pxn3xcUT2qbAILMum4MX4KVNZEayzzNC6QFT72q/IMHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bf24sZ+x; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3fa528f127fso4221559f8f.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205693; x=1759810493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tDZrJ5n4JJlGtTIDZGasXxs/GbyDfsVnrlhryX3chWg=;
        b=bf24sZ+xo3jbVNokdv/WO6wzEwjZT58D2DQVj8LB1BJsykZhmnBJzVKvNDhN7xEcid
         OIsbs5LX/iwRIGKk24g+0jVnZAy5HXxT1evN+c03GFjFNMFJZYrfH4EG5GJqpl7GOayF
         EB7TDIUwdKdUo9TxJO03oHR+WlSHyV5Ivnlc2WE0EUs8xOdV9IfPnYLIH+2lqQCTWItX
         Bzc8/WP3YFnefEdADp2AiTzm269KDMxgB48ey418uq4ydXUqk982S8sjgj3J7MZeu6AQ
         3lTwd/BYb6in412cEZYYva6SYE0CoIJIfl0P4KXj1k20yiZPbTEFtHRHIclJbWx6W80k
         DTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205693; x=1759810493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tDZrJ5n4JJlGtTIDZGasXxs/GbyDfsVnrlhryX3chWg=;
        b=hUsBvLP3/a9qTxMet3Mj1/p8gp516tG//b683X2bXQ0QGbsLSW9LnAAEO9s6exVd+i
         K4V7MARtHUtWApSh6BVAo61IAdOyz0GzCYWynAmCsxNxetsU6rOtLsmhVrjOkFTscnGw
         BNGKL6ZH6IhVjRRZHoMyVHMEgLnHiyizW1cIdbybYyh5xFhFhW3V5bLxqlkJWywpjcMI
         LwzdgBhAeaic6sMQv2cQQh2nEPAadryw9aJultMrFeT4PANEGNCoHv8hGnLXprXDxRqR
         5JRaenEKlV5u/5cglHnYuJ3E9yta9ad7bizM4SbocU/SkMUbzgWMQhhL+mk1SRejJCDe
         Gl9w==
X-Forwarded-Encrypted: i=1; AJvYcCVrggZ66k7kcdXfdq45VHc1Y5hkOUIlSf4oP7SS3IvSo+pLxpeK9UytFDfb+02od68vQq0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxF2X2JNCkAb92N51G415vKZR8ebA2msWEclnQ+ZUKSjw1qRjE
	0fytgECDHY3aA7g4LvFGHk2repO2vjAZyuj5+1nHTmJ0d3UYz4buBUP1LzQDHs2iNK8=
X-Gm-Gg: ASbGncvejuD1lbb/tYYtKixhwPhpDnqcfP29v3EBu8ugHHzSz0R5K6SW/9bDzZV/7Mp
	BgAigGyXID37PtvStGzr75nf1tySWK0XT7AMsAWemT0HZc19Yvubl80BmDkwXk4cZihLcXP+TL3
	cxbfnsceYVz77oOL/IyZ9rt0Zwjp/aM/nASXvlEnFP7jYeoN/c+oWzFBXh+3IRqhjBXmwlzIsBC
	wCDfDPAFHF6L6XjxajiQHCftYguNWUWOowPzGIFpO7BRThY5vbXsq0B149zQT9a9eGN/NyfLNm0
	izRWVolTrK1yNUXpyyr76Aoh0K7D54w7ogTVuEO0doH/3ndkAnzQtAYH1Eu0mRTvbsUHwFJj8pI
	C+eLrU/l4DR4b1+HJotpYXsRwMP3mggULB3nXCHAhZAmUAAfI+iq26R4ky7CBuLXnPeP8c4+R/1
	Fh7jAkWwjCpleFs6+AIsxE
X-Google-Smtp-Source: AGHT+IGTcuGp6K4U+VzNJFqsWFt5qmyyMICY36EpMMpwA/c/CYvK54pPvXL/H3Oj0HTHDk8uqyOMBA==
X-Received: by 2002:a05:6000:2901:b0:3e7:617f:8458 with SMTP id ffacd0b85a97d-424116eaebcmr2419836f8f.24.1759205692755;
        Mon, 29 Sep 2025 21:14:52 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-41855fc661esm13064710f8f.45.2025.09.29.21.14.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:51 -0700 (PDT)
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
Subject: [PATCH v2 14/17] system/physmem: Un-inline cpu_physical_memory_read/write()
Date: Tue, 30 Sep 2025 06:13:22 +0200
Message-ID: <20250930041326.6448-15-philmd@linaro.org>
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

Un-inline cpu_physical_memory_read() and cpu_physical_memory_write().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/cpu-common.h | 12 ++----------
 system/physmem.c          | 10 ++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 6c7d84aacb4..6e8cb530f6e 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -133,16 +133,8 @@ void cpu_address_space_destroy(CPUState *cpu, int asidx);
 
 void cpu_physical_memory_rw(hwaddr addr, void *buf,
                             hwaddr len, bool is_write);
-static inline void cpu_physical_memory_read(hwaddr addr,
-                                            void *buf, hwaddr len)
-{
-    cpu_physical_memory_rw(addr, buf, len, false);
-}
-static inline void cpu_physical_memory_write(hwaddr addr,
-                                             const void *buf, hwaddr len)
-{
-    cpu_physical_memory_rw(addr, (void *)buf, len, true);
-}
+void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len);
+void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len);
 void *cpu_physical_memory_map(hwaddr addr,
                               hwaddr *plen,
                               bool is_write);
diff --git a/system/physmem.c b/system/physmem.c
index 70b02675b93..6d6bc449376 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3188,6 +3188,16 @@ void cpu_physical_memory_rw(hwaddr addr, void *buf,
                      buf, len, is_write);
 }
 
+void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len)
+{
+    cpu_physical_memory_rw(addr, buf, len, false);
+}
+
+void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len)
+{
+    cpu_physical_memory_rw(addr, (void *)buf, len, true);
+}
+
 /* used for ROM loading : can write in RAM and ROM */
 MemTxResult address_space_write_rom(AddressSpace *as, hwaddr addr,
                                     MemTxAttrs attrs,
-- 
2.51.0


