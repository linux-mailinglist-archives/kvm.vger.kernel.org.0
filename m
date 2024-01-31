Return-Path: <kvm+bounces-7609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC70E844B40
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96DB8293253
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 22:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9C83B290;
	Wed, 31 Jan 2024 22:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGKUiRhq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613F23A8DB
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 22:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741421; cv=none; b=FEUnfbw+k7sT48i1jGneajPtn5kj/FmhUleMj5dzuFNtHLp+sjcABveuYrXlhTUO5YCKxt76w+bviAPx/MUgpXYtFhU+guwWzF3KxF3EXFvMGHmf/VfycIerEfHGy/4opJ44Ivg7YE4vyMKjsFmrOop1iW52Di/gQB1BlDss+AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741421; c=relaxed/simple;
	bh=tyhKQEGxoc+5LKT2qa+NyC+5aGWDrPkCzeF83mjdXcs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=BxGpEf7sdZwo9xFknaNppGVR/t6G0CUELEDEQEOAdPHMKq67LDmFwDtNR4q2UavJeFlkUO7gcmCD+wXbRBKiXjAU4QCZF2NsO6c2MlK92jrtHaU0BfGgydiNniMh9t7mf8p55EkEAudvAQ71EOeDg9wBg74ZiwtLk64sbSl4sHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cGKUiRhq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706741418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pvCHdlS/17NOGeP+h3aQQiZmVhEUhvCy/DRXsIIS27s=;
	b=cGKUiRhq89xdP3EM0mk7sTKv67HS38hqUDEKks4VuD2ibEgMXcW+venAWAbjerJbmp0zXH
	nkbubm4Z9tp4UqNG5FmF3UxQRh1JeeDifCdtUGYpAwcjdKhq6uCoqW5T5iXWVAOcvlCAkf
	drPHUYq1ODblOWlKE6ywbGdDMiKSFLU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-Z0eXEX_7P7-_-D6qfxh7Pw-1; Wed, 31 Jan 2024 17:50:11 -0500
X-MC-Unique: Z0eXEX_7P7-_-D6qfxh7Pw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07FE6101A526;
	Wed, 31 Jan 2024 22:50:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D841E2166B31;
	Wed, 31 Jan 2024 22:50:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: dionnaglaze@google.com,
	seanjc@google.com
Subject: [PATCH 0/3] kvm: x86: fix macros that are not usable from userspace
Date: Wed, 31 Jan 2024 17:50:07 -0500
Message-Id: <20240131225010.2872733-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

uapi headers cannot use BIT or GENMASK (or the corresponding long long
versions), since those macros are not defined in uapi headers.  Instead,
it is possible to use _BITUL/_BITULL, or the __GENMASK and __GENMASK_ULL
introduced at the beginning of this series.

Paolo

Dionna Glaze (1):
  kvm: x86: use a uapi-friendly macro for BIT

Paolo Bonzini (2):
  uapi: introduce uapi-friendly macros for GENMASK
  kvm: x86: use a uapi-friendly macro for GENMASK

 arch/arm64/include/uapi/asm/kvm.h      |  8 ++++----
 arch/x86/include/uapi/asm/kvm.h        | 14 ++++++++------
 arch/x86/include/uapi/asm/kvm_para.h   |  2 +-
 include/linux/bits.h                   |  8 +-------
 include/uapi/asm-generic/bitsperlong.h |  4 ++++
 include/uapi/linux/bits.h              | 15 +++++++++++++++
 6 files changed, 33 insertions(+), 18 deletions(-)
 create mode 100644 include/uapi/linux/bits.h

-- 
2.39.0


