Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5681573BA
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 12:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgBJLzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 06:55:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726950AbgBJLzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 06:55:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581335703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5fRRVx0DJWeJMvbVzSZZKp0ZVcvinA5K0CU+SmJ64iI=;
        b=LP7kRQCIQMsX9KnSG35grYdqmAxgHcaLNpY3nikZWAggf8dR9ATK0aDS4+KVAtozB5xeja
        X8wg38FRkNg6Jd+EKHTdYnQ4UcPnaKgbJ1qEZPeHCPRVyoUIQe2RJmnfyaE6qAQyn5wgfS
        Kw4KTI4/FsvIo27GqkU45pHjh8i0Vos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-Bfp89bI3PsKeBDGVxR0OtQ-1; Mon, 10 Feb 2020 06:55:01 -0500
X-MC-Unique: Bfp89bI3PsKeBDGVxR0OtQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EB0B1005510;
        Mon, 10 Feb 2020 11:54:59 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAB2091820;
        Mon, 10 Feb 2020 11:54:54 +0000 (UTC)
Date:   Mon, 10 Feb 2020 12:54:52 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 03/35] s390/protvirt: introduce host side setup
Message-ID: <20200210125452.7f66706d.cohuck@redhat.com>
In-Reply-To: <20200207113958.7320-4-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-4-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Feb 2020 06:39:26 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Add "prot_virt" command line option which controls if the kernel
> protected VMs support is enabled at early boot time. This has to be
> done early, because it needs large amounts of memory and will disable
> some features like STP time sync for the lpar.
> 
> Extend ultravisor info definitions and expose it via uv_info struct
> filled in during startup.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  5 ++
>  arch/s390/boot/Makefile                       |  2 +-
>  arch/s390/boot/uv.c                           | 21 +++++++-
>  arch/s390/include/asm/uv.h                    | 46 +++++++++++++++--
>  arch/s390/kernel/Makefile                     |  1 +
>  arch/s390/kernel/setup.c                      |  4 --
>  arch/s390/kernel/uv.c                         | 49 +++++++++++++++++++
>  7 files changed, 119 insertions(+), 9 deletions(-)
>  create mode 100644 arch/s390/kernel/uv.c

(...)

> diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
> index e2c47d3a1c89..30f1811540c5 100644
> --- a/arch/s390/boot/Makefile
> +++ b/arch/s390/boot/Makefile
> @@ -37,7 +37,7 @@ CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
>  obj-y	:= head.o als.o startup.o mem_detect.o ipl_parm.o ipl_report.o
>  obj-y	+= string.o ebcdic.o sclp_early_core.o mem.o ipl_vmparm.o cmdline.o
>  obj-y	+= version.o pgm_check_info.o ctype.o text_dma.o
> -obj-$(CONFIG_PROTECTED_VIRTUALIZATION_GUEST)	+= uv.o
> +obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o

I'm wondering why you're checking CONFIG_PGSTE here...

>  obj-$(CONFIG_RELOCATABLE)	+= machine_kexec_reloc.o
>  obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
>  targets	:= bzImage startup.a section_cmp.boot.data section_cmp.boot.preserved.data $(obj-y)
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index ed007f4a6444..af9e1cc93c68 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -3,7 +3,13 @@
>  #include <asm/facility.h>
>  #include <asm/sections.h>
>  
> +/* will be used in arch/s390/kernel/uv.c */
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  int __bootdata_preserved(prot_virt_guest);
> +#endif
> +#if IS_ENABLED(CONFIG_KVM)

...and CONFIG_KVM here and below?

> +struct uv_info __bootdata_preserved(uv_info);
> +#endif
>  
>  void uv_query_info(void)
>  {

(...)

> +static int __init prot_virt_setup(char *val)
> +{
> +	bool enabled;
> +	int rc;
> +
> +	rc = kstrtobool(val, &enabled);
> +	if (!rc && enabled)
> +		prot_virt_host = 1;
> +
> +	if (is_prot_virt_guest() && prot_virt_host) {
> +		prot_virt_host = 0;
> +		pr_info("Running as protected virtualization guest.");
> +	}
> +
> +	if (prot_virt_host && !test_facility(158)) {
> +		prot_virt_host = 0;
> +		pr_info("The ultravisor call facility is not available.");
> +	}

What about prefixing these two with 'prot_virt:'? It seems the name is
settled now?

> +
> +	return rc;
> +}
> +early_param("prot_virt", prot_virt_setup);
> +#endif

