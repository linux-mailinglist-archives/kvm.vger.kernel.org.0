Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3D5518314
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 13:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbiECLPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 07:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiECLPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 07:15:10 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A583464A;
        Tue,  3 May 2022 04:11:38 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so1076660wmn.1;
        Tue, 03 May 2022 04:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GsogsT9bhJS0azISfSjF4/Gdtg2bL/l2CaKN/yJOq2U=;
        b=KMTJX39ow68qWmWxgO+TP55iaLnuVRVItcxZCM/jcq0PDeUUkyUlH2Ta5j4TiY67tq
         YyUyAMb3Va1AMjWmF8veGu5qMzZuUjBWGmNXmavS8exzwHLMsfphZzNnHv2ppX2DHFjZ
         wMCFdHKhTnBTJDc+HnHyIg5mAyEKqcGkF1IjVvMxczSXu5Nl194gOsaLXz/yfa8eqPBi
         B//FIZKXozbu4IwJcrJQ4EjqDdaiUPqt0C6ZAyB0frYn6IpTJxD3LnsDjsQGVM0fmCXj
         xtXbsXGZ9QNFMU8E2k/CCy7e3Vr1Sf3p/kRAVjemRTqynn+o+ZwOzfGnuLNBPSchnqqQ
         LkXA==
X-Gm-Message-State: AOAM5309pMk1fKYbLOTgnX3bNOJrvnHBQ21xbEnFeozjTcrWu2epPEk2
        JQ7nHJLhhBeWCp+/+HoX3EM=
X-Google-Smtp-Source: ABdhPJyhUyArLZ6U7eQ4wiMgOJiKkSAK1pVUfdJy3Bn7VLBKr52ZTx0gXisXtzzC4SGwFA0Yn97PTA==
X-Received: by 2002:a1c:770b:0:b0:394:3fae:ab79 with SMTP id t11-20020a1c770b000000b003943faeab79mr2884315wmi.200.1651576297176;
        Tue, 03 May 2022 04:11:37 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id n21-20020a7bc5d5000000b003942a244f47sm1708601wmk.32.2022.05.03.04.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 04:11:36 -0700 (PDT)
Date:   Tue, 3 May 2022 11:11:34 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v3 07/34] x86/hyperv: Introduce
 HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
Message-ID: <20220503111134.zuzidhqfmac2csfm@liuwe-devbox-debian-v2>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-8-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414132013.1588929-8-vkuznets@redhat.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 03:19:46PM +0200, Vitaly Kuznetsov wrote:
> It may not come clear from where the magical '64' value used in
> __cpumask_to_vpset() come from. Moreover, '64' means both the maximum
> sparse bank number as well as the number of vCPUs per bank. Add defines
> to make things clear. These defines are also going to be used by KVM.
> 
> No functional change.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
