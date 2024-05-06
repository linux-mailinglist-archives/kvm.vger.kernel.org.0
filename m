Return-Path: <kvm+bounces-16658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6AE8BC6FA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 175EE1C21171
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27790482CD;
	Mon,  6 May 2024 05:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t810ES2/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1680313FD91
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973516; cv=none; b=rVYmFdWSPqrtoFVcgU21SGgVrW4/nLavIOwiEmhEMa+QQcsBeU23mmgg1BmWiNmXIxj863aDwVGNNA+2du4zp0s6RXeQoZsE39dnX2SRb/3hlEjb/zk2HuYNzj6amh95AEddNfDaW4kwhsnhPkQLsjSDQ+I6dsYVg8iq7JpL5I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973516; c=relaxed/simple;
	bh=hYHJs9v3pADKP6kDRWPxKlGprXJTLz69FbXvygErydg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iQmlPfdyk96a8YgtNZZ0jvoEAjtGidlk088jn++juGPv7E/paBAni3f1ICpwTSCdmaGLFm4xCSc2Zri2muBDWiJC6lLTfdcnn54/VVzSwLLP4CiPY7LDg43jZJioHMuyn50YN+Nx8AjNGBdo9ehf5Bk8qdtlw9DUIxl3D2j4Avc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t810ES2/; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de8b6847956so5603101276.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973514; x=1715578314; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=R3btYVSbOUUUG6wvVgZKK1IzrRe1w7aTXikAYvX9oRU=;
        b=t810ES2/PbGQwjSdzDCPo63xfYQC1nTzbnPyT9T7AKeLmncETNvUgfPwk3lk/GHeCq
         W6P8C+u2HiapPlQyxHnwnNxAOjtiLRsLNS5Ghnnv6MPHZXOaZb406Hf/7l8672PbJ30H
         gktSbBExPsTyCWkbkxAWnOgsnnO3pZ+dxzVmvypaB4MHLuiThwXG8k91Ag4Btre97ONo
         GUMYOzdhFP59GUWa1GiDsG8JXrU5aRUo44g5rlOTyZDBhdHjrL6bIaAke//wptRdfS/o
         QvpDKWf9++ZUrwlMQ0BMa5xL7DlWUxM7Zplw9uT0sDAcxNfopTI7HpoW6ivaKmbxStx0
         grNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973514; x=1715578314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R3btYVSbOUUUG6wvVgZKK1IzrRe1w7aTXikAYvX9oRU=;
        b=B5ieiHlWBDYy8QJDUZEKuBL6yzuY5K7rKN0F33ChRNYS0ZbRo5D9PEY74EBgGbNvvV
         0P5w2S2/vlCTHunN8iIRaTEOkUU3vp7HGRamzI0wvqO7OWtEn+Y/DuGhZLtlQ/VMSwEv
         YJE9UOPlAMSuFU/pDcqwsw5o2Qj7wQdp1xEcbAX3KQ0WFFAv+U+Cg2Kehb3H1NhAswEA
         q7L/MOu1Tm4Xkusto85eH22Yx904YZDRmvLdObN4PKC2pttasTCKryy2jYx8KLpsQAid
         EDnJJPPrj3h15d4hWQYq1sPWpm7XgdMQnJPj4LMarWsysNf9kfN3ZiBYstRmeM12ROJb
         sX8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVwA/CGnIuvRtF9qv15/iAIEHKeir+LQMuK2Bqp4Y0k2IzCRwJMHHjEDUao5T3tdamzX7cSkORJgGvBjnXzTGlVlUeT
X-Gm-Message-State: AOJu0Yz6Dd9ABXCW22d1jrmT8WysARn9SDlZA9KAi7uO0jmH818tnvRA
	lnErcaekQ0q9OvK+lHyCzYKnju+UBpNA7I1ldqxTx/nB4xxtygWs5xhmjvHkL4m7atQavi02BLv
	5upsaFg==
X-Google-Smtp-Source: AGHT+IHYtAKETaSkJtaWjBbjSZv1PW0dYkKkjX2kkHnO+ZOXalrSCVSrUqbKXqRrINppkxEB/rczGUaFb3SL
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:1505:b0:de5:9ecc:46b6 with SMTP id
 q5-20020a056902150500b00de59ecc46b6mr3476037ybu.6.1714973514144; Sun, 05 May
 2024 22:31:54 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:11 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-47-mizhang@google.com>
Subject: [PATCH v2 46/54] perf/x86/amd/core: Set passthrough capability for host
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

From: Sandipan Das <sandipan.das@amd.com>

Apply the PERF_PMU_CAP_PASSTHROUGH_VPMU flag for version 2 and later
implementations of the core PMU. Aside from having Global Control and
Status registers, virtualizing the PMU using the passthrough model
requires an interface to set or clear the overflow bits in the Global
Status MSRs while restoring or saving the PMU context of a vCPU.

PerfMonV2-capable hardware has additional MSRs for this purpose namely,
PerfCntrGlobalStatusSet and PerfCntrGlobalStatusClr, thereby making it
suitable for use with passthrough PMU.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/events/amd/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 985ef3b47919..7a91c991779c 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -1395,6 +1395,9 @@ static int __init amd_core_pmu_init(void)
 
 		amd_pmu_global_cntr_mask = (1ULL << x86_pmu.num_counters) - 1;
 
+		x86_pmu.flags |= PMU_FL_PASSTHROUGH;
+		x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_PASSTHROUGH_VPMU;
+
 		/* Update PMC handling functions */
 		x86_pmu.enable_all = amd_pmu_v2_enable_all;
 		x86_pmu.disable_all = amd_pmu_v2_disable_all;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


