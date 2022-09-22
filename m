Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C5E5E69F5
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiIVRxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiIVRxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:53:15 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91831106F52
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:53:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id u69so9889813pgd.2
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=lg6tvO1N5seeCZuNPfIr5vgas0L196sBL4hWDdGLhFE=;
        b=DV5Net0T/vNCmvA2Vxv1KERBT0uY5239av4/2uZlmfZCkTQgtqNf/xVMu5fLnyVs4N
         CRRe+t0NcApbP7BNJpojrI1z60y2Vek+htQK1nCXLEuUigETHylQI6Tn4pfCtCAl9NvV
         WtL7YicSxcCrCXTcPa9mjru8b3cDOC3uRGfj799EmpJxC1Of0ktlK3FOSe4dvK4bp4cD
         ZRcsQeVCqK2bXfI8AxAw3NlRJ4aCJgcuKVpPZZo4Ku4AkmSMbNXpujqf1+nszH30S4sW
         tWYQBCIHlCtK+BUSigTBq2KfoAoYzgomKQUb1yzLkFIpcHHNr/K3Yw/QMAJrsGftPGoZ
         h3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=lg6tvO1N5seeCZuNPfIr5vgas0L196sBL4hWDdGLhFE=;
        b=J9g8dXCe0nmE7xK43j8ah74ueaUJvpjb584N1w4UGaLazWK+gqfQmRLhSCLgdvRBRF
         8C1WrLF6LC3pmA+oIZ6N9QyuscSwBtr7w1LnjBiNc86CddGjSif2YLBiHnimV8S4WjRg
         LY4OpSFl+r6TO2XwOlH/jNvcEjPOgkII9Qhb3by2l5nryuMS8YgyX3z9VOLa3RxC7WbF
         ZEPQB0ESjBcghPys2xBMfWMGmHNThUQ//e4w9v2Ng0usyy4YG+d0IRx64uiWCqX7aHAb
         dbAOMVan/qcSyUoJ/oiyYqHX0sZXVEfHrvFlPDu8dRVmCH8ytqW4/LiOi1gOQXFpeiU8
         TUZQ==
X-Gm-Message-State: ACrzQf39r7kz2h/1i4345tHZm6fNOnIN+kOykR2fwpFK91rhqvuKQbCA
        SU11norMuEpU2mFwEiugIuBKzA==
X-Google-Smtp-Source: AMsMyM4GrCC+NMcGcmAQLz/03WheNYz+VUlooDPYAJRz3BQ82WD35Kn+LUrHxfQswy9dJG7vZKCHaA==
X-Received: by 2002:a63:f050:0:b0:439:db24:8b07 with SMTP id s16-20020a63f050000000b00439db248b07mr3888991pgj.60.1663869194011;
        Thu, 22 Sep 2022 10:53:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b16-20020a17090aa59000b002002f9eb8c4sm78760pjq.12.2022.09.22.10.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 10:53:13 -0700 (PDT)
Date:   Thu, 22 Sep 2022 17:53:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] KVM: x86: Introduce CPUID_8000_0007_EDX
 'scattered' leaf
Message-ID: <YyyhBTXdj96crwbZ@google.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
 <20220922143655.3721218-3-vkuznets@redhat.com>
 <CALMp9eSVQSMKbYKr0n-t3JP58hLGA8ZHJZAX34-E4YWUa+VYHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSVQSMKbYKr0n-t3JP58hLGA8ZHJZAX34-E4YWUa+VYHA@mail.gmail.com>
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

On Thu, Sep 22, 2022, Jim Mattson wrote:
> Why do we need a new 'scattered' leaf? We are only using two bits in
> the first one, right? And now we're only going to use one bit in the
> second one?
> 
> I thought the point of the 'scattered' leaves was to collect a bunch
> of feature bits from different CPUID leaves in a single feature word.
> 
> Allocating a new feature word for one or two bits seems extravagant.

Ah, these leafs aren't scattered from KVM's perspective.

The scattered terminology comes from the kernel side, where the KVM-only leafs
_may_ be used to deal with features that are scattered by the kernel.  But there
is no requirement that KVM-only leafs _must_ be scattered by the kernel, e.g. we
can and should use this for leafs that KVM wants to expose to the guest, but are
completely ignored by the kernel.  Intel's PSFD feature flag is a good example.

A better shortlog would be:

  KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
