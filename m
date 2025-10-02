Return-Path: <kvm+bounces-59407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD0DABB354E
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7086F19E3703
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FDF30F959;
	Thu,  2 Oct 2025 08:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XBaqq8WY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBB9314B63
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394552; cv=none; b=Vd6Co0ONzF+lT62jn0IEI8deNeJdW227z5nxB3cA7z3EIwwpbCrb9wbFyjw+nE6f8fGR4MfZwhZQEadR5HybXm7+lMJAnVRb+cxeFahJ896VwIhuzVqayBLIjxQGdQej5UpR7QXOCr9gQe5Z7ylWvCL3Ho37Gbh1TNVxIocZvDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394552; c=relaxed/simple;
	bh=d+hAQzhdIx3jTG5o/dildQFp32JuDJ0P4l911Km5yPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gvdag8swRQHC8phncs5y0ScT0m65gXR/dEaMwezyDASF8r/ebQPIIvifWPU83ZgA9zeQKLCET1dISzc35qI6tZqMtMgO9LwGE2S9lME5BuaNWnn8o+Ym9EinNnOw9HZHifOYTWYPUakuXuqM4dOhfFLChAzla3MmY4/uIFLo7TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XBaqq8WY; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ece0e4c5faso543714f8f.1
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394549; x=1759999349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SpGUqjX5M0j82QXVYXw9oJFFwSK+I6Ya0azNIIXD0n4=;
        b=XBaqq8WY2gW8/XmcrEqVwgF0uCTGhflAucKDvyQDo2cz1dRsUHQmlXPVER6/Nl8WHr
         CG3wMweHvA6Q1mdV/2G9Z2ocGWymljrR6jwP8MW6eYPUZ3yn5ktKsPYt4jGf2QOHVrqT
         57spbHopETtWuZ3RVVuyhwu8BUuP0F0TILYmGaH/l0qJCsS/LrEVZPJujNRe3wwbxraS
         4ias4OjSlaEwsRi8eSEag2pKkV30XP2i8yTgZs5ofE5aLdEQWEypasWNPZRHa7xu5LoU
         l7Q4Q1H2dxlmlhQGhuNwBlPjY0Ke8hrDfT11x7EqZ32UzeTGrAUE4padRMJZLVUuZk9V
         Y50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394549; x=1759999349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SpGUqjX5M0j82QXVYXw9oJFFwSK+I6Ya0azNIIXD0n4=;
        b=V9/u9vbeDPSTMxs59V1SSjsatUZ40BW6kheGpVqrcf+HeeGY0ZakxQv0EmeV+IEXOl
         tPo/F8cD0djxHOcIynGcXTnjboyBqFcSRnW86tz8WyV66q9H6xc9f4Lqzs4Zl0iRwFyX
         59GXk7Az3Ss24f7/i2H6+HkmeTRYXE/WhXLnar9KgHbpGD2oGVtdeL1mLAPQfWIRywg4
         DMB39p74Rquu4iq12uL/XVwIJZewtQoXEYsAfNAKhznFG+be4C5qVuaFaMzfDUDqyiAM
         FGN5rbBB5kPT8pJrs6cdgfIgoutl3fag+Z9jJxiwbZvyVboEJXr+3Drc36iDxPkn+usg
         YwRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcjpsEggZfn3kqTbvGr0vXoNP4/H7Qk9OFzKTEWDLO32jGQDDv2zUi1HcNEpyri4ix9yA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdOJHFJGDuHGNqnzjAFb4s3ClTbzB1qypewMZPdMUyOhCuCSXB
	T2kpxR4NsIDLD9oxgs2bN1TQvYTJ2ZmGzqOH+9crtHlGM2oJUjjRXqWDocV6L5xa/jY=
X-Gm-Gg: ASbGncsqFMsMi0H/ImVPdakk2DgKxZK3IQTIZB0jjO9JoUYCg7IbC4a5Za6pbH42E5z
	puU4CkxF5Av/oQlZCgfL+kA8OL7J/jyZ0aeWMEx8HNtOE+3vtJTjAkYrf2eQ3yYiTOFpBqwZDE2
	dCq7wbstiCxl+X0sYRU9yrhtOPK9AKZKjRbrnJmlMDczQFFbeMFX646m+wLSYeK+9CpzrK1Xfcg
	zQwUw5wVz7XZvo1IBxfth9TpoY3fQu2eRgUPbpMFgGHG5RL2bpkJWF+mMMw22F6wTDxixLMvciA
	0uT8ZmQ3CLWSc9YUol6zToAPG/i9xwuKfzPnA05DoRfcmRTNqb3/9gFLMqQaoEZvL8ult7cqi/x
	a9RjYOafeCwrTdx5fJX1BMNn7pdci/K6ucOh0VLuTbPmomug1lwdy8ymUMmzZeGMkT1MLSB6XdH
	49Iv6j3ZmfDXkpRjaTVdOZuQLV3nxoUg==
X-Google-Smtp-Source: AGHT+IHnMMvrULFyoGLvyWEYNdN7opPAO0EOueQAPseRRuabHvxN0jtL5dWb3pgTDAuMakOX0VTtNw==
X-Received: by 2002:a5d:588f:0:b0:3e2:4a3e:d3e5 with SMTP id ffacd0b85a97d-425577f362dmr4449090f8f.22.1759394548791;
        Thu, 02 Oct 2025 01:42:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6917a73csm25459055e9.2.2025.10.02.01.42.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:28 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 05/17] system/physmem: Remove cpu_physical_memory_is_io()
Date: Thu,  2 Oct 2025 10:41:50 +0200
Message-ID: <20251002084203.63899-6-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There are no more uses of the legacy cpu_physical_memory_is_io()
method. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/exec/cpu-common.h | 2 --
 system/physmem.c          | 5 -----
 2 files changed, 7 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index e413d8b3079..a73463a7038 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -149,8 +149,6 @@ void *cpu_physical_memory_map(hwaddr addr,
 void cpu_physical_memory_unmap(void *buffer, hwaddr len,
                                bool is_write, hwaddr access_len);
 
-bool cpu_physical_memory_is_io(hwaddr phys_addr);
-
 /* Coalesced MMIO regions are areas where write operations can be reordered.
  * This usually implies that write operations are side-effect free.  This allows
  * batching which can make a major impact on performance when using
diff --git a/system/physmem.c b/system/physmem.c
index c2829ab407a..4745aaacd8f 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3763,11 +3763,6 @@ int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
     return 0;
 }
 
-bool cpu_physical_memory_is_io(hwaddr phys_addr)
-{
-    return address_space_is_io(&address_space_memory, phys_addr);
-}
-
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
 {
     RAMBlock *block;
-- 
2.51.0


