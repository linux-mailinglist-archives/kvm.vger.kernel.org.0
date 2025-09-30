Return-Path: <kvm+bounces-59117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5FDFBAC010
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 504751926032
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E9B2F49E4;
	Tue, 30 Sep 2025 08:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D935TS5V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5010F2F3C0F
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220569; cv=none; b=dFG71kVboxOhDgz+SUIqb3P17x4efDQvXHEqNtBipT96tcMUaBbbzsBmkem6QmwjmUoBZCSRhMUL6CqRbyMJOnMdlTURlxjsV50lBKI0thHV7jMXGV04TPsZCFegvnBfPAckEcKHyCcY+0KJPsRiM9BagSf41yDiA72VZqoYdtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220569; c=relaxed/simple;
	bh=vk39DRdwnmK9EYHcD7X5yTqGanZxroJJeCSmOCcXrOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oF5HOEzYdp8hEo4pBDRyiekcPlReDnJz9l/ypbEEInWLs0rFH4cxm8rPzKSdU8f0EpuuqyoYzqO02Bb04nC/fIVeaCHcKD+VAQM7PtBTHAM1gW8ApgzXWDmyFUxMi6Z8+7OxI/GcA/asuI74Yxa1RjpLRHMxpGNFH4ltNmjc3tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D935TS5V; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42420c7de22so444378f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220565; x=1759825365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWuKL8TfgkuOIExpLDHpPzfjXl06+qaviUFlhAaNsvY=;
        b=D935TS5VPL+KD3pg+qF7wSy0ATMbTC1c/SnXSWYClPOUjnZwI+MaieFmAvEexwnxk/
         gZlqXL+PY6IKtXNlkJYYG69eYUx09q/MLbLmY3Gbb35tDNBwW8z9F5YgVWBVqVCburjx
         upbSfBLV1QInMZTQqdE6rtLoHA0V2hYGH2ckLQO297qLCgnucOk+Fy56Z81HexGvQFEo
         v5qW0iYn/1dti3ikwj0CPZ5bxnEBqRXk5SU4JE42j2FVgC7bJ31N19yNrZAB/F8vR8VQ
         b0lX1NImmCMkzSGW9CPE2PWA2Tfww3lY4qWPiQg4hdpsh8/JZH1poSFPpkVTgh91vpI0
         nC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220565; x=1759825365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWuKL8TfgkuOIExpLDHpPzfjXl06+qaviUFlhAaNsvY=;
        b=w0S5T77SkWKAxsB76ZHViafc7oJugVrBcZwrAw8I4d42UK5Xt6M5QYyXNZfKbnrMBy
         eMguF9Zf+dAzWN5pP+dRvzQaUjxTujtewIPnCJANpToaMmWpAe0HjG9/X84Lm81JSH9x
         1jjKfF74R4suZ0MMbAVsDmCM7Y4G91CcxmO5COwl20FPVFxvTIQjm0PcQ5BDU1aHJKTV
         4afrVRZ5xnGFymPQJ6Cn1unBiwAVFsUHyCdo+9Iee3TY5B3SagpJ5TnWIAnKMLMAzc2a
         eEiPKFvqDkJAQLJHBxM1Qiofyg9UmCpbTUzqOlbDGR8a5rzNeC5/F6ozHKZpyfTJGvLL
         AERQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdHTmKJYoJYrFU9l9aPPiPmkIaA0UzXqH/NJUq578kddrlVo66FAnQmx0jjx2T0pOcfPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+TnZWp/sa1oZPs6PqN9fPyraOgpAA6r1lW1L1YszaL9Jtrnok
	hKsGnOACZqjykgLg89gxaEYSPZnt1Z1VvFb9W3sFFRPGWAOV86Flra6CmiCtkUYyUhM=
X-Gm-Gg: ASbGncvY6Rd/PoUBfV7/vhSskR8nQoyGuDcUBL/DeuCwfkoXbrweYfm8BKuaF2f5AuX
	cLYOPNgjXs7If/g8RURz6JxWHUpdWUDeNriPeZhiWFu6NdFw6Szi6aqFs8i4scc1jq7ojfhEt3y
	8mJRYImqYbP/5HW417ObDMZnV0AocPB/FV7vKVBfYyuzM7EBX9ZkNfjk/HDz6XUjmZteA+bnU69
	SU+aQUQ5TmJ4ZC/3zY8xlN9r604w1pXzyAxN63jnP6eguOMxXTce58QOACoU6H/DhGKKHkphV54
	LtO7vcCtfVZwFSKXsMIVe/E9ZwluIhSRoNduVL+ltBXTJ0EQ0DstZ83NIQoFMcPndtMpnTrslPZ
	s1kRqRgB39Dv3EPvjMvL1tQeWYI9Vkz+yPkZ5aL/5Sabnxb2GGsYOUebieo5K5dFVe5l7m4xVln
	tIpjuY7JNuTl9s1ri+juVm
X-Google-Smtp-Source: AGHT+IHE0WytwIozDLwCH/1E/tGTnOI9D8efEv7Y9aQk+zHE6qo+2lNsAzNshhN1K4J4d9d9Usou1Q==
X-Received: by 2002:a05:6000:240c:b0:3dc:1473:18bd with SMTP id ffacd0b85a97d-40e497c348dmr17529188f8f.3.1759220565490;
        Tue, 30 Sep 2025 01:22:45 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc7e2bf35sm21817486f8f.53.2025.09.30.01.22.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:45 -0700 (PDT)
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
Subject: [PATCH v3 14/18] system/physmem: Un-inline cpu_physical_memory_read/write()
Date: Tue, 30 Sep 2025 10:21:21 +0200
Message-ID: <20250930082126.28618-15-philmd@linaro.org>
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

In order to remove cpu_physical_memory_rw() in a pair of commits,
and due to a cyclic dependency between "exec/cpu-common.h" and
"system/memory.h", un-inline cpu_physical_memory_read() and
cpu_physical_memory_write() as a prerequired step.

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
index e0c2962251a..033285fe812 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3189,6 +3189,16 @@ void cpu_physical_memory_rw(hwaddr addr, void *buf,
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


