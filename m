Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9735A6F3E
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 23:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiH3VkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 17:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiH3VkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 17:40:08 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F411A0D
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:40:05 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q9so11816739pgq.6
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=18dT9IU9K46+vCA6vJDJVkD21xnS9+e2e1BeowiR1WI=;
        b=HZB6je5dIAHIT8RL35BCbIQQdkkyrQ6gFRb5LDDaooEFcuBFSB3KC/7fUqFuHcMYRK
         OuUODJ0k28eBIFuYlJP9hAnVNTuAu3jjG68e79AK6w1rJhvghv1JybkCaOyuSiC38txK
         xxlpZN+MLNgR23Qx38fe7RU9O5BInBvEizdEQHH+s1sJUncv9JmhtRhZXam15a8+STkx
         eV+ZQpGWgm47xnIl8AaFsUlXKsFOXlPi7sheOJqFgIjMUEEuJumb6s2nVidABYIavD4+
         bp/B6UDs1ZN6QMlfSKoLGgxDHLu4shsSvrW+9PofzPNBSY79xlvNJFEHUdz/RT3ie0Y9
         6KYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=18dT9IU9K46+vCA6vJDJVkD21xnS9+e2e1BeowiR1WI=;
        b=M99dBcLToZeH+9+7ab9DJmoB8bivIJlqm9KMmSq1TjeJSbgdzz34zdpt3O+Wox6Api
         hZovv17lk5z0tCjC5joXw9A4xaxY1lgXzOz/4arEJRpByQfSdVUim9vt7CHPVa67Hanw
         OIOG4MbO4IrNiAWeke8vHvjHtbhq/Z9KNcuP6xxJjT/rMm08olXYQM5h4T4t0QIfIr1K
         hPa4TIVFRTioWEc2cMz0DSgwTG87WaYGcGywFZgRTe3rqFGCiItmI+YfHQOW5CtjJ1z2
         8pUJMPnjCV3bzaeZErYzaHvgXzT6vLwaSS+EUlSOzOm7WnwBT8oLEw42Cf2RRtpYRZS7
         RRlw==
X-Gm-Message-State: ACgBeo0rClsFAzdP1xpNQ3bzYLr3wW7DogbcCigv4QbksT8AaQyxsUJt
        YYYqnvjqfO0liQPtqHuOI8FlQ3W3fPCiwQ==
X-Google-Smtp-Source: AA6agR65AOCzU326CQEQPMV0m/LcF/VJ4y6ePmtttO+ZNdrCCwjNT/z+BsXuSqjTtp6l8TUbzpRJhQ==
X-Received: by 2002:a63:2:0:b0:42f:6169:f396 with SMTP id 2-20020a630002000000b0042f6169f396mr3283995pga.249.1661895605323;
        Tue, 30 Aug 2022 14:40:05 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b124-20020a62cf82000000b005381d037d07sm5774991pfg.217.2022.08.30.14.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:40:05 -0700 (PDT)
Date:   Tue, 30 Aug 2022 21:40:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: mmu: fix memoryleak in
 kvm_mmu_vendor_module_init()
Message-ID: <Yw6DsUwSInpz97IV@google.com>
References: <20220823063237.47299-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823063237.47299-1-linmiaohe@huawei.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Miaohe Lin wrote:
> When register_shrinker() fails, we forgot to release the percpu counter
> kvm_total_used_mmu_pages leading to memoryleak. Fix this issue by calling
> percpu_counter_destroy() when register_shrinker() fails.
> 
> Fixes: ab271bd4dfd5 ("x86: kvm: propagate register_shrinker return code")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Note, the commit IDs are not guaranteed to be stable.
