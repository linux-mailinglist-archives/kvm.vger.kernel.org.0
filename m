Return-Path: <kvm+bounces-63998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 33433C769F2
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6951D35BCA9
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75F630AAC5;
	Thu, 20 Nov 2025 23:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UiB0oD/H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED8E3093CD
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681526; cv=none; b=tCEqcThmuPWckNih0xO6vOBrR2CGnBDMdisHuzb1tzGTE9dUeA1EEBdXIcZ/KcWxcLIGxPtkVPzSdCn5Wsx7Q3Ih260Y7E3KuSQYi4GNK07yVPGGLr2/8ufxdgiVIjuqgdExKVB6eE9RwUy/P0p5DFqaupprqPvb2P4N6Qsvy3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681526; c=relaxed/simple;
	bh=+OngT8LqXRIY86u9UmodOtak7/uzQvENjsNehxX6/38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T84pnlIc0fuSBUDvPRitee9r6b3z5dSfZMVbPFy55qaYB33q+zd5WFOuCR34DlXBt1F+cSeT/P5Zyk6xjFi6L0IanJ0AQImEPvB6MhT1nTjMFvKPPm63qBv4kpcisLkGY5w1O6DiqoWgdFRDCRKjT/dAop3RKhNK/wCqVcqLzq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UiB0oD/H; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297ddb3c707so12744545ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681524; x=1764286324; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OJSTzZeutbK4xKPNzkx7zN39n75yDnXSLA4LxRzVGHQ=;
        b=UiB0oD/HwAy7uPlA8Id3iSt109bI/HyaatTVe9U3fW4tcYrISjQSYal0w6lCBalFBC
         X5nLlIlN3O00s2nZl/3PfeWmJqsGNWkzHRJTsSiDLoOJBZevWwW3K9whJutdq6lkap14
         v5eVk64LCfyQ+CfrS0/kbqlYpcqFvVGZGN2V7b0CrYVmJx9A9DKA+bTSb38pY/CP3VW6
         mF5992mYidOwtVMFJAfDdxisjEukhGs5T+aB4lQnk4qpY5xBuSNIEA3x7TbwYgM8U0eb
         UjgrQ+vaGtvHMRzQ4n97U7bNJ2M9GrwVqaBhI8Jcn2jtI8lvZnU1YI6pzjNBYE5lDa7D
         nxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681524; x=1764286324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OJSTzZeutbK4xKPNzkx7zN39n75yDnXSLA4LxRzVGHQ=;
        b=JLcGaJGi+AQO4L5FmkmYaEQNli+t7WXmlHODl+OGgfr7HHHguKBIh2FNvys3yRyRg5
         PM6v42L1G0gnxZD3qpLgAmxU9P/wVHGg0JB65brJAIfsliH63GPjzAh3gqQKy3ukYC8m
         oZCB0t7yUs30bnc/UPZBFQpYtYuYOz9vreY2gD3co/2W3RYa/d1YDPtzdr9ui+G4Vu3i
         OSYlKGuOV6iBN8ToWjgPqYvwtry2Of7nUWRI8y2pFnnJTLKpNnUM6Lx7BeuBO6iAsEVZ
         Ej8zZ32ujB+mh/Y4UF2F2jx7Rqrn8qv7Tn+ys9A2Ck6RWp6klv+PzYog5KOkBdPg2SCr
         2yyA==
X-Gm-Message-State: AOJu0YxjQAro5fOsTSWeCGRbjbzKgorrvXxpCYyz2a4gHe3ye4TgDG1U
	W1omW/qbU/kyiwL5y4xFqiiMqWgUB7lphgs7cKh/DVmqrnqLMyFJWhiXQE+7OMO+1/mNICAik81
	ro6yUiA==
X-Google-Smtp-Source: AGHT+IEqp5TLn+mQPWFQpfo+iW/SQBWuGxw/DEHtRnWqtucEBrRHO1+I91uesTSGw+4szO9nNTWLQVBMUGY=
X-Received: from plbkm12.prod.google.com ([2002:a17:903:27cc:b0:295:cf61:9590])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1786:b0:294:fcae:826
 with SMTP id d9443c01a7336-29b6bfa1cb7mr3568175ad.59.1763681524472; Thu, 20
 Nov 2025 15:32:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:48 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 7/8] x86: pmu_pebs: Remove abundant
 data_cfg_match calculation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Remove abundant data_cfg_match calculation.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu_pebs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 6e73fc34..2848cc1e 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -296,7 +296,6 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
 		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
 		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
-		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
 		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) ==
 				 (use_adaptive ? pebs_data_cfg : 0);
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
-- 
2.52.0.rc2.455.g230fcf2819-goog


