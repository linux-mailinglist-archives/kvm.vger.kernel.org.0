Return-Path: <kvm+bounces-59345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8ADCBB1672
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F5FC3C2E49
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71F3028505D;
	Wed,  1 Oct 2025 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M1HnuGNt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D254B34BA32
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341305; cv=none; b=KC42zAoJuS38EV3ZmcOSpw8kkdtDWCaXpE47UuPadgxAnm+4dVPQLEZKjNT1uFNtrluJHFWx2ZinarVdZwt4WPj3JXrZRBzzAKhhQt1x3IdyV4eb+VqbWANhhqSiZ9xmfbn3ANuaR5NSNiPpj37jy8VooWOEd6fbNuCut+wWwMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341305; c=relaxed/simple;
	bh=NFEBmvZSZwiTzdghu+G9HKZmBNBftW+sJ9Q0DtXDREM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fV9GqcQLSZtn1QdptkzMcEF5REjqeouNrDSc3QSsAshairzBbR5wmLVf795gWgJzHgmzKAYF/YOHv01Ee2x8d6g5fVle9Aq0ipVbBbn8GPX5TLRr/hMqgyy39BtHi+BrG6nmOmLU8mQptWV7gLGcx4W+5EyUphq6DV0svRTE/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M1HnuGNt; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso538845e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341302; x=1759946102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0oYtvp1Jy05y+cs5OqqW4cigIw/Evuwzbdyi31MB4Sw=;
        b=M1HnuGNtB36iJrM6Pp+GjNJpT3Mz+1x8iuE2ehucas6FbO/qlL29PNj8OgMaj+RiA/
         7fQ/BBKMUwHi8CdZd+viCzlArZbeQB2lpiqMx6Svt8SEZUZV5U86uHxZWaTbbP6ofYKW
         x78dbvF1xiorZ5G2wmvW/dc2XR2BbzxryCsSAqhE/cMJInY+TPjETWnFZzxvKcI8mH1X
         uSzSGCqhplF9VaRvMZsW1ra5hIMcVQJVzbYLz6OxjmlteeZJmhQBDYRhy2nScyiFtY7R
         ZZgj8wXfdEDHo9mw1k/R6i5qLmhp7OM0oiW0DcAJldyp2assolUHVFPPVB8A6fBXrm6y
         mLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341302; x=1759946102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0oYtvp1Jy05y+cs5OqqW4cigIw/Evuwzbdyi31MB4Sw=;
        b=TTTaFMhDdtTao78JS78GjRYxb1HHtmtY/oKOGru7X91gVj9goMl+dcZvJeHSpome7w
         9tLSQ1ae6aRt2Bi8kjyaJGMXyRYUXk6Zh0wVbHS4WefSRoFEaemFv+7bAPnbyYSZ7u6t
         PPB5tDEnNSBoiOEAscQfQ2zsnPaRbWH18sslL07lAAx39yVe4WzzL+lbfyqr3Xenn8WG
         iWiIZVXbsSRH0/1fqM3ohTHEaRJ34IU883I5R2AQHZYYntuPehdUdeCb/UVpPK3Y9zd3
         Yp7BoM1bdJWxkZf6vrejMGyzasWdS1m/C49hqg/DuHDzzdMlMMbpLMdMHnmr5Um0EQJs
         wBNg==
X-Forwarded-Encrypted: i=1; AJvYcCUbEn1b1fSlnUHnqXKslFC+UTOF6URrMK/xcRtvPxYsvl+xXl5BRmOPbXr8P3KDDVVHWss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw04E9sSF5NtUNzNRwXp444ps3bpOVVIiuCO5knRn55arco4HLR
	FDdNkZDuhe2sEf6OCmVp4v+4LmeYX4A37OzvGQUvkHchP8dM0PX4QfoPGIYtIUEOeF0=
X-Gm-Gg: ASbGncvCoPBvNBwcPw9KUQBMTQZdH4Xe13eoTGuzL+7lKqzMEY0VhOOe5jjKhDBJNSc
	lRtsgQYX63zCCeXPiAqctyWFUzO8vBRNKDcDPVQu4aiTn2r41xcS3OVlAb/12a7MMGl/FoSJanE
	iNMIqZgboDDSWux4FWnc5xRWU2g5XOrlV4PwO1q1CLgpFy5o9D7yJgAztlcK9SOuwFXZGcNB4f/
	GTRvVQm5tHuy/iDh0cVhHDXGzvKQ1hYNoJNLraJF/OvRqHJgUEwXx3jKMsVSpo6YWEYa9H7z4bQ
	Yiz5PPwe45C3s6lm+lXWk5ENEIiFDkJiJeq95tnK1xUzv3OFPaz94ilcJS4kK3QwlewYgnr7rk/
	lyHA00LEtmxfawzKef4fbRf/eLTBDQYoC+R4SMLyWzqz93o9VkIX5cXTHR7kJeQw8FVPOUxHoBw
	ljDPG4FZpgM9ZDAYOdFf97j9STwA==
X-Google-Smtp-Source: AGHT+IEE+JOgdQcWDCLTXQOhks4UvOy7ZMILGVzu3gYLgsHV3P63UTkJyw5YOjk/WtC4nRuVfjLM/A==
X-Received: by 2002:a05:6000:2f83:b0:3ee:2ae2:3f34 with SMTP id ffacd0b85a97d-42557803ac5mr3634173f8f.13.1759341301952;
        Wed, 01 Oct 2025 10:55:01 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f027csm94114f8f.40.2025.10.01.10.55.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:01 -0700 (PDT)
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
Subject: [PATCH v2 02/18] accel/kvm: Include missing 'exec/target_page.h' header
Date: Wed,  1 Oct 2025 19:54:31 +0200
Message-ID: <20251001175448.18933-3-philmd@linaro.org>
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

  accel/kvm/kvm-all.c: In function ‘kvm_init’:
  accel/kvm/kvm-all.c:2636:12: error: ‘TARGET_PAGE_SIZE’ undeclared (first use in this function); did you mean ‘TARGET_PAGE_BITS’?
   2636 |     assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
        |            ^~~~~~~~~~~~~~~~

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


