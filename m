Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45928691619
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjBJBNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 20:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjBJBNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 20:13:35 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584B85EA1E
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 17:13:34 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id f15-20020a17090ac28f00b00230a32f0c9eso4047016pjt.4
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 17:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k3av9jkUvE9A6NJ/myH2LVzHPBwDhgbAq+TXm0rIoTM=;
        b=PHZQYT5oASeECsZsHRHQMGmmlRn/fh1qFIyHRbeqb6UKHavmxO4hmYGKVNZ3HXfHCP
         OC+jObRKncg1lbUI1c6zLMxOulEL4CDQTfhrHtjSFhe60xMZzvHSZKHiz04WTd812P6c
         /gmzgZGkx8I5YMNuPo9O28D4S2q+ikgRILRReal9hzuIijl6Zu4RVW6sHImTFlsiNrI3
         YVkJmEkMBeHhPbqmrRnCQuyvV8054XIVeM+4KGPkRjrFvaIx64M0S/WFnVQwX9NNiWbF
         hMWRMMEk9Iz3eHX6+Tp6StYtSqPySt+Z95pXifmRZBUzvX8dri+GKO8RUx9Sfcd1JPKs
         b1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k3av9jkUvE9A6NJ/myH2LVzHPBwDhgbAq+TXm0rIoTM=;
        b=qbBQ2HpqkW68hm7/vVrkoQOp+sgk94HNnYO8ZTAawVmHozxnip2AcO2oTsuji11WMP
         2Fm1tcfil1yUOeaRRqrAHZgp+orsOFts/nKe5biUwaxp9BjNOBgnM7eGtIuksxpNk89k
         Zq0GSrtwEz4JOIjq1m9Bvc9FOfFhA1WAj0oPVHKmy4FXC7Os3DfKvc3uVyYxH1wCLx46
         wj1drYi9CIoo/mqX12XlDxBgAwPz+rNB/nELzptbBYaeW8c7n7VCNwq5u9nGnCtP6PdN
         Ez/qUp52E+0LeHzWE412ROtisduaoPnPvv/suyrnTqJA8zg5f7vGFGPtokQl/KHkDycj
         SUsA==
X-Gm-Message-State: AO0yUKV5IpXt5Pt3gCrKEmU1z8RCmWiL0e6gV3eoVTdg/GYC9FdU/xRU
        IaBuDU6CfHT4dV2RfbQtLE0+3g==
X-Google-Smtp-Source: AK7set9pFw3J5w5r/xV/SoTgrT6GjoR14zs1JLwGP7oCVVKObwM+RL2W/uCJ6aaf3zqmyu8HS/ZqXg==
X-Received: by 2002:a17:902:ed89:b0:198:af50:e4e4 with SMTP id e9-20020a170902ed8900b00198af50e4e4mr102079plj.10.1675991613691;
        Thu, 09 Feb 2023 17:13:33 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i25-20020aa78b59000000b0059428b51220sm2040561pfd.186.2023.02.09.17.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 17:13:32 -0800 (PST)
Date:   Fri, 10 Feb 2023 01:13:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, Tom Rix <trix@redhat.com>,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Stub out enable_evmcs static key for
 CONFIG_HYPERV=n
Message-ID: <Y+WaN8wW1EOvPbXe@google.com>
References: <20230208205430.1424667-1-seanjc@google.com>
 <20230208205430.1424667-3-seanjc@google.com>
 <87mt5n6kx6.fsf@redhat.com>
 <1433ea0c-5072-b9d9-a533-401bb58f9a80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1433ea0c-5072-b9d9-a533-401bb58f9a80@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023, Paolo Bonzini wrote:
> On 2/9/23 14:13, Vitaly Kuznetsov wrote:
> > > +static __always_inline bool is_evmcs_enabled(void)
> > > +{
> > > +	return static_branch_unlikely(&enable_evmcs);
> > > +}
> > I have a suggestion. While 'is_evmcs_enabled' name is certainly not
> > worse than 'enable_evmcs', it may still be confusing as it's not clear
> > which eVMCS is meant: are we running a guest using eVMCS or using eVMCS
> > ourselves? So what if we rename this to a very explicit 'is_kvm_on_hyperv()'
> > and hide the implementation details (i.e. 'evmcs') inside?
> 
> I prefer keeping eVMCS in the name,

+1, IIUC KVM can run on Hyper-V without eVMCS being enabled.

> but I agree a better name could be something like kvm_uses_evmcs()?

kvm_is_using_evmcs()?
