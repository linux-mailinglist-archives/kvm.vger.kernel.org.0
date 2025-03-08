Return-Path: <kvm+bounces-40504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 023ABA57FAB
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2DA83ABA93
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFAA20C468;
	Sat,  8 Mar 2025 23:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JMLX5BpL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0361B5ED1
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475388; cv=none; b=DHj6R8pnjEXr5w/rFZVEHpd5VirZLJNUhuRneIvPFUf5F+EMnSXzX6IE7scP9iPgrfN9oGHS6wkjLN7SCKuEcBkP+WXGQ7PkX3wgk2UR9/iyNf5x9fZy3gd8mSgh9APe6fGMgOHkGLUjjuQwdxV/tLHdMJGhx4fmFBkFaIdW6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475388; c=relaxed/simple;
	bh=7JifOsK56KLXEupAFHYKaU8TlwNPNllK8RLo4I69V2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXjVLOHpr1YP0pp1SIh20hQZwqF5xeXcWlnGaVB70sIlEeQXk2zx0NClMWTxXw/6oeQWt3VFGSP94oosqgHWSBcZb02HyZTdkLeKXUUJA/1K+NDpmSJcQpDCENGZsTdY2VqW9hg9nSs4eAWEV7GFUxwwIiToIgehYNabBuCAWVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JMLX5BpL; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3913fdd0120so217172f8f.0
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475385; x=1742080185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FKsUbwnAskeU+PqgxhKuYVFxrph8Le8+j4owi767as=;
        b=JMLX5BpL4wrq1LDd80qiFwg1hXdIKnYjskk1ez5qwHeO34LXr3bw4gKrMHu9p7A1an
         pTG9HmnyrB9o9jec2ku7N41MJ8p00o/BS332Tru914SHnF3Qdioi2iNBz9R1dn6g9D4d
         5d2wpG9diQs2ZVxNogCFk9mg9TVcVBMm+JrrY8nViEwwMTCAjfel/E8rzJqzp+iDNJP1
         hh3aE7w8VXixXwelfkh08YJWMI6XyNS6ByBs/8h7iYEPJhs1F0kzE86g4zNgBy/or1LO
         MNdKKcBZ7NY5EJgng8Hr8j7dDZYjHBBnlF8ae3JHN6pcedHt9sJkl2W3h93D9ahVwUtX
         rM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475385; x=1742080185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+FKsUbwnAskeU+PqgxhKuYVFxrph8Le8+j4owi767as=;
        b=MPUgIgHd6TMoyXyTVkm3sCixvxnLWu+dNd+vL03ZLCPM2c0ASrXga3XNbZJxalvEco
         QMb/OZ1/vHeV2mB6pAPi9VeH9tLDaXzyOw/QitshBlytZv5OQyztmjQzzi9cp0M1Ybf9
         ilbqADRG9xhO35bMTrDULqCwARY2yDgxKYHVLqDgoL2rpMWk+s02/wig8TQEgedjCTLM
         QorFAWhKkBu8repA1my072nHwEZAFoybQlNtT0kJoD9Wtdfj+8LjaVVczLXk1dpmI+ti
         GFqUy8q7QPVJ/XpH4fbdsv6MqcOYbKHvOEj7AcElfsdG6OO3EfxuwyIteP18EQOFkJ/p
         oE+A==
X-Forwarded-Encrypted: i=1; AJvYcCX6AUfEUxQIszmtuXmDFtVp4R/l9T+DiVj114x5YMpChVsKoYeOJuHm+ne32f2drbK/G0w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvw42cbBN47BMxzErDKGtuIO9aUDK/7IHOkgDvJvHPm1qgyOJB
	Itqj7KFgpYX0LztiRg6B5AmQAZshiSV19955th3F51WBbvMUXXcxQplawI+b3sE=
X-Gm-Gg: ASbGncu2tukWXlSuclx97h5ZAh/QUye3t0tO5rfeLJPDmkHBL0MUNg8juJBpEWKRDS8
	68Vp1Z5jdpMHI2yNWj/G/G4lRzg7HvOxMcLtG1UAUUPiv927Om7UE8+0jyDfPkXhdO5FXGqwzJI
	lrZsq6AJLdGfme2KdsxvkjlOZvitvJ2Wlmao1WkqgoxKbwttzMJDtEGwOUs+CcIhN68zstDhDBx
	izp4lQy7YtFgMBRIijAJHdwdI1x6ogCX1YHPGhekOrZZl5hsyFWQq6osY7l/5IuHL0zciDV8DH9
	vxzNhAvwLL7wwNWV66EAEi1VS3gtOpASoFliDstyNfdspuHK5zjkf9ReVcpg1pJaDi+WlWp4KtU
	fevyL1uyirRUEW+9BUT4=
X-Google-Smtp-Source: AGHT+IHZofeaDr/4fSpqwbHx3ixE1QtBXdjQPdOMSMcK4b64SZHfONsqYlwQPdKO1yfi+jQf0ZSJlA==
X-Received: by 2002:a05:6000:144d:b0:391:2e58:f085 with SMTP id ffacd0b85a97d-39132dab192mr5125015f8f.54.1741475385293;
        Sat, 08 Mar 2025 15:09:45 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfde7sm10273156f8f.32.2025.03.08.15.09.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:09:44 -0800 (PST)
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
Subject: [PATCH v2 04/21] hw/vfio: Compile more objects once
Date: Sun,  9 Mar 2025 00:09:00 +0100
Message-ID: <20250308230917.18907-5-philmd@linaro.org>
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

These files depend on the VFIO symbol in their Kconfig
definition. They don't rely on target specific definitions,
move them to system_ss[] to build them once.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 hw/vfio/meson.build | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 8e376cfcbf8..784eae4b559 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -14,13 +14,13 @@ vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
 ))
 vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
-vfio_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
 vfio_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
 
 specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
 
+system_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
+system_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
 system_ss.add(when: 'CONFIG_VFIO', if_true: files(
   'helpers.c',
   'container-base.c',
-- 
2.47.1


