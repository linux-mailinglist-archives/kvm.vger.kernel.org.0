Return-Path: <kvm+bounces-48688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDA1AD0A81
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A0CD17196F
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC510242D8E;
	Fri,  6 Jun 2025 23:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xRtibIW5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B063A242D77
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254208; cv=none; b=dI97Qv26s/IhiDL3OkhmNHgWk0BsKcRib3HbK2InlsHKK1BZe+FHBtynebSyg4uJ7hjQRclmMNNXDXNTnKTZwT2xUopJch6GfXIE+akc3ccd1Tl2t9qwKCNP0CqEXsvV5paQP6DZaE4cBQtaH0Z+53S/kYQlTKihMAeUHb3Qjkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254208; c=relaxed/simple;
	bh=tAhDaW1UKjDSoNvp463R7s5asIhTvTptfxnbQS/b8mI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PwO+CMg8l1k2GNbezILWQr0Ihr7tk+Fr7Oln7f/o3lBaxOIzLTK83VK8/0mEiUwUmom5U9miLSZOPaKQHvOu5MdLL9KDFALjEhUeKW6PPTGxz6k2hzGlgOi/jXUvK1cKHrt5Tf4mF2g6cqD91FjxQV5HFEuKcS61h+g4MrD1YTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xRtibIW5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740270e168aso2079333b3a.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254206; x=1749859006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VrOwB60iRPSms6H0AJKyXzUgvUqpPNkdC9MViEx8qm8=;
        b=xRtibIW5GWcJc+OrfG0YLlrlY/hoy9UaBo8iQgzsUGbMvzc0UqEUxIFLHJokZuBFIP
         jFiVMbDhN060rgcgtSBRhkwBJ9AsEZPy0GTK6QcS2li5gdiAsOFYABAzYt4xkhvIbVHB
         u+L10Un9jIcahKS/nfmtD++u2GIh8XYk2iw54nqPHIu54D+tCwKtm7j3xCNvlqSOqx5C
         Pq7W0OXGJhNWEKDybdvbUKyBNVlQexDboQpk2J9EtGx030tkDHNUxduHUkcPa8r/AtuE
         iMPNhTamiw2NUZgKjjF+BVjHkmLQyzWvkLNLKRJyEiLNckv1LUTKH5/hQ0lBgBhEnV8T
         Uklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254206; x=1749859006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VrOwB60iRPSms6H0AJKyXzUgvUqpPNkdC9MViEx8qm8=;
        b=NBJ9lXcpaS0dTcD6vTkD9nSI5g68+d2ouiWiWb8fwEaN2j+ppsx/VSDjg+LCeAL8lQ
         /rEFD/NTo4spcEpSbS3+kYbx+Uj3STVFmNwJTpjgrGp84l4CpjTnpjZh0is8dJ6ovsn+
         W+PrRO6Vd/JTUgNGjMRbvvLofkm0kx/EmFfryflc8yuDF5puWK6oJ0Emx78JpsObInGf
         me/Tkj4m7rlbdWU0bTyWHjZ2Q0fdTxR/2BkSNwZX/CBEvWYBhxBkvFmmEoyrZlS4E/9J
         fF/ERw+ulVUZDdngZjnd2aCr4xuNjEap4bvQsbhswaVe6VkDc8uFaRtCTK6R+Dcis/aM
         WD3w==
X-Gm-Message-State: AOJu0YwKliDTbqXMqP2J0/B9QFc3Wk+6Xo/bfnvLrJnnlZAqdtY0qzhL
	yeeo2e7dtq2B8ky7AwoV2RQgMfdFBXfODQfpxanpv2PpM/iaq+/+d9aDfAIUKnHE8AK3Ql0b2z/
	oMxXpGd/tfW+RD27c5mRAKygWQ2mI2Sj2MGOBVoOKPPjPYUiU43gnJR5dmmzl6RrNSSaYjejV5O
	XeYuZjoJ2o91tzxk8aoyYXFxvDwsR500ZEj2qQ6g==
X-Google-Smtp-Source: AGHT+IGcO5eLR5D4rJUvqyhcG7DPzhqjWvwjT9S1GiHqHVEpWgfsWBe6SJIclWzcovJY/XCNJMaAI3VDhG0T
X-Received: from pfbhm22.prod.google.com ([2002:a05:6a00:6716:b0:746:2bf3:e5e8])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1ad4:b0:742:aecc:c47c
 with SMTP id d2e1a72fcca58-74827fcd87cmr7087572b3a.7.1749254205891; Fri, 06
 Jun 2025 16:56:45 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:13 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-10-vipinsh@google.com>
Subject: [PATCH v2 09/15] KVM: selftests: Add a flag to print only sticky
 summary in the selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a commandline flag, --sticky-summary-only, which only let sticky
summary print to the terminal and all other outputs are suppressed.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/runner/__main__.py | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 4406d8e4847a..2dcac1f4d1c4 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -124,6 +124,11 @@ def cli():
                         help="Print only tests which didn't run."
                         )
 
+    parser.add_argument("--sticky-summary-only",
+                        action="store_true",
+                        default=False,
+                        help="Print only the summary status line.")
+
     return parser.parse_args()
 
 
@@ -131,6 +136,9 @@ def level_filters(args):
     # Levels added here will be printed by logger.
     levels = set()
 
+    if args.sticky_summary_only:
+        return levels
+
     if args.print_passed or args.print_passed_status or args.print_status:
         levels.add(SelftestStatus.PASSED)
 
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


