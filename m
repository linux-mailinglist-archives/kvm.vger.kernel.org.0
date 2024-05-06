Return-Path: <kvm+bounces-16630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 369E08BC6DD
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67FC81C210AE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61951422B5;
	Mon,  6 May 2024 05:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3p51e7h+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C481420DE
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973462; cv=none; b=BELXNY8wmOQERYyI1j0Qbvnh3VM5lAxNQkUMetZAYjs22RVCZgCTfPqAM9QBetYrIeW/mqG5+SWxgvHZdrsldUILMdauHamooZABoYYcEXRtCf0+cwNpHJ4te092JWy1zwrjwBv/ihwnFWmDx2aR3UG4WiYJrLBJrSjqtp9aX1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973462; c=relaxed/simple;
	bh=minTSL9XqHEpIVjTC2PQRW4L97izhLeLHuOSnX5dCBE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CfiVrWi+b65MncDo6Epuo3E6PuWQZUTIs0UwFcEVEPeKxMW1UZQzlBDLkQqiyjGaRm3u3Gpab4gSMxJ+LZEwlFYuBAM/CTojK8WgSsS/EoeOP720+OSP5F2GhsUCQRuvitn+n0HKVoJYkvFN8jzuluDeafVGowM8ViY6bLa6+Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3p51e7h+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2acf6bce4cfso1197641a91.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973460; x=1715578260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DMSkODsG7t5yWnGmB0n44Dj2lacu17Mhk7BwCmJOvKA=;
        b=3p51e7h+7u0iwTSqmag5XM7suGf9AXLz8l46lXbDUXLhgItyszyr75q1B9upGgc+e/
         EGcHJyZrEHUmApi+gFFv88rpkZWu82vwEDqgbhu83vIUyUrMmtr/xzOBsGtIWXziqram
         Ljx5MXNCh3G4daGkdWaFs2t0Ey8uN1VHeAPwWRbgPmEU0KLle55q4TTjUsAZFGV4To69
         xkZKN+nUYN402iVLwwq6eA/JF/vBqDiCLA0BIGacS50LL3IqhKXXn7vMjxe5OliSVhF2
         iUaBpqqVQ+qJWkSc2tRPjvPsGbjy8Fi5y2/Jkyo+K0nXOhTBsHjb39mRwdcwPmmTL48a
         4mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973460; x=1715578260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DMSkODsG7t5yWnGmB0n44Dj2lacu17Mhk7BwCmJOvKA=;
        b=Bgk0ZDg1rx9qZytQc3NePkBUswzETGRZX5O+fFM7cwU3hgj7MjT8eCisS0tVk8+9JS
         asgkdbzHHHIPyuG2DF9tJbF6ZQEph24+Vi1WU1LTczQvtBvIhB7Eyk1EPB33L42JLRTF
         XdA/eiyMfrBaZgbT0AiK9lWmkXSmGQq43hw4UpZBRZyC/dy4RyFfjfYZ4asA6+iYQ1Xu
         MwjLni1QQs3z7TbmA2KOMXHmsoNkEd2AMvDrXw6EElwy1+TRHZ5ugmvjvNOs0ZKpaEg8
         76NzXnUuFjHd6fax67PGc8mBHS3hxkBxEbr2i3HaRGZy7v/uCTdL0H77dZIgVQMuMg3n
         H9jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvhjDdMnwUFDn7s5J5cweiK0PsSISbY7i5QuoY5KjkwTRD/qjcXT9IxLphbmlXr9A2iVo94kRAnt8516jLlbNghzcA
X-Gm-Message-State: AOJu0Yywdi0P94E4aBcfU7KO2z7wjvrz661bXENXFJFuuVnNQioi7uYg
	4vQW53nV36kTwlBiDfpH1A+GrYtO76lAZpwcaujDjHOEoz5GX1hXlr4Lx4+AoScL/lDmqADlg2X
	aEiWqNQ==
X-Google-Smtp-Source: AGHT+IGVAUyB6MHqFjd2ZrXXirE+zSCX3EDDFExYLi3qdObYKdk9RYe07S4/VPk6JzALE+CLT0k1NZtIOAbh
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90b:2302:b0:2b4:329e:ead7 with SMTP id
 mt2-20020a17090b230200b002b4329eead7mr30779pjb.3.1714973460060; Sun, 05 May
 2024 22:31:00 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:43 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-19-mizhang@google.com>
Subject: [PATCH v2 18/54] KVM: x86/pmu: Add a helper to check if passthrough
 PMU is enabled
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a helper to check if passthrough PMU is enabled for convenience as it
is vendor neutral.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index cf93be5e7359..56ba0772568c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -48,6 +48,11 @@ struct kvm_pmu_ops {
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
 
+static inline bool is_passthrough_pmu_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu_to_pmu(vcpu)->passthrough;
+}
+
 static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 {
 	/*
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


