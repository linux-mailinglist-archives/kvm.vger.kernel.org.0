Return-Path: <kvm+bounces-20178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C74911519
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F27D51C2294F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A280013210D;
	Thu, 20 Jun 2024 21:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NCojgrux"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678B96F311
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919945; cv=none; b=a8KWQSm5qIeJ5lp/7b3OBgvkz/WKH2Q0qnjvqNbY/dfbefMBFfqdRribx6/Q/vMpXjfONFt6KSVMNc97aHVAV6HFpeVbp0fMTw4x5/n6hDydHq13PB0pfQmUh0RvyqAJPCCa6z1obDr8kihjeUJKcj6CjbQyzLb50H3m9w6s2QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919945; c=relaxed/simple;
	bh=5dPtTAG4GW5C/TnFEGEzXMLyNONKVEwIjyeVwDnIYxI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zab/urA7yA3w4QxUEWbbMNCjckcse27874h4yEBWK0mF7nslhDW9Ycj4lQ5LIXvXBNb930QQbMbPRADHwdR4lxebu9Fn4To1VRA+LV2Z4OaoLgAZ4URP5K2cFXhaudS1Itl3k1INK7Ogda8NLgSjWM/nFlvLGDKb081Wz+4ob+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NCojgrux; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718919943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3uaf2uh1YgcypA4A7YUC+Dpsjm4oFokGMV2kONLaLa0=;
	b=NCojgruxuvQgEEzVDh63hAO4Xl5PYuYE/1rqnZESEJstTdKxL4NNM4Bo8L4DIgzsc79y8b
	sLoEvMomtjA6rY+/U4wGQDUvqrYXrhIz/eyNhJqcMM4rvRghzbTWYeI84qH56LnVfVNjYG
	h+d7E8kajZ0xvB5BtMA/12LiSasItHA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-ec37nypyNVm0BopW8vBqNQ-1; Thu,
 20 Jun 2024 17:45:41 -0400
X-MC-Unique: ec37nypyNVm0BopW8vBqNQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5DBD1956095
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:45:40 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1AE601956055
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:45:39 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] fix cirrus-ci-macos-i386 CI job
Date: Thu, 20 Jun 2024 17:45:39 -0400
Message-ID: <20240620214539.89839-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Apparently, on that compiler uint32_t is an unsigned long.  Whatever.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/asyncpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index 9bf2056..ae9c8cc 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -58,7 +58,7 @@ void* virt;
 volatile uint64_t  i;
 volatile uint64_t phys;
 volatile uint32_t saved_token;
-volatile uint32_t asyncpf_num;
+volatile unsigned asyncpf_num;
 
 static inline uint32_t get_and_clear_apf_reason(void)
 {
-- 
2.43.0


