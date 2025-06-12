Return-Path: <kvm+bounces-49307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC6AAD7ADB
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D5A23B6F3C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 19:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E370C2D3A89;
	Thu, 12 Jun 2025 19:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVg3k6+1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDE44A1E;
	Thu, 12 Jun 2025 19:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749755056; cv=none; b=eiZHH5u3P/wyVdBM61vJ2QkbvSyBJZYmkHKh/OffIhrV/cb5uMkmQQHoKO6UO9b4U2vDCXW6utzR5WUkQIeB7sEO/4Qyh/A7B19BjqpVNFkWnh8aW9Wg7NU4fp9trnjwbfT1Bj++zb/VRN0YWhhROhaKLwj6lZGKyf3Bw+0o1Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749755056; c=relaxed/simple;
	bh=6D6BxuzqFc6289gWzxr9MD9k6SduwODZ6NYAWgJEVvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FDa0uDsyVShTp5cZFGhjA/TA6k+ZjfBfUywBrVVrlY+s38vKjjT9NlJGn1y9V5/V9ls5gwERkngeSfWRehJhjrhK/BmIRH1BOtn7FJV8GW6/6Z4TDlnJVGvpl8D4y/vO0pk9jF3r7omVpIJu5k4b939kefHFwZu7IBt1nTcm59A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVg3k6+1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDC4C4CEEA;
	Thu, 12 Jun 2025 19:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749755055;
	bh=6D6BxuzqFc6289gWzxr9MD9k6SduwODZ6NYAWgJEVvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TVg3k6+1fIFCDCqzj07OpTxgI7rzCORKFJbnqm8GeR9/Oss7I+h/K8zjYgLY7WVC2
	 w1+q2edN6g8e8Croaj+1DDwH6LAQMtjnSMyvSJZQSZsUuTEvp0KAXFESX8PacCrgJs
	 aM3hbncXgquVHDukx3NmSg6cOb/FLcRQHUlhHwyvNG0pHb532yUDsKwlX0RWY/oQZ3
	 Ov6H5FMMYGTeK/p+HkjAExQ3JC4gemnACMbtpztskO8CiI5c/QKFz9RrAEpIYHWD2y
	 ISKKCAodFRejkVVX257Qga1XEswstCcv2G8CP5fuaoGIjydsqYgaxXwTvC2YTs8QDZ
	 b/EskwBtyvQrA==
Date: Thu, 12 Jun 2025 12:03:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Zhenghan Cheng <chengzhenghan@uniontech.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org,
	mario.limonciello@amd.com, yazen.ghannam@amd.com,
	jpoimboe@kernel.org, tony.luck@intel.com, jarkko@kernel.org,
	bhelgaas@google.com, pbonzini@redhat.com, oleg@redhat.com,
	jbaron@akamai.com, ning.sun@intel.com, seanjc@google.com,
	luto@kernel.org, andy@kernel.org, jim.cromie@gmail.com,
	kirill.shutemov@linux.intel.com, hpa@zytor.com,
	pawan.kumar.gupta@linux.intel.com, vkuznets@redhat.com,
	rostedt@goodmis.org, ardb@kernel.org, thomas.lendacky@amd.com,
	nikunj@amd.com, ashish.kalra@amd.com, kees@kernel.org,
	alexandre.chartre@oracle.com, rppt@kernel.org, steve.wahl@hpe.com,
	jirislaby@kernel.org, apatel@ventanamicro.com, bvanassche@acm.org,
	ptsm@linux.microsoft.com, Jonathan.Cameron@huawei.com,
	beata.michalska@arm.com, xin@zytor.com, davydov-max@yandex-team.ru,
	ravi.bangoria@amd.com, joel.granados@kernel.org,
	ffmancera@riseup.net, kprateek.nayak@amd.com,
	akpm@linux-foundation.org, bhe@redhat.com, brgerst@gmail.com,
	coxu@redhat.com, dmaluka@chromium.org, linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-sgx@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	tboot-devel@lists.sourceforge.net, nouveau@lists.freedesktop.org,
	linux-coco@lists.linux.dev, xen-devel@lists.xenproject.org,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhenghan Cheng <your_email@example.com>
Subject: Re: [PATCH] x86: Fix build warnings about export.h
Message-ID: <20250612190347.GB1283@sol>
References: <20250612093228.7655-1-chengzhenghan@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612093228.7655-1-chengzhenghan@uniontech.com>

On Thu, Jun 12, 2025 at 05:32:28PM +0800, Zhenghan Cheng wrote:
> After commit a934a57a42f64a4 ("scripts/misc-check:
> check missing #include <linux/export.h> when W=1")
> and commit 7d95680d64ac8e836c ("scripts/misc-check:
> check unnecessary #include <linux/export.h> when W=1"),
> we get some build warnings with W=1,such as:
> 
> arch/x86/coco/sev/core.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing
> arch/x86/crypto/aria_aesni_avx2_glue.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing
> arch/x86/kernel/unwind_orc.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing
> arch/x86/kvm/hyperv.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing
> arch/x86/events/intel/core.c: warning: EXPORT_SYMBOL() is not used, but #include <linux/export.h> is present
> arch/x86/events/zhaoxin/core.c: warning: EXPORT_SYMBOL() is not used, but #include <linux/export.h> is present
> arch/x86/kernel/crash.c: warning: EXPORT_SYMBOL() is not used, but #include <linux/export.h> is present
> arch/x86/kernel/devicetree.c: warning: EXPORT_SYMBOL() is not used, but #include <linux/export.h> is present
> 
> so fix these build warnings for x86.
> 
> Signed-off-by: "Zhenghan Cheng" <chengzhenghan@uniontech.com>
> Suggested-by: "Huacai Chen" <chenhuacai@loongson.cn>

FYI, I'm planning to handle arch/x86/lib/crc*.c and arch/x86/lib/crypto/.

(Specifically, I'm migrating them to lib/crc/ and lib/crypto/ respectively, and
one of the effects of that is the EXPORT_SYMBOL in arch-specific crc and crypto
library files go away.  The lib/crc/ change is already in linux-next, and
https://lore.kernel.org/r/20250612183852.114878-1-ebiggers@kernel.org adds
<linux/export.h> to all files with EXPORT_SYMBOL in lib/crc/.)

- Eric

