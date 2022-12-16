Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7C964EECD
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiLPQRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiLPQQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:16:48 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91A81CB37
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:16:45 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so6543296pjr.3
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OdafG541YsuwvzcUKOiDNZSPdcOBQZHVnqs17ldAk8s=;
        b=NQHNWyzTZVqs3i+nTtCvRl0Oi07t/GtdzERlgZK5zP/JCJQCc7FVQFqvaubLv7k3s8
         9w2pZrs8iQMiRFaFBIx05+rLb75LoSJmqyyIVojTQzUKyn6kI92cIaaDnTRQqJ+IHxUv
         ni16R7plw+ppA2sdZYqaHc/gwOesBbKlho11HX1XIYGKxvzykz0iSkBHWjde40oCGoyl
         y9EICvsDEYkqiA3w4MZYMjYgPuonqA1pDXorlPakXdqusAmXKnyKi/8BGuBeFajvaMlp
         /PR3rMa1yh+zCbaapKj1EBO9kj3nXek0sXz3atu0cUZst51Fnlr80TbISsHa8UcRO6z4
         bTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OdafG541YsuwvzcUKOiDNZSPdcOBQZHVnqs17ldAk8s=;
        b=wAyx2tOrG7X9KKXXe65iF5nsCl58H21W1oy7SsgmArBD/E0+hVOg/9SWCETF6qiKjn
         qnOCH7d0TkqDyZHCOe65GUOKXNOVn6jXYZBbkBxc1JEfdDUHpD3O15PrRvRktU0xSmR8
         IQPT3xBCY6DMSSRhOXGO1Iz/lftvaMkPmQCEW/Q5phaqkZFgvhxK9Rvncjdt3ByXggeo
         r7uaix1CITdCpHNvK0/wQad/3gUps1/VtINI8p7j2xLTN2PzZGtQlKhF+aGBTcvPYk5z
         aEtBPRcDmXBsdr6nqkJXfy+9U+2PC51gVOwA+XQ4ey28jjP6fBztYhu5vjBg4KpfnuKg
         AHSg==
X-Gm-Message-State: AFqh2kpBii0Jb84ig+WDeDeXpDJYXtwdgbbfo9ugJBARIWKpmOJLCYpE
        ilJZMGMWEcsyt+OpfxD9FC0Jbg==
X-Google-Smtp-Source: AMrXdXucnqilxaYOrF+vGocnpMUkRc0Pruezx1vAiz1I0ykEseGHMPEdTs7Qvts0exh8BN/3pmKHwg==
X-Received: by 2002:a05:6a20:3ca7:b0:ac:af5c:2970 with SMTP id b39-20020a056a203ca700b000acaf5c2970mr706763pzj.3.1671207404991;
        Fri, 16 Dec 2022 08:16:44 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k15-20020a63d10f000000b00478b930f970sm1628694pgg.66.2022.12.16.08.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:16:44 -0800 (PST)
Date:   Fri, 16 Dec 2022 16:16:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org,
        dwmw2@infradead.org, paul@xen.org
Subject: Re: [PATCH v4 1/2] KVM: MMU: Introduce 'INVALID_GFN' and use it for
 GFN values
Message-ID: <Y5yZ6CFkEMBqyJ6v@google.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
 <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
 <f2fbe2ec-cf8e-7cb3-748d-b7ad753cc455@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2fbe2ec-cf8e-7cb3-748d-b7ad753cc455@rbox.co>
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

On Fri, Dec 16, 2022, Michal Luczaj wrote:
> On 12/16/22 09:59, Yu Zhang wrote:
> > +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> > @@ -20,7 +20,7 @@
> >  #include <sys/eventfd.h>
> >  
> >  /* Defined in include/linux/kvm_types.h */
> > -#define GPA_INVALID		(~(ulong)0)
> > +#define INVALID_GFN		(~(ulong)0)
> 
> 
> Thank you for fixing the selftest!
> 
> Regarding xen_shinfo_test.c, a question to maintainers, would it be ok if I
> submit a simple patch fixing the misnamed cache_init/cache_destroy =>
> cache_activate/cache_deactivate or it's just not worth the churn now?

It's not too much churn.  My only hesitation would be that chasing KVM names is
usually a fruitless endeavor, but in this case I agree (de)activate is better
terminology even if KVM changes again in the future.
