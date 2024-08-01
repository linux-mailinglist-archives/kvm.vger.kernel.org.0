Return-Path: <kvm+bounces-22836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E65A94424F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 06:59:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4062C283E3C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 04:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D587B14374D;
	Thu,  1 Aug 2024 04:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ViFeccXC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D38142627
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488359; cv=none; b=oxMHVVQJqvbKBdFg5chOJG7qYSzHAib4fxwfW35BMOzyFPsc4ei7WhmW2WXpTQse8P37SG58mFIhDLPhJ64J/rRqzu+enKNok7n7dGF6oK7TnlwDkRO1RpAGVU1sTJqP0FEFLPftMUjOinGacH+sIQHlm4L93wKh0J893BhKn3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488359; c=relaxed/simple;
	bh=ZvGS+oj4XuLPg8nuEXUEAPuSbcPZ0/B3ZPBcvTQ6b6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BF1tFqZa+D5SHIeFP+irotBQ0R0n7fVZC/kChDPE5ikUq0H7c65tDGnrswc6fdTibfYIXfghQr8lcQlsXY8vA5BbN9OSawbklhlsA0B5jCyqt5D6noUOLG10d5w8HtwXlMdDumk0uLxc49l5vEcf0rsMfOv9jDAghYXAoCsrwVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ViFeccXC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6818fa37eecso6938718a12.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488357; x=1723093157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1xyyU30celNRJ8DLWsDy56YEJTFb2rNjwWtIE7jVfbg=;
        b=ViFeccXCE5NIewqn5sltPfgVd+IGJztbPUuypoxLXvTQbzxaEw6MSCZnWOSQb8XqGK
         TCOaFVwZ5oOpNjmrZd+NFl/MkxcMyJpTOtUjNx1TR57g1oNT7YiBhmyV+ff6Wz+ZTdUO
         1lVDuhooMKvJCtfLI2E4CFimYmMURQ3SWMM5OvlsDkXVsesswmi89frsQEog4yKhqZ2J
         z3Y6zmXFxTLG3Ro6QHYVhWoin7osM7RgJ3BgZSuZAbI2UKOQqglKAQLX6Sz2UqNHiZPQ
         3flo4b6SiGDmWMT5uF3IQFFt1lRoQmy66uKma7OuYhl5ZAMsWpoNQcrptabB/tIV8Is9
         8hcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488357; x=1723093157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1xyyU30celNRJ8DLWsDy56YEJTFb2rNjwWtIE7jVfbg=;
        b=EALtby5ZNGTn7RJoQs94JUWFol6cH5Qfez/K3db0u7YTtQ6bZ2Y1nbVzhG/mnJHed8
         BmiTOLQbQ4AlfaLHyeol2KBfZ+lcQ7bbxPmnbl/q0i38NBI0Jbzgni2KYmhDMYE66JgC
         +Wi8XQ2450wa3kffsn+XpLpHoXuSdan15kpmHYfXNOEDRsx0AXPwAiQcwohbrnbCvf9t
         i637VKxhfa3aNUwQaGRIZALRr6K/2UynuCJqt0VlSmnZVUE2yWKTW9EKqn6/EY+m+xtg
         edTz82qPvhbZ+5I2x0wf0JGmb9+sN2wnsDRdWdQe5WJ8RkK88bjjyvuyqsIar+DQEsGg
         l76w==
X-Forwarded-Encrypted: i=1; AJvYcCXYJNSBf8OvTOtd2l/3N9n3/9CXlEiCXpZhSLIILDR4h9sD5K0nvpcKbAxT+G8ORconpAiTkdZN6Jquw7zteG1ZKEx/
X-Gm-Message-State: AOJu0YxlxMkbgVEDDy3u4Siyo77DcsW597JC/tnbJ5waKpcsDHtT8z3f
	gYTgc2BTMno0IfL+mWGk0IQlm8e+yTDtyRWfjDiHo/1XPW0hWUWLIAY1b60yCRtjBsAbDaArUkA
	qDCGNyw==
X-Google-Smtp-Source: AGHT+IFCfoz9h6lJmm/P5SbMt/spaprFBzE+plqdpnUgcDlwekzgDeUVyAcFT3/5A6VAv+kI/DyBylARHwev
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a02:50d:b0:694:4311:6eb4 with SMTP id
 41be03b00d2f7-7b6362f4786mr2600a12.8.1722488356855; Wed, 31 Jul 2024 21:59:16
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:12 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-4-mizhang@google.com>
Subject: [RFC PATCH v3 03/58] perf/x86: Do not set bit width for unavailable counters
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

Not all x86 processors have fixed counters. It may also be the case that
a processor has only fixed counters and no general-purpose counters. Set
the bit widths corresponding to each counter type only if such counters
are available.

Fixes: b3d9468a8bd2 ("perf, x86: Expose perf capability to other modules")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 5b0dd07b1ef1..5bf78cd619bf 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2985,8 +2985,13 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->version		= x86_pmu.version;
 	cap->num_counters_gp	= x86_pmu.num_counters;
 	cap->num_counters_fixed	= x86_pmu.num_counters_fixed;
-	cap->bit_width_gp	= x86_pmu.cntval_bits;
-	cap->bit_width_fixed	= x86_pmu.cntval_bits;
+
+	if (cap->num_counters_gp)
+		cap->bit_width_gp = x86_pmu.cntval_bits;
+
+	if (cap->num_counters_fixed)
+		cap->bit_width_fixed = x86_pmu.cntval_bits;
+
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
-- 
2.46.0.rc1.232.g9752f9e123-goog


