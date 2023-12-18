Return-Path: <kvm+bounces-4686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B262D816761
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:29:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 903281C2231D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A010D8473;
	Mon, 18 Dec 2023 07:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+xiCzQ/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B7079EE;
	Mon, 18 Dec 2023 07:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E5BC433C8;
	Mon, 18 Dec 2023 07:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702884576;
	bh=vYhXAXWM2ISVIu88GyMX7e6SpUme8puSMXqUFyuvgBo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=n+xiCzQ/m+B8O6UEvMX2vXyc/gPwX3CgQitmoSw2xfgwsnepzeq6ktDwZ3D8bk9jP
	 0hYOBZWNfyCovDlAOKM/6T9y/iiZaaDi4he65hJ1I7kVyi+yp04aUzknyj9dRuW/Jp
	 HsNkNqXHkoiNlXBXtvSN85Isn8bOICsfz5kJ+ztJ0FYtWUe59wp3r+K5gJECVHEsX7
	 SvMDsprNEVBveccUIQizYHG2ul4LI6nYzMT5IgOmNbFC3Rc9lh5KY+EerPVrT7GZ2X
	 VC2VXf21R/UIq8OLTQuY/opA5QWOGL+YT4yx7kocR0Vu2Lb9JlZ7otXlMZUDwbP9dj
	 mFTZpalSnvp7A==
X-Mailer: emacs 29.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jordan Niethe <jniethe5@gmail.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	mikey@neuling.org, paulus@ozlabs.org, sbhat@linux.ibm.com,
	gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
	amachhiw@linux.vnet.ibm.com, David.Laight@ACULAB.COM
Subject: Re: [PATCH 09/12] KVM: PPC: Book3S HV nestedv2: Do not call
 H_COPY_TOFROM_GUEST
In-Reply-To: <87zfy89enk.fsf@vajain21.in.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
 <20231201132618.555031-10-vaibhav@linux.ibm.com>
 <87sf4dun37.fsf@kernel.org> <87jzplmlx5.fsf@vajain21.in.ibm.com>
 <086fb48f-ea7c-4b4e-b3b5-c930aa74bbb2@kernel.org>
 <87zfy89enk.fsf@vajain21.in.ibm.com>
Date: Mon, 18 Dec 2023 12:59:27 +0530
Message-ID: <875y0wrmso.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> Hi Aneesh,
>
> "Aneesh Kumar K.V" <aneesh.kumar@kernel.org> writes:
>
> <snip>
>>> Yes, Agreed and thats a nice suggestion. However ATM the hypervisor 
>>> supporting Nestedv2 doesnt have support for this hcall. In future
>>> once we have support for this hcall for nestedv2 from the hypervisor
>>> we can replace this branch with a firmware_has_feature() test.
>>> 
>>
>> What I am suggesting is we convert that conditional to firmware_has_feature so that
>> later when hypervisor supports this hcall all older kernel can make
>> use of the copy_tofrom_guest without any code change.
>
> AFAIK for firmware_has_feature to work we either need:
> - A way to call this hcall with some invalid args. However lpid/pid for
> guest arent allocated during boot.
>
> - A way for hypervisor to advertise support for this hcall before the L1
> kernel boots.
>
> ATM L0 dosent support for any of these two ways. I can do a follow up
> patch later when we have a clarity on how we want to advertise support
> for this hcall. For now current kernel supporting nestedv2 wont be
> using this hcall assuming its not supported. Future kernels can use one
> of the two ways above to set the firmware_has_feature flag to take
> advantage of this hcall.
>

We can use the second option and have L0 publish the firmware feature
when it adds the new hcall. The good part about this is that all
existing L1 kernels will automatically use the new hcall. Something
like.

diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index 69ae9cf57d50..0ef97b56f999 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -57,6 +57,7 @@
 #define FW_FEATURE_ENERGY_SCALE_INFO ASM_CONST(0x0000040000000000)
 #define FW_FEATURE_WATCHDOG	ASM_CONST(0x0000080000000000)
 #define FW_FEATURE_PLPKS	ASM_CONST(0x0000100000000000)
+#define FW_FEATURE_H_COPY_TOFROM_GUEST	ASM_CONST(0x0000200000000000)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 282d1b54b073..8fc598b4767a 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -39,6 +39,9 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 	unsigned long quadrant, ret = n;
 	bool is_load = !!to;
 
+	if (!firmware_has_feature(FW_FEATURE_H_COPY_TOFROM_GUEST))
+		return H_UNSUPPORTED;
+
 	/* Can't access quadrants 1 or 2 in non-HV mode, call the HV to do it */
 	if (kvmhv_on_pseries())
 		return plpar_hcall_norets(H_COPY_TOFROM_GUEST, lpid, pid, eaddr,
diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
index 18447e5fa17d..d49b5c52e7b8 100644
--- a/arch/powerpc/platforms/pseries/firmware.c
+++ b/arch/powerpc/platforms/pseries/firmware.c
@@ -69,6 +69,8 @@ hypertas_fw_features_table[] = {
 	{FW_FEATURE_ENERGY_SCALE_INFO,	"hcall-energy-scale-info"},
 	{FW_FEATURE_WATCHDOG,		"hcall-watchdog"},
 	{FW_FEATURE_PLPKS,		"hcall-pks"},
+	{FW_FEATURE_H_COPY_TOFROM_GUEST,
+					"hcall-h-copy_tofrom-guest"},
 };
 
 /* Build up the firmware features bitmask using the contents of


