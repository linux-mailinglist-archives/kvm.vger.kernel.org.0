Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F77605415
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 01:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiJSXj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 19:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiJSXjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 19:39:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC0C6687F
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:39:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o9-20020a17090a0a0900b0020ad4e758b3so1411400pjo.4
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fKKXbcN44vw0WPAOU5aHRyCNZKKb/gCi94CUSavyllY=;
        b=d5G7DdsLHR5XVPJ76xOc7/0TVfc4rsd1X9piRJFDiUHpDjROsaC2cDHsBrZNYxf4zR
         MWVcWIUbvnn16py2n1dQJvnUrb0rYHLUUW9Ey88iuMspBbHoHDZAxUvN0UFjLWuxd70i
         sU9roJ0KNUnMMKWUCEr5p8o8yCtQvSUpkJicKKkQZmEPQgx40D/EkKkQF32OfcFvBvgx
         MmK7gHn3JKpE0ncXBFGRsAohrBXjIXuFNN4C7P+UWQAt0iwiPOP7u6zBxGGB1/nyqPSE
         08CEJ9BMzmFxFYS2ch08m3vm4ss9cF0UjhyVRTmS3OWQXuusk8PFpPBWzsDv5bJDArbI
         GxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fKKXbcN44vw0WPAOU5aHRyCNZKKb/gCi94CUSavyllY=;
        b=a2w4YjEUK3iBNaILzdpg2gG4vb3t5rAZwkgFm2BDuZMnbVJns7iha9yjxtZcsB87ZZ
         qpaZAmUm7C8qCGPzMWWahnRAbK4hqG+DYXF9xXyVGZFk/XMMu6mtJx/WHQ0EI2ncrLLC
         359q36J1/6AqlDFKBDuneyzMaDc5Q1e2S5ZfJ/ochhK7YfmzhJEh//nx2wvFbd9JUkLG
         RVGernw35UAR2XvW23u5CkjEdUdIIg/kbSci4wLHB1/Z7QMBklrKHYx1A0n13MR83TvL
         YK33QUiaiTRHSHXubBcf47bN65FqPCvBvkbQEldArKnQquSIp2+gMUmbnHhzRflyCe0e
         bDAA==
X-Gm-Message-State: ACrzQf2EzWD/4nxvKgO7dMb7L6gnXLqEt1o16MDV5PW43vdxUM6PXjyB
        pbgiBbc2hj8554gFMOJSnBjr6Q==
X-Google-Smtp-Source: AMsMyM7gO/J7gWZdM++yB65z2vAHOxzDBDvyVdpN8uwu29BRqNmfxxvKTYGZoe397p9alXgi23L8Aw==
X-Received: by 2002:a17:902:ced1:b0:185:4ca4:263f with SMTP id d17-20020a170902ced100b001854ca4263fmr10720122plg.148.1666222789764;
        Wed, 19 Oct 2022 16:39:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n6-20020a17090a2c8600b0020ad46d277bsm454567pjd.42.2022.10.19.16.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:39:48 -0700 (PDT)
Date:   Wed, 19 Oct 2022 23:39:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v10 01/14] KVM: selftests: Add a userfaultfd library
Message-ID: <Y1CKwZG3jBz7mOvj@google.com>
References: <20221017195834.2295901-1-ricarkol@google.com>
 <20221017195834.2295901-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017195834.2295901-2-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022, Ricardo Koller wrote:
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 779ae54f89c4..8e1fe4ffcccd 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -22,23 +22,13 @@
>  #include "test_util.h"
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
> +#include "userfaultfd_util.h"
>  
>  #ifdef __NR_userfaultfd
>  
> -#ifdef PRINT_PER_PAGE_UPDATES
> -#define PER_PAGE_DEBUG(...) printf(__VA_ARGS__)
> -#else
> -#define PER_PAGE_DEBUG(...) _no_printf(__VA_ARGS__)
> -#endif
> -
> -#ifdef PRINT_PER_VCPU_UPDATES
> -#define PER_VCPU_DEBUG(...) printf(__VA_ARGS__)
> -#else
> -#define PER_VCPU_DEBUG(...) _no_printf(__VA_ARGS__)
> -#endif
> -
>  static int nr_vcpus = 1;
>  static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> +
>  static size_t demand_paging_size;
>  static char *guest_data_prototype;
>  
> @@ -67,9 +57,11 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
>  		       ts_diff.tv_sec, ts_diff.tv_nsec);
>  }
>  
> -static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t addr)
> +static int handle_uffd_page_request(int uffd_mode, int uffd,
> +		struct uffd_msg *msg)

Heh, one last alignment goof.
