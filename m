Return-Path: <kvm+bounces-35550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 033E7A125F2
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 15:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4A2D3A7F2D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 14:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B1D7080A;
	Wed, 15 Jan 2025 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="PW6KZUbZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621078F51
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736951047; cv=none; b=TLpOjiLbQEguuNcoZHXeVpEvD1axcSMiO/7CqizVt59QpLOtJAXxU8jLy4B4/hTORNYDtloFqcfsRbNTWDa7BBEv0ri9l2oKfFL9UI80fVL5R5kQbZCQNMQkcSIt6ixUhDpF2Q2xYIJ0Xv5/q/YeViTkpX4XZJnj/PR4ukXAy1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736951047; c=relaxed/simple;
	bh=jhivC+n/vcaTpoLHzz1z0eZfNT6N7o10oU1CPrqeu8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4jPqZ5CsvFuOD+Rg6U38VeH4hK+3v0cjc19+KpMjao+Hbd1Q3SJ1Nzlw53MoOWCud2UPWRb/wABzikaIKwClhkcWElxyp3AFwa9htpEIcSP8AgqAmSprVkHr5r7IAlO0r76BYK8lKRwgUTrHcoh0M0haLJ8fkmDRSLiDhAmpZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=PW6KZUbZ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d3f65844deso11040228a12.0
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 06:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1736951044; x=1737555844; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f27bAX84AzL+EFQJIqUEmB7FxlZdaQIwVfhTkGD8eAU=;
        b=PW6KZUbZne2ZSWTLCkctSAhQNQjhQfA/6MMS+mP6DGcpcw8cwsc217nfuBEJENTXVr
         PwOwGUuLeWlD/xRopHkXdfRsaOkpxWokyC8r1/WlzhJ/7CPUhaX/vp6gu11byYq3nY4y
         R+V1VtKnl2pGW690e4OYkYaYE/kaZ7WKbl3OAPVIjmgmcECDIrfBXQaMBHOdr4DQxRU9
         F8iy2KvoeaMVZSA+7uJhTpjjvVNBnn3zMxMBVnWbjMDXrApLqvMGrzXH7rDcDBU+hoJQ
         6V6YI5+GhCAcBYt3Rffnu056R6wTSU+Y51+ZIZxXiEofGMGE/AbO7NaUCBxb30Z5sk6W
         cJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736951044; x=1737555844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f27bAX84AzL+EFQJIqUEmB7FxlZdaQIwVfhTkGD8eAU=;
        b=dCgolPgrdLfdG1jX5XeKRr4HZ3YI2PTOPxV50HuwT6/sxoD8bcIgF30cjwuWuUyT72
         +vjYEoTW0lushoGtYJFO0few30snBsUufWxVU485dEudUFaMtja3PukMIw/iQveoY0jE
         XpDn+azN+Bx3HbA7whrbeqlCgzD1VxCVHuvxa3D7K/U/0edrsBIYNP2rtHkXAUkLxwO+
         aAJcowrWNy6eiEFT4fFWEpZpFMpqKx2mwWeU8x/fASBGtNrSuwPa7lfqqVsZ2o+FpscD
         gNOXXkEHV5+1Wz097SRP3T1Ab7Q9w5/tpsIjp3X/3ozoJ48xN6tK1p778rhQndySRJ2d
         eMDw==
X-Gm-Message-State: AOJu0YzJJbYUUxCTQRLRYnIUbuuV4dVKdygJZVCU2fdK/CCbUUqrtFFm
	umylXSI/0/ZEjLf2oCvZTLDGiYUPuc2wJu9j8ryV9zmqbJLAiaRnzb4b1zvpO4o=
