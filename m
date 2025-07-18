Return-Path: <kvm+bounces-52913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B35B0A80D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 781241C42ABB
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA882E5B00;
	Fri, 18 Jul 2025 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NeIkwBWf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26D72E54DD
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752854269; cv=none; b=cx9/vUxnaa8BAhzA5YiSdc3AN/DBbAVb9MwstosJNkWGeyzu8jlz4EQ9rR6MV/7L7LxT1LLQf28eO7PI5ygBD924G+ls8LCt/YK5Bh+ifr5r3ZHBmPSKLyQkKcZT3c+MsT8AUcPktNYx8bjQ+TeSXl2R7SYG92vwTEKjyUHxgTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752854269; c=relaxed/simple;
	bh=qQmzRl4OLjkPkTrRmtiqEulYjsrhNbzqdBOD2Rswc9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i3mPofUkypiJ4p5UTD6B0BwSSJcSPffFR/Ojz3XtSPASEUC+A2z0yF4mrcgjsnZzSgyLvCmPd9wt2iXzZDovPGIXVyhfh/GTat4wRpUbmoeNVc7vUUcJCJnmuJAho6XQTbERAoGHZ5BVBTrBgVdCh0cZgiY5IbOufRSzGc2OYnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NeIkwBWf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752854266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uxKrly1pxO8fwuMJglDxd5o/voJTvHi9dZGMdvdxn2I=;
	b=NeIkwBWfafEwXDQ+x2tRrVJGGo7m1srIclrCSxjaQ0+lZEV9OqpCcPWkg5w+PJCdxJppZJ
	lxX63gTBh/mdOw19Fp2fctTz8RAVjUD+K20D43fl0EfZtdiTZnLHZZe7A+/lNSkHU0Fhob
	h5zq0yXyiB+aN3b7K7ygM2nHw24Df1o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-ynPNcbeWN9uRHeDoRDiYqQ-1; Fri,
 18 Jul 2025 11:57:42 -0400
X-MC-Unique: ynPNcbeWN9uRHeDoRDiYqQ-1
X-Mimecast-MFC-AGG-ID: ynPNcbeWN9uRHeDoRDiYqQ_1752854262
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07DE119541A7
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:57:42 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 15FF519560A3;
	Fri, 18 Jul 2025 15:57:40 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] x86: add HPET counter tests
Date: Fri, 18 Jul 2025 17:57:36 +0200
Message-ID: <20250718155738.1540072-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Changelog:
  v3:
     * fix test running long time due to control thread
       also running read test and stalling starting other threads 
     * improve latency accuracy 
     * increase max number of vcpus to 448
       (that's what I had in hands for testing)

previous rev:
  '[PATCH v2] x86: add HPET counter read micro benchmark and enable/disable torture tests'
  https://www.spinics.net/lists/kvm/msg383777.html

Igor Mammedov (2):
  x86: bump number of max cpus to 448
  x86: add HPET counter read micro benchmark and enable/disable torture
    tests

 lib/x86/smp.h        |  2 +-
 x86/Makefile.common  |  2 +
 x86/hpet_read_test.c | 96 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 x86/hpet_read_test.c

-- 
2.47.1


