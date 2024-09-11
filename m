Return-Path: <kvm+bounces-26499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E18D97509E
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7AFB1F2179C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C433C187349;
	Wed, 11 Sep 2024 11:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dIVYljLb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A1918733C
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 11:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726053386; cv=none; b=VnHvU06ZdBDwTjdMDAV08aJhAQ1VBv7R5QhusOsmlMzchjtxWahcfGXbNITiy/+hla35yv/fGxy1ai6f1qXb5ffIWT1AfCvtOVe9EaH+FXrj3xObDAdD+l9rKTLUXBIBzNuWveQ+0CKFRwQ817HruOyoFa4wUEgrX39Z6mxyAa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726053386; c=relaxed/simple;
	bh=wTtci8eoVgZsRM2qXAmiFpLpC6jRu1ELaLXAPR2rZro=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=hRlsovQ8YNt/56LbKrdkjp+UMo8hKXfCu8yb/gYafOpPC2rpnTNULDqb/8ed2YLcvLIJ9BtUTFufmC/drKQGdvLUpjV5pZ04o1B2uzULFwqJ1pLksoX4f1tjozNwRXJHdpP4b5ZHTCQSqo91Q0cK8jJTWirl+jJwZxvetA0l6so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dIVYljLb; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-69a0536b23aso185690167b3.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 04:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726053383; x=1726658183; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rZeN3m7JwHd+aiSOQFFXykrHDvl9NFzT+dwyqVmXC5I=;
        b=dIVYljLbDhJUYptPLiTqDqcC/sP1fKbYMXxWG82HHUpG8NBIgkjdLEGJXVUS0cJgjU
         uj9GkUVOnSltYD1t2Pcgds+7L+l3IygfA5LNriyEsA6ubvdJUFkXSWj2xp2fv+AE3eIi
         OL9UE8UxGfoSxLu8i6BCfjHiEsi3NeyfShVKcQbwMnVoHzk3VE3K4Il7nH4C2J+EZKZv
         cGgZZWSK9px18piAf0U5hlbYL+cKbqZ8/+PktEU6ilSC2aX0SFfQ4fCScXye40xOEJxx
         1ahZ0gV/3FnkMl6mHsuSiPFiZH8V+c5Reispc5GTek3oKh9MDSF6zokP8bS+TGCZpoLd
         vI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726053383; x=1726658183;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rZeN3m7JwHd+aiSOQFFXykrHDvl9NFzT+dwyqVmXC5I=;
        b=d64fbjX9S/o1lXEOje6MugA9KfkySngZKNZYteNzkG14tcjpRJTdtUfbmq1Zce7Ewu
         mTRsKgtZ6XxNH8NxqdCoBovtjB0PNwCj1lNayolIxVUBflNuELsLkE2/qiCvof21uzM7
         gCBz46YTvDJfVxw2q3I7o5bf2sL5HBFUNhrPt543e0VfjuE8x3x72uiglHoyP213FtLj
         8lOs6+dLpHdP/ncbz1aGiorgNJ5VGq1CDG8HeQVjQcXs3CQZI0hUI7f0V6zg2HY+d313
         WLQnCteijBlE+MktSEJWcaqgsSsctAbvaJU02kT87ZYPKAACwt9wIGdK+jmKrYsomJA5
         oKBA==
X-Forwarded-Encrypted: i=1; AJvYcCXBkKiuQkvLj8YjXsMd/mAEiwsu6cwxQv41ZMDzhF3Vlvv8FDjxCVPpKtpeguaKJjuM6nY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjs+wZSvJzGyp9+7S7TbpIq/y3wRatTC321rNkzmzlaTYZNMV2
	fZhripGLeIC3oNCG+HiKwCwW//8T1BJAj0JVT84dPBJgkEDx8D091lte0cpRdNp8FcWPnxoFoIj
	bzdlAvnmZUQ==
X-Google-Smtp-Source: AGHT+IFLsShVm8R7NpJci0/1+sfejlskACPnpCLygmEyKH0O7KOx81HYO532YTKxSmiWzym78Cq5wyJCyqBjWg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:23ef:6338:5fb3:dbb0])
 (user=suleiman job=sendgmr) by 2002:a25:df4c:0:b0:e0b:f93:fe8c with SMTP id
 3f1490d57ef6-e1d346b2ca3mr52914276.0.1726053383366; Wed, 11 Sep 2024 04:16:23
 -0700 (PDT)
Date: Wed, 11 Sep 2024 20:15:22 +0900
Message-Id: <20240911111522.1110074-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Subject: [PATCH v2] sched: Don't try to catch up excess steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com, 
	vineethrp@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	ssouhlal@freebsd.org, Srikar Dronamraju <srikar@linux.ibm.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

When steal time exceeds the measured delta when updating clock_task, we
currently try to catch up the excess in future updates.
However, this results in inaccurate run times for the future things using
clock_task, as they end up getting additional steal time that did not
actually happen.

For example, suppose a task in a VM runs for 10ms and had 15ms of steal
time reported while it ran. clock_task rightly doesn't advance. Then, a
different taks runs on the same rq for 10ms without any time stolen in
the host.
Because of the current catch up mechanism, clock_sched inaccurately ends
up advancing by only 5ms instead of 10ms even though there wasn't any
actual time stolen. The second task is getting charged for less time
than it ran, even though it didn't deserve it.
This can result in tasks getting more run time than they should actually
get.

So, we instead don't make future updates pay back past excess stolen time.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
v2:
- Slightly changed to simply moving one line up instead of adding
  new variable.

v1: https://lore.kernel.org/lkml/20240806111157.1336532-1-suleiman@google.com
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f3951e4a55e5..6c34de8b3fbb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -730,11 +730,11 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	if (static_key_false((&paravirt_steal_rq_enabled))) {
 		steal = paravirt_steal_clock(cpu_of(rq));
 		steal -= rq->prev_steal_time_rq;
+		rq->prev_steal_time_rq += steal;
 
 		if (unlikely(steal > delta))
 			steal = delta;
 
-		rq->prev_steal_time_rq += steal;
 		delta -= steal;
 	}
 #endif
-- 
2.46.0.598.g6f2099f65c-goog


