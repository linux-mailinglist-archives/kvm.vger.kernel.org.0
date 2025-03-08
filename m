Return-Path: <kvm+bounces-40521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C480A57FC1
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D848516B015
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4167212FA9;
	Sat,  8 Mar 2025 23:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tmVsheW3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AE217C77
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475484; cv=none; b=inUo5X9Ra2XjcT1X1/2v5UV2vcM9SYdw8Fs6hogie823o6cHSaPxD00CFPXiMjowZNzEqdttXBFJdYDgMJdIeZG+ejGAINuOTl/YSOCWz8/5iD9u8BZhVbyACj2Ox5KWFnhmPJOPgJTfgtQLYolQmgqHTtqju5SnD3NqVNlCFBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475484; c=relaxed/simple;
	bh=eDh3c+/Vj8jpKN0lbJP4pS05bBtQ7yp3s2/UePZ5ch4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tn1iOxNxB4rw4YaJM6h9pqK//56yK06TgyWcZAyaYfdAyy2LmluoXKVlvJ1tTV3VK6qjHikuQfW64zMkcd9vvbZxgSPhHRguiQOZVyzlDcp8Xb6wufPW6CJU8zaY8YdB3puggS84euharF6o/uPAYE4yiF2bYvpPPvfx7qjWOLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tmVsheW3; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39143200ddaso71944f8f.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475481; x=1742080281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=prGg0Jp93h0bTm2Rvsy5eDeK3CFMwhrsFj/MryWjJGE=;
        b=tmVsheW3VH/Lqu71oEAkCxUnAGg5xKRrVQ8XpgzrH3NuWjr5kyYTWouMkIzOvrbwW/
         HHoLa0+HkzrUb+WkNN+qjs+Huf6Ybh4x6Q9wHjYKfCmIMs9QnPSataKN43vT1Xro9dDv
         t0NVBwFQVPqfqlie9+uZJVN3waZXvFzfu5XKXAc7xeqS3RWPT7ceqfYkjJ6xDDZAzAUn
         I3GQtPrJl0BSyhAGr4yK4jyvBicFYqrXJSKwQliRIn31xITwo5npLzgLspgehBxbfEok
         yfpi+4mvxPADatajI/kF0cDhAOgSdDMdMuQRyRlyLgwo0c+vpKyupdjYeQ0W1Ykt9m2S
         bc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475481; x=1742080281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=prGg0Jp93h0bTm2Rvsy5eDeK3CFMwhrsFj/MryWjJGE=;
        b=DcoSoGU7N/ImuBUIhY1JMR4akpx6mMXBGAEKyatkxPR49OFNkWQ9uSeTusTM7k089u
         KzBOpYgAKzP6o49R26W5ccoYQnrW4C0nqUTGEHsoYMwCA9ED7mOuaExMnuX8McXWqz1a
         IW+vtLF5iZuwxvPIJZPf+f08U2D0795fIrBOA4YPnr4qp7VTkytcqakwBvBZBnfZoAHE
         SxtTqyZyRkIKEdXeUuyTpRvcN87hiyrONKRBqmw0wqHp6eJlT07z4FqID8glKJcC05gQ
         m4GiyJ7vVTK6KNRRKmUfiEkMi/Y5JP3g2SI5zZ68LYn2VzQNHfTd7WpXMm32SS67jVwR
         Yqmw==
X-Forwarded-Encrypted: i=1; AJvYcCUG13gm8IUQGEdkixdqxp67aLxYhGKg9lqNLp13GU8IjCidWzGqD44orkKqOrzhgmIYct8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNKYOspLiWZlNrfKrXytbbPCa4Vr197V2HMUv2llOVKknoqCiu
	h3h32eF2c1t4IhQ6H7gbfTA7E6+/aJsDOtLuP8e0+vxhp4u+F9ef8FQ4D5mYQ+g=
X-Gm-Gg: ASbGncsSV0idEgZZZjL3Y+XFOGR4QRvyX0mz7+D9ds67QrNOvQhVhSOBSgSL+HOTqDG
	AHdZpN42iedggwGZWs6A0F0nj3xCUwyBScsAE1ThK24gn89tql34OnLqB+3O5pJxFdWm9oLMS3i
	5hqyxZugOxDNREKszNfgCiMBEg++oRQHz2UoaV9r+zpbxwbGmhx/G0rYlwRmT+UQfFNTDVehc1F
	ZhaS9QOxs54PsygU+XTNMVIBmGhrg97S/t5YzGN3FQTV/I8EmjyAceKqvpUkJG/0yqD9VFHLC7k
	md00BBxP4vFZncz1e/CJ5FP10yyCWI+gnbP7kKh7kjsGPgU6bMAjvsulqGuYCFQhTTXzXsRlNCm
	dDX4hhBkWmjbleSiwQ6c=
X-Google-Smtp-Source: AGHT+IH0XSNDzdAllhDd7qyOz0D5nItYuKr/ugMkLxptVro68gJqgXVXVwkqEYkZomhnl6ZBZh9Tiw==
X-Received: by 2002:a05:6000:178a:b0:38f:210b:693f with SMTP id ffacd0b85a97d-39132de1c59mr4682001f8f.52.1741475481571;
        Sat, 08 Mar 2025 15:11:21 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01d81csm10221905f8f.58.2025.03.08.15.11.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:11:21 -0800 (PST)
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
Subject: [PATCH v2 21/21] hw/vfio/platform: Compile once
Date: Sun,  9 Mar 2025 00:09:17 +0100
Message-ID: <20250308230917.18907-22-philmd@linaro.org>
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

Since the file doesn't use any target-specific knowledge anymore,
move it to system_ss[] to build it once.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 3119c841ed9..2bcbd052950 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -4,7 +4,6 @@ vfio_ss.add(files(
   'container.c',
 ))
 vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
 
@@ -27,6 +26,7 @@ system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
 ))
 system_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
 system_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
+system_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
 system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
   'pci.c',
-- 
2.47.1


