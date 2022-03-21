Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25144E222B
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 09:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345232AbiCUIaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 04:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbiCUIaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 04:30:09 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52F219C29
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 01:28:41 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id d62so15845119iog.13
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 01:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cfg0pudYuT/u9wGQCidgxonBzl21c0eXO7Xcpwo6DvA=;
        b=i7pv6ta+HcQyz03nNrIY/wwiH4PmYxUxoVygyzR65sr5D7TIWBtE50wN/vm7DFq3Ny
         JCFfR6YE94Ec1NI59HTf0yCMDdNbFZ566y+1EoHu741K0oYhUvMDga/syvsdgowQMYYE
         WDTQcvcf1IcdlrRaUbVn8a9UQsSurtP4PnVx/pGuf5cuNoaWg0SgNWNYfzn8rWo2VHEC
         m4QlSycQ6JKjDoY0RvAWA3tkfsbRxkO8TEO7cv73TwfFHu/ix/mTKKDHEEjKZZ13xZiK
         sun05CpBOCvf2Fg9+wwEmmK6xAsRfgpNvFaNvjXaie+Oj78pscbozGzmN/nHVby39LF6
         kSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cfg0pudYuT/u9wGQCidgxonBzl21c0eXO7Xcpwo6DvA=;
        b=cVfpFNhUQu/xX98bGam0IXZfe8eGjIyLgYW/O/0cUsG6+UU1wH1YbXgO2YlVmX6kuv
         ZfLnoeByqODnfu8VIsyrT5K8qhVQX1pWbvJf0t5MceKPJ49OsyOlQBu3WvI3SmMjyeMs
         fjkxbw8jhRZG//i9pIiwhAx1GW9ZVIGmsYjE6qz5qGtkg+EeEWr80iCbDNk/RdrzTaLO
         +9Sgvpd9HIOpZEBEt+ZvMaQK0KLgiTYY4e0QfmDASWe8SE25lLGvRRLQkCUxTqZIKSxq
         Soy0swgpaWRyGYrmcxHJSmFaqSJX797iWsov5J6jUg6cGykWhAQfnRr0qI6fbxakEPgR
         C6Ug==
X-Gm-Message-State: AOAM530gLI37D4e95cwuBhfAU+aNWb6nztjkEZJi3jOhcRoe/IpuWmmg
        QiKPfGBv+T5Vi88uwLR/d0wGKA==
X-Google-Smtp-Source: ABdhPJwTWqgxMSuyUPTzaj4+SQGyUK+bH9j8AzPeOFjf5Lmv+3MyOVV6SsDOnasb4Gvf4p4Yfg6qUQ==
X-Received: by 2002:a02:b048:0:b0:311:85be:a797 with SMTP id q8-20020a02b048000000b0031185bea797mr9850764jah.284.1647851321010;
        Mon, 21 Mar 2022 01:28:41 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id x2-20020a056602160200b006463c1977f9sm8361965iow.22.2022.03.21.01.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 01:28:40 -0700 (PDT)
Date:   Mon, 21 Mar 2022 08:28:37 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v5 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
Message-ID: <Yjg3Nd1KYmJX5rSG@google.com>
References: <20220321050804.2701035-1-reijiw@google.com>
 <20220321050804.2701035-3-reijiw@google.com>
 <YjgYh89k8s+w34FQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjgYh89k8s+w34FQ@google.com>
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

On Mon, Mar 21, 2022 at 06:17:43AM +0000, Oliver Upton wrote:
> Hi Reiji,
> 
> On Sun, Mar 20, 2022 at 10:08:04PM -0700, Reiji Watanabe wrote:

[...]

> > +#define _GNU_SOURCE
> 
> In other instances where we define _GNU_SOURCE, it is said we do it for
> program_invocation_short_name. Nonetheless, I cannot find anywhere that
> the symbol is actually being used.
> 
> This looks to be some leftover crud from our internal test library
> before we upstreamed KVM selftests a few years ago.
>

Ah, it's because we're actually using program_invocation_name. This
already gets defined in lib/kvm_util.c, so except for a few oddball
tests that directly call kvm_vm_elf_load(), this is unnecessary.

--
Thanks,
Oliver
