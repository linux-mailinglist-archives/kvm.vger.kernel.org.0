Return-Path: <kvm+bounces-54667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A8EAB264ED
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 14:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B5432A2B34
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 12:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58AAA2FCC16;
	Thu, 14 Aug 2025 12:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oa/gsDXn"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2B7212575;
	Thu, 14 Aug 2025 12:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755172994; cv=none; b=cEHt1xBkJTnI+SSZYelbldEwrCpio1g6j3Pyzpuu17Zh4z53lTGtj3CGnPx7wBYnM1X8Ul8xNe+veFpsFfODjpcNIgZtXPW5UFddtVaaj9PKClX04RanyEJ4Gysmek/tczuSMQQhDPrrLP8iTMXAyYBOpF/ouXKyY71KdQpy7P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755172994; c=relaxed/simple;
	bh=A44Vs9FuO6cjAFMVMyGMWh1udTSAtOBXeRZU70TWpPs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=NE59MJJ1qCSAepOp5EGWQC0qEe4g8aIu8A+Irc18oS9Qx3LWbEfzY+XZh99a6PLu2WFdLorXXyGVl71d7DsB++bV+/uNa9VUVhAJLTDwUfz334QAl9n+LJt8WpdbVvJUB/6BeuBgHOSgcslhTGNrp2qlNCETOORx+Bz9IDh5lOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Oa/gsDXn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Cc:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=b2xpMMk7bEoP8g2l9/S0R3HsbmWy9t5985Mu6HDY55U=; b=Oa/gsDXn8+V6D7AVIlZlchWPVG
	ABsZg/ROm5vnjEmIxDUD9hfRKl0A4id2EaaDcuF9IIZdVywm5QlM96xLgnAl8Ch8FJuo9JBhUgj5q
	zlLorRxB0mkhaoqmg499QcALurJBn3NlDcInS7c602LiHTGQvqBXZfafgw3QxLDGNr/z5n1h2qlSz
	yrkSvfaz6Nq9Mp6ppYfwO+C2Ppf2RcFSEsAQWBw/PQHpS9u4LZwoTfHJxzXKMCWchPU3UiOl2UUM1
	EETCGEJ2dDhQIDuGVdiC/bV3tJKA6i23gZEInnd/2TR2Mv+wuPbqxaxqlnXR9xNzwNvH1rRVuJ3jl
	u5JrfA+A==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umWfd-00000000IZu-2akP;
	Thu, 14 Aug 2025 12:03:02 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1umWfd-0000000AMTg-10H6;
	Thu, 14 Aug 2025 13:03:01 +0100
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
	Alok N Kataria <akataria@vmware.com>
Subject: [PATCH 0/3] Support "generic" CPUID timing leaf as KVM guest and host.
Date: Thu, 14 Aug 2025 12:56:02 +0100
Message-ID: <20250814120237.2469583-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


In https://lkml.org/lkml/2008/10/1/246 VMware proposed a generic standard
for harmonising CPUID between hypervisors. It was mostly shot down in
flames, but the generic timing leaf at 0x40000010 didn't quite die.

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


