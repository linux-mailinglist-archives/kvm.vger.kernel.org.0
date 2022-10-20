Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCC86062F9
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiJTO1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiJTO1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:27:07 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E01B1AFA8A
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:27:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g8-20020a17090a128800b0020c79f987ceso3605461pja.5
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5as7RvXmnpmdw2J8D5qzRuTt8iInwm4QklMlCoqT8xc=;
        b=j27ChnRsZvVCu6uPN8v6MUJfYY4YII6/shJfnYuumGcBsyqGBg77+FHzsgGrdDlnNa
         ZnFCjIqzMFIa5e8eFIH0V/QdekhZBbGzDhm9z/4ui+mENYaYGh4zgLHyLQGk4tqn2NjR
         2hrqDcPJmVrShWIv/wXzs5tysV//YEBCk0GuL8AlDWPnJbGbNmIiA2r3SbfWjfwcws31
         33T6GdhVyzV+oPccdsvefOM/kqT94JcavpQwiyhEMNLn+vwU9Un19XmDwfWPtadQHI76
         fncVxyVVfNp9py+JAGWr+hiRcTGTPaXIMQCAwkOWizazXIKoaAvnii2ocHqu/Nl7NLre
         fF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5as7RvXmnpmdw2J8D5qzRuTt8iInwm4QklMlCoqT8xc=;
        b=UhgUUIYeRDW7+0jUFomnjCX2wdZtRM/tabja3m/+QiOT72tKJZlpXMeRUh1XmH//Q/
         ILjB/JIrm0RZRsyZijgDxlxept/9vPw6ZM2msQhuAt/PXqxt2daQKFEBk22QyLMwRg0W
         tBzWO6ZllZk2Kt7zfK2IwPkXoQSTq5LfnRqBnAOq2NPh2TZ8EuQXavSavDjlynif8Muo
         p+/nZufIDSzFcYrucjDzQb2vnJIPrdLRJbbh17sJzwjk2V+9C7Go6zbrv6oNeCTtrGJa
         wGsVLYQAzWGTJGotRFNsxZnOweqTjOuPZ+qMI1LtLTP/GnzDxTCeHf8BzGA+0mR0caGy
         uDYw==
X-Gm-Message-State: ACrzQf34NQTIru74rm7TY1nWz9r35Kxrel7Bmmo50O4RJr5SFdCY0Vg1
        vORzYFy50T0xmD15Tw09vBAcfw==
X-Google-Smtp-Source: AMsMyM6dgONGmly9i1g9cbunKT4jCzU6tIbYI+FDN89w9xHqsGAoFm5G+VheJmomUGkEYWEIAGyOkg==
X-Received: by 2002:a17:90a:930b:b0:20b:a5d:35d6 with SMTP id p11-20020a17090a930b00b0020b0a5d35d6mr51575318pjo.146.1666276025901;
        Thu, 20 Oct 2022 07:27:05 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 194-20020a6216cb000000b0053e199aa99bsm13217718pfw.220.2022.10.20.07.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 07:27:05 -0700 (PDT)
Date:   Thu, 20 Oct 2022 14:27:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix the initial value of mcg_cap
Message-ID: <Y1FatU6Yf9n5pWB+@google.com>
References: <20221020031615.890400-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020031615.890400-1-xiaoyao.li@intel.com>
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

On Thu, Oct 20, 2022, Xiaoyao Li wrote:
> vcpu->arch.mcg_cap represents the value of MSR_IA32_MCG_CAP. It's
> set via ioctl(KVM_X86_SETUP_MCE) from userspace when exposing and
> configuring MCE to guest.
> 
> It's wrong to leave the default value as KVM_MAX_MCE_BANKS.

Why?  I agree it's an odd default, but the whole MCE API is odd.  Functionally,
I don't see anything that's broken by allowing the guest to access the MCx_CTL MSRs
by default.
