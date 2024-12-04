Return-Path: <kvm+bounces-33049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFFE9E4193
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC4DCB352C5
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA2320D50C;
	Wed,  4 Dec 2024 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QelsXKaS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C920B20CCD5
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 16:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733330433; cv=none; b=rMxPHjW4TWV9WpU2jnnL8E4x34HbF4AoeJVK65pd7BAW9OzFoEYCDO+kjLLfQtjwBoLz9dcoYjjMDB7m+1q0R5qdiXvlfq6jwvmyiSxBWQriwexYG7n3scyIPq1QgIwb/d+QD2zj1QBE00U/une3PVxaCi4DvU0Ldt27i8wTyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733330433; c=relaxed/simple;
	bh=E07o7SrVn6fMgHQ2ye3xvGGrM1Xm8Ed0AWBR9iBbFuE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuTt987EGp7cA+GKOWR7ORgcMFWkRp5DUQT1ZFp/lDqZcT/5SU1kRoXEUV9MitEbaNlRuP6XeckKnzJmCyh36JFxfDqXA2MsFhbmG7wCdhGO/Q2rWjrPu8776vUAbuInGrsOA/oPtmPYennlM7Jc4WkQwim1KW3lfj7DPYFDFTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QelsXKaS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733330429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VEeC3RYjo0ryc9cx1hBsYweGmp9PRkMA7aFXlYOXkWM=;
	b=QelsXKaS6XX7se4l1KQo73xSWxnez2d7LhuAXJp4VCxeubakZFlN7pTXVh1mxMvT3i3bQk
	qjdahc3NOZv3lMl6YQzR7LLHnPZi+uZb3E1qmPheABbGiVLyG4sDzK9YoX+dOHS3UyL3N5
	inCwDyeQoRy2/GW69N1aPuB3+Agff1o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-yQuReqxrNsm1gkdPbPrVrw-1; Wed, 04 Dec 2024 11:40:28 -0500
X-MC-Unique: yQuReqxrNsm1gkdPbPrVrw-1
X-Mimecast-MFC-AGG-ID: yQuReqxrNsm1gkdPbPrVrw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-434a29a93cdso53094935e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 08:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733330427; x=1733935227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VEeC3RYjo0ryc9cx1hBsYweGmp9PRkMA7aFXlYOXkWM=;
        b=E6isQ3RN9sUYnuSnJXYrMOLc8IP4oHSnsaPVfhrHZ+mR1mTJBAX6ahmrlyKyTUuXLB
         gRdYcpWd3PRY1K7sZSkbbENywdw1GsVDb5jSIBwV4O06hcR+tJazm0e0l9pd+543JkM3
         FEnp/akon7J23JEsEvrC1tMmE1TOCmXP4KCDKP/uoNKWG07EaCeOvvL3jfqj9W25RWmE
         zwwdXgow+p0QBUbVxir8Bt4JdyAbMDql72YpU1TwmvX7zJ8A+cRuaEOMQjThv8zR1H2Q
         x0tBhjnNTQafLzv1lxSIPKI7dpzT8uhAhYSaOezZj3pCmcGOLCQb3xhngcSFGGMtLul0
         z7EA==
X-Forwarded-Encrypted: i=1; AJvYcCUkRirTtv6DKu0zWR9+rbGjaLsm77HH39Go+3pJ59qkQn7W1+eYG1BZXFlp1TnFzE8fT28=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5lGrQztNCFTdkGdUsswokVSXe81EifsoEccb5z2LgU3p9n90c
	G+zu/tJLY006mjuTsT5DhrELRaB6QsZDwNWgU8ZHKndS7Hd5dzDf9T8XWuuzNzKzAvEZSVWCGel
	8WgdlkVC6C4asVd68aC029zAN9t96GctTtSk+ThfA/aqNXrZwuQ==
X-Gm-Gg: ASbGnctuTtalrdvkj7pxgyJxBInkeDI9iqNH8YQrm3jM4mFoQFMtbHoB0Lbyks4ZGh9
	iMrW9pzQxA/g0AMlCQTeJ+txwV2M7z8hq2LO6kjzRx2VyRJb6sxB6X3OwjffHFpaw4+mt8CCeKY
	Elv4h8VdqzKvg9SBbv6I+fRPiX/HJbMQAJ8m0OIrlAuCZYiqk7WHfw52f3XaLz6+QvEIvbVbt4C
	S/SM/3MlWUyel+vtvIz8yr1fFWKEXJ6CYY2emCCtedL05ronFWV+Ww91M1353GW5XjDaOcf6qdk
	xTBlSRcTzNIB3Sn8U1j+NQ==
