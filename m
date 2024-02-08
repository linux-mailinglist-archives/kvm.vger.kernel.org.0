Return-Path: <kvm+bounces-8344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8331184E1FE
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:31:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 751C11C23444
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE674763F4;
	Thu,  8 Feb 2024 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C1nKUUet"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FE871B47
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 13:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707399058; cv=none; b=h37KFjgYFw4a9fRVGQHH6+ybB5agyWsI6RhVL3OPoCPU0GloOppQ+41xaYP4ClpPep6cmmSe82ny1306zBma7RL6Sl6OBFM4nPN742m8Bs9YSJrqOrmWSvNGxbM+BWvM7jhLR+DSbjEIf/GiloUReYFkLu38Q2B9EfHZ2Bbl+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707399058; c=relaxed/simple;
	bh=0Y/NWtq0++KDS7DW5Ga8O7mDH7qi4qQn92PYZrXAwJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdRLLuD9AtS629+95uOwhqt3mIOVxNXcvibDnq5Jor42fjsrsHJ381DViR2AmHeU0gAb0TMGIsvHSf9xHLi20Hw//EHBva1Ej2NtJ9g+kD+y3upBHwwDireb18npGNBGvriBxSHC++ydy6uT9FKA4wy+ZrJIeWHTTA+2y8fq8mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C1nKUUet; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707399055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=skHZhH2neXcw79cTYknGaCDYowrcPvP9mC0pM3v/Buk=;
	b=C1nKUUetf4Sei3lltfc5DOaaipaGN9gnXrytwp3KUBoXrGwCppCSCUfcoyoz0Z1pJz5ULG
	60fh3gEvP6nV8PkUEf9UKRVUdMaR4TSsWnjBo3JsNju9vJGYuVnsRj64U+kBf7gVeRl+BT
	ZHzVlVHQCxiLr1xZFdIiVgZckldWeHM=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-an955_qlPxqKEBCJCZ3HFw-1; Thu, 08 Feb 2024 08:30:54 -0500
X-MC-Unique: an955_qlPxqKEBCJCZ3HFw-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4c031359125so993254e0c.0
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 05:30:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707399053; x=1708003853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skHZhH2neXcw79cTYknGaCDYowrcPvP9mC0pM3v/Buk=;
        b=AdlWgC6LRHeuS94SzHn25+mvnPPM6BFDHxbqJNemRpU3CwCYX539tA8pIgCVC790S3
         3Sy1X2AGRI9v9WGhv7EI8Rcr2mN38ccM+QFwW4Wm8Y369dGk9ETNl2SYYfO2sl+m+C0b
         Hk0hXVssOLP2gem9Itwz5D2B0LngVZxa5XIad7jv58oLKSycXmVMzSHwSNvb9bjcvCnH
         jGZ327Opt8mSAc8TKeaWWBVwGIlrQG1HSsS7F1MaovJ6nJOcLag6lIlAILl/u2wIG9Rn
         wsAh2+GmCD8UeXMk9RGSFrKWQRJn+wGEH7AMDQspey46t4UEF3N8s1CLD4hczDoy4Nnf
         5Ufw==
X-Gm-Message-State: AOJu0YxUwg4ESlT8heGPCHDo052N+qZ1KGaXfFJMx5lDac4tjFUvT7Qn
	rq04QuQm3oJ23epkq2YfHgz2L9rrd6IVdmVfD4gzuQcMB6FgXN/BWudEBgKGt99BSRM95IWLeR3
	OD8+fF8HvKD20LPQBqewX6tRioHjNqIEwvodbkAjrpoiALXtC46+UY+E+Xkcmy5mBHx8zcG0xFk
	+ozzyGfXXEOa7z4EC6IqUi3gy6VlKv9QdF
X-Received: by 2002:a05:6122:180b:b0:4b8:4e76:a5e6 with SMTP id ay11-20020a056122180b00b004b84e76a5e6mr2144901vkb.2.1707399053100;
        Thu, 08 Feb 2024 05:30:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHob5ah0xO/MlvFGAhaRvzI6DpcAzryTHKFxy2TvzFiQUbK7JU6un06DmZ+jkQelMn9n9cWdEcFEiY+DONfdyE=
