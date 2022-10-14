Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EB75FE7E9
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJNEQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJNEQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:16:49 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCCE237DE
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 21:16:47 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b2so3659657plc.7
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 21:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xPM7H8VCe5LlRYI2O3PDUNTvx7F/b65dUWFM3N0mAts=;
        b=DxGXzqUO2kcK4MFYJfpuIaQms12iDTlrSJOrH8dwLedxYT0RPt2j8iNpo2QzzvOxW0
         r5PWwaBWHpQY2U8CE5OsF5Yq6Rez0U13cx/OsEWXApyahLb3fwHZ8x5hQxltgNftbprO
         UAYiylu9w3MhNd2ix8+xMYMz26pElI7jOW2m1aROHz91MOE8oX23Xsmd0TX84MPLmJKA
         gGxTStGmmWzXAX8CM71x4+UAMASAwdHU0mHrH1XQ/HQfFd9RnSkpd28sYJa2f5iHN0It
         i53/i3HFTcba8h/ohl9yYAVmodkDpDwy6EtE2gRCSQoArbf4JKVAe4KCCDabxDu8gnYF
         JWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPM7H8VCe5LlRYI2O3PDUNTvx7F/b65dUWFM3N0mAts=;
        b=A3L3ChpCNbSwx8HsBdyq/SxG+0maMWrTEkC/VDeFE+JNSgSv8seG/PeFdtF8Qke371
         nnKMChuqSqostp+h4r9WTF8kb+GtgVuJbrqwMKk9MYDrZX9iLITRY/xsNRhsJPR9w6lU
         4vlTnNFmcSDsqmE0NuXkguAK2dQIOXY+3E8ZxH3mSQbudgIb6dx1Rng2yNwwtEMZEM+A
         Gsb2NVX3LFpAbjseLk3gP35OHQl/sDs6/nOc50q7xIVDKi+iK99umZTXvMwOVm3ctg5n
         lkV3EvPk7ULVq1HYZNHXUtq1zRj1zcfgkl69x0mf1bs1/IqchCSz9cqCaCDuLf7Lf7LP
         P23Q==
X-Gm-Message-State: ACrzQf3/79hQuaTaXkXgOqjPMg6fWNjow8eiYz9CFmeHicDStwFa5vzy
        91qXC8YD3EjXeYs2enYDausmn83BHtiI4g==
X-Google-Smtp-Source: AMsMyM4LQFF9YMfsa749/qKAr4R8DhiM7rufmsp38yJkOuJKa2/YSLtLVOwXTyJU3VKtv2JAX5nGfw==
X-Received: by 2002:a17:90b:4b4b:b0:20a:926f:3c2e with SMTP id mi11-20020a17090b4b4b00b0020a926f3c2emr3406780pjb.87.1665721007319;
        Thu, 13 Oct 2022 21:16:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g186-20020a6252c3000000b0055f98a2c64bsm531582pfb.142.2022.10.13.21.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 21:16:46 -0700 (PDT)
Date:   Fri, 14 Oct 2022 04:16:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Mark transfer type as X86_TRANSFER_RET when
 loading CS in iret emulation
Message-ID: <Y0jiqr3axA49RvDJ@google.com>
References: <fcaf1408d2aaaa39b33cdd3b11bf06e7e935d11a.1665565774.git.houwenlong.hwl@antgroup.com>
 <Y0bssbjJTQVB+SCg@google.com>
 <20221013065222.GA100679@k08j02272.eu95sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013065222.GA100679@k08j02272.eu95sqa>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 13, 2022, Hou Wenlong wrote:
> On Thu, Oct 13, 2022 at 12:34:57AM +0800, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 3b27622d4642..fe735e18c419 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -1641,6 +1641,14 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
> >                         goto exception;
> >                 break;
> >         case VCPU_SREG_CS:
> > +               /*
> > +                * KVM uses "none" when loading CS as part of emulating Real
> > +                * Mode exceptions and IRET (handled above).  In all other
> > +                * cases, loading CS without a control transfer is a KVM bug.
> > +                */
> > +               if (WARN_ON_ONCE(transfer == X86_TRANSFER_NONE))
> > +                       goto exception;
> > +
> >                 if (!(seg_desc.type & 8))
> >                         goto exception;
> >
> Do I need to prepare this patch or you will add this directly?

No preference.  Feel free to post a patch, if not I'll get to it soon-ish.
