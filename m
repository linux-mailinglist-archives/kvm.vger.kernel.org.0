Return-Path: <kvm+bounces-62951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C3CC549D2
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 22:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6759D3A8B1F
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 21:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735422DC76F;
	Wed, 12 Nov 2025 21:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="am92Mmc6"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDC727D782
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 21:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762982531; cv=none; b=upN44ut6y2sm5YMh9iSIf1lhoy6pYU8Cxv499kl2LZq8AqdsLib5LHU5nSMgI/h5UABfneXEsP3jZ41emH/4k+9rD44hrjUXzq+pyFecRPgv3uOB2UPyYQl2i81AAne4US49aQN4osueQQirNTyueeiOjrFyzuaW+5lmFaa6gIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762982531; c=relaxed/simple;
	bh=4SgRlDDvU5istjyUir1XwDs733sVp33z3Rp103M2gAQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=iK2B++o+ODbvBMUTu3WeBVqhumJidwS36hINny4G5LfwOd4pPkfx5uRQeCJsqX1HfYi6/C6oS7/mJ/G44PXrBXsEcbYiHlXTE5J5fFFU52o4kt/AMtVMI/7gn+Cj+kNBBSOHOmwkpLzkXnSFTnqy1VQqXGrFxr29fFcLmiPtUJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=am92Mmc6; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762982526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4SgRlDDvU5istjyUir1XwDs733sVp33z3Rp103M2gAQ=;
	b=am92Mmc6V1CmAgaBbJ+aUSSO3USMV7oCACilqoA2O+FCF6/5JIJlOUvyH8rgcfuNMMZSAu
	7kT2b0mvzdMcQmhqnFG/x6JkWwwuhY2VFfmssN7hit5UIb504pdV/1MkW4rBfLegpt0occ
	/JuhJ/WilLM64y6Y23zmRhI/FjboKak=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH RESEND] KVM: TDX: Use struct_size and simplify
 tdx_get_capabilities
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <4a2a74e01bfd31bc4bd7a672452c2d3d513c33db.camel@intel.com>
Date: Wed, 12 Nov 2025 22:22:02 +0100
Cc: "seanjc@google.com" <seanjc@google.com>,
 "x86@kernel.org" <x86@kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "hpa@zytor.com" <hpa@zytor.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kas@kernel.org" <kas@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <79605B58-CBB6-460D-8B72-F648F962E1BA@linux.dev>
References: <20251112171630.3375-1-thorsten.blum@linux.dev>
 <4a2a74e01bfd31bc4bd7a672452c2d3d513c33db.camel@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
X-Migadu-Flow: FLOW_OUT

On 12. Nov 2025, at 20:59, Edgecombe, Rick P wrote:
> It looks like you are conducting a treewide pattern matching cleanup?

Just a few instances here and there, but not really treewide.

> In the handling of get_user(nr_user_entries, &user_caps->cpuid.nent), =
the old
> code forced -EFAULT, this patch doesn't. But it leaves the =
copy_to_user()'s to
> still force EFAULT. Why?

get_user() already returns -EFAULT and the error can just be forwarded,
whereas copy_to_user() returns the number of bytes that could not be
copied and we must return -EFAULT manually.

> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com> (really the TDX =
CI)

Thanks,
Thorsten


