Return-Path: <kvm+bounces-20235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 462E1912258
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B28331F28F6B
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF8E3171653;
	Fri, 21 Jun 2024 10:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkQ4F2xZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CF217106F
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 10:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718965589; cv=none; b=OVNU2N9SMALHJqtvHzcqhEu7zdFhds4MhpEC1H2DnrWUOOjIZeg66606SxzScQ1Bay6y/W0eoGo9BCrihfSs6aYDw600CR84Z/FYGhvkoiytxXA2NBNKgLKKDjpNLQh8zHUlID/KxvobRuOgFkbdsDMff6bANhu1fyupkwIJ46I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718965589; c=relaxed/simple;
	bh=PSlzo89pcrInaHgm1rAzjiZZf2iE3/0TQqrn2q6Uook=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=opMM8XmaCo3xblMLSkOzHtSkslB/pBYyWYWfonbGzVX2yDvaw52RenGQjJLHCG/p9V9QkIkaIBTFrgKzTelsoaXqzuAfw82rERGTteAjNLXz3xK5SbQ6+GNVOUwmRG0IXVbWfzXioUgM/OYmMxUJE9K3jl1mbHV3OydS7QI7nC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkQ4F2xZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718965586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3vcZEnvcRN8efBD/EQKkDtTL1JriYb06mY/KS73HHY=;
	b=fkQ4F2xZaGgb+zRwdmPLx/Zb5VkGxkefi0uNp2FZCpTkqZzu7Gku5ShHs3wIfmPM1Ub/k/
	uxiTFf+qHbcUTkv5bo+EHRxNzTEgSJKlCktRAEuqE1URFbQYop4DjJJFejPEWcy9sTCnNa
	LaOio8g2NDrm1wbMbWNfpp9SudfixJQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-8W_GCExlP9KKpV91pir1HA-1; Fri, 21 Jun 2024 06:26:25 -0400
X-MC-Unique: 8W_GCExlP9KKpV91pir1HA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-421f3b7b27eso17730455e9.1
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 03:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718965584; x=1719570384;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b3vcZEnvcRN8efBD/EQKkDtTL1JriYb06mY/KS73HHY=;
        b=mNqrBbn0cThthV/o3rofVW0agB+Y4hVhJmHI/s0ZMHC/LdhDe+INYnfnqoR95xXHAr
         sN1Et8OuKg2BDdNe4w4oYSKqGTe6+i1LahDttLeb2BPQN0j+g5tEYUNiqgtfrfKN8b6V
         /cIjRpnwLp9womr2PTKC824d64oJ1t4dOhM2gFlf/HlJ942kfM8trqr1cJ22tjH/Wfmu
         kfqvDTIzpwSRKlJsEGG1x9scxCTTAXfAfDyNMV0sPl2pwNQXqjvA+91dqjs8I8+AR/Xw
         4K5ZUHt7ugrusP4rLqmsnqgjh7LNIu1a/95f7wa0wmLmLVZ9UCNEdyZEYHuIPY/BEzmx
         8qxw==
X-Forwarded-Encrypted: i=1; AJvYcCWsNcsdYzY1tG2csp0UzZ/wA2R5a2VeEKVQW+gE+TaU+mfkzN/ccMuO1xLWaPsYr1HzFvFw++A4Iut9K5XpCRaem66d
X-Gm-Message-State: AOJu0YykRMNmJkLKtlXPJ60gsYr7MC0B+YJRVVRHg6hnMPa7BQazoc7c
	rAbmhMG/n267A3FsMUlXkYll2wVwgTwWqmtr1HivuIEtaDFbQRAsz0v6uo85SSiCdJoR1UgGtCt
	DJGv+ZNlBvq8BmXQk/qrDjtbvc2DmRi7edP8caBJpqqnTM0kLuA==
X-Received: by 2002:a5d:464a:0:b0:35f:28eb:5a46 with SMTP id ffacd0b85a97d-363170ed434mr7821835f8f.10.1718965583995;
        Fri, 21 Jun 2024 03:26:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4JRNBJ051021SVYemFNpv29rT9dMwYZfyHe9BVlp3NdsyQCDHiUGJVdq7oPj3mgYJgtn+TQ==
X-Received: by 2002:a5d:464a:0:b0:35f:28eb:5a46 with SMTP id ffacd0b85a97d-363170ed434mr7821798f8f.10.1718965583190;
        Fri, 21 Jun 2024 03:26:23 -0700 (PDT)
