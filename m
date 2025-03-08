Return-Path: <kvm+bounces-40516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DD1A57FB8
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34AA4188E8C3
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721A620FA9B;
	Sat,  8 Mar 2025 23:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NfOSC7P5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE89F1B5ED1
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475457; cv=none; b=LKzdjav/pUQSEV547qF8U7mDJzDjdpqtU6V9H9MNDe4YEusSZN/nmto0yk+AMfhjuhLTyXWlSCGsROx1G7K2o2EMrnFXlHjQTaqVjhYJ2NyfjdU/XVmK1NucyjCwHZVCg9UUJlBeOYxv3EV2t2cx0ntbNfxhOXmxCutggsLbH48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475457; c=relaxed/simple;
	bh=yQSGyZpIkXMWlGV4oPCqW/y03LTQBYwnsYVY3D2IjqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MI+e55AIaDA/zITs5Mw40PPwiaxP1gF1VyeqJV+f0fpS9DYuX3p4dE8uQ1r8lgLtqGzGKSMDZIqnQgmKXE2Lh/ygIUTyqfNHTlEIuc9lSPICXiObBh4sb7HhRveNH1SfQe2Ydw8QaRWrUuUfeJCZ3H0h1COqhg+0cqukeEe0YEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NfOSC7P5; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43bcbdf79cdso18044915e9.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475454; x=1742080254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9I5vCsA50Nsuo6JWWElDKwuAuqANWG3nhtm6Mug0ADk=;
        b=NfOSC7P5HggymY6pnNEXJK3vMFEnx1r2dmJnkXSDbVt+bXHLsdyti+7ldaTF1QoQuH
         IlDFW3wJfTLvsM4Xfccx/YrGA58VWNquaKH7xzK9+ErNmkxk5QLoaNJtXGjPdL9zhabS
         HWd4FHHGPYEEO64EgbXm0LDvSfKJgEdlgW4u3785SwJbpaR83US8F+nNWCYBgT8/fp3n
         D3Y7XbiPDDGdsdmZzZeqR3BPhhtGckXam30wdiOe7pNwX1mBsTdGWWVuv/oAcByoqJaY
         NSfwt6i22LFoyQRyjl36vj42PyhC1yL9AyaojJRQXqUTAk0A3MbwdgBDXlKiQ9t7w1iF
         qBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475454; x=1742080254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9I5vCsA50Nsuo6JWWElDKwuAuqANWG3nhtm6Mug0ADk=;
        b=HUgFNNGCAvpL94fwljGEluKIt8euCpk2UxRADRfj3tYPcwWAfe9gJQeDQ1BLcenTGZ
         gHaH/PamJZmbRBqwU1S9AJ+4ErZYN0h+UlkdGCCV5zvDcK14zRqmpyowYcz4OMyyydS/
         Ru3rS4yFvXK87LmQ5MvobXL50PPFYnNPBdCRIfXZKji+9AePRycO8qD2z9Id/UpxPq/I
         zJ476lyAe4VXw0J8eCR4gSCv8SbEO368vOEKHwg3R9BUMYn5k45xZNiiBYfTRJ0lPEfp
         833+GQFApHMUx4BP6yQkeLm/wiJ/bABfcBvYA0g9K2oBQs4LechEKzehC00IuacDZq9H
         vGZw==
X-Forwarded-Encrypted: i=1; AJvYcCVgNM0x+V5Vj1axNRtHIzZ9w7Xxofuv0U7WPQqIlLBPjm1pfLxbvrKn2ht/weX3/SV0bbo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDsD1nW78SHnvJqfG82Xk4Wf0MSrn5mDokqYmAA4E2Tist+nF/
	5+LyderlY6mSjdIl8wOqvnBNZfX3yBGTIILiabSDoE7Wdv6w2E9gp+jhvcuVN9w=
X-Gm-Gg: ASbGnctaelyJbBxSlY37ZZcw5wiY/Ns6ttx9pX46Zjdq7nzWplksOk9+sdqPuaz5L3C
	y1HVicwxa0pSo8V5FkNJ18/EOiz+Mb8DEuwcdgFxbOYzafwp3PsM+1m2xlZzE2lXHAygejUmlhB
	m9YUv1usr+dOggqR7F0awEtsSrhhMo7ytujNVOzXzONWRF5eENU08Co7ia1BKU5ZetsICwj7x5Z
	6y8pnFF1DarY4ZumWouXiN7GCLSUvJSzJRgoGPyvPxhZQYDJaZBnHtQr+eRsYSCAF6A/QAJ8jxa
	nDUb8v1yWuI6e5IgSv5LVClGstvmD+EnM9GgERm6dG3UyFMum3vslC/i9VcmexFZVlvhFVIfTvD
	rHpWPCi+UPsiT+eRlVJs=
X-Google-Smtp-Source: AGHT+IHD4U1Jg2eYVlde+YIZ+P/aR73Oxp+dN6sVG7EKlH8IIyBuRl1arvaQ7vamgw7TSdQkmdXYog==
X-Received: by 2002:a05:600c:4e8e:b0:43b:cc3c:60bc with SMTP id 5b1f17b1804b1-43c5a60ed21mr56361295e9.15.1741475454020;
        Sat, 08 Mar 2025 15:10:54 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01d2cdsm10234876f8f.57.2025.03.08.15.10.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:52 -0800 (PST)
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
Subject: [PATCH v2 16/21] hw/vfio/pci: Compile once
Date: Sun,  9 Mar 2025 00:09:12 +0100
Message-ID: <20250308230917.18907-17-philmd@linaro.org>
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

Since the files don't use any target-specific knowledge anymore,
move them to system_ss[] to build them once.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/meson.build | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 21c9cd6d2eb..ff9bd4f2e35 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -4,10 +4,6 @@ vfio_ss.add(files(
   'container.c',
 ))
 vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
-  'pci-quirks.c',
-  'pci.c',
-))
 vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
@@ -33,4 +29,6 @@ system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
 ))
 system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
   'display.c',
+  'pci.c',
+  'pci-quirks.c',
 ))
-- 
2.47.1


