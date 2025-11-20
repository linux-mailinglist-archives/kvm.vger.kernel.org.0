Return-Path: <kvm+bounces-63993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA24C769E9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8BF094E285A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60FDC29D268;
	Thu, 20 Nov 2025 23:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GmR8qbfn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F628CF41
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681518; cv=none; b=eK9IgJzpQJkvKexOFY04NbVOVoloUaCV9odd73inJXh/rQSYefa3pGbWawz26lPGQeQSpsICwu1dNVf5ACEd9+JaZcR/l/2hAqgDN0aIoSlgTzgncJv00fU6drje+304UzHTVcEeVBBDf9ocS/ldjXcUbH2wt1vPaEoqqphQKG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681518; c=relaxed/simple;
	bh=fppBqwVK8bpEW+fW9cNLHNqKUC1S438JrR3L7X2ABqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kUm1sX6Ho0507mUzC/qPIbkgRJkRucVPT4Yyb9hO7b+zchGYYUS9sPzpj6eJp9e3WOfpOXC8YusSrbqxmduVN+Q+lcIBagNIWYp3ZUc9wsHn8sqtuX/2s5Fgal775gf/TAam1p//TDqK2XuS2+KIxxIfcVQwoFlhtR17/GaF2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GmR8qbfn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436e9e3569so3082541a91.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681516; x=1764286316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CIb7bf7vKPMI/IPIueAZxP6Ey/1wOXK4djRgeeRcMXU=;
        b=GmR8qbfnWGwURLBiF33yzD6oQnwMglDlr+Zk1D6XD0xTU6tZXHFeMlZ8S+j79D5s9S
         RJBSr5gxLys+/8BH4cTbMVQ8w/JM/mR5sOmfgAkGpmUBX8GwHe6zJYt/stOPJk4mOtoW
         RAIuUsetj8NH1cFR8QoN2/GOZXFOfjbmahOmV/og9xA09gdyncAwaxqFn74rco69ZFeu
         okeOHGs3H8GL2c2xt6NfqAC+8H1dkUcCBo0x5esthevi/HhqXuLvMu/cV2fwtEilZhyB
         8f2hyhvJ+XnGHb9L6xu0Z0WBj5Oh9bhM6JW03R6msC+hiiQIzw2eLfIn1cQlVYaDDAyb
         Ra/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681516; x=1764286316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CIb7bf7vKPMI/IPIueAZxP6Ey/1wOXK4djRgeeRcMXU=;
        b=XQVg5VBOfJvVRVViy8y2fZ8d2S1u5J4CvWmvnhrTcLLprnwRs2Od6Q3BaTNR7JZOgI
         AYWD8EltQEwJHwYplS8B39rX6uBY1lCX/ux3tjC+w5Loug2f+YK/oqmnQ/2/kQzgLTZA
         E7QXffRkPhM5PzoCM4xcomjD1wOU0QY/H01s15g6o4nOAuAV//bl1qDZZ04yHvu5Z2vf
         JG7+mlHsOfPQkWQpgybNGrRHp8SGPPtzoeEsCoqLtvU4jC6jVJK7V4emSG7cE/C3J5Vh
         JrVNMORZbkVLqLgfaztBGy4nSRe7nSkRoSgSw/cGYjgCYYgzkmTXAltHBFqZkn65VLgJ
         8eLg==
X-Gm-Message-State: AOJu0YyxyqbV3VSBRfKrx6rk+VjBo3zDFfVwhnDNpQCB6C6jMRiFu6Oj
	v7gx+ujdYqtpeUrakKSsDAFVXJAukk1+pBQXuLFudEwWv6GWCxaC1iFlUVVqsx+vwWPrKNTx7R6
	SPuq+9w==
X-Google-Smtp-Source: AGHT+IFVuQqnuVgVhz/0q+TanIN9yMfLN1uC2H93JvYOIhiGUXUT6CtFgt6wfKDS7ICx8kDgYCRDRCuljlE=
X-Received: from pjbds2.prod.google.com ([2002:a17:90b:8c2:b0:347:2e36:e379])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b45:b0:329:ca48:7090
 with SMTP id 98e67ed59e1d1-34733f4f773mr250738a91.37.1763681516377; Thu, 20
 Nov 2025 15:31:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:43 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 2/8] x86/pmu: Relax precise count validation
 for Intel overcounted platforms
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: dongsheng <dongsheng.x.zhang@intel.com>

As the VM-Exit/VM-Entry overcount issue on Intel Atom platforms,
there is no way to validate the precise count for "instructions" and
"branches" events on these overcounted Atom platforms. Thus relax the
precise count validation on these overcounted platforms.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index f932ccab..bd16211d 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -229,10 +229,15 @@ static void adjust_events_range(struct pmu_event *gp_events,
 	 * occur while running the measured code, e.g. if the host takes IRQs.
 	 */
 	if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
-		gp_events[instruction_idx].min = LOOP_INSNS;
-		gp_events[instruction_idx].max = LOOP_INSNS;
-		gp_events[branch_idx].min = LOOP_BRANCHES;
-		gp_events[branch_idx].max = LOOP_BRANCHES;
+		if (!pmu.errata.instructions_retired_overcount) {
+			gp_events[instruction_idx].min = LOOP_INSNS;
+			gp_events[instruction_idx].max = LOOP_INSNS;
+		}
+
+		if (!pmu.errata.branches_retired_overcount) {
+			gp_events[branch_idx].min = LOOP_BRANCHES;
+			gp_events[branch_idx].max = LOOP_BRANCHES;
+		}
 	}
 
 	/*
-- 
2.52.0.rc2.455.g230fcf2819-goog


