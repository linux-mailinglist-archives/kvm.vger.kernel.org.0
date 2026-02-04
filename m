Return-Path: <kvm+bounces-70256-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GENJQiJg2niowMAu9opvQ
	(envelope-from <kvm+bounces-70256-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:59:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC33AEB4A1
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CBAB83039CBC
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 17:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0048E33B97B;
	Wed,  4 Feb 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aaQiI3E4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="i37uSa9s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F399D3D348B
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770227715; cv=none; b=mbTaWaXq9wD6S+CP2FTelW8ltnRwwB9c/H8Qi8H8DoN0gLy53Hhk/yV6eWcpwTGPASGfohYDKgNMl0P3Zjo0NW3LVOC88qXklMdJk2JeGEGlBhJATEheshztW0UJEP/gQkqxgBAIAJlW6lcZMOx1V9WV1E70XTpj5NUGKqBAQEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770227715; c=relaxed/simple;
	bh=TLBCUTvP15RruxQjOOFWeQkrr5l0mypZhABnKB8F1QI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K/P8vr5MAkpHC2eRT/+xOEE537Hwq+R/i8xKM4YI6e6lXBl1Ij62CwWwK79vVnSHJavksBo/6G+JQASYLvRJhZY8dblg/Q0s/hg2z0Rydpl0gknIBSWk8A/beV4IdoDer3YX66pcHpWvraNGPqXt1SDXXFDVLfoVoLIRDcZQBJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aaQiI3E4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=i37uSa9s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770227713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Bu84bBv18VElvpl4fBxGEtl/ANlOXU8e1YPfRaTP8Dc=;
	b=aaQiI3E42RS0I1YDuYEbvbFnUzp+z014b5k0bPSRRWFjh77FP/y4uqvQZVD4sNAa3XXQoI
	+YtR63nNyMpIVpfxt82auJJlPXyheTcqvKIn8rdcJOYxAUdD7G22dhoHJQn3CyZnHIEdat
	wFbp1pTHwuaanHGW34jFf53yVmjaSSo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-wSIjarUGOZm-lHgDD4lOHA-1; Wed, 04 Feb 2026 12:55:12 -0500
X-MC-Unique: wSIjarUGOZm-lHgDD4lOHA-1
X-Mimecast-MFC-AGG-ID: wSIjarUGOZm-lHgDD4lOHA_1770227711
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-431054c09e3so98589f8f.0
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 09:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770227711; x=1770832511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bu84bBv18VElvpl4fBxGEtl/ANlOXU8e1YPfRaTP8Dc=;
        b=i37uSa9sYNb4VC/32JwHjzAgQM92Bzi+5VYNPrK7ipj9MlmY20A80tCNqp9WhzvgfD
         tCPrIBGH3pGD9MwVYteVai4gaJxsyqD8a+DM7NTmXsiJozsLBDiDSxC3RssWzcdwXioQ
         qYXwDvTrgdvZ3G+4VzmSG400hXylqL8Zkbg4dEr2M80DJftV4vF+UBzN5hOdqxjpvFQ3
         g675j06iuq9SZd8F7x6MWDisd5vkQDX/ppxPfP5fAOCP1QAkn/2GcXgPpXqYpgvlnXLM
         X9TuHvhMsgPFRpgn60RECg5cfXK6EghKjyAsYfI2iXQCXmfjE2c7KI+XCgmfCYbRkpjd
         AD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770227711; x=1770832511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bu84bBv18VElvpl4fBxGEtl/ANlOXU8e1YPfRaTP8Dc=;
        b=RdYy+cIdCYd+fF8ZiLoOIFdodYxWpIzF2wQLnwE4pezaWrfQiJF1edm/yjIRDoYrKw
         TUFvFowfIYZoUrHb22cLI39+0r8fF618+2FnJeasBg0vQwCJCow5A3Q3IHHa+eKlbwO4
         uaLn3843UEWG1UHkBGv69s6/0Y1jsrByoiPq2c3IilJLPbvC7/4y7A15O2TIFtteemkD
         hH3Ie9Y14rAxYDzMZL4v1KP5U63YG8VloCtrocmYJuKxT1utZfdL952odbCzF+gG0dmA
         e3iD5Ww9nj6TBmsw+J0hCU7qHe866CGF//mAAMAJGiB2SnBFWcoPYNGQwJlFn66QhuUo
         MJfA==
X-Forwarded-Encrypted: i=1; AJvYcCXslJ5hsjOhe/uAwUhs2KGkfYHGb5XeZ1HT7SPPIfDGdmLTma0hpZ1tyeJAKZQUaCsEQng=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw8r9zlKLM/mqS7dd96eWFB7uvLvErSLSnWFkEX1yYi5o8yOzD
	3tGRE7YggyDSXi2S6Xwm8JtGcxIae2TQoe4hBFMTDQd/mPIieL/4FMASdaI0PVk8VThJG17BfWY
	94iapi1cvtj9WcoYpXsIwSiNfbI5m13UJmdVmhg+IRTMhG2lNYb0uwtNeDoEeKg==
X-Gm-Gg: AZuq6aKWXID5gObpKhE8F40HBLYd+RLJQQlpKmJOXcvzqlRznLG1qfubLdPvDQuYvR+
	aCKokGKi81zjV8RkdKOWjj3kcngdiQI9slpSxKrcxFFHT+vH8jsTeJZrxZF6PxIOmVbtBnOs0Nd
	fBc1LLy4UP2Ccpe5xRlv2bQmY9VRgJOd9jLjqN2L86exuYJPMckaVIMc6xwpR0oh6Nn4UysT27a
	3Gm8aDBTMpjvUeI1uqRzL8HDoOrBzzZ+DDqnFQ9cIvX9cPG5eEeCIL8OS7lzvB+1Z7dM06PnQ+l
	I81kbgy34xX5MQvg6Xmi5mtFkfd6LuYePx2mR981Mvua996fRyYGZ/3jTqiCo9TsI+wkjo1z+Wf
	fYyWbm5HrpRjiGnIt5trQGbMH5Ipny874InxQHSQR9hGQjji3djcBqgGG36Je0Rio0/ydIyYUc8
	AXWDpBgSp19097RA==
X-Received: by 2002:a05:6000:2384:b0:435:e3e7:1da7 with SMTP id ffacd0b85a97d-436180596d3mr5531897f8f.48.1770227710903;
        Wed, 04 Feb 2026 09:55:10 -0800 (PST)
X-Received: by 2002:a05:6000:2384:b0:435:e3e7:1da7 with SMTP id ffacd0b85a97d-436180596d3mr5531871f8f.48.1770227710460;
        Wed, 04 Feb 2026 09:55:10 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43617e3a486sm8313201f8f.16.2026.02.04.09.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 09:55:09 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] Final KVM changes for Linux 6.19
