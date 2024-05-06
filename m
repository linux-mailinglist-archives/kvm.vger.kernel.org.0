Return-Path: <kvm+bounces-16663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA968BC6FF
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:37:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F7351F23903
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998FD144D1A;
	Mon,  6 May 2024 05:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rm3MYkgD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD31144D03
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973524; cv=none; b=KsptnesNfs9ASPCogHqgoB//2MW+17tDCviILYtQ7jSt5/c+Vkbx91n7UDNzrc4w0zmisn4/uIf3O2BADD25QbhnLfI2zvVLBjblD+YHTeb8hWGAa9W9t/cum9E7GZ4x8iKzowekzPVMZs/l2D8IE91FZwh9DqkXFPBehbDF8aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973524; c=relaxed/simple;
	bh=2TAE4qlq3GDNrvgbc8mZAcqg26xaguAw16L1tX5hnBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SCzKkBV6ovHDPB/Sx0KaUNBYlgVZZbo2fMdGbnLEdOnwtFRqxG7jj18wJTN4RJmvaxVZU9g0Z+TJeOfoWFYmUSX9qMIEbiUd+yxr+q0Qb1kWUBlJqO+lV5ZAvHCO7mRoqbD7W+fMMfBvV/Lsj7FyR/a0TDgqQvFuBKa1R30Yk9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rm3MYkgD; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-61d486c9430so1456229a12.3
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973523; x=1715578323; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NNQwrl+soN4o++BMIchb3q689/b2lkY6JBS37xEudIE=;
        b=Rm3MYkgDObTbz5Z/ciawkukxkp1Uujhk4nNgc34S6dgXMql8M55tPkM0OASy4Sskqd
         TlZOZ2SHNQ5YVIgXt33R9S6PDyBKC95Bj/qvJJXvNNX12F1uA/4UEgDhk8RGNtqe8tTB
         5cMlawTMRMvENzYAqXf50RNLfBHoPhZADnkOHVLIHsk/jW22C+zDEWnbCKiJjanGXpRe
         qXAmEPCLKT8jCMWgB+7cGOEL2P2b3KWc8Aq0nVVYu9iOl7mlU3xQx581BHCvuiVq/w20
         vTm1ObbUh8+pKg/jYnVhArBIlE2WOeMwnwgR9e/fNh3YZx0obK/etcSksiVBW5hPcqFN
         Iweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973523; x=1715578323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NNQwrl+soN4o++BMIchb3q689/b2lkY6JBS37xEudIE=;
        b=Yz9wOYjdJ5zmOe7dNbi80xrE4bdWcptHqKDpw/2t8oJif36F1S47uuoLHzrnsqf9aU
         WypAorkm81jniF94y/t+XtlMRKszjLiuFnNyPE7nLOPfTJWXeF4QabIIkTnYhSX+Zrs5
         8oqv2VgmpctSR0gYF7nH69EAPNmrQdW1a+SaEKn7V0K1sMq30aB4S5CEZ5DCSKBX5a+f
         3sqLWLv3ZiswPQPbt+717acUBmxMx2/Bgh0CojlUG9bigFyMkJb2mTyQYrNvW5DpzD94
         md2euds/Z8Y3OICLhA1aSUgLo2jNH3JgdrRcTC7VG1DEOJor2aLxB8IdZ9t61af6vJc5
         Zq9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLjhsYxf6rIRbAxG69YkRMj/rSQ05csfdOyARlaRm5fTdpxdBrLkR8dlTtcMrSj2Fzvs5+AUc4zKY2AXUZBu4v0o5s
X-Gm-Message-State: AOJu0YymnFIwXPEYY134eZMkmWUC5l/MAGZhRns440CKXUHxqpmijDLB
	NJtwe2lMVPpZAr3wox+1G0fKtFCJw8l8a2YNOOibS+XSb+b8EwEg/vFwCe8igtVcchxE/4bBJc9
	b9P58Bg==
X-Google-Smtp-Source: AGHT+IG1j+qdQr6WFe/1g/NjE2LppxjI/ZVH47N5+rLXh6X5mwGn+Gm3SiFSy/9eWWI+HEG2U0HimLGiDr1L
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a63:7151:0:b0:5d3:3a61:16a9 with SMTP id
 b17-20020a637151000000b005d33a6116a9mr22296pgn.12.1714973522875; Sun, 05 May
 2024 22:32:02 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:16 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-52-mizhang@google.com>
Subject: [PATCH v2 51/54] KVM: x86/pmu/svm: Set GuestOnly bit and clear
 HostOnly bit when guest write to event selectors
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

On AMD platforms, there is no way to restore PerfCntrGlobalCtl at
VM-Entry or clear it at VM-Exit. Since the register states will be
restored before entering and saved after exiting guest context, the
counters can keep ticking and even overflow leading to chaos while
still in host context.

To avoid this, the PERF_CTLx MSRs (event selectors) are always
intercepted. KVM will always set the GuestOnly bit and clear the
HostOnly bit so that the counters run only in guest context even if
their enable bits are set. Intercepting these MSRs is also necessary
for guest event filtering.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/svm/pmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 2ad62b8ac2c2..bed0acfaf34d 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -165,7 +165,12 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			kvm_pmu_request_counter_reprogram(pmc);
+			if (is_passthrough_pmu_enabled(vcpu)) {
+				data &= ~AMD64_EVENTSEL_HOSTONLY;
+				pmc->eventsel_hw = data | AMD64_EVENTSEL_GUESTONLY;
+			} else {
+				kvm_pmu_request_counter_reprogram(pmc);
+			}
 		}
 		return 0;
 	}
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


