Return-Path: <kvm+bounces-60304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC5EBE86BB
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A60295E2FBD
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FFB332EB4;
	Fri, 17 Oct 2025 11:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GpzV3oQ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A263346BF
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700844; cv=none; b=QpP+ywImKknp0bpsCEQ/TCAjH0KfmhFhmka4vlX/lpqAhpP3wWDyPgFRgwl0jw9U77BJ6k8IAhQ+/dl6kveQF9jbHVOYdhuN0KZFq+PRq9YvvytwO/DcNLwCyFvG2KdKFquhq/tGQ82zLwlkJNBYozHO5sgjrlCWoG1r+uTqORc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700844; c=relaxed/simple;
	bh=AApBZrW4/cbMt1+Vke4JMf44nirXxFVVoLL6xILURP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxM/W4yiSE7gwKovREjE1OGtRfVP1nwnsGoRQgFkGd/3BOv6bx6Wo4pIbM41r4F04CWkAL6TmM+YRVnpBcSHK7fCx9AIHV+3zYmZ1e6NeYXbidj6rrRw4K1yFxcwufsrFxN5ZdVo4zlkr/VJaT7e3spJ4hk05eFz3F0CJP+BEWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GpzV3oQ0; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e29d65728so12787725e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700841; x=1761305641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HtQk0GJuCq/JgD3T73Q/ujEtbCnLstw5lfgjKUjPFqo=;
        b=GpzV3oQ0RRf4Yj5yjsdAYOFwI7lpr3r+yC4r7C4RtxLdjPw2FlE6zrpcS0IX9tlfER
         ClVhfY2zbqOP+uPkXiUqbGR3xZf4//uqOyY7i/IXEVckoLUHXdmE5qLsKltVy24/8ybh
         CMIXEzmYQFEKoBSDiVODXIa5XNyWo9zYEJ8KRVV4LIuugDYUVZ0wHngJZOCrKfqkzTAa
         ulMX7CSNCSzkBd4rfSNomnv5ibJIyTv+a4GptL82uzlY++KxixRx/Sr4gjGS72R+Gkxc
         iwYyCUtJq08moVEYeU+18wwP7m43cZWLkB8792biv13mHf85QPVZ0ySqg2H/l8hMIibX
         wgHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700841; x=1761305641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HtQk0GJuCq/JgD3T73Q/ujEtbCnLstw5lfgjKUjPFqo=;
        b=P8rp3CH7tt+8lP0Vnkx5OOZ6NJgEPlcexowZPKN6+qSTUdwdFKf7lza+yEmXWgVGko
         iYWuyeKorhoApV6key4E+y/F0DB+3+SeV2/5rrsOPXuhUMyiy4gAldO/mU5icEoIUCuq
         PtFrolkO+ZZo9bdN2QZqqrvIMLalqJGN7dbcAKtcQ18u6xk8/Fk+UtKG05mV6sijc0+M
         O3nmG5tsljjLKPTk4PC8YNuNtRiI9Ysa7DoLBptxeWcdAihNg094qwnuH0+/e3ziu26V
         k47D1u+XxNO4QZrZNKEXekqr8MaemLu0HxRF0m2XUNnMzwyHqoa30nW1sADyiXoIDdCT
         24Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWRUngcmLVluFipN8kFvrM6/abiHIaX/rdumbrviLta/PkSTRhGVqVVuUYrQ7YJljE6ElA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ7NIbTT7QzJqwLoCpIlK+GSIq2itAmwZ4/TETkloDf7uUoEB2
	negTUCaJgzwNvfV0Q5DRII2ePCL+MV+VEq9ANaVXVhWBZw4P8Nl67PqZ
X-Gm-Gg: ASbGncs5G9kBWJu7/VukcxN7IrjcnMGKWhcBWltJDH/L5I6fGUsGdZJPJ63wyPht2nh
	OiOkcd6YSNw0i/PH2AjYmxUoXQk3vcPmo89dxNWIaBpAUpWD2jtKGjOWbZ/LwmPLUjcGMbSGvIQ
	BKtuf5OfnCLhtQNWNg8Q6UbLlpDTVhyNfpWsPjUZiUa+2uXwrw35hPx5zTJ1I5eleFvNnXXsJvS
	D+W3SIdwEG6Jwfj1x4rM7bT2+IJN3CH+yU1DPK4l1xR6hjaodTqlwaI/ar1RdP725uwWT5Tvv3I
	ZOS0vqzyqBwOqWnd+pUQ6sfS22kG/ajlr8lbXH4wtk8KZe3iwnDtJcNDWwxCkaEC3Cvj5MAwM2P
	FDWV1oIeYQhU7wA62OKPJMNqZMvMWMaERq+uARXzb/yrA75/w2gT8C75x5DEwhm5TU0G6uQWKAo
	JDsrky5ZbLMR2DR4vxMrJ0y8xi7rPpcfwul/KHNQJu5IY=
X-Google-Smtp-Source: AGHT+IHnu+GakzzSeEi2iUO0tTroVaMAXrhyHBzxS5+N+mWFSMCsDYg1lzurYZznwJfsxWlWvCdE2A==
X-Received: by 2002:a05:600c:4e11:b0:471:c72:c807 with SMTP id 5b1f17b1804b1-471179079c7mr26540505e9.22.1760700841253;
        Fri, 17 Oct 2025 04:34:01 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:34:00 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <laurent@vivier.eu>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-trivial@nongnu.org,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 4/8] hw/rtc/mc146818rtc: Use ARRAY_SIZE macro
Date: Fri, 17 Oct 2025 13:33:34 +0200
Message-ID: <20251017113338.7953-5-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017113338.7953-1-shentey@gmail.com>
References: <20251017113338.7953-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoids the error-prone repetition of the array size.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/rtc/mc146818rtc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/rtc/mc146818rtc.c b/hw/rtc/mc146818rtc.c
index 61e9c0bf99..5a89062b4c 100644
--- a/hw/rtc/mc146818rtc.c
+++ b/hw/rtc/mc146818rtc.c
@@ -726,13 +726,14 @@ static uint64_t cmos_ioport_read(void *opaque, hwaddr addr,
 
 void mc146818rtc_set_cmos_data(MC146818RtcState *s, int addr, int val)
 {
-    if (addr >= 0 && addr <= 127)
+    if (addr >= 0 && addr < ARRAY_SIZE(s->cmos_data)) {
         s->cmos_data[addr] = val;
+    }
 }
 
 int mc146818rtc_get_cmos_data(MC146818RtcState *s, int addr)
 {
-    assert(addr >= 0 && addr <= 127);
+    assert(addr >= 0 && addr < ARRAY_SIZE(s->cmos_data));
     return s->cmos_data[addr];
 }
 
-- 
2.51.1.dirty