Date: Wed,  4 Feb 2026 18:55:09 +0100
Message-ID: <20260204175509.163280-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70256-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,plt:email]
X-Rspamd-Queue-Id: EC33AEB4A1
X-Rspamd-Action: no action

Linus,

The following changes since commit e89f0e9a0a007e8c3afb8ecd739c0b3255422b00:

  Merge tag 'kvmarm-fixes-6.19-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2026-01-24 08:42:14 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 0de4a0eec25b9171f2a2abb1a820e125e6797770:

  Merge tag 'kvm-x86-fixes-6.19-rc8' of https://github.com/kvm-x86/linux into HEAD (2026-02-04 18:30:32 +0100)

Sorry for being a bit late, I try to send things over the weekend
if possible but last Saturday/Sunday I was at FOSDEM.

----------------------------------------------------------------
Final KVM fixes for 6.19:

 - Fix a bug where AVIC is incorrectly inhibited when running with x2AVIC
   disabled via module param (or on a system without x2AVIC).

 - Fix a dangling device posted IRQs bug by explicitly checking if the irqfd is
   still active (on the list) when handling an eventfd signal, instead of
   zeroing the irqfd's routing information when the irqfd is deassigned.
   Zeroing the irqfd's routing info causes arm64 and x86's to not disable
   posting for the IRQ (kvm_arch_irq_bypass_del_producer() looks for an MSI),
   incorrectly leaving the IRQ in posted mode (and leading to use-after-free
   and memory leaks on AMD in particular).

   This is both the most pressing and scariest, but it's been in -next for
   a while.

 - Disable FORTIFY_SOURCE for KVM selftests to prevent the compiler from
   generating calls to the checked versions of memset() and friends, which
   leads to unexpected page faults in guest code due e.g. __memset_chk@plt
   not being resolved.

 - Explicitly configure the support XSS from within {svm,vmx}_set_cpu_caps() to
   fix a bug where VMX will compute the reference VMCS configuration with SHSTK
   and IBT enabled, but then compute each CPUs local config with SHSTK and IBT
   disabled if not all CET xfeatures are enabled, e.g. if the kernel is built
   with X86_KERNEL_IBT=n.  The mismatch in features results in differing nVMX
   setting, and ultimately causes kvm-intel.ko to refuse to load with nested=1.

----------------------------------------------------------------
Paolo Bonzini (1):
      Merge tag 'kvm-x86-fixes-6.19-rc8' of https://github.com/kvm-x86/linux into HEAD

Sean Christopherson (4):
      KVM: SVM: Check vCPU ID against max x2AVIC ID if and only if x2AVIC is enabled
      KVM: Don't clobber irqfd routing type when deassigning irqfd
      KVM: x86: Assert that non-MSI doesn't have bypass vCPU when deleting producer
      KVM: x86: Explicitly configure supported XSS from {svm,vmx}_set_cpu_caps()

Zhiquan Li (1):
      KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some unpredictable test failures

 arch/x86/kvm/irq.c                       |  3 ++-
 arch/x86/kvm/svm/avic.c                  |  4 +--
 arch/x86/kvm/svm/svm.c                   |  2 ++
 arch/x86/kvm/vmx/vmx.c                   |  2 ++
 arch/x86/kvm/x86.c                       | 30 ++++++++++++----------
 arch/x86/kvm/x86.h                       |  2 ++
 tools/testing/selftests/kvm/Makefile.kvm |  1 +
 virt/kvm/eventfd.c                       | 44 +++++++++++++++++---------------
 8 files changed, 52 insertions(+), 36 deletions(-)


