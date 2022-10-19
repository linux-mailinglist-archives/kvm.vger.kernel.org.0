Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA7B604C73
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiJSP4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiJSP4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 11:56:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD164160EFE
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:53:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id fw14so17271398pjb.3
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NJ+nN+QUK6RRtYPub9bp/ffhxW7yFnMip2TYPRpy3cw=;
        b=N2Lk9SxgfuZbbjp6OjFITibedJ4g2BdtW9dRhKK25Ws1I6jtLs5U6oTu6QQTzDCsxJ
         9i1+2xnDnqRs56ImHaeL3zLhOrqWKs/KrJWBjsKdQIH0C6HtolryJr2w5H4obf/u+3Gu
         UT8GvxeEgw5rOPOnoqrdafYzqqjHiG5PtiaxIwh0ynLc5XXMupOf1+sIiXgGdydIJZB7
         Od3sUClDrY30de7IzyYEcg9GVqxsJ3QNh2f2YFLUtCQRQj8NwmVeJ5pFZRrcm1mTM0wk
         F5jZXIzYeUoZsUXrfQxeW9PEI3sqVZiI2kZKMfJkOi4M1JE4W9JlTBH5WT+5Mk2/4d49
         9ybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJ+nN+QUK6RRtYPub9bp/ffhxW7yFnMip2TYPRpy3cw=;
        b=1MUV/dUid5zJ1RvRa5xY4apVVq4MqFgmtd4Eu5dg6VVBzN90Wd7PchZei0jTXno7yb
         55zPl1CAXNYIGbMQwOgnIetYQtis8t6JQk5lT+CMfgFodmrsptJK0VcX+Yl3ZthJlue8
         wxLz9t7Y7UTTACURglKleUojFCuwAO4HEHC9vdJz0/LGrmQGfWC9UbkCvXgKiiQ7NnUi
         YeEdMosSq5YDFgQsI7lgR7AbRihZGDUfBNhXvaN+HovPP24FLhKnZXvBz9AKMJ1CJ6jl
         VRDgUMLV5nwPnWkJx/GJvsTX2oKCgOrYLjsecSrovXZcuAN0G0OKCxB0a8DRB/9Ox8XR
         sITw==
X-Gm-Message-State: ACrzQf3IFGK96tmxMAyhFCkqbnk5b6JgVURkbDJ+I2ePqyWeiag74YSV
        cgVonnwoVRUJdoqlkKlc/UAsKyBqZTx4xg==
X-Google-Smtp-Source: AMsMyM6eG1cPKllv1blU7HBjND2QdoAwRjdB/G3QS5lmsok3T2psKESyu3hobHG5dpkNvAM3j+jH7g==
X-Received: by 2002:a17:902:c405:b0:181:83e4:490e with SMTP id k5-20020a170902c40500b0018183e4490emr8926245plk.4.1666194819999;
        Wed, 19 Oct 2022 08:53:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b001811a197797sm10843216pll.194.2022.10.19.08.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 08:53:39 -0700 (PDT)
Date:   Wed, 19 Oct 2022 15:53:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH][RFC] KVM: x86: Don't reset deadline to period when timer
 is in one shot mode
Message-ID: <Y1AdgCyCPINaTCgA@google.com>
References: <1665579268-7336-1-git-send-email-lirongqing@baidu.com>
 <Y0bl2WjoG12WcCPv@google.com>
 <94584fc76a5f41629febc53615f82b6f@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94584fc76a5f41629febc53615f82b6f@baidu.com>
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

On Mon, Oct 17, 2022, Li,Rongqing wrote:
> > +Jim, Peter, and Wanpeng
> > 
> > On Wed, Oct 12, 2022, Li RongQing wrote:
> > > In one-shot mode, the APIC timer stops counting when the timer reaches
> > > zero, so don't reset deadline to period for one shot mode
> > >
> > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > > ---
> > >  arch/x86/kvm/lapic.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > > 9dda989..bf39027 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -1840,8 +1840,12 @@ static bool set_target_expiration(struct kvm_lapic
> > *apic, u32 count_reg)
> > >  		if (unlikely(count_reg != APIC_TMICT)) {
> > >  			deadline = tmict_to_ns(apic,
> > >  				     kvm_lapic_get_reg(apic, count_reg));
> > > -			if (unlikely(deadline <= 0))
> > > -				deadline = apic->lapic_timer.period;
> > > +			if (unlikely(deadline <= 0)) {
> > > +				if (apic_lvtt_period(apic))
> > > +					deadline = apic->lapic_timer.period;
> > > +				else
> > > +					deadline = 0;
> > > +			}
> > 
> > This is not the standard "count has reached zero" path, it's the "vCPU is
> > migrated and the timer needs to be resumed on the destination" path.
> > Zeroing the deadline here will not squash the timer, IIUC it will cause the timer
> > to immediately fire.
> > 
> > That said, I think the patch is actually correct 
> 
> Should we set deadline to 0 when it is expired whether the timer is one shot
> mode or period mode ?

I'm not sure I follow the question.  Are you asking if this path should set the
deadline to '0' even if the timer is in periodic mode?
