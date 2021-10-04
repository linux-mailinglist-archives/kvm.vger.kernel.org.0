Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E1F4208DA
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 11:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhJDJ7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232161AbhJDJ7E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 05:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633341435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uN4kK1pXQZANYm2HaFwo6QaP04q5hMTYTuZqmJHwjTY=;
        b=G0iTypB70q3sflzQM7R+1mHu82+8NPUzaRbBKIDGGD5Zd+6qCAmfSto2O6G0+DTNBt/ooq
        b0/bj+TKaOkFrOVhnfYlGEPfwk4ScDOFFaDnoi+0P2DFDToRGQ74bD7uP3R90yxAKmZK/B
        203JdLSI1//jK9Obw0LAzZh5rBZkzcU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-eFJ9LHKDMB27Jkz0lHxhEQ-1; Mon, 04 Oct 2021 05:57:14 -0400
X-MC-Unique: eFJ9LHKDMB27Jkz0lHxhEQ-1
Received: by mail-wr1-f72.google.com with SMTP id j15-20020a5d564f000000b00160698bf7e9so4447097wrw.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 02:57:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=uN4kK1pXQZANYm2HaFwo6QaP04q5hMTYTuZqmJHwjTY=;
        b=bkYBK/sBGePDs7hadfusgD/OMet7Fxw4oOp6cK8PeZusvfJpZhm9vZ240IOzAD+rfA
         B9EEVnZ1DRF4CRurjbaeR7lxk13zpmKuivihRKs4YX4KO6055Kliwe4SP7kxazcPzaJQ
         QdMieIq4MD+lHNKqtcmEhQc3q6752CCrxYvy2BuXRdUVm0Q4h+MTEI73Zz8BoXIAcmmA
         A6M4zTwO3JFd6JMQzOeFurssaFz0z+tm+V6bLa0vw+7rHjaHyH6Lm+m0c1plbtaR2l61
         HXwcf9DNqbYYOk/u0lpkZKB7BiWP0ghWTHABfFC+1DizVY1PqmQtvcbYJxOHV3ff6zaF
         lASQ==
X-Gm-Message-State: AOAM532A0OhxtsLXI8MhlegiNcbqLAZUQOz7c+Q0Kih8CQODsmFm9PUz
        7p7pjyD26c/DFKwVweWkL99I/IcLI4772vI4e8pCks5YQk1RzA/4xaMPy2F/WRNgheD6BFksjhq
        +7oXsk5r1YcSp
X-Received: by 2002:adf:8b98:: with SMTP id o24mr13372075wra.302.1633341433472;
        Mon, 04 Oct 2021 02:57:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpWd/y8XqYfgDbtRv96Gzc0e4logE1MVVZzrOjkYgjzLmgLB8e4N0CQwcq7o26faMqWhKBmQ==
X-Received: by 2002:adf:8b98:: with SMTP id o24mr13372042wra.302.1633341433218;
        Mon, 04 Oct 2021 02:57:13 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id n186sm16112484wme.31.2021.10.04.02.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:57:12 -0700 (PDT)
Date:   Mon, 4 Oct 2021 10:57:10 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: Re: [PATCH v3 14/22] target/i386/sev: Move
 qmp_query_sev_attestation_report() to sev.c
Message-ID: <YVrP9sGcUNuRuXm6@work-vm>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-15-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211002125317.3418648-15-philmd@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
> Move qmp_query_sev_attestation_report() from monitor.c to sev.c
> and make sev_get_attestation_report() static. We don't need the
> stub anymore, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  target/i386/sev_i386.h        |  2 --
>  target/i386/monitor.c         |  6 ------
>  target/i386/sev-sysemu-stub.c |  7 ++++---
>  target/i386/sev.c             | 12 ++++++++++--
>  4 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 2d9a1a0112e..5f367f78eb7 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -27,8 +27,6 @@
>  extern SevInfo *sev_get_info(void);
>  extern char *sev_get_launch_measurement(void);
>  extern SevCapability *sev_get_capabilities(Error **errp);
> -extern SevAttestationReport *
> -sev_get_attestation_report(const char *mnonce, Error **errp);
>  
>  int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
>  int sev_inject_launch_secret(const char *hdr, const char *secret,
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index a9f85acd473..c05d70252a2 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -764,12 +764,6 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
>      sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
>  }
>  
> -SevAttestationReport *
> -qmp_query_sev_attestation_report(const char *mnonce, Error **errp)
> -{
> -    return sev_get_attestation_report(mnonce, errp);
> -}
> -
>  SGXInfo *qmp_query_sgx(Error **errp)
>  {
>      return sgx_get_info(errp);
> diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
> index d556b4f091f..813b9a6a03b 100644
> --- a/target/i386/sev-sysemu-stub.c
> +++ b/target/i386/sev-sysemu-stub.c
> @@ -13,6 +13,7 @@
>  
>  #include "qemu/osdep.h"
>  #include "qapi/qapi-commands-misc-target.h"
> +#include "qapi/qmp/qerror.h"
>  #include "qapi/error.h"
>  #include "sev_i386.h"
>  
> @@ -52,9 +53,9 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
>      g_assert_not_reached();
>  }
>  
> -SevAttestationReport *sev_get_attestation_report(const char *mnonce,
> -                                                 Error **errp)
> +SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
> +                                                       Error **errp)
>  {
> -    error_setg(errp, "SEV is not available in this QEMU");
> +    error_setg(errp, QERR_UNSUPPORTED);

I did like that message making it clear the reason it was unsupported
was this build, rather than lack of host support or not enabling it.

Dave

>      return NULL;
>  }
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index aefbef4bb63..91a217bbb85 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -31,6 +31,8 @@
>  #include "migration/blocker.h"
>  #include "qom/object.h"
>  #include "monitor/monitor.h"
> +#include "qapi/qapi-commands-misc-target.h"
> +#include "qapi/qmp/qerror.h"
>  #include "exec/confidential-guest-support.h"
>  #include "hw/i386/pc.h"
>  
> @@ -487,8 +489,8 @@ out:
>      return cap;
>  }
>  
> -SevAttestationReport *
> -sev_get_attestation_report(const char *mnonce, Error **errp)
> +static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
> +                                                        Error **errp)
>  {
>      struct kvm_sev_attestation_report input = {};
>      SevAttestationReport *report = NULL;
> @@ -549,6 +551,12 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
>      return report;
>  }
>  
> +SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
> +                                                       Error **errp)
> +{
> +    return sev_get_attestation_report(mnonce, errp);
> +}
> +
>  static int
>  sev_read_file_base64(const char *filename, guchar **data, gsize *len)
>  {
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

