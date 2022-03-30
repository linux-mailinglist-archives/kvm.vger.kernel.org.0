Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4E34EC7AF
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 17:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347745AbiC3PEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 11:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346246AbiC3PEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 11:04:45 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7C2657BF;
        Wed, 30 Mar 2022 08:03:00 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id z16so18948393pfh.3;
        Wed, 30 Mar 2022 08:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=0MBVxiaFywM4pu0z4oSgGZuG1yRrtK/NM7ZzynJsPqs=;
        b=mAvL3DNgMxVPREzhXaFeaZCJ6SVPQ+W6KvhjSCLUsOEPVc80aU60ecGUmz5hZeqQSt
         bXCZ0PIAYCrM9FtK7uup3fwK4i06fuQNZudaN2n82Ttt4w7RwwwDS8LHq05xD0pBQnb+
         9gj270uiZEof/V3yFjWiam+pg3TsQp3d9k/7hS05LnS05uBCC6meQb6+/Mr4TNApzCog
         nKMj1gJ3T1YRI9SWOazIxV1VU3wDWdyHyguAVeKzcAeQwTEuTQ3PTt1jgbsUskfINpdv
         NKyCrAEauGpMfhDsw0c3f7dwp2Jor6sJsjQ5ueMIKPzf4gFt2NcZCRc+oY2YJtwb/Fi6
         7oqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=0MBVxiaFywM4pu0z4oSgGZuG1yRrtK/NM7ZzynJsPqs=;
        b=sRyMv5IjnyZCi/X3Ix+3L6xR4ifmMsg7DLkBYxv23ItqiIPbiPGrUznqyAPoncx1BO
         HXAmlPEPC577T9Is0oBDlpjyQ23cWWL0JKHetjI8AkRufUVYFkp9L2Pzv7fs3C6IrzM7
         5xFLbnamcREQHQh0GxMbpMShky2OjSOwFYyXj/nHHx5LkNVn3PbZDifLXfZvyKzQMYYm
         OY/PqMk1RnBc+C9Q6QoERh+A3qqUHLIx91UD6U7UFZf63ZcEcX2k224WJl08bwcbQfA+
         qLGlOTdBTryqYHwRBtEOp2Qt5NptOUOnTStcRtFA988dMuvWke9yfzYA5Xsbu1ZnNYWU
         xytw==
X-Gm-Message-State: AOAM530szbMr/2nRhn0D2T9YAo/9Zlz30dbKeaVpmzQ8aPhKRFC/j3zC
        jmwAESgV52Kpkqccco58bXc=
X-Google-Smtp-Source: ABdhPJzlWyEeJUhUtrp7faglokIfFffPYkbsvRd8O9FRMCJ/TXHpsn1idVEWlRM6wEmqxz2+UoPQzA==
X-Received: by 2002:a63:dd0a:0:b0:378:4b73:5b3b with SMTP id t10-20020a63dd0a000000b003784b735b3bmr6456622pgg.564.1648652580087;
        Wed, 30 Mar 2022 08:03:00 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id ip1-20020a17090b314100b001c7b10fe359sm7235305pjb.5.2022.03.30.08.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 08:02:59 -0700 (PDT)
Message-ID: <ee0892bb-ba1e-251d-8e19-ac26b4c0799d@gmail.com>
Date:   Wed, 30 Mar 2022 23:02:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3.1 0/4] KVM: x86: Use static calls to reduce kvm_pmu_ops
 overhead
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20220329235054.3534728-1-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220329235054.3534728-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/3/2022 7:50 am, Sean Christopherson wrote:
> This is a minor iteration on Like's v3 to allow kvm_pmu_ops (the global
> variable, not the struct) be static.  I ran the PMU unit tests and compiled,
> but otherwise it's untested.  Strongly recommend waiting for Like to give
> a thumbs up before applying :-)

Uh, thank you for picking up this optimization and it passes my test cases.

> 
> [*] https://lore.kernel.org/all/20220307115920.51099-1-likexu@tencent.com
> 
> Like Xu (4):
>    KVM: x86: Move kvm_ops_static_call_update() to x86.c
>    KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
>    KVM: x86: Move .pmu_ops to kvm_x86_init_ops and tag as __initdata
>    KVM: x86: Use static calls to reduce kvm_pmu_ops overhead
> 
>   arch/x86/include/asm/kvm-x86-pmu-ops.h | 31 ++++++++++++
>   arch/x86/include/asm/kvm_host.h        | 17 +------
>   arch/x86/kvm/pmu.c                     | 66 ++++++++++++++++++--------
>   arch/x86/kvm/pmu.h                     |  7 +--
>   arch/x86/kvm/svm/pmu.c                 |  2 +-
>   arch/x86/kvm/svm/svm.c                 |  2 +-
>   arch/x86/kvm/vmx/pmu_intel.c           |  2 +-
>   arch/x86/kvm/vmx/vmx.c                 |  2 +-
>   arch/x86/kvm/x86.c                     | 21 +++++++-
>   9 files changed, 102 insertions(+), 48 deletions(-)
>   create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h
> 
> 
> base-commit: 19164ad08bf668bca4f4bfbaacaa0a47c1b737a6
