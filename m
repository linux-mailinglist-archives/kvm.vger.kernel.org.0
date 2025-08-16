Return-Path: <kvm+bounces-54830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C2DB28CB7
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 12:13:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E4727AB7AB
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 10:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E0A28DF07;
	Sat, 16 Aug 2025 10:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gNVUuk8g"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BA21DEFE7;
	Sat, 16 Aug 2025 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755339201; cv=none; b=i2GgfLxm3KS2KlDuovZVxO/f/Fb2dtAOMSUcmSZHB+d0Ne9Ds/jumrmxEN31p6tftj0pswy1cLAJPYGHiiSHk89GXLKVXkTert47WaTvhry6AtUP1TX42zyA56HDu7Hirvx/z5pKPiJixdl5iqz11V+krzyW3rdeL4AGDznt/mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755339201; c=relaxed/simple;
	bh=FwTGNcW1CmXH4bwdcW2Ptfr2ijvfsjMKZcgT7hAf73E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KFNdh8XpbHGYsabWPqGj0mmkmz8eqXphqcxNg86yVW3u649VnDoPIC9znfo1tpc4AkbYIuCiIGqB88XCBDQNoZbuAiu54A3Jk+sl9XwrHocJyoykqmxGX8nFbJ58YwzEXbhI2mPefBSkHY6k8J53gIYvQlmTnHt04uNEjL4Xz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gNVUuk8g; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Cc:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Js09wWwfMna1f0k3MLy5WWIwtabd0tfZJXk+++8TmAc=; b=gNVUuk8gCdJkC354+sE3rXbO83
	+PGB4RcIxwz5cjblusD4A9d5K1a7yWYMEBJs7KQMwn6yVPSGVOZhH/U3ZjJorvDaNIQGYEb0ocZIU
	mik4TYaptr9eC8l1nKvCv5wUNNQ9vgL21BBYhU4KBXeBrT6BDvLjL1TLKy5+NhOhJ2sFqhUBfmRDu
	L5o4gz4rJPuJrkeUCgtR2X4UQ9zkyhQvFfZbIcByFrVD4BIydXsW1gKcun3aeEH70G5F8wet0HdDG
	Vn66QjfQSc7YbB23N9UvuWbY70Eh1PPasXIYHLStlTKBfatjUhpBaold3Nojc2W2xtLWN59CexuHp
	KXS6Lqpw==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unDuR-00000007nqD-1qZX;
	Sat, 16 Aug 2025 10:13:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1unDuQ-0000000Asu6-0nY5;
	Sat, 16 Aug 2025 11:13:10 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	graf@amazon.de,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Colin Percival <cperciva@tarsnap.com>
Subject: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest and host
Date: Sat, 16 Aug 2025 11:09:59 +0100
Message-ID: <20250816101308.2594298-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

In https://lkml.org/lkml/2008/10/1/246 VMware proposed a generic standard
for harmonising CPUID between hypervisors. It was mostly shot down in
flames, but the generic timing leaf at 0x4000_0010 didn't quite die.

Mostly the hypervisor leaves at 0x4000_0xxx are very hypervisor-specific,
but XNU and FreeBSD as guests will look for 0x4000_0010 unconditionally,
under any hypervisor. The EC2 Nitro hypervisor has also exposed TSC
frequency information in this leaf, since 2020.

As things stand, KVM guests have to reverse-calculate the TSC frequency
from the mul/shift information given to them in the KVM clock to convert
ticks into nanoseconds, with a corresponding loss of precision.

There's certainly no way we can sanely use 0x4000_0010 for anything *else*
at this point. Just adopt it, as both guest and host. We already have the
infrastructure for keeping the TSC frequency information up to date for
the Xen CPUID leaf anyway, so do precisely the same for this one.

v2:
  • Fix inadvertent C++ism pointed out by syzbot:
    https://ci.syzbot.org/series/a9510b1a-8024-41ce-9775-675f5c165e20

David Woodhouse (3):
      KVM: x86: Restore caching of KVM CPUID base
      KVM: x86: Provide TSC frequency in "generic" timing infomation CPUID leaf
      x86/kvm: Obtain TSC frequency from CPUID if present

 arch/x86/include/asm/kvm_host.h      |  1 +
 arch/x86/include/asm/kvm_para.h      |  1 +
 arch/x86/include/uapi/asm/kvm_para.h | 11 +++++++++++
 arch/x86/kernel/kvm.c                | 10 ++++++++++
 arch/x86/kernel/kvmclock.c           |  7 ++++++-
 arch/x86/kvm/cpuid.c                 | 23 ++++++++++++++++++-----
 6 files changed, 47 insertions(+), 6 deletions(-)


