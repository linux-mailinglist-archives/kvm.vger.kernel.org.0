Return-Path: <kvm+bounces-58437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF19B93D81
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 03:27:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94D7417FD20
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 01:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD45A24635E;
	Tue, 23 Sep 2025 01:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfeNbT1T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ABF2405FD;
	Tue, 23 Sep 2025 01:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758590865; cv=none; b=rIcmmxCE4NI6g9iRcgudUvguTImFJeCtKaHFcQMSfqNzoJLr2nTazEypuzFBu4bYDjFIyDwxVDRvldKMGJLGVYCHqb6+sUPVCoGThPjUtyzD6R3t397PYusZxJTWM32vMhTZznKlxr/uwRGHobCnvDzoiBNBuU2k+5enfLc1DYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758590865; c=relaxed/simple;
	bh=flxBSoftFjiAiP6heMicexlj4mz8YIbgAu/4NHMShZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQIdHD5Hk+NKpCjozVn9mLjG8nBZZk4cwvefB4G3woA2hpmniu1tffpwUxoU2vTBNW7haN5WrpBqdb8RG+8JJ9HFjnKHqyDpoOa5QCJOtL79VWAe3vmt7i2U9KWciwsI2hXb4hypE8RJRcKOE1qWyizcWKDJFgk+GuxBRqy4svA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfeNbT1T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21BDC4CEF0;
	Tue, 23 Sep 2025 01:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758590865;
	bh=flxBSoftFjiAiP6heMicexlj4mz8YIbgAu/4NHMShZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lfeNbT1TuoFCTHW6Jg29BWRSn57TObXGwoSgkxzcGIWOtxUTUYlzJYnAgc4ewEoiQ
	 JjX3AT1iC1k4WJwwi4/xB2zTjdHRxmkccgz3HYxWVxrfhqJJHH2UDjy82MKheoBSYM
	 7N015kyTr6rMUqIarDtTyyLcqvF+O6ifox3lVTLaSMrraNZaunKbBApn/ZqnuQyJV0
	 qv3EpkiJOS1Zfv2YbLX6h2Gz0al4U0q7DhOlnX8llNZBIy+D/MQTS2GTAMHvuilztN
	 KxhHV3Y1rWXBEqhays1O7iQVorgG+VsP8g4UTwTyWIOqeUiy8+6OYqdPtLGapQ0BPZ
	 NHymVK/kL7NaQ==
Date: Mon, 22 Sep 2025 18:27:38 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] KVM: Export KVM-internal symbols for sub-modules
 only
Message-ID: <20250923012738.GA4102030@ax162>
References: <20250919003303.1355064-1-seanjc@google.com>
 <20250919003303.1355064-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919003303.1355064-3-seanjc@google.com>

Hi Sean,

On Thu, Sep 18, 2025 at 05:33:00PM -0700, Sean Christopherson wrote:
> diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..656b498ed3b6
> --- /dev/null
> +++ b/arch/powerpc/include/asm/kvm_types.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_PPC_KVM_TYPES_H
> +#define _ASM_PPC_KVM_TYPES_H
> +
> +#if IS_MODULE(CONFIG_KVM_BOOK3S_64_PR) && IS_MODULE(CONFIG_KVM_BOOK3S_64_HV)
> +#define KVM_SUB_MODULES kvm-pr,kvm-hv
> +#elif IS_MODULE(CONFIG_KVM_BOOK3S_64_PR)
> +#define KVM_SUB_MODULES kvm-pr
> +#elif IS_MODULE(CONFIG_KVM_INTEL)

Typo :) which obviously breaks the ppc64_guest_defconfig build.
Changing that to CONFIG_KVM_BOOK3S_64_HV fixes it.

> +#define KVM_SUB_MODULES kvm-hv
> +#else
> +#undef KVM_SUB_MODULES
> +#endif
> +
> +#endif

Also, you'll want to drop kvm_types.h from generic-y to avoid

  scripts/Makefile.asm-headers:39: redundant generic-y found in arch/powerpc/include/asm/Kbuild: kvm_types.h

diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index e5fdc336c9b2..2e23533b67e3 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -3,7 +3,6 @@ generated-y += syscall_table_32.h
 generated-y += syscall_table_64.h
 generated-y += syscall_table_spu.h
 generic-y += agp.h
-generic-y += kvm_types.h
 generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
 generic-y += early_ioremap.h
--

Cheers,
Nathan

