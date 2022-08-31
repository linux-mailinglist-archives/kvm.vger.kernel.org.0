Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790975A83B7
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiHaQ5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiHaQ4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:56:54 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C2EDD4F4
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:56:52 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 78so503503pgb.13
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=HdAipv40/QqUuhoEN6Hq6J9CX7+XanSXNZDP7WXuA2w=;
        b=E+dpjJqqZDnYhWyJB7NPrHbcJXnwY/FVAxgTif0XLDolthQbNU2kb5duOzTXFJRyNt
         2hw1fG/0dF2n9h3l7igOMBUOwD2I41lLkJ5A3S4SqigYhZ2F8AUr6PC7+mm5zna0OiKM
         7uSVQlx3qx8FVlP7XSuym/DhcVMW27h6f3oRVcIyKbXjcccx6adclZmABrC7J+dh5qYF
         9svm06eXHLHJKMUb1s1RGoYVAzDRYFtPIwVWRXoIMKYBYtBbgkwoUtrsKu4p7H+856ti
         3Xtm+2zdCedDRsDBZpFhZLp5JndSPq3kmB7RN63yD4rkTyjuj/KhtREr8vQwwZl4Cd0S
         SiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=HdAipv40/QqUuhoEN6Hq6J9CX7+XanSXNZDP7WXuA2w=;
        b=G0wyQe62jdt2TdL6z4jsUjUs6WHXo8Hc/3epsy2NvJ3oNJjmP+7gBaWdlE1s8VPfED
         wGqAZ4oi5jaOjgQwe8sr6qqBJKcC02PDjTQcutzCYvoiJkkKSM6GigMoy8T3ERkBcaSe
         KtXvCRCtxOt+efX6A1tNvcMAMKwzW22LfxhQCl2jYxHv/yojeC5gjtkBpm/v/vlJIiaE
         UHqQQwH3lAiNWA6yFKomHbCGaTDVKwW7W/ltX1PgTm3VH6KQVLN5wmHaNmV75gocMSC/
         ELxpsA7raITHBDODBzMpQxghpGO6myFudWm1nHWPgwWZYUBADl6XQ/fuQ0/Wh2GH8GP+
         u8Qw==
X-Gm-Message-State: ACgBeo00jm1j3AM0tEsy98thl4lfrafbNPFIWSK4oAJoEggu00uRgCHe
        BPV+fndDO3pg3zlHBrlfjPHLjA==
X-Google-Smtp-Source: AA6agR6cQdWCJj8nIL8lC0/B1orERU83CcRBe8mpU1Xnak54m5SKBPoax0iLrY8he6N8y6biTQJi5g==
X-Received: by 2002:a63:fb56:0:b0:429:983f:b91e with SMTP id w22-20020a63fb56000000b00429983fb91emr22939560pgj.399.1661965011770;
        Wed, 31 Aug 2022 09:56:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p15-20020a170902780f00b0017555cef23asm199694pll.232.2022.08.31.09.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:56:51 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:56:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 16/19] KVM: x86: Explicitly track all possibilities for
 APIC map's logical modes
Message-ID: <Yw+Sz+5rB+QNP2Z9@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-17-seanjc@google.com>
 <8d3569a8b2d1563eb3ff665118ffc5c8d7e1e2f2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d3569a8b2d1563eb3ff665118ffc5c8d7e1e2f2.camel@redhat.com>
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

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 8209caffe3ab..3b6ef36b3963 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -168,7 +168,12 @@ static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
> >  
> >  static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
> >  		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
> > -	switch (map->mode) {
> > +	switch (map->logical_mode) {
> > +	case KVM_APIC_MODE_SW_DISABLED:
> > +		/* Arbitrarily use the flat map so that @cluster isn't NULL. */
> > +		*cluster = map->xapic_flat_map;
> > +		*mask = 0;
> > +		return true;
> Could you explain why this is needed? I probably missed something.

If all vCPUs leave their APIC software disabled, or leave LDR=0, then the overall
mode will be KVM_APIC_MODE_SW_DISABLED.  In this case, the effective "mask" is '0'
because there are no targets.  And this returns %true because there are no targets,
i.e. there's no need to go down the slow path after kvm_apic_map_get_dest_lapic().

> > @@ -993,7 +1011,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
> >  {
> >  	if (kvm->arch.x2apic_broadcast_quirk_disabled) {
> >  		if ((irq->dest_id == APIC_BROADCAST &&
> > -				map->mode != KVM_APIC_MODE_X2APIC))
> > +		     map->logical_mode != KVM_APIC_MODE_X2APIC))
> >  			return true;
> >  		if (irq->dest_id == X2APIC_BROADCAST)
> >  			return true;
> 
> To be honest I would put that patch first, and then do all the other patches,
> this way you would avoid all of the hacks they do and removed here.

I did it this way so that I could test this patch for correctness.  Without the
bug fixes in place it's not really possible to verify this patch is 100% correct.

I completely agree that it would be a lot easier to read/understand/review if
this came first, but I'd rather not sacrifice the ability to easily test this patch.
