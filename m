Return-Path: <kvm+bounces-11381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBFAF876A03
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 788EA1F22249
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAF850251;
	Fri,  8 Mar 2024 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="OQbO7omb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FA54879B
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709919317; cv=none; b=qNr4YkgdAMnvWQaAxDj/m6gjb6XY2thFODE6BKuEdb4Q8ZjchCXwvs9j3FikS20l8CWkdh21/jYMJfMoVsewS2DPjfGpA9D8ULa6+uhZTvKNS2OY6Pexg1xQnfHNBNP3ufHQrdyPLCnmizk89Q8u2tYTCHNgjBURlkzrgUcLFvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709919317; c=relaxed/simple;
	bh=sDCuyYqHhXwatCvf1bK8Y6Awy2oBcDLB7r6iE7tGSow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlbzBxaynS4ynasCoYC/uJtVLO7ZTO9J7PCQ/XOuOcjOV/PYNxusl5ZrZ9tUbCOkFh6L2Dv0OIUN+9cstcCwEaVh8z8nnvAixRHt6AMdZwdg0IXKUpe2VtUaQ05jYXW2ga/+GDi4K8/tI75douN4YG/p2cNWrC3tPlAZsr6VYtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=OQbO7omb; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5a1d83a86e8so61089eaf.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 09:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1709919314; x=1710524114; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=42z1c6En4OMO73HSWbt9qhFCGOY4c7z3vfsZqA96K6s=;
        b=OQbO7ombB7Tq73mesaPSUQegfYEQV6zfdH3bU03Q1FmiF29gr1Yq60HgwLeglJW8mF
         cKpulOh9gZSW1J3Y8tcusQiih/fWGDVP9o0CtSirUfcv3UtmKny/wRp+QFWHqCAj+1la
         1bjE+l45idH4JVdHZuEy4hfY8TeDe6GM2kDdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709919314; x=1710524114;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42z1c6En4OMO73HSWbt9qhFCGOY4c7z3vfsZqA96K6s=;
        b=F9TK1JL2vpFu8M33SvJq4PjYbd3PIZBOCJ+2+3l42VuTQxJyR4dPOQBTb5Dpcx8sP2
         0uo1oIPYzPObI+BNEfapfPHOKJTBMKSx5M0DLlYZD8zS98G+gwDP4qKkZKXdGwIwLrLR
         WuCTcxCXvCjbFAC8HiamB0ICVUj3B/ZVG6itgKfSwHrGC4Tfjj2620CSleEJ0qkSs3MT
         F/XsFJTpDgd+I56Jmkg0gErcday0jR8vDy6Fok/ARJxJbq/e4xzsOTGKL4aHD2h8BIbR
         tlKRWjt4xwA9SSNhScDOnH98Em/oaQ9UaD9UeGrFd9uMThvGEDXGnTOXiYW7kUbDynNw
         9brw==
X-Forwarded-Encrypted: i=1; AJvYcCVamHvor/eEei0Yro5wk6Pkw8447iKALOm2eST2A5kI4JhKJGqYvtrtoy3KACeuE0EYSo+6BfqS4+hGzTix6JJtfxkr
X-Gm-Message-State: AOJu0YzX6Nxm0add8QyyFehR0QuqgsgIuXu2fqH7+XQKJh0OoY2Q2lAQ
	ldSbyntuTmf6+bQg73OoMzsK/s6N9bob50gTWAUrnHFGsT6vXrQ8HVL3h/oGd329Cxg95zFJb0X
	1cms=
X-Google-Smtp-Source: AGHT+IFP+iIn7ziPACo/W5ywuwt3jU9vKOJI+Md4melHw3m+IPRBayOOv3MnfyWInvHuBqQD34WXQg==
X-Received: by 2002:a05:6820:2227:b0:5a1:34cf:400c with SMTP id cj39-20020a056820222700b005a134cf400cmr12525786oob.9.1709919314653;
        Fri, 08 Mar 2024 09:35:14 -0800 (PST)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id z5-20020a05683020c500b006e12266433csm2248064otq.27.2024.03.08.09.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 09:35:14 -0800 (PST)
Date: Fri, 8 Mar 2024 17:35:08 +0000
From: Anthony PERARD <anthony.perard@cloud.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Barrat <fbarrat@linux.ibm.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>, mzamazal@redhat.com,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>, Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 01/29] bulk: Access existing variables initialized to
 &S->F when available
Message-ID: <a495a2c8-0259-4a44-8ac4-9cb6052074b6@perard>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-2-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240129164514.73104-2-philmd@linaro.org>

On Mon, Jan 29, 2024 at 05:44:43PM +0100, Philippe Mathieu-Daudé wrote:
> When a variable is initialized to &struct->field, use it
> in place. Rationale: while this makes the code more concise,
> this also helps static analyzers.
> 
> Mechanical change using the following Coccinelle spatch script:
> 
>  @@
>  type S, F;
>  identifier s, m, v;
>  @@
>       S *s;
>       ...
>       F *v = &s->m;
>       <+...
>  -    &s->m
>  +    v
>       ...+>
> 
> Inspired-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
> diff --git a/hw/xen/xen_pt.c b/hw/xen/xen_pt.c
> index 36e6f93c37..10ddf6bc91 100644
> --- a/hw/xen/xen_pt.c
> +++ b/hw/xen/xen_pt.c
> @@ -710,7 +710,7 @@ static void xen_pt_destroy(PCIDevice *d) {
>      uint8_t intx;
>      int rc;
>  
> -    if (machine_irq && !xen_host_pci_device_closed(&s->real_device)) {
> +    if (machine_irq && !xen_host_pci_device_closed(host_dev)) {
>          intx = xen_pt_pci_intx(s);
>          rc = xc_domain_unbind_pt_irq(xen_xc, xen_domid, machine_irq,
>                                       PT_IRQ_TYPE_PCI,
> @@ -759,8 +759,8 @@ static void xen_pt_destroy(PCIDevice *d) {
>          memory_listener_unregister(&s->io_listener);
>          s->listener_set = false;
>      }
> -    if (!xen_host_pci_device_closed(&s->real_device)) {
> -        xen_host_pci_device_put(&s->real_device);
> +    if (!xen_host_pci_device_closed(host_dev)) {
> +        xen_host_pci_device_put(host_dev);

For the Xen part:
Reviewed-by: Anthony PERARD <anthony.perard@citrix.com>

Thanks,

-- 
Anthony PERARD

