Return-Path: <kvm+bounces-63146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B3393C5AC8E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 87CC2351386
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3AA221264;
	Fri, 14 Nov 2025 00:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="behQMah2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9538521E097
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080600; cv=none; b=Nnak+B+UKxxBBQiBoDKt2/hO3dWGPxC2Azna8hF3UTJvTKyRXtPl9/K/SGONHJNWdAiw+AH4YffS2DlA0jdTzqFqe7h12cFm3WS3x/jJO4afHObBUZ3q2EIrgyk2gegAirqIND8/ma6n+DnlXlWDCuN81v9lyupUCUXIp9dSAuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080600; c=relaxed/simple;
	bh=/4OvoTGSnwuRGElbpcpcCkhtjNcwlNRhvF80WqoXkWE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=df83bodyZ/jn2kmTQQZYKxiUd74PDrB546OOPyycuWgPBZy7TndzmDm0QMOnW8vsxl7Qut+VKHUBXzoh38Lt8IqNbWeVYhC4nZcPEmWevUVOZJaEhwzv/iOH4i1/gxo5uMmjwNHvagZgbncv+3XV6mthw+m+swrLXoaHCaI/Vsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=behQMah2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y6gdCEUSKAqGLkXmCa0ZgxAX0rIUhnlNbvkRkF2TaQc=;
	b=behQMah2LQFK8di6ZSXr9lf0MhoxL1LActQJdnZAI+mQgXpe49L4eLU3Ml5tKC60Iwc/KM
	nVevsBPs/i6xpv57QT1oKRSiW1zZSfujlkW4tSU1cctQWH6vp6dnmPbeK6YzHF/3agKa48
	mLcu9MNZc0/eto3N2HNsk86nH5nu2Eg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-O_KePOPnNcWP4dTwyvWBkg-1; Thu,
 13 Nov 2025 19:36:36 -0500
X-MC-Unique: O_KePOPnNcWP4dTwyvWBkg-1
X-Mimecast-MFC-AGG-ID: O_KePOPnNcWP4dTwyvWBkg_1763080595
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8CDA19560B2;
	Fri, 14 Nov 2025 00:36:34 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D1C419560B9;
	Fri, 14 Nov 2025 00:36:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 00/10] KVM: emulate: enable AVX moves
Date: Thu, 13 Nov 2025 19:36:23 -0500
Message-ID: <20251114003633.60689-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Over a year ago, Keith Busch posted an RFC patch to enable VMOVDQA
and VMOVDQU instructions in the KVM emulator.  The reason to do so
is that people are using QEMU to emulate fancy devices whose drivers
use those instructions with BARs that, on real hardware, would
presumably support write combining.  These same people obviously
would appreciate being able to use KVM instead of emulation, hence
the request.

The original patch was not bad at all, but missed a few details:

- checking in XCR0 if AVX is enabled (which also protects against
  *hosts* with AVX disabled)

- 32-bit support

- clearing the high bytes of AVX registers if VEX.L=0

- checking some invalid prefix combinations

The ugly parts are in patch 7, which has to juggle the fact that the
same instruction can decode to SSE and AVX, and we only know which are
valid after all the groups are handled.

While at it I also included a small refactoring taken out of the
APX series, by Chang S. Bae, some cleanups, and an extra MOVNTDQ
instruction.

Paolo

Chang S. Bae (1):
  KVM: x86: Refactor REX prefix handling in instruction emulation

Paolo Bonzini (9):
  KVM: emulate: add MOVNTDQA
  KVM: emulate: move Src2Shift up one bit
  KVM: emulate: improve formatting of flags table
  KVM: emulate: move op_prefix to struct x86_emulate_ctxt
  KVM: emulate: share common register decoding code
  KVM: emulate: add get_xcr callback
  KVM: emulate: add AVX support to register fetch and writeback
  KVM: emulate: decode VEX prefix
  KVM: emulate: enable AVX moves

 arch/x86/kvm/emulate.c     | 320 ++++++++++++++++++++++++++-----------
 arch/x86/kvm/fpu.h         |  62 +++++++
 arch/x86/kvm/kvm_emulate.h |  20 ++-
 arch/x86/kvm/x86.c         |   9 ++
 4 files changed, 311 insertions(+), 100 deletions(-)

-- 
2.43.5


