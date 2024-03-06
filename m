Return-Path: <kvm+bounces-11218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A136C874362
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBC8C1C20B25
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC691C2BE;
	Wed,  6 Mar 2024 23:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="syM4/D5m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA801C6B7
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 23:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766125; cv=none; b=sASuPmCLFwdJl/yuOEsrvQps3UDKHRncu/1xYZzuVK94q+1HjjOleI5/w+KHlcOgREDAIxugo2CxUskn5V5mCMDuFhGVp+uQsr42zWlWeNTx4T4MG98f/TW2MQAnL3MLO1Y7OGtfRMwkxDF4LYbOlGRoSINZ39Hl+J5XIzkxRAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766125; c=relaxed/simple;
	bh=sCGQq+L5TRfuuFSyOqc97FqDvo4ksUorGfUG+ihRbCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KkdkKWzgmrJr6SNjgfHAyBELNHxdRmaBnWmH6gh/naWXgZ0in3oJVPJZC1t+Fvbhnm10eYUc761psH3LXKs+5Gm3mZFUzohXh7K8K/dYNhQY7UQfkY02s9wl4wpJgSllbDwxNNWhBpI5h0V9bhF6TWyx7b/oQ/v0D7qzKL7pTFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=syM4/D5m; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ceade361so358402276.0
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 15:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709766123; x=1710370923; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DoXKF70ijkN5/EgZ39hZNeVXgbsILGyaQ2QG5g7Hfc0=;
        b=syM4/D5mUID6uyJNFn/A8zwkNJCchOR4E55DmFWIX3BRhXrnngLlwPEGaLLKrv8cD1
         HQ20PQKsOJjJ59+SB/84hdFqseDAeSOOO7jL8xPHgjCQRBUHX2kvrObTbMl++UP5Fmus
         HCv2DXtuiehq4LVg6XPEy3ETDv8kIkNxzsDMvj8iE+59JpUhqEyvRDNhxt8OdNA3hsBR
         QJgIQzoatHR6MNhGqJH5qsxNnch/F9vUjnByLKmTOa5oWhJXXneKVz+BxhXIiw1x4t4t
         W6VbKvIJsyfY7LyywwUSX26jCXcmjOAYryZFYRV52oJbjdVw++e9eXlt4og95/jLCcwa
         RdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709766123; x=1710370923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DoXKF70ijkN5/EgZ39hZNeVXgbsILGyaQ2QG5g7Hfc0=;
        b=NpMk3knIUad9TNlmkXSSIhTBq8XMgafIcmN7P38uCRiKC9CLdRfx2HoZouIC9ZnsoE
         f30qAVJ/Njw0qcZ8TK56FLb/NWo/mjXY09zqhq1iV7FIknhtUz55nwqilHrAW5O1Wm5c
         WVa75ihkWjWEAdeNoEdGk7FEVkDwDIpBjbk0wIbsdSWf3176blydRDKtQA8Kyz8ykc+A
         OtpHqElz37R/X98n9IM/3W2ZXyvN7mq3AeT3fJEffqJi3KRdN1WreItMifekX96xH/PB
         y8b+jY6E8kvjCiHHMvlU+MpYlg2qWyELZqXDC+4hMzwjsa3wI+OY16SGQAgjfOheXZbX
         6Gag==
X-Gm-Message-State: AOJu0YzQIqfjGhD9M9BYwRGgcv/jEh5X8j9E5LMrf0GwEtTdp2ORj60i
	njrNet6mcqdhAzAzIIZaL+JMW6tnZcqcfuTzd7zOTOowfYSaKcNQFlMqDuLZI/s3tHdAdzNXvYI
	/6A==
X-Google-Smtp-Source: AGHT+IHrEFAkk2G/TpVL2FmqnD/5rGf49DH15YCmjWedL2HzehsTkBLBPJUXmDj4T87RPeXYj4he47odKGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1744:b0:dcf:6b50:9bd7 with SMTP id
 bz4-20020a056902174400b00dcf6b509bd7mr4155082ybb.7.1709766123364; Wed, 06 Mar
 2024 15:02:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Mar 2024 15:01:53 -0800
In-Reply-To: <20240306230153.786365-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306230153.786365-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306230153.786365-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 4/4] x86/pmu: Add a PEBS test to verify the
 host LBRs aren't leaked to the guest
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Lv Zhiyuan <zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"

When using adaptive PEBS with LBR entries, verify that the LBR entries are
all '0'.  If KVM fails to context switch LBRs, e.g. when the guest isn't
using LBRs, as is the case in the pmu_pebs test, then adaptive PEBS can be
used to read the *host* LBRs as the CPU doesn't enforce the VMX MSR bitmaps
when generating PEBS records, i.e. ignores KVM's interception of reads to
LBR MSRs.

This testcase is best exercised by simultaneously utilizing LBRs in the
host, e.g. by running "perf record -b -e instructions", so that there is
non-zero data in the LBR MSRs.

Cc: Like Xu <like.xu.linux@gmail.com>
Cc: Mingwei Zhang <mizhang@google.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhang Xiong <xiong.y.zhang@intel.com>
Cc: Lv Zhiyuan <zhiyuan.lv@intel.com>
Cc: Dapeng Mi <dapeng1.mi@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu_pebs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 0e8d60c3..df8e736f 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -299,6 +299,19 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
 		report(expected,
 		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
+		if (use_adaptive && (pebs_data_cfg & PEBS_DATACFG_LBRS)) {
+			unsigned int lbrs_offset = get_pebs_record_size(pebs_data_cfg & ~PEBS_DATACFG_LBRS, true);
+			struct lbr_entry *pebs_lbrs = cur_record + lbrs_offset;
+			int i;
+
+			for (i = 0; i < MAX_NUM_LBR_ENTRY; i++) {
+				if (!pebs_lbrs[i].from && !pebs_lbrs[i].to)
+					continue;
+
+				report_fail("PEBS LBR record %u isn't empty, got from = '%lx', to = '%lx', info = '%lx'",
+					    i, pebs_lbrs[i].from, pebs_lbrs[i].to, pebs_lbrs[i].info);
+			}
+		}
 		cur_record = cur_record + pebs_record_size;
 		count++;
 	} while (expected && (void *)cur_record < (void *)ds->pebs_index);
-- 
2.44.0.278.ge034bb2e1d-goog


