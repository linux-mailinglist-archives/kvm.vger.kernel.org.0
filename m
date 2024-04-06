Return-Path: <kvm+bounces-13800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC0289AAD4
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76B56282083
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2AF02E64C;
	Sat,  6 Apr 2024 12:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="at+YPAZz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B60BA55;
	Sat,  6 Apr 2024 12:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407160; cv=none; b=YQUeV2eUy+3POHCZdQl3nWl8PEgZe7RZvVGXC8h067C8o+UlsnOiIu32ksoAbQtPpK2boMkXx4V4PB55M0OKMAxVtwvfhSFWOQeZBooFPtQCKcnOmSY9jUa3v0LPLhhs9DNKLttHOZdAm3d/E/4IKB/8y4a11b2W98AHyqDTRvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407160; c=relaxed/simple;
	bh=9OMbAsnU+2GHeCnIyNL2D/RSvQn0Or13ZlM7FSCcym8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlG9nj+TgdOiVq3yG3nuTBZ0QN+IgyJ/ABNc4qBqzh/y7qtuPDxDl6PTWYq7mrskL1OAyDIAzDnXqFXox6FPoqqlI+3eXvkOm0fbwe0pnLmqYpPEsKQOleIGU2kWoZOu+TyUaDNWf9QUTuy+jKw60ssBlY49O84q/pmncFGyI0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=at+YPAZz; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ecee1f325bso2540674b3a.2;
        Sat, 06 Apr 2024 05:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407158; x=1713011958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JXiqEZUiNUnXuxmqi+ca5TsUVImKZg5r/shld6kwl0=;
        b=at+YPAZzGRrj4D79Mzc28zLQnxCDp1nRYhxX2Mvt8aGTNVjiuXB8E8tqkVdNblOyRG
         xQFiBLidB1dm0wcurFWfujzZv/2L2HVO/PYAaV9WV5n/6+3VgTMXtAcJat3G+yMdYLM7
         ga+YcatO0hUO5HGLjk4nwB75c/erzUf9FORzjCP8IMQwcqU5okqKQ1E/P7UegCiTdB4A
         6c7u0drjrzTvCtslEvcGqn0wy30fSh+GDboTo9iuH5pbPBfZoksYKF9ZVhoiCaAu+FYJ
         NmNpXCJVoikppExAqIxc/YmcLM7xCu1b/g38RI9uURd8TbgEhKQ+JA/6AERVtnpDmoKk
         +BoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407158; x=1713011958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JXiqEZUiNUnXuxmqi+ca5TsUVImKZg5r/shld6kwl0=;
        b=fqRkqDtEDo69oIMJqlZ5/qh5w/99K8kZaW7QxrtxnBrqmZfF/J895IOQQIUFpAMHrb
         vpqVq9r5xZdMRbigL0n7/JEFEN+cLTD9D1XEqH7zT+RWV+AxGVHXcovQAlOUq6YZG2sD
         oDYQaehdUd3pip+M0CNIaJrH0nPQXYluZpdAzeeY7awqD14CZahBVDgHk+MaqSY3mBKS
         3rFFm2A5SnWfFF502iBRWKtZ8C4d31+jM1O/Bads2cejxX1aMPzkAV6qWAQKiXb5OSnt
         X0LI9B4TD2V/dZq4Q3wUzV7erY2+WQPtuSgdZIJqzBEzxpiyrGZwmZg7QK7LfRRbHSm3
         ATAw==
X-Forwarded-Encrypted: i=1; AJvYcCVodDpayhRIG/xGnOqYQXZ0un2ydAjRhZM+BNMOgf4UrRD1wMnPta4YuF6MMgACpXM76j6XdwMeaSj6KupO0GkSNbc1RVnksWl9YuRiJWQcn+g7ylsf263gAK9+6iEvDg==
X-Gm-Message-State: AOJu0YyIXpzycKFsMGIzNoa0Xw5jUesspT4ycUyd5zDZhvGGSHcf7ALH
	2wmcHpPukS0IehqF9BeRGjSwH5Y5r4eQ3RC4Yruw6YlfqrjwUNNY
X-Google-Smtp-Source: AGHT+IG333LDkbX9VhVWof9DtloUszYhWmLouAuBT0iCtpIluUHJkcW3r50xGy82vnO7oaHc8GPVug==
X-Received: by 2002:a05:6a21:7889:b0:1a7:5509:a603 with SMTP id bf9-20020a056a21788900b001a75509a603mr591062pzc.27.1712407158090;
        Sat, 06 Apr 2024 05:39:18 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:17 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 03/14] shellcheck: Fix SC2295
Date: Sat,  6 Apr 2024 22:38:12 +1000
Message-ID: <20240406123833.406488-4-npiggin@gmail.com>
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

  SC2295 (info): Expansions inside ${..} need to be quoted separately,
  otherwise they match as patterns.

Doesn't appear to be a bug since the match string does not include
patterns.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index 9067e529e..116188e92 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -99,7 +99,7 @@ else
         local testname="$1"
         CR=$'\r'
         while read -r line; do
-            line="${line%$CR}"
+            line="${line%"$CR"}"
             case "${line:0:4}" in
                 PASS)
                     echo "ok TEST_NUMBER - ${testname}: ${line#??????}" >&3
-- 
2.43.0


