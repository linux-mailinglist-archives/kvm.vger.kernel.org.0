Return-Path: <kvm+bounces-40514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35408A57FB6
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E877188DF82
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503CB20C468;
	Sat,  8 Mar 2025 23:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fpxWITAR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92E01F9F5C
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475446; cv=none; b=cOrEYkzOB60b4u58/u+65UvQIrqpxJu7DeDpBnw6gdeREMiu3uI6TK9M2fn+BWbrZJG5r4NpEQjydWrKscpDVLv2Bz6BKS8xs+7N0uV148FHkkhXlWku2e96w0ngUIa9FdON4vtgvbt8wM1sqwQzSeelpdqFxMMKuUqiN+qa4eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475446; c=relaxed/simple;
	bh=aqPEb4yOPrVtNlr0AJyyI8wIcJ0q7eTX0wEHsEYITYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NGFYffr77f6sMg/8pV115JgDftAOSE/7K17x6tGm5f24T78C1m+vyvDMJJzQ5UDjJoQCFSdjblMQ0AGP4oiVnSXASbGK0zso6WzQL4UCmyBWS/634nrTbANCET6Hdc8cN6WlLzK37MnnFm88k7mZzJCiw9tEBim4rVsB6kqqc2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fpxWITAR; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso1297945e9.3
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475442; x=1742080242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e994k6DJ1GVQfS1v420FHs4KoJEVg7ohUIOs13xGxIQ=;
        b=fpxWITARpU/PV1If7xs2Q3qT2woVj6gqDAdJYu6gqA68szLzbhGCEtBW4D7g0dRZMK
         Vyrl7W2pror3t7oGJMonmNWdepCxsG9QdDYgl9Aoz5W0m8Mk/kg1NyYinS7Z3wGlKXBr
         d3Se3C6HQp+PF9IWf6aZby06WbwDs13x1rznWluqhe2XLDysSU6NSRgIEXvxj/69sy6g
         ajjniNjt3tzZ2i9wKj2+l4bME6WX7UXhgst0JwqWyaaP1CTaRVjS+0gCK2p+VPjjfJUE
         QJr/edPbVvaeI/az5f7XJ7ORVPcZPLC2UTDXWF5G7sgTR/HMNjmbY5Zcj6KleiGIbbZp
         fKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475442; x=1742080242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e994k6DJ1GVQfS1v420FHs4KoJEVg7ohUIOs13xGxIQ=;
        b=wBAOIz70Ssmuo6GlKqzI2hvbRW8gWZNk4FL9VPR3Xa3QfHgWv6w9EZK6fSPuD93wRf
         Syo4rwIfoT9Jj0HTaz1NdQMWhthc1JlzmsDAjPOFF7yXafH5Bo6tbfuCVHdgpVbPreR4
         mC+uoFrye/LizUOTgpKr0S+Hytmilq1TOMFfiW6oiv/uES2gTNijrw9ZYkeCTQUAAvZ8
         RCrc/viRy/LHBKSy3Um+p/PzP9FO5ZXxbuCNHbiWZhwg+IJ6euBRaE3ccwkCi2VuW/FO
         2R3NqtsxNibI5ezXxF0bfEPsJ1rBRL33JrGUbYjNTs8YBPh6La3vHgkv3Bh945iC0ccF
         XoJg==
X-Forwarded-Encrypted: i=1; AJvYcCVqKOuKjFoqZDBnLMMke3ecuvjruZ0806jTmk9OPcI3cUJtd3j+oqECL8mExgqG/TlV7xo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX4K/qQ/2giVKcLXtBtHHgD/7XfYpTVtz1sv2t33wRgiRIeSGm
	52JVDnTa05rk89GkkrDWui2INY8rrYxfyiPDlqp50JXWiWk3C1KOTZ/UnTEeYps=
X-Gm-Gg: ASbGnctzeeuFjc6Wm2zOBQycYpwuZdxIKiW9KKGd2+NL+bP9Aaw4utavVkFC4RgZbdJ
	X7xFM340XTi999Lz4pgOeQw7oSJwn96ST2jem7Hn7o+nOFGlRGvPlmk65j+mDEYngNnWbqQWqeX
	xXj87vaW+7fbqnuLnY5rjwg4v970OEwsOFAOFfcgCkeYICMGlGdHnFUKyXWAFMnxZvsW5HmfHU/
	Vs1pzRsl7kRzw56AfbjLHgNKMHAePz5E05jDmLL3R6binCAxSc+ke91w4d1hDD8c5Ze2TBcS19W
	iyCH1leow4BY+moDo5pjc431CpMDEe9Db7TUG3vYbOlKpQuJPgtBRsAdd3VozIVvQxt8ZfL4NAn
	ON9tfcOXAfEegJXQf1bI=
X-Google-Smtp-Source: AGHT+IGanFAG++lqDWp4faa7iGXFNwWsx6KoPF+8GUYwA8SvvtEs71rNKQ7140I7e3KcmDtaGGxtiw==
X-Received: by 2002:a5d:64c3:0:b0:391:2932:e67b with SMTP id ffacd0b85a97d-39132dacfdbmr7249820f8f.35.1741475442093;
        Sat, 08 Mar 2025 15:10:42 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cec28e1c4sm12949955e9.1.2025.03.08.15.10.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:41 -0800 (PST)
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
Subject: [PATCH v2 14/21] system/iommufd: Introduce iommufd_builtin() helper
Date: Sun,  9 Mar 2025 00:09:10 +0100
Message-ID: <20250308230917.18907-15-philmd@linaro.org>
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

iommufd_builtin() can be used to check at runtime whether
the IOMMUFD feature is built in a qemu-system binary.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/devel/vfio-iommufd.rst | 2 +-
 include/system/iommufd.h    | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/docs/devel/vfio-iommufd.rst b/docs/devel/vfio-iommufd.rst
index 3d1c11f175e..08882094eee 100644
--- a/docs/devel/vfio-iommufd.rst
+++ b/docs/devel/vfio-iommufd.rst
@@ -88,7 +88,7 @@ Step 2: configure QEMU
 ----------------------
 
 Interactions with the ``/dev/iommu`` are abstracted by a new iommufd
-object (compiled in with the ``CONFIG_IOMMUFD`` option).
+object (which availability can be checked at runtime using ``iommufd_builtin()``).
 
 Any QEMU device (e.g. VFIO device) wishing to use ``/dev/iommu`` must
 be linked with an iommufd object. It gets a new optional property
diff --git a/include/system/iommufd.h b/include/system/iommufd.h
index cbab75bfbf6..3fedf8cfb63 100644
--- a/include/system/iommufd.h
+++ b/include/system/iommufd.h
@@ -63,4 +63,10 @@ bool iommufd_backend_get_dirty_bitmap(IOMMUFDBackend *be, uint32_t hwpt_id,
                                       Error **errp);
 
 #define TYPE_HOST_IOMMU_DEVICE_IOMMUFD TYPE_HOST_IOMMU_DEVICE "-iommufd"
+
+static inline bool iommufd_builtin(void)
+{
+    return type_is_registered(TYPE_IOMMUFD_BACKEND);
+}
+
 #endif
-- 
2.47.1


