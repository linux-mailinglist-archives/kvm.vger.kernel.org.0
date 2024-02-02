Return-Path: <kvm+bounces-7817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F748468D8
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16473287DE4
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608E517C9B;
	Fri,  2 Feb 2024 06:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PFEpSd9i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE6A17C72;
	Fri,  2 Feb 2024 06:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857108; cv=none; b=oDh5nfojxK0AK6bv80aZ+cQnaLp0XXjURzruU26x2AOdaT70qsrVu3P6Nxca3+nmkcERi9KLnr3wki7WT7dF/2HKYOcslT0r5JMslgDwXfWfzU9Itqxz27TI21I5Ns8F1bD66A4v4AkjP2qXbFdLMGEnuDRuctm8tmnsyQD6s2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857108; c=relaxed/simple;
	bh=4yScsOrcnjKTTDzCPnl6oSqQbBcwqPOJzQMwRvXXfl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKzorPg/5p0Eet/V2wdEwC+blfAJLDzDZxd6485w6ZVIX3Y7hDjutGtLCuhnnXqi4ihOIFeLk4kWBeH5iaoy0uy718YniVsj2GDzYrfHQMr3DHuzWiag6d/Zi4Xq1iKFGwYoUp6MzVjPLFmuJF2olcGEYbzTYerzy50YJRw+eQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PFEpSd9i; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d8e7df6abcso16662555ad.1;
        Thu, 01 Feb 2024 22:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857106; x=1707461906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=PFEpSd9iABdv0Rs4jJjTgfG9YOUwIoAdNPj/Hwlf68QO7WJxKTKiWRbv1CYvu0S6U7
         478w7BnKhUBywiIkt1OSVBZEHHjoNO9QJYOW4i/pkanr+7MGqmRQtJz3J9N6NOkH/7mg
         LsUt8J3WqoSMfEV7aLe4Qn7GIwvRCgHvuwHKwBv2F5CEXKN9KkwFgsm/HK3+crHmqykR
         uvrI2mMKyNHl0iyNmPJ9hI0qG227IjTyZ3sUGA+X2lKrgBxhE5iCV2y+qC3af9+E8eeX
         meh7dS/zD62deX/U0uMZxErLhyEReKLIM7lEFpDSW4IZjA8kaNcWvScktozy/5Pq+Lat
         sFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857106; x=1707461906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=rmo2AjBGEEXjs+Dz0+M+wTXhqFFLacMPtS0zcmmq2t+b7MMO1m7zifNR4IDBV9AZoA
         7ynRnTMAXFhqYuPFtgs0tvtKufyAGKSeX2gIiwA0hGdJiZTxU+7plMtPV+HhTczLPQgN
         fiXpQlj6mqoQNRybExoohbiiQff6kGhfmXj1OVv2fE122gvglKHhqKetGsxkIPxl6vZm
         YNBf7znHv6n4BG40Bo0wm1yIkv1+vKUJ/qkJjjvcx8d3F2d12C/x6U2+e13qOyCysss4
         BfQ6nr6BuqONRwQV5K9RVecrgbJRXoRF9rIX8IMEukvFnzqMOCnNG2sx/2YCBRuuSJDc
         xbdg==
X-Gm-Message-State: AOJu0YxWrg4uoMwNf5B/FshirENSFXq/+K2tb16QI2VfqJ0ppeESafAf
	PAuusodObHO+4BMxXe/um3kigf5kifYdVwJwch6TMbPHWOAo/d30
X-Google-Smtp-Source: AGHT+IGl/XMjvd9Klgg2/FWxCwJMxKc63HwstNQDO2ClYm/78uC2k5jJZCUW+UiCZN8A2rtA+7mFiQ==
X-Received: by 2002:a17:903:445:b0:1d9:5ef2:abdd with SMTP id iw5-20020a170903044500b001d95ef2abddmr1116146plb.0.1706857106567;
        Thu, 01 Feb 2024 22:58:26 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW/IOgMZYUZthoBpoNRMf/oli+krs0I7QalTXQLhmUUWWhn4KTEGdDr/tD4cxALPr5YanOFmAHpezVtwao2TQzO+RlJR3Ey/l7/3QH/K3g+wJhke1+8D7EBboNPM5WoqME9ClFM8Tb2qCEIYjo+bDj+JytizB/Z/HHC2r1N33PYMUgH67boLyOHJbDw9bZpjApoN82XPi+TIHolN046l5iX1K13QrymhO+WP1rEnsSa9hFW05dJESbK9n9XsLx0/+71n2h46K26UvtQ2Tvhi4CxxSgx61auRLuHt8a4ivXCW09clAuX2orO6qQmVgmRP6m0MuduJ7wcFMpF4m/Yyx8XgB+x2QC4G9sG0uUxRP61DypLkLC/HukTiuGgrKuWO8070olj+6YNjeeQFlx6mz0z7Ta+qF2P+x5aggZgJT35GSJypgDz0pyEIOTAPK75Tgu99P65NQ0dXD3u4iLw7/cZe08vmV/GqS8qWhRhxtJKwMQsq18X2q834tfjJ55jslSnq+Pu+viz/94=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:26 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 3/9] arch-run: Clean up initrd cleanup
Date: Fri,  2 Feb 2024 16:57:34 +1000
Message-ID: <20240202065740.68643-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index f22ead6f..cc7da7c5 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -271,10 +271,20 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+		unset KVM_UNIT_TESTS_ENV_OLD
+	fi
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0


