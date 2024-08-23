Return-Path: <kvm+bounces-24981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA1295D9FE
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 509B61C22A7A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF2F1CDA3C;
	Fri, 23 Aug 2024 23:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c+jKn06Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717E11CC8B2
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457423; cv=none; b=OI7VRKjr9nWvgLcrwt1zcaX5dV8pa60HAldy10yOze9H4viqP6n5AgLfAa+YT3yx/ISPcdkKdrPlzUuGSWIbdtGiuRQE9LZoHCZHgAk0JkMzIvTfg3Qst/60d6VmhOEyJHwmkOOI8Gf2ALir5gpkNSU4CWF9cstVlF5+v/jn4bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457423; c=relaxed/simple;
	bh=4XD4l3U3wYnBD7f0qYtCqEDXW9p9w81RczhincQurds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GOqln30R3ZkO0XT5GW2YJGS3OFJKBnXxH+V/gZZg3gynf5pkfGUb8P121YTqzs65wDkWEAz11E6Bl4G2I3ZMwg/lcYDHxZKoxWy+U1RzHq3ZwBvIvcdgBrRbrrr/ATZD7J2PFBq8T1M8kQU3v3OPF8f1keDnPkmv9jVLQow1J8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c+jKn06Z; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6c3982a0c65so45055257b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457421; x=1725062221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W2SOE6tX7v/OlcyQI0vQz2k5OLAtSjTk1r+cXVAyDEI=;
        b=c+jKn06Zvuj0xzJBWSyfWAkQAXJP2+/o+4Tidk68LBC0cuISu7QWsShPmAZHE2YEP2
         ALmUMPxCSRBw8GNA0fpoDXf/069ZwWAaG54yonieRy4fdr55BfvTquyz2ZvsTAUpGeYB
         xDij7T0rewyxHCpD7ZcQEnadj9prfRHX6qyoU3YN8sP3b/tywGEFB7WCyYGTDVYuwPHN
         CTAidYvnprbwS9djJMTn4Pc0QMU3Sas6N2Ni10UJ6oYsOtb1GipuEqclpFWTLprZLPW6
         48VzvdTBzrV8Dn2GrnqrhtPKEem8JVfykGoLgjSalV8ac1+ValxvTLXQ8beygA59+tGm
         YvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457421; x=1725062221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W2SOE6tX7v/OlcyQI0vQz2k5OLAtSjTk1r+cXVAyDEI=;
        b=vwsFGICBYU/4JuDQgC0v18eN2aAoYUjDlFRuhiUGYXSOlauiPxs2iS889jtwcybWbt
         lXE9J9QRMV7cv5Rh+7moY0ahLSgwNHSWW5xjAB2xsu/DUmp58CoriMuaxTDNviylYH64
         gwRBcrjX63phnagvX9flP18Xc5NhpNyTG++mNRia25hNp4JxFNXmceMH5Dth0LGi00YF
         AIuMNHBXA4BipMLA626X4DDRQpHXnJK4AOC/rD0yd9SkRU6nKUtOPBiz/ANcyRnYBTco
         T0Lu/iyunTJO/qNTJ+OjKHs6hUj005OajKpWPJeLCVst7+Y39tviN3qo8utcDfG0wJtM
         Aulg==
X-Gm-Message-State: AOJu0YxahGlM5MAolXRXQjP8rzsWwq5qTpCINPEF4dyPpjqhl3Et/wY8
	ZqcVWjfJFUeRmOKIv/UMc30wH+gspj5e6od4FPse97WOQjfwpH77CT0oPQphZyB/o3kIsQljzFg
	CGkOpnx9BpA==
X-Google-Smtp-Source: AGHT+IFzMvv8Jh0nbvaPUtheFnuf6z4lW4doJwlm5sqQx6U26IiKBfIXR3l5asqPwBrTmqUus/GB3TbEaR/EAQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:92:0:b0:e11:7039:ff92 with SMTP id
 3f1490d57ef6-e17a8666f19mr5295276.11.1724457421572; Fri, 23 Aug 2024 16:57:01
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:56:48 -0700
In-Reply-To: <20240823235648.3236880-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823235648.3236880-7-dmatlack@google.com>
Subject: [PATCH v2 6/6] KVM: x86/mmu: WARN if huge page recovery triggered
 during dirty logging
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN and bail out of recover_huge_pages_range() if dirty logging is
enabled. KVM shouldn't be recovering huge pages during dirty logging
anyway, since KVM needs to track writes at 4KiB. However its not out of
the possibility that that changes in the future.

If KVM wants to recover huge pages during dirty logging,
make_huge_spte() must be updated to write-protect the new huge page
mapping. Otherwise, writes through the newly recovered huge page mapping
will not be tracked.

Note that this potential risk did not exist back when KVM zapped to
recover huge page mappings, since subsequent accesses would just be
faulted in at PG_LEVEL_4K if dirty logging was enabled.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4c1cd41750ad..301a2c19bfe9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1619,6 +1619,9 @@ static void recover_huge_pages_range(struct kvm *kvm,
 	u64 huge_spte;
 	int r;
 
+	if (WARN_ON_ONCE(kvm_slot_dirty_track_enabled(slot)))
+		return;
+
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
-- 
2.46.0.295.g3b9ea8a38a-goog


