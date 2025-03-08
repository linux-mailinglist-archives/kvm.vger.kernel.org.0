Return-Path: <kvm+bounces-40510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40455A57FB1
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24A803ABD40
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666A81F9F5C;
	Sat,  8 Mar 2025 23:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JKO2YAF4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1AE1B425C
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475423; cv=none; b=J4DdXvveuXEdE6tF6LOtWecmdE9R7B8wbMDrFsVb7PyeouzDRXpTrBK71h1tyZ5cH//QY0S8cg6NJlZp7dVWpDSMz74ZqEqH8nEv6pnAr5W/enrUwb2/z87ilPciz39u4moaQhAE6gYX70wn7zMtL8F65nFFyY1lI6D6HyjskwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475423; c=relaxed/simple;
	bh=pSU027guXWV44OJWUo+ZHPch6oXSIyJRktU1hf+rwPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XsGGy9Ze4odfPJ6/6s9fXXTETYI0Qkmp3ITUIOJ0DET+4RXB5NAL/SGSyRdmv4a4iRubA6bgNtMYiKjHJ0gvVPn4C1ebVcUOtEsnqAvhkgKwcITRsJsq0XV+PITlKHiUeDMd7KAccplQvSjIVyfbX3qoaZ2XewXYKf7AEJ+Kqgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JKO2YAF4; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3912c09bea5so2328142f8f.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475420; x=1742080220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJXNBj0mVkk7ow8GecZF5txwITRLIlUvrzgwdEPrsZI=;
        b=JKO2YAF4toC2CcOACIFBcsDrU+VQJQ72JaFYRujjY77OXv1yKg3MiEVGAnwpdbTrqN
         qyq9RT3qi49+27epD2bqSwEMfYygDB3aIFLXHhvlFOiQw3KICoLB6HOe8dVkRRMdCU2f
         FtDXMAdFahJutAQeciFZWAFQdKuVbhwX7DbWr/Urm2OwsJa83Wu2J3GXo5O486zDX7hN
         Jl6ieakQOFmHz6ekoKbybhJzOhICY3LI7PiCBB71Ed44GVYpZjzlnnfn6dDOAUZiClq0
         w7eyOMgNpLaGjTah8sRrd6ulmi6MZjeD87Ukx3PVZw/TQI2hzVKWNJEf7tmcNQGc4car
         lXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475420; x=1742080220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJXNBj0mVkk7ow8GecZF5txwITRLIlUvrzgwdEPrsZI=;
        b=Du0oe4Xm8+2YHPcIAYiA2isHyHztS5QV33oGAbvSM7o/baGNY1ZeZ+cNo1mUMZb1uH
         eaWzLq5temgq31ZJH91G9gOFwkfOK6JufrnNUot6bvcK1mQmjEvdte3ZMnn1QZn5GAdH
         GHOHOaDxrT7zP4UnFLr7vGdxUSqpyHJ6qpMYqC/VR7HzaJBzK1pO2CZojDCATWAvFJB0
         9SSLkYJVh6E41G/t1rb2UsEy2dFuhRUxc60H0wj7FcADmMZmWCoD3NeeaV7LQUZ00u64
         PVk/mOA9fKvDXAwnj3x8kpN/ERTUEqkdZMJ6O7sujas0nIrM5ZSKHXIPIf9zi8Mnn24P
         sIqA==
X-Forwarded-Encrypted: i=1; AJvYcCWggkx9XRUs+vLOjfaziTTLfg28RYCg7EeoPYSK5cCQVThX6PsAUGDrGnOleUf7oBsmKQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLnx2TMDEcFqP/ENWxIpfEu8pBdRPiQoIXXKqUF/QOvQ0UMYkI
	4tjHgbcQeMhFZjF+0cFL0r7UWELM370cjmpGawkG2D/7i1yCw0ExPKnp9UFCuWA=
X-Gm-Gg: ASbGncuoebW6elEJEZLqqtLlLosQB8HbcNreJTFvxdwDBa6udlmUYAMbCEFjf61xjSg
	SVgziMNlCGTjXmV5nsp1LKvNKq4HLnYgTP6KawbfifCTslwgDn85RfDfK2+nkBuqE9B8qTjPMVs
	7NFqCP7gS0or6NSIkgg/FxzakgPU/Y3OkaAgr6qtI+rtZt7bDg6ZbrH8EaXQDu1o5rI6thY+4sV
	DgDo5vYiv0DcxIfXtjng8bMlyrF4k8T2R5R1FwjwncvFWBRi/A7AxUIaWXaDZgQIVXlMxnSuyPR
	Oqk3bUk0U7eYutZmoA/rH0BL6U0bueRkvxSPC/7xPhPNKr+M5F6Fwwh5szl6dSjapWoH0KYOfku
	Xz34+vhk/s2LDww5iPYuIXJnUVG2zaQ==
X-Google-Smtp-Source: AGHT+IHQgGDKYnpS8cvxChOVuSZsAjnTKah2viEVS9oNKXufBZ9Ckl/6tU+y5xvoKE6/Q1ES0ORdxg==
X-Received: by 2002:a05:6000:1545:b0:391:2ba9:4c51 with SMTP id ffacd0b85a97d-39132d98bb8mr5365371f8f.44.1741475420168;
        Sat, 08 Mar 2025 15:10:20 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e4065sm10260184f8f.62.2025.03.08.15.10.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:19 -0800 (PST)
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
Subject: [PATCH v2 10/21] qom: Introduce type_is_registered()
Date: Sun,  9 Mar 2025 00:09:06 +0100
Message-ID: <20250308230917.18907-11-philmd@linaro.org>
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

In order to be able to check whether a QOM type has been
registered, introduce the type_is_registered() helper.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qom/object.h | 8 ++++++++
 qom/object.c         | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/include/qom/object.h b/include/qom/object.h
index 9192265db76..5b5333017e0 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -898,6 +898,14 @@ Type type_register_static(const TypeInfo *info);
  */
 void type_register_static_array(const TypeInfo *infos, int nr_infos);
 
+/**
+ * type_is_registered:
+ * @typename: The @typename to check.
+ *
+ * Returns: %true if @typename has been registered, %false otherwise.
+ */
+bool type_is_registered(const char *typename);
+
 /**
  * DEFINE_TYPES:
  * @type_array: The array containing #TypeInfo structures to register
diff --git a/qom/object.c b/qom/object.c
index 01618d06bd8..be442980049 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -100,6 +100,11 @@ static TypeImpl *type_table_lookup(const char *name)
     return g_hash_table_lookup(type_table_get(), name);
 }
 
+bool type_is_registered(const char *typename)
+{
+    return !!type_table_lookup(typename);
+}
+
 static TypeImpl *type_new(const TypeInfo *info)
 {
     TypeImpl *ti = g_malloc0(sizeof(*ti));
-- 
2.47.1