X-Gm-Gg: ASbGncu2OHsusVkTIyuYRAlL/5ygzsg0LFuj3OomjcY7fH80HQmRnXgnUcP7+BYAE6Q
	FLQhVkGqJZqsw6/m7osJZhJhO7Fntizsm2Y+O3Eluuz7A3Tz9u9cqAN227HVtK6ApHxsG8065PK
	5OpJCmzBOt12BW65ZPgYY7LSZ745H1AKFqMwZWgwTHryw2s2CcYYVUVZ1eSZLkSXi22pROx61OS
	p6ULr4xq7CZUp37oZVXLEmDrNVw7+4BT/jOSZ0/gfjW+aBeIlR9cEpFBZ9CyUH+fX1tJzClc5kT
	OQrrZvdZ6nKVsvdf0KIQGhJGt2vJdKBHNijDUJMOyA==
X-Google-Smtp-Source: AGHT+IFg1hay+OzhgrZg520xkKKbDWD4RwTyZmPGjG3ZG2WLaIdKPk8vwZndO8iolM+AVrUr0l6nyQ==
X-Received: by 2002:a17:907:94d0:b0:aa6:423c:850e with SMTP id a640c23a62f3a-ab2ab70fd34mr3062446766b.27.1736951043935;
        Wed, 15 Jan 2025 06:24:03 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95b0ab6sm757057666b.155.2025.01.15.06.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 06:24:03 -0800 (PST)
Date: Wed, 15 Jan 2025 15:24:02 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: kvm@vger.kernel.org, felix.chong@codethink.co.uk, 
	lawrence.hunter@codethink.co.uk, roan.richmond@codethink.co.uk
Subject: Re: [PATCH kvmtool] kvmtool: virtio: fix endian for big endian hosts
Message-ID: <20250115-73a1112ddbc729143d052afb@orel>
References: <20250115101125.526492-1-ben.dooks@codethink.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115101125.526492-1-ben.dooks@codethink.co.uk>

On Wed, Jan 15, 2025 at 10:11:25AM +0000, Ben Dooks wrote:
> When running on a big endian host, the virtio mmio-modern.c correctly
> sets all reads to return little endian values. However the header uses
> a 4 byte char for the magic value, which is always going to be in the
> correct endian regardless of host endian.
> 
> To make the simplest change, simply avoid endian convresion of the
> read of the magic value. This fixes the following bug from the guest:
> 
> [    0.592838] virtio-mmio 10020000.virtio: Wrong magic value 0x76697274!
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  virtio/mmio-modern.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
> index 6c0bb38..fd9c0cb 100644
> --- a/virtio/mmio-modern.c
> +++ b/virtio/mmio-modern.c
> @@ -66,7 +66,10 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
>  		return;
>  	}
>  
> -	*data = cpu_to_le32(val);
> +	if (addr != VIRTIO_MMIO_MAGIC_VALUE)
> +		*data = cpu_to_le32(val);
> +	else
> +		*data = val;
>  }
>  
>  static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
> -- 
> 2.37.2.352.g3c44437643
>

I think vendor_id should also have the same issue, but drivers don't
notice because they all use VIRTIO_DEV_ANY_ID. So how about the
change below instead?

Thanks,
drew

diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index b428b8d32f48..133817c1dc44 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -18,7 +18,7 @@ struct virtio_mmio_ioevent_param {
 };

 struct virtio_mmio_hdr {
-       char    magic[4];
+       u32     magic;
        u32     version;
        u32     device_id;
        u32     vendor_id;
diff --git a/virtio/mmio.c b/virtio/mmio.c
index fae73b52dae0..782268e8f842 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -6,6 +6,7 @@
 #include "kvm/irq.h"
 #include "kvm/fdt.h"

+#include <linux/byteorder.h>
 #include <linux/virtio_mmio.h>
 #include <string.h>

@@ -168,10 +169,10 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
                return r;

        vmmio->hdr = (struct virtio_mmio_hdr) {
-               .magic          = {'v', 'i', 'r', 't'},
+               .magic          = le32_to_cpu(0x74726976), /* 'virt' */
                .version        = legacy ? 1 : 2,
                .device_id      = subsys_id,
-               .vendor_id      = 0x4d564b4c , /* 'LKVM' */
+               .vendor_id      = le32_to_cpu(0x4d564b4c), /* 'LKVM' */
                .queue_num_max  = 256,
        };

