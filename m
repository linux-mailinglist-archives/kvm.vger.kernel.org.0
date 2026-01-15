Return-Path: <kvm+bounces-68171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B388D24109
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 12:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C511304A9A9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 11:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2A0374171;
	Thu, 15 Jan 2026 11:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NW8wN38V";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gmgdYk5P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0202F37417F
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 11:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768475117; cv=none; b=Z0wsiiC/Zx0toX90UE6xAFkSKo3KXu3nGTLm+KVEhpx8w9RIGubfjGY39yASDfxsQral7tHawCbSvkRyU6IPSKrP3C+SSIhqCTt71Bd+62xTVPFNqardiPQ9kUQdYm+7nhNDR9yATshTpAbR2jH0UKbU6A3ia6+GOOw4jCLljfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768475117; c=relaxed/simple;
	bh=C2hWRDzQDA9fpIwxI9IGLgvZ48W0v3yG6Q+0DKIMrJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J41CicMQUJDXdMFzYaEKRqUoMYpunoHdFCoDPswjJ8WXOJiZiXdOe1TFkAjXCkvN8/3ab9y0o4jdQHOLaScugGYMswS2JassWrlgVA3Ec8Ov4fWHIMS3llYzKZkuOxIa3Pz/fk+2G7lvrwEepSN4wkFaxSqM5D36qM0xw9vNb74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NW8wN38V; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gmgdYk5P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768475111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Svd+r6JtR49rS3ZhVIBHDUx48l4coX+GwI5DLO3FBNY=;
	b=NW8wN38V064Lm5GxbzBZ+hq1saiqhproJMxsB0HHmYifdVQAsSIsjoD2srJJupFMRJEB5y
	6N7NoyFkzCpaFG+N9HPcvxN4l+tKLw89iU+PLwXPpqSmylRw5gGW+OXnlX6g0tWV8I+pvU
	cqOOV8sqK2DVsGoNjFwlbZc4YYW2Frw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-kPS9HISUOoqqUIbwig8BqQ-1; Thu, 15 Jan 2026 06:05:10 -0500
X-MC-Unique: kPS9HISUOoqqUIbwig8BqQ-1
X-Mimecast-MFC-AGG-ID: kPS9HISUOoqqUIbwig8BqQ_1768475109
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4801ad6e51cso3826525e9.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 03:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768475109; x=1769079909; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Svd+r6JtR49rS3ZhVIBHDUx48l4coX+GwI5DLO3FBNY=;
        b=gmgdYk5P5RndeSdIL9XTjYfjma/a9+DO2i1wcGtKJ+7UOYVYZ/3yxmZHHDSeN8Uwsc
         8peVX/tbflmizMrsfyNaHbkzJHNIJSWIWbEKX/lQRWffdv2bsgxLOOZD1TUb+LNtglsz
         4MP5C4Ffdwj5aCCB1i7bvONmE6Ld/DIx53vdkXir5LpXj5THBk9BDFGuP+6zNHNbDX+v
         UliVUDsFVjm9iJYWGYXKo6mjmRdL51+IEDR8MOvLJ3ftqBcN9fY/x2/g++P/Q+jXa9ee
         vEq/6zrSAaNcISj3/gZ7vO1TmzPJb1Q65r+e1EZ/1wo3JwWxVy1ddyv9edpAL5R0uFht
         FUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768475109; x=1769079909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Svd+r6JtR49rS3ZhVIBHDUx48l4coX+GwI5DLO3FBNY=;
        b=LjirJ5r3KEg0z98WoOqQfqabmN8OIZdzRgjCTPXWXz2AmmHvh3shjKVX5+yjxMjGQR
         MaHEJeP/y0QbAJ7rP4k3w3cPgZ/K8V3sX96SvhkSySyv0WlbXnBGlQPv8YGiqiKE+fip
         aM6moagGcr7dd1nV+tWiPKXLSN6E3vpQxz93WuU1k0vJ4C6OukGf4lgVNCkro8Fn/mIw
         XpGEPBmf5AHI2PnDoTWMhHUhD1aA/2+2GwRgA/5/VhzmCjcHiyf9GdL/fXmLgpT5X8/9
         Th9Qs2PDV/QpoG+meTs2K9EhAoQFpDVtf0EqDx7YU0oA6Z30Yf6RxWnIvyA2BeSzadHp
         1rpg==
X-Forwarded-Encrypted: i=1; AJvYcCUl+d0kGYC7EbTwnkHHm3XoTwsmCD1wl0fycg3UZkJDUade5zHLiWjHaqwZeXXYwJimf2w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+kkRPWc94bgHLPzKr9ZM9P58Kvk8nH98rJ4gUyCWPP3nWHKJn
	eq28eL+NvSbM/FXndaO+/37aiD6DQTE9dTtFcBjEh8iIa3+BaJCDAlgs78zhCG4y2t6qW1Sj8Wd
	1dbIHYIs4ML5hrQ30mIM6uEexJVdwYU7TbEjuj8w7qaUWzOKiCauKlA==
