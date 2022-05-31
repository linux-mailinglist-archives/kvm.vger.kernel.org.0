Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136575395DB
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 20:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346826AbiEaSGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 14:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346816AbiEaSGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 14:06:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8394E8AE68
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:06:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id d12-20020a17090abf8c00b001e2eb431ce4so3030198pjs.1
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mFu6iMX87nna7NvQ1h70DyFL3gjd//hWF9G4LDYdoKs=;
        b=RZAbhvi9Ma8iWYYK9n4vIXolgsgsZPb5tw01NgsKFiYFs7NbUw6S443+JZIGG3wU5i
         rfekncIjPCRwfh4SnjOPfNpZk6vJUb3ERPj49044AgyZ9eRHI35DylfjsJ48sFciCwWz
         zTELrC9m1nH6M7CM/BDzXXXGhEx1Od4DEMBXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mFu6iMX87nna7NvQ1h70DyFL3gjd//hWF9G4LDYdoKs=;
        b=rljm0mIxCO+MHDg5w/RsgjV+qd8qLE37zvR4eLbSjqUxvPWmMZknomZPenL3nDGphb
         F7oJtm8GiUbvMhl0ezvNol2Eo6aUuYtiQMRiFZeFmE5ESOgc7nExpBNV2HqsXLjfsmNc
         JFS6V+bFrt6AJS8fv3krCznZdjbHmYumTKulhKfnr0yDoTfN/k/3zsa6WcXI9j7xlRe8
         nFlLGRdyAVf4gy8HHoErgPDYIihzqWpKgBi0k4pf95kFSwLQgFVACG83j6QAKkz/I+cZ
         A6WTomn1ruxLMQi2BcJx8ZNK/vLDoV8BbtBeKCw+GgzVLChJL1fj8W9+nV6f35A29xAF
         Ub3g==
X-Gm-Message-State: AOAM533Z/tdtKgKKHEFQWhZbyhClVdUNVdx7Wy978BHTUiYqdrDj8b6Y
        rxbLEQZQB1qda9kJu2iCVoPCRQ==
X-Google-Smtp-Source: ABdhPJyvFP8ou6y6xiqGQWiMDZgSy3ovDYL5wv8GVhEXDUTiJKqTaPzPagdh0u4rf/FrKL2VAwb8tg==
X-Received: by 2002:a17:903:2287:b0:164:83cf:bb15 with SMTP id b7-20020a170903228700b0016483cfbb15mr574939plh.49.1654020373077;
        Tue, 31 May 2022 11:06:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s22-20020a170902a51600b00161823de53csm11471517plq.282.2022.05.31.11.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:06:12 -0700 (PDT)
Date:   Tue, 31 May 2022 11:06:12 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>
Subject: Re: [PATCH v2 7/8] KVM: x86: Bug the VM if the emulator generates a
 bogus exception vector
Message-ID: <202205311106.58FC5B61@keescook>
References: <20220526210817.3428868-1-seanjc@google.com>
 <20220526210817.3428868-8-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526210817.3428868-8-seanjc@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 09:08:16PM +0000, Sean Christopherson wrote:
> Bug the VM if KVM's emulator attempts to inject a bogus exception vector.
> The guest is likely doomed even if KVM continues on, and propagating a
> bad vector to the rest of KVM runs the risk of breaking other assumptions
> in KVM and thus triggering a more egregious bug.
> 
> All existing users of emulate_exception() have hardcoded vector numbers
> (__load_segment_descriptor() uses a few different vectors, but they're
> all hardcoded), and future users are likely to follow suit, i.e. the
> change to emulate_exception() is a glorified nop.
> 
> As for the ctxt->exception.vector check in x86_emulate_insn(), the few
> known times the WARN has been triggered in the past is when the field was
> not set when synthesizing a fault, i.e. for all intents and purposes the
> check protects against consumption of uninitialized data.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
