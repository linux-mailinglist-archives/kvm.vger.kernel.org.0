Return-Path: <kvm+bounces-59246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C92ABAF93A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 068BB1C4521
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA2327FB28;
	Wed,  1 Oct 2025 08:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U2KKr6H8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CAD19DF4F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306916; cv=none; b=oRJ9IpDlgfvh2jzdP65jaS5B5x8jC7SfEdqtkHXAUOf33JpZP1N7sFB5OuzC9curoMdboDlUdRjPSOO6KBo3YXGRAoQditdONAub474ymyKTthoBSAs4p8LxWPkfrqStm4SfVb7nPLzMH1NKSWJBYp6iFkZP9n51Gt718kvDPQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306916; c=relaxed/simple;
	bh=HnQYXTgFmEF5oObN6t4uh+LULyZHSbiLo8pUW0acYAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oisvh/caRxIRFg1kuitK2zMI46CzmZCC1xdwZdYyn4pwARtSU99cbOe9ilRhxqIqCIeg46qzE2fDc7kDvF12B8VgK+DKnIU87LYYkmTz1PuAyLkkoujBvYr+7s1D1eOuMY2CMajHBF/yqqPF7F7XisWHHo8/kk/7rdQHdhpjFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U2KKr6H8; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e33b260b9so23374185e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306911; x=1759911711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFKaDNxEC0b5kIZOWsLuJtJEztvf4NT+IrhHLczSREU=;
        b=U2KKr6H8fVe4Omm9VTvyAc3etUgPPWaRglcLF57+KPh+qZsBH5kC8XCGdJEH+196V0
         5ttfvQcFxrtS6dYSrUZu6JGW4L27t90iFo0EevPQkh7PlLDJ2NK7KVoEYfTytwbah/lv
         3r3xN7+4qLL0ZYkMcPN1b13TkIMnJw6OzaA34Tha+2wSeIVUAt1vPlPI9FTW04Br82Uk
         irA8B+Bi5ubbqSEtFv3mYm+C97DIj+IFaC5TLUFU0TpmrGyBOxxs53O/OgX5HrEP2rL9
         074shqP4oCVC061ysiw7HirKz8iBZOJiF5EEvNSqfj6fWK0+jO7V4I2mtq1wTDMr6rJc
         SrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306911; x=1759911711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eFKaDNxEC0b5kIZOWsLuJtJEztvf4NT+IrhHLczSREU=;
        b=U7y+d0QVv8FlrczPEswL9y5JT871jztwflkmizTkB9/2u2jZ/kyfxfADQtfdPC6UB7
         7zuHR9ygdaPCEcvlYTUW6oZix9kTjhhQqgVS7Y5Fq4JBVgI3VX38k4Ld1BYnBHO+X3rw
         bGNtDHOgWlvE86BmFWsqzKXT9dVmZmdulpGUeQd4ocHUyaUJwNwbadWNeuQZp8ci4I5T
         NIkBWlc25Wbhne/xwFLfA3ugRcZhH6HZibmMfZ65Zzb8uXqCA3T4V8AapF/hZ4hzB/on
         w4hQdlOFM/Dn3ZazvQgViHAGzRLYddJXQiZTJ9x4LL/s16C8681tOeQdLQ0S07BLRd5y
         EH8g==
X-Forwarded-Encrypted: i=1; AJvYcCVrkOTL5PbLHXFy/s+HyoswerlvqpIVUz/9TAh3993V1zJdmMGDDAW3FXprGk7iCWO34VQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeWuQAsIgR2Y1Zhz9k1KOaMPfSBAt+QcoCZlI+IEJcWyHRyNIU
	WpyFw6opgvPjyxqJoBEP7ClH7DdZ7HJ9U9NVcmjrKtcgmbsF1595v5R6E0Rx8y3NF9w=
X-Gm-Gg: ASbGnctINMgmvZD9ViD/JIqEEwhNhU7CkE2ueBDW3e8or84lzZOlw+AsYitD2iz51pq
	C1ki5for0/uBsgllMViFSCrwQgHJPPcG+SvoM9TG0vr5a85fwkF2+T33WvZM0TGYRFMgR/6qt9C
	/53n1MswZSx4aVUSJKAiv9e9xf6XIAEBfj3UkRx8d6X6n3crM+UCLCm3zAiAIggQtUQN+1Plbt2
	lAwOEHNh0B749wMoh/XxhBPqdYgqO+5R0XnjYaAbdndZ69HaIMejCQiM9FTGBtUVtZhhHkhjDwt
	Yb3zkyvYqcU/VPmV3Z54lgMgmmy7QDAjL52tekcmCeqci7/E0zr8OgSl71rqSUTla6IKFvBceU7
	+eHP05q+zxpyQSmYTYMPhhHPOh4UsmRW9ZjZt2ZVRrjWOZrV7CPK1SFduZSSAuzbe4TwR9/Kqxm
	8cx0Uda4ITxoSoMFlfr0LP
X-Google-Smtp-Source: AGHT+IHvU9S2+68kk4bIY6XJSt3ALbLJOqHjRhsYuYgNMt/px6MtVCMOZuGrkrVlzP+KGctR6OsILg==
X-Received: by 2002:a05:600d:41d0:b0:46e:394b:4991 with SMTP id 5b1f17b1804b1-46e6127a4f2mr19980725e9.11.1759306911312;
        Wed, 01 Oct 2025 01:21:51 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619c3a58sm27485035e9.6.2025.10.01.01.21.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:21:50 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 04/25] hw/vfio/listener: Include missing 'exec/target_page.h' header
Date: Wed,  1 Oct 2025 10:21:04 +0200
Message-ID: <20251001082127.65741-5-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001082127.65741-1-philmd@linaro.org>
References: <20251001082127.65741-1-philmd@linaro.org>
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


