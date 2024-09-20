Return-Path: <kvm+bounces-27212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D27497D7A5
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 17:44:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 576DAB23C8F
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 15:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1056D17DE16;
	Fri, 20 Sep 2024 15:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c6kgXt/a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E02117A583
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 15:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726847072; cv=none; b=E+VruZeNrbT0SPD9OF7YnUG4jRnMS3jJD1MaQnBAJvgGB44sdArV9bGrvjfQehUzbm36MxnSb9O61OpdDqjntgQnLlVsQNAjziq9RjuBLmzPiy1ugwCc5jpQe9rccEjOzcy6D6ESGKxeIH2cuChHQX4ZeT+4isHfucl3kGzB9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726847072; c=relaxed/simple;
	bh=L4F9t9eX2mGkrFvAoAO4WcKWW0cmDO9vUJ06dP3REH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pMmhKREP//2LVXpwwbMhyIazvlVsWZtV1aWeJuLvklJ4ucLNiwJHkMWNKR244Qmgy+OIXtwtf8yaNb5QHTBHUd+Ua9csAYTrOCW259yvB6TRjOAqRRSf1PfePlpR5mdEX1WvfjQoWQjDPdBbbym0aFwPCUSQmxrJMC/fZjJ5Rr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c6kgXt/a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726847068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tuUFCphhzHU/5+RQPnqBt9ZmoF79wTTTNRlLo/sGdJo=;
	b=c6kgXt/acPGlGfAC1oNRjDmfaJUagMQlm4ZQ+BIEOLJWMRIzxAxKNVznQL0wyUtqJq3BuS
	g7x/62cPcsYjx4ENdlg8vx398E7YbCC1VnRRqXKX/Az8LXMaV9VZj56738JTc+BqRjg+mX
	EQXv4++xWoJSWWSay9ba67ph/pwO7B8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-UyipB_pMMiqs5u6zSbBI3g-1; Fri,
 20 Sep 2024 11:44:26 -0400
X-MC-Unique: UyipB_pMMiqs5u6zSbBI3g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A44BD19137AA;
	Fri, 20 Sep 2024 15:44:25 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.225.184])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 90AAA19560AF;
	Fri, 20 Sep 2024 15:44:23 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Jan Richter <jarichte@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: x86: Avoid using SSE/AVX instructions
Date: Fri, 20 Sep 2024 17:44:22 +0200
Message-ID: <20240920154422.2890096-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Some distros switched gcc to '-march=x86-64-v3' by default and while it's
hard to find a CPU which doesn't support it today, many KVM selftests fail
with

  ==== Test Assertion Failure ====
    lib/x86_64/processor.c:570: Unhandled exception in guest
    pid=72747 tid=72747 errno=4 - Interrupted system call
    Unhandled exception '0x6' at guest RIP '0x4104f7'

The failure is easy to reproduce elsewhere with

   $ make clean && CFLAGS='-march=x86-64-v3' make -j && ./x86_64/kvm_pv_test

The root cause of the problem seems to be that with '-march=x86-64-v3' GCC
uses AVX* instructions (VMOVQ in the example above) and without prior
XSETBV() in the guest this results in #UD. It is certainly possible to add
it there, e.g. the following saves the day as well:

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 78878b3a2725..704668adb3bd 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -82,8 +82,17 @@ static void test_hcall(struct hcall_data *hc)

 static void guest_main(void)
 {
+	uint64_t cr4, xcr0;
        int i;

+	cr4 = get_cr4();
+	cr4 |= X86_CR4_OSXSAVE;
+	set_cr4(cr4);
+
+	xcr0 = xgetbv(0);
+	xcr0 |= XFEATURE_MASK_SSE | XFEATURE_MASK_YMM;
+	xsetbv(0x0, xcr0);
+
        for (i = 0; i < ARRAY_SIZE(msrs_to_test); i++) {
                test_msr(&msrs_to_test[i]);
        }

but this needs to be made conditional depending on the compilation target
and added to all selftests. Slap a band-aid on the problem by forcing
'-march=x86-64-v2' in Makefile.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..3f1b24ed7245 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -238,6 +238,7 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
+	-march=x86-64-v2 \
 	$(KHDR_INCLUDES)
 ifeq ($(ARCH),s390)
 	CFLAGS += -march=z10
-- 
2.46.0


