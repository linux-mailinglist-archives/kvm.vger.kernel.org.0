Return-Path: <kvm+bounces-14116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D1D89F1BF
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23214B21348
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 12:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA1415B126;
	Wed, 10 Apr 2024 12:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UETbghUH"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F87155395;
	Wed, 10 Apr 2024 12:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712751068; cv=none; b=O3bMdiosGDFXmJc+bQI/ajaQWZiOYKnGdnr5a63aj/MllHggM9gtLzFww2ABMViqKNiyQLNjVCxVRJpGtPDcL6IwuK7MXTwkEH2Um/BrYUfUyVffF8QzNLBY6ip3xuTN2BtWd3DTOuhu8KGg4k0AelOAGFvhij1bULyA3XkBeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712751068; c=relaxed/simple;
	bh=fCXmHu/sj1xLLBtmb9MsJcANXl0QSG8UGKO3OOLOI5U=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ZwQWy4IsNZuF6gpYv+Rh5hnVzHIIBQSR6Fp+PdSvcmHit89OJlTj9qg7NXywjzazMtyZ2MNAkIcXIQW3x3SyVou6wKiwJkVM3+VSW4VO5CU9LmOaj9PN7Veyfp+4+8Ecq+n5M2sCGv1bdtySnI0pWl7Mtyulr2XoBDhBIFMKFqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UETbghUH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=T3LuN1qZGAG1mn2CrH18sNzVhvy7sMk/dlTCxB4L9Uo=; b=UETbghUHyLxMARcTyfFfhvaPM2
	/FF5w/vKOvU0qHFs1OGAhixNnPiOLHtJqaho3k4Pn125svSZA81JdZrnQP2IJR+K4qGRcgTj6CWLj
	37Fagij1sLWAuVblPNMlKMc9MmyM5P56iCPsNTWaaJNrbt7qs3YyO9CXd3n4U8iZPwysQqZWsKVrs
	p8fbVIyicXMTL+FWrCbDCW/21eqejyQ5VUfvrmnE9nCQnGOC1kw8aN7ZOKDXyMLOpBR2XwdwSyeXd
	3FXLfFxd6fnTkuVLV7pN0l+DbwMXvfMIuL85owAzkaxs4zGghDeCvcjFkkfC51QULrDv4sK/+jg9P
	DmUAOGeA==;
Received: from [2a00:23ee:1400:1bb8:e7d6:9885:5536:57d8] (helo=[IPv6:::1])
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruWmu-00000004Psm-0dXv;
	Wed, 10 Apr 2024 12:10:50 +0000
Date: Wed, 10 Apr 2024 13:09:45 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: paul@xen.org, Paul Durrant <xadimgnik@gmail.com>,
 Jack Allister <jalliste@amazon.com>
CC: bp@alien8.de, corbet@lwn.net, dave.hansen@linux.intel.com, hpa@zytor.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
 x86@kernel.org, Dongli Zhang <dongli.zhang@oracle.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_1/2=5D_KVM?=
 =?US-ASCII?Q?=3A_x86=3A_Add_KVM=5F=5BGS=5DET=5F?=
 =?US-ASCII?Q?CLOCK=5FGUEST_for_accurate_KVM_clock_migration?=
User-Agent: K-9 Mail for Android
In-Reply-To: <005911c5-7f9d-4397-8145-a1ad4494484d@xen.org>
References: <20240408220705.7637-1-jalliste@amazon.com> <20240410095244.77109-1-jalliste@amazon.com> <20240410095244.77109-2-jalliste@amazon.com> <005911c5-7f9d-4397-8145-a1ad4494484d@xen.org>
Message-ID: <ED45576F-F1F4-452F-80CF-AACC723BFE7E@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

On 10 April 2024 11:29:13 BST, Paul Durrant <xadimgnik@gmail=2Ecom> wrote:
>On 10/04/2024 10:52, Jack Allister wrote:
>> +	 * It's possible that this vCPU doesn't have a HVCLOCK configured
>> +	 * but the other vCPUs may=2E If this is the case calculate based
>> +	 * upon the time gathered in the seqcount but do not update the
>> +	 * vCPU specific PVTI=2E If we have one, then use that=2E
>
>Given this is a per-vCPU ioctl, why not fail in the case the vCPU doesn't=
 have HVCLOCK configured? Or is your intention that a GET/SET should always=
 work if TSC is stable?

It definitely needs to work for SET even when the vCPU hasn't been run yet=
 (and doesn't have a hvclock in vcpu->arch=2Ehv_clock)=2E

I think it should ideally work for GET too=2E I did try arguing that if th=
e vCPU hasn't set up its pvclock then why would it care if it's inaccurate?=
 But there's a pathological case of AMP where one vCPU is dedicated to an R=
TOS or something, and only the *other* vCPUs bring up their pvclock=2E

This of course brings you to the question of why we have it as a per-vCPU =
ioctl at all? It only needs to be done *once* to get/set the KVM-wide clock
 And a function of *this* vCPU's TSC=2E And the point is that if we're in =
use_master_clock mode, that's consistent across *all* vCPUs=2E There would =
be a bunch of additional complexity in making it a VM ioctl though, especia=
lly around the question of what to do if userspace tries to restore it when=
 there *aren't* any vCPUs yet=2E So we didn't do that=2E



