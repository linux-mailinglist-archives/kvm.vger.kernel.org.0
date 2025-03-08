Return-Path: <kvm+bounces-40513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABFF4A57FB4
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 440FC3AD499
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0863220D50D;
	Sat,  8 Mar 2025 23:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BOUPgcAw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B32C2FA
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475440; cv=none; b=dnb7rWwaA7LM7r2nHU437SmxBgWrqNREIKhW9ufPrq7aWJwRLYUZUmaL+nO41yWMeGbtHCpBBc379dZoDKrfcVsUn73TgBemM/ki3wyFcikTp00+S391V/5TTb77HFlpJ3XjLZBTdZ+TmF5SNxyZAXS7PE+Z9RfUdTUKZzHIg3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475440; c=relaxed/simple;
	bh=0503i25oiKvX7riJYo2CLDDJ3sqilJTvQAsPM3F1GZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqdWnr33dqbhOz9NpmlZ0pH1eU3/P3E7CDuXn4l4Y8H5aEbJ53Fp5ltABOOxJrIDVo5nh+MF74hFdz3hnCG7DuNHCPA/Hw9mdmxlC3jYoFAARdnPXkN1H+RxJ49nSh5NI1fmTxXj2gARsKZbYWUSsGuNQJWaG7lIV8eB9gpmIAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BOUPgcAw; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so4078485e9.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475437; x=1742080237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCiNgLEiS6OiisxvVuwTtdLprKkJGMzsN7gdfZerLX8=;
        b=BOUPgcAwWH9ixnYebsoWq0m1fP9E6EHc5CWyO5qrc6GY5yoi5kABp5wJMwokEX504U
         ptP6eV/wvq1nqut/yGAILBjU8Mm63StbzQACWzW8wXWZd63SK7jUhv164bR0cOKZA1b3
         kM86F/n1Z5iAI+wk7+uVPRu9jhWcsUncArH0zjcN21HVB1XyFB4VsRze+uto+PJb9D+j
         XPrDyGaBfuCLs1GJ51HOGbXaQirRgy2ZE8yqtiMRP0Vo/TgXpdPufEjQafiWhu3fQ13+
         9N5Mn85AumH4gNKYKkeKVTckce65NL5IqqFklhSsnwbMBpCmz0tydKE24CMDbhx7e3dz
         3J0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475437; x=1742080237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCiNgLEiS6OiisxvVuwTtdLprKkJGMzsN7gdfZerLX8=;
        b=cF4jU+6F4FUzI0yNjl/NRBjLQLh0faw6A4n7QAcfoVrhIg5hfnnnMN6MmESepjXTxC
         tuJ8yOgm3AWg3n5ByILNvuPpPCykmgNCWNq0ipfNzrbZHxbVtcG8aoGVK+T0rx5ZojSn
         H1/F2LyKskg4WQ6uMoOrS8zeQVJfFnM8hd92Duob8LpDcYCtgdFNf/kz1fPQ9+wSXdc2
         T3wK1pHjRxNoM6wr2vMJpd27wmVjImMrGdBzcKbLHKLBLyyDZOwZeUXxyADKpgqC5UIZ
         /uUly1uw8kYvmoNY1g6Fo9w8teO26e1BIAsFGWLVXNILhWC+tjE2L73ILPlR70othrvJ
         ZcMg==
X-Forwarded-Encrypted: i=1; AJvYcCW76mRJ8ld1FpeG3kKM15jHWn7CvvsZsDf0GxfSpS4pX2O5BxmeO+zCcAzMjfcGy9q3Pic=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY0zWoLf2X2YbtATISliXjYXJXhm4e3pAoJ48fcawoKh4wammq
	2qy2BYpzxdSOcX67r3+EV6zFUV2gVCQksknBhaKqXfwZQVnxTcQXTaYVCOEdDAo=
X-Gm-Gg: ASbGncuKTKarbkQWTcq1kz/mp3DaewfsLusDlMwJOYOjQGPsMlxxhSsiQ1phtRkHaFD
	jrDjcENzs6GAg6pqJbB/m/GA61/GDZaZ4gXRPDCIkztfI+h3lx1HwQ8rysp9hdtG1GniJEoyva8
	KYREcgMe5aGBMVLjJojMzrSuXDGboDZrj98aGzRJeJAKCtwhNqxP7StLZh44qPgWRTvni1LisTU
	0I3U0okmLxqLl1WGfvZ7KZRJvcKgmoCNYT/hnrWWPCMAOlLw/dRpB80DbUL7zZyjcLJTAobM0MA
	CvrUGawb+H2WUoKElcNIwZTo42Tv9Kyl08q1kGMxO6XTlDpbEPyCPyicayDO0e1EzWuMgqLpnEw
	sU7g0xm1qpGUmhkbXfd0=
X-Google-Smtp-Source: AGHT+IENrA47OVsXzaZX4a1bGAgrCx0XL0i2aOlzI6Mq7cL2vI+8HE9sGHrEgItEH0nHk0n3/e8OGA==
X-Received: by 2002:a05:600c:470c:b0:43c:f050:fed3 with SMTP id 5b1f17b1804b1-43cf051022dmr4854905e9.11.1741475436763;
        Sat, 08 Mar 2025 15:10:36 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd42c6203sm126860865e9.24.2025.03.08.15.10.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:35 -0800 (PST)
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
Subject: [PATCH v2 13/21] hw/vfio/igd: Compile once
Date: Sun,  9 Mar 2025 00:09:09 +0100
Message-ID: <20250308230917.18907-14-philmd@linaro.org>
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

The file doesn't use any target-specific knowledge anymore,
move it to system_ss[] to build it once.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/meson.build | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 6ab711d0539..21c9cd6d2eb 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -11,13 +11,14 @@ vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
 vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
 
 system_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
 system_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
-system_ss.add(when: 'CONFIG_VFIO_IGD', if_false: files(
+system_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files(
+  'igd.c',
+), if_false: files(
   'igd-stubs.c',
 ))
 system_ss.add(when: 'CONFIG_VFIO', if_true: files(
-- 
2.47.1


