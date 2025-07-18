Return-Path: <kvm+bounces-52912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CED90B0A80C
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 783891C42B75
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6915C2E5B1C;
	Fri, 18 Jul 2025 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DN/lCud9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90582E5B00
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752854268; cv=none; b=DVvy2wMsZC689OLTcla6KTA0ggkT7upRjoTh2ZF62phiADjBbFrAhbKd/KhP/tqidIwqFvaSFS7ChTAub53EKPT1GJv4odaFaiPYSSNhgQ8uwnks/eirLsMs31PNAUL/pkspcLMESOgvmSx7f2mD0RYfUkWgZpyLCViLHfYdjyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752854268; c=relaxed/simple;
	bh=sKn4I1Q8/dV1kY6FbZh+mGn3c7jb0sUHs9VD6LqSCD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6NkPGvtT/YzIQING3pzZednv8mgAFTlLEKlRpg1Tjga2MR/p64t0nVewhsoa0yJMXF7KGAKIuhZgNgkEhrtJCsHaZjLmNRMaczRqYsBtJSRmJZgK5e6lkzutpOPOmFqq88bAmFnKWVgpF5T8u/mX7JZQ96YhLv1HNKMFJigtEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DN/lCud9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752854265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E+bEpnt2tGVcJbg5mbQnyh11/6AgFqfvv8aV7cUdk98=;
	b=DN/lCud9XgePOAi7PSDh5uzf9HUkB3h4EurdJSwQlecXY6ArIClEMH3w8OLXlrQ2i3eqR6
	grH33wX1jmWoJNioAVhIrR9FWowYgE0KPCE8SzMdGzjgzcxCvuo+nhUe5tGBVkRdwCT/DX
	wH+mXB+ZvPWOUHeIuaMYzn3OYGjSvlE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-ZERtI2ySMiiERdrsVhMSPw-1; Fri,
 18 Jul 2025 11:57:43 -0400
X-MC-Unique: ZERtI2ySMiiERdrsVhMSPw-1
X-Mimecast-MFC-AGG-ID: ZERtI2ySMiiERdrsVhMSPw_1752854263
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 255DD19560A7
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:57:43 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4DAD7195608D;
	Fri, 18 Jul 2025 15:57:42 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/2] x86: bump number of max cpus to 448
Date: Fri, 18 Jul 2025 17:57:37 +0200
Message-ID: <20250718155738.1540072-2-imammedo@redhat.com>
In-Reply-To: <20250718155738.1540072-1-imammedo@redhat.com>
References: <20250718155738.1540072-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 lib/x86/smp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index bbe90daa..0f62cf2e 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -1,7 +1,7 @@
 #ifndef _X86_SMP_H_
 #define _X86_SMP_H_
 
-#define MAX_TEST_CPUS (255)
+#define MAX_TEST_CPUS (448)
 
 /*
  * Allocate 12KiB of data for per-CPU usage.  One page for per-CPU data, and
-- 
2.47.1


