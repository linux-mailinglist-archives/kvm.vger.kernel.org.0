Return-Path: <kvm+bounces-40502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 744A7A57FA9
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A50B16AE60
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FF220E31F;
	Sat,  8 Mar 2025 23:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lFb16e0A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1006C2FA
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475376; cv=none; b=sn2j2AC/JXaGYCuUMGsZvMtpGMo+uG71giGeFIXF+fDN0Gorvr6qtZ0vCMDwuJ7S+04Wh82GX8LI0sNSateFi3nVWO8dY5tMlL0zGmrUBxU/PIdmS84oqB9sYJb4QL65s3BHCth1bxaLbQfk8xO9qM7wungcmmjxq1f3LfFzgfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475376; c=relaxed/simple;
	bh=AInv2ScCWeturStaBsdVLk2o0m6S6PvKzCLYtxZiLQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L7hF6SWP/rm+YbDSgM/ZEVaWWhZyPX74PbEXqn9qFfyddRMqm1cWe1mKlqgCQIpmK/MGpoRO3ZdmWZ1xR5GGP+RrNPfBjVuG2M36Cg6FOLhZ4QY9pyU09u+cxdYI/3osCyfAZEkhM7GWOJFkBMolgu1UHkGQJnThBKYpo2Bzp30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lFb16e0A; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-391211ea598so1794674f8f.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475373; x=1742080173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UiYDGY0x4W7ov/VJy7EJQHs//caAqbf3NrfbrKDB/Hc=;
        b=lFb16e0A58nCRt6ly5YrPAdcOuy6/vJClVEDHe+/5BibMHBe9uWxHkApIQHC/IeLcX
         uDyuuXPZbp8/dWvJ+vyFvtfax2F5/fpl9eZ0WuK9BcPzvbQi7hpwlYpPWUgSKQGtQOwV
         8YkDTevN4jlz0MpIT8s5wSN92mzhGgTt3ceIMVwqeklaa4OVgRL4SGgDHk46RsWvG4qO
         81c1SvUF0J6zVmsFw/sj6svgDrKbMniBWcM02mGftcHyI5ja/viiGJx7vbNJm/E5q4JV
         69mCkkQXbOVmOgof2nkSI86DR+PzHR/QIRledEiEqLSN4c+FalmN8IZP7KUOatyhdJP3
         x+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475373; x=1742080173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UiYDGY0x4W7ov/VJy7EJQHs//caAqbf3NrfbrKDB/Hc=;
        b=Zc+423DzBwmMtv1sMAr0gf+l7O9pnvF1pxr0GmHla0nRkZABl8IV9C4QlZVGzKaOJ8
         wiasoeQtKzhNArlWhQNWHMsIcjBxmumXe1kwp9OQaQ0S8N6g7P/w1n2ULxy3CIFrsnuX
         8veweERM21kqe4xHZzdrBVHap2MZwaHhZc0v96YmgbNx0lP5OX+yHiA7qyD4Jwn31IVW
         gnyfEQ/UyPW8sjPgfiIa8EbrekdkDtuO5ysFcjhmX45U3wZslHoPWTK5LG43zAGcZgL5
         OFR2WzEhaejhP8igu9i4H3QzdR9nCKJhr7RxOZPEfj9hV4vSkroJNRUq+wjnyC8og1lH
         MfBg==
X-Forwarded-Encrypted: i=1; AJvYcCVqSXkH/cy3HGmUYQq+b7AIWkyfqHkkDsMU/eV9DoATn+8TwRsRMHX4/Udl5jXO6r+xALw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0FP4bN1qnvk8kTPeMrfJ18mbg8ieojKvlCH50iA6Dx0ZZQhNn
	/7/dDJ1VVuzpzRwOeU8Q8kXnI/lsWFymTfxGuKFt1MHOG3Zf/LjLxX5tN1OGnqc=
X-Gm-Gg: ASbGncvGVuNsZQIsF0yK4Cnc/YLbPFO55FkMp2kyciJsF1XE1HUAqFI8RUBSJHWdfSI
	O88J9Ao6+Cw0h2PUoo8LgGUG33DCC6y1FRqWZMO3swwtOj16kpCJdZyeaXCSVdorleP6K6G9gLb
	wCGfp37kKJymjKvT/5lbmchKXwfR9ECh24XXua0eCVjhwPAU27gjftPg6qXXgi2m/3xW0CNQsMp
	IVVH3MIHeVzDMjlQamIMYXQ+siqyaX0y+K7n3J3StDHm04IVaT7d0YUeDSR5VBg7M/OFxardLkA
	WVQF0dyTmr3dm+WhLpuJtJJMiJe0/k88qmJ8gttS9mFVZVnj/DX8h32eduWOMPOJnCR90DBeWTi
	m4lDCl7Sk2T54eDoJlng=
X-Google-Smtp-Source: AGHT+IHYMJqZoHstkmUTso6ugEbg70sSuamLLXL2p0kaDugCZceiL2gWbQnBjC91i2JahXaPJtswDA==
X-Received: by 2002:a5d:5f8f:0:b0:391:2e0f:efec with SMTP id ffacd0b85a97d-39132d1faebmr5173255f8f.7.1741475373036;
        Sat, 08 Mar 2025 15:09:33 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfe0004sm9859574f8f.40.2025.03.08.15.09.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:09:31 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 02/21] hw/vfio/spapr: Do not include <linux/kvm.h>
Date: Sun,  9 Mar 2025 00:08:58 +0100
Message-ID: <20250308230917.18907-3-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

<linux/kvm.h> is already include by "system/kvm.h" in the next line.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 hw/vfio/spapr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
index ad4c499eafe..9b5ad05bb1c 100644
--- a/hw/vfio/spapr.c
+++ b/hw/vfio/spapr.c
@@ -11,9 +11,6 @@
 #include "qemu/osdep.h"
 #include <sys/ioctl.h>
 #include <linux/vfio.h>
-#ifdef CONFIG_KVM
-#include <linux/kvm.h>
-#endif
 #include "system/kvm.h"
 #include "exec/address-spaces.h"
 
-- 
2.47.1


