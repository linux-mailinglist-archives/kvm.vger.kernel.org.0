Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CE25229F7
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 04:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238378AbiEKCr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 22:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238961AbiEKCmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 22:42:45 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4D24B401;
        Tue, 10 May 2022 19:42:44 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id f3so1197458qvi.2;
        Tue, 10 May 2022 19:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nr7rqF9Jp127FLYWyPkXv9hygDn/nLdZ5zerr9o5n/g=;
        b=RvJ9TjOlncSirgTPuYZX1XigDeFfu08gOc/fdEZnzD/CCiVl/WUB0nj/UBx+ouDnYj
         chfgVlakGjCXG0pNOpABcZUhTQV48fdM+QVnaQY9o5IQjNyxrfoksnmt6ICdPlDX6+Vp
         s3rmbS0JGKW3pgWWcyiToU0gAxUaykrSNjjbgp2d3HRMOUpSgicPbJ2cAroNV59MlSne
         /uDWCUqBqEvv4ML2qYWA/q57B1RB0qAH8+J1IdnMRJMz0GNVAuquZOIgIfCfsQYgBqaO
         xMGHNgm//GL5wrGjTGsN0y8HFpxPFgLvI+pHKF5ok3qb/fam+5yHAvItTjGNJF1BhL7j
         OFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nr7rqF9Jp127FLYWyPkXv9hygDn/nLdZ5zerr9o5n/g=;
        b=ygGSKm5H42wu3aHCy7IM/vb5EU4qNjb4wXYo2POU5nos7S0hkt5KWPh4DIIKpsFMin
         FwbeLcMKpMv2YdnZCF1cKH1c1+Lc6ew8cEnzYeSsAnI4NlfZhFB6NLcdDRm5LQoBsPrR
         RTI6tqmLQI4Sk9PtGQxa0np992XyTG3hK1mbaks3lrjzB/ejWWifiXnwxBOTTpuyu+fB
         iHe5b6NCheISkh4dNgYKN1g2UIuuPk0VOKWoKY2DRL0H8gCdQm7WkSqqeXhfbIPCWCiP
         O4XTHBSk2tBUa54xcd+Q/T9IbFE0ZmHe8ijifQFa+JU4zlWpLLEGhTxeT8UjiL1W564L
         JUrQ==
X-Gm-Message-State: AOAM532eJ5YCvTj87D+nxE3f7ojBY/2s+kFZc5wSch1APyfDIPuBMJX5
        ZePvlvSfarEP+OtNjbWch8far6OtaaU9lJnYQXw=
X-Google-Smtp-Source: ABdhPJzHtXF7gyc3PpTvZWDV01lMIPbqKeECdhQHnJnq0aBsRURyFA5IcbRKAKZpaeCPmm34CUXrsxUZW0eFpcded6E=
X-Received: by 2002:a0c:dd8a:0:b0:456:37b6:24b5 with SMTP id
 v10-20020a0cdd8a000000b0045637b624b5mr20520428qvk.69.1652236963931; Tue, 10
 May 2022 19:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <1652175386-31587-1-git-send-email-wanpengli@tencent.com> <YnpsDSDqU5oNK3bQ@google.com>
In-Reply-To: <YnpsDSDqU5oNK3bQ@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 11 May 2022 10:42:32 +0800
Message-ID: <CANRm+Cx69yfmN717VGPD7oYkW=RF6ZofTN0ZqEV7=CQVUqocCg@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Disarm LAPIC timer includes pending timer
 around TSC deadline switch
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 May 2022 at 21:43, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, May 10, 2022, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The timer is disarmed when switching between TSC deadline and other modes,
> > however, the pending timer is still in-flight, so let's accurately set
> > everything to a disarmed state.
> >
> > Fixes: 4427593258 (KVM: x86: thoroughly disarm LAPIC timer around TSC deadline switch)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 66b0eb0bda94..0274d17d91c2 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1562,6 +1562,7 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
> >                       kvm_lapic_set_reg(apic, APIC_TMICT, 0);
> >                       apic->lapic_timer.period = 0;
> >                       apic->lapic_timer.tscdeadline = 0;
> > +                     atomic_set(&apic->lapic_timer.pending, 0);
>
> What about doing this in cancel_apic_timer()?  That seems to be a more natural
> place to clear pending.  It's somewhat redundant since the other two callers of
> cancel_apic_timer() start the timer immediately after, i.e. clear pending anyways,
> but IMO it's odd to leave pending set when canceling the timer.

Do it in v2.

    Wanpeng
