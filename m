Return-Path: <kvm+bounces-11176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C56873D49
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75BCC1F25F68
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C35960250;
	Wed,  6 Mar 2024 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gFG3kqwn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE96D13A89D
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745513; cv=none; b=IqiUaDbAxrPpzjv4nVO6/mhFPhLFa76WPT3ZOgMchvB18xTyQdg1PMSxQ5KKr7Uty/XH483NvColg3nVJBmgYGjbNvxVZp83iPmfG97DktYmFvz541N1xlnqhJ/5UDSg2IbSSAtBHXQ/CZ7CFNqy3XPlMU9QAPAu8pVfKTvPzcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745513; c=relaxed/simple;
	bh=TzN9Xepo0ygmvg+vRtout1SP86rchOSVx1BVhDSVi2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GvPiI305wj+KxcH8BpeMlpLNqVo1+l7FOfpsPR8OO7S5CWdwj3Lif7GJMoIwjn6blI2jrN95qYmjyK+LhP8dfBi8Ca8X0m19v2X2p3tE0rRCo+cpmp7qslq//q+O9438E9j6U+aq2VPXAkWAKFktwlbY2KkYFOSB7wCaBXYMjY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gFG3kqwn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zAzPHrliN/EFHghrKt7zoU0Zbpjt1QbL6kvaIvezceg=;
	b=gFG3kqwnJIdNExCjeSKpN4kE6NJLJEZmxk3t+xEJ8R1QBQF1bHOMXAdDFffb+XxmQ54XTN
	sgmngSj2rSowY8LOgTcQxkMQLrOGbOSaqonW9bpXCOTsdUefiSYfocH/Wmm/Dh/eWAAlF2
	qCOATmtbDbjkNjJJ0xC55h4BzBbmO+4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-ZeVdgLLDM9WrV0d44DrEQg-1; Wed, 06 Mar 2024 12:18:27 -0500
X-MC-Unique: ZeVdgLLDM9WrV0d44DrEQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27EE28007A1;
	Wed,  6 Mar 2024 17:18:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7294D40C6CB8;
	Wed,  6 Mar 2024 17:18:26 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 02/13] x86: hyperv: improve naming of stimer functions
Date: Wed,  6 Mar 2024 18:18:12 +0100
Message-ID: <20240306171823.761647-3-vkuznets@redhat.com>
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

- synic_supported() is renamed to hv_synic_supported().
- stimer_supported() is renamed to hv_stimer_supported().

Signed-off-by: Metin Kaya <metikaya@amazon.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv.h             | 4 ++--
 x86/hyperv_connections.c | 2 +-
 x86/hyperv_stimer.c      | 4 ++--
 x86/hyperv_synic.c       | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/x86/hyperv.h b/x86/hyperv.h
index bc165c344a11..3e1723ee9609 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -183,12 +183,12 @@ struct hv_input_post_message {
 	u64 payload[HV_MESSAGE_PAYLOAD_QWORD_COUNT];
 };
 
-static inline bool synic_supported(void)
+static inline bool hv_synic_supported(void)
 {
    return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNIC_AVAILABLE;
 }
 
-static inline bool stimer_supported(void)
+static inline bool hv_stimer_supported(void)
 {
     return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNTIMER_AVAILABLE;
 }
diff --git a/x86/hyperv_connections.c b/x86/hyperv_connections.c
index cf043664b329..2c6841553ee4 100644
--- a/x86/hyperv_connections.c
+++ b/x86/hyperv_connections.c
@@ -266,7 +266,7 @@ int main(int ac, char **av)
 {
 	int ncpus, ncpus_ok, i;
 
-	if (!synic_supported()) {
+	if (!hv_synic_supported()) {
 		report_skip("Hyper-V SynIC is not supported");
 		goto summary;
 	}
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index f7c679160bdf..2344eaf56f11 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -352,12 +352,12 @@ static void stimer_test_all(void)
 int main(int ac, char **av)
 {
 
-    if (!synic_supported()) {
+    if (!hv_synic_supported()) {
         report_pass("Hyper-V SynIC is not supported");
         goto done;
     }
 
-    if (!stimer_supported()) {
+    if (!hv_stimer_supported()) {
         report_pass("Hyper-V SynIC timers are not supported");
         goto done;
     }
diff --git a/x86/hyperv_synic.c b/x86/hyperv_synic.c
index 9d61d8362ebd..00655db10131 100644
--- a/x86/hyperv_synic.c
+++ b/x86/hyperv_synic.c
@@ -142,7 +142,7 @@ static void synic_test_cleanup(void *ctx)
 int main(int ac, char **av)
 {
 
-    if (synic_supported()) {
+    if (hv_synic_supported()) {
         int ncpus, i;
         bool ok;
 
-- 
2.44.0


