Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA95D5B0687
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 16:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiIGO2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 10:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiIGO2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 10:28:17 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0124A5FAC
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 07:27:53 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c2so14736146plo.3
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 07:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9XYS+Kgfb1igJPu9ypOIGlz79nZqVIH51hI/0E5X5eM=;
        b=Bv3u2O5q2uJVe3HgYKCpkwW3hIjKkeJnM85rvsLdQhPO4kzJKsS9ham5jES+6lG9td
         gfZTWjCH/qAqSa/tqaQb0OgjHGOrc531I5mAGHtbGRAavJjsweH8RmfDycY9cyKLX3mi
         Tz+Dw0CBx5MoMq+fIGFMbRB4Lc3E8G9I7Oa5hmiUGMwRk7nakoNIhy+NKV2ZADTH7NP/
         oi2FsUDJWn8JUZuk3Pa1R6ozwniM48YqAv9Khd+Q5o94178YHFzvvX0FkvZH46dNofGA
         EWzHAk2tPugmr4DjqSBo3GcPjNpGAozoBqHiZZieYDxyfbeho8CKNYUa7rir8gjGfxIh
         VQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9XYS+Kgfb1igJPu9ypOIGlz79nZqVIH51hI/0E5X5eM=;
        b=2wesY5yiQQ8IKi4unjnCMogVvGZzR4uKmBfatTMbteHaEKmCWo9or9ic7h085RWqlU
         95BkZW6nk9T2IJN2BDypisLe62gFn3iZufzDj0cOtOoMguBziMkrMJWGzqBNQa+duic/
         cUWlfLCCQeRVLpXdEAo5qlvdyNcLUtWcPzxFGL1qWsRIW/Zoi5KmhWw+1qjfWH0xnfHU
         plFxohO9WqYwoo4hkBg75WkDaNheJmbHPEZGmZb4GuzCZmXhuhywJMSqX6AxwjAItkNk
         HuSGBc8FeSIhqKLcLnn6iv0VIzo38Oymvyf5A9g6qIWOc+aqhnVnlyJfBD7xEDhr59Xp
         wfnA==
X-Gm-Message-State: ACgBeo1Dy+eW4aJtq037fSRfnuUJrkBYFfh2Hmtalo9iMblCzFDxL981
        xBPpz3qMYzA8T/LBxtJoOw1jpQ==
X-Google-Smtp-Source: AA6agR7c6O5T5fX9brggCj/jzZQi8hBuMiaraeBpsDLiQih1cZLOe/O5Rs1LqPfhJa/psb1gkAYOHw==
X-Received: by 2002:a17:902:bc44:b0:176:909f:f636 with SMTP id t4-20020a170902bc4400b00176909ff636mr3883717plz.21.1662560821442;
        Wed, 07 Sep 2022 07:27:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a3-20020a621a03000000b0053e7495a395sm1721141pfa.122.2022.09.07.07.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 07:27:01 -0700 (PDT)
Date:   Wed, 7 Sep 2022 14:26:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: add missing update to max_mmu_rmap_size
Message-ID: <YxiqMbQlZJqxzu2q@google.com>
References: <20220907080657.42898-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907080657.42898-1-linmiaohe@huawei.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022, Miaohe Lin wrote:
> The update to statistic max_mmu_rmap_size is unintentionally removed by
> commit 4293ddb788c1 ("KVM: x86/mmu: Remove redundant spte present check
> in mmu_set_spte"). Add missing update to it or max_mmu_rmap_size will
> always be nonsensical 0.
> 
> Fixes: 4293ddb788c1 ("KVM: x86/mmu: Remove redundant spte present check in mmu_set_spte")

For anyone else wondering "how did so many reviewers miss this obvious bug?", the
answer is that the reviews were collected for v3 and earlier, and the mishandled
merge conflict only showed up in v4.

> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>


Paolo, do you want to grab this for 6.0?
