Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730E45181DE
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 12:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiECKDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 06:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiECKDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 06:03:44 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFE51E0
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 03:00:11 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-e5e433d66dso16694251fac.5
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 03:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p6VmgZgbj9KAuI/YkBuK9i9uLFuu8Ee6aM08pw3KfSA=;
        b=TPyaTRJsj5bYrYQA551NtRkGLgJ6IViBsfnkV/igMEtxtWKpuwgHR0geNoV8fiwyZ6
         GXS2SDRwITFcf3ApeWyXen0Bg5GwZSirSvwtBE51eSRvT+apQL3jSkgbybPsb95LdOCY
         YlavU+X9YACl53qeYW6JDe3EsK3mLgfrLoZv8tmCOpvozOE9/xCNlpMH4BYn8BAnCZHR
         BZXvQy2U+AMS4vtpP3ynsb7g2LNQ+ClpjhCL+z4Ak0bE+0zn5AZOulJEcHd4YYpQ28K9
         25djKykytyBg5t3UAnDlvgV1CHCdMncGDndNEJGT0eU6U0KEucVx9kOySWV38tS1BK/f
         WeEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6VmgZgbj9KAuI/YkBuK9i9uLFuu8Ee6aM08pw3KfSA=;
        b=ZkYqMzVRHw/Uz4y5MHOdlxDlO565/YQ9YqY22m6emfevGAvWWHc6ApDNsEoYIuopZX
         25vCDHC4C6mDzI+ea0+8rWX3dS11dAezMD/78EeAeUhVxuO+R9agmL7yVzLaGLFrgNTL
         Bo7gzyrR/uMV/Rjn6+xvV+z80iHGN/TFBx1cbc8CNA7UNpEzYg4whj8eZnQIARrt8q+u
         sryWY7SNRNhIjdYeEljmnlZAililwrWlqO+Qip9aeldWIW23JgF8h+ws/ISP/KDrT+W9
         8pCyMVRr7IWJ18X2DItUhqjFu0E/EHxHAunnc6gNKdjj0Xadobe87cFknikS3P7+Zq3H
         HpLA==
X-Gm-Message-State: AOAM533mCBh5ViZ+cflf+D4RWHMixLTY/nutJ+BTvN4EoN4wstwut5xS
        xJb1bw+3JYuv7eWCvvgrOBZdTMYd8UYKGLXjoVfpyw==
X-Google-Smtp-Source: ABdhPJwLxBYAs66rQRuoxspW2AW7l0Rwad4MVCd59NJBFjU3fDtR69VxutXMYb8Qr4bobex6FWU5i9oVLT8RpGVGzSU=
X-Received: by 2002:a05:6870:41c4:b0:e6:6550:2da3 with SMTP id
 z4-20020a05687041c400b000e665502da3mr1435938oac.13.1651572011045; Tue, 03 May
 2022 03:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220503050136.86298-1-khuey@kylehuey.com> <20220503094631.1070921-1-pbonzini@redhat.com>
In-Reply-To: <20220503094631.1070921-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 3 May 2022 03:00:00 -0700
Message-ID: <CALMp9eTCY3tMGL4=g4UfxGJoVhVB6KGu+vbwL-aDr+HJyaBBcQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Account for family 17h event renumberings
 in amd_pmc_perf_hw_id
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Kyle Huey <me@kylehuey.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, May 3, 2022 at 2:46 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Queued, thanks.

Isn't it better to just drop this entirely, as in
https://lore.kernel.org/kvm/20220411093537.11558-12-likexu@tencent.com/?
