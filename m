Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F193C895B
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhGNRLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 13:11:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhGNRLR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 13:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626282505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pENw184fACnSZLpy/r2d4M3jJhjg34w0pPVINZ+AW14=;
        b=ZBz6t0B3e3F7vphUSiT8kRibDIGlhL82GK5FbCXFEfy9lcDjbPu2wqieh3spo9hKtMYsTv
        qsYX6Db7DJ0I+9+zMWTpVmFA6i4KxAlZrW5ka8w/UbX7DUyzv3lhar5EAxGhtc1TwMhoZ7
        at2bzxbzcfNZa98eYTvkXUjEPAa3czE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-CQrk3yRjPXu9_Kkrxh87ZA-1; Wed, 14 Jul 2021 13:08:24 -0400
X-MC-Unique: CQrk3yRjPXu9_Kkrxh87ZA-1
Received: by mail-pg1-f198.google.com with SMTP id x9-20020a6541490000b0290222fe6234d6so2171777pgp.14
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 10:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pENw184fACnSZLpy/r2d4M3jJhjg34w0pPVINZ+AW14=;
        b=MQSoDETtd6ybAxkCOB8PlRwmudL0/5XmPZmsEL6LVa8op5KdgK1a+5ANxwIGp7j6R2
         99ocHptyZGJAbY+zTP/JYUtQXe1r8FdMlCqg2fGn+pViYgyRo4E0izg4L/DROu7KFskU
         rG9K2J6GLh/y6C4rr4/TfzLxhzsSQRvFh4B89VJQybjDo8Ny3qdbbzIVjdcTq3E8EHNX
         TK/57dmjH3syWy+oSCGqOF9h+38eN7pPgXlSmcOHFQcryvoOFIovWto4WfEgAmIhCLDb
         bI11qMn2H/yKQeLaC2rrC4clQfG5jknh/Haudbau00cszcU1XwY1ApVdzde/mm8NZ3ef
         2PNg==
X-Gm-Message-State: AOAM532+h4LG5pC9gG8CJNE7l+c0JvmXXhaTn5ZHc/IzFTaaGt8uVaKs
        FzzXDn+Ao+DJzU8LzLNbT4ImXLbguuG9J8e97cDcUuG3eW+53OYYGZL6SAdhDX5FHO3j3lnI1U6
        yx7Wtnhzqd+5u
X-Received: by 2002:a17:902:9a81:b029:121:a348:fa68 with SMTP id w1-20020a1709029a81b0290121a348fa68mr8248794plp.46.1626282503201;
        Wed, 14 Jul 2021 10:08:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziD22Akx0RXbQFalHrdhbWbA4ZDqEMNVz3xQRcoxzgc9J8+rP2Z14fKZBstE/JRve4gyQQaA==
X-Received: by 2002:a17:902:9a81:b029:121:a348:fa68 with SMTP id w1-20020a1709029a81b0290121a348fa68mr8248775plp.46.1626282502945;
        Wed, 14 Jul 2021 10:08:22 -0700 (PDT)
Received: from [192.168.0.18] ([65.129.103.82])
        by smtp.gmail.com with ESMTPSA id 11sm3927643pge.7.2021.07.14.10.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 10:08:22 -0700 (PDT)
Subject: Re: [RFC PATCH 5/6] i386/sev: add support to encrypt BIOS when
 SEV-SNP is enabled
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-6-brijesh.singh@amd.com>
From:   Connor Kuehl <ckuehl@redhat.com>
Message-ID: <3976829d-770e-b9fd-ffa8-2c2f79f3c503@redhat.com>
Date:   Wed, 14 Jul 2021 11:08:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709215550.32496-6-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/9/21 3:55 PM, Brijesh Singh wrote:
> The KVM_SEV_SNP_LAUNCH_UPDATE command is used for encrypting the bios
> image used for booting the SEV-SNP guest.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  target/i386/sev.c        | 33 ++++++++++++++++++++++++++++++++-
>  target/i386/trace-events |  1 +
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 259408a8f1..41dcb084d1 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -883,6 +883,30 @@ out:
>      return ret;
>  }
>  
> +static int
> +sev_snp_launch_update(SevGuestState *sev, uint8_t *addr, uint64_t len, int type)
> +{
> +    int ret, fw_error;
> +    struct kvm_sev_snp_launch_update update = {};
> +
> +    if (!addr || !len) {
> +        return 1;

Should this be a -1? It looks like the caller checks if this function
returns < 0, but doesn't check for res == 1.

Alternatively, invoking error_report might provide more useful
information that the preconditions to this function were violated.

Connor

