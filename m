Return-Path: <kvm+bounces-59244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D23BAF934
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:21:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D1F31C3CE8
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CC427A465;
	Wed,  1 Oct 2025 08:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qWrnpZs1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5B019DF4F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306904; cv=none; b=m/YmUbPNdmtQ82mxUMDoiHKQbhlsc+E5gw9+qXC69DwbnuDCqtIs4iy276Zk7pEqvFTsv1mFSVnuck4s+hA+IOkLqko2yEhautAQes5OeD6jBg1m92OjGLA302Q9vLF1FhfIJJMNMJhloibQrn5uFv6+PDyWk6FhDLgsNazkmSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306904; c=relaxed/simple;
	bh=QSSSLv8vXmvPNvYEi0qrrQGs2PlBS75MLvtPyRp9Db8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qrj0LRAaGrD5mNJ4gbr6ya8UsyWIxTTr+o/V56GY75F+uQhw7VSqgTKmwZYWUne9V/1ebJH1rh3X0v333PMj/ZHts0Sngsr+/dhF7ORobXpgrNDOKPzP2QpI8q+ax/brHlhtiFv/qkHY4n9kLKKedU6/mOuq/itUTnkrxlUx3Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qWrnpZs1; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so5260618f8f.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306900; x=1759911700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+C5CzLMaPwDa1iB060vEOK+Ww+NfWXh/VYhisUdBYCs=;
        b=qWrnpZs1h1SIsgX9XB+06GfZcM0RVrqCXl/uPa28Ya3EYBOhC/pf+dY3v6P6c73iy7
         5ye5kBHa6ydyZj5iVYwtnNcIZ7vx1xcZiSnkieFocpFVlwI4BbbpjJmsTdLRtf1Juqr4
         yhOac1N6CD4m4xWYXp3ScLEv7eDZyNWoHCcv3zXCkjzMUFqOViHMfIkzElPr+TTGDroQ
         Ts8NVyZ+0seunX3xMPQIhpUtFFNUNzt8bj8QnlqvaoxSCBsmaLaCeGVcSAjk9jSbtc7s
         hxNbhZuybLv95z3F/GGyORkk8AoOU1GBoKaGpJpxKQoVg0eG9lpjfBFF/6N5GfblxF/M
         0Spg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306900; x=1759911700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+C5CzLMaPwDa1iB060vEOK+Ww+NfWXh/VYhisUdBYCs=;
        b=f3nMn/mW1smY+zbQfrcNQ4YLTrd4sC/woqEbmVTyMcpsSkLgBnNuU+fuWXR99rUN3e
         H1SsBoxvQio0o0lRaURz5ZFUE2tD9A8KA4SCY7SbCBNUnRLjfaF+ipIGZNvDfcOm2/ae
         zKFLvQYg+oc7fGC/ETKC0d7u3B+aiDJkJgUabCpkj1WYUKSuvJ91hpo6J1431PyusF5c
         xY0ELnk8ZdrNIOXkzdl3KC5rqqxic0NslThb79Ptct4KhvTDJEnUw3R4tdaKidy50OBg
         fHUruzEDu2yObVm1x090rliFnWSfQm1XlNtFO8F21rrBN8WGJWKQcOozO3Le99xJLwJ3
         qorw==
X-Forwarded-Encrypted: i=1; AJvYcCV2TG1TefOpiOWEsnMX8PxMy5pXUpbG9fhzDy9GxvTyarrR8AgU8Mg7ZiXEIQwaAQlRW+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrBxwg79knGtnwSSEHHBqgKCcKYWZddAa3uKmDYvkXoa1WCVvy
	vMKTgb8FilGZ+vouaxQuMvHyXDtC4Xe0sB1fAB+4ednypk4XUAG9lyb8vTVEgLejhJs=
X-Gm-Gg: ASbGncstoVgkhhKvY7hyo7UTLaNSOr3Mtw/lSpLcmh6p/rDKKcwQ8XmDHGeF7djKe3N
	fQhPV/h/AvGPTRjLwG2TVKTChQqeMaBdbzTqA4VkrYlihvkndkA3VaobUNShAy2FCqFmZJe1WTW
	KlNLNAkojXo1PFe+0HZNEqyurEEoEAup5lf2pBFY4exj+DjVp5y1wFEjrjIY03pPGwg/TzFIIr0
	ttXSdiwFepchOPM7J2oySe6LznTplQKii2uVHoOInjJVsbkOJCSX8ncIfeBhnKI35vnuC0H5Dnd
	nB4sR8qqW6OtX6Q5wqq8KuaFNP+nwxawiAHwyWdSjB1Tnr+0KrfS66uorgI8PohFFNt2d5ksdxW
	/2SmObEIS6sHTJNbZggw7sgfw9PqpzSH6MLr+Yws55wkpEjZeiW3gNtXf6os4/KH5/T4GndoeP8
	iYqBYrNGkZkiHonO5i8XyF
X-Google-Smtp-Source: AGHT+IG+BsZmZhn5AVBasoM2tJ9zzxKe+EhfCA1OHPGY/VYR6bdoCD06Y50Qg9jsUtcYDIRS/+ZYRA==
X-Received: by 2002:a5d:64e6:0:b0:3f7:ce62:ce17 with SMTP id ffacd0b85a97d-4255780b1admr2121501f8f.38.1759306900546;
        Wed, 01 Oct 2025 01:21:40 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6921b7dsm25730046f8f.42.2025.10.01.01.21.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:21:40 -0700 (PDT)
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
Subject: [PATCH 02/25] accel/kvm: Include missing 'exec/target_page.h' header
Date: Wed,  1 Oct 2025 10:21:02 +0200
Message-ID: <20251001082127.65741-3-philmd@linaro.org>
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

  accel/kvm/kvm-all.c: In function ‘kvm_init’:
  accel/kvm/kvm-all.c:2636:12: error: ‘TARGET_PAGE_SIZE’ undeclared (first use in this function); did you mean ‘TARGET_PAGE_BITS’?
   2636 |     assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
        |            ^~~~~~~~~~~~~~~~

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/kvm/kvm-all.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e3c84723406..08b2b5a371c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -36,6 +36,7 @@
 #include "accel/accel-ops.h"
 #include "qemu/bswap.h"
 #include "exec/tswap.h"
+#include "exec/target_page.h"
 #include "system/memory.h"
 #include "system/ram_addr.h"
 #include "qemu/event_notifier.h"
-- 
2.51.0


