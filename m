Return-Path: <kvm+bounces-66309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B18CCEDC0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 08:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F96530419AB
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 07:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2002C0F62;
	Fri, 19 Dec 2025 07:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IbLMRfLL"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FF12D6E5C;
	Fri, 19 Dec 2025 07:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766130774; cv=none; b=rP60zL+mxQL0xB+dmsVJERAQf8FJ7eVTe1kpK2axKmZAkArwkPtL8o4TOoOon54RFCBNPFvGnywF46lJjT0lt44bFx79S0rJeE9nMkU2/TyZ1fzzql90iaJAH6QJ86xDIVtnX1X6VqZv97b/QOdtLQQ/moZX1SIODk++kOHdlqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766130774; c=relaxed/simple;
	bh=HEaeeIQnzZQnWQcIIE4Yd/QM16AqjSH39Wr7nOHQ/xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4psMb4cS1ukLcnNHSyhXERtLb8mDf4g+AG18CXtkMVJW6VRdULXIPL0QAVuZDi68/0j+83zdFGw3q4wRMVmLMebuHpgTC6Ug/oFPkNtnYNQP6EHS3Xvs1HsB+Qu1GDqQ24EcAESBHDiY3gmQ1Zw//mYdZZQbhAVN6TJ8uxNlxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IbLMRfLL; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HEaeeIQnzZQnWQcIIE4Yd/QM16AqjSH39Wr7nOHQ/xE=; b=IbLMRfLLvj2PfqQVrwUd26x7Rh
	QCiy/mVp+0HKdiDmfE2TCQInnOl6NzxskL95j4WAz2oPrGA5AJ2raAkK1xhPIUZV2a/SAw+uqjP1y
	pqn3U0hl+J2ValUExcih/C7oOrXtCX/FBrmzLTu75eCOSBe54Nw793aUUOoT5nZtpKmtdiTr4zoIG
	uqm4mjWNz3NExzdSJjwHsTvGJyOr33XgL+UM7qAoqqnrbLfvFd1aIXjDTvmxo+oj24aAZcSunWIuq
	QhwuOs5UH6G80JFEfM7SHWAwslizMJE7ur7btC0LkTlaXIXRibxlzDipINmy0lpzuwxBII+Mmocpg
	X4WTTCWg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWUQU-0000000AM2O-36LO;
	Fri, 19 Dec 2025 06:57:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E4F9830057C; Fri, 19 Dec 2025 08:52:35 +0100 (CET)
Date: Fri, 19 Dec 2025 08:52:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
	linux-tip-commits@vger.kernel.org, x86@kernel.org,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [tip: perf/core] perf: Use EXPORT_SYMBOL_FOR_KVM() for the
 mediated APIs
Message-ID: <20251219075235.GV3911114@noisy.programming.kicks-ass.net>
References: <20251208115156.GE3707891@noisy.programming.kicks-ass.net>
 <176597507731.510.6380001909229389563.tip-bot2@tip-bot2>
 <20251218083109.GH3707891@noisy.programming.kicks-ass.net>
 <20251218083346.GG3708021@noisy.programming.kicks-ass.net>
 <aURKsxhxpJ0oHDok@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aURKsxhxpJ0oHDok@google.com>

On Thu, Dec 18, 2025 at 10:40:51AM -0800, Sean Christopherson wrote:


> Include the arch-defined asm/kvm_types.h if and only if the kernel is
> being compiled for an architecture that supports KVM so that kvm_types.h
> can be included in generic code without having to guard _those_ includes,
> and without having to add "generic-y += kvm_types.h" for all architectures
> that don't support KVM.

Something jogged my brain and the below seems to work for the few
architectures I've tried. Let me update the patch and see if the build
robot still finds fail.

---
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 295c94a3ccc1..9aff61e7b8f2 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -32,6 +32,7 @@ mandatory-y += irq_work.h
 mandatory-y += kdebug.h
 mandatory-y += kmap_size.h
 mandatory-y += kprobes.h
+mandatory-y += kvm_types.h
 mandatory-y += linkage.h
 mandatory-y += local.h
 mandatory-y += local64.h

