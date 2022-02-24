Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDC04C38C5
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 23:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiBXW2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 17:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiBXW2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 17:28:51 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2A618FAC8
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 14:28:20 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id y5so3093118pfe.4
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 14:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NF/iGcyMODxJd9hqjYLYxLcN2czTwBn1UOj2IoRGcP8=;
        b=GhGK4UmLpNzx2+ohKdGzYdnehJPpnDtc4ZPCSQSF+XN9W52Va2beVoCqg+ww9MVBea
         8C79LKwYirUw2PQKTDZa+obsIlomXleHgnOh0XzF/QA5ZYKkdNU55iW3alKJPn6KRNag
         yP9DEyDvc8lVh2fp/InUTbYsKtgDXmBS+WLbDSXCj5f3hCo67bbnEb7Q+K6GbjkfSj1T
         4lr80FFJgmYzfnWHp7VuDbodJcb6WVQiAKLLkXlm5YU1MeY3DuBSOrvkBLTOiuuVB+bt
         0dUbvWyWGspw7LodJylb2ObAVXtY4+lP0lf3EqykK0OqMFZ0EqGq53n59njJQj3WsNuw
         6E9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NF/iGcyMODxJd9hqjYLYxLcN2czTwBn1UOj2IoRGcP8=;
        b=XIx9UWboUk4reJcYtIr6+FHBPMAOdJpPY/GA8Ir8RlPv5WjAUhdsQg+LlpBX3dp/+T
         XERnGWrGClViCxH0gdHY30+yrWSWP2spAmZzybIrUMSXkPRK2uSFBK8nRK1/CwtSpG5v
         JGS74BWut+XMj6mONXgcC3yDj7PJHHTXJXfCKHXXvls96bmV1myGV1cksSEhmR5wlbzc
         Rhi7/Ba9sKkLAd00fRdzxNcHxqmwE/I+R9bGK7VFwLGXrMQoVVNtnsNYEmbgZX3Jx8gg
         RFg3gnVYfY0YDs8rB4i/tRb72g0VQ+7guAb/y0Tq6BiXpzZwdhQXnN+bv8Q5k9fdLFc1
         ukIg==
X-Gm-Message-State: AOAM530Qrz5+Zf0SOtZmYZFmcs9CjKliukk6q+7L2QW0+h5lnSiWREH4
        dpmqRUL+telsF0ueGtEl25tUog==
X-Google-Smtp-Source: ABdhPJyMIBiMPrAbg0mqyTV/P3U7UaWOv6ucsXvGaR9sjG5VuieOYn9UTIG2lHyZkX7jAqO7lSC9ng==
X-Received: by 2002:a63:4412:0:b0:372:f29e:3108 with SMTP id r18-20020a634412000000b00372f29e3108mr3814834pga.354.1645741699770;
        Thu, 24 Feb 2022 14:28:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm455511pfm.200.2022.02.24.14.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 14:28:19 -0800 (PST)
Date:   Thu, 24 Feb 2022 22:28:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86: Temporarily drop kvm->srcu when uninitialized
 vCPU is blocking
Message-ID: <YhgGfyqRZp4S2/gn@google.com>
References: <20220224212646.3544811-1-seanjc@google.com>
 <CABgObfZnW=7v6agYYK6ENgiNOwFCbCZo_8t95LoFrt3sg5srcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZnW=7v6agYYK6ENgiNOwFCbCZo_8t95LoFrt3sg5srcg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022, Paolo Bonzini wrote:
> I had just found the same issue and dropped the patch. If it's okay, I will
> squash this and also include your reverts in the next pull request.

That's fine, I got a giggle out of seeing kvm/master force updated :-)

In case you haven't seen it, this needs to be squashed too:

https://lore.kernel.org/all/20220224190609.3464071-1-seanjc@google.com
