Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AFF613D50
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiJaS2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiJaS20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:28:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54C7120B6
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:28:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso16662051pjg.5
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vz6yiApS1co9RvG/8mi0KCN4CFmc6c0fRULo+xpV8Mo=;
        b=NKAd0H011FWuuNptQfpVe6E/Am0wjkRwwuo/j58WN5RcBiwNu1p1oXOEkLfy9QCYHY
         LKRqFGYDNfn0CGnXlpOCp6BEpotaj9SBp1HEWZAzPjiv0bCgX7tgIbnO5aumEjXX48eF
         r5OJMwrFsNus826EVmVHTf0IcU2KYJa7NbjPSGBBxL+1ZS1H0qNmP9wcKX+i+4UgoGKg
         qQ6IwUDIOt32f9JQuLZpCAWqnBk30h8PjSP2i7jurh36JAIMVdrTNXQrhpL8eKTUIEWW
         E7dQJvRQ3mkZ5Wrse4YyvfEz4Q9ULFgA4fsHrdyPAPp9Yc4N67xR8VhK+QwHSnnlhfw6
         RQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vz6yiApS1co9RvG/8mi0KCN4CFmc6c0fRULo+xpV8Mo=;
        b=3nCpYMbZcejI77DBsEtQ5ud5Qx26hk3p8RKB7pdS6Na/HUQPHp//bwwQmmUkUh1543
         bmLVTU4Kx2FZwRczivX78pYYfM+zroxhEm8SF3ajzMtZ/+nWcQL+tKN0A4YJwu6Mu6LG
         PhAQk5GBzgdcwvqSut6uiOdzMJBpYGaJRukFL6el12h9RcJK98geEB+UPrvzZ1XGtDns
         ZDGqUcehj7IXmhp8LB8arKOk1BmdzARnE0TofOQF7cq7WqhBC/ytKPI50UmVpcu9Vbz+
         4Kl/Jv/wmh/auyzh1K1c+1gGgrj4G5gXdiL194RCmYLDkM8yeLPEkS2JzZcO/PTcbcA6
         sbeg==
X-Gm-Message-State: ACrzQf1Ut5B6CpWeeLKA6auYQM35yxbDesBHEaIoMr5JM01eumYQg1By
        T724zlQtimUiOC7fMQlJZNugHg==
X-Google-Smtp-Source: AMsMyM7BKAhuXKWt31cWYKYMgAF/H9OewsNJD9XdT5HS9VdT2w0Qggs3h/SX9n5u2UjaQojAVoIoXQ==
X-Received: by 2002:a17:902:ccc4:b0:17c:7cc1:a401 with SMTP id z4-20020a170902ccc400b0017c7cc1a401mr15712856ple.58.1667240903446;
        Mon, 31 Oct 2022 11:28:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m14-20020a63fd4e000000b00460c67afbd5sm4519268pgj.7.2022.10.31.11.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:28:22 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:28:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 06/10] KVM: selftests: Copy KVM PFERR masks into
 selftests
Message-ID: <Y2ATw8BHvi0muiSX@google.com>
References: <20221031180045.3581757-1-dmatlack@google.com>
 <20221031180045.3581757-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180045.3581757-7-dmatlack@google.com>
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

On Mon, Oct 31, 2022, David Matlack wrote:
> Copy KVM's macros for page fault error masks into processor.h so they
> can be used in selftests.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
