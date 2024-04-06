Return-Path: <kvm+bounces-13810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7402D89AAE9
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:40:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4B221C20F11
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020462E84E;
	Sat,  6 Apr 2024 12:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5BVMllI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB809208D0;
	Sat,  6 Apr 2024 12:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407248; cv=none; b=bnk3X5/kKmkZPNNCYiQDD4HDF0XMEVweOrgafN0zSuxB4mfbHFRaVwoWWJwxhmQMeJp1Y+l//gM7Dzgn1gQXrWOK2xU61DzC3IRzmTulKeVGjXhr4afRzLPYCl1aHFgNC6A4+MqrThQqQsuZ3AnJMaZtnwwOO8H6XkeB91iUMlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407248; c=relaxed/simple;
	bh=od27buX75qlekTIQxkP3UT5fuV09JndQX6FYD2vHQr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkN25EpYyKHJF2DKfDKXkbk5SA40iPfF2WlD2GvMXwegNSHgb+9yxIsWI4FKwgvJ5Qr0CF+cLZTh1OG3e+pf1POHXix+nLGtwfkzKwDXWhvicvEiqMmijTMVvWSMhgDu45Qb26dzuqKF50CVHNjoOmCFUxIRmWF0lofyzDd7knc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T5BVMllI; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-29e0229d6b5so2425746a91.3;
        Sat, 06 Apr 2024 05:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407246; x=1713012046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74FZsPss0kwxe9NqMeWaPReIQrTUACvwkEx+kD2VIoc=;
        b=T5BVMllIxM4BYjflRB6a2BOZ6VkXne1vvkzc7QW0jwefGBrL0stkZ8O/iCYX3+vy0h
         as7Dk4R6CxLtrsUdYt0mnUPZmf9ietsJjSpq1/grbZSS6Z8VqPyWZnk2Ls48tIqjg9Ci
         XEm2m8DCxPMoLslal/YNTfKR65aBAPPaPni9RXG7PReTafBlK1yzq7Mf6/hfbETygZ+6
         qkKRR41hnc7tNSQV03aRpDRTfiSk0OWGYQTum29MuXGcGRCYgfnPfotFlcx5Z2P91oER
         JdQsIY1D1rdze9uMjW3jA0j8wocVYr6L+B3fEKx08v8nb0zFiy8tah9wLJEX2KVZDn+x
         FN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407246; x=1713012046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74FZsPss0kwxe9NqMeWaPReIQrTUACvwkEx+kD2VIoc=;
        b=fxh/F0ExJfqw+Jt8cUjUqjMsaQfM1e1noi0TAjptEkYHKWz630wuCUDSGdPRRcu5TF
         +qlVXdiLBqexNjbNzhdku4Wve1K1LXnC4I8N13MeFZsWL+MPHE9e70+RgZ03zrrlJ6nj
         jWXV1bjDCXN0VUV/DMs92ZGW9o5XeG5rt12i9JhJjzIIN+A+z/nTvb/pbQfu5nSK/mnh
         mXkfzaUWEWjB/BEmvgykoizzcU4kYXcMfWNNW1+kxrLfTtuGae7A89waXS9DF8Ea1HGq
         83MJ8re2j5GJuczYDVPGDiXYJAXkxJB0ZUysuizW72cvNkRKyOSEiLUkNtvnIvG2IYFx
         tCdA==
X-Forwarded-Encrypted: i=1; AJvYcCUm50enerGpQglDy9DuWZNma4/vLI7EVGkG0Dqa9GRO9WoHfJWFig1ijToO2Ptii00jYB5CahHIkQpA5H/IWUUmTOU55ymFNCSMx057IpDuG1uiQ13eVcD0kxN55tZo6A==
X-Gm-Message-State: AOJu0YwuYE7oqZzDp7Up6oqJXjZlLIULkq5O8R3ltGRgp6yTI3jXQpvn
	CB+2WPjqi1fkAbZyT1nZDbNMD54gwhFjzsJVpf2QqPaCNrDbenof
X-Google-Smtp-Source: AGHT+IFgZyVM/wV4gHHTUtKzy2GaH8FYxLa20w79AVDB9o0mSig7OeFOhEaU4CW5c0EVv67nDh4oMA==
X-Received: by 2002:a17:90a:eb0f:b0:2a2:53a5:7559 with SMTP id j15-20020a17090aeb0f00b002a253a57559mr3815747pjz.38.1712407246165;
        Sat, 06 Apr 2024 05:40:46 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:45 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [RFC kvm-unit-tests PATCH v2 13/14] shellcheck: Fix SC2048
Date: Sat,  6 Apr 2024 22:38:22 +1000
Message-ID: <20240406123833.406488-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2048 (warning): Use "$@" (with quotes) to prevent whitespace
  problems.

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index 116188e92..938bb8edf 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -44,7 +44,7 @@ fi
 
 only_tests=""
 list_tests=""
-args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- $*)
+args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- "$@")
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
-- 
2.43.0


