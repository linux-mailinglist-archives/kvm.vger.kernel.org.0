Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5661754B758
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbiFNRIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 13:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347448AbiFNRIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 13:08:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D79B51E3C2
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655226513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=arExzYcJh6coYBGryTUDrklEuifMUMl6IcPdTTiqMP4=;
        b=P85PoWEnlwqZr6SYGXwRmqT3XDYIBhA8MaHcjGKg3ttI2XXNJROlBWC+vfFQlufu/sLyZ9
        KKVRH9tVTs5/peNSGwKCsoc/Q7gdOl7hv67y5YYQi8CW2KG8FXB69uQ6fYAO0v4FMZoToc
        OUC403sJ3C5LncTf3Rdl9sbWfrbooco=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-4dI5qhV6NbaYDOJ-lxSRFA-1; Tue, 14 Jun 2022 13:08:30 -0400
X-MC-Unique: 4dI5qhV6NbaYDOJ-lxSRFA-1
Received: by mail-wm1-f70.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so4069242wmr.0
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=arExzYcJh6coYBGryTUDrklEuifMUMl6IcPdTTiqMP4=;
        b=H0JznXn/XWKJg7YwypFqrw0+YTtFUnRCsCKhvla4N5TVIzoZucFiktTAtpxGQglC5U
         GQsj53ab9FZWYLveuw/dgneE833fFqq1ovDSkr7UgbPACgRAva4/daHCDgUlT0K9FUyV
         PlXj2hWJ2OiznI49N9HZ75dzHkIHs/1FtPjlvXRc/FQJEsjqe+lA/Phxso5CrRn5/3YV
         fyMPewouWUTB21BEhby8O93cjHiWTfRLnN4UqZOiJmqL6KlDzFlimSm7GhUaSS18SPgf
         C9oIR/k8AALqix17nyJ1vaSJPLE5S4DOpu/WdqChmQ/tsCZaXHBojuTQFRw49eD5W1ep
         S53w==
X-Gm-Message-State: AOAM532oCg5f1usMZFstS8yVGOsrvhYPeBhgMT1kIy1MjtJ+WF/kGwPA
        ZJ+MoS7qW2nv5/4876FakihbXKt45GRZYDdjKRN//JELaZ+BSWtTplFbROjeI253PKZ+y0KSJGa
        pKxttPNAYP2PV
X-Received: by 2002:a05:600c:3c8f:b0:39b:808c:b5cb with SMTP id bg15-20020a05600c3c8f00b0039b808cb5cbmr5233759wmb.11.1655226508817;
        Tue, 14 Jun 2022 10:08:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfulXSgkHcoNVhCpVUCALcchmTfsuX5OOOyVvW4iK4zOt/EXcjhLh+v88uAeKhN5Ss7V1otw==
X-Received: by 2002:a05:600c:3c8f:b0:39b:808c:b5cb with SMTP id bg15-20020a05600c3c8f00b0039b808cb5cbmr5233737wmb.11.1655226508556;
        Tue, 14 Jun 2022 10:08:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id e15-20020adfe38f000000b0020fd392df33sm12241754wrm.29.2022.06.14.10.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 10:08:27 -0700 (PDT)
Message-ID: <6e602ced-a19f-0691-0cda-553dad46a130@redhat.com>
Date:   Tue, 14 Jun 2022 19:08:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] KVM: selftests: Remove the mismatched parameter comments
Content-Language: en-US
To:     shaoqin.huang@intel.com
Cc:     Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Peter Gonda <pgonda@google.com>,
        David Dunn <daviddunn@google.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220614224126.211054-1-shaoqin.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220614224126.211054-1-shaoqin.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/22 00:41, shaoqin.huang@intel.com wrote:
> From: Shaoqin Huang <shaoqin.huang@intel.com>
> 
> There are some parameter being removed in function but the parameter
> comments still exist, so remove them.
> 
> Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
> ---
>   tools/testing/selftests/kvm/lib/kvm_util.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1665a220abcb..58fdc82b20f4 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1336,8 +1336,6 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
>    *   vm - Virtual Machine
>    *   sz - Size in bytes
>    *   vaddr_min - Minimum starting virtual address
> - *   data_memslot - Memory region slot for data pages
> - *   pgd_memslot - Memory region slot for new virtual translation tables
>    *
>    * Output Args: None
>    *
> @@ -1423,7 +1421,6 @@ vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
>    *   vaddr - Virtuall address to map
>    *   paddr - VM Physical Address
>    *   npages - The number of pages to map
> - *   pgd_memslot - Memory region slot for new virtual translation tables
>    *
>    * Output Args: None
>    *

Queued, thanks!

Paolo

