Return-Path: <kvm+bounces-22259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F6BA93C7D5
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 19:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 607151C21ABD
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 17:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D176719E7E9;
	Thu, 25 Jul 2024 17:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+/HRP/I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C78219DF88
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 17:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929963; cv=none; b=QOkroywNjg5yrVdq+AndE2XfnzFQdkc0uK7Fig7e80PcvRFuu1a7eszcULDpvdyccZ5GG/eJeu5c90+16hdP/hGmUAcVz9LTYxePlgvT6EU6P/1Grwnutjuipp77uDydCUFJJqJzyCu2zKOg6r7pmh5L74yk8uxGWjs7/1dIAFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929963; c=relaxed/simple;
	bh=Mrq3pVcI6peUqPoMSdpibg7CDGmyuyeGF+0cPsFEeKw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=tg7jiXA7zJL1uGypwEYDkl/9VyoSnOuuTAZCkF+eZsSerwj/FPXBOgdda6lb7HNX1FqgpdzJQ4ojL/4ZjK17+YTRYWNbuqMB7rFNH53+UNAGNOaqWxenklM1HijR/ifn85DbrCOQO5rGlvUv+2cY7voEw452Rd6nz7oY725ucuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L+/HRP/I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721929960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HhAbBAJ6gL1oMeI4keNegD7Rzp4r1zzadgT6Nf42wKk=;
	b=L+/HRP/IjuPXW5G1SeQPVUvIi4N9djYVYYdvjlMk1hWWe1FdppzIFpQDY8DwO0TdciFXik
	JYGRk+BrvizNPldxUewtT1guYDw2+SnnD+Iynnvxrph7SKBKuHVY8SC39T9vsEdU+v1W5V
	dJ0ptNA0b9MLSYOasK0GeI6L5qt2FVc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-A_5hwBBROOCeTCw7g6ibrA-1; Thu,
 25 Jul 2024 13:52:37 -0400
X-MC-Unique: A_5hwBBROOCeTCw7g6ibrA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A48519560AD;
	Thu, 25 Jul 2024 17:52:35 +0000 (UTC)
Received: from starship.lan (unknown [10.22.8.132])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F999300019B;
	Thu, 25 Jul 2024 17:52:32 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 0/2] Fix for a very old KVM bug in the segment cache
Date: Thu, 25 Jul 2024 13:52:30 -0400
Message-Id: <20240725175232.337266-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi,=0D
=0D
Recently, while trying to understand why the pmu_counters_test=0D
selftest sometimes fails when run nested I stumbled=0D
upon a very interesting and old bug:=0D
=0D
It turns out that KVM caches guest segment state,=0D
but this cache doesn't have any protection against concurrent use.=0D
=0D
This usually works because the cache is per vcpu, and should=0D
only be accessed by vCPU thread, however there is an exception:=0D
=0D
If the full preemption is enabled in the host kernel,=0D
it is possible that vCPU thread will be preempted, for=0D
example during the vmx_vcpu_reset.=0D
=0D
vmx_vcpu_reset resets the segment cache bitmask and then initializes=0D
the segments in the vmcs, however if the vcpus is preempted in the=0D
middle of this code, the kvm_arch_vcpu_put is called which=0D
reads SS's AR bytes to determine if the vCPU is in the kernel mode,=0D
which caches the old value.=0D
=0D
Later vmx_vcpu_reset will set the SS's AR field to the correct value=0D
in vmcs but the cache still contains an invalid value which=0D
can later for example leak via KVM_GET_SREGS and such.=0D
=0D
In particular, kvm selftests will do KVM_GET_SREGS,=0D
and then KVM_SET_SREGS, with a broken SS's AR field passed as is,=0D
which will lead to vm entry failure.=0D
=0D
This issue is not a nested issue, and actually I was able=0D
to reproduce it on bare metal, but due to timing it happens=0D
much more often nested. The only requirement for this to happen=0D
is to have full preemption enabled in the kernel which runs the selftest.=0D
=0D
pmu_counters_test reproduces this issue well, because it creates=0D
lots of short lived VMs, but the issue as was noted=0D
about is not related to pmu.=0D
=0D
To paritally fix this issue, call vmx_segment_cache_clear=0D
after we done with segment register setup in vmx_vcpu_reset.=0D
=0D
V2: incorporated Paolo's suggestion of having=0D
    vmx_write_segment_cache_start/end functions  (thanks!)=0D
=0D
V3: reverted to a partial fix.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: nVMX: use vmx_segment_cache_clear=0D
  VMX: reset the segment cache after segment initialization in=0D
    vmx_vcpu_reset=0D
=0D
 arch/x86/kvm/vmx/nested.c |  3 ++-=0D
 arch/x86/kvm/vmx/vmx.c    | 10 +++-------=0D
 arch/x86/kvm/vmx/vmx.h    |  5 +++++=0D
 3 files changed, 10 insertions(+), 8 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


