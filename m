Return-Path: <kvm+bounces-21591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB7E93030E
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 03:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B9FB2833B2
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC57C17991;
	Sat, 13 Jul 2024 01:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7ELI+V+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EF014012
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 01:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720834747; cv=none; b=RDMFJkQT6u5q0aZKmoSEod7AI0Ke8i1kHLa5wFH9VpmSb8CaMIP7yWThIXKF83UMh5arru5idXJ5a82ZPi/bUGJJBAV/CaoQhrPCD782CjBXzbJWp8oV8c6EBp/ESS7eK3/00DN1Mf/vPgdVCMg2hup/pTj0N2ybm93Bta/qrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720834747; c=relaxed/simple;
	bh=ZLnJzFlCPFz+aFSkdpAsEfC2J8bneJIy6qVFc/o0Kg0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=bCd/Jkro226wyu9IMxw2scqd1QON7L4d9CyuHecN/ecKoDOPiGHmufoGTkzCZWXl9TDBleo/aQT1cYX25T6lIbe96r6gsC4SniWTT2yf/Mn8P92HOKO4GZeBc6YQ7X1akLK7CXbra0Q88O9MAH8Qklou3Kqj/rQBJwe8faCjFBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7ELI+V+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720834744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MUkwksWZM4bpo+VerhOiEyiXHghLuvfzYDHRObdTPyU=;
	b=E7ELI+V+h5wweoxuXuiKVjodC6scmB2u8olN3Kjirmu/EkeftHY0E4ITad9OWc9gQS/1mc
	hdFANP9CzZisxVOt+85xOVQgWvXVursW0YqYWZqGGe2kLEFTCVTsWoji9D67RflT9rHOgL
	haxwi/V+TnlfdpItXogWqXjACdhB5J4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-TjfmI7CGMJqB2UM6TOXzqA-1; Fri,
 12 Jul 2024 21:39:01 -0400
X-MC-Unique: TjfmI7CGMJqB2UM6TOXzqA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 874DD19560AD;
	Sat, 13 Jul 2024 01:38:59 +0000 (UTC)
Received: from starship.lan (unknown [10.22.18.76])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D5DC13000181;
	Sat, 13 Jul 2024 01:38:56 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] Fix for a very old KVM bug in the segment cache
Date: Fri, 12 Jul 2024 21:38:54 -0400
Message-Id: <20240713013856.1568501-1-mlevitsk@redhat.com>
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
To fix this issue, I wrapped the places which write the segment=0D
fields with preempt_disable/enable. It's not an ideal fix, other options ar=
e=0D
possible. Please tell me if you prefer these:=0D
=0D
1. Getting rid of the segment cache. I am not sure how much it helps=0D
these days - this code is very old.=0D
=0D
2. Using a read/write lock - IMHO the cleanest solution but might=0D
also affect performance.=0D
=0D
3. Making the kvm_arch_vcpu_in_kernel not touch the cache=0D
and instead do a vmread directly.=0D
This is a shorter solution but probably less future proof.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: nVMX: use vmx_segment_cache_clear=0D
  KVM: VMX: disable preemption when writing guest segment state=0D
=0D
 arch/x86/kvm/vmx/nested.c |  7 ++++++-=0D
 arch/x86/kvm/vmx/vmx.c    | 22 ++++++++++++++++++----=0D
 arch/x86/kvm/vmx/vmx.h    |  5 +++++=0D
 3 files changed, 29 insertions(+), 5 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


