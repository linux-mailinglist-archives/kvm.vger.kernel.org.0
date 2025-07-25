Return-Path: <kvm+bounces-53437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 028CFB11B44
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 11:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 512BE17CC2B
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 09:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9390B2D5C74;
	Fri, 25 Jul 2025 09:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CviF53b1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058072D4B5A
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753437281; cv=none; b=F5JFW3eYpw4EEH1lI93UWlUThnv8rSvUHD6JlYdutXA+za2sPucmlHTMpRy5imiK3EvD6Tdzib6WevkKr/rbD9215bsfF7CXrRp/OwQnsVrkrhByqlQlBW89ZBmFNMNdhIy5vNfKk5BBHUBv838S/Sy+hWwUYshdtydIr2M+tKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753437281; c=relaxed/simple;
	bh=T0CKwAg9qn7pAYD1/cXJvKn3Paev1yX2ytGetqqpFbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mS1ld4zXIg4f1l8/ykxD/wfTytcCi9KJBcskNZftVd9abvbnGAXE8JtfdjsS31kZ2OzBjhNmIw3/J/YP7289nND4GRYsnTY9OZnwwnhH1bsrci1Xo0mdjusOMHEv0fQMFBfGk4+cHs8H7znrPgxupVxwpUY368tJhW1U5z1qozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CviF53b1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753437278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7XLDKmc4YLwKP+EDqPlB6Zt0UTCWXVw4t2K/ECld3j8=;
	b=CviF53b1z9NCWkQv7ABueuRLe+50TRrBm+3ZeuO2l189v7CTxe+8gof87/smsQ8zyBPCIu
	0E/IRSGmHiVwMPB6PDuF13x6OVCZ/ZH3nRll32eenQV2FxTqOPVkM7wHBBGCvyLJ2/O1i9
	hzhYQ2w4ec2Wz4oJ1C2rxOa4lvOBUjk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-kEQ9YfUpNQu4gdH8RpeLQQ-1; Fri,
 25 Jul 2025 05:54:36 -0400
X-MC-Unique: kEQ9YfUpNQu4gdH8RpeLQQ-1
X-Mimecast-MFC-AGG-ID: kEQ9YfUpNQu4gdH8RpeLQQ_1753437275
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92EEA1800876
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:35 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D2CC1966665;
	Fri, 25 Jul 2025 09:54:34 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	peterx@redhat.com
Subject: [kvm-unit-tests PATCH v4 2/5] x86: fix APs with APIC ID more that 255 not showing in id_map
Date: Fri, 25 Jul 2025 11:54:26 +0200
Message-ID: <20250725095429.1691734-3-imammedo@redhat.com>
In-Reply-To: <20250725095429.1691734-1-imammedo@redhat.com>
References: <20250725095429.1691734-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

save_id() is called too early and uses xapic ops, which is fine
up to 2566 cpus.
However with that any CPU with APIC ID more than 255 will set
wrong bit in online_cpus (since xapic ops only handle 8bit IDs,
thus losing all higher bit x2apic might have).
As result CPUs with id higher than 255 are not registered
(they will trumple over elements in range 0-255 instead).

To fix it move save_id() after the point where APs have
switched to x2apic ops, to get non-truncated ID.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 lib/x86/setup.c | 2 +-
 x86/cstart.S    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 122f0af3..c2f1c6d0 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -391,9 +391,9 @@ void ap_start64(void)
 	setup_gdt_tss();
 	reset_apic();
 	load_idt();
-	save_id();
 	enable_apic();
 	enable_x2apic();
+	save_id();
 	ap_online();
 }
 
diff --git a/x86/cstart.S b/x86/cstart.S
index 8fb7bdef..dafb330d 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -99,9 +99,9 @@ ap_start32:
 	call load_idt
 	call prepare_32
 	call reset_apic
-	call save_id
 	call enable_apic
 	call enable_x2apic
+	call save_id
 	call ap_online
 
 	/* ap_online() should never return */
-- 
2.47.1


