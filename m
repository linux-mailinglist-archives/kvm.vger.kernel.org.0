Return-Path: <kvm+bounces-2458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 175397F8948
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 09:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4868F1C20C19
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 08:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5638CB67D;
	Sat, 25 Nov 2023 08:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NNfEGEay"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC18DE6
	for <kvm@vger.kernel.org>; Sat, 25 Nov 2023 00:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700901244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gbnARVNy5E0hGES1ua4xRZ6a56me/D63RWZkoJuQ94E=;
	b=NNfEGEayr0ikh3ANBJmFYLcgUoFdHzkmHdiKYswscdEABXM0cs7nOmb7msAHwHf+s8cfBT
	cOTiBYUrVkIlIwaC0aNCW45p9lMe3DlZ438DvqSDn1hOC8RSaQ7qAZHQVhCAZ8wRn+DCDT
	wXajuKelYbQeL6Ulqz2FfgH/0ZX95K0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-P13XO4xENne2rqMu9Rhw2g-1; Sat, 25 Nov 2023 03:34:01 -0500
X-MC-Unique: P13XO4xENne2rqMu9Rhw2g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5203811E7B;
	Sat, 25 Nov 2023 08:34:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BEB751121306;
	Sat, 25 Nov 2023 08:34:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	mlevitsk@redhat.com
Subject: [PATCH v2 0/4] KVM: x86/mmu: small locking cleanups
Date: Sat, 25 Nov 2023 03:33:56 -0500
Message-Id: <20231125083400.1399197-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Remove "bool shared" argument from functions and iterators that need
not know if the lock is taken for read or write.  This is common because
protection is achieved via RCU and tdp_mmu_pages_lock or because the
argument is only used for assertions that can be written by hand.

Also always take tdp_mmu_pages_lock even if mmu_lock is currently taken
for write.

Paolo Bonzini (4):
  KVM: x86/mmu: remove unnecessary "bool shared" argument from functions
  KVM: x86/mmu: remove unnecessary "bool shared" argument from iterators
  KVM: x86/mmu: always take tdp_mmu_pages_lock
  KVM: x86/mmu: fix comment about mmu_unsync_pages_lock

 Documentation/virt/kvm/locking.rst |  7 +--
 arch/x86/include/asm/kvm_host.h    | 11 ++--
 arch/x86/kvm/mmu/mmu.c             |  6 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 90 ++++++++++++++----------------
 arch/x86/kvm/mmu/tdp_mmu.h         |  3 +-
 5 files changed, 54 insertions(+), 63 deletions(-)

-- 
2.39.1


