Return-Path: <kvm+bounces-59346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEA88BB1675
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 990BE7A9DB6
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81F3279334;
	Wed,  1 Oct 2025 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lSMTyaKD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BF25E44D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341312; cv=none; b=r/+sCI7rQRH12Bc8h5ByFzEPk7mhScVKb1+XHyO9itPZNEkIgKfF/lnDLPjboNkjYxoPuPVU8aYM4CPapMTuNMS4FigpSSXZ0Y3nfpIerRslrrEdm14reJj7x6SO1YHHSBN1Ib3C/dnrT4TcqLABKazsCLh5M2W3LPcJZsGMONc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341312; c=relaxed/simple;
	bh=zlwsep+lhKiWLRhzU71wBne+CynZjNLo+LAWGq26OT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3wK07N9z0fAU69BN+bzd3HHH4D7xfqQSjJT1yJMc8L4IEEFaxDOpSyMtMnQ6oHfScjmra3gpuYgiqzK78CAbe6TwIxoWufs7eajTyv8WOO9ygPEmpgB1LsemzAEg7JCDcdVw6DkP6W/dqzC7jdaUAL2o2MShUv8dPl+vtzulr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lSMTyaKD; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e4ad36541so1141615e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341307; x=1759946107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBaAfw5JT6Gi3iih06puN0jNUode/oUz6CEGsKdvDCs=;
        b=lSMTyaKDQFTkkPcMEOVWu4eH15J7+i/B+wtxx2/cJw0q0PuG5DBCy0uGq34aHME+cn
         E+UkCU4p4EgkMtOUItXjeajaZ11wGAPRw5SoA1TOs56yWmfqlLd+e7mrMa7EBRF7453S
         zKznsanDWz/Gh3SxwsSf+eJ+ANY9zgqlBVOjISwM4IeP3VS2bokX/+H81Puseirkh+3b
         W7RoOOJGdY/inPaS2Wgrg952dDUU4q95EXeuWCaHvZMwm3zW1vWwYsgZNsvx/u/j6QLu
         BkM+iqiuMqjLM72YIKD62KmklG1a4KNxDblKstaBzltIdQvYUlZ9tfnP4b8JSGPYlrUz
         ofUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341307; x=1759946107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NBaAfw5JT6Gi3iih06puN0jNUode/oUz6CEGsKdvDCs=;
        b=bF1N79wavy2dpZF8P5RKkGT8km8dy/Hqnvl5D7GnB4Lta4qNgt66rEa0VHBLwNAquW
         HT05Q0uUase/Kv4MmRdf6lQIYZlMSRCX6nmTHBlw/RPXeokH7vYf8G6Sl5ClRhnCgIR7
         Mc7mQfJ4IApTw8Rb4zMj/Pt09+3EB0NnDpbbIwkJOnLgjQWSoNOHrtBr3dhrFZ4bV/zC
         dGLVjUYlpVZZzY8mXqldb6IpdSRbp3MgOvOgVdX+LX5kKwr4lbmYRfxqewgkxlgvMNYj
         SwiayXhzaKcaCUIwxoGi5BthXgugxFqf5uYCB0ApbZwdYqNNNpi75PCOvbUOuHRj73pO
         uMDg==
X-Forwarded-Encrypted: i=1; AJvYcCWOGelSUljluwUkItfdtZngFl+OTaH7ttyCA/UAlBSwDdzp3fa2trQmH98uAIxfdI66Hjc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaJXuH42FF+6wyw8228uUNz9VdorpUsRV2iFVZPpMJdlZ9z+/H
	JF4Z3hqpT2CnOKC10LJugSqg1VU7W/B8NrsMH08KBU3xJ53+eYJs614OLNBYlCvok1E=
