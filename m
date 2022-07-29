Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9924858566F
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 23:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbiG2VVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 17:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiG2VVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 17:21:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5A582FB9
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 14:21:05 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w63-20020a17090a6bc500b001f3160a6011so7632962pjj.5
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 14:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=oHI6KrO109rryHsE4gFvGHSOp8BXz7iSibWzWO0B34I=;
        b=OlMttIhX8SQFZywUj8/pmGnaNOv6CWB9bSitkTVPfop23xeN6RhCpEi/55DLqBySJ1
         dRwjGFRwsyZWoQMBYA6Cp9gXpuZbuMUH8lhoRKjpfp1LD7SgIK2viWjRbO6mugpYgf8p
         567hxY4RADzqs2Z67sZgCBudAaBSqFxe0nlFbFA2qnnzlUMU3gSzUmtj6NRWc7pSvMXP
         E8BgVpN1ymI6AgUjH8m7gbEc1QXZ0RUgTDEYDrKQPYoxA5bhlISYt5RUU9VyZvW0F0JX
         t0ahgpqzuWQJK1hhgqTHU2c/BHoeZqowhMGySnshrIqr5g7T/qLXa2m2IepuSc/hVepO
         16eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=oHI6KrO109rryHsE4gFvGHSOp8BXz7iSibWzWO0B34I=;
        b=VQr+dML97doOspXzBDMsCpuYWiJ7CFn/iq1mPTASJsHy7Ax50FT4gaGgjcOc7AZ3VY
         7BYqRNGBgVYTM7DntwmMJTsHKaHOV6kxifbNBlU3G4nkz2Gd8qGCIX9ICSmd8hilhvDf
         N1uuqvnPiewOnH9EVbLRGSWEbeO7dwoYR4nfjcBMJkByeXFSJeeU8fEMhFYlKNobHL/e
         BTgLJSz0RaTuEI4cNuqH/bqSB68Y6BEIKfndZWj1HeLHoT2dY5luL4WbSqF/KCWfC+VR
         Ob2F4My5AUEmcRN9ZKkSSUkD4cI5jtoqX1t5gJE83MiziigGwz7lFRk5WCy9NGSyu8OV
         dllA==
X-Gm-Message-State: ACgBeo3CLYMJbN6Mic9gsXdSaheiIDXkqY1vDLwfUnJKvwCFIOxqt1k9
        ITlfYdWRwk0GNFM8HM4kpxfV7A==
X-Google-Smtp-Source: AA6agR7weG7LToeZrScn9UsnCDAdE+Q6lF3f/UQXV1CF5UY/Hx7cW49DSolKU4lEyKiAb0zzCgCnuQ==
X-Received: by 2002:a17:903:41c5:b0:16d:59ef:eb00 with SMTP id u5-20020a17090341c500b0016d59efeb00mr5722671ple.161.1659129665255;
        Fri, 29 Jul 2022 14:21:05 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id gb5-20020a17090b060500b001f2fed4090bsm3516728pjb.49.2022.07.29.14.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 14:21:04 -0700 (PDT)
Date:   Fri, 29 Jul 2022 21:21:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Simon Veith <sveith@amazon.de>
Cc:     dwmw2@infradead.org, dff@amazon.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, oupton@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [PATCH 2/2] KVM: x86: add KVM_VCPU_TSC_VALUE attribute
Message-ID: <YuRPPQfUVA3uGubd@google.com>
References: <0e2a26715dc3c1fb383af2f4ced6c9e1cf40b95b.camel@infradead.org>
 <20220707164326.394601-1-sveith@amazon.de>
 <20220707164326.394601-2-sveith@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707164326.394601-2-sveith@amazon.de>
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

On Thu, Jul 07, 2022, Simon Veith wrote:
> With the previous commit having added a KVM clock time reference to

Moot point if the two patches are squashed, but avoid "previous commit" and "next
commit" and instead use less precise language, e.g. "Now that TSC synchronization
can account for a KVM clock time reference, blah blah blah".

> kvm_synchronize_tsc(), this patch adds a new TSC attribute

Don't use "this patch", the reader knows it's a patch.  Just state what's being
done in imperative mood, a.d. "add a pair of ioctls to allow getting and setting ..."

> KVM_VCPU_TSC_VALUE that allows for setting the TSC value in a way that
> is unaffected by scheduling delays.
> 
> Userspace provides a struct kvm_vcpu_tsc_value consisting of a matched
> pair of ( guest TSC value, KVM clock value ). The TSC value that will
> ultimately be written is adjusted to account for the time which has
> elapsed since the given KVM clock time point.
> 
> In order to allow userspace to retrieve an accurate time reference
> atomically, without being affected by scheduling delays between
> KVM_GET_CLOCK and KVM_GET_MSRS, the KVM_GET_DEVICE_ATTR implementation
> for this attribute uses get_kvmclock() internally and returns a struct
> kvm_vcpu_tsc_value with both values in one go. If get_kvmclock()
> supports the KVM_CLOCK_HOST_TSC flag, the two will be based on one and
> the same host TSC reading.
> 
> Signed-off-by: Simon Veith <sveith@amazon.de>
> ---
