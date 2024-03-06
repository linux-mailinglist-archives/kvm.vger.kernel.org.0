Return-Path: <kvm+bounces-11180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7072F873D4E
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C85E28439A
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C1613E7D9;
	Wed,  6 Mar 2024 17:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hL26/XyA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B828413BAF6
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745516; cv=none; b=UdaoBFhYN/bYdCYUfVxnn723OGqH72N3E78QUw6u4DU7t/5E4R5OVmU8I9aI81hNBYBtaC4/VJBSGxipzloybx7fQxMbh7v9j+Qu0KuL/HZFFWIun6u2uovLbLRpscz/Y8DjOlJ7ah8YxhT6mnASTsIZOZ5daC1rK8rg4E3pC1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745516; c=relaxed/simple;
	bh=0ybuAdRdhU4IHHmuKOQBbiOmlVT/xG5YsyUV4TZM7DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pVy+qDDE/7yaGNoX0ex3BPMDdOBsnBmxtpidTN1nCjM7izQfQG4FoqPaBQTQ1986nnYXaTFutxFOlGQiGVK4ZNQYzTfVVmVRe6dPuoM29pAX/MpqVYg5SDHbtLPYUBoMhbpwTuL3IL6/OolncqGdWYFADEzePcWZfmd7bQcjQuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hL26/XyA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GYl1lad5fdnKbNmseWR53XRD+84jZjcyseZuHemsUmQ=;
	b=hL26/XyAQOpk1fD3MHrNwZoQwWZ4HVt6t7mw5eSa5ul/qYmJod9QebSdwc+zw9Jx04snlD
	eISgXgnqBBITtocwV3SFmfRLgyyIbQmXBiSjT3kzqYW4HXdzbWqD7UR5IBeFOlTyagMMrQ
	XSEEiePoRIWOyLUsRhYx6kza76WNSO4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-jqPp9NwENwant8eHOvGsjw-1; Wed, 06 Mar 2024 12:18:31 -0500
X-MC-Unique: jqPp9NwENwant8eHOvGsjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D37D0185A783;
	Wed,  6 Mar 2024 17:18:30 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EF0740C6CB8;
	Wed,  6 Mar 2024 17:18:30 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 06/13] x86: hyper-v: Use report_skip() in hyperv_stimer when pre-requisites are not met
Date: Wed,  6 Mar 2024 18:18:16 +0100
Message-ID: <20240306171823.761647-7-vkuznets@redhat.com>
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

'report_pass()' is supposed to be used when tests actually pass, use
'report_skip()' to match other tests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_stimer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 2344eaf56f11..9259e28c6a90 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -353,17 +353,17 @@ int main(int ac, char **av)
 {
 
     if (!hv_synic_supported()) {
-        report_pass("Hyper-V SynIC is not supported");
+        report_skip("Hyper-V SynIC is not supported");
         goto done;
     }
 
     if (!hv_stimer_supported()) {
-        report_pass("Hyper-V SynIC timers are not supported");
+        report_skip("Hyper-V SynIC timers are not supported");
         goto done;
     }
 
     if (!hv_time_ref_counter_supported()) {
-        report_pass("Hyper-V time reference counter is not supported");
+        report_skip("Hyper-V time reference counter is not supported");
         goto done;
     }
 
-- 
2.44.0


