Return-Path: <kvm+bounces-26328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F359B9740DA
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C1A428A632
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC46A1A7072;
	Tue, 10 Sep 2024 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q22PgiuD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9E718EFCE
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725990023; cv=none; b=PEnbPCIj4ue9GdDxGYCzP9e3hkSiROb3MuLLj9HSQ8SlheKZZ8CaR1vuNzTLxD0Pf3VsOTVzud80Id2F97poyQqOTgmNpj6xD16nrJDZCmiLfIjKLrZLjWNu0Naic+Q8C6X/tMRwTLCQcy/b/1uY4A7IsFbuMj4aJYvzYUFGOAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725990023; c=relaxed/simple;
	bh=T/KEscckbYYv8nFayO7e9ZzarrkVmfCybf6TCOToYdE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Vq+FI/nKYHOzJ7h7HvdfZA1+4z1btrA1ppDQds+iihdCqg/o3vyHsHX5zGKkgT6+HAkKA9+LNOpeZ1DTASQTs4OMHXBDNQOlegfOJ9enqFgyNX+G8cqgkYmzyY4N/iKTtHVjYdaFrMyC6uvp7aA5WNqGh3kpcYsXIbtDzopiCp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q22PgiuD; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71911585911so625528b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725990022; x=1726594822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7IuVk+4j8sLSrVGUPeyOAaGe996Ji2rvk6igp9easzQ=;
        b=q22PgiuDexT12Ue+ijysCcAYkrQN8h1kgAwptJ5lTfYZuBQK723d6vCfVTlAa18BlU
         8UZXrruhpRkLBrijdeUrC6diIjpejzAIkK3jp2/YsLJ1ISn3q7MSaD5YxvCEiABcRr+q
         Jw9CVP+jEFOwt4LM39jovg2Nery1ZNnEay9l5zyEGfjxGDRV2k7p8ML7iRWVjWf3L65U
         3kPRQFQrzIHbpsziU9CxDbCpUR3M0sPJSFM4gkcwl/qCM8HAyAqfsdueho9w5meCx5gv
         QXnfZ+cztHqdCPWIKaqTmSwoBlgH15gqghGtEhtUrKkD2bOP7CIzuBNVWczgH8kTzlx0
         yP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725990022; x=1726594822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7IuVk+4j8sLSrVGUPeyOAaGe996Ji2rvk6igp9easzQ=;
        b=YVLdt+BXg30UkOwCF2f6MupxokQ0mTvLh/7zQnxkEAuUD3SYdYrocDdn1f7OAlwQkG
         HwfHND9qtIRn5Fx7DejwKG8iIKo7vMV8Qtk602Yev14LVHUSSwiHTAnGmjYehAiYeN08
         jWLXD2tNp8mvvk94IhbvIGnSJQziGNgY4ImTvLrUepGWBAeYBy/kpwvPi2WTQ5lmIoxA
         R6loBtxzl4SJ6goPdcA+KkUM/t5VpmJNIPwHoRjx64aimIsCShsYz7SlcjdhMOXpSif2
         Tp9abBFltWyVGboe0AhbCkqRjYBNQrlmj6nxXO1e4tXuksCYFRe8K2qjdMACDpv45jx+
         ovxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEQyO/L7WYLQDwkrUMHNc+Mcwx3ve4FtZW2wJ8AqSHX540fDO5o1WWwu3EuYnIpiFrGVk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+C4CkYDBAVo51NhCu0ZZfFSGwxRBPLr6sfWsFRNMeNpWuFJT2
	bjaQSk6MKdWglbFsFnhzHMIeNXmxtVF7tYtSokMha0O8NMqCDZE0+nVFk4hB51Y=
X-Google-Smtp-Source: AGHT+IElvFQY+4wSOF9AHzT+ZFuOHW2i6wZqAogDfq4RXoum4LbG220eqTylWzBSlE9N9DFYJSnNEw==
X-Received: by 2002:a05:6a21:458b:b0:1c8:a5ba:d2ba with SMTP id adf61e73a8af0-1cf62cdaf9cmr652112637.22.1725990021601;
        Tue, 10 Sep 2024 10:40:21 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db04966d3asm6682751a91.38.2024.09.10.10.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 10:40:21 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-s390x@nongnu.org,
	Beraldo Leal <bleal@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 0/3] build qemu with gcc and tsan
Date: Tue, 10 Sep 2024 10:40:10 -0700
Message-Id: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

While working on a concurrency bug, I gave a try to tsan builds for QEMU. I
noticed it didn't build out of the box with recent gcc, so I fixed compilation.
In more, updated documentation to explain how to build a sanitized glib to avoid
false positives related to glib synchronisation primitives.

v3
- rebased on top of master
- previous conversation shifted on why clang does not implement some warnings
- hopefully we can review the content of patches this time

v2
- forgot to signoff commits

Pierrick Bouvier (3):
  meson: hide tsan related warnings
  target/i386: fix build warning (gcc-12 -fsanitize=thread)
  docs/devel: update tsan build documentation

 docs/devel/testing/main.rst | 26 ++++++++++++++++++++++----
 meson.build                 | 10 +++++++++-
 target/i386/kvm/kvm.c       |  4 ++--
 3 files changed, 33 insertions(+), 7 deletions(-)

-- 
2.39.2


