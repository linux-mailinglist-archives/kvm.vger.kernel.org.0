Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0679F59FEB3
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 17:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239988AbiHXPnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 11:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239943AbiHXPm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 11:42:58 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E35C28E00
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:41:57 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 12so15372871pga.1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1prRi8IvFsf3xlNKbjLDKEdeYxVI3zsAKuSEuLmreYg=;
        b=OAjoK2tj6wUtBPSHxqaBNfG3oi6yIn8K7/N3PzSyFG3gG0c8LZGgTtzm0soqlRWKyY
         LSVJ0N1zcfTQvhx7F1dWGBaBwn73cy4etJNHybLblA7AL9rQGlvBxfJe4/wse3DDGm36
         OC5SGWGEw6ONLv07yHzDzBpa72Xf6YehDjMtnRqWZLgfSWg/OkEfDI0UpZD3Lzb32vND
         5bipEsGmBQ5MDyEeU0jJHDxVYMWqgiGRQ9CkU68quZYeCfP/ULLrHaYamT6/M1aVLJmM
         lga0iZy8cXRr1GVB0LSjmCQHqczZ/FA3Jhh4t46iz7kPHw04dIWH4qHa/DQl6wPWNTmk
         I6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1prRi8IvFsf3xlNKbjLDKEdeYxVI3zsAKuSEuLmreYg=;
        b=jIw9FhQU4tx7ivSSL35hsbjbbLnJLtuN6invRgR4j/3rmtar3bW+zgtvLLnZsUZ5Rn
         oy/EcbdpeqSCV6u2COI1MSBtQZFoSitfh4b+ludHjcko5Lfc7DRaxzblf38HLShr6nR5
         rW8dQ59p8cTlBvMsDXLeGrgatAA6oJXtSHLbGVPzj8RGyoOZXs/aiHM+YSghedFNCKoS
         PavcJxrbxonX1PIft9uWxu1vwSvD0yc3iV/EtTKGTicaz0pHgkI+mS10IGp9NNBxO5ro
         Ef1/OiD0ISKcC25c7Blh0DySFgsXAyVwpSr67NE8ghvLlYkCNpuYTz+fsa+BwjZRaL5I
         xP+g==
X-Gm-Message-State: ACgBeo1WsDlWb5qWHrwwoSFqM/clLr4+RdvIlYIc8ddwK1HNxeCGHiYs
        C5Gy9uEI5crJGL7gz9U//CELmINpiNf0Cg==
X-Google-Smtp-Source: AA6agR5z2VCrs4Venit4r8EaiRKC7PZCiqEkQAd35VKK9dqRELEoJxmQSJBIGbpbXDhDEdGwCgDYag==
X-Received: by 2002:a62:e50a:0:b0:537:1eae:1268 with SMTP id n10-20020a62e50a000000b005371eae1268mr5568538pff.16.1661355716394;
        Wed, 24 Aug 2022 08:41:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h16-20020a170902f55000b00172ad292b6bsm4241112plf.116.2022.08.24.08.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 08:41:55 -0700 (PDT)
Date:   Wed, 24 Aug 2022 15:41:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix memoryleak in kvm_init()
Message-ID: <YwZGwInBkpgUYRIL@google.com>
References: <20220823063414.59778-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823063414.59778-1-linmiaohe@huawei.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
> When alloc_cpumask_var_node() fails for a certain cpu, there might be some
> allocated cpumasks for percpu cpu_kick_mask. We should free these cpumasks
> or memoryleak will occur.
> 
> Fixes: baff59ccdc65 ("KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
