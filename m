Return-Path: <kvm+bounces-65913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 010E7CBA192
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:15:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D01C13002FF5
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3DA185E4A;
	Sat, 13 Dec 2025 00:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lx3tbuYT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36643155389
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 00:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765584897; cv=none; b=BvOF/R1Rx9UkA4N7zPJr9h9uoSoPPaiVgTHuD86cHKZ1me8vKIZGgTyZpqw6Fw9oKBSeRwuc733/cqGftU4rS4Nuz3Tfq5DTIetGrg6V8cbNWG2hXt4P/BaUjJ5QDo7fzyuJ4+jxkxB3/KdEQ2tqtKxDTNik8zsTvnpswnFWIWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765584897; c=relaxed/simple;
	bh=NKDqS3M1cLf7hjrQmnVauabHWGMJaW4nJI4M7NUUhbc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k9+qnmbrHB0F6ESnQ+qBz+UfiuAkC6Yfm/J8ZmwGr1s7Zt/HJwl2WkRlZVBj56Dg1CRVRYRv8rbbqlEA0wGNYeUZy2IipK6HZGWJrg6cZsfLK+ckPNF5mG/FoML+7K0jir4TqhgzJdNDLHJ2o28AK28+shuNEYqztUcBcJt4ghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lx3tbuYT; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so1765777a12.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 16:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765584895; x=1766189695; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sl9CNn1EVZEpq7y7cqXda6K3glgb23SOapyyZsDMnjg=;
        b=lx3tbuYTxu2O3NNfR7tj6yhOiueHz7vMNPUTQd7aCi1uaNBeJ47OdGszCWp63t0aHX
         zHyMtsV87oEKKPzuln4NIH9cGK6XvSYoHBgC46CjCTjBj2kcO1Q9SjhRj6yM3wpnfnil
         RYZrDl+CyTWp8FL3x+HQZon7oimWbpcRFGkcRopixCx1WrK0WifCB3ky9gldXntRt0MM
         maekP2nnPzAr6p8+gFybnVMqvG1pzAAg2bLGw+l6sJMD/yWeX2KR6OCtozkHgx/waGqZ
         uCVt0BEFNtIcgo8zgYuDSnOBP5Q8q8o1Vn7KVjGoYxdBALxbRKJTqzBfk3IeUSfCNj/g
         ZZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765584895; x=1766189695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sl9CNn1EVZEpq7y7cqXda6K3glgb23SOapyyZsDMnjg=;
        b=ZLzcJ4o/N+6BP5y8EBdTfbUKO2vq69n93YWRGNH+qAPTJkvNfTBM8sDt/AGYyZGgg5
         Abkry1uhXi82L8Xolf8UUVhU9DndTq/nivcYtTPTc4L2C7xQIaled/RIX26DD0auhPEF
         RE0SHtR5E/OFXC2QO0AERQV0JlcyZCz4a1/GZ1MT/Euk6UMsl7FpHvLGKWhBH8gzJ76Y
         y4IHLGiYh8q3v0busp+SFNB432jkkwUBf2o7JERCKJDPGlTFoxiurQeKojWxz/bHcAQU
         SOfhNaooCY5JXAPrNhYz/ffHxMWXTVjEc/XgEfQ0cGAGe5U1ooSLonU5xl0kEiiN3r45
         DElA==
X-Forwarded-Encrypted: i=1; AJvYcCWcxSUSkbl7gS3nu+lNTsX6tni0mESz1xoMU4M+nM1HUdqscoh0eB3JlHZWVQ6k0FSba4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmdkLHgWhyxR1m7KezslW2zZuHv6Zq1xisL564SGREY+Zp0uLW
	gT0m1CrXF/tEareCVKiaHkeyou/sx/Und+DYstkCacXIAato3O7pUFtwurmygYiyB1Eluw8lcRS
	wMjpmi0jpm+UvQPqlhjKMFA==
X-Google-Smtp-Source: AGHT+IE8+xrHCWoej8QIHCaGCUtpB6hyutXgRJeL9Co2narXZoICzwtqZy/98P5K8Cw5wHfygJT+Pm+hzJ2VPvoE
X-Received: from dycmv3.prod.google.com ([2002:a05:693c:2803:b0:2ac:3a02:feae])
 (user=marcmorcos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:6213:b0:2a4:3593:ddf3 with SMTP id 5a478bee46e88-2ac3012b8a3mr3278144eec.32.1765584895347;
 Fri, 12 Dec 2025 16:14:55 -0800 (PST)
Date: Sat, 13 Dec 2025 00:14:42 +0000
In-Reply-To: <20251213001443.2041258-1-marcmorcos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251213001443.2041258-1-marcmorcos@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251213001443.2041258-4-marcmorcos@google.com>
Subject: [PATCH 3/4] qmp: Fix thread race
From: Marc Morcos <marcmorcos@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Eduardo Habkost <eduardo@habkost.net>, "Dr . David Alan Gilbert" <dave@treblig.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Marc Morcos <marcmorcos@google.com>
Content-Type: text/plain; charset="UTF-8"

This fixes a thread race involving the monitor in monitor_qmp_event and monitor_qapi_event_emit .

Signed-off-by: Marc Morcos <marcmorcos@google.com>
---
 monitor/monitor.c | 11 ++++++++++-
 monitor/qmp.c     |  6 ++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/monitor/monitor.c b/monitor/monitor.c
index c5a5d30877..4bfd72939d 100644
--- a/monitor/monitor.c
+++ b/monitor/monitor.c
@@ -338,6 +338,7 @@ static void monitor_qapi_event_emit(QAPIEvent event, QDict *qdict)
 {
     Monitor *mon;
     MonitorQMP *qmp_mon;
+    bool do_send = false;
 
     trace_monitor_protocol_event_emit(event, qdict);
     QTAILQ_FOREACH(mon, &mon_list, entry) {
@@ -346,7 +347,15 @@ static void monitor_qapi_event_emit(QAPIEvent event, QDict *qdict)
         }
 
         qmp_mon = container_of(mon, MonitorQMP, common);
-        if (qmp_mon->commands != &qmp_cap_negotiation_commands) {
+        do_send = false;
+
+        WITH_QEMU_LOCK_GUARD(&mon->mon_lock) {
+            if (qmp_mon->commands != &qmp_cap_negotiation_commands) {
+                do_send = true;
+            }
+        }
+
+        if (do_send) {
             qmp_send_response(qmp_mon, qdict);
         }
     }
diff --git a/monitor/qmp.c b/monitor/qmp.c
index cb99a12d94..e1419a9efa 100644
--- a/monitor/qmp.c
+++ b/monitor/qmp.c
@@ -462,8 +462,10 @@ static void monitor_qmp_event(void *opaque, QEMUChrEvent event)
 
     switch (event) {
     case CHR_EVENT_OPENED:
-        mon->commands = &qmp_cap_negotiation_commands;
-        monitor_qmp_caps_reset(mon);
+        WITH_QEMU_LOCK_GUARD(&mon->common.mon_lock) {
+            mon->commands = &qmp_cap_negotiation_commands;
+            monitor_qmp_caps_reset(mon);
+        }
         data = qmp_greeting(mon);
         qmp_send_response(mon, data);
         qobject_unref(data);
-- 
2.52.0.239.gd5f0c6e74e-goog


