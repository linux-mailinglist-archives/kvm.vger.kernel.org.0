Return-Path: <kvm+bounces-23049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D3A946016
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 17:17:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8235A1C221A6
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 15:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03851136346;
	Fri,  2 Aug 2024 15:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jFintkjt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D2515C14B
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722611782; cv=none; b=dIp2IaN9tG5BMBi8zXCzctE3uIoGyq9R4HIak96kCe3jPtuxDKkuGLd4Su3IJCwFJfSRU3sO4koTiO8MW8oVHAsXFLvhiIOjr+OZaoQ0VLbxYJ6vO+GtIka+OPtF8RmrmTLIvjWNf2NUDmoCvmY1W48IZ3KmGVNHRsQ6nwFkHYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722611782; c=relaxed/simple;
	bh=iuimfJknKx17ZsRwE8HxkPVR9wtDKQz5UqYPwUcW5+E=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=L8I8WLtqwxYr7CpIQSd/Dt4DjFUk1aTHW/atFiq8xrJP6VyIzgOf4axurM4n7v0XzzN14Ee2J08Zt9JJJZPzlxOescOR98h8aS6xl2RCgWuuNmrdEoWqUG2sINZj73sJ4UxgCEVoxLsfoyyFFGrFuj6r+mx7iTkfzgzJBMno9iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jFintkjt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722611779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dB8ZjsQi0DqhQ19QW4eHSso4LuqSpVC05OgWx9LUJeU=;
	b=jFintkjth0O+AKuylQy1hOpKfsuzIS8DpPnH1yQtjNPJ7YjhBy3b4xO0gqcOfKF/mVXxIr
	HYOZt+nJQkwYWmZrXhBLyT0OeEMY5oj29lrAhNBR/RS/oR/EuzULUfRxiXCzsq9FMXnDct
	x+R8gIjuUPtQkFwqn13opzei1CXuJ3A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-sELmaxqFNACf-wJmQ0HHjw-1; Fri,
 02 Aug 2024 11:16:16 -0400
X-MC-Unique: sELmaxqFNACf-wJmQ0HHjw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DDED195421F;
	Fri,  2 Aug 2024 15:16:14 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.47.238.37])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE2481955E80;
	Fri,  2 Aug 2024 15:16:09 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/2] Relax canonical checks on some arch msrs
Date: Fri,  2 Aug 2024 18:16:06 +0300
Message-Id: <20240802151608.72896-1-mlevitsk@redhat.com>
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
V2: addressed a very good feedback from Chao Gao. Thanks!=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: x86: relax canonical check for some x86 architectural msrs=0D
  KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and=0D
    MSR_GS_BASE=0D
=0D
 arch/x86/kvm/svm/svm.c | 12 ++++++++++++=0D
 arch/x86/kvm/x86.c     | 11 ++++++++++-=0D
 2 files changed, 22 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.40.1=0D
=0D


