Return-Path: <kvm+bounces-27835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C4198E774
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 01:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78F10286ED5
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 23:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BB91A01D8;
	Wed,  2 Oct 2024 23:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQZ9/eLD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2085D19F117
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 23:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727913426; cv=none; b=GUVdTWbKs5ACik1yMJwsGS/j8TJtJGPPlRNTUVpJ9XfceZq3A4QlSrvWFx0W2zo86675CecpQ1j3ex45WF+TRbtmS8oqM73JCdhGTz9BEuTuOP1htvrEm/OjzfFWMDBtejoYVrvTyESRQh4gzDVXMpYP150Nq9YVoN+h0KD5Dpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727913426; c=relaxed/simple;
	bh=aeal4mtCrM10A6OTbbWpWaiKd6iUg0/K9n/aPwB0eSY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=efzBxeTS1HJgyMdydxDpBI84GpfcDpB8za14OBMxCx9rwl1AGw1By6q7OZ2TVCTateY2dygIk20FIXsXyfQmVpqdAkGBMyJKuTEJxqi+TtQFLyoqh2du17183zstGhEJHL5GywgY7gLE8u/cpYt1yzL8jgiN3EYTFH0Iv8D5eAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SQZ9/eLD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727913422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FU5Pp2/M+yDSKUP8a7PqyIEMaSUfF14h1UyX3fHperc=;
	b=SQZ9/eLDIx6JJmHcOOIWl9ZU76Rx4cI1lqxrfvvO9+/3UaFnH0JL3lbg7noSrNyFcOoG5F
	qyriVlqQBzYlKDuxDAxR3KFnBO2JDG2XYJRVhN+/abyamuZGZP9n18MyhXx03FD8HTySYm
	e051NokOmuDDXQQ9YpmpjQB/ChPc3mQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-15-Uu8OO1DzNNK5GNUcBEADGw-1; Wed,
 02 Oct 2024 19:57:01 -0400
X-MC-Unique: Uu8OO1DzNNK5GNUcBEADGw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA58619560B2
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 23:57:00 +0000 (UTC)
Received: from starship.lan (unknown [10.22.8.54])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B4CDE1956086;
	Wed,  2 Oct 2024 23:56:59 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [kvm-unit-tests PATCH] pmu_lbr: drop check for MSR_LBR_TOS != 0
Date: Wed,  2 Oct 2024 19:56:58 -0400
Message-Id: <20241002235658.215903-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

While this is not likely, it is valid for the MSR_LBR_TOS
to contain 0 value, after a test which issues a series of branches, if the
number of branches recorded was divisible by the number of LBR msrs.

This unfortunately depends on the compiler, the number of LBR registers,
and it is not even deterministic between different runs of the test,
because interrupts, rescheduling, and various other events can affect total
number of branches done.

Therefore drop the check, instead of trying to fix it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/pmu_lbr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index c6f010847..8ca8ed044 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -98,7 +98,6 @@ int main(int ac, char **av)
 	lbr_test();
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
-	report(rdmsr(MSR_LBR_TOS) != 0, "The guest LBR MSR_LBR_TOS value is good.");
 	for (i = 0; i < max; ++i) {
 		if (!rdmsr(lbr_to + i) || !rdmsr(lbr_from + i))
 			break;
-- 
2.26.3


