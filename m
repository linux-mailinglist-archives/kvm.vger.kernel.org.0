Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EED72B050
	for <lists+kvm@lfdr.de>; Sun, 11 Jun 2023 07:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjFKFDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 01:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjFKFDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 01:03:35 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ED12720
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 22:03:35 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b3b9413baaso28405ad.1
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 22:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686459814; x=1689051814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qi24DtFAZsmrHNEajEMdxjivstNNvDufpgTl6tgbS4Q=;
        b=vDdGiQM9kknKiSTNdri3wDlj3hkc5o2RYQEvLzGZN/lzVybEkCVqMcaTiQIPXoUCPv
         BdnPZWCOXtY1RYRiY4pKHIF75foWlXuELw6wZDQMK0qgFJTWHDQO/NepoMI9MeUW7AhP
         H5/14D1DQfmyF3kLUdh3plDwF5y4RjjUF82ptcZtIjNMyHGsjeJEPlz+XlHYCllAyPLq
         173Ym0P+uC8jJHa96C24lzTEf7bYMvmX8j9PIDkltIF027u7XETReqia4Z2+HPpH6RXb
         knPUm1pnVo4K6C35XJW7d9cWqmxouSTr4vZ3ZhUVKuA96o68ueM6Lcpx4FGSJwpy8+5N
         2VRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686459814; x=1689051814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qi24DtFAZsmrHNEajEMdxjivstNNvDufpgTl6tgbS4Q=;
        b=IT2haEgujp9EqT3NlR9xKqv0oDGxjGmHzueZqpRnmFOdmo1Mv+9ns0rlXC2QXGqjr8
         5fb/eQgvCwBKC1ZLCzBZ16uCyL8hnqIW3WEqhP9AwHEZrr38UUkzOHd7FuY82FlnbXhW
         TW/WIhUs5oFqjR0QEp1sixSS9Pfi6pgXeyRyj4Bx8c+krBI9Onxa5RqOrsTNzk2AE+au
         4QnCPH/xsHWOfzwH+BaXwWR+qmhHVz4UHH6ZpMD6Y6UaCCgyn0vkiggMW8pYJfIveLBi
         IZ6RVGeXu/AaMXWjUWJpmfRtqJqgyOG7iHlOBrnw9sZHxLg/iw9r4veQMsxW21uSjiaE
         BWug==
X-Gm-Message-State: AC+VfDyhKQkRN0eil3qsq0dX7qv9hzYjrJzQcJSkyNDdBFx1CCvwRpIx
        JcYZQdvrAkgvIKjhzZi8LRZALg==
X-Google-Smtp-Source: ACHHUZ7m5wKCwbG46Igxsl4l4bkC+p8WBdNwdgSwmJpMXakjdWkTqdovzDL6QSXuqmxFwa4srv1CGw==
X-Received: by 2002:a17:902:e74e:b0:1b0:2670:7d49 with SMTP id p14-20020a170902e74e00b001b026707d49mr120852plf.16.1686459814091;
        Sat, 10 Jun 2023 22:03:34 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id u1-20020aa78381000000b0064f7c56d8b7sm4764643pfm.219.2023.06.10.22.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 22:03:33 -0700 (PDT)
Date:   Sat, 10 Jun 2023 22:03:28 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer
 systems
Message-ID: <20230611050328.jr65a56n4mmb6xk7@google.com>
References: <20230610061520.3026530-1-reijiw@google.com>
 <20230610061520.3026530-3-reijiw@google.com>
 <ZIUx5c//d4txXbUB@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIUx5c//d4txXbUB@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Sat, Jun 10, 2023 at 07:32:42PM -0700, Oliver Upton wrote:
> On Fri, Jun 09, 2023 at 11:15:20PM -0700, Reiji Watanabe wrote:
> > Disallow userspace from configuring vPMU for guests on systems
> > where the PMUVer is not uniform across all PEs.
> > KVM has not been advertising PMUv3 to the guests with vPMU on
> > such systems anyway, and such systems would be extremely
> > uncommon and unlikely to even use KVM.
> 
> Ok... Now your changes are starting to make sense. This patch is rather
> relevant context for interpreting the other PMU fix [*], so I'd
> recommend you send this as a combined series going forward.

Sure, I will include the patch [*] in this series.

> 
> [*]  https://lore.kernel.org/kvmarm/20230610194510.4146549-1-reijiw@google.com/
> 
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index eef17de966da..af1fe2b53fbb 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -105,6 +105,14 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  
> >  u8 kvm_arm_pmu_get_pmuver_limit(void);
> >  
> > +static inline void kvm_arm_set_support_pmu_v3(void)
> > +{
> > +	u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
> > +
> > +	if (pmu_v3_is_supported(pmuver))
> > +		static_branch_enable(&kvm_arm_pmu_available);
> > +}
> > +
> >  #else
> >  struct kvm_pmu {
> >  };
> > @@ -114,6 +122,8 @@ static inline bool kvm_arm_support_pmu_v3(void)
> >  	return false;
> >  }
> >  
> > +static inline void kvm_arm_set_support_pmu_v3(void) {};
> > +
> 
> nit: Give this thing a more generic name (e.g. kvm_pmu_init()) in case
> we wind up needing more boot-time PMU initialization.

Sure, thank you for the suggestion!

Thank you,
Reiji
