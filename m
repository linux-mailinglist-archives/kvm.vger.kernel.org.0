Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED75965AE
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 00:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbiHPWzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 18:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiHPWzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 18:55:01 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650706173D
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:55:00 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id d14so16827748lfl.13
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=s1+GFu+N7CIKfS8OAp+AI4ni9mpv6OWnOGVB/3BEk7I=;
        b=SFVBpJvS93zanubzxoKvo9Ev7mNiGDzRy+YBEVLIBTPOWFgdm6zC6lRqHMxWljHR7N
         9wgTm5mTWSHd4VMto2ajc75vo6F/vdWGiHeFTPiwxIqZr4MS7Iij6TnPpIXAzJbsR6II
         X0qvBjqf9+Zjxy4lI1ZE4FSccGGcKrme2crSVD/6hJbQzeMljkJKRXkXs5bLFYxDfbDE
         XaRrxibNKxR+SxplLufrTcr/D9UE5644583luj1B4YudHnzP5YaliYdQSaYTjXzKqWLL
         qbmiUriLABBqbVRlTo3ZiqD1/YFZO5Tje06Cr1bx7ZYQvAF23y7xJiboxdN4QuEs0XyP
         EidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=s1+GFu+N7CIKfS8OAp+AI4ni9mpv6OWnOGVB/3BEk7I=;
        b=SDOcee4h6tQ41V41pyG3WT4gR9NQevVSu98DUA7CYxGpwmhBNCpSOGlDSCC6ogP4rU
         n4rSVe9rFb4/VBBXqtuCgLAfqaI85W7woI+9CwqGSWdLYLO1HFe+G3LZqMkxisa0WTTf
         5ZrcbE/klVWewm9yo/RtwAIXYr4+BDWcaqOUcl8iFhMlIoEo8hCbP+MwcQ7kZ5Bf11K5
         iMJ0A7EMaIoN92cakZ6HOBrvtwN8cUK/V6uNT6frSV+o8Wl2rsO0i7JvGmlQVRq0ChH4
         ujJAxz64XTP9H78qvxe+JevK+0lCVDlONOGgh9dsbZ8foX7M5fpS+x/NFkOwYu+Og36N
         CTcg==
X-Gm-Message-State: ACgBeo1AbvcnHR5RGr0OfzK4DwD4qAqdTnVXr3hN78uR11J4AD3ZAPX3
        fakPAaNpB69mb04obxZnmXnzG40X3tc/r4iMTqRyXw==
X-Google-Smtp-Source: AA6agR5DeeZ5wEY0y4jOvi6hRYJR/BSth7dhRT83iN1OWdCs3/GYiRdFTOB8hizk2t0WzlDMDtpxY/nSHWRgvto3AJc=
X-Received: by 2002:ac2:4943:0:b0:48c:e42a:f0d9 with SMTP id
 o3-20020ac24943000000b0048ce42af0d9mr7412465lfi.528.1660690498562; Tue, 16
 Aug 2022 15:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 16 Aug 2022 15:54:32 -0700
Message-ID: <CALzav=ensf4nrRmTGsix4ah6VsM7COxmbMPNfxyOGkK-tAVZTQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is enabled
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm list <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
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

On Mon, Aug 15, 2022 at 4:01 PM David Matlack <dmatlack@google.com> wrote:
>
> Patch 1 deletes the module parameter tdp_mmu and forces KVM to always
> use the TDP MMU when TDP hardware support is enabled.  The rest of the
> patches are related cleanups that follow (although the kvm_faultin_pfn()
> cleanups at the end are only tangentially related at best).

Please feel free to ignore the kvm_faultin_pfn() cleanups, i.e.
patches 7-9. They conflict with Peter Xu's series [1], there is a bug
in patch 9, and they are only tangentially related.

[1] https://lore.kernel.org/kvm/20220721000318.93522-4-peterx@redhat.com/
