Return-Path: <kvm+bounces-59243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 526F0BAF931
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5177189A9C9
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7511428002B;
	Wed,  1 Oct 2025 08:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NvVj7UbL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA80719DF4F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306898; cv=none; b=e3qYF9zLGqThiC6UzEc3TpMtvYh8n6Fymi+wMlZy5l+eELLk0nC0K06j+PgI9ToT6olMEZh6zrLztqwmCBcB20g25i1pKzuTCHAnII+RB4BIYKVAtQjsL05rOZBnbDq291jwhJg2490RDh7md7pHssONvMSwy3fCog2/mNoRAwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306898; c=relaxed/simple;
	bh=IZs5DPaBCsZbUWReFAEwEYcla0rb87Db5uOgZ69XjOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XahOnFPqlXYTHWd9/eHZ5hI9G+oybgAKvPzdKyhK6aqjMaQoCs06Js5N22S2kOD31n/zmW03i05MzLFAPbITpvNE7ezwFQteMDoK6SdhWe2NrQ+smcYo0znwXd20g+7uu87jGBuve37vooCf+JQq2gq33gny4IgQ1PoTxaXFMEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NvVj7UbL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e4f2696bdso47079155e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306895; x=1759911695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FXrBC5DT5H2U+KHBH/fTo7fOpyh9XDm8ZSBZ4mpCC0=;
        b=NvVj7UbLyJPj9/DP2rmbE4oOIIL7ueeuuxV8R+p17dDUYcAtT1n6yYt/cH0jZWaH0A
         v3TYB3RPtbAZb4ZTjvRNiMs9ZEz/dPJD84M3DF+yYN2NTM85J4s7l5APVB8tYIoszu9V
         /1KkXu9iaBii/4CUs1rSSWUZRl0CrsOYiVNpFm/DUBKU2cKDsOsJL6wTw3GwJEfQ6lYz
         cDbgqPaerVrUTMO9v8DdYASR1TxrA5NPCulV0LHlg1IFb3hOSmtL27F54OuhLOGwBIED
         vH1ik0sKCoaKMxz3JxKxg9UkmsjG2pONvz8m9RybQaB1Iq7PucBJSZIkUgEBdXEbbR7o
         qk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306895; x=1759911695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9FXrBC5DT5H2U+KHBH/fTo7fOpyh9XDm8ZSBZ4mpCC0=;
        b=UFxsEUJARcu3oNt3LOPhjV/QXFeNu6wuW629TSJeoiQmWKphJT8h0hjcCU02DqUVt+
         67VfoDeTp7XnKeAenM8+UO2KAiLSxwEMA8Pamh7XMELTRCi26DnaJCVrkhowa0ZhxGUT
         P6dcgpXO5XbBhCdxdovmshK3S3bjom3CBf6Ej77EJAm+G7iod0s6b2SClayWQPcLaMvz
         q1RlG1Ax1BYq6ymTbFhuX5Y+bvyPIh2NeFrLectQEpvJQZYBgLYUv7C142T7fPq/x14I
         87xSML4Y8DQBX9Hbfp/Y28n6cm3gN6ZHWiWWGgdc14Ouly1NzSmQsxMAiSJFLIheZk49
         Ld1g==
X-Forwarded-Encrypted: i=1; AJvYcCV2JICAsrkPhuYPPVnwv3ynJntg8IQ+l/LoS0fjbYoxNVv4lvfGWsP4IFLW2XI3G3UeXpM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5g8erGnr0amLFkpysjQqKlzg2iZewjc2IEJ3DsHs69yMHvzRu
	gv9TW2kD39DkhCcH94zE+vnhG/3lew0Q6GjgOIeF8rG209woXmUKtyAhgdgSiT5eCEQ=
X-Gm-Gg: ASbGncthwd9X1C1IurH1V3beoZQ3SqXry5Tisav+jn43OZMzhvqfOiZoJLexVpJV+rk
	tPeXGVGqco1DjZebpSBtxR5A8XA3DQdS1vcxaJHkgwLWUnp7lVS/wa8keXjaWX/QlFLUGdZaWur
	0VyemYX9dddNLZcGoBquMnZmZyGTDqZBXkivwo6gCM9lltpo/HVjNbSvQ9lbJKO5xfb9im7WCiQ
	jchpFe3XKnfMpvo1tFWALDlqW9hpRnKmVyCVcmIHZ0lwSfIFGOu9JkGnhyhbTftSiOYcYX6nSpK
	lCddkGbzO3HOZcNWDtConW+dvB92jz3oNy4UiMp6wqlQUQrqoQbtUtarXXLcIYUCTnUowfgcOAU
	KEZpwugK5kjorMTAf5Dj46RGvG7lB1g/JyFC/PENZ7Px34+rNB32/wikmWHE7q3D21Hjd7SCPFr
	k/vG3iTPFrTHMTA/xk/KvA
X-Google-Smtp-Source: AGHT+IEVW+a7ZQahLwvXdewpnTcuAcck+Pbu7pXQ3XgPa8cMZnL3kzmIaMWIdBuRBFM46G6yblRD1A==
X-Received: by 2002:a05:600c:698c:b0:46e:4783:1a7a with SMTP id 5b1f17b1804b1-46e61201fb4mr19588005e9.3.1759306895019;
        Wed, 01 Oct 2025 01:21:35 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc72b0aeesm26590514f8f.49.2025.10.01.01.21.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:21:34 -0700 (PDT)
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
Subject: [PATCH 01/25] system/ram_addr: Remove unnecessary 'exec/cpu-common.h' header
Date: Wed,  1 Oct 2025 10:21:01 +0200
Message-ID: <20251001082127.65741-2-philmd@linaro.org>
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

Nothing in "system/ram_addr.h" requires definitions fromi
"exec/cpu-common.h", remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 6b528338efc..f74a0ecee56 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -29,7 +29,6 @@
 #include "qemu/rcu.h"
 
 #include "exec/hwaddr.h"
-#include "exec/cpu-common.h"
 
 extern uint64_t total_dirty_pages;
 
-- 
2.51.0


