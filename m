Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2625C4B1438
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 18:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiBJRaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 12:30:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiBJR36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 12:29:58 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6085921BD
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:29:59 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 9so8575900pfx.12
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y9MnmD2bSwsnvEnxXgt0owCbJFsLwnmCwLpJpglBXOY=;
        b=JXSIoN/RuFEMa1gcezB38jipRmkjUWzNsXKP94nzIGpES6fsmKdDAeD1Wttcv/S+W3
         Ut84mGPhxjkc+48GxecL4LdG4emEhZX4vQbpW+rIhpVgz6qXystRCVDWIzFYAKy2ob1p
         C7OkP9+GSM9TNuzj2Jk6QGpxvYGawAg0OrP0nAEM4Dqpbqv0vHAZEa3u+w3Psizl5eeo
         oqRiTebEjZCqBwHPNINj9fJ9mDVacJGk6OYaYcYwnPyxNrXkDUPMtAjDNTTOflPLKbtq
         wvwXjc3NY6pbrKialisoAypt+6VaGJ8AkAJJmdMBWsFv53zg2DnZc5tm4sPO2obSnX9i
         ce3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y9MnmD2bSwsnvEnxXgt0owCbJFsLwnmCwLpJpglBXOY=;
        b=poBD1ZE83vBpvYGMqiN3kFVx6tI+JAalgk5UoBRCoXTsdbC89HwSfodXSWHBSe28xr
         q1KKGVw7k9Xweng6rlLXRnxwlAg9bPdrf0L3ql88wsE7A7K6L6uHPcHWNARhZxd3FdZV
         s9czuiQx5ZFndl//D6ITMyZ/FOmqyPrkegBEkPfUz7S77GDsKhpEnGIlDzhxhmyIAr21
         UV5R6u0AO43ZFR3hCsvsOIGSqbIWklTCo9xS3ZGqFnOY0X7RBR98J2UXIB6uw+OhTAm2
         mcRmm4zap51kFZflJoXBlYP1xtdemqi+GeKhL8Ny1JfSLt0AdgQ/r9vLUmpIXHbU/y3/
         L9bA==
X-Gm-Message-State: AOAM530jpBwo+hs+F1BTF293C6m+54KHxOPNN+iDDL79Nok6AMd3a1v8
        stRUmntxQ+PC5a7PrfglLA3Kiw==
X-Google-Smtp-Source: ABdhPJz9a+GpGCnNOhpvPCTUn/KBUvTg0rSn1KqekTtgz6jYeT0nzgRu5MU56sM1UTZ68gAQAtL2fw==
X-Received: by 2002:a05:6a00:198f:: with SMTP id d15mr8595561pfl.78.1644514198738;
        Thu, 10 Feb 2022 09:29:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j3sm17890957pgs.0.2022.02.10.09.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:29:57 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:29:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 07/23] KVM: MMU: remove kvm_mmu_calc_root_page_role
Message-ID: <YgVLkgwBRy+JXZiH@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-8-pbonzini@redhat.com>
 <YgRgrCxLM0Ctfwrj@google.com>
 <1e8c38eb-d66a-60e7-9432-eb70e7ec1dd4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e8c38eb-d66a-60e7-9432-eb70e7ec1dd4@redhat.com>
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

On Thu, Feb 10, 2022, Paolo Bonzini wrote:
> On 2/10/22 01:47, Sean Christopherson wrote:
> > The nested mess is likely easily solved, I don't see any obvious issue with swapping
> > the order.  But I still don't love the subtlety.  I do like shaving cycles, just
> > not the subtlety...
> 
> Not so easily, but it's doable and it's essentially what I did in the other
> series (the one that reworks the root cache).

Sounds like I should reveiw that series first?
