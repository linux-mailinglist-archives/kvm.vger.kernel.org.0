Return-Path: <kvm+bounces-11463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 874FE877503
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 03:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B94A11C20BA2
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 02:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445112E400;
	Sun, 10 Mar 2024 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4RRJfEVF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AD72744C
	for <kvm@vger.kernel.org>; Sun, 10 Mar 2024 02:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710036352; cv=none; b=g8+RWKs+A0/UHas7as9hERCbDAJwiHtBiR5Lze8OfZf5QbTlw2gboNSA9peFdYo5GSoIejSBLvCYWMakCIHqWjXv4U8ba8k2jV9Qvyxn9g80Hq2F3LTSvv0Ok1QFhUcy9sL5w0DrBcUeMn8pALr1dB2E+7s+7StPrTZaoD9IHXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710036352; c=relaxed/simple;
	bh=gXS4/PmUcr/u98E5bD8fZ0t4D/xMUtOLNVIZOZ/mooI=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Content-Type; b=C2iE2ireC4WgMQ8YQZuNbaxoOMo+TOed2/BDKDq1KThFM8ZZIRaIloCBeILXkuR+R0r37PU/VGYs/Lkh4c/wiIUnXvIrV4TOhQXjvstxOAwNsdyOf3mMG9RaaHs+MxuiUSnAWl1l30oFuCNjP3nT2kZ7ULEOe4bQsDSADOOUVSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4RRJfEVF; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-609f2920b53so48010857b3.0
        for <kvm@vger.kernel.org>; Sat, 09 Mar 2024 18:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710036349; x=1710641149; darn=vger.kernel.org;
        h=to:from:subject:references:mime-version:message-id:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vgONc26lvm/9ZOmPonAKLBWVK7kvQvvNgc4EWpL/eBk=;
        b=4RRJfEVFPtrJeHkpe6FwktJhu6hedW8U/v/FPR5lEZLhqQphPs7rfv16DpEvOLsq3p
         uJY87zLQNSikrSGbJjnZmvv3SXwvszzrcdKMS+PKtWJIUZtpzl7R0QEuJARFoL8xscwU
         rLXoSBMrzfFNivUw+I2NtMiETimmNkJd6cd7MXkpMcOn3sAm3xhnGlM7JJ0agY8uLr+f
         aziq4Fo6IxHBXY0idncI9OQeKuvL/Oh585fTQgef3OOR+7L7BZeWsnsPOiZaR5WeSN0K
         OthKQCtrXWr5CHwo2KSZJcHxH72A5++tGB32b3HTV7eIH7HP5uHRbMBhpcBc9t59/bku
         QaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710036349; x=1710641149;
        h=to:from:subject:references:mime-version:message-id:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vgONc26lvm/9ZOmPonAKLBWVK7kvQvvNgc4EWpL/eBk=;
        b=aZiVrf0yFBArJ7Kjlc/Uf43wj1NhJWyMBk3YB+2OXjx5GRUWlyK8IiSfpf3h8PqLeB
         xGPmD2wvlHs4uLv0SaLk9RdZrcdcEntH66tfdGIK1J7jFCQ1WFMo337lRk9e+OtjAqZK
         nY7U/wVx6oJw0/+59gobSH2Bxl0nsfqHLV04gg+Exz7T2rezzOj8Q81+lxhLt7y40/dP
         N5gGALosiL3a91pxsV11BgpJqfKp6+/OxeuZxpOoBjJmEMeUWbjt6/obl4UO+m69Kvfo
         nT22mcGMAWD3xC88skKdLyseXSz1/0qejDao++0Avf5fUewFzdeDvwvmsaaCMlTda/yH
         O29Q==
X-Forwarded-Encrypted: i=1; AJvYcCVi5Vk0cg0hDvSXZERYmGjMvifTLYmMdBvxnGqMZ3b/829jGvmUEhjGB4qzyJX9leCTbMRM1Aurgs0P+gGCsOlUYf9Z
X-Gm-Message-State: AOJu0YzjyE7uR/cFJsfjwS/m55mWz0ljj5PzFvgYSErGODVWgMxGdThF
	4h2/PSpMwSuYkU2Rj9zWq9BNx6fFcwvrJ5vnZXu+/y1bFARcb/oY+De3dBBAMeJ9M/cbfMrgCEC
	3l1sBcQ==
X-Google-Smtp-Source: AGHT+IEHSaymlJ72bm2wFBwRFlyvHmM501SMsBRHMdMGbeCTQVSAZx2WeXRxeWUBMJJSsrdAYYWs4TJGUV9K
X-Received: from irogers.svl.corp.google.com ([2620:15c:2a3:200:a63d:1b65:e810:3ad3])
 (user=irogers job=sendgmr) by 2002:a25:ab6f:0:b0:dcd:3a37:65 with SMTP id
 u102-20020a25ab6f000000b00dcd3a370065mr144117ybi.7.1710036348960; Sat, 09 Mar
 2024 18:05:48 -0800 (PST)
Date: Sat,  9 Mar 2024 18:05:02 -0800
In-Reply-To: <20240310020509.647319-1-irogers@google.com>
Message-Id: <20240310020509.647319-8-irogers@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240310020509.647319-1-irogers@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Subject: [PATCH v1 07/13] perf cacheline: Add missing linux/types.h include
From: Ian Rogers <irogers@google.com>
To: Arnd Bergmann <arnd@arndb.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Kees Cook <keescook@chromium.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Liam Howlett <liam.howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>, 
	David Laight <David.Laight@ACULAB.COM>, "Michael S. Tsirkin" <mst@redhat.com>, Shunsuke Mie <mie@igel.co.jp>, 
	Yafang Shao <laoar.shao@gmail.com>, Kui-Feng Lee <kuifeng@meta.com>, 
	James Clark <james.clark@arm.com>, Nick Forrington <nick.forrington@arm.com>, 
	Leo Yan <leo.yan@linux.dev>, German Gomez <german.gomez@arm.com>, Rob Herring <robh@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Sean Christopherson <seanjc@google.com>, 
	Anup Patel <anup@brainfault.org>, Fuad Tabba <tabba@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Haibo Xu <haibo1.xu@intel.com>, Peter Xu <peterx@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-hardening@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

u64 is used in this header for cl_address and cl_offset, so
linux/types.h is necessary. Add to avoid compilation errors that
aren't currently seen due to transitive dependencies.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/cacheline.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/cacheline.h b/tools/perf/util/cacheline.h
index fe6d5b60a031..50b77129e1a4 100644
--- a/tools/perf/util/cacheline.h
+++ b/tools/perf/util/cacheline.h
@@ -3,6 +3,7 @@
 #define PERF_CACHELINE_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 int __pure cacheline_size(void);
 
-- 
2.44.0.278.ge034bb2e1d-goog


