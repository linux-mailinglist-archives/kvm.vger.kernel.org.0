Return-Path: <kvm+bounces-26050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA5396FEC2
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1713C1F23C1F
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 225B67483;
	Sat,  7 Sep 2024 00:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V0S309Bl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084CAA923
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725670488; cv=none; b=aUOLFX8kSbfN0kWM+ZAGVJpewZp2n4w5jVU0xL3tRKSatoUGeUenxZAOUXvEkLkFS5IwtB+Tf2ebfpyR3SGAqLMTRxM4TVClGKhBO+lzpEkdpnewigKijJ6y/tJHK1bXm59W8OZcTslSrxq75ri2i6zhkp/QNa91eZWlkSeKn4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725670488; c=relaxed/simple;
	bh=Sk7BMH9U0ilyT7f9lRB8rLHqd6xRSaaWI3sNPnLg2CM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=aht8aCITT7wzYcos4X77hUcrNiv00a8QCSAbBVGqqzAG9xIIFUB/dS3iL+SHTRUQgma8o2AsDaeZjs6JndcaJvIdUk87KwgYRxM9EBEt3L03rgmc7pPM5AzM1imzUSaSEJ6RTFoWc2swUZvRlpK7GoB//htjn0W6g6dl9oK50hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V0S309Bl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725670484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GRzb3WHTGcxYFkBYlgB+eIzkvLtqajlXAY9aYVkkz4Y=;
	b=V0S309Bl+yNOmJO7pdF8ycvUMuHLYBmzjwagRy0liZzAWKcw+GRZsi+b77PbxkE2cnvc5C
	QMDF6kd2P7OD2cV0hUiJseeoCYkSFl1L61izoLNn0MhmfKVpJtvqYkpYVxAhSi9viFrp8V
	Wzy2ImWUuuX5ISXuBybWoJ70JfHLD/M=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-403-pEQ-Bh3DMjGhg_YqW_kDFw-1; Fri,
 06 Sep 2024 20:54:43 -0400
X-MC-Unique: pEQ-Bh3DMjGhg_YqW_kDFw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41F631956096
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:42 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3406319560AA;
	Sat,  7 Sep 2024 00:54:41 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [kvm-unit-tests PATCH 0/5] Collection of tests for canonical checks on LA57 enabled CPUs
Date: Fri,  6 Sep 2024 20:54:35 -0400
Message-Id: <20240907005440.500075-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This is a set of tests that checks KVM and CPU behaviour in regard to=0D
canonical checks of various msrs, segment bases, instructions that=0D
were found to ignore CR4.LA57 on CPUs that support 5 level paging.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (5):=0D
  x86: add _safe and _fep_safe variants to segment base load=0D
    instructions=0D
  x86: add a few functions for gdt manipulation=0D
  x86: move struct invpcid_desc descriptor to processor.h=0D
  Add a test for writing canonical values to various msrs and fields=0D
  nVMX: add a test for canonical checks of various host state vmcs12=0D
    fields.=0D
=0D
 lib/x86/desc.c      |  39 ++++-=0D
 lib/x86/desc.h      |   9 +-=0D
 lib/x86/msr.h       |  42 ++++++=0D
 lib/x86/processor.h |  58 +++++++-=0D
 x86/Makefile.x86_64 |   1 +=0D
 x86/canonical_57.c  | 346 ++++++++++++++++++++++++++++++++++++++++++++=0D
 x86/pcid.c          |   6 -=0D
 x86/vmx_tests.c     | 183 +++++++++++++++++++++++=0D
 8 files changed, 667 insertions(+), 17 deletions(-)=0D
 create mode 100644 x86/canonical_57.c=0D
=0D
-- =0D
2.26.3=0D
=0D