X-Gm-Gg: ASbGncv2fAYrRHBmgx9Q8R0o8S1XyL1DL6q1k64g88K8US4t7joJcU30JtGJ7fJZx+q
	0UXO0o6q/hKnqk1ot1kVEqtxsRHIff7NRwtjEiGt5fTih/M0U98fi+lWuSv51BiB50M/k0XZLa1
	5wUJs05CELFHaDi61OioJDb9YoJWKz/o1edzyhTvbx2BQsxX8lN0WfrxUwivy/aURtZMmv4aEB6
	N+BdNpm1D0oGXqqJq5aL8TJPXA+OodH3frtKtwR9TKNoVg6uTA+rd6jkilsSD+YSBj9T0fPfelL
	imS33566SAr5HsIf2Ooxwcxf/pgtWzjmJBFN7E04aBxnfZRNNbnZRNsCBOKWxx8fEfUrFTVAu46
	rDVkvAnC7SSUV7vDinp/vqy/j7gTlGn5kOC4eBIPCQO18vGym/ssKXr5+486sRQbgyrwOrR8+mA
	xUQmM6VwwWJmC0cN9h0Q/E8sC1AA==
X-Google-Smtp-Source: AGHT+IEWsWi+Nsho5T807TNBGq094dWdLWwTbwGMWBB4+ICpcy+vDMYvY+ZqTgbYOdjGB4etexOrFQ==
X-Received: by 2002:a05:600c:198b:b0:45b:80ff:58f7 with SMTP id 5b1f17b1804b1-46e612e57c3mr39612865e9.36.1759341307382;
        Wed, 01 Oct 2025 10:55:07 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8abf38sm130150f8f.20.2025.10.01.10.55.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:06 -0700 (PDT)
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
Subject: [PATCH v2 03/18] hw/s390x/s390-stattrib: Include missing 'exec/target_page.h' header
Date: Wed,  1 Oct 2025 19:54:32 +0200
Message-ID: <20251001175448.18933-4-philmd@linaro.org>
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

  hw/s390x/s390-stattrib-kvm.c: In function ‘kvm_s390_stattrib_set_stattr’:
  hw/s390x/s390-stattrib-kvm.c:89:57: error: ‘TARGET_PAGE_SIZE’ undeclared (first use in this function); did you mean ‘TARGET_PAGE_BITS’?
     89 |     unsigned long max = s390_get_memory_limit(s390ms) / TARGET_PAGE_SIZE;
        |                                                         ^~~~~~~~~~~~~~~~
        |                                                         TARGET_PAGE_BITS

Since "system/ram_addr.h" is actually not needed, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/s390x/s390-stattrib-kvm.c | 2 +-
 hw/s390x/s390-stattrib.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/s390x/s390-stattrib-kvm.c b/hw/s390x/s390-stattrib-kvm.c
index e1fee361dc3..73df1f600b9 100644
--- a/hw/s390x/s390-stattrib-kvm.c
+++ b/hw/s390x/s390-stattrib-kvm.c
@@ -10,13 +10,13 @@
  */
 
 #include "qemu/osdep.h"
+#include "exec/target_page.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "migration/qemu-file.h"
 #include "hw/s390x/storage-attributes.h"
 #include "qemu/error-report.h"
 #include "system/kvm.h"
 #include "system/memory_mapping.h"
-#include "system/ram_addr.h"
 #include "kvm/kvm_s390x.h"
 #include "qapi/error.h"
 
diff --git a/hw/s390x/s390-stattrib.c b/hw/s390x/s390-stattrib.c
index 13a678a8037..aa185372914 100644
--- a/hw/s390x/s390-stattrib.c
+++ b/hw/s390x/s390-stattrib.c
@@ -11,12 +11,12 @@
 
 #include "qemu/osdep.h"
 #include "qemu/units.h"
+#include "exec/target_page.h"
 #include "migration/qemu-file.h"
 #include "migration/register.h"
 #include "hw/qdev-properties.h"
 #include "hw/s390x/storage-attributes.h"
 #include "qemu/error-report.h"
-#include "system/ram_addr.h"
 #include "qapi/error.h"
 #include "qobject/qdict.h"
 #include "cpu.h"
-- 
2.51.0


