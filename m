Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4894D8B42
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 19:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243565AbiCNSEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 14:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243559AbiCNSEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 14:04:07 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4E1167DE
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 11:02:56 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r2so6649636ilh.0
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 11:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8536zTCC0nz+jAiN1Qoj3oXH4YMV4n9ZnMmaeo4Xicg=;
        b=WtLSR3KJ8u9JQkI9+QSWyYPtWKcjlMAKFvYeejWljSWKsJQGM59y9i1IdxqS3+2+pg
         w7Ji25CC9oXxA5xeRbkm6/QQUdvkOssJAgNQ9l/KXY2CjLMYMuqTjnl+ox+Ia37oNvYN
         G6eJ7DAuBLnjB2YBIomjBNXkB68JMFnpv2puOs9pWJFixYXHMRAphvT0lR6lN9huIha4
         CykHm8Z0nm3EpY24SvluveXCt3nTtLVrOvqQ4Ffvv3ZO9ZZ+ggXhI9ElbUuudaRFOvcI
         DPQx65e2r0DDfqlmJxws/Vxl+IvEBJvpzEoYeuKEyzG2C9EWwNi0OvTomBJaENH5rULI
         LQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8536zTCC0nz+jAiN1Qoj3oXH4YMV4n9ZnMmaeo4Xicg=;
        b=h4cl/SROOSE2EBLO786I7zeqvEkAW70gl990bod/a7zvKZccaREkDcdqfZDdHyFpYW
         wRujdxmYICWL8dsytsa2RPWNBZEEuAuxSTG1Mf5EIoqW73Vt4J+JN2TNuJfQOeUXnDDp
         OSgFpXxNkF5E2MHyBqvROTYs15KJDnkB8ul+ZWxKoZ3qCJIhjZwXH1uCbrG4llk2jFKF
         2D86Fbj/1e7feC/w7BUVekmVBTu/AzYn5SDe51JORQi79LmTeoSCB1LqMdv5fxOGjkFw
         4pWuvbe7QDqQbMS8OEYlQb3HXBs8CSZTD+hG35FT6xWMC+xzjHMMuCHwraX9M/fk+3yb
         Jk5A==
X-Gm-Message-State: AOAM530vQTci3sylI1M34ooAiUiTfiGBAKH6Xqp/e74xvUMiYnuNgJCZ
        cxk+9t8e7bMh9RciNxi3GH0kKg==
X-Google-Smtp-Source: ABdhPJyudojN0tne3cl946mlYkSIDAiVPxLHDvbjzXb1BXUOPQ05BUW/BUAvbjwMoHoqH4g/6ZzqbA==
X-Received: by 2002:a92:8e06:0:b0:2c7:a8f8:3c5d with SMTP id c6-20020a928e06000000b002c7a8f83c5dmr3107778ild.107.1647280975428;
        Mon, 14 Mar 2022 11:02:55 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id e8-20020a056602158800b0064683f99191sm8050365iow.39.2022.03.14.11.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 11:02:54 -0700 (PDT)
Date:   Mon, 14 Mar 2022 18:02:51 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 04/13] KVM: arm64: Capture VM's first run
Message-ID: <Yi+DS/BUPMiB+B0a@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-5-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-5-rananta@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On Thu, Feb 24, 2022 at 05:25:50PM +0000, Raghavendra Rao Ananta wrote:
> Capture the first run of the KVM VM, which is basically the
> first KVM_RUN issued for any vCPU. This state of the VM is
> helpful in the upcoming patches to prevent user-space from
> configuring certain VM features, such as the feature bitmap
> exposed by the psuedo-firmware registers, after the VM has
> started running.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

I believe this patch is superseded by commit:

  5177fe91e4cf ("KVM: arm64: Do not change the PMU event filter after a VCPU has run")

on kvmarm/next.

--
Thanks,
Oliver
