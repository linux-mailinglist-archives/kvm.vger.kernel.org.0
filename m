Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD04718945
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 20:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjEaSUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 14:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjEaSUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 14:20:36 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DA1134
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 11:20:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565de486762so78795007b3.3
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 11:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685557233; x=1688149233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VCR2E0OYyzjkMYmrwYxsQ0pX07aftNB42Q5lU3ZTBDo=;
        b=hm/ZkpYPHYftUYuA5GHo4XGFOcvMsCyFXo92BIIOLA9o2527VOwKdZuhxK7U4n1osI
         WTFCq+1A7/z9FW3yEyVip4UW4tC0jl01/YzmKPqe3Wpvs1EyXx2wyfUe1pUVeJHtzOhX
         acAu6mLMgViST8ISRL0LMMYyBh+ImfUfbBZhbMrpFjg6NKJgtHd1+QSVqSSF7bvAnai0
         q6xhu6LArX/Ct41x43JkOHxozyHk8L6MpRN1PEk2RY0hdVdC/3NyNoT5gHPTEtIa/UbR
         qNevkWEMKN5K7AvGCS9S2gO/0F5x+ldwjobn6OwxgsfC7/CfLDynjwOCSUxtl2+PBx73
         Atpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685557233; x=1688149233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VCR2E0OYyzjkMYmrwYxsQ0pX07aftNB42Q5lU3ZTBDo=;
        b=fooSXMqGloNFfyVr8bWQ6yYTzzigtFGduS4tL1pHdFdxtxFYC2MgKCJ8xIXGXEnipy
         b3BWA/yc+eRz6Bydlk0ApZrv/jHScB2i0iIZqbnDcwqIckyZX26Lqbcs8/KALn/LbSsq
         QoJ2d1ulamz/RZUN7Blpv/0fzMY9P3zZxUTcr0gP0ltf2/NCnfjhT2o+VZrVww3WRcDq
         mCz4pM4XjFSPIUXDO3BqDlohk0n4ZxZRqgn8XxsZOtwOhJCqSAvJcoM8cyZ6JdPoz2co
         7tAJRQkQwH1DMw/FjPWk/pDu/+MbfGN0Svje1q2kwCguNv9kMFSazaANm+RkUbhs735w
         94Gg==
X-Gm-Message-State: AC+VfDwEeu7lWQzlMqhSOf3CHiULH7Daicu64kucv/p0ioA5wCOiRUCS
        JtHiLtus1IRypilQ6Js/W7DVcqBR22M=
X-Google-Smtp-Source: ACHHUZ6r0y8Yn/EhWVPiwhnalpGscKVNji6OfdOyABNNFBYNflUdRUfC4N4FXfxvA2SGSXi+GIoT2A+fF5g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4519:0:b0:568:9e88:6aa4 with SMTP id
 s25-20020a814519000000b005689e886aa4mr3687665ywa.6.1685557233090; Wed, 31 May
 2023 11:20:33 -0700 (PDT)
Date:   Wed, 31 May 2023 11:20:31 -0700
In-Reply-To: <20230531155821.80590-1-jon@nutanix.com>
Mime-Version: 1.0
References: <20230531155821.80590-1-jon@nutanix.com>
Message-ID: <ZHeP75vG8xA+UeHt@google.com>
Subject: Re: [PATCH] KVM: VMX: restore vmx_vmexit alignment
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023, Jon Kohler wrote:
> Commit 8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()") changed
> vmx_vmexit from SYM_FUNC_START to SYM_INNER_LABEL, accidentally
> removing 16 byte alignment as SYM_FUNC_START uses SYM_A_ALIGN and
> SYM_INNER_LABEL does not. Josh mentioned [1] this was unintentional.

Anyone know if this is this stable material, or just nice to have?
