Return-Path: <kvm+bounces-21681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F472931EC0
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 04:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF692282966
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E627AD32;
	Tue, 16 Jul 2024 02:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyeQJGDP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72A314277
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 02:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721096428; cv=none; b=KSEkmaFT6ZkAcaUGTe7bbkG9dhHdEDeOlMWzpsqLnsv05sJYGyPnpg+bGlsWm868NTT1WeMdA3tm3Cj453kpq4HAVDymLyXo2x2mdNccKLNIijRa+VH2QKbptZXSj83AzIjg1xyvDkIKEgUlx59Xsl+57j1J2vD2rsQu45dJqaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721096428; c=relaxed/simple;
	bh=HeHFh3uTY2qznZHF8awVukHmACLPPqsJ7jfC+fsUYuM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=TGVcTOxkb1lb9m+8ksqKt6iv256+hi5AL/NdC/Wx/nCAYdLun2d977+kWcicmmQ/CMQRBq5VfZbZn/iJggKY29MzGKG7+NjjAVCWggCjkGJPOE11JDtwK7+XNhAF5DQfuXOeRUR3ocQUWQ3Y0Euj+IWv2zLlU76GApjzsM+jnvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hyeQJGDP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721096425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u7nsomLB5pQK9PslRRQG0TufbWxbkz8lavQHCKnAJDU=;
	b=hyeQJGDPVhs73nVM+nIm0m+yk2xtEkavjLP7EYyfrts/9Ri/IF41eTqi/jzpxeM9BixaYk
	k92ZCOJdBxJraLl6vUjZZ7yxrVemgcN+efeyAdcXtB+JJwslAlTXaB8+ehR+wKCBbi+q1Q
	KfyMdx9rZKrQTCFjycgDItsdqHoTzNw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-dWbkc9PIOkSDFtRW_ItB3A-1; Mon,
 15 Jul 2024 22:20:20 -0400
X-MC-Unique: dWbkc9PIOkSDFtRW_ItB3A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAF9619560A2;
	Tue, 16 Jul 2024 02:20:17 +0000 (UTC)
Received: from starship.lan (unknown [10.22.8.61])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E04E19560B2;
	Tue, 16 Jul 2024 02:20:14 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/2] Fix for a very old KVM bug in the segment cache
Date: Mon, 15 Jul 2024 22:20:12 -0400
Message-Id: <20240716022014.240960-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
To fix this issue, all places in KVM which write to the segment=0D
cache, are now wrapped with vmx_write_segment_cache_start/end=0D
which disables the preemption.=0D
=0D
V2: incorporated Paolo's suggestion of having=0D
    vmx_write_segment_cache_start/end functions  (thanks!)=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: nVMX: use vmx_segment_cache_clear=0D
  KVM: VMX: disable preemption when touching segment fields=0D
=0D
 arch/x86/kvm/vmx/nested.c |  5 ++++-=0D
 arch/x86/kvm/vmx/vmx.c    | 29 +++++++++++++++++++----------=0D
 arch/x86/kvm/vmx/vmx.h    | 17 +++++++++++++++++=0D
 3 files changed, 40 insertions(+), 11 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


