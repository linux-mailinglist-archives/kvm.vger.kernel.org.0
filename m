Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0E610F39
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 13:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiJ1K7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiJ1K7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:59:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330981A1B3C
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666954697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XrUtE6ZNOyWMMDqaj6d2QYbvzqtncJzWhL/jOAoTugc=;
        b=HOg8ABocUFDZYJJ2N9u1pnMG7YTGkDnUx/rs/HXwtPVaGUT8a347urAulnfA+JM+gKsuBL
        CoWHH4nJZTj13IPKscbgnIjGCoNeGh68hXbATYTAM7NHPDSUpQ9pP+BmvH3km7W+9DN/IR
        q1Qsob7KGcHAiZWqR2sFC76IsylyeQM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-4YM2ZKJVNYmEXLvDNPtvxw-1; Fri, 28 Oct 2022 06:58:15 -0400
X-MC-Unique: 4YM2ZKJVNYmEXLvDNPtvxw-1
Received: by mail-wm1-f70.google.com with SMTP id c130-20020a1c3588000000b003b56be513e1so2155188wma.0
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XrUtE6ZNOyWMMDqaj6d2QYbvzqtncJzWhL/jOAoTugc=;
        b=mDDkrFYeCJkgqUjVBtwsU3Ry8sHoP6GJSFjbavd8Ntfja4bqXKAUebOkv3mAhWJWgK
         hs214P+EEH0gvvA4s74p5pZTxiXE4oQkTw/3hXoFN6WHyV2/J4vBRmXWb5Ob9CTijXbC
         Edo9x7Kjmhr4YU55w3wWVl1gP+HHqujuU3kanj3seKDdA46ggFUovO7/Q5JhwSTear7l
         NPV98gAGPPQQWmJGzyYunbT4IqtWNsRSV3YiBXvOrQY23kRZy02De5ocIKoXzTKf/jvi
         yJKtjW41mqzaz6CJu6HTta/qhRaXyHfvVXWFZ7itKQFV+MU0U0xV/t390dwZzRv+1+US
         VeDw==
X-Gm-Message-State: ACrzQf3MBWwYa7M7bE/AeyCgx7nPalgw6iKYWRI3tY9oKUqf/ecfh3oL
        iNERVrECUGF4boE1nsvxzYlP8nW/UetZI7y/75wljKdgnJ+1tYfL7prd982TBhEyk8f1dwC3wEF
        wzu6Y0ogBkWCp
X-Received: by 2002:a5d:58ca:0:b0:236:2324:3f0f with SMTP id o10-20020a5d58ca000000b0023623243f0fmr28230590wrf.325.1666954694021;
        Fri, 28 Oct 2022 03:58:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM47D2weYKyvueChMr42f8gZ6fkjKHDRwyD4DciGzhA+navUQcmZNWMLifAqJ2gUIcrRPhZH2w==
X-Received: by 2002:a5d:58ca:0:b0:236:2324:3f0f with SMTP id o10-20020a5d58ca000000b0023623243f0fmr28230575wrf.325.1666954693812;
        Fri, 28 Oct 2022 03:58:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id g10-20020a5d488a000000b0023657e1b97esm3384225wrq.11.2022.10.28.03.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 03:58:13 -0700 (PDT)
Message-ID: <7314b8f3-0bda-e52d-1134-02387815a6f8@redhat.com>
Date:   Fri, 28 Oct 2022 12:58:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20221027200316.2221027-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Do not recover NX Huge Pages when dirty
 logging is enabled
In-Reply-To: <20221027200316.2221027-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/22 22:03, David Matlack wrote:
> This series turns off the NX Huge Page recovery worker when any memslot
> has dirty logging enabled. This avoids theoretical performance problems
> and reduces the CPU usage of NX Huge Pages when a VM is in the pre-copy
> phase of a Live Migration.
> 
> Tested manually and ran all selftests.
> 
> David Matlack (2):
>    KVM: Keep track of the number of memslots with dirty logging enabled
>    KVM: x86/mmu: Do not recover NX Huge Pages when dirty logging is
>      enabled
> 
>   arch/x86/kvm/mmu/mmu.c   |  8 ++++++++
>   include/linux/kvm_host.h |  2 ++
>   virt/kvm/kvm_main.c      | 10 ++++++++++
>   3 files changed, 20 insertions(+)
> 
> 
> base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354

This can be a bit problematic because for example you could have dirty 
logging enabled only for a framebuffer or similar.  In this case the 
memory being logged will not be the same as the one that is NX-split.

Perhaps we can take advantage of eager page splitting, that is you can 
add a bool to kvm_mmu_page that is set by shadow_mmu_get_sp_for_split 
and tdp_mmu_alloc_sp_for_split (or a similar place)?

Paolo

