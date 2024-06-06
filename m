Return-Path: <kvm+bounces-19019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD0088FF15A
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D2E42841B0
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 15:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766C6197A77;
	Thu,  6 Jun 2024 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BnZtsX6t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE62197A6A
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717689339; cv=none; b=QJNNh0XXKREaY4F1Qr7x6u2nZlTq9z4jWsF7k3EEEjRehPlODgwSzHx10JlwB0P/oP0Pd8UloQQ0+xhkjrk7bkTJUbcdzCijHy90TPuw+OBheLnQ+kdy/S1BFPSnLLT/dr/h97ZjLRlPMTZ9OyX71zCmTbVhwTUvlR7rpmlJWuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717689339; c=relaxed/simple;
	bh=sYwMXyFF5ixGHvNGo97vEq7NFrrcLjDHWZL8/TD1lOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Znh9ykmc2/QWpG44ItKZjJZYM7qXXWlI5Qqai23BXrlY5H9Ck1T/Dc00ZNaBDuCcm3OkqsU53PYcSr7CxyqEGgRPlq66g9jkEK4CyT/trAxWX5TLkaG+nTw1wqn+4VDx+qJAbUlvHZPm1U39eRdTPPISKWm8CGUqfj3jKcIrseM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BnZtsX6t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717689337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VAS3T4eIlsBeIGJQaMBH344OaeO565Bp+YWQvYSRJRg=;
	b=BnZtsX6tvw4XtMyCVF6t7dWkRdrfJiQCSTNdO6TzwSDXxkMmtMUlTD9QEdv8zrU39KEYXL
	C+bOqbqkI3632h0jCujQtj7IJPCRUmx7GNIrabdq03bwKebpfSZGOiGoGBOWmrWb+HPJNr
	FKRxx3YwQbpu6RMnD0k6z3L21gOSMIY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-yYPZFIrEMcSf03yLs6BLwQ-1; Thu, 06 Jun 2024 11:55:34 -0400
X-MC-Unique: yYPZFIrEMcSf03yLs6BLwQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35e7d4f4243so791090f8f.1
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 08:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717689333; x=1718294133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VAS3T4eIlsBeIGJQaMBH344OaeO565Bp+YWQvYSRJRg=;
        b=sYtWlHCfyEkluRDv5hj9hrULLQ6o1UXVJglTrWx5mRle6kvjCjdrgoHBGOxA/wuCpj
         8RHZTrgSo6oFg9SFrho8i4gHdpURDTHEmjrTYpXKM/o/3+X8r/7ap8v5gb35V8e21mQw
         6e/2GnuEf92+jR/jRhWNci+aJ4x08tgOHhP5fvQdcDKfBBcyNthw0n2uogsEJrOHZt0C
         lpuDnJLRKxjhjlHlv1dKbKOZnnzkkM16K3xoNdcTtFMUUomfBr7/ZFz0D+vQyrPyVMo1
         pCJoM7Zd7eisEwVgVgUYwYgwnFHc4Cgfwgls1iMnhJk7h+hW3z9UnaqQy18e9Zuc//FO
         kR2g==
X-Forwarded-Encrypted: i=1; AJvYcCWREHAuj5EaJjvBrIkwJIwciWIjHrMAaHjRrwc6N2nf5XU7nim+sX01Ie61VJu1GRDxKBdW35HHA9/lxF5d6fHpTYyU
X-Gm-Message-State: AOJu0YwGI7dbpq4hbgFJfKqFtxrR4orIDXvcaEKOhUelW69kEIxpKq+3
	68VLhnmtZxkGVwTPR8+XF/NBSuLxgKafU75xlvpMD7qTGhovimFCo+qHqmptk6uiRkIIOzhQ1WZ
	9QejF8mDkiieQU9tEsUZdlED7PD5D/JAGBtf0/7S8G+b21lIrBl5Hk7huMs2H4PDCWEWT1WpHZz
	Drpf1tBWo6xEAvMx5hrjSsaaxl
X-Received: by 2002:adf:ed86:0:b0:355:451:df52 with SMTP id ffacd0b85a97d-35efed7287emr30396f8f.34.1717689333254;
        Thu, 06 Jun 2024 08:55:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2Y8tswbPAEDMxvcnWmmCT8GpIPg0n2c4bvuPyToo4YuEroQzgcRPSS7Py1HooVbVd0cTca+l6fSiY5takNSY=
X-Received: by 2002:adf:ed86:0:b0:355:451:df52 with SMTP id
 ffacd0b85a97d-35efed7287emr30378f8f.34.1717689332948; Thu, 06 Jun 2024
 08:55:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-2-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-2-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 6 Jun 2024 17:55:21 +0200
Message-ID: <CABgObfZ8qOJtui9ozU4sd-hnjNM_33qwA-jcJEeDc=RY5EoqfA@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] KVM: Add member to struct kvm_gfn_range for
 target alias
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 11:07=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
> +       /* Unmmap the old attribute page. */

Unmap

> +       if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +               range->process =3D KVM_PROCESS_SHARED;
> +       else
> +               range->process =3D KVM_PROCESS_PRIVATE;
> +
>         return kvm_unmap_gfn_range(kvm, range);
>  }
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c3c922bf077f..f92c8b605b03 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -260,11 +260,19 @@ union kvm_mmu_notifier_arg {
>         unsigned long attributes;
>  };
>
> +enum kvm_process {
> +       BUGGY_KVM_INVALIDATION          =3D 0,
> +       KVM_PROCESS_SHARED              =3D BIT(0),
> +       KVM_PROCESS_PRIVATE             =3D BIT(1),
> +       KVM_PROCESS_PRIVATE_AND_SHARED  =3D KVM_PROCESS_SHARED | KVM_PROC=
ESS_PRIVATE,
> +};

Only KVM_PROCESS_SHARED and KVM_PROCESS_PRIVATE are needed.

> +       /*
> +        * If/when KVM supports more attributes beyond private .vs shared=
, this
> +        * _could_ set exclude_{private,shared} appropriately if the enti=
re target

this could mask away KVM_PROCESS_{SHARED,PRIVATE} if the entire target...

Paolo

> +        * range already has the desired private vs. shared state (it's u=
nclear
> +        * if that is a net win).  For now, KVM reaches this point if and=
 only
> +        * if the private flag is being toggled, i.e. all mappings are in=
 play.
> +        */
> +
>         for (i =3D 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
>                 slots =3D __kvm_memslots(kvm, i);
>
> @@ -2506,6 +2519,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kv=
m, gfn_t start, gfn_t end,
>         struct kvm_mmu_notifier_range pre_set_range =3D {
>                 .start =3D start,
>                 .end =3D end,
> +               .arg.attributes =3D attributes,
>                 .handler =3D kvm_pre_set_memory_attributes,
>                 .on_lock =3D kvm_mmu_invalidate_begin,
>                 .flush_on_ret =3D true,
> --
> 2.34.1
>