X-Received: by 2002:a05:6122:180b:b0:4b8:4e76:a5e6 with SMTP id
 ay11-20020a056122180b00b004b84e76a5e6mr2144873vkb.2.1707399052811; Thu, 08
 Feb 2024 05:30:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com> <88bcf53760c42dafb14cd9a92bf4f9243f597bbe.1705965634.git.isaku.yamahata@intel.com>
In-Reply-To: <88bcf53760c42dafb14cd9a92bf4f9243f597bbe.1705965634.git.isaku.yamahata@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 8 Feb 2024 14:30:40 +0100
Message-ID: <CABgObfYo0OaSXUYjQbn188y8JOAZGzD56TabdyENXAW6_Ca0Hw@mail.gmail.com>
Subject: Re: [PATCH v18 002/121] x86/virt/tdx: Export SEAMCALL functions
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, 
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 12:54=E2=80=AFAM <isaku.yamahata@intel.com> wrote:
>
> From: Kai Huang <kai.huang@intel.com>
>
> KVM will need to make SEAMCALLs to create and run TDX guests.  Export
> SEAMCALL functions for KVM to use.
>
> Also add declaration of SEAMCALL functions to <asm/asm-prototypes.h> to
> support CONFIG_MODVERSIONS=3Dy.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

I thought you were going to introduce builtin functions for SEAMCALLs
needed by KVM, instead?

In any case, missing Signed-off-by.

Paolo

> ---
>  arch/x86/include/asm/asm-prototypes.h | 1 +
>  arch/x86/virt/vmx/tdx/seamcall.S      | 4 ++++
>  2 files changed, 5 insertions(+)
>
> diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm=
/asm-prototypes.h
> index b1a98fa38828..0ec572ad75f1 100644
> --- a/arch/x86/include/asm/asm-prototypes.h
> +++ b/arch/x86/include/asm/asm-prototypes.h
> @@ -13,6 +13,7 @@
>  #include <asm/preempt.h>
>  #include <asm/asm.h>
>  #include <asm/gsseg.h>
> +#include <asm/tdx.h>
>
>  #ifndef CONFIG_X86_CMPXCHG64
>  extern void cmpxchg8b_emu(void);
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/sea=
mcall.S
> index 5b1f2286aea9..e32cf82ed47e 100644
> --- a/arch/x86/virt/vmx/tdx/seamcall.S
> +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> @@ -1,5 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <linux/linkage.h>
> +#include <linux/export.h>
>  #include <asm/frame.h>
>
>  #include "tdxcall.S"
> @@ -21,6 +22,7 @@
>  SYM_FUNC_START(__seamcall)
>         TDX_MODULE_CALL host=3D1
>  SYM_FUNC_END(__seamcall)
> +EXPORT_SYMBOL_GPL(__seamcall);
>
>  /*
>   * __seamcall_ret() - Host-side interface functions to SEAM software
> @@ -40,6 +42,7 @@ SYM_FUNC_END(__seamcall)
>  SYM_FUNC_START(__seamcall_ret)
>         TDX_MODULE_CALL host=3D1 ret=3D1
>  SYM_FUNC_END(__seamcall_ret)
> +EXPORT_SYMBOL_GPL(__seamcall_ret);
>
>  /*
>   * __seamcall_saved_ret() - Host-side interface functions to SEAM softwa=
re
> @@ -59,3 +62,4 @@ SYM_FUNC_END(__seamcall_ret)
>  SYM_FUNC_START(__seamcall_saved_ret)
>         TDX_MODULE_CALL host=3D1 ret=3D1 saved=3D1
>  SYM_FUNC_END(__seamcall_saved_ret)
> +EXPORT_SYMBOL_GPL(__seamcall_saved_ret);
> --
> 2.25.1
>


