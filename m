Return-Path: <kvm+bounces-22252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC2793C5F2
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 17:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 345D2282152
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 15:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CD019D881;
	Thu, 25 Jul 2024 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fdYJAFop"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5BA19AD8C
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 15:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919682; cv=none; b=MKEv5/9ZepQem7dUnjUUCROwO5TJcQfK4z2s+eTVEd+HI0ev6memoWMYc3+hOsr1QvBYNrIRsnnzpNs9Ye/InfiBHk9++RXupUU8wnz4c2pOkBL5OZQZ7C/Focu513iQm6X78sM5wB+rpKg6US+ZzYSc76oGHqKSI564uq9CFac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919682; c=relaxed/simple;
	bh=7+X1J3vQqd5avlgzFBJ8tkKRivOM0F+9Jkhc/kwhmP4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=FlCOhh2tKvEsDolNQZnF9PgjNnAhLIMESgYv3QfPR09V1JWIG7qUez/bcIsgml2qITTp1gs2h/rw61yez6Ggw7fsuYfoL0BcvHRmu5pD+IaHAFQnR7LWTxsnb/h235GVn/UThHvOZxMTHQqqd1KuIA903stQwm7M1J+/R14aop8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fdYJAFop; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721919680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JbyFR4Lriebf4UKLcRlttmZkowS2A+OOfQfuAAW2wDo=;
	b=fdYJAFopeCD2SKFUakA/ajybGoH3n0gn17p6Cbiy1pEkm323qJFHnmeIsew9vHZpP/rjgM
	giLTzhfiV+h9Mu02e0YblPJKjJtV9pVdN2GBUXN0XVgjDy8n4v9MJv9Z9sVzzcCalW5oug
	g6a1jrHhSAKdgaMY/B/CTpmL0JZ5bkA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-XkAnUC1uMPCQod-ItxuDOg-1; Thu,
 25 Jul 2024 11:01:16 -0400
X-MC-Unique: XkAnUC1uMPCQod-ItxuDOg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEB0C1944B31;
	Thu, 25 Jul 2024 15:01:13 +0000 (UTC)
Received: from starship.lan (unknown [10.22.8.132])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 311541955F40;
	Thu, 25 Jul 2024 15:01:11 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] Relax canonical checks on some arch msrs
Date: Thu, 25 Jul 2024 11:01:08 -0400
Message-Id: <20240725150110.327601-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Recently we came up upon a failure where likely the guest writes=0D
0xff4547ceb1600000 to MSR_KERNEL_GS_BASE and later on, qemu=0D
sets this value via KVM_PUT_MSRS, and is rejected by the=0D
kernel, likely due to not being canonical in 4 level paging.=0D
=0D
I did some reverse engineering and to my surprise I found out=0D
that both Intel and AMD have very loose checks in regard to=0D
non canonical addresses written to this and several other msrs,=0D
when the CPU supports 5 level paging.=0D
=0D
Patch #1 addresses this, making KVM tolerate this.=0D
=0D
Patch #2 is just a fix for a semi theoretical bug, found=0D
while trying to debug the issue.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: x86: relax canonical checks for some x86 architectural msrs=0D
  KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and=0D
    MSR_GS_BASE=0D
=0D
 arch/x86/kvm/svm/svm.c | 12 ++++++++++++=0D
 arch/x86/kvm/x86.c     | 31 ++++++++++++++++++++++++++++++-=0D
 2 files changed, 42 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


