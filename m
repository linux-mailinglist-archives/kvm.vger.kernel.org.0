Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9558C4B1D8F
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 06:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiBKFEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 00:04:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiBKFEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 00:04:31 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5741105
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 21:04:30 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so10801097pja.3
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 21:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hafp+SZmlpr9AIwlLC0AjbdundomKkMQTM3i7h5hOko=;
        b=HEmqti9TBXPB3AgN69donMmH29Y5xqziF2WLDQcCD96zK0fU5P6wypu/8lgYF25myR
         di+zV3FTrLjipVxiPY3X97CT5YE0pRdBQxNXOuSNGi/8pzZeZYIlHFcCB5Hlm0Q9FWSm
         qnuH2jYgA9ahhyiMcZ7St/2u2UiHo17yD9ZKPYWJFtj72/Vu26fHu6/3PGqB32j481UI
         Z3isYpTw7Hcq35PSpqRSkqualueaMF/Kfv9Mx5P4VYlO5OgpNLs+GQqoE8okm9BHvjPx
         YlSuNiDxiaWm5eDr7gcCdbpie6pq/crRlk5RMcnwa/TJwY+A2h0HoD/jPoeOzspyyeNb
         LUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hafp+SZmlpr9AIwlLC0AjbdundomKkMQTM3i7h5hOko=;
        b=kGocKd33GLWdt0UwydEuMmiZQLFrhG6aDE7deyeilej+8ZPlU3qYCNSxPWk20zW+Qh
         Y1xg3IMZE0qKLCQZX8RipKFagi3rmS0vfEp/6FCCjxoxXM8/++ezMMl13As/kvaYEJGU
         /EQYZDBrS21lGusE+TuiuUyk2x0e0CyCwk1f8SI/c3YIP3rkdoJwW0LSnerZCIU8jt7K
         qkkQbShy7Vq38sR6MomcjSXwjC1XMetL3Z/YKKI2+tWhDplM6luZre3nlIVpA3HoALe5
         tY1JyfYFdiJsxJW9Cnq3Ymz9IEIVJ7aBFWNTPgmWMwHTX3zgVEGl0Sq4Qp74s6raj60v
         u+LA==
X-Gm-Message-State: AOAM530Eyaxp7td7iCj1oKD2Xv6VpgLDBMz3IW7x4uVyztLXkAOFIxxh
        7e0rusq7nLeVb51mqQXtGMwAyFTEAQn9I+8dJw9QPQ==
X-Google-Smtp-Source: ABdhPJxVpz+4mZJs01nTXHzISx4FfZlba+M0gcEsKqH63dBrGFwxdQMBlt246gsdjFdx9ihmmFqnpFYoybH0AaYSP78=
X-Received: by 2002:a17:90b:3c6:: with SMTP id go6mr912970pjb.230.1644555870192;
 Thu, 10 Feb 2022 21:04:30 -0800 (PST)
MIME-Version: 1.0
References: <20220118041923.3384602-1-reijiw@google.com> <87a6f15skj.wl-maz@kernel.org>
 <CAAeT=FwjcgTM0hKSERfVMYDvYWqdC+Deqd=x2xT=-Zymb6SLtA@mail.gmail.com>
 <875ypo5jqi.wl-maz@kernel.org> <CAAeT=FwF=agQH-2u0fzGL4eUzz5-=6M=zwXiaxyucPf+n_ihxQ@mail.gmail.com>
 <87wni33td7.wl-maz@kernel.org>
In-Reply-To: <87wni33td7.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 10 Feb 2022 21:04:14 -0800
Message-ID: <CAAeT=FzGP6jcsDbhZsNZVCUib8UQ4zc+y6s0TrsaKjAKx9WSWg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
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

Hi Marc,

> > > Also, we really should turn all these various bits in the kvm struct
> > > into a set of flags. I have a patch posted there[1] for this, feel
> > > free to pick it up.
> >
> > Thank you for the suggestion. But, kvm->arch.el1_reg_width is not
> > a binary because it needs to indicate an uninitialized state.  So, it
> > won't fit perfectly with kvm->arch.flags, which is introduced by [1]
> > as it is. Of course it's feasible by using 2 bits of the flags though...
>
> 2 bits is what I had in mind (one bit to indicate that it has already
> been initialised, another to carry the actual width).

Understood. Then, I will take the patch and will work on v3.
Thank you for all the comments!

Regards,
Reiji
