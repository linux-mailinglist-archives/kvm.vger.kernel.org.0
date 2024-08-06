Return-Path: <kvm+bounces-23342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2530948D7C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:14:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6AB1BB25A6A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8621C37A0;
	Tue,  6 Aug 2024 11:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="38UH1bXY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A971C378B
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 11:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722942818; cv=none; b=aEqTEGW//isL7utX48yCTjJ//oPF49droGrX5Az6wO/53GnK4HoDHE1lZH9EZFP+YvHaZ5DsfDO+usOcSX2uU2vwTlHAOA4xTEpmrcqMuNeTbcHaIvCB4AOG5NwxnzxFHN5l4tVI3xbBrTctd+82nLWa1OkEw6K8bjwfYQ+KYYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722942818; c=relaxed/simple;
	bh=kusyX74anKUvJtCfxngX/OtY0QjoeJphsXn2Qty7pKw=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=QMh5UwOwYnGmd2IRNBl/ie+VafO7cxlbbadhYlO8yLv/5dYtz+srff+GYu59AF0n/QfWLdDWLrMv9yEqDcC/T4zYWJiYGDrDCEyY00ZoOBEIT7MCOyWV3pvnnR/S4g/HZicKk5Beyti/aX6ejO4kNbzCofoLmok7857U7Nl8mRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=38UH1bXY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0bbd1ca079so834509276.2
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 04:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722942815; x=1723547615; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xyUxj+djLdlRwekr4YmMJ+pDVibINgk9WOcX6Bxk2YA=;
        b=38UH1bXY6AqQqZcSWKZEnodwDLSnbaRYKgvfhJb3iGMBqTV/6ybZfqVl/7fJgyvC+R
         T2MRV1tEMeZg6dBQqmdbbA+toHwoIxz3CrA4Tj1fAhRgb0k574u+NWigAqRjdCKwEU9P
         Cfpapqs8NqLWFyZwkCFp6kz5fhI/V2weZhe4KCPHCnGW5Cy2CGLpfEmwqN2izMzJA6NW
         czbvx0E3hHCjPb4SeA99R+WcT+TzDVr50AYExHnle1eom/8LsVj7OaJbwGF3wMvvJh14
         lsZQo8c+JYEV1Gi3izhRjPdPeYpcvdHC91R0gH5tNEyEfB2Y+BhTCEdmpQLDnnbX840U
         WzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722942815; x=1723547615;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xyUxj+djLdlRwekr4YmMJ+pDVibINgk9WOcX6Bxk2YA=;
        b=cxD3GHeZunPv+HF/EUvPhI84/Lq3XDS7bpOCD3+o8x7oBkmmIR+eIN7LbaEcG56HJ8
         1lv0dS98uPwZ4/jkkt3VObMD/9dnistMJXwS6Ee+HkkOv8UQedV3Kfo9PS/ut09g6hIZ
         BtKJhlQVjk49Ct4SIHoUvLO/Ttc4J2b/tO+FGIPNN8BGNwbS+87XG84HBCo9ri1Mxy01
         WAuG76DXxN2enRdCCKXkpZYJEP/dhb3OSDSM9GILIJy3jj5U9lPAtZME+8gteg5m9Seb
         gvS8NxGJZiL8HAC+360FcGoQxHyAd0PKVQ6EwjYaqwnrOW2wi9aW2pzPm1a0aKI2LE4z
         V1iw==
X-Forwarded-Encrypted: i=1; AJvYcCVKUWofuAjH2QhHKMB9ESWIW1alKy6m2XAHoIBcyXs/+LyBZRkNn/g+Ugisn0e72UBzpzHpadcE8KiTYHK+mzutLnVn
X-Gm-Message-State: AOJu0Yx5XY9m7m4RJY6FeUtxWXqb2/XrDoXvTK/kHGMZOUNreH1CbWzg
	KicUXmGhWMan2T3PrYDfNv++rRgIG9UYaiZj3HuJcaqBVa8LNilfEVJi76f5Niw3m+fEpswfzB9
	2XQZqWK5MxQ==
X-Google-Smtp-Source: AGHT+IHheegWu/yI68m9kH9ZXwI+xsqn1YVqotildNKzDceR+E97lk+Px0u2KK3wI2oNacUveSQ1G3Vk3r+ALQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:fb:d234:7f21:d2f5])
 (user=suleiman job=sendgmr) by 2002:a05:6902:f11:b0:e0b:ea2e:7b00 with SMTP
 id 3f1490d57ef6-e0bea2e811dmr63020276.5.1722942815659; Tue, 06 Aug 2024
 04:13:35 -0700 (PDT)
Date: Tue,  6 Aug 2024 20:11:57 +0900
Message-Id: <20240806111157.1336532-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Subject: [PATCH] sched: Don't try to catch up excess steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com, 
	vineethrp@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

When steal time exceeds the measured delta when updating clock_task, we
currently try to catch up the excess in future updates.
However, this results in inaccurate run times for the future clock_task
measurements, as they end up getting additional steal time that did not
actually happen, from the previous excess steal time being paid back.

For example, suppose a task in a VM runs for 10ms and had 15ms of steal
time reported while it ran. clock_task rightly doesn't advance. Then, a
different task runs on the same rq for 10ms without any time stolen.
Because of the current catch up mechanism, clock_sched inaccurately ends
up advancing by only 5ms instead of 10ms even though there wasn't any
actual time stolen. The second task is getting charged for less time
than it ran, even though it didn't deserve it.
In other words, tasks can end up getting more run time than they should
actually get.

So, we instead don't make future updates pay back past excess stolen time.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 kernel/sched/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bcf2c4cc0522..42b37da2bda6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -728,13 +728,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
 	if (static_key_false((&paravirt_steal_rq_enabled))) {
-		steal = paravirt_steal_clock(cpu_of(rq));
+		u64 prev_steal;
+
+		steal = prev_steal = paravirt_steal_clock(cpu_of(rq));
 		steal -= rq->prev_steal_time_rq;
 
 		if (unlikely(steal > delta))
 			steal = delta;
 
-		rq->prev_steal_time_rq += steal;
+		rq->prev_steal_time_rq = prev_steal;
 		delta -= steal;
 	}
 #endif
-- 
2.46.0.rc2.264.g509ed76dc8-goog


