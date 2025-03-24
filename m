Return-Path: <kvm+bounces-41849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD663A6E169
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:47:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A9551897696
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84A426E162;
	Mon, 24 Mar 2025 17:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x9hBxvAe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1867326B951
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837629; cv=none; b=cfAAN2iZcj8teWp54KjGjZf3FTC2AfiGKcEVYlqf5AjN8qExunDzvC/87awuOtYvsQlT1ZBNQ3cIuRjXBk//CUSOopge+PY28V8zuEd+OBasunAmUogqr65UuhxscpOZcK03G8PtOLuxQ5ZiZetGdq25ER1ILkCyOJee2aY3hXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837629; c=relaxed/simple;
	bh=uxeRSQhopIcLqUg/0mbD+aBrEYrjz1kZmjC8RvnoPKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dhQiKyqPsv5vt7tuEZEPDRKtK4irk8MxcZMYFPpp7ct1hG45blx2VMsxN6PLi4XIdr2Wmgx9LaU9PTl9ox5fOhAnoxcdXEFP+y/v2ed6QR3qOaf385BxCdDNFb6H8c3Tt1r5J5p18KlfRpt6Tn/ReZqwZXXYTlB1o3+Vl9w+gyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x9hBxvAe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff798e8c3bso7881407a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837627; x=1743442427; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QRjcPleU/6UshS7jqyhSRtB7XVQZnZWYVsb4HkvaGz8=;
        b=x9hBxvAefRw81hQpG4KyXtRUJaASsi5qsBnTv8pacP8J/iugFUOgy4XMpv08JLFe8y
         fEWKp+sU650Z3At4nxG4chxuSKhzCMuX2FGb6xS7LQpaObzFwtSpHVaJQx4fgZZJdlde
         j9AVlpIipASBfJdTMBETfz1iJEqR8tHs/o1I5mATU2eE1vkMK5qvZhK+JOyTsXYkjRlf
         nFY7fkuFezymKKXCO4Y52OFThnPxahSwmsYT/wwcYfIqImJu3b3As63Oy5Jy9YW1dV37
         hXxCadh+Ko5Kjo8MZ/BnRCaQcH99kSd4y8whA4uG0Ogs20HFMnl2hnec0Oxh3bsE9fFw
         73sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837627; x=1743442427;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QRjcPleU/6UshS7jqyhSRtB7XVQZnZWYVsb4HkvaGz8=;
        b=jG792fezRAkqyqrT4AWoUIYBQLa6NPeo0oVfz4odN4pgqynQRKW6c/EWH3KmDGjFY9
         +hSwjQXLc+FAjDPdNxZxt3SO8ye1GMKrM9tU1NYgKaMiryEnBC00YF3QM543sJV1cuIg
         azQy4F4Kjr0gbeiSJa4+ZPmgFkzC8JShyo51W44C0/9kDoG8PdJ0Vx1o/fsyR1tiLP7v
         t8jrprAviBrQ0QR57ywWJIaob2s5pgq2eR5Aj1KHuuslZCLJs0dVGuhqancACgu/Imww
         qxjXbBAHVGhHS7xwY7RnbW1ArNlA5s4l4z9izMlT7ixczl+0Kk0MWm3yv4qhpVU/Fyyc
         3gqA==
X-Forwarded-Encrypted: i=1; AJvYcCUlit6Smk2Vwo6pptzKmTC5X3wfae1FbGRvBLSk/NcfmGVnR5ZK2mjcJpdp1DLhd9OdssY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQs3APNKEsBu/v14kja5Bf1YvYxpd4vvBSG/dm8yvwvy2wiY83
	L84KVpjuk8BtKMQEwmwS8FqmU5RYLW6QftAWFOO8ZGLobAnnzzhaN127FjLU9vlLCdSc4c0QExH
	gABnVBw==
X-Google-Smtp-Source: AGHT+IEuHjs/A2Re3ck6QJTqptDV7w7AygF6gEwnZPovDIhyUvEjjPjQgZu8Hydk3XXYIRv6LtyhIJkf9PiR
X-Received: from pgmh3.prod.google.com ([2002:a63:5743:0:b0:af2:54b0:c8d5])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a1e:b0:1f5:70d8:6a99
 with SMTP id adf61e73a8af0-1fe42f08ea1mr21842848637.4.1742837627379; Mon, 24
 Mar 2025 10:33:47 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:31:14 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-35-mizhang@google.com>
Subject: [PATCH v4 34/38] perf/x86/amd: Support PERF_PMU_CAP_MEDIATED_VPMU for
 AMD host
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

Apply the PERF_PMU_CAP_MEDIATED_VPMU flag for version 2 and later
implementations of the core PMU. Aside from having Global Control and
Status registers, virtualizing the PMU using the passthrough model
requires an interface to set or clear the overflow bits in the Global
Status MSRs while restoring or saving the PMU context of a vCPU.

PerfMonV2-capable hardware has additional MSRs for this purpose namely,
PerfCntrGlobalStatusSet and PerfCntrGlobalStatusClr, thereby making it
suitable for use with mediated vPMU.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/amd/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 30d6ceb4c8ad..a8b537dd2ddb 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -1433,6 +1433,8 @@ static int __init amd_core_pmu_init(void)
 
 		amd_pmu_global_cntr_mask = x86_pmu.cntr_mask64;
 
+		x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_MEDIATED_VPMU;
+
 		/* Update PMC handling functions */
 		x86_pmu.enable_all = amd_pmu_v2_enable_all;
 		x86_pmu.disable_all = amd_pmu_v2_disable_all;
-- 
2.49.0.395.g12beb8f557-goog