X-Received: by 2002:a05:600c:35cf:b0:431:52b7:a499 with SMTP id 5b1f17b1804b1-434d0a07e76mr56634725e9.20.1733330426904;
        Wed, 04 Dec 2024 08:40:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlmQvivINODRz0LjSbG3GHEmn9Krx7Hqgr3pzwsWlsNg+E/WUPCGldC0NDYZMcYKm+/x0RRg==
X-Received: by 2002:a05:600c:35cf:b0:431:52b7:a499 with SMTP id 5b1f17b1804b1-434d0a07e76mr56634495e9.20.1733330426521;
        Wed, 04 Dec 2024 08:40:26 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d52cbd42sm29861995e9.38.2024.12.04.08.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 08:40:26 -0800 (PST)
Date: Wed, 4 Dec 2024 17:40:25 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Shiju Jose
 <shiju.jose@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>, Ani Sinha
 <anisinha@redhat.com>, Dongjiu Geng <gengdongjiu1@gmail.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org
Subject: Re: [PATCH v5 10/16] acpi/ghes: better name GHES memory error
 function
Message-ID: <20241204174025.52e3756a@imammedo.users.ipa.redhat.com>
In-Reply-To: <1f16080ef9848dacb207ffdbb2716b1c928d8fad.1733297707.git.mchehab+huawei@kernel.org>
References: <cover.1733297707.git.mchehab+huawei@kernel.org>
	<1f16080ef9848dacb207ffdbb2716b1c928d8fad.1733297707.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Dec 2024 08:41:18 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> The current function used to generate GHES data is specific for
> memory errors. Give a better name for it, as we now have a generic
> function as well.
> 
> Reviewed-by: Igor Mammedov <imammedo@redhat.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

not that it matters but for FYI
Sign off of author goes 1st and then after it other tags
that were added later

> ---
>  hw/acpi/ghes-stub.c    | 2 +-
>  hw/acpi/ghes.c         | 2 +-
>  include/hw/acpi/ghes.h | 4 ++--
>  target/arm/kvm.c       | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
> index 2b64cbd2819a..7cec1812dad9 100644
> --- a/hw/acpi/ghes-stub.c
> +++ b/hw/acpi/ghes-stub.c
> @@ -11,7 +11,7 @@
>  #include "qemu/osdep.h"
>  #include "hw/acpi/ghes.h"
>  
> -int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
> +int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
>  {
>      return -1;
>  }
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index 4b5332f8c667..414a4a1ee00e 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -415,7 +415,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>      return;
>  }
>  
> -int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
> +int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
>  {
>      /* Memory Error Section Type */
>      const uint8_t guid[] =
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index 8859346af51a..21666a4bcc8b 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -74,15 +74,15 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
>                       const char *oem_id, const char *oem_table_id);
>  void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
>                            GArray *hardware_errors);
> +int acpi_ghes_memory_errors(uint16_t source_id, uint64_t error_physical_addr);
>  void ghes_record_cper_errors(const void *cper, size_t len,
>                               uint16_t source_id, Error **errp);
> -int acpi_ghes_record_errors(uint16_t source_id, uint64_t error_physical_addr);
>  
>  /**
>   * acpi_ghes_present: Report whether ACPI GHES table is present
>   *
>   * Returns: true if the system has an ACPI GHES table and it is
> - * safe to call acpi_ghes_record_errors() to record a memory error.
> + * safe to call acpi_ghes_memory_errors() to record a memory error.
>   */
>  bool acpi_ghes_present(void);
>  #endif
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 7b6812c0de2e..b4260467f8b9 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -2387,7 +2387,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>               */
>              if (code == BUS_MCEERR_AR) {
>                  kvm_cpu_synchronize_state(c);
> -                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
> +                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
>                      kvm_inject_arm_sea(c);
>                  } else {
>                      error_report("failed to record the error");


