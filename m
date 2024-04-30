Return-Path: <kvm+bounces-16247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA308B7F7B
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F1B51F232B2
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D51318412E;
	Tue, 30 Apr 2024 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H0q4gROC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABF2181B89
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714500437; cv=none; b=eixaJyNsS6tYCoMlOhgtp33C7tnu1+EL9DfbqO3xWXre3Y3BGchDCUaFCYPHnbjBDD1fFqP2zjPtyqnU0NODK5RAq7b5Yiq9uslnCwRoANMsIqMAu1rK1cx8U8H5Mj5k6Y4gyCP8fcvcYjto6Swgm3pzUnUZvkpWR4zllxpoddE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714500437; c=relaxed/simple;
	bh=L47q4mt9kBy0wy8Q0nzUA+7b4LoDWbP6TNlD++4HcME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CWSCBu5WCKvbAY1BeNWvGUqFmN/qH/nl3nnMoawpqrd2cv6FekuQ2PkzrEGomhDQsiyuslmUNdU+2/DXTHHVgpDAr5/1vaoIEsJrooHswYIagpXEIvifsDrx5s+k7XzXVHS7aZiD223iCfwVqZyZ5LTQvNvgzTNUXBOOqkKBwvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H0q4gROC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714500434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KZBVbO66XJQeYd/bCDE0p7KhNBBtdq70G4UqPY9LxKI=;
	b=H0q4gROCDUgFhVN1XVxWy3nvhwgV2Xcc6iz4gf3OXBbQ+0cAOpzqIaaia9RplfKDNoZwJG
	77VUqE0wLXjSCZOapbWDCmTlybZuhxZR1sYnUz8ocZypzcXILN/it5EzRvopdN/oWuTAH9
	FWUPgpRPROKyDuxmUOAA4MMRY4AJ+8Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-ZmrGJoxSOmeBgbOag4bPJQ-1; Tue, 30 Apr 2024 14:07:10 -0400
X-MC-Unique: ZmrGJoxSOmeBgbOag4bPJQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66275830F7E;
	Tue, 30 Apr 2024 18:07:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49BD2492BC7;
	Tue, 30 Apr 2024 18:07:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fix for Linux 6.9-rc7
Date: Tue, 30 Apr 2024 14:07:09 -0400
Message-ID: <20240430180709.3897108-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Linus,

The following changes since commit e67572cd2204894179d89bd7b984072f19313b03:

  Linux 6.9-rc6 (2024-04-28 13:47:24 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 16c20208b9c2fff73015ad4e609072feafbf81ad:

  Merge tag 'kvmarm-fixes-6.9-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-04-30 13:50:55 -0400)

----------------------------------------------------------------
A pretty straightforward fix for a NULL pointer dereference,
plus the accompanying reproducer.

----------------------------------------------------------------
Oliver Upton (2):
      KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
      KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-6.9-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

 arch/arm64/kvm/vgic/vgic-kvm-device.c           |  8 ++--
 tools/testing/selftests/kvm/aarch64/vgic_init.c | 49 +++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 4 deletions(-)


