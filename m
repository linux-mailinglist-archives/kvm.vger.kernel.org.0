Return-Path: <kvm+bounces-11178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C777B873D4C
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68AA71F263C4
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD09113A875;
	Wed,  6 Mar 2024 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3RTLavD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8A713B7A9
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745514; cv=none; b=JhX0xDoicwMIosvJJfDgXsHcQc2mQRTBcAVWixrljfxUMybpDLnAXhyFGZVA1zA5leHdyvU4LhRAw9A0uo2LYtPuiP20lNqTyQGNVGAnIC4xJJzhxrIgdzFYdR714Vu2SquhVGjoCSwp9Ud9fZ97fr5hMCc5kxwCuFV5obqc0qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745514; c=relaxed/simple;
	bh=Uv7UzAmC0blmuqBWKqJiiLVqaB1t/iPqoWO3WN2ddyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pw6q44YvVNrqR2r2wyqeEEgqvoQA/+WgnMK2nfbWHQW7jN5fpp79s167G7qI49roWRQKsGRAEVfoPBWPjcBEe1/80UrOCyKtPyF/sW/XC+oLqOZH2oP8Hp7lGK1ykbBVZsp26QFk/Od96zqgpLbuic9Xl25B1SiEhmjzRKqqNF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T3RTLavD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byns24RDf1XWWqpjjM4MoX3F+iLN2xKSc4Emn7CV/HU=;
	b=T3RTLavDCQZiNabcs59CQB0r/iBscdND34L3N0CYDwCuS7sStEnL676KrNrEv1skr4TJVQ
	fSXU0DaIlB69K7ae7lESvtZgBHL+ytHZHKlJnpJ/4G23ax3zq8lBGclyNN7vULh67jaIAZ
	MueqBpd5NWjQLEg7n7N5vq3qSVcbKhs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-137w_avaMLC9Zj7AYqcbxw-1; Wed, 06 Mar 2024 12:18:30 -0500
X-MC-Unique: 137w_avaMLC9Zj7AYqcbxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDF99879845;
	Wed,  6 Mar 2024 17:18:29 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3338240C6CB8;
	Wed,  6 Mar 2024 17:18:29 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 05/13] x86: hyper-v: Use '-cpu host,hv_passhtrough' for Hyper-V tests
Date: Wed,  6 Mar 2024 18:18:15 +0100
Message-ID: <20240306171823.761647-6-vkuznets@redhat.com>
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

To make Hyper-V tests skip gracefully when Hyper-V emulation support is
missing in KVM run all tests with '-cpu host,hv_passhtrough' which is
supposed to enable all enlightenments. Tests can (and will) check CPUID
and report_skip() when the required features are missing.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/unittests.cfg | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3fe59449b650..a5574b105efc 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -451,25 +451,25 @@ arch = x86_64
 [hyperv_synic]
 file = hyperv_synic.flat
 smp = 2
-extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
+extra_params = -cpu host,hv_passthrough -device hyperv-testdev
 groups = hyperv
 
 [hyperv_connections]
 file = hyperv_connections.flat
 smp = 2
-extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
+extra_params = -cpu host,hv_passthrough -device hyperv-testdev
 groups = hyperv
 
 [hyperv_stimer]
 file = hyperv_stimer.flat
 smp = 2
-extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer -device hyperv-testdev
+extra_params = -cpu host,hv_passthrough -device hyperv-testdev
 groups = hyperv
 
 [hyperv_clock]
 file = hyperv_clock.flat
 smp = 2
-extra_params = -cpu kvm64,hv_time
+extra_params = -cpu host,hv_passthrough
 arch = x86_64
 groups = hyperv
 check = /sys/devices/system/clocksource/clocksource0/current_clocksource=tsc
-- 
2.44.0


