Return-Path: <kvm+bounces-31996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F90D9D0873
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 05:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 575501F217A0
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 04:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFE313B588;
	Mon, 18 Nov 2024 04:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jjn9TKqG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22801EB48
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 04:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731904709; cv=none; b=j7c6cWrvX+SVopj10WGrBhgqV8kXF7qna4iVlHVJP0oM96CWmjQ8PvkhMYpm7CxQjqtuW5leYQxj9bsVT9HCDpQHqYqYFdVaq0Wo7GgmVsoWZWVt2FpRlYeEuJFVrfGfXBbjsBrdpYbOIGSsETwM6en6cK989zP1ffWCpQmi2wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731904709; c=relaxed/simple;
	bh=t1DV9+PJwntk8JsKXT8IBFfY683A0ef74HmUZOsGwu0=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=cCbgv5ol6l4lPn6IBkjF4GXXT1ImU4MYuHm+VeaByzllsr8dF4765wai9QJY1zTR8pj26jaVfMdbS84bUU885kaXb8Pl1zTkfA1P7dqrtVB4t39FWvi4YOVkafYRMQ7+ktl1fbv7rK5v2sCQTBoliXK7Kx8LWCgDzOumAYsffIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jjn9TKqG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea9618de40so64904717b3.3
        for <kvm@vger.kernel.org>; Sun, 17 Nov 2024 20:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731904707; x=1732509507; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JQv8I3JIxaU1/rgjHqPaWuqVa3AWWbnCJTtTeM4ESO8=;
        b=jjn9TKqGZQANXWzJFdS2V5ZD5ZDINBjfaCAj+qnnHxlJ9S8XnbMEnnJMfix+T+FVp6
         i4rrcQhjZAuZUEEsWt6zXMv48dklJQDZmdtXk4G4otBcIiQqnSXdtCCxh147i6f03Bjv
         pRY1IxdIXYm74l+8RbxStAcJ55K3QOqdfcKXLqXx+AcVZon3DKvV7acnkaPexSr8+mnx
         QhU7/zSvV00OEUGbUZf7Z4xgkD1oO3IPhDk6b4MILaMvJ+Knb1EURo+urKik65YQJYZO
         BGlaQxgQmATrFtBrxYrXYVY03mUVuAOStjeR4QYYrQXD3OxC8owaN1Pe2H1iZ676KTiS
         B10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731904707; x=1732509507;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JQv8I3JIxaU1/rgjHqPaWuqVa3AWWbnCJTtTeM4ESO8=;
        b=o3Ij+sAR4SPlr1J5LmSaJl42ab7bQhdcJOwgKOwwkk76y/RqUfIg/f56f8lm7Ne5UW
         LNv+vA6gdKwFSIKFVZwZ5vUh9BBD4QA+8nNi+prmvwzmlGz1LmKKF4I5N7vaH/N/0lpp
         yvZEO0ksNhskeiHW1Jvieb9kImT7+ookr5iAok7w/POLR9zoTpzxx9SAmtxH2xEAPVJ8
         PyGazKQpJ88yas+j/h5QOt9OppJIngtdftv6GZz8+IGSUpE8i6ihgeqWc40GWpXtEwCL
         ip8YZONF7zyyE1ib/0/qXqWjk81Nz+6aI49to+WThOdoaBd/eB8e6CKD0VLE2EFIn349
         nGHQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4lly+bCASGP5Qn45RYwqqsqY0PRsxPl06B+7s8kr4V0iNhig5i4ylzuy657WmXg2d2VA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzuemhUIZi1txSX+6mQvOmeWsbUAJmn4nODccFyzQGm7dadNkS
	QX9OLwiq92trWudKTQrn29kddNlbvkV5tgJepwOkUaf8b7W1U9RVImodBPSGPm3rnbsds5s+q83
	v7y3AeqsSZw==
X-Google-Smtp-Source: AGHT+IG/L7EqsoR1sfX/shhNBpQ4HgVRA9GeBU49j7fNWohg7uviubTV5M/BOrxjTQEpcnc2LCXFSHLhg2XoWw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:ee32:7944:d9d4:158a])
 (user=suleiman job=sendgmr) by 2002:a05:690c:808d:b0:6ee:3b47:59a3 with SMTP
 id 00721157ae682-6ee55a553d5mr525797b3.2.1731904706871; Sun, 17 Nov 2024
 20:38:26 -0800 (PST)
Date: Mon, 18 Nov 2024 13:37:45 +0900
Message-Id: <20241118043745.1857272-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Subject: [PATCH v3] sched: Don't try to catch up excess steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com, 
	Srikar Dronamraju <srikar@linux.ibm.com>, David Woodhouse <dwmw2@infradead.org>, joelaf@google.com, 
	vineethrp@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

When steal time exceeds the measured delta when updating clock_task, we
currently try to catch up the excess in future updates.
However, this results in inaccurate run times for the future things using
clock_task, in some situations, as they end up getting additional steal
time that did not actually happen.
This is because there is a window between reading the elapsed time in
update_rq_clock() and sampling the steal time in update_rq_clock_task().
If the VCPU gets preempted between those two points, any additional
steal time is accounted to the outgoing task even though the calculated
delta did not actually contain any of that "stolen" time.
When this race happens, we can end up with steal time that exceeds the
calculated delta, and the previous code would try to catch up that excess
steal time in future clock updates, which is given to the next,
incoming task, even though it did not actually have any time stolen.

This behavior is particularly bad when steal time can be very long,
which we've seen when trying to extend steal time to contain the duration
that the host was suspended [0]. When this happens, clock_task stays
frozen, during which the running task stays running for the whole
duration, since its run time doesn't increase.
However the race can happen even under normal operation.

Ideally we would read the elapsed cpu time and the steal time atomically,
to prevent this race from happening in the first place, but doing so
is non-trivial.

Since the time between those two points isn't otherwise accounted anywhere,
neither to the outgoing task nor the incoming task (because the "end of
outgoing task" and "start of incoming task" timestamps are the same),
I would argue that the right thing to do is to simply drop any excess steal
time, in order to prevent these issues.

[0] https://lore.kernel.org/kvm/20240820043543.837914-1-suleiman@google.com/

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
v3:
- Reword commit message.
- Revert back to v1 code, since it's more understandable.

v2: https://lore.kernel.org/lkml/20240911111522.1110074-1-suleiman@google.com
- Slightly changed to simply moving one line up instead of adding
  new variable.

v1: https://lore.kernel.org/lkml/20240806111157.1336532-1-suleiman@google.com
---
 kernel/sched/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a1c353a62c56..13f70316ef39 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -766,13 +766,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
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
2.47.0.338.g60cca15819-goog


