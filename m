Return-Path: <kvm+bounces-11172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D35B873D45
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDA40282993
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FAF13BAE5;
	Wed,  6 Mar 2024 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5pkaS3A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5D660250
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745512; cv=none; b=DY9Nij3usYPtos+yV0+RBYUfduWWaIeUxP9JsbHaIJosy8UgosWPypDZG+t1araE3ahmrb1PyHADZUzcoyn3EZoLRgqWkdxxeSb/94AI0eWHF2B/9+YhJ3nfKLsgsHb3XSNkmK+mGDI3Oo/70zGWw1+2Bfwu12kxmDe4FfCzmZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745512; c=relaxed/simple;
	bh=gQShW6mrwuJgtjfCmbaf/VfVG40ZYLhgb0YQvx0pCRw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hm1X9SIzAnmzJatudpOE5cIDkdQn7TSGNx9RnMnLFiLJaMKNSikRqlxr4xRiLpEn/ks0w5T6DIBGfBHQnCPO1a/f93+C4MNLZ7WoTXl6Gyo5fRiYEN2a4gggT8FKx9hlP9VBd8HafB1nT8Uk5wQF0NKdniXVSwxePoztmShFRBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5pkaS3A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vAiMQkizcK+ZBLRavbWOq3BsbczbChOMxHhomOO3qlE=;
	b=G5pkaS3AQDydzmEJ9kQv/Ms1DzJbPAGxdRV/haS8HvFXRx58TeyRGRcze6jlLNMSnqBZdJ
	WifTkkY46SW8jy2WsDNCQ8JMY/1v/Hvd6mW5xNu2mrpExoWZNOs3Qoq0+MURfGUqvpaOuC
	UAZmY7j3ppFSoww9Vnf8UIcZAE8CorA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-QhJwoz6UPeWgwjVGYr7b_g-1; Wed, 06 Mar 2024 12:18:26 -0500
X-MC-Unique: QhJwoz6UPeWgwjVGYr7b_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44C758007A3;
	Wed,  6 Mar 2024 17:18:25 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B48240C6CB8;
	Wed,  6 Mar 2024 17:18:24 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 00/13] x86: hyperv-v: Various unmerged patches
Date: Wed,  6 Mar 2024 18:18:10 +0100
Message-ID: <20240306171823.761647-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

A number of Hyper-V related patches were sent in the past but never made it
to kvm-unit-tests tree. As there are code dependencies between them, I've
decided to put them all in a combined series. Besides various fixes, the
series adds support for !CONFIG_KVM_HYPERV and direct mode synthetic timers.

Metin Kaya (4):
  x86: hyperv: Use correct macro in checking SynIC timer support
  x86: hyperv: improve naming of stimer functions
  x86: hyperv_clock: handle non-consecutive APIC IDs
  x86: hyperv_clock: print sequence field of reference TSC page

Vitaly Kuznetsov (9):
  x86: hyper-v: Use '-cpu host,hv_passhtrough' for Hyper-V tests
  x86: hyper-v: Use report_skip() in hyperv_stimer when pre-requisites
    are not met
  x86: hyper-v:  Use 'goto' instead of putting the whole test in an 'if'
    branch in hyperv_synic
  x86: hyper-v: Unify hyperv_clock with other Hyper-V tests
  x86: hyperv_stimer: keep SINT number parameter in 'struct stimer'
  x86: hyperv_stimer: define union hv_stimer_config
  x86: hyperv_stimer: don't require hyperv-testdev
  x86: hyperv_stimer: add direct mode tests
  x86: hyperv-v: Rewrite flaky hv_clock_test()

 x86/hyperv.h             |  35 ++++++--
 x86/hyperv_clock.c       |  87 +++++++++++--------
 x86/hyperv_connections.c |   2 +-
 x86/hyperv_stimer.c      | 176 ++++++++++++++++++++++++++++++---------
 x86/hyperv_synic.c       |  61 +++++++-------
 x86/unittests.cfg        |  14 +++-
 6 files changed, 259 insertions(+), 116 deletions(-)

-- 
2.44.0


