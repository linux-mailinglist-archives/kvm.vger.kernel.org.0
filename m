Return-Path: <kvm+bounces-57634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2843B58702
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A53432083B0
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CB72C11EF;
	Mon, 15 Sep 2025 21:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="T1eNs8Q7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9572C08AC
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 21:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973297; cv=none; b=ku8XMT9h/1v/dD57hi05gtK8NMrDjA4nJh+twhpMUaRP/3/MHzcDuLkoxSpDbD77kZHeUMFK9CMRfObKgxSdPIYUdO5IgpwBZVYVlxz7I1LpzavH+DVtaA2tWeXqM+x0kQm+DSyALie6CYFhMnEXx0yyDxCIkWTByVjCZ6T7ACo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973297; c=relaxed/simple;
	bh=PdHvRfevfRqxtXXEl7OhG5gE+ulxsfMQaWQYO3eysx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeUWqanVFJUHBsU9fRZoi+RYD9dy7daZ9xkpWvh9fzooGjHUD0vLE4fllNdIoaPBjgdFD42LH0A+HT8txqoCO872DcQmi5ugjUIlueLG6HgvWVE/XySxFCva48f6MBF5IA6mK4IJu9nUXcEj9fBQdzrFcNBJk0exFjDgNqBNQNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=T1eNs8Q7; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-78393b4490cso13986716d6.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973295; x=1758578095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osV/NIjrIH3bFRop0adAnSBkm9yQEHuI7nZrGLeMdNc=;
        b=T1eNs8Q7syESm4E7LXYAUhZ1OKSQSWJH3JEamLOrvdZWGh41jETIHd70wlUXvj+c8L
         c6CR5geUh86iCPVwnLzI1NpHJ4lInNmce3iUfdXh8qnBu4Hc2MtVxZgylxlAXuDRybSm
         oI6tntaUrKTmTT121/ykQY0C5kRlQVKfdo9Hpdjub4bT8qIwmETgw53l7vXLqM21/nsq
         VoW5g+rztu8t/P3X98qlqdxCCupy93nZw8QSnlNW6YXOxXnRL6i+2a0OVe+RNZH+oS5E
         uk6HUkAGilsQ7FVl939NbLaqUiE4f3BaPN9eoc5dlM2UAnuWWItrWADc0JWJaZLXdp4y
         mxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973295; x=1758578095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=osV/NIjrIH3bFRop0adAnSBkm9yQEHuI7nZrGLeMdNc=;
        b=WshwsuAGzNGlktj3CUW6kYun95T5C+zBHkOe7ufKu4zbuPhaJLAjmgQBz/PcxGwfZv
         5H4gBFkOl0ZlZY7A52EqtGqGFe2ADn20gM7TZLWXK3BOteCjc5jc604gwqMBX3F/8Ody
         5pV/jRn1gPMQDkGHA2xvxIFR8eHIpRHHv+Z1pwLqvYoFPM/xzkPOpgrgxOy0MMdRcz6r
         T+EWjCU/mX61dJgMWRKgxL0GY3wGSOPApEApUqC+AT8GegnvUfq866Xp9mueXZufJjta
         h39yayCyNTDz2P6dzIQ0s5LkbnNLF/e+ARyYjc2pu6T/D/0o8D5DkaI2Dj6NAd3WcDIv
         5tDg==
X-Gm-Message-State: AOJu0YxA/UFPCfjSgxUZ3HATKa5JIHcca30N86/r2v29rPkscnT98jD7
	QrhYwPa62YKN9E6h2SCpL26r+QeksZqdwbUpOOYT7z5k8BSeK3O+DIMgz7cK7DYK1Is=
X-Gm-Gg: ASbGncu5nwbrQeLMkx4MS6gT+2GCu1skx+5u3KhxbbUMnCrBYZZkv2lzAjfVvW/pC+S
	UXJJB4NM5aGBQT0RDaYNuXjK+SjXEwBEH5Wd9WHHFCLtXUB02CqB4e7FFNgyACZjtnukt32S1+F
	8NV699qqIvk20ayK9n/2UgKUwqdgk6JlRrH5ujqlEUe+j7Is1sskHsde7GvPO7JHSr6sbT5vJd9
	+/cS33A/P/PNcyZncmdRctyV0x+5JG1LaecNXIcMzUsPZtKgN+WP5T1czhmdSyueghzs1H3r4dR
	ErIgjK9pTE+fNSxMTKpcZq9+gdjvBcRJTUMZHVVvpPEf7Yk6Xux4tfGGb7Js876lEOLCcIA8enR
	Q5KH9s8ohBbUHPN7+n7uMZvyBJ7M/GZ+eSA8Pf6J/rZqTWoWONtiJZjnMs6KaXZd/eVymEQ0PZ2
	LLxsyrvq+5hLcS14wDpuCCVBj1QfbR
X-Google-Smtp-Source: AGHT+IHFw5J+yWr+E/blgWAggycz6gvE13byABTAUgHBbzCSHqYp1RjFAsQBSWhl5BL4Ce51buVRAQ==
X-Received: by 2002:a05:6214:1d23:b0:743:15ff:94dc with SMTP id 6a1803df08f44-767bb4acc69mr166749496d6.7.1757973295050;
        Mon, 15 Sep 2025 14:54:55 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:54 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 3/4] arm64: Better backtraces for leaf functions
Date: Mon, 15 Sep 2025 23:54:31 +0200
Message-ID: <20250915215432.362444-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to x86 before, ARM64 skips the stack frame setup for leaf
functions, making backtraces miss frames.

Fortunately, gcc supports forcing generating stack frames for these via
-mno-omit-leaf-frame-pointer.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arm/Makefile.arm64 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index bf7ea2a36d3a..a40c830df20f 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -67,5 +67,11 @@ tests += $(TEST_DIR)/mte.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
+ifneq ($(KEEP_FRAME_POINTER),)
+# Force the generation of a regular stack frame even for leaf functions to make
+# stack walking reliable.
+LATE_CFLAGS += $(call cc-option, -mno-omit-leaf-frame-pointer, "")
+endif
+
 arch_clean: arm_clean
 	$(RM) lib/arm64/.*.d
-- 
2.47.3