X-Gm-Gg: AY/fxX68ljvvWSYUi22tWm5yx8n9iy75LfkTiIH3WJNWU3OSJX3H5Wdf11WllfF9bpV
	MxGHXh/tC5kOovpi2VNCVSJnfCD5PZQSiMO//BQ1jL8rT309crA0pSbD9NPyw+ydjsAT7I8dE0K
	EhbV9YIpLwof1pTk2eWp8C00xpBoZE6FNGPOUS5SAkuCsLvyPRX7d+E5862kDLKmrF/bLoQmMOu
	arOXnQH6AfrWjAuUoPw6xObAH67PudEQtjsGB30DPa5/P+HeNNHzJV2oAR/Xurc3A2afb1aNdqJ
	TqST4MzV4uGDiObewEXZLluf9CRh6MA51jTvSK2z6NMsB8RIMjaLEGK5DslGqdMgBPmRNE0KyA9
	sr0DC/6wWMKXe5JU=
X-Received: by 2002:a05:600c:a11:b0:479:1a09:1c4a with SMTP id 5b1f17b1804b1-47ee4841128mr70773015e9.31.1768475109238;
        Thu, 15 Jan 2026 03:05:09 -0800 (PST)
X-Received: by 2002:a05:600c:a11:b0:479:1a09:1c4a with SMTP id 5b1f17b1804b1-47ee4841128mr70772465e9.31.1768475108810;
        Thu, 15 Jan 2026 03:05:08 -0800 (PST)
Received: from leonardi-redhat ([176.206.16.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f428cebdcsm40826035e9.12.2026.01.15.03.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:05:08 -0800 (PST)
Date: Thu, 15 Jan 2026 12:05:04 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Richard Henderson <richard.henderson@linaro.org>, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v4 5/5] igvm: Fill MADT IGVM parameter field
Message-ID: <aWjJdGSOl0T9zEqK@leonardi-redhat>
References: <20260114175007.90845-1-osteffen@redhat.com>
 <20260114175007.90845-6-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260114175007.90845-6-osteffen@redhat.com>

On Wed, Jan 14, 2026 at 06:50:07PM +0100, Oliver Steffen wrote:
>Use the new acpi_build_madt_standalone() function to fill the MADT
>parameter field.
>
>The IGVM parameter can be consumed by Coconut SVSM [1], instead of
>relying on the fw_cfg interface, which has caused problems before due to
>unexpected access [2,3]. Using IGVM parameters is the default way for
>Coconut SVSM across hypervisors; switching over would allow removing
>specialized code paths for QEMU in Coconut.
>
>Coconut SVSM needs to know the SMP configuration, but does not look at
>any other ACPI data, nor does it interact with the PCI bus settings.
>Since the MADT is static and not linked with other ACPI tables, it can
>be supplied stand-alone like this.
>
>Generating the MADT twice (during ACPI table building and IGVM processing)
>seems acceptable, since there is no infrastructure to obtain the MADT
>out of the ACPI table memory area.
>
>In any case OVMF, which runs after SVSM has already been initialized,
>will continue reading all ACPI tables via fw_cfg and provide fixed up
>ACPI data to the OS as before without any changes.
>
>[1] https://github.com/coconut-svsm/svsm/pull/858
>[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
>[3] https://github.com/coconut-svsm/svsm/issues/646
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> backends/igvm.c | 32 ++++++++++++++++++++++++++++++++
> 1 file changed, 32 insertions(+)
>
>diff --git a/backends/igvm.c b/backends/igvm.c
>index cb2f997c87..980068fb58 100644
>--- a/backends/igvm.c
>+++ b/backends/igvm.c
>@@ -18,6 +18,7 @@
> #include "system/memory.h"
> #include "system/address-spaces.h"
> #include "hw/core/cpu.h"
>+#include "hw/i386/acpi-build.h"
>
> #include "trace.h"
>
>@@ -134,6 +135,8 @@ static int qigvm_directive_snp_id_block(QIgvm *ctx, const uint8_t *header_data,
> static int qigvm_initialization_guest_policy(QIgvm *ctx,
>                                        const uint8_t *header_data,
>                                        Error **errp);
>+static int qigvm_directive_madt(QIgvm *ctx, const uint8_t *header_data,
>+                                Error **errp);
>
> struct QIGVMHandler {
>     uint32_t type;
>@@ -162,6 +165,8 @@ static struct QIGVMHandler handlers[] = {
>       qigvm_directive_snp_id_block },
>     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
>       qigvm_initialization_guest_policy },
>+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
>+      qigvm_directive_madt },
> };
>
> static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
>@@ -771,6 +776,33 @@ static int qigvm_initialization_guest_policy(QIgvm *ctx,
>     return 0;
> }
>
>+static int qigvm_directive_madt(QIgvm *ctx, const uint8_t *header_data,
>+                                Error **errp)
>+{
>+    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
>+    QIgvmParameterData *param_entry;
>+    int result = 0;
>+
>+    /* Find the parameter area that should hold the MADT data */
>+    param_entry = qigvm_find_param_entry(ctx, param);
>+    if (param_entry != NULL) {

what about an early return here? I think it would make the code much 
cleaner.

On top of that, we return 0 even if we don't find the entry, is that 
correct?

Luigi


