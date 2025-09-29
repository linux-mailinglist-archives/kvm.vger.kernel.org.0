Return-Path: <kvm+bounces-59034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5889BAA4F9
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96C003A8C94
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0388323BF9E;
	Mon, 29 Sep 2025 18:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p+pWWGoE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7368074C14
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170824; cv=none; b=TWAVHRxAY75py0rtPHrFWIG1lcjJf0l1F6fKbD3247+W40d6Ln1j4zU0tl7Emy8KZxhK4ecib7I+58Ybp+MhAV+1PQr5uchdP+gwa4felhfET6Gc46ch0oeBzvAExW7DUCjKCrOE9dFkQWlKs+NayWZ4XYkEK79x+CazjpbK5p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170824; c=relaxed/simple;
	bh=Kd3qG8yteLnzqTqa5lNxN+xIix6uNUkVKZrS5PpxcpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ei0/IUsxORZMfC5WLS0jNZ0+OJOmQD5tl6IKMXnPQ4cgXmRgzfwTOKgiw8IK7LkVYIiDZJls/bjvmo1O6fAdFg6Xd2z74ZQlGx6keNOacqH9MdZ54zifp619/bL3y/3x1VhZer9eCzHwBpvU28OwMzXRmel8J03sFqltgOrnClI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p+pWWGoE; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so3962735f8f.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170821; x=1759775621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbEYNZgIU6LqvkF49qge8kIj2C3i6K2S813tsyxbWwg=;
        b=p+pWWGoEKqxZZTX5r3A8BJ2LBjNyKz6uHTx1rhS3K2LzFHmoKv4aoysoJyU7A0ajek
         SD1uiL0Sxf0mz3sBXDAJoXedXxh4ltqpDDoDpRgHBhT+GNBRJJdUeTTu0Yx2ljDNbpFi
         NskHjHSjAu1RfiWedaLLB9763qvAV+cLxjDYLj1Cuc2HmmQ/L8FxExTLc7qS70SkAHnW
         3gmnPZF2t0kI7z3vLZkgoZduRtbjqg1lkxp/bHMbY11xBBb2YQjIzmN273OMxoMZecrM
         bAOOTzlzWzRG5K2YeT472VHxuUSh8/HJeLrrIz3snCqMH953fkgabTcX6t92DxGeWsZH
         glJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170821; x=1759775621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbEYNZgIU6LqvkF49qge8kIj2C3i6K2S813tsyxbWwg=;
        b=oFuT5fzSA/3Egl5NWiziqQZe/IEc4uO+2uOQe7b5vypYA2WvUZDAJei1cSD9IouRjO
         W3C1WhDBXYXRpNHJmk5Z6o28DhiaSOMIn/NO0iYlWQI+V/sGSHjRa6+5HneOGWmALP2Z
         AXKjKGuuqGzrHCtk8K/BJaLi3mYzZpZu9EJcjW31cuO6qe5nUGoxch9JJoDukRd4sfA0
         kaeGD5rvFYrnXyNmbZ/DmLSz9i43icMfjyuup7qmA4oPvHVpKMobXBlp57QJwyeHueON
         oh5QI7TJemFgglP/Fp7Osmj4rzxF2ICSdAj81o4GoGAtJnVC9pilLt8vcsIxjjHhm1hd
         P32w==
X-Forwarded-Encrypted: i=1; AJvYcCW1k6CJIxOIqwgWbrtBV9px5XV5swVwsdXa9B1bhblAzaKLi502W007gIP7Llo+HA/vHc8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+6YmN7CKpO1znIi6ttWGhZ6bwdAxyr/E+ISQxAP+l71e/gXf6
	IWq7r2gpocVCKk+mnqK6KqHElP3cbeqYT/YWXMwLsHSUYKnYuHW27/TWaA/2yytD57Y=
X-Gm-Gg: ASbGncv6SGQiXUaLFDyg54XWmsCy5EsIDjP3MQaCJ4Y+GepEl0so+GfgAKaWPF2wqHu
	7e7VtxHlq78FO2KbRcqH1b6JdXlRr696SehKCnKog2SH1sYW0ElKicO/BaxACO3ZXRy85WBGZi3
	bb+iUkCXiIVzbKHBqPvA7oUmBlFEWsUrTjPctTibTdTsAYtLGa1YhsP31TH68f2ni6oMhQ5tLr7
	hlV+jB35MNaKkC3HOGTErx6aOPziYnknMori3aIZ6iGuOuJmpYZceaI8XvLK80WlUsSMzph0xDF
	cJgv79TWnrtjLR0KSuSrT8Sz1RdAbwic5rj+kAQIb8HXCHGUEZfgaa678m4Bw0y1aanS7QA51ze
	hxriLaTQn/ZZRjzRfjhOOIoxRcAsfURmPZAmZvXwoxLVAqrt3n/C/FEVywtQmewnFPqQM5ajI0z
	uSLfIbNYyZJbC86+UJXQ==
X-Google-Smtp-Source: AGHT+IHaOBKfpBuD9vwP/E//+ppjcdL0t+dVKZj3FJZtAkNcYom3O6PaZLYCHSxxg6LM7gcPXW/sAQ==
X-Received: by 2002:a05:6000:2c0c:b0:405:3028:1bf2 with SMTP id ffacd0b85a97d-40e4d0372cbmr15214118f8f.62.1759170820742;
        Mon, 29 Sep 2025 11:33:40 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f3d754sm23909085e9.4.2025.09.29.11.33.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:40 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 08/15] target/i386/whpx: Replace legacy cpu_physical_memory_rw() call
Date: Mon, 29 Sep 2025 20:32:47 +0200
Message-ID: <20250929183254.85478-9-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929183254.85478-1-philmd@linaro.org>
References: <20250929183254.85478-1-philmd@linaro.org>
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


