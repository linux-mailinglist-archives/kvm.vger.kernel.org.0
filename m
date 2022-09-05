Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367E55AD811
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbiIERHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 13:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237660AbiIERHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 13:07:16 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEEB4BD00;
        Mon,  5 Sep 2022 10:07:15 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id bp20so11651906wrb.9;
        Mon, 05 Sep 2022 10:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=b4juj7B2UONec9DN5R9H+S5J6rQPs3/+0cM2WjUaO5k=;
        b=iFovOR/Wfh1IQeXRIxmdXPrwAhHTKj6ANR+tbCVF6tOoIO+5WWLxzFcbQJEA6ae7iG
         j2bAzv+RS3H65Q2vSIfslGEc7pFaMBEBSoB4gNYi4vfa1mqAqk9n4jnJiNwVZTeJ3CwQ
         rmOcdQocNxHTTv3h4tQuNrT777A4fpGoYrRaT/hx2u+XoFDoCaGGvD8qEXAONOouQ4Dc
         qaQ+jNS2JM3Rb2VAfusoPJ2LxojYuUlbMgzNFFii65oFTYp5r5Yqwd+fghwUjqSh1/YK
         UdWe8qpcsD1HGGP9QKZKdOQwscZRvbOnqjvvdLyQM558WSB4+HZfUYU59MOKT3uzD9tR
         xBiA==
X-Gm-Message-State: ACgBeo1H6VCBes4DG6EQEvevn8qXRkLvupHzD8fyby3tAGvIKdjsebF5
        5B72i59tgXN0Hl+MRThXKPk/1TSGGB4=
X-Google-Smtp-Source: AA6agR54pyDETu2sUWvvNJ9LGzrJCmE5taGD4owhWNoFpkTFhjbzyeLvcU3XR9YDt94/RKUzsbwUZw==
X-Received: by 2002:adf:de01:0:b0:228:62ae:78bc with SMTP id b1-20020adfde01000000b0022862ae78bcmr5547587wrm.41.1662397633989;
        Mon, 05 Sep 2022 10:07:13 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id bp8-20020a5d5a88000000b002252e5a6841sm9412547wrb.57.2022.09.05.10.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:07:13 -0700 (PDT)
Date:   Mon, 5 Sep 2022 17:07:09 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v6 03/33] KVM: x86: Zero out entire Hyper-V CPUID cache
 before processing entries
Message-ID: <20220905170709.dn5zp6wq5vo4cq2c@liuwe-devbox-debian-v2>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
 <20220830133737.1539624-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830133737.1539624-4-vkuznets@redhat.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 03:37:07PM +0200, Vitaly Kuznetsov wrote:
> Wipe the whole 'hv_vcpu->cpuid_cache' with memset() instead of having to
> zero each particular member when the corresponding CPUID entry was not
> found.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> [sean: split to separate patch]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
