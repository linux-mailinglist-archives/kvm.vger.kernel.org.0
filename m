Return-Path: <kvm+bounces-11175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B79873D48
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0407F1F262EE
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D5113D2E4;
	Wed,  6 Mar 2024 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PqCu/seV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA03C13A875
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745513; cv=none; b=lNMVoeZqUaOLL8MnQrOEmemJ7FEd+ipE2qU9WT3gcwXuibiWuE9QDUsxd4xWT0vJldi0J4AOF1B+K+DI4V4e7dleSe1xL2Xa7GhOsE0nMQmszqmc2awi+BwoI3LNdHb56VWxWYM/Xg53gPd33l3uOZYuPIsXOKD6wE103njI4BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745513; c=relaxed/simple;
	bh=sPoHrIj+1VVruLjCgBWFx9RjGHfF471LR1/mWWKaQog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZY0MyFhiv7ReyYtGNXSnYvDdl17UkB1mVNZDA/3KHC4m2u6oFAXHY3BsvWNjXELhFZXvGLqvL9qN6T1KLa10rJ4BKE6lXfBJQzTknozL7Zt/9UhXvvvSVNyNHYzWLMICmaA7gJHygpNz/TFeHroWNAxSJ0q/94Z//fy1glrWG5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PqCu/seV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y6F+rL2aeBRT+VdhqfM0zvutPYZDf1aP6YuQs82OQ34=;
	b=PqCu/seVKdruCXipBIsSHcmDsDMEHCmE6CdT9QUEZGdWoZwtQsrVbhKqjOdQ0w1TggU5xQ
	PlW4Qg3sX7gwE40ORosuqWQ/s/pl7iC1FTMyBnkm5OtIhwJYkT/NwzyrHMhggcZyYwhLlc
	s+p/lPROXrvc4cgoO+SGeni0cUTaXC0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-17YYX9D4PEeg2M5_qTH-bQ-1; Wed,
 06 Mar 2024 12:18:29 -0500
X-MC-Unique: 17YYX9D4PEeg2M5_qTH-bQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1DE13C0CEE5;
	Wed,  6 Mar 2024 17:18:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4839540C6CB8;
	Wed,  6 Mar 2024 17:18:28 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 04/13] x86: hyperv_clock: print sequence field of reference TSC page
Date: Wed,  6 Mar 2024 18:18:14 +0100
Message-ID: <20240306171823.761647-5-vkuznets@redhat.com>
In-Reply-To: <20240306171823.761647-1-vkuznets@redhat.com>
References: <20240306171823.761647-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Metin Kaya <metikaya@amazon.com>

Having TscSequence in the log message for completeness.

Signed-off-by: Metin Kaya <metikaya@amazon.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index dcf101af6968..9c30fbebf249 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -181,7 +181,8 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	printf("scale: %" PRIx64" offset: %" PRId64"\n", shadow.tsc_scale, shadow.tsc_offset);
+	printf("sequence: %u. scale: %" PRIx64" offset: %" PRId64"\n",
+	       shadow.tsc_sequence, shadow.tsc_scale, shadow.tsc_offset);
 	ref1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
 	tsc1 = rdtsc();
 	t1 = hvclock_tsc_to_ticks(&shadow, tsc1);
-- 
2.44.0