Received: from redhat.com ([2.52.146.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3663a8c8b32sm1308063f8f.92.2024.06.21.03.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 03:26:22 -0700 (PDT)
Date: Fri, 21 Jun 2024 06:26:19 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas@t-8ch.de>
Cc: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v8 3/8] hw/misc/pvpanic: centralize definition of
 supported events
Message-ID: <20240621062512-mutt-send-email-mst@kernel.org>
References: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
 <20240527-pvpanic-shutdown-v8-3-5a28ec02558b@t-8ch.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240527-pvpanic-shutdown-v8-3-5a28ec02558b@t-8ch.de>

On Mon, May 27, 2024 at 08:27:49AM +0200, Thomas Weiﬂschuh wrote:
> The different components of pvpanic duplicate the list of supported
> events. Move it to the shared header file to minimize changes when new
> events are added.
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Thomas Weiﬂschuh <thomas@t-8ch.de>
> ---
>  hw/misc/pvpanic-isa.c     | 3 +--
>  hw/misc/pvpanic-pci.c     | 3 +--
>  hw/misc/pvpanic.c         | 3 +--
>  include/hw/misc/pvpanic.h | 4 ++++
>  4 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/hw/misc/pvpanic-isa.c b/hw/misc/pvpanic-isa.c
> index ccec50f61bbd..9a923b786907 100644
> --- a/hw/misc/pvpanic-isa.c
> +++ b/hw/misc/pvpanic-isa.c
> @@ -21,7 +21,6 @@
>  #include "hw/misc/pvpanic.h"
>  #include "qom/object.h"
>  #include "hw/isa/isa.h"
> -#include "standard-headers/linux/pvpanic.h"
>  #include "hw/acpi/acpi_aml_interface.h"
>  
>  OBJECT_DECLARE_SIMPLE_TYPE(PVPanicISAState, PVPANIC_ISA_DEVICE)
> @@ -102,7 +101,7 @@ static void build_pvpanic_isa_aml(AcpiDevAmlIf *adev, Aml *scope)
>  static Property pvpanic_isa_properties[] = {
>      DEFINE_PROP_UINT16(PVPANIC_IOPORT_PROP, PVPanicISAState, ioport, 0x505),
>      DEFINE_PROP_UINT8("events", PVPanicISAState, pvpanic.events,
> -                      PVPANIC_PANICKED | PVPANIC_CRASH_LOADED),
> +                      PVPANIC_EVENTS),
>      DEFINE_PROP_END_OF_LIST(),
>  };
>  
> diff --git a/hw/misc/pvpanic-pci.c b/hw/misc/pvpanic-pci.c
> index 83be95d0d249..603c5c7600da 100644
> --- a/hw/misc/pvpanic-pci.c
> +++ b/hw/misc/pvpanic-pci.c
> @@ -21,7 +21,6 @@
>  #include "hw/misc/pvpanic.h"
>  #include "qom/object.h"
>  #include "hw/pci/pci_device.h"
> -#include "standard-headers/linux/pvpanic.h"
>  
>  OBJECT_DECLARE_SIMPLE_TYPE(PVPanicPCIState, PVPANIC_PCI_DEVICE)
>  
> @@ -55,7 +54,7 @@ static void pvpanic_pci_realizefn(PCIDevice *dev, Error **errp)
>  
>  static Property pvpanic_pci_properties[] = {
>      DEFINE_PROP_UINT8("events", PVPanicPCIState, pvpanic.events,
> -                      PVPANIC_PANICKED | PVPANIC_CRASH_LOADED),
> +                      PVPANIC_EVENTS),
>      DEFINE_PROP_END_OF_LIST(),
>  };
>  
> diff --git a/hw/misc/pvpanic.c b/hw/misc/pvpanic.c
> index 1540e9091a45..a4982cc5928e 100644
> --- a/hw/misc/pvpanic.c
> +++ b/hw/misc/pvpanic.c
> @@ -21,13 +21,12 @@
>  #include "hw/qdev-properties.h"
>  #include "hw/misc/pvpanic.h"
>  #include "qom/object.h"
> -#include "standard-headers/linux/pvpanic.h"


This part is wrong. PVPANIC_PANICKED and PVPANIC_CRASH_LOADED
are still used in pvpanic.c directly, so we should
include standard-headers/linux/pvpanic.h to avoid depending
on which header includes which.

I fixed up the patch.


>  static void handle_event(int event)
>  {
>      static bool logged;
>  
> -    if (event & ~(PVPANIC_PANICKED | PVPANIC_CRASH_LOADED) && !logged) {
> +    if (event & ~PVPANIC_EVENTS && !logged) {
>          qemu_log_mask(LOG_GUEST_ERROR, "pvpanic: unknown event %#x.\n", event);
>          logged = true;
>      }
> diff --git a/include/hw/misc/pvpanic.h b/include/hw/misc/pvpanic.h
> index fab94165d03d..947468b81b1a 100644
> --- a/include/hw/misc/pvpanic.h
> +++ b/include/hw/misc/pvpanic.h
> @@ -18,6 +18,10 @@
>  #include "exec/memory.h"
>  #include "qom/object.h"
>  
> +#include "standard-headers/linux/pvpanic.h"
> +
> +#define PVPANIC_EVENTS (PVPANIC_PANICKED | PVPANIC_CRASH_LOADED)
> +
>  #define TYPE_PVPANIC_ISA_DEVICE "pvpanic"
>  #define TYPE_PVPANIC_PCI_DEVICE "pvpanic-pci"
>  
> 
> -- 
> 2.45.1


