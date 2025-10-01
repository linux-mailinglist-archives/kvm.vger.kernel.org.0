Return-Path: <kvm+bounces-59347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED96BB1678
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC3F31942E78
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDD325C70D;
	Wed,  1 Oct 2025 17:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gpYLIhnq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F7125E44D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341316; cv=none; b=GGrLtVOKshNrj+Kb98mu9uBbJcTx9IRCKjtep2ULvAPcp4x844iUwAV8y89wpKeggchBCC40mFW/Z1aRVaxsDDqT8ceqy4b6OfmvUpguTaq1X1dUCsMSE7Uexg6x8Lnjx16x7f1VcydheMXV4aVRvO6bscHaS9oOcMaq23KR3xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341316; c=relaxed/simple;
	bh=5Etq/hqEXc1Wz7g++5C2lhAdpxf+57CgejGE7WRSaGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTL0I14p0X8efKwb+4muv8ep+j4ZCLoyhvbC73n1jU9irH/w596GLf3s1cEF+Y+dab/C/kYgFzvCH4M8W/a65XQJJ7emFnAiYiax+ko3sxoevoHrB5R0B5oJ2FgWw0O5jbUgd/Z5o/N8nFXfD60qDk0EUUY3B12ksr4uoWSK3pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gpYLIhnq; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so44163f8f.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341313; x=1759946113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9ekZYHpJDRZOlVJcikM1vyUhcFtsxbY7lhISL3cLWE=;
        b=gpYLIhnq2rgIny4K8q51QltjgCb2B1B7YCuMHAWUlQAXFmcVyt2FH+91qEp8zyjNKN
         Mnf3Vmxc3g4gkOzWlEgHgEHTXiOGLgbxc4r1x6lw9fDjOfcfxq2zhk3gLgRfMC344TUx
         zzPSf/0l59EAuRkz+W6+3E893Z1nrN/B2EN4B/LFXS0xYmV0YyXuT/UJJp846cheGeZD
         kw/ni0/+MnVgAe5nbHOz8mBi4443cQ+7aN6uqNyQO/w+3CfbpmIk1NbgipVP86icNTjc
         MXvHoLKMnDw70nqZHGQ17hQC/BRVMlWhfURcrdXtkxqsPZgRYeItz1aIfhNgPBcVLMLM
         GrzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341313; x=1759946113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n9ekZYHpJDRZOlVJcikM1vyUhcFtsxbY7lhISL3cLWE=;
        b=hWu5Vh1aiU494w+oCgGTnTBRX8hIE+RlFm5wlNIZQr90nggPekaXNb/i4YZhrsdVaT
         bClgkDyXbi9tTrOEuV/wrSKV+BKlUDgGx/gWQltGgTdBpv4oW6KwsLfurmaUpIJOjh7W
         GVeFud3h+mD2LwYFEvBf0aNYaMMTjIB9iXosIWU39k4hSHHNrs5boEcL7i5W6GNVlmma
         U/Qyq1aB2Vl2lLFx6b9lMgWCo4whgY4oEsbAzzLIkdeQDD97i66Qy0aEQWpI/3tT5mZO
         7I2eq1RyVBPQS5uqGYuEB1WMo8YhprWKmW4hHstS3WvCMuVuoSI2Pq4rJmhMIv/vf3i6
         0Gpg==
X-Forwarded-Encrypted: i=1; AJvYcCWNg5cn4s0Qbu3RdTYloNHkALISbQRk0ktFAmuC/NG515x8PH0qtZjCd13eMU2D4Iq679w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZYVMlK0ic4bxg9YKx/7gJ0R8YWrgXRWwlMQ0ZUK29YjH05GRs
	we2F5cPwrbv/WeWMyv8a0DWj2pdgUA3I8tJf5fiESWGz3LqeVJoZ9lcHd95Lrs8a14c=
X-Gm-Gg: ASbGnctsTPd6MGohKTMOGnRdmM2mCz87RPZ+3PVFAk6EwRZfPUkO95GpZ63xRyaMAGr
	doYZAGfVFBl48c6KpeJgaq//90hQdkh78YzTz3U+mQECIcgVbQHfRURzvrhp1xEd2YH1vM+3s7v
	cmX38arPv2AWHH2YcKsQle5OGMUyQ11wiuX+x8+eJyCaaRMQ6pCdICF6PfrEno0ohGLplNdruCz
	cXrMpOplYaF0Z59S4iqGYPJqv8vFyFFoy3zqU9GeQQddDPH0NjDn1UkcbfQQxN1qUeidOb8vfh/
	YtGL+j5GkvKpCUh98WW3D+XZEZr7qZKYXn0bZDgzvSNnyqRkitQKXzw+FhD9ONLBA41olAUoNbl
	/u7l+s9bUlKmbxWnGTpi/YyXFoR2l03DVKaoIuYgjw7SCAniguH5rJlP8wDsxKneQy+4yksUPrd
	nYJ3cVW832Sd05pLIY0Hr4E+atBA==
X-Google-Smtp-Source: AGHT+IHjfz50VbN77vl51yEZuShG9ZWJl90dZfPlk6WYnylKSeRTX299MkK2JbX1c9tALFa9dVMZ4A==
X-Received: by 2002:a05:6000:2204:b0:3e7:ff32:1ab with SMTP id ffacd0b85a97d-42557819209mr2844287f8f.50.1759341312780;
        Wed, 01 Oct 2025 10:55:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e97f0sm97984f8f.27.2025.10.01.10.55.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:12 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	qemu-ppc@nongnu.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Eric Farman <farman@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 04/18] hw/vfio/listener: Include missing 'exec/target_page.h' header
Date: Wed,  1 Oct 2025 19:54:33 +0200
Message-ID: <20251001175448.18933-5-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001175448.18933-1-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The "exec/target_page.h" header is indirectly pulled from
"system/ram_addr.h". Include it explicitly, in order to
avoid unrelated issues when refactoring "system/ram_addr.h":

  hw/vfio/listener.c: In function ‘vfio_ram_discard_register_listener’:
  hw/vfio/listener.c:258:28: error: implicit declaration of function ‘qemu_target_page_size’; did you mean ‘qemu_ram_pagesize’?
    258 |     int target_page_size = qemu_target_page_size();
        |                            ^~~~~~~~~~~~~~~~~~~~~
        |                            qemu_ram_pagesize

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/vfio/listener.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/vfio/listener.c b/hw/vfio/listener.c
index a2c19a3cec1..b5cefc9395c 100644
--- a/hw/vfio/listener.c
+++ b/hw/vfio/listener.c
@@ -25,6 +25,7 @@
 #endif
 #include <linux/vfio.h>
 
+#include "exec/target_page.h"
 #include "hw/vfio/vfio-device.h"
 #include "hw/vfio/pci.h"
 #include "system/address-spaces.h"
-- 
2.51.0


