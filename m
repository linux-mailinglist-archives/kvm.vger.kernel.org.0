Return-Path: <kvm+bounces-36571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8986EA1BC9F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 20:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 132353A1C12
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8C22248B0;
	Fri, 24 Jan 2025 19:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLqO8o+J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B535A1CEADF
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 19:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737745877; cv=none; b=AFRGZDtJAEg2F6dV8yRU+04LtY8qTc4wX4lyRGpkZeQSjcmGmJKf4UIWhqFLTAc2SIqmLtcsQex+eX0iMrImN33wNWVnB7aHo0c+n/tbQ1lmUh+Jjl/V3CDsMA0jEDi+Cx+70r7FFvb3f/5sk4g0YehQKQizS9hZVhpjzJcX/rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737745877; c=relaxed/simple;
	bh=rZt6d5AHrRj1rI+MxwnT+FRdc7q74iew8hOw+0xw7h0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z4yCb27F+KoxNgWzyUPN7XzXnM60kpEnHvlozHAIFAKlUjU3qxM6E6lS/UPmGP5Xgazth0T+rzviyIdxYz7EWTa+3UXlT5WQUlvM8k+JfdRwdANnE5bInPkoWI2p+bErgWN0JjgTR6Fapz27RASufriYCkb2LEu13fZFJBrqM8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PLqO8o+J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737745874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EzFHJh3igAM5ZxhQNkOPDaAZjKpLpjifpqMoO7E9EGo=;
	b=PLqO8o+JkrQP66xrmT64sjfeGayWSOiMLBEhcnRBtRrBZAjEPkMRkfE0HHZXcNK0ebhdsA
	WrY3O+PED9wPu+udQU/gh5oVT6ZaPJfajkWUDp/iXpvx2PA+x00AlXMha+1fkSTHee+tRN
	S8UBG6j6culgNM/Wi5VxLKqS9Wl409E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-Fb9dh8MPPCysVCTbyhtBQw-1; Fri,
 24 Jan 2025 14:11:12 -0500
X-MC-Unique: Fb9dh8MPPCysVCTbyhtBQw-1
X-Mimecast-MFC-AGG-ID: Fb9dh8MPPCysVCTbyhtBQw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4DE119560B7;
	Fri, 24 Jan 2025 19:11:10 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3FFC119560A7;
	Fri, 24 Jan 2025 19:11:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [RFC PATCH 0/2] KVM: x86: Strengthen locking rules for kvm_lock
Date: Fri, 24 Jan 2025 14:11:07 -0500
Message-ID: <20250124191109.205955-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Last June, Sean reported a possible deadlock scenario due to
cpu_hotplug_lock() being taken unknowingly with other KVM locks
taken.

While he solved his immediate needs by inroducing kvm_usage_lock,
the same possibility could exist elsewhere.  The simplest sequence that
I could concoct requires four CPUs and no constant TSC, so this is really
theoretical, but since the fix is easy and can be documented, let's do it.

At the time the suggested solution was to use RCU for vm_list, but that's
not even necessary; it's enough to just keep the critical sections small,
avoiding _any_ mutex_lock while holding kvm_lock.  This is not hard to do
because you can always drop kvm_lock in the middle of the vm_list walk if
you first take a reference to the current struct kvm with kvm_get_kvm();
and anyway most walks of vm_list are already relatively small and only
take spinlocks.

The only case in which concurrent readers could be useful is really
accessing statistics *from debugfs*, but then even an rwsem would do.

RFC because it's compile-tested only.

Paolo

Paolo Bonzini (2):
  KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
  Documentation: explain issues with taking locks inside kvm_lock

 Documentation/virt/kvm/locking.rst | 27 ++++++++++++++++++++-------
 arch/x86/kvm/mmu/mmu.c             | 13 +++++++------
 2 files changed, 27 insertions(+), 13 deletions(-)

-- 
2.43.5


