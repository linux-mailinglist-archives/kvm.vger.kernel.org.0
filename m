Return-Path: <kvm+bounces-72584-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPZAEdE4p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72584-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:38:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F254F1F6304
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2458F307B672
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC603976AB;
	Tue,  3 Mar 2026 19:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B4hP5t4d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98B93976A2
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566711; cv=none; b=JhCmI9J0ZIV1fx8eHmhTEgDo9JCHI4eApXJjyaewLMIfKIrt86Jo5XhltdfmGqL1SeOORy+ZTMEZX3FwX7dyuhY45uDN4fMiLagXmEY+8aT7TlD4W7m0C4lfrPGY+A14LVdEPDvW9FqpJxmut1sc5bXBJ9NDTRwxFVvFjxJAMww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566711; c=relaxed/simple;
	bh=jjqO7YZCeRuBMZ1mewA6ckPXJHycFjyo86Cvx8Zot6k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WhD/kuJkBpLEQs7nL/d6zV0gVZh3GQmssT79mJv4lIHlbfmXfoTVZ8A8rPIRh9QcM7N+ZFcP//DUidqWQCcBevC0wpmij1nTLsFE9MSqpuk6qJ/HzsGTp3es95CND3O05gcpyakei4rQeZks0swQ+V58S9uwqZOceup0BR/aFjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B4hP5t4d; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-663019e3e05so39374688eaf.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772566709; x=1773171509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bd3WQNQbvy17FPuSWSlePhR5MFAZI/OI9QfmsSTSzes=;
        b=B4hP5t4d8SMhp1zVlvhhLlCT0np0GP2IwMGEippf1SDDbUqvSk9qUAz6ufiNSdJyyp
         /6BCja5hlMV5J4Mj7J3BoQEspB4+jlRug5U7nHjfDNo3H3D9yZv5oL/2PV7krbUr42hM
         EfAFfEY1UpLK6nRzQt9NaUYVbsp3s82cacTkkmkYyxlXkdJyZkQO8cm8u6EMC6uXeuVG
         3j7nX5QYaO9MeML5GoETETSwPfOPEzlzbH2D83t0yrf10r3SEeXFE3VolGcNwOAWIyoO
         lNZdTghFMpT5I+4kQND7P80YLHhK5naL/7scli7TI69gWNNBLwTaBhyz1L4SJ40usMBe
         Mh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566709; x=1773171509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bd3WQNQbvy17FPuSWSlePhR5MFAZI/OI9QfmsSTSzes=;
        b=YSWnDQuUw6LqG6Avii4w4OKDzk04EEXrk/p9HOC2NSE4PkH3n1iZK8wA1DmOOJuCG/
         2PP/tY04vxbLT2fy8nn01Yxcj4U98ZOlSOsauS17qiMAuaUO3msaM5X6jwgLqcmixT42
         tVGGnyDO0m3wyeekUwL1ezZ+Rp0/67DEzMyCvhN5mwhAXlmnyrVXer7XWYIupLgQYMW6
         tYmCsB4nnxYtnt3hr1tgzZfYg1WBMiW4vplHqzl8iOiiWCaNI9yB4bMYSAT5AmJ9HgX0
         6ci2mnw+0lA+XzugEM18KDjr+hZVD0xMtWsNbSSvBkTQchUhDN1VfBbIY0roH0FWlF6z
         FHig==
X-Forwarded-Encrypted: i=1; AJvYcCUF76RFvKdZULElPLN21fTriNwyRtSafi1pQY9BnqoUGEpnYdcKGmQ7J7uZxIFlCoFBz8I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaMMMbGX/srCjOy5wxiSJ6te4j7FRA1lZzaevcgZZf073SHtUp
	zJsFiRJfP0xSSgplZAXqBOxGI58QSZLhXgPT0j2Tj++O49672YIRUaZIcFmv/3QKec7mN7k1tPH
	4j91+rgxYVw==
X-Received: from jabls22.prod.google.com ([2002:a05:6638:acd6:b0:5ce:b671:f1bf])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1b0f:b0:679:e4c0:e022
 with SMTP id 006d021491bc7-679faf3e904mr8235457eaf.52.1772566708525; Tue, 03
 Mar 2026 11:38:28 -0800 (PST)
Date: Tue,  3 Mar 2026 19:38:15 +0000
In-Reply-To: <20260303193822.2526335-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303193822.2526335-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303193822.2526335-2-rananta@google.com>
Subject: [PATCH v6 1/8] vfio: selftests: Add -Wall and -Werror to the Makefile
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F254F1F6304
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72584-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add the compiler flags, -Wall and -Werror, to catch all the build
warnings and flag them as a build error, respectively. This is to
ensure that no obvious programmer errors are introduced. We can
add -Wno-* flags in the future to ignore specific warnings as necesasry.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 8e90e409e91d8..6a9ac6dd32cb6 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -23,6 +23,7 @@ include lib/libvfio.mk
 
 CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
+CFLAGS += -Wall -Werror
 CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
-- 
2.53.0.473.g4a7958ca14-goog


