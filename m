Return-Path: <kvm+bounces-71645-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLDiA17unWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71645-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:30:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6405418B68A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5A6A306B2F6
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896A23AA1A4;
	Tue, 24 Feb 2026 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0apdZdVQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9A93644A7
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957539; cv=none; b=mNRNVYOtD4A9SnSJAtiUZoBaHhDJ2yYGdocyraOxFHUrEfqi4V3qQoAyoU/f9WYkyhcv09E83Xj2OO6sNyWEoFU5UFoL2fsHnF0nGF88RJEENzDpa88nvMW2New3ftxXyBY4uvIKMvKf10zEM/HtIswi1PZS28DSZnbtn9fWg/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957539; c=relaxed/simple;
	bh=VPgmUc1W/PstaSNg9BA0aLpGy2DMtKlMVZ2vml+wXjk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iw5ZAh9CW0kcQ0aYzl4ahAu4k8t+OSF+S033K/WvIOvcfLcn0zF6iP0bOhi1YKyx22ZJSd6n6eYverMILygiSLUQlf7bSwXoI3MaWYJoKvegVEW9Tof3cubwzpW2S5A3MIwXKMlIdv1uuxZPdUhFupNi95/L8QQRf4h6PDbqL4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0apdZdVQ; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7d4bd29099eso71121236a34.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957537; x=1772562337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7yYcH80TlRJEoXywxjzS5+u+dAUmU/HoiYfOPoDy8HQ=;
        b=0apdZdVQB/JmCQOSbUbi9f5xpj2xgoo1bAicH5C1C2IDBl5/Q3RNr5jXe/BThAT8EX
         VlXczEHsZUMSWjiWSwSl7mvNPQwX+FBGtn5+3sNFw++7Ii1Fee3JUM1scRFHzKR5fJdZ
         JwRXnZ+CZXxZkPhVJ2g1mraf+1Uyff7Z4NVNWUc+h+dqdKf1qYcUENfpKyUnDTja6O3Q
         oRG0YnVie9HPkbii9pxf79jzFDEOK32Qb+fACn1j60EyK/2/BhsJKZ+qC0kdo9FmP/Z5
         KgYGkTvduUEq1ycgZ8iwn6+UQ7G9SpN53XFqhXeZy4ayHdHYhFy3LLzFD9qQ5fboRgoP
         RWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957537; x=1772562337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7yYcH80TlRJEoXywxjzS5+u+dAUmU/HoiYfOPoDy8HQ=;
        b=Rzyzbj/neaPIH4G7+t3z9fmRq7p4DG75xn/T3GKFORTMYREiKFK8a/Hg/jcUlk+pTo
         Iqm+Z0YxIHuEcgXd/zlqZMJgqhdEK5aHJ1VMhGoE1W/C2KvQOlJ7LqryZ6bfyvJyQjFX
         MHg3DTefS3SwCQYHqMU4J8AtCJMa+8fcpXSfDvhJQKajzm7sAVwjYMv2Vz2waz1aP8Yr
         p1pH/hKjOa9ZqxeldCaCDVvLCkllWx/v6LgJSQvQ6AvOK3ev4NDhBNiU2VNdiaEyt+8L
         WqOi4lUexjbRWDY5IZUFPGL+Vn7uxfZAFmwTyrJs1N9CatvjxMUGjU2YraKmALP+pYPv
         dSwg==
X-Forwarded-Encrypted: i=1; AJvYcCW01xH4FYhe0xRrb3U3DTJYcjWLSdnwkHOZHMbhUpDAVCFPMvYPSnRHy0lqGLCGMfGLbq4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0qZx9lZ9TcFNWmTPsjLKlC9utI23CdEwH3zQ77ikTYnTf/uMo
	huhEgS3la1GBhI9u0OHzAwAbbD2ljGHgwaEF8ptweTImBPd5ODUjSjYFOzTwoxL0G/z1qUi6nfo
	hTiRqFWiyDA==
X-Received: from ilqk1.prod.google.com ([2002:a92:c9c1:0:b0:4e0:8c1e:e15])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:169e:b0:678:a4f1:c369
 with SMTP id 006d021491bc7-679c44754c9mr6789966eaf.24.1771957537453; Tue, 24
 Feb 2026 10:25:37 -0800 (PST)
Date: Tue, 24 Feb 2026 18:25:25 +0000
In-Reply-To: <20260224182532.3914470-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224182532.3914470-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224182532.3914470-2-rananta@google.com>
Subject: [PATCH v4 1/8] vfio: selftests: Add -Wall and -Werror to the Makefile
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71645-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6405418B68A
X-Rspamd-Action: no action

Add the compiler flags, -Wall and -Werror, to catch all the build
warnings and flag them as a build error, respectively. This is to
ensure that no obvious programmer errors are introduced. We can
add -Wno-* flags in the future to ignore specific warnings as necesasry.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/vfio/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 3c796ca99a509..e8f9023cf2479 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -15,6 +15,7 @@ include lib/libvfio.mk
 
 CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
+CFLAGS += -Wall -Werror
 CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
-- 
2.53.0.414.gf7e9f6c205-goog


