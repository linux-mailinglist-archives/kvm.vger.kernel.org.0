Return-Path: <kvm+bounces-25005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 303FB95E34C
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 14:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7B211F217B6
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 12:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3158143725;
	Sun, 25 Aug 2024 12:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ikcE1jU1";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wR56FUl7"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4731E4A2;
	Sun, 25 Aug 2024 12:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724589359; cv=none; b=iloXNC7JMdGApCQ5m6stJ87TcKrJKC/hXRkbjcDR/xjB1YnereVyRto9TFFFm4DqW7kSMyiOs/QMvlJlALymgCWnrcW+UgC1mp4j+c1uaYLkzV2/INPNOY8lM8LSoVspY3HdWihO4CxbmHpTYofRJai1FN7LRD+YTriiYc9c6jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724589359; c=relaxed/simple;
	bh=XgRl8IZZ8Q/ktf6pFfAjj2i4C46Kar4pf/csOipfuWc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Z8f3C8e5LwExKLKXTvig8+iYfXgetPHL2xwd6HMJGz2c9GlTkON7+2y/o7X97VTF4iI0bkK0SrvcQasXu5fzBXzBSMiTYaq8Te1+bVMIQkRjzp8lozwlnWyU1JrziZHXwfjqhDJCLy/Jbu3HyXLZj4JGR4wTT3lYj9MXq7dZiuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ikcE1jU1; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=wR56FUl7; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1724589356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xi/56QMQfPh2xxpoVj2jNAFcipohi/1raBVMkWkCEHs=;
	b=ikcE1jU13ToH6febtssE78hzY5czE6WPHvmdUZeEh7RxXNsyWtFChfQGKfLklUM2gFz4hy
	kmb0oXTCERgUFAFvKmNVHUzYX4UBoR/WOHrapdZkB2QLL6r2moaWFAnBwIvN3UZ1FMpo4M
	OPH2lB5q6lYk6EDPJzNWs93VtoFuQPZj/H67MVRIm3N3zt43x3BEX5B0V+UXDRNMGje+jv
	OAmKrMUGj6tc5GlEUSM1GjQT7fU8zW3VWUr0ChiY8J6lh3ko1BMLso/el6Qu78elyDH5El
	vykAf4Of154SJe3FazSJlMBHYvXPkbMkxU+iHNTYPoOZgqyPhQIMHPhrlyIZzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1724589356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xi/56QMQfPh2xxpoVj2jNAFcipohi/1raBVMkWkCEHs=;
	b=wR56FUl7sMC+5z0WOH0UQuAAcZ6M/4SQI1PAn2AAD5RONerz7xOpWNv4i2AcmfsdesF64c
	uJbbXXvMYmcgh9AA==
To: Kim Phillips <kim.phillips@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
 <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Kim
 Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v2 1/2] x86/cpufeatures: Add "Allowed SEV Features" Feature
In-Reply-To: <20240822221938.2192109-2-kim.phillips@amd.com>
References: <20240822221938.2192109-1-kim.phillips@amd.com>
 <20240822221938.2192109-2-kim.phillips@amd.com>
Date: Sun, 25 Aug 2024 14:35:55 +0200
Message-ID: <87y14keq50.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Aug 22 2024 at 17:19, Kim Phillips wrote:
> Add CPU feature detection for "Allowed SEV Features" to allow the
> Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
> enable features (via SEV_FEATURES) that the Hypervisor does not
> support or wish to be enabled.
>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

This Signed-off-by chain is wrong. Either the patch is authored by
Kishon, then the changelog needs a From: Kishon... line or you need
Co-developed-by. See Documentation/process ....

Thanks

        tglx

