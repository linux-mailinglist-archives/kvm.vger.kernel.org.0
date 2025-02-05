Return-Path: <kvm+bounces-37284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A8DA28059
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 01:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E463E1888FE0
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 00:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F55227BA0;
	Wed,  5 Feb 2025 00:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sc6hfSyj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241952F43
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 00:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716693; cv=none; b=byyRo38esRIRGQ1fDnyebWMFpqiGRaUlsBNn/vaK9xXSN0zBB0fieqxgYzhss1R6rsHnPBlzAGPhl0Uso/uAA0mps7wgAFxaa8ggqik6ZyVTTzh+XrgSggScrCRnVIradqFSUcVn5uwTbxTgIjsRtmbeFlQLN+k4hqxo7xZ3ctw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716693; c=relaxed/simple;
	bh=XtQQWabVOHX7zmQS2CO7NrOR6aQ88uLVgXmR1WS1CFg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ht+nNFV5bKej6hEzp+ENIpkuYWtfRv7HXyeDU8pDXK8Z3QXMVsIsTMngkuG9wj2bVb3kZbcb5SwBiVQxXggR9uwYYfPK5wIiHmvIY/RlT5X4JKnchVZc/PJamjYUzNSw6Keo1zKoL0JccgtT8bBxIOytk9isJaDMxkyXoJABchU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sc6hfSyj; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53e3a2264e1so12222e87.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 16:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738716690; x=1739321490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hc8Lcys0yC2tF2+f+cOwe8ZYx1K/RKZrOMNcRMYC5p4=;
        b=sc6hfSyjJeTXTaLNjjVpcC7rNLgDxpXcF6Keq2CbHm+aN1cKse4wOk6KrYrXMX4jby
         R360LJP5hyd+zr8hkrixbr0wVWAM3QiUd9mDdez/bJSSEGdjeTaeAGUK60A3ekryRBdW
         7pe8HgeqPnP7NKB+xfySSHDsO/+xR2JMe/UesyWaC+b8OLpvpsxrOFeRjFx3en7H6nIX
         1Ls2CceOD1a/YKwUuhCjs8OmKSTWGxjNMZjjRr2Pkyr/PZULkeoif0hrJP9hnBi3IQ/a
         daFOUClDHzK/lJs5l4neRKIDC7sKziQQUdBkRoaqLs4Zw8FxmoYe1hEvgwfSGocMKR3S
         0lWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716690; x=1739321490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hc8Lcys0yC2tF2+f+cOwe8ZYx1K/RKZrOMNcRMYC5p4=;
        b=QXu49dPX94h4JDLjT78aJWRGpqJfNKD2WWLrK2xJhupe42k65q3n+UwQ8lWPLTIC7Z
         Rm221uo6v0pGF0beRysAjA+hWHgtVeksYb4VK2jZyeql7ErRTNl9yKtGrGN38FDDyUCE
         XKmFZn8ubTlfSpok81FDaPb7aBsW1AmrXE/wsZczvTsyXGyjC4EcjY/4Xgafrwtqh317
         uF3GXPRLarPJ4KCkIkp1hmLtIMTCksdPKMDo3BmlIO744l1gFs821E0iJSim65XcqWSa
         +mQDUr0f6FUxH2c8o8MMHP2oHkYnkNpz/ii5TDS6Zletxi7M59bBw5Dp6OQvQov4wRFA
         YFDw==
X-Gm-Message-State: AOJu0Yy+/BxV2yP9y3Foz5MVK/zNKgV2bghAz+4cor2SwS00VhC/p7l0
	hWbCMar2dc+HzPNZ4BqLEl29+M6KMBnCiQYjzf23wJJZzg4KXxYdt9K0AiDB95pHxWcLZ+9bdC9
	GS3Fbf7NzvZV8d1ophNZMRSflORtL5C/q+s8v
X-Gm-Gg: ASbGncs2w5ZaiO04Vw6wc+1EIcOMN8N5R3hiTcuWCz3jkWZ/8jgoW3nly0nsdLgDkLZ
	p3WUthy0sh6PhtMNbFAxQJUmP4WduqzyKQk9it4CdpQpa5ubwVuifLPobLg6Veom/K/8sdVECkp
	4lyNupiKqnTUHq3IvJaSd4OLj8
X-Google-Smtp-Source: AGHT+IGFQO7s55x3biW/18h8H5HRUzXB3NHyKRsEz3BGUxgrIoIQVnI5qZd01OD1ZeF2iLwQJ+MGR/VRwInf18RB54k=
X-Received: by 2002:a05:6512:220d:b0:543:e5ac:8ba9 with SMTP id
 2adb3069b0e04-54400262b09mr447679e87.6.1738716689955; Tue, 04 Feb 2025
 16:51:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com> <20250117163001.2326672-7-tabba@google.com>
In-Reply-To: <20250117163001.2326672-7-tabba@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 4 Feb 2025 16:51:18 -0800
X-Gm-Features: AWEUYZkuSE-sHTWcu7LlcMXcBbzwY2ZrjgMl2ba1jEXbdckTrns-xOC5624jTFM
Message-ID: <CAGtprH-R7g5NNLZhO0hTs_RWML_pLafT8Wy=f13qTrHO5LscGw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 8:30=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
<snip>
>
>  static const char *page_type_name(unsigned int page_type)
> diff --git a/mm/swap.c b/mm/swap.c
> index 6f01b56bce13..15220eaabc86 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -37,6 +37,7 @@
>  #include <linux/page_idle.h>
>  #include <linux/local_lock.h>
>  #include <linux/buffer_head.h>
> +#include <linux/kvm_host.h>
>
>  #include "internal.h"
>
> @@ -103,6 +104,9 @@ static void free_typed_folio(struct folio *folio)
>         case PGTY_offline:
>                 /* Nothing to do, it's offline. */
>                 return;
> +       case PGTY_guestmem:
> +               kvm_gmem_handle_folio_put(folio);
> +               return;

Unless it's discussed before, kvm_gmem_handle_folio_put() needs to be
implemented outside KVM code which could be unloaded at runtime.
Eliott's plan [1] to implement a guest_memfd library can handle this
scenario in future.

[1] https://patches.linaro.org/project/linux-arm-msm/patch/20240829-guest-m=
emfd-lib-v2-1-b9afc1ff3656@quicinc.com/

