Return-Path: <kvm+bounces-7814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D87858468D1
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1614A1C254AB
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0471774A;
	Fri,  2 Feb 2024 06:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuHhg/oX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBEA17BB5;
	Fri,  2 Feb 2024 06:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857082; cv=none; b=OgNq2/ckE/7NpjHW7/jpahz72k9SXuLkM0fmEDphHefi+7V7eav8dxK770MHEHzSnJUscI7TXjYYrguT4dwvJjzbYOpODYGR5BcU7uCCpT+eVScLsPWT5PZhPXescP/ODXnu//eJERLOcUPQJznrqJf7FRaldAEb5EXAMl/W4TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857082; c=relaxed/simple;
	bh=vCQQxqZeil0+LAP1vgV7VJsaQr3zxDKFtbKnoHbEAHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k/9cya2H6mCNOvyAJ95LV3qE+zJ6Ik7OviBHd2X1UaNSC/6EJn9FBaKTJ8D+rw4R4fDQihh9pH/dNuuJVVTQlkLz7nYY/tKcmaUgGCnlpEaFMAKKW+VGIBsdV6dEhRRWJEuHdKhNori+h0aYBF5xMhvJHEw8yaKOnRJIVllJowc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WuHhg/oX; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d928a8dee8so20120765ad.1;
        Thu, 01 Feb 2024 22:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857080; x=1707461880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L/vDd2wgYFMcjNJFhzb4jvCxGWjleUG2mUvo4O12Bto=;
        b=WuHhg/oXRnJPO7KGu7f/gADvMoLd49TTh9qf5P8QJM/loataF5NC6OyaS/Wt+bmftQ
         lhP89xQuS/WfCy2kBMOnjS+IWJ4syx/kZAbNkKVPAGDs9gO3zLMEqpaFxNMFp1/xk4DC
         7zsgNaniGVA+CIKCnhTHgSOcnF9CNA3qx1V2Y1Rx9QbkZKoKawxRUyzNcS47yZTzj+Nl
         PDtzM45V8Wism8uIKWNgXxeyYuIy0emV6RtR0EpcrH+AXMkdL9reBw0Rzjx+YCXdSEAk
         hdR43qEEEt0Nbbr4JQOwkB7f9/l5OnMdd/ysbYHqCROgFBfLdFYR3CzK8/sgwXpOuiEL
         w2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857080; x=1707461880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/vDd2wgYFMcjNJFhzb4jvCxGWjleUG2mUvo4O12Bto=;
        b=rRhb/UZ5xRFsdsCTT/NlB46V5EDUjICXufhZUhBl8nbD5a3NzBNbiGFRvp70XssZMe
         0gdJaPrHWs9V/4DkbxNcSFyFqO7C2ptxIW+JlZx0k1Vk8Xun5bWF3XZ0jMAuBjXSiv5C
         E+XP789CFTX0NuVKDsZwUfK+qY4M5jrDuiTQR9eb8HjpnaJsrEg4z9PGZfxe+Ax7hYut
         HkWHGykpcIzFqH+LFtsVyiKI9C4oPmhfKmoehEZ4yks+8AXfnkHDl3hifNFrXcOT6q68
         sr/y4vl5JMpd5debEUhb/9N9laXhv0ourvOfWYU6Otm7NbKcalPGORPvBOWkc4JWA87T
         BN7Q==
X-Gm-Message-State: AOJu0YxfaO4tzXrsCAZQXkyfOb/2B4/CSMr5+fAfIctl++w0oXHq/3Qf
	AdjUGAS4WtHWqJFaJl8HegvUO1sPnZ0Z4BKh9bkFQTWuCGbxkK7Q
X-Google-Smtp-Source: AGHT+IGvWMO95PcN7pxJxhTwc5bvzblFArUoEi14KMGjTdeCja7Ua1kX5fGYBB4wx1ubSAWO93T2uQ==
X-Received: by 2002:a17:902:d511:b0:1d3:f344:6b01 with SMTP id b17-20020a170902d51100b001d3f3446b01mr2424651plg.3.1706857080038;
        Thu, 01 Feb 2024 22:58:00 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUPuBFBBUlP1POmXUq/7h79MjiGh3Fb+mUy8N0UtV29d36M8bpCkahEq2fBI12IF+E2V3w2wkb1AY1J5N5Mq6dcaLElXt9euCwD1asMtGBMENTsh3t5qRBApH9FJ27tgAzBxPBOWVbeN6j11hEQBnq8Kq/gtoGDRUHPovJP7hSkwpRmKAtFnJj23Xwc80WxpIBcbcOUV3n5D1fLgw24RKKZeuGdKUg0zDQ0L3JhuH8IaHVQ49tNvfe15pQylzqD8MMSviLW6EJpNB/DoyUOkkoK5tsxuSw9lHUNsmEnp5VL/preOc20OLi5OINKuq2J+OPc47YeqUuthIys4aGZ8sl2UvynTs6wt6kBRSRWWEMGuqCzVn6rWU8ff3+rbGssrIqWwuoXklN4c8qymt7QvGw4skVzrFDlYLKgqcIbW5+3RKwhZhhZkKJUBIFnhKxaSc4pKaDkzsHezYbgD6ndnKL66CEeMswERnvxbjl1AddT5WEz4nIAsiOt0WXb67q+R7UCUihOY5LvYpI=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:57:59 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 0/9] Multi-migration support
Date: Fri,  2 Feb 2024 16:57:31 +1000
Message-ID: <20240202065740.68643-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There were not many comments on the previous post last year, so
this a rebase and resend. No significant change to migration patches,
but this rebases on Marc's better fix for cleaning auxinfo. So that
s390 patch is dropped, but added a minor fix for it instead :).

Multi migration works fine. And arm now has a reason to implement a
a getchar that can run more than 15 times.

Thanks,
Nick

Nicholas Piggin (9):
  (arm|powerpc|s390x): Makefile: Fix .aux.o generation
  arch-run: Clean up temporary files properly
  arch-run: Clean up initrd cleanup
  migration: use a more robust way to wait for background job
  migration: Support multiple migrations
  arch-run: rename migration variables
  migration: Add quiet migration support
  Add common/ directory for architecture-independent tests
  migration: add a migration selftest

 arm/Makefile.common         |   3 +-
 arm/sieve.c                 |   2 +-
 arm/unittests.cfg           |   6 ++
 common/selftest-migration.c |  34 +++++++
 common/sieve.c              |  51 ++++++++++
 lib/migrate.c               |  20 +++-
 lib/migrate.h               |   2 +
 powerpc/Makefile.common     |   3 +-
 powerpc/unittests.cfg       |   4 +
 s390x/Makefile              |   3 +-
 s390x/sieve.c               |   2 +-
 s390x/unittests.cfg         |   4 +
 scripts/arch-run.bash       | 181 ++++++++++++++++++++++++++----------
 x86/sieve.c                 |  52 +----------
 14 files changed, 260 insertions(+), 107 deletions(-)
 create mode 100644 common/selftest-migration.c
 create mode 100644 common/sieve.c
 mode change 100644 => 120000 x86/sieve.c

-- 
2.42.0


