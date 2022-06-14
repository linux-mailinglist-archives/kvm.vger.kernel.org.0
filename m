Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5FB54AAE8
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 09:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354831AbiFNHsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 03:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354726AbiFNHso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 03:48:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 036933EA9E
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 00:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655192922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pA9hWNFeXf3Ws8HBvV+hgwjcVRJHqFaY7TkNSW+q34Y=;
        b=QoobN0GnxeZh/4xkqay/0DTuao72eWYj302PvKS2o4siM4rNHiw8jfkBLqk5xwAzhifz2M
        2tLBZKdhjMqTzA3+KO5Q7SltIpThQFCWUDgEZR+71dQyBe3jpKPzPjBfK5DMxPaUTv6Bih
        MTcLw+AMNyt8LzppzNgP7IOwPQj9p90=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-Y2mdwCPsPVeTpRNEa9R4PA-1; Tue, 14 Jun 2022 03:48:40 -0400
X-MC-Unique: Y2mdwCPsPVeTpRNEa9R4PA-1
Received: by mail-ej1-f72.google.com with SMTP id nb10-20020a1709071c8a00b006e8f89863ceso2525039ejc.18
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 00:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pA9hWNFeXf3Ws8HBvV+hgwjcVRJHqFaY7TkNSW+q34Y=;
        b=UWcHHs3iDTuuTcTRWBHLdOm4xH/C2BWVQ3z7i5WFrd+hKPas8Miv8kcIN6wPMC5mlX
         qdph6ua/YqX1k1tJBaUbBHadHz3/fK7/F6iQzeY25MxNMRhCx70epXGNfBqVZvxsyDn+
         Jc8kvXCtw3pgKu/FM/qVSrlI3PDtW/UrdCFItwIRc7c6x3lp4PGFWZPCFGooqgjTLmeG
         84wcV0fhuIiD/0QsVa5Meen23yLD3Z1J77AiAtuHDbsBbj5hrsdeRd5DuSf8+I9XRcKL
         S5LKmMEPEa9SGd8qSYViiwEBvMRWlxSFlujCdVzvclhoLK3PmbbuNrYNJV6pJXLT4ZXG
         I+Ow==
X-Gm-Message-State: AJIora9JFDfGFcoNT0wzFu4dkrmjWa51NtKpVHlXT0Ojtn0YPljKRGPP
        NhD38FWCCYjdwUaLcLxgIWRKA7kDy/N8AQgGEZN5UgllsvWpuEnS9met/pwpyXW/dbKKnHXIfgR
        Dk8Q8pP61W5UJ
X-Received: by 2002:a05:6402:5384:b0:431:6d84:b451 with SMTP id ew4-20020a056402538400b004316d84b451mr4299286edb.46.1655192918268;
        Tue, 14 Jun 2022 00:48:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzP9bNFT/YiQLWZHW1O9vZ21ws6w7/jitcSKem//QoUBDC+1oG4tlyeyJ5BHfZ4fUU8Wr3ZaQ==
X-Received: by 2002:a05:6402:5384:b0:431:6d84:b451 with SMTP id ew4-20020a056402538400b004316d84b451mr4299270edb.46.1655192918087;
        Tue, 14 Jun 2022 00:48:38 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id y18-20020aa7ce92000000b0042dc882c823sm6586576edv.70.2022.06.14.00.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 00:48:37 -0700 (PDT)
Date:   Tue, 14 Jun 2022 09:48:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     shaoqin.huang@intel.com
Cc:     pbonzini@redhat.com, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Peter Gonda <pgonda@google.com>,
        David Dunn <daviddunn@google.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Remove the mismatched parameter comments
Message-ID: <20220614074835.qto55feu74ionlh5@gator>
References: <20220614224126.211054-1-shaoqin.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614224126.211054-1-shaoqin.huang@intel.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 04:41:19PM -0600, shaoqin.huang@intel.com wrote:
> From: Shaoqin Huang <shaoqin.huang@intel.com>
> 
> There are some parameter being removed in function but the parameter
> comments still exist, so remove them.
> 
> Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1665a220abcb..58fdc82b20f4 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1336,8 +1336,6 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
>   *   vm - Virtual Machine
>   *   sz - Size in bytes
>   *   vaddr_min - Minimum starting virtual address
> - *   data_memslot - Memory region slot for data pages
> - *   pgd_memslot - Memory region slot for new virtual translation tables
>   *
>   * Output Args: None
>   *
> @@ -1423,7 +1421,6 @@ vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
>   *   vaddr - Virtuall address to map
>   *   paddr - VM Physical Address
>   *   npages - The number of pages to map
> - *   pgd_memslot - Memory region slot for new virtual translation tables
>   *
>   * Output Args: None
>   *
> -- 
> 2.30.2
>

Hi Shaoqin,

Please check kvm/queue, the extra parameter comments have already been
removed.

Thanks,
drew 

