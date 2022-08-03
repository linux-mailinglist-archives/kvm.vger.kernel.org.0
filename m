Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9EB5890D7
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 18:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbiHCQxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 12:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbiHCQxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 12:53:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A663FA2F
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 09:53:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so2727144pjf.2
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 09:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=4Tus1R0xuYRBtU57ePhS4E0yErBE8jqpbyDcNdaMSVs=;
        b=hOAAnwWYgICjdTGqOw5garJoe78sf1ZPhQp/JtblQa1n8WVvtl1Fg/5jWqoeYo+rV6
         7IfjUmYUrRJxxpVkbn6d6UqnIwUQF5h+dTk9ur292aTyc3sqiAWEaEKgtiA3adPZmThc
         Ehdvbzz0F2xF6f1w74818d4nrbakcb+oJf8WVILrmoeGG6YWj5cyxlo59sXgwRAcDgcr
         o3l21zBhmUQYo/J09tb7tT0p92hNAebXF4z9EW3tCROG+TB0AQ9ljtAyoMIa2tTGv29k
         sCC9GynpxgwcvxRd6jkW8LT9FUX/kthjaOzCWdWvOuOyVMCKT87QcHxQ9jWr7T2/c74f
         6iZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=4Tus1R0xuYRBtU57ePhS4E0yErBE8jqpbyDcNdaMSVs=;
        b=WL+XX2QpTk8s7IPpfLyQEymznlqv/izcf52C7sk7upUl+dgd0WQ2391yHZRKSJIcTo
         9uFYXI1GetWlbTwvKB7aRFtIThFr0X/cV1ce0yyu6aXq4+/Bgu0wZCzm1udHKUK/r2vW
         Y9PfXcarHdqdlHDExgq4n3ooY1JDCJPN+SgvnCEwaY0aV9Za05p6Q4sxRqM54ECx8pzD
         8eTCcKclzFQXM9S2pBQVCYn/C78M7b1YFjReS40gMRbsnplPmoiQ3xexNyqGCJKwIw9Q
         g0azsuRlusxIpKebesdYQD1aHPj5JOoEAvSmlIrK2BQR83DyDknm3TvNGsf//R+qkQQ7
         WXZg==
X-Gm-Message-State: ACgBeo2jbHL8JF86D0T0aF3vMDNqlnGAoeK3D6OSYazkwHH5WnH12Nhf
        wfUz75Et9t3Gyn4y21IZFI0aZQ==
X-Google-Smtp-Source: AA6agR7kWU1ywQmU447El8WR3xMws9kT7tW9gC1cfIkjl3e897HcALT+8//M66UiFUkC7BWWKnEm0Q==
X-Received: by 2002:a17:903:1d2:b0:16f:1664:dd3b with SMTP id e18-20020a17090301d200b0016f1664dd3bmr3275358plh.60.1659545593573;
        Wed, 03 Aug 2022 09:53:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 145-20020a621497000000b00527dba9e37bsm13168880pfu.73.2022.08.03.09.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:53:13 -0700 (PDT)
Date:   Wed, 3 Aug 2022 16:53:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 2/2] kvm: nVMX: add tracepoint for kvm:kvm_nested_vmrun
Message-ID: <Yuqn9QFA6ycHXgJx@google.com>
References: <20220718171333.1321831-1-mizhang@google.com>
 <20220718171333.1321831-3-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718171333.1321831-3-mizhang@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capitalize KVM in the shortlog, i.e. "KVM: nVMX:".

On Mon, Jul 18, 2022, Mingwei Zhang wrote:
> From: David Matlack <dmatlack@google.com>
> 
> This tracepoint is called by nested SVM during emulated VMRUN. Call
> also during emulated VMLAUNCH and VMRESUME in nested VMX.

Please reword this so it's a more coherent statement of what the patch does, e.g.

  Call trace_kvm_nested_vmenter() during nested VMLAUNCH/VMRESUME to
  bring parity with nSVM's usage of the tracepoint during nested VMRUN.
