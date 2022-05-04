Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D31519305
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 02:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbiEDAyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 20:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiEDAyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 20:54:18 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EEC403E5
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 17:50:44 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id n10so129943ejk.5
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 17:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cP9uWnOWqzXPA2lSzLL1mbAFP/+AM6E6742CRb8OAEg=;
        b=Yjw/EnmWU+rVL+X/0xSJrIE/iLh0U6od8A1TLwfTPacJSqDXwPZV94B4OounqLhXTt
         XEbie7CO8XsBLCGnT2GSkQSDhMY33fcdoRzml/OfqeCHeu3S7+V0lk1hsLS+q2Nbl0kW
         tdrUbCUFVyLpTgrhfnNqZgd9O1HVEbe+61uNUkEqa2Q2OzlagZasK+g2d0oKPBCx2Xza
         Q+szFBap2PoKIYJsspidTqqNg9KTzo7s2d5rgheyL6nybU7lGaDXZXyQhkumBnP2Y6Ww
         gpZ5gLnurnrHBsM4HsCx174BIGZdwfhwPg+xA0zWW10Vt0iE+Xo1HB5u4kbu8vp7l2a+
         uRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cP9uWnOWqzXPA2lSzLL1mbAFP/+AM6E6742CRb8OAEg=;
        b=5TOA3w7aV6MRSMvhHwqPTL/TFG1dX9g8nmZjT/UUceKLxGE0qMKXTrOVaGaeH8kJgc
         yZTKtyNm0zQB78RevmrpGvANCoQDtFHBOc+VGV80K9isL4o9NO3AXnHDWDfG6am7gqUE
         uZhtoAVllSSIriN7FqhG2aj5omfenGFBdgpWW3ZZMNIY9k7kqwMSQZoBcgC8tueq0UMh
         7VeSFfLOkYa2Fli89NR1h7FNVQhm8x4XSzAm1HLDbayoMv7EfqYLnFoV8MZvfktpgDbW
         WtVoLv+uvCEWApObHX8lhTAjrGyJhl+w1QNylbWYj0RjsLsTzRFogiqrDSJ7dyZTJF0o
         wh7w==
X-Gm-Message-State: AOAM531B8hDD+JWyELMVCesHyAEKYEV2w7DLMM9GIOUrd5VsYs+yITYI
        HeuK+kqP+1HQ6j9FZrZGF8B7up9phT2T9oijPtfL1iQIGAE=
X-Google-Smtp-Source: ABdhPJzxBsJ/lYcetbRrFJrg1HY5oPGvYeGqgVLu+BDtIgj1hsWIaG4NifJBOTiuYK2RioMqP80W8mL6G+tB3UzytlU=
X-Received: by 2002:a17:907:7f90:b0:6f3:ee68:d332 with SMTP id
 qk16-20020a1709077f9000b006f3ee68d332mr17124127ejc.114.1651625442639; Tue, 03
 May 2022 17:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220503050136.86298-1-khuey@kylehuey.com> <20220503094631.1070921-1-pbonzini@redhat.com>
 <CALMp9eTCY3tMGL4=g4UfxGJoVhVB6KGu+vbwL-aDr+HJyaBBcQ@mail.gmail.com> <9085a08b-cbf8-8c79-f75d-61ae03bd92c5@redhat.com>
In-Reply-To: <9085a08b-cbf8-8c79-f75d-61ae03bd92c5@redhat.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Tue, 3 May 2022 17:50:31 -0700
Message-ID: <CAP045ApTz4K3QR=CezU2qnO4UfW-x6DTmivQ8xk5euqOAaVNXA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Account for family 17h event renumberings
 in amd_pmc_perf_hw_id
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        "Robert O'Callahan" <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 3, 2022 at 4:50 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 5/3/22 12:00, Jim Mattson wrote:
> >> Queued, thanks.
> > Isn't it better to just drop this entirely, as in
> > https://lore.kernel.org/kvm/20220411093537.11558-12-likexu@tencent.com/?
>
> I plan to do that on top, this patch is good enough for stable.
>
> Paolo

Yeah, rr will want this on stable, though this patch won't apply cleanly.

- Kyle
