Return-Path: <kvm+bounces-1610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 887717EA243
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 18:43:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B78F61C20964
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 17:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C1EF224F1;
	Mon, 13 Nov 2023 17:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlPJj9La"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C031224E3
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 17:43:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3831110E5
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 09:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699897410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rqt89Efo92L9gQUjQREL1i3618rnBSc+Vh+WfUyKjto=;
	b=HlPJj9La7spcJWRg2yYw3nl4u+0lGk0rTfV05kKhey/0pM+CIBeoa4hfq34Wocdv2hc8ZF
	N67xOIprw1SwuBmw0nFufxi4OEoRLUVa8ZB2tTL/S/Ke6vHEqzGk3w2zkmPHQXOvnYopg/
	Lax0b4PWxNrhG2KoP2GCGiTl4wU6oBs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-9iy_81rePDapSoTfL6QrKA-1; Mon, 13 Nov 2023 12:43:27 -0500
X-MC-Unique: 9iy_81rePDapSoTfL6QrKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1607F83B825;
	Mon, 13 Nov 2023 17:43:27 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.115])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D7BC1121306;
	Mon, 13 Nov 2023 17:43:25 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev,
	maz@kernel.org,
	oliver.upton@linux.dev,
	alexandru.elisei@arm.com
Cc: jarichte@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/2] arm: pmu-overflow-interrupt: Fix failures on Amberwing
Date: Mon, 13 Nov 2023 18:42:39 +0100
Message-ID: <20231113174316.341630-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Qualcomm Amberwing, some pmu-overflow-interrupt failures can be observed.
Although the even counter overflows, the interrupt is not seen as
expected on guest side. This happens in the subtest after "promote to 64-b"
comment.

After analysis, the PMU overflow interrupt actually hits, ie.
kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
as expected. However the PMCR.E is reset by the handle_exit path, at
kvm_pmu_handle_pmcr() before the next guest entry and
kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
There, since the enable bit has been reset, kvm_pmu_update_state() does
not inject the interrupt into the guest.

This does not seem to be a KVM bug but rather an unfortunate
scenario where the test disables the PMCR.E too closely to the
advent of the overflow interrupt.

Since it looks like a benign and inlikely case, let's resize the number
of iterations to prevent the PMCR enable bit from being resetted
immediately at the same time as the actual overflow event.

Also make pmu_stats volatile to prevent any optimizations.

Eric Auger (2):
  arm: pmu: Declare pmu_stats as volatile
  arm: pmu-overflow-interrupt: Increase count values

 arm/pmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.41.0


