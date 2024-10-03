Return-Path: <kvm+bounces-27874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4491098FA44
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEC3F1F23FE2
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4CC1CDFD2;
	Thu,  3 Oct 2024 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="inEKXgwk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D95F1D016F
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727996897; cv=none; b=SmUi+TAEjVriaBya8xTY1CmWbl/G1aoW6uc9AtDn++rV35nlJ/4t0qbJVGq5ic+yX3K+qWecYFjz+Sq7Dgh6dF4NeZOTxDEnAt60rWB37jALzMwJ4gMyrPz/YxcrQWlXemLnd08Rh38PKkgMz+4x1RAM6u+q3d6omYR89/AAbQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727996897; c=relaxed/simple;
	bh=i52pljhvZ9r3vktLWwSQMyI3hCYCB2dXO40nZcQpwQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HiRIsfiDDcfSl+pFNofCHqc+0RhpeCsBWEaUnh4tY0BVWDJssnfTYi3B3/e+2zwGJ2FO3RzRTR518QwH1AsVbAeUMxiQd2mOXOETMiVfUdr0d/zfHc5bV1Xwmni9DiwAZNWdp/8eagNXT50Q0AZYaJ29ICgp+y+FmP020w0IH1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=inEKXgwk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727996895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KZz9BEGehiAxiofBDXaPPa2xHap71M8gl8oDOTN9NU8=;
	b=inEKXgwkga2guJ8cwD9k5x+5r5gVCqLC6sojSxzE3vcfIxbPpbmAVPjHQGU1Vu64x1VJId
	hNGMdD4mt6WLwgPTdKLve+uG7JSU1q6f3XfIrt/cYZ7KPXWwCPWjFblJupIoqaTYRpoC/V
	lTS7vNSym8jIEENI/cioh8slth3EI8Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-CmkndQqqMIC8AxxgNMoH_Q-1; Thu,
 03 Oct 2024 19:08:09 -0400
X-MC-Unique: CmkndQqqMIC8AxxgNMoH_Q-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3ADB41955EE7;
	Thu,  3 Oct 2024 23:08:08 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3DC9219560A3;
	Thu,  3 Oct 2024 23:08:07 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	torvalds@linux-foundation.org
Subject: [PATCH 0/2] KVM: x86: only build common code if at least one vendor module was picked
Date: Thu,  3 Oct 2024 19:08:04 -0400
Message-ID: <20241003230806.229001-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Linus reported a build regression when CONFIG_KVM={y,m} but
CONFIG_KVM_INTEL and CONFIG_KVM_AMD are both n.  If that happens, kvm.ko
tries to call cpu_emergency_register_virt_callback() but that function
does not exist due to a mismatch between KVM code and the common x86
files arch/x86/include/asm/reboot.h and arch/x86/kernel/reboot.c.

kvm.ko is nothing but library code shared by kvm-intel.ko and kvm-amd.ko.
It provides no functionality on its own and it is unnecessary unless one
of the vendor-specific module is compiled.  In particular, /dev/kvm is
not created until one of kvm-intel.ko or kvm-amd.ko is loaded.

It is still useful to have CONFIG_KVM, as it lets the user make kvm.ko
built-in; but it is pointless to build it unless the user picked at least
one vendor module.

Skipping the build of kvm.ko is already enough to fix the build regression.
However, the second patch also adjust the reboot.[ch] files to test the
Kconfig symbol that corresponds to arch/x86/kvm/x86.c, which is now
CONFIG_KVM_X86_COMMON.

More cleanups are possible in arch/x86 in the other direction, making code
depend on the specific vendor-specific module that needs it.  For example,
current_save_fsgs only has to be exported if IS_MODULE(CONFIG_KVM_INTEL).
This is left for later.

Paolo

Paolo Bonzini (2):
  KVM: x86: leave kvm.ko out of the build if no vendor module is
    requested
  x86/reboot: emergency callbacks are now registered by common KVM code

 arch/x86/include/asm/reboot.h | 4 ++--
 arch/x86/kernel/reboot.c      | 4 ++--
 arch/x86/kvm/Kconfig          | 7 +++++--
 arch/x86/kvm/Makefile         | 2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

-- 
2.43.5


