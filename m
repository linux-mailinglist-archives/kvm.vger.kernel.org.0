Return-Path: <kvm+bounces-34346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 429909FB2D1
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 17:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BC7718815D8
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 16:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3D11B6D01;
	Mon, 23 Dec 2024 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zf2ztV3L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A28415C14B
	for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734971158; cv=none; b=TewP9uQ1msuICazdLZAhNJe7mRcDi9MeWLfVaEllLxGaptM/23DTfiE1bsi8RBTM9y4KxWFdfsr0AYquUtDqi50/Bqdg1lTwmUM7vRQ45TkYM0t8MKG1/d6rKL8u2l/PqDuPYTfJzdiYVVGrC/ZrhhOY38kL/VUk8GXopMm6vho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734971158; c=relaxed/simple;
	bh=gLNTdqy53kOy7FEe0+XlSXCLL3TbieGqcMeBm4A4YK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WdMPQ0QeaqzuxQO0TEn0wUhJ6MrFDLAHBouUHpbkGSmVWm/CSfrbbWHja0SPinZRMF74nptJzmaITgoGNFqr+GzpGlUNsN4Yqg1Q7BUGu1A+ePDZB2raHLCmDvmvH+hjS7p04vEfzdYUpPDTsUhZtMZraZdiG+flV1db5IilSC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zf2ztV3L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734971156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fjl9eR9cpIlUwJR3bzJjeDpMZWb8GNcfkZ63EEu1UXM=;
	b=Zf2ztV3LLqlqLWm043pJXkHuRLtWL8OmpiacVmBj2Rwkil9KFEPzJITZnmEABSK2xq0erT
	7UtDsbXOSu7gSiu2aO6FAIiss9NRP9wXBA8jwsbx5D5icCSo48gcfKbbbtwfyBCnt6D6Yj
	s7+3vuDnsksKMR6NsTqUae5L5aExdw4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-uunnNdoEP2qfs7pkl5EXGA-1; Mon, 23 Dec 2024 11:25:54 -0500
X-MC-Unique: uunnNdoEP2qfs7pkl5EXGA-1
X-Mimecast-MFC-AGG-ID: uunnNdoEP2qfs7pkl5EXGA
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3862e986d17so1917067f8f.3
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 08:25:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734971153; x=1735575953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fjl9eR9cpIlUwJR3bzJjeDpMZWb8GNcfkZ63EEu1UXM=;
        b=dGUFTqL6oUkkS92ZZ1gKaKxnrUpFc0ZUtgd92rMoQmd3Azo+Th4hQO+i9Uu330W7ZI
         Qs2PS45GAsp51H0GePe8HtlZ+xHNmrun46dCEQrruWWqbqdeqGDO2m9mN0FDKbOdfbOp
         Nj/+YB8ZxqwOU628E64Fd9t9Glc01VmpuFcnnSmO7IcTwdiwP2HETOKPuXJh3DYFi3OX
         DmkjBhqnD+1brfrXiEB2omIsZmsYC8KgrMCSoXRyJt9QN5m5K0ofKzmw7UJpGZHHf/Z6
         lleRZ92npUtPod8+nVJRnQw6fbRfNKN4GZ8blvJ7ZW50sw5WWDHRYktjz3xsdRh7lY6f
         u4RA==
X-Forwarded-Encrypted: i=1; AJvYcCWRUsMCCoK75uSzAx3Q2kgCYLRAGVPvcvA4bCTbXfa7T9N93ljLe0Xxa5ZjQxud/ErskOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyalsYKdK6vGYFLE1dmdqt7nUOUNhKin9/7ACUaX3vw3z6oLmOV
	nqXszTgJ3uY4t+Dl6K4CdJ2LOk9uti/2yVFodBW/U+FW4by+3SRYa9OrzNpJQ+8m5XPt3+SFgwl
	qa0+TMRmziEMvUiIXzOx/fy+z17JCQZtpdYprqPtwQuEGR7Qaij0dfhNU5ypI+ISV3aIGqxrB2o
	i/0D+ArVLuOSM1S9TRNRUufqfh
X-Gm-Gg: ASbGncsoBS/L9QtYKFucHsGNIGN3xAYhumxSbEHyFd40YfFyQSBBKVqIELboyF+wSGW
	97DTLubg1ulCzldCteuie/cZ5/D3o8eQF9JqRgA==
X-Received: by 2002:a5d:6d83:0:b0:385:f249:c336 with SMTP id ffacd0b85a97d-38a223f5d01mr10934432f8f.45.1734971153343;
        Mon, 23 Dec 2024 08:25:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHh+ax0lV6iyT21FHnDCzDOh8g/6t+77n2Z8HiMJ46IbE1My31c4oORTEe5AfDoiotldDZ1DoiP35dRFhB7jKM=
X-Received: by 2002:a5d:6d83:0:b0:385:f249:c336 with SMTP id
 ffacd0b85a97d-38a223f5d01mr10934405f8f.45.1734971152957; Mon, 23 Dec 2024
 08:25:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 23 Dec 2024 17:25:40 +0100
Message-ID: <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com, 
	kai.huang@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com, 
	reinette.chatre@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 8:01=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> Hi,
>
> Here is v2 of TDX VM/vCPU creation series. As discussed earlier, non-nits
> from v1[0] have been applied and it=E2=80=99s ready to hand off to Paolo.=
 A few
> items remain that may be worth further discussion:
>  - Disable CET/PT in tdx_get_supported_xfam(), as these features haven=E2=
=80=99t
>    been been tested.
>  - The Retry loop around tdh_phymem_page_reclaim() in =E2=80=9CKVM: TDX:
>    create/destroy VM structure=E2=80=9D likely can be dropped.
>  - Drop support for TDX Module=E2=80=99s that don=E2=80=99t support
>    MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM. [1]
>  - Type-safety in to_vmx()/to_tdx(). [2]

To sum up:

removed:
04 replaced by add wrapper functions for SEAMCALLs subseries
06: not needed anymore, all logic for KeyID mgmt now in x86/virt/tdx
10: tdx_capabilities dropped, replaced mostly by 02
11: KVM_TDX_CAPABILITIES moved to patch 16
19: not needed anymore
20: was needed by patch 24
22: folded in other patches
24: left for later
25: left for later/for userspace

01/02:ok
03: need to change 32 to 128
04: ok
05/06/07/08/09/10: replaced with
https://lore.kernel.org/kvm/20241203010317.827803-2-rick.p.edgecombe@intel.=
com/
11: see the type safety comment above:
> The ugly part here is the type-unsafety of to_vmx/to_tdx.  We probably
> should add some "#pragma poison" of to_vmx/to_tdx: for example both can
> be poisoned in pmu_intel.c after the definition of
> vcpu_to_lbr_records(), while one of them can be poisoned in
> sgx.c/posted_intr.c/vmx.c/tdx.c.

12/13/14/15: ok
16/17: to review
18: not sure why the check against num_present_cpus() is needed?
19: ok
20: ok
21: ok

22: missing review comment from v1

> +     /* TDX only supports x2APIC, which requires an in-kernel local APIC=
. */
> +     if (!vcpu->arch.apic)
> +             return -EINVAL;

nit: Use kvm_apic_present()

23: ok

24: need to apply fix

-       if (sub_leaf & TDX_MD_UNREADABLE_LEAF_MASK ||
+       if (leaf & TDX_MD_UNREADABLE_LEAF_MASK ||

25: ok


