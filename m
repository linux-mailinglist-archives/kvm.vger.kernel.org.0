Return-Path: <kvm+bounces-59247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94C81BAF93D
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E9BB1C3F95
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CF427A465;
	Wed,  1 Oct 2025 08:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oo9M8VM4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933E919DF4F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306920; cv=none; b=bLWTpapXu+rfTDMzXxY8RtNe/kGZdr87/5oQk1dcOgFhIsvNogcEeSm57wFMAwd5x5HlnALV2f7qo5jsECaukEgLRT7zyV7bX8MMmCq0y+b4yNxW+C9oj5QgHvOJ7tlbsle10xfjNfCjqJBNgURG4aZOaGX8d4PpKGulx9Uacdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306920; c=relaxed/simple;
	bh=Bt7/Fo3I+rezFqRrOSYjqsGwZOA4N+0mqsehCAVsseM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=alTf8pq/i4k90MIFa0Nn7S7OGtjlcsZ2LXOmaax2X6clclYfnibZT9RViBLSORjXYC4KOfEqZWKsrlDxZOBzWaJ85uLUDVeipRknC5Dw0rJjvxmC65ibGbGNtsRXJ1VB8uroJVxsprfTMx8fMoVZ4v5pp1Pc8hdkKY7utyYJCiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oo9M8VM4; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso6229489f8f.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306917; x=1759911717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiAF+xKMY/ZjdE56BR2SJrHQNq0qMD7rf4hlNCZkp34=;
        b=oo9M8VM4KgTAaQKLG26T0mHICEWx5u8lQqtMEMqe2iS2emtWeDgFehajqq+AvBWTvl
         x29Ko4cJ+D5TJDCRV03g9saps/X/pakLBAIzDY2voe0YB4ZhCLWaYR9Y8wWRUB6kjw5+
         iWdceSzkuTgz5WoJ5yHrIKHy/zQzPmDxTN4pNR2yFyB8oPt/trpoygYlRvGKWvLqkdmN
         EkhlMkG26yOtThJdOctR1Tb2agccAPbCsLtpguaP5F3+rsZg7jk/toT/vECxN6OcTuAm
         fVzfiyjDHquHnK1WTZT9JEIU/6/NQpfC031CI8vMmI94OsKVP/JpcplbhQXMA3rUGyXp
         yj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306917; x=1759911717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SiAF+xKMY/ZjdE56BR2SJrHQNq0qMD7rf4hlNCZkp34=;
        b=m4hRQ+oAcZb8MlKk0SlmShmAbMgvvAL2e8QKpRgNNZ3BS80wUVVMUsocXM9l9N0O1G
         2kpLknlH6dzqSwlFhcpSj+gtoPk2L8Z3dS1oLImzO1wc59E+2pzwjfmLZha60o8Jq1hg
         9nMfKe6AJfSdD7/6TltCBDoxhQLdFuZWxyKFlrIxxjy1AMdL7Je3yb80c5R9ixws+x/x
         H0mUeqRwsfX+eMBG5C9JN+NwRx/x5OqcupmcZM5cjbNrh3XnA5+56H+ZzLMThFuS2JfN
         cF592dnsFDj16RQbog8JijbhYS51r/391mawJ2AAmw4e/4Fvu1kik+4xcjitGf4wpz04
         m9ww==
X-Forwarded-Encrypted: i=1; AJvYcCWoKDORBrtstkRWkJvH/zI6nhFJOUYYAqrKeicj1fXLsDILxJvYeNWc+Fl6tCCRJqDwR+o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb8KJv3ZNsJrSU4Klzj+MEMOV4hPhVJ0zkajOumERd/RIcqcsU
	peZWqXBlGXDPVBRdfsKfHS4kgAoOVw8NEHdwVeY8hgW0FvDxMHFwbYTZNj2ynWvDM04=
X-Gm-Gg: ASbGncvBW0baeLmVU/Jwo9JR9h7f9f3Dl9x+HFHy4JDcVofxtw+EWtrAuCYNTf557rF
	DJX2oigPUTWZhKZ4JGM4r/KwB1t0488qG09rnouUCSWIQ9ZY4kihIGEtf0mzR8qwv0La0yIpRC4
	ZaoU9Pu7YuspvDUkutN4ftrGDjTWA0ab0Tr9QVibp2VbhcLqdnw/3a2PygJjkuKGHDvcran4YM8
	Fjop0Kvj+cz4gFjsfgoQW/0JpUC3BWSkdi8ECw+SJx57SCcXQrXAkKxSys499aNVop1blWZqyhH
	ZMvT9fvw2Az5JVl/gBhIKx0Zp5u7NKNoI3vuQvFEgnR0LiYIbp08s/J5GD1MR34wRuX6kp2WW6x
	vE7rauZH3T318vO450Lk/xCEQxX+SgW+0rWe5xAWa3JfN/VretZ5qPFVVbVM+uvGJjoLXzqZiZk
	LbQF2j0jJHK4qnAo9I+e05
X-Google-Smtp-Source: AGHT+IG2c0fzOsFiKbrvJ6/AoYIm/GgfiCoe/atI67XIMJvAlpgbgwgfqiNLjcER0nZiKAK5YPtzGQ==
X-Received: by 2002:a05:6000:220b:b0:3ee:1357:e191 with SMTP id ffacd0b85a97d-4255780b78bmr1411077f8f.30.1759306916617;
        Wed, 01 Oct 2025 01:21:56 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc7e2c6b3sm27728732f8f.54.2025.10.01.01.21.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:21:56 -0700 (PDT)
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
Subject: [PATCH 05/25] target/arm/tcg/mte: Include missing 'exec/target_page.h' header
Date: Wed,  1 Oct 2025 10:21:05 +0200
Message-ID: <20251001082127.65741-6-philmd@linaro.org>
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

  target/arm/tcg/mte_helper.c:815:23: error: use of undeclared identifier 'TARGET_PAGE_MASK'
    815 |     prev_page = ptr & TARGET_PAGE_MASK;
        |                       ^
  target/arm/tcg/mte_helper.c:816:29: error: use of undeclared identifier 'TARGET_PAGE_SIZE'
    816 |     next_page = prev_page + TARGET_PAGE_SIZE;
        |                             ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/tcg/mte_helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
index 302e899287c..7d80244788e 100644
--- a/target/arm/tcg/mte_helper.c
+++ b/target/arm/tcg/mte_helper.c
@@ -21,6 +21,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "internals.h"
+#include "exec/target_page.h"
 #include "exec/page-protection.h"
 #ifdef CONFIG_USER_ONLY
 #include "user/cpu_loop.h"
-- 
2.51.0


