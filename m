Return-Path: <kvm+bounces-36576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ED22A1BDA9
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 21:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D036016EE2C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 20:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B5F1DC19E;
	Fri, 24 Jan 2025 20:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iz/+o9NF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB101D63D9;
	Fri, 24 Jan 2025 20:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737752048; cv=none; b=kuHx/nQF3CXfh9TWjAVIW+gKf1BT6qHxqO88jWROoQrVZUSILf5KKNK+8a+ETyIOICb04cm9NewHChtbOD5hY4HUvK91pFxHOIxOO8NqWzeAZd25kJOlPRyxt7RNpbRacpiH0tHxWWfOBQYksFCUtn+poA5QW2s57u7g789wUrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737752048; c=relaxed/simple;
	bh=Wg82B/LkkthZ6NOIJBA1U1Ksgxq8/OpgIRhZH2OM/fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oTIncFjEys1W1Ln8OqrEKDZy0ZRgY1w46uTIAsrUVP7tBtriarDp9ZoxlprufDl5FEA7rpjygjp53VElKAo2OJAUXViz/jbjBL35aMTIxtJYTuFntQAXr2Prl0RyLjSoLeLEAkYmI2jFHc140pTGNQ3j4hQv0JzPWQbYopVWnXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iz/+o9NF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD5FC4CED2;
	Fri, 24 Jan 2025 20:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737752047;
	bh=Wg82B/LkkthZ6NOIJBA1U1Ksgxq8/OpgIRhZH2OM/fs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iz/+o9NFrnRcyj4ZcIamfliPpi5+qysrPFsC3NVNAKijlHAiwezTOcazc01xSb4j8
	 I/ZRYdTGU5KWUpKA3zqyLBjenwRur1t+92UW4AD0nJdlI5KAuokxBGTjneuEvH0FwD
	 7b5xZ0lo/pSlbsuX2wcY3lwHR71Fqfzzwr+uLyS57b7zbeFKXfmXCzzIk9ADr+udQs
	 fgB9CSqMncLeMCMkIhVnuV3bojXL76dRTifpxM8l4KtfKPJN7/iG4P5I4IK0RDXYv6
	 JRSDH6ChFOE61mqKXQ8vnhK9l93FIthVMyMAxUu2Xf8riZHZF2eYnV8KpN6saYt280
	 Fe8JJfH7Avnhg==
Date: Fri, 24 Jan 2025 13:54:04 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Vlad Poenaru <thevlad@meta.com>,
	tj@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Alyssa Ross <hi@alyssa.is>
Subject: Re: [PATCH] kvm: defer huge page recovery vhost task to later
Message-ID: <Z5P97NyK9Rb_cU1z@kbusch-mbp>
References: <20250123153543.2769928-1-kbusch@meta.com>
 <Z5Py_JYc8nYHNgZS@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5Py_JYc8nYHNgZS@google.com>

On Fri, Jan 24, 2025 at 12:07:24PM -0800, Sean Christopherson wrote:
> This is broken.  If the module param is toggled before the first KVM_RUN, KVM
> will hit a NULL pointer deref due to trying to start a non-existent vhost task:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000040
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0 
>   Oops: Oops: 0000 [#1] SMP
>   CPU: 16 UID: 0 PID: 1190 Comm: bash Not tainted 6.13.0-rc3-9bb02e874121-x86/xen_msr_fixes-vm #2382
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:vhost_task_wake+0x5/0x10
>   Call Trace:
>    <TASK>
>    set_nx_huge_pages+0xcc/0x1e0 [kvm]

Thanks for pointing out this gap. It looks like we'd have to hold the
kvm_lock in kvm_mmu_post_init_vm(), and add NULL checks in
set_nx_huge_pages() and set_nx_huge_pages_recovery_param() to prevent
the NULL deref. Is that okay?

