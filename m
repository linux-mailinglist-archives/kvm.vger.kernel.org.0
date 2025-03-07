Return-Path: <kvm+bounces-40371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3A3A56FFE
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4558516E6AE
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A837423F29C;
	Fri,  7 Mar 2025 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bQGrTdk3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAB2217670
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370645; cv=none; b=XAlcSykADKnXnoYn08WbXMJa3LChZe9Q6R07vgRMhRQ3MNUvFdfQ/WfBM5VgucPfaPPI/+ZV2GaayTwe5ZQQfxS9HRo3JIcsHd8t3OgpGKYvE5fol3uO/W0bn0dcCerio2WhZR3KvBDvDzuIaVjFNuMqZbcLpciMSk5Rm8/6EJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370645; c=relaxed/simple;
	bh=lXXphKQbpJNTtHUav52LK+UzEncfLO9/RxqUhhKP1VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHNO6duiBTGUn16KtT5rp10ISj5PsjfvhfwAGNDQp0nK264ueFlUBGRzXty87kuRJHMw92cyI0Q8MohLS3aIaEj/2BGgPF4UqXqq92WsVnoHUzJMTAU11lt9lwJJKbe68yAfOSi8cO2vV6IJBFB6PrVdurryVjX3Yf5mN27wHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bQGrTdk3; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43bdcd0d97dso12780115e9.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370642; x=1741975442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjnP6suRKIDIvCyvQUHjHOPyIvdZR5e5AjhnJZaY/H8=;
        b=bQGrTdk3D9EZZ2y7ZKXnhfngKzQlGgaWpWoM+6b83Fez8XpMG913Oll9COFp//oMNU
         QDBKegAgYy8xm927C0vYN64AyG28wIpyHNo6EMEoi/6L12U6eejx2LxMXy0k0CkhxzYf
         lBtVEQUz8BLLrfi9vQY6fMGoY7Hpyb/KShBtsok1IyX8/2aMIiqXaZ32qTW3DNxwZlLE
         5fwEmlK4QlQqmhH+UFG0U8X+pNo4yRjsh538eXVN1sSIbcTnR54bcYLCu8mU8d7np3X6
         X2I70sGvJrJEqbK9RfDaO4ySrI4ji2HgLHpStpe+1ZEyIn1GcJtJ2iPtHSzJOg51VEWL
         mrWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370642; x=1741975442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XjnP6suRKIDIvCyvQUHjHOPyIvdZR5e5AjhnJZaY/H8=;
        b=WVl4D0nKzXxHy4qlPPmsEIWUhCYjTw2G5Zwa9slFJNeG3Rp4xh37OL36T737SB+AhE
         vuI+n3NhRdjIobgfMAlSBeuTvjE1/82UVzv/0wzlAoJlPCz7d5o7rDldDgQtPjRZflOh
         VQT66bMvCATmECHJfy9S9NNMIt3ke191ht0GpklWucUV//MtUJbB/RsqLhu32U16q3eI
         I2f7v7P2z2IlQrNxI/rcjYxO3IwhxrpdDnMyoOHOlUYLO0toUQ2SUUwySLQFFXg2OJXJ
         7nF6czPavfTKxAAHulBtjrnlwTyL4gTV7aSMkv9VjstUSkJHg/zeN6Ae7PkHi7bysTeL
         HXpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZobhLlvh8Ud8jvDpHNikEMb27fF3xNCe+LbqXl6zmiHpWwVCD8oi542oomgQ0lSHu13w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxevIMRctNdedZ1xvWEOoifhUSQmz8AC4mUjamIP6nViRvoVGuP
	bzGFekSyUlWs+rQxkBWmNpsu1CW3iEZC16OeGepORXOxDA2aIUT2aAZfkKDvjh0=
X-Gm-Gg: ASbGncurV2U84WZO2cTPCk1pyfuxVK5UoYAQfP7SxQmqQzzsOkd5DLQd1gm8LgE+xlc
	wKkrwMed/rTW2zLOTEGjYb/EB7Lvuy5nGGC2JfDyUFCJY+4WqbFl3JhYXt0ejs4vvFebL6CSAew
	OuKyiwQfS4No29+Arr51aul2UDBYhHpxTxSFsBl1yuRHPS/5hak3i17XtIU/h4cGXvtiGyZQpXC
	zELnkNBpAdpZX6IknxEss3hVjP9uuqRSkGEpEdCnOhuXthdqlIvx+0XBGj3gntfEZIt6PY/U2Rj
	yfS3D/P1Ot0zJfsMdp3LVSgdavUhScYhl6oURIt6uFpajT4GCuSCiUE/frlRZKTOdnBuoJq+4nP
	kWLI7IKfNNQExLp64wjY=
X-Google-Smtp-Source: AGHT+IH3pBJfwJ8GeERs7TfdjebZ04J4hRz/gHgLpXVYv4THdONSI3tncV7atbL9lWwA6lGOlofjPw==
X-Received: by 2002:a05:600c:4683:b0:439:9f42:8652 with SMTP id 5b1f17b1804b1-43c601e1201mr33989135e9.17.1741370642093;
        Fri, 07 Mar 2025 10:04:02 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfba679sm6002314f8f.8.2025.03.07.10.04.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:01 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-ppc@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Yi Liu <yi.l.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-s390x@nongnu.org,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 04/14] hw/vfio: Compile more objects once
Date: Fri,  7 Mar 2025 19:03:27 +0100
Message-ID: <20250307180337.14811-5-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250307180337.14811-1-philmd@linaro.org>
References: <20250307180337.14811-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These files depend on the VFIO symbol in their Kconfig
definition. They don't rely on target specific definitions,
move them to system_ss[] to build them once.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/meson.build | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 8e376cfcbf8..2972c6ff8de 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -14,13 +14,13 @@ vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
 ))
 vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
 
+system_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
+system_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
+system_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
 system_ss.add(when: 'CONFIG_VFIO', if_true: files(
   'helpers.c',
   'container-base.c',
-- 
2.47.1


