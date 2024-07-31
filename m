Return-Path: <kvm+bounces-22741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFEF0942A42
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:21:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F91D1C241BA
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627B51AAE34;
	Wed, 31 Jul 2024 09:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="rMxo0eVQ"
X-Original-To: kvm@vger.kernel.org
Received: from relay-us1.mymailcheap.com (relay-us1.mymailcheap.com [51.81.35.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E631A76D1;
	Wed, 31 Jul 2024 09:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.35.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722417667; cv=none; b=FSrEp5R6hm4/pY6CBx/Qy9dN/ilGH7X76cJaAbaoNohN0tiUZD2m/xAKv77FTUmaEb3I0oAUei2Rj7kLgyb2B1AlV01F8/pXcxtOFGHa9YYb0pSAKImBPAf5IvzRZp8pi60RbqjmRHTfmrqmJghznOPzQ0DKzkmJrpYl3bGH/c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722417667; c=relaxed/simple;
	bh=3+vM12SWlc1ny4Y/bpC01kRYAc71CKZmegr4wNVXjg0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=lUYRpqxxnyoy+WMSVzg/q5T8vOofejILeNZFp+NCUCjMYmjuHlJypgx9k5+GuZK1UZl8NSHQoY5tpoiZL+8q31f4q0kLin2QqIBeWmApM9JMC2PrwViggH3vRHp9sVkDbHvDo3rmpEmhMAquBx0QgdiNEjUaehrtVi1zB1gdTak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=rMxo0eVQ; arc=none smtp.client-ip=51.81.35.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	by relay-us1.mymailcheap.com (Postfix) with ESMTPS id A45D520A2F;
	Wed, 31 Jul 2024 09:15:06 +0000 (UTC)
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [149.56.97.132])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id AAEA020C63;
	Wed, 31 Jul 2024 09:14:57 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay1.mymailcheap.com (Postfix) with ESMTPS id A0FBD3E84A;
	Wed, 31 Jul 2024 09:14:50 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 1D980400AD;
	Wed, 31 Jul 2024 09:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1722417288; bh=3+vM12SWlc1ny4Y/bpC01kRYAc71CKZmegr4wNVXjg0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rMxo0eVQJLHcGAh9yqrjtbwHghplROA18UuOhMlkgnTJgNAeHpzt+9Kd948RlOaYY
	 i9J1hLJnibW6x45Q8lwY+WC8id1ryHe5waJbke4FLSkJEXkma/+Si/Vz+YeOzjiH37
	 9+mc+qvw9hWA7dKgthq+AWrTy3vA+61Ec0dfidQ8=
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 4A13840A78;
	Wed, 31 Jul 2024 09:14:48 +0000 (UTC)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 31 Jul 2024 17:14:47 +0800
From: Mingcong Bai <jeffbai@aosc.io>
To: WangYuli <wangyuli@uniontech.com>
Cc: pbonzini@redhat.com, corbet@lwn.net, zhaotianrui@loongson.cn,
 maobibo@loongson.cn, chenhuacai@kernel.org, kernel@xen0n.name,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, guanwentao@uniontech.com, Xianglai Li
 <lixianglai@loongson.cn>
Subject: Re: [PATCH] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
In-Reply-To: <04DAF94279B88A3F+20240731055755.84082-1-wangyuli@uniontech.com>
References: <04DAF94279B88A3F+20240731055755.84082-1-wangyuli@uniontech.com>
Message-ID: <5c338084b1bcccc1d57dce9ddb1e7081@aosc.io>
X-Sender: jeffbai@aosc.io
Organization: Anthon Open Source Community
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: nf2.mymailcheap.com
X-Spamd-Result: default: False [-0.10 / 10.00];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	ARC_NA(0.00)[];
	RCVD_COUNT_ONE(0.00)[1];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MISSING_XM_UA(0.00)[]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1D980400AD

Hi Yuli,

Thanks for submitting this documentation. I have just a couple 
suggestions on prose and grammar. Please see below.

在 2024-07-31 13:57，WangYuli 写道：
> From: Bibo Mao <maobibo@loongson.cn>
> 
> Add documentation topic for using pv_virt when running as a guest
> on KVM hypervisor.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> Signed-off-by: WangYuli <wangyuli@uniontech.com>
> ---
>  Documentation/virt/kvm/index.rst              |  1 +
>  .../virt/kvm/loongarch/hypercalls.rst         | 79 +++++++++++++++++++
>  Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>  MAINTAINERS                                   |  1 +
>  4 files changed, 91 insertions(+)
>  create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>  create mode 100644 Documentation/virt/kvm/loongarch/index.rst
> 
> diff --git a/Documentation/virt/kvm/index.rst 
> b/Documentation/virt/kvm/index.rst
> index ad13ec55ddfe..9ca5a45c2140 100644
> --- a/Documentation/virt/kvm/index.rst
> +++ b/Documentation/virt/kvm/index.rst
> @@ -14,6 +14,7 @@ KVM
>     s390/index
>     ppc-pv
>     x86/index
> +   loongarch/index
> 
>     locking
>     vcpu-requests
> diff --git a/Documentation/virt/kvm/loongarch/hypercalls.rst 
> b/Documentation/virt/kvm/loongarch/hypercalls.rst
> new file mode 100644
> index 000000000000..1679e48d67d2
> --- /dev/null
> +++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
> @@ -0,0 +1,79 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===================================
> +The LoongArch paravirtual interface
> +===================================
> +
> +KVM hypercalls use the HVCL instruction with code 0x100, and the 
> hypercall
> +number is put in a0 and up to five arguments may be placed in a1-a5, 
> the
> +return value is placed in v0 (alias with a0).

The original paragraph can be split into a few sentences for better 
readability:

"KVM hypercalls use the HVCL instruction with code 0x100 and the 
hypercall number is put in a0. Up to five arguments may be placed in 
registers a1 - a5. The return value is placed in v0 (an alias of a0)."

Not sure if "HVCL instruction with code 0x100" is a proper expression, 
so I have left it alone (I'm a little suspicious). Others are welcome to 
comment on this.

> +
> +The code for that interface can be found in arch/loongarch/kvm/*

It would seem that this sentence (or rather the components and 
structures of this whole documentation?) was borrowed from 
Documentation/virt/kvm/ppc-pv.rst. But nevertheless:

"Source code for this interface can be found in arch/loongarch/kvm*."

> +
> +Querying for existence
> +======================
> +
> +To find out if we're running on KVM or not, cpucfg can be used with 
> index
> +CPUCFG_KVM_BASE (0x40000000), cpucfg range between 0x40000000 - 
> 0x400000FF
> +is marked as a specially reserved range. All existing and future 
> processors
> +will not implement any features in this range.

Again, please consider splitting up the sentences:

"We can use cpucfg() at index CPUCFG_KVM_BASE (0x40000000) to query 
whether the host is running on KVM. The CPUCPU_KVM_BASE range between 
0x40000000 - 0x400000FF is marked as reserved - all existing and future 
processors will not implement any features in this range."

> +
> +When Linux is running on KVM, cpucfg with index CPUCFG_KVM_BASE 
> (0x40000000)
> +returns magic string "KVM\0"

When the Linux host is running on KVM, a read on cpucfg() at index 
CPUCFG_KVM_BASE (0x40000000) returns a magic string "KVM\0".

> +
> +Once you determined you're running under a PV capable KVM, you can now 
> use
> +hypercalls as described below.

Once you have determined that your host is running on a 
paravirtualization-capable KVM, you may now use hypercalls as described 
below.

> +
> +KVM hypercall ABI
> +=================
> +
> +Hypercall ABI on KVM is simple, only one scratch register a0 (v0) and 
> at most
> +five generic registers used as input parameter. FP register and vector 
> register
> +is not used for input register and should not be modified during 
> hypercall.
> +Hypercall function can be inlined since there is only one scratch 
> register.

"The KVM hypercall ABI is simple, with one scratch register a0 (v0) and 
at most five generic registers (a1 - a5) used as input parameters. The 
FP and vector registers are not used as input registers and should not 
be modified in a hypercall. Hypercall functions can be inlined, as there 
is only one scratch register."

It is recommended to define what the "The FP and vector registers" are 
with parentheses.

> +
> +The parameters are as follows:
> +
> +        ========	================	================
> +	Register	IN			OUT
> +        ========	================	================
> +	a0		function number		Return code

Function index?

> +	a1		1st parameter		-
> +	a2		2nd parameter		-
> +	a3		3rd parameter		-
> +	a4		4th parameter		-
> +	a5		5th parameter		-
> +        ========	================	================
> +
> +Return codes can be as follows:

The return codes may be one of the following:

> +
> +	====		=========================
> +	Code		Meaning
> +	====		=========================
> +	0		Success
> +	-1		Hypercall not implemented
> +	-2		Hypercall parameter error

Bad hypercall parameter

> +	====		=========================
> +
> +KVM Hypercalls Documentation
> +============================
> +
> +The template for each hypercall is:

"The template for each hypercall is as follows:"

Also, please consider adding a blank line here (though it probably 
doesn't matter once rendered, but it would make the plain text more 
readable).

> +1. Hypercall name
> +2. Purpose
> +
> +1. KVM_HCALL_FUNC_PV_IPI
> +------------------------
> +
> +:Purpose: Send IPIs to multiple vCPUs.
> +
> +- a0: KVM_HCALL_FUNC_PV_IPI
> +- a1: lower part of the bitmap of destination physical CPUIDs

Lower part of the bitmap for destination physical CPUIDs.

> +- a2: higher part of the bitmap of destination physical CPUIDs

Ditto, please capitalize the first letter after ":" and use "for" before 
"destination physical CPUIDs".

> +- a3: the lowest physical CPUID in bitmap

The lowest physical CPUID in the bitmap.

> +
> +The hypercall lets a guest send multicast IPIs, with at most 128
> +destinations per hypercall.  The destinations are represented by a 
> bitmap
> +contained in the first two arguments (a1 and a2). Bit 0 of a1 
> corresponds
> +to the physical CPUID in the third argument (a3), bit 1 corresponds to 
> the
> +physical ID a3+1, and so on.

Cleaning up sentences and dropping inconsistent expressions (such as 
"argument registers", which was never brought up before). I would 
recommend making them all consistent throughout by classifying a0 and a1 
- a5.

The hypercall lets a guest send multiple IPIs (Inter-Process Interrupts) 
with at most 128 destinations per hypercall. The destinations are 
represented in a bitmap contained in the first two input registers (a1 
and a2). Bit 0 of a1 corresponds to the physical CPUID in the third 
input register (a3) and bit 1 corresponds to the physical CPUID in a3+1 
(a4), and so on.

> diff --git a/Documentation/virt/kvm/loongarch/index.rst 
> b/Documentation/virt/kvm/loongarch/index.rst
> new file mode 100644
> index 000000000000..83387b4c5345
> --- /dev/null
> +++ b/Documentation/virt/kvm/loongarch/index.rst
> @@ -0,0 +1,10 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +KVM for LoongArch systems
> +=========================
> +
> +.. toctree::
> +   :maxdepth: 2
> +
> +   hypercalls.rst
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 958e935449e5..8aa5d92b12ee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12073,6 +12073,7 @@ L:	kvm@vger.kernel.org
>  L:	loongarch@lists.linux.dev
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> +F:	Documentation/virt/kvm/loongarch/
>  F:	arch/loongarch/include/asm/kvm*
>  F:	arch/loongarch/include/uapi/asm/kvm*
>  F:	arch/loongarch/kvm/

Best Regards,
Mingcong Bai

