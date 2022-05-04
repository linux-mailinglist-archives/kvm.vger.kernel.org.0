Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41F251AECE
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 22:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356626AbiEDUPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 16:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377920AbiEDUPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 16:15:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 523964E3AA
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 13:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651695085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g8w8l8ma28D4DTNwuvPt+cKMYwBDuhQgRyZ4PAYyzes=;
        b=A33hcPEjHag8h6W79qkhpi4OI+0pv6w4jYezTxT78hit4AMqkvOWoVT3nkquFDlovqEQ7L
        qfumsppbXxlwXNAElsvX6JtkFa4j2KenrzHZw0var3Ks0SK18VJ9irZ7voPzXToVUutiQv
        3b4oSWK8f9x/EL0WBMhKGWZL083+jW4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-RUsQUNYPMdCj2lU9jVNeGw-1; Wed, 04 May 2022 16:11:22 -0400
X-MC-Unique: RUsQUNYPMdCj2lU9jVNeGw-1
Received: by mail-io1-f70.google.com with SMTP id d7-20020a0566022d4700b0065aa0c91f27so1663061iow.14
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 13:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g8w8l8ma28D4DTNwuvPt+cKMYwBDuhQgRyZ4PAYyzes=;
        b=pimamT67IxmHZI1ztJqLBWU1bVcE2snx9tcYWs0GzyEmJf7YkadsOEZQvGmjkmCqTD
         9/05Js+erCexVQcJyk7v7qoZPMZJeNkBR9OUpVpO4EACOWfupj3eMkRcwXFPI1U9oe68
         tCeBpa0FgLKkE6N2S3jc7LQR7WcsNFcIi6rsJ7GRuN5lBvekqDCT8HsVDad6yTpqCwyw
         r7P3eE6lTymaxbgWJ+4rCmlUJW+3vusHdH1mK/UO9/0WvhJIM4mr40UgtlWdvCXHClFc
         J4blzwkALn2GaW7z76hLEGtsgtQ5PwDESrZUYvq30YiIHzyADbtNJQh/73dfMHwEfIiU
         Hixg==
X-Gm-Message-State: AOAM530RJkUFEpAGOrGu1E+Ml52yEHsNaHdu2DTjrHBt7NNlygdZ+8Pw
        fGTfTDCcSfeMy7zWh9IwVI/NalgWRnoZVgnsML1YTTidrOAgPhIHZIZqPj4i0fK8xSDGDbtz7aH
        kqy45vRy6qIUI
X-Received: by 2002:a6b:7845:0:b0:64c:9acc:9f1a with SMTP id h5-20020a6b7845000000b0064c9acc9f1amr8823463iop.103.1651695080508;
        Wed, 04 May 2022 13:11:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXxJw8HskfKMhb2KmHeGVSapHKE///TS2gM+2yR+mKxK0u2oG3LMHfrNfO5rQ1xcrxh7e6RA==
X-Received: by 2002:a6b:7845:0:b0:64c:9acc:9f1a with SMTP id h5-20020a6b7845000000b0064c9acc9f1amr8823452iop.103.1651695080319;
        Wed, 04 May 2022 13:11:20 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id q19-20020a0566380ed300b0032b3a78179csm4960800jas.96.2022.05.04.13.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 13:11:20 -0700 (PDT)
Date:   Wed, 4 May 2022 16:11:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit
 support
Message-ID: <YnLd5b3GssL0l/uE@xz-m1.local>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
 <20220428211351.3897-5-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220428211351.3897-5-joao.m.martins@oracle.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Joao,

On Thu, Apr 28, 2022 at 10:13:45PM +0100, Joao Martins wrote:
> +/* Get the content of a spte located in @base_addr[@index] */
> +static uint64_t vtd_set_slpte(dma_addr_t base_addr, uint32_t index,
> +                              uint64_t slpte)
> +{
> +
> +    if (dma_memory_write(&address_space_memory,
> +                         base_addr + index * sizeof(slpte), &slpte,
> +                         sizeof(slpte), MEMTXATTRS_UNSPECIFIED)) {
> +        slpte = (uint64_t)-1;
> +        return slpte;
> +    }
> +
> +    return vtd_get_slpte(base_addr, index);
> +}

Could I ask when the write succeeded, why need to read slpte again?

Thanks,

-- 
Peter Xu

