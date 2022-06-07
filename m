Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7235C541E05
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 00:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381946AbiFGWWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 18:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382759AbiFGWVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 18:21:50 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE53626ACB7
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 12:22:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s14so15632427plk.8
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 12:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dG6iUQTX56gb1KRoxh+jUdOBcbzfvID/rD9lhppbHhw=;
        b=WTYz1wQYjjWL/0TzdIpz0b1L3rInkykCucL+C8/qCNXA/oiXsHwBL8s7GFBmS3KG2s
         5PZMpTxrkHRsy0IUqsGEDAAu4jYlqxzkNNONVKljpUde8ZEcjxsO1llUSfG8awZnA0qB
         kySTZ1c9hVyIZzINZ+4VPklhOIITtZUKIeCR5n0uCipeYvD/zcnxFkwORHptAMNJTA3g
         Flf2S85/9j6Gp+aAaIGRg9LV5sxap9sYRv/xKEbf+pxxo04T/r0xxyn2MIIGUU9YKJnI
         l2vyOPsonxkuBkim2P9pEMB3eBNDNqh9OHyLU6acObP4Lfp0bOCb5i9Pe5nwGkvvlgWN
         Zb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dG6iUQTX56gb1KRoxh+jUdOBcbzfvID/rD9lhppbHhw=;
        b=CtJux/hJz96+NU0SPYz9P51vAyKLfwPvxPzd4aJ0u2NQIVZpBoIm0V6PKcOqr7SsiC
         4uNAVTjQCwyg9eaWGtvZpjGo9ilDIWM/3v+Bkw+EThXImj1yWnux1wVHGh5StZgd8lgu
         H2Pz/gxNCmwF4u+0SGAQTBXAty090/dyJUEcxjhGo1nGIol5DispBV/a5yPctW1HTW/B
         FVEdEeZM8UrmZtgGI/e2p7rldovSDzdi3wAgrPFLwkz8sAFtUjQechc9PsjFHR5Q3111
         +WCvZjEkpii8f/uXVi+4XuwPpAdU0NH1hJzk5Hr3LvbSCfJcDayKae6ulXeBv1AcA40d
         8MQg==
X-Gm-Message-State: AOAM533/hvFpfvSDk1xx7IJUO4o+F4gBueitl0fK+9m6e+Zyfd2UnYU1
        eUyN0wg6sd7gVOa41ulze6Sz3g==
X-Google-Smtp-Source: ABdhPJwv+u+ed6w7AqQdZ2IfKjz2pwsuRB7B048zj22PbfKf0SNIDeZdsHsPxYbB2cWVA1+zUSBCLA==
X-Received: by 2002:a17:902:930c:b0:167:8960:2c39 with SMTP id bc12-20020a170902930c00b0016789602c39mr8419405plb.33.1654629737646;
        Tue, 07 Jun 2022 12:22:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c11500b001677d4a9665sm4295102pli.267.2022.06.07.12.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 12:22:17 -0700 (PDT)
Date:   Tue, 7 Jun 2022 19:22:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86: preserve interrupt shadow across SMM entries
Message-ID: <Yp+lZahfgYYlA9U9@google.com>
References: <20220607151647.307157-1-mlevitsk@redhat.com>
 <2c561959-2382-f668-7cb8-01d17d627dd6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c561959-2382-f668-7cb8-01d17d627dd6@redhat.com>
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

On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> On 6/7/22 17:16, Maxim Levitsky wrote:
> > If the #SMI happens while the vCPU is in the interrupt shadow,
> > (after STI or MOV SS),
> > we must both clear it to avoid VM entry failure on VMX,
> > due to consistency check vs EFLAGS.IF which is cleared on SMM entries,
> > and restore it on RSM so that #SMI is transparent to the non SMM code.
> > 
> > To support migration, reuse upper 4 bits of
> > 'kvm_vcpu_events.interrupt.shadow' to store the smm interrupt shadow.
> > 
> > This was lightly tested with a linux guest and smm load script,
> > and a unit test will be soon developed to test this better.
> > 
> > For discussion: there are other ways to fix this issue:
> > 
> > 1. The SMM shadow can be stored in SMRAM at some unused
> > offset, this will allow to avoid changes to kvm_vcpu_ioctl_x86_set_vcpu_events
> 
> Yes, that would be better (and would not require a new cap).

At one point do we chalk up SMM emulation as a failed experiment and deprecate
support?  There are most definitely more bugs lurking in KVM's handling of
save/restore across SMI+RSM.

> > 2. #SMI can instead be blocked while the interrupt shadow is active,
> > which might even be what the real CPU does, however since neither VMX
> > nor SVM support SMM window handling, this will involve single stepping
> > the guest like it is currently done on SVM for the NMI window in some cases.

FWIW, blocking SMI in STI/MOVSS shadows is explicitly allowed by the Intel SDM.
IIRC, modern Intel CPUs block SMIs in MOVSS shadows but not STI shadows.
