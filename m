Return-Path: <kvm+bounces-27872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 579C598FA43
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C43BB227FD
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4141D0B9B;
	Thu,  3 Oct 2024 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F8S9OuLp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B071CF7BD
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727996897; cv=none; b=tUXGI5XnB6Fcsb7CN9MPj4DZ57SdXzbVmbq3bK0WtRe+O4zpITxaXrRB47QNwCYOGBqHxifxXsayfv2IHz2uN6A5ojwkeuOobN2nkU3ra3wSZuGsOYloHk9siAhSj5sEmn9GKuJIddJsL3KEWnurcu7UcdXaElxcVoAO6diuphY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727996897; c=relaxed/simple;
	bh=u8T99IzGWykMNel3U/9wzmTaqZv74nJArrn871UJQgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wz+3vMq6G6FIxkL79l28v++hAxUxcMEnqG4CfqqdADsio9wyDjGP3msE4eQdR78YgVyAkKiYHVgw4ee53F1GWlwmSrbCoy6ovp6+0HDpHUNZwcHR2fFK6H6plUeaC1FJ6AEeDQUZCqxhBS5IBc1jmE2IP5Co9pwMCcgSEMXkO0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F8S9OuLp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727996893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8knLYr09K7Vnktb8HVIIx+q1DRSVC9E3W+BXuiuKNc=;
	b=F8S9OuLpiE13OsRh6VvJZiuHN51EU1xdhRjpxUwIB5+ftfcHgehPZDzDxBmx6yEV4gMxL0
	zaZK+XrqZRJm01NetpYsvG+RppzSRdm2/HN52+GqVCiX8gpypV6yrFYsfbwHufcNp//m73
	HVUI+V+bVGiIOIo2rSKZSMNyBxnoMso=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-BlCEm-jlNSKdwH-kUEbL2A-1; Thu,
 03 Oct 2024 19:08:10 -0400
X-MC-Unique: BlCEm-jlNSKdwH-kUEbL2A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EEFE1955F44;
	Thu,  3 Oct 2024 23:08:09 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4DAC819560A3;
	Thu,  3 Oct 2024 23:08:08 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	torvalds@linux-foundation.org
Subject: [PATCH 1/2] KVM: x86: leave kvm.ko out of the build if no vendor module is requested
Date: Thu,  3 Oct 2024 19:08:05 -0400
Message-ID: <20241003230806.229001-2-pbonzini@redhat.com>
In-Reply-To: <20241003230806.229001-1-pbonzini@redhat.com>
References: <20241003230806.229001-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

kvm.ko is nothing but library code shared by kvm-intel.ko and kvm-amd.ko.
It provides no functionality on its own and it is unnecessary unless one
of the vendor-specific module is compiled.  In particular, /dev/kvm is
not created until one of kvm-intel.ko or kvm-amd.ko is loaded.

Use CONFIG_KVM to decide if it is built-in or a module, but use the
vendor-specific modules for the actual decision on whether to build it.

This also fixes a build failure when CONFIG_KVM_INTEL and CONFIG_KVM_AMD
are both disabled.  The cpu_emergency_register_virt_callback() function
is called from kvm.ko, but it is only defined if at least one of
CONFIG_KVM_INTEL and CONFIG_KVM_AMD is provided.

Fixes: 590b09b1d88e ("KVM: x86: Register "emergency disable" callbacks when virt is enabled")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig  | 7 +++++--
 arch/x86/kvm/Makefile | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 730c2f34d347..81bce9dd9331 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -17,8 +17,8 @@ menuconfig VIRTUALIZATION
 
 if VIRTUALIZATION
 
-config KVM
-	tristate "Kernel-based Virtual Machine (KVM) support"
+config KVM_X86_COMMON
+	def_tristate KVM if KVM_INTEL || KVM_AMD
 	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
@@ -45,6 +45,9 @@ config KVM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_WERROR if WERROR
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 5494669a055a..0d050cfaffb2 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -32,7 +32,7 @@ kvm-intel-y		+= vmx/vmx_onhyperv.o vmx/hyperv_evmcs.o
 kvm-amd-y		+= svm/svm_onhyperv.o
 endif
 
-obj-$(CONFIG_KVM)	+= kvm.o
+obj-$(CONFIG_KVM_X86_COMMON)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
 obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
 
-- 
2.43.5



