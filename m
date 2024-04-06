Return-Path: <kvm+bounces-13797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E3E89AACE
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16BC91C20DB3
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2A22E83C;
	Sat,  6 Apr 2024 12:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7eSSDyO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB7D2869B;
	Sat,  6 Apr 2024 12:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407133; cv=none; b=tsaErAn+2r387F21H6ZHU6uvFGDk8294TEoJitlUWKNB+0aw9QaAdwjzCgrQXRROvSxaJNhWLKeFnoX+QMG4pFkxdOZvQAIxtGKng3W2ZBY4kgruOZ/u96Rs8ounRouEauCXp/tgjsJLFlRvX3nRvd1xW7AmV317SDRbxvlAt0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407133; c=relaxed/simple;
	bh=w46SXyYEMeeZD6g32zT8PhnLM/MxhZO53g/IEoHjQog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JlU61ifElROR9IjRSmpqnymwgpxQjdx0PIpcwwp9mDBgmDVumf6CKunjkoa71u7DtjK/ejIJ/s80YSbihpUc3ImN/GOqdfLJVqkra3Mbco/zXnBIJaXgaeYZmqJyUzyAgAAoackC2Vmpjwa8rnYIqfGKwPOiwJ/PSsJbIcVAY2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J7eSSDyO; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ecfd29f65dso1633736b3a.0;
        Sat, 06 Apr 2024 05:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407131; x=1713011931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7w2kaMdOJquHBKIGt0eh7rBKhuP+nEorD/7bYdg9VOI=;
        b=J7eSSDyOkMP01KWoQvsD+U7YAbJ9BsKdh1wbMtLsRFXBRcp5y2AEWmC2Dus/ouhZeR
         Dh28BvZl43JtDBRw8KvG2duT4nB5GllVpdWPYuYa58H//m3BO5dZSWWL5HRn5NO8WveW
         GPn08c6QKal7xfZy5n1e5LKkzmUN/o61Bf7ulxBOCethl9U+mKsMwjEHDri+9Ff7Gd9E
         NkHYKpu8oNmePGOyeppWhXdhxsFmBXZQgngdeV5aokCmrwwatz9i4xWi9clqBtCfAGs7
         cVBv06yWl9AR1H6yMNGrQwz1O9prK7B9vXF8JIJrxe8TzhW5wVUGgyCE/EoCRpU7WoOy
         R7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407131; x=1713011931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7w2kaMdOJquHBKIGt0eh7rBKhuP+nEorD/7bYdg9VOI=;
        b=jEWxFW1JRl4Tm7HV/6kRSkXNvITR5eJHjQImqmGKxbFScN2WHhv+4pvRU+BfxbBWm4
         KHUuyQBN+lxrZi7r7djlzlNeWhYmPcNqCAK2OPcs8XusljLoEQ5jRkh+WIgkAIhH5jpq
         YBT6ARhYXlr9t2UMSuyt8ZkmCwOaVC2RynqjPWFRkjE1YVQhxheow9+h/xStOo6770U9
         JXIrq73u9O6A9rS9C6DTgjQpEgPhlIt5NFo5C4hL2Uy0uP4FhZotJved64QjHFpGYWFQ
         vVgo12M6L5NM61ViB74jfN3j0TLMTkcPJGaHZK1+Yi6GzkG5Z6lV2D62Z9ppqFB0sEee
         n8zw==
X-Forwarded-Encrypted: i=1; AJvYcCW1GXlnD0HMPjqaoOeLsd1hgm24xBZigmAW3X3g2CoZc54iJaWeC9a1HxP6l9aAc0fyd94Zp5UjuB5uYr0IpplOVIaue6qA89E4+UA6s2cZ2oVf+ewZedc2rLqXdeXurg==
X-Gm-Message-State: AOJu0Yw3L6fVhCNJI5JBJPo04/TskB5MZ0PuNEVelRC4sqJbkt1XvE9z
	xLzuAOXZSIZhghwrIyQua0+ingjK65VIkqdLfNhmb8hhhpBY2Ur/
X-Google-Smtp-Source: AGHT+IH4r6r9YbNAgX9HgtfYp0aid5yQ4Qc22A3fJ45yWlgo2AyKwwzLl2pM3GDnNTbmVtMVsPs95w==
X-Received: by 2002:a05:6a20:4324:b0:1a7:5103:5520 with SMTP id h36-20020a056a20432400b001a751035520mr1027830pzk.43.1712407131082;
        Sat, 06 Apr 2024 05:38:51 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:38:50 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 00/14] add shellcheck support
Date: Sat,  6 Apr 2024 22:38:09 +1000
Message-ID: <20240406123833.406488-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tree here

https://gitlab.com/npiggin/kvm-unit-tests/-/tree/shellcheck

Again on top of the "v8 migration, powerpc improvements" series. I
don't plan to rebase the other way around since it's a lot of work.
So this is still in RFC until the other big series gets merged.

Thanks to Andrew for a lot of review. A submitted the likely s390x
bugs separately ahead of this series, and also disabled one of the
tests and dropped its fix patch as-per review comments. Hence 3 fewer
patches. Other than that, since last post:

* Tidied commit messages and added some of Andrew's comments.
* Removed the "SC2034 unused variable" blanket disable, and just
  suppressed the config.mak and a couple of other warnings.
* Blanket disabled "SC2235 Use { ..; } instead of (..)" and dropped
  the fix for it.
* Change warning suppression comments as per Andrew's review, also
  mention in the new unittests doc about the "check =" option not
  allowing whitespace etc in the name since we don't cope with that.

Thanks,
Nick

Nicholas Piggin (14):
  Add initial shellcheck checking
  shellcheck: Fix SC2223
  shellcheck: Fix SC2295
  shellcheck: Fix SC2094
  shellcheck: Fix SC2006
  shellcheck: Fix SC2155
  shellcheck: Fix SC2143
  shellcheck: Fix SC2013
  shellcheck: Fix SC2145
  shellcheck: Fix SC2124
  shellcheck: Fix SC2294
  shellcheck: Fix SC2178
  shellcheck: Fix SC2048
  shellcheck: Suppress various messages

 .shellcheckrc           | 30 ++++++++++++++++++++++++
 Makefile                |  4 ++++
 README.md               |  3 +++
 arm/efi/run             |  4 ++--
 configure               |  2 ++
 riscv/efi/run           |  4 ++--
 run_tests.sh            | 11 +++++----
 scripts/arch-run.bash   | 52 ++++++++++++++++++++++++++++++-----------
 scripts/common.bash     |  5 +++-
 scripts/mkstandalone.sh |  4 +++-
 scripts/runtime.bash    | 14 +++++++----
 11 files changed, 105 insertions(+), 28 deletions(-)
 create mode 100644 .shellcheckrc

-- 
2.43.0


