Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF0F5A8693
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 21:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiHaTRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 15:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiHaTRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 15:17:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4B0DA3E2
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 12:17:20 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u22so15007752plq.12
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 12:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=zHM07eO+Ah42PE786kyCsTV2son2tBDz1ynwCBNBtXk=;
        b=dIuoJFUP2Y35KD6v2SGjH0spplZBk1M2V7nqufMQvhuEkgyTgSu2+wraTtkMlK48IC
         6NUbU3PkmZa9bko5OkmBvssxs5z2dLx8nTFKXl4QVUHrUI0NKpu036zIzrkcNsNDBPKP
         VPXyiVJsrcwpcriAABRQDVYN6cpOq51do4YRgaQwjSsNFTosilC/AUspFeScVKQsnSwE
         EHPlYKc+7SD92shbf8Uf25zKXW04xG31u0pO5Kr93F/UZoUM7KZjkT3RYAgz4oPw3gbC
         Q9ta6BaKg2pZUx/LsJqSyTOsbmkWsDsYESUvBAbIaD1PBpkkZPomOQNOPNKeWktfZhMG
         NYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=zHM07eO+Ah42PE786kyCsTV2son2tBDz1ynwCBNBtXk=;
        b=PDOgjQNDEUe5qK5zDbgQfjChYQbWwpsJJDmjEkY6Q7XrQoqCxkFs87IC1X8uDSERNl
         g3qGS7yR2E+ixAj8yRBYpdQImH9Oap00kEbBqtr1F1HHsfmPxK2zaRUSYjThtH99hB9O
         rNho00pKC9CvLhr/0H27h0DFLb/0cUiQynFwOhaOWbRjztZ8TkhATCy1wRg77Twkl9Hd
         cFd2q/KVa77fN7XJhyqM6JE7qkGGeerb4wm1txAxDgN8+iFHMNCD8awvR8p8pF8vLEvy
         /lKWv+FYJhjds5w9s8EqIhq+DfsK8Lv2P1lXsLNsDMlt/nibLATIeZYVlr47oKLWT7xF
         9kMQ==
X-Gm-Message-State: ACgBeo0q6Cx+VV4mpEUURPqHYUnAYiolNvZi32UXW01Rj8E7vEAxIGn4
        8hB2jOAn75BWgOM3sMl2hW0S/Q==
X-Google-Smtp-Source: AA6agR6D+KF1IWd7yIWhXMaEh2E5+FoLRnVXYppi7/t7piE4uUH0lkBIjo14g9fUhKsgIuQQWwcczg==
X-Received: by 2002:a17:90a:ec05:b0:1fd:9368:2c8 with SMTP id l5-20020a17090aec0500b001fd936802c8mr4641721pjy.183.1661973439925;
        Wed, 31 Aug 2022 12:17:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f9-20020aa79689000000b00528a097aeffsm11604082pfk.118.2022.08.31.12.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 12:17:18 -0700 (PDT)
Date:   Wed, 31 Aug 2022 19:17:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 16/19] KVM: x86: Explicitly track all possibilities for
 APIC map's logical modes
Message-ID: <Yw+zu3t6Gob4uq1K@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-17-seanjc@google.com>
 <9c3e126bdee38bc4a0fa03eec994878aca4f3b3e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c3e126bdee38bc4a0fa03eec994878aca4f3b3e.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
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
> >  	case KVM_APIC_MODE_X2APIC: {
> >  		u32 offset = (dest_id >> 16) * 16;
> >  		u32 max_apic_id = map->max_apic_id;
> > @@ -193,8 +198,10 @@ static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
> >  		*cluster = map->xapic_cluster_map[(dest_id >> 4) & 0xf];
> >  		*mask = dest_id & 0xf;
> >  		return true;
> > +	case KVM_APIC_MODE_MAP_DISABLED:
> > +		return false;
> >  	default:
> > -		/* Not optimized. */
> > +		WARN_ON_ONCE(1);
> 
> BTW unless I am mistaken, this warning is guest triggerable, and thus as you
> say when 'panic_on_warn=1', this will panic the host kernel.

If it's guest triggerable then it's a bug in this patch.  The "default" case was
reachable with the old approach of OR-ing in bits, but the intent of this patch
is to fully enumerate all values of map->logical_mode and make the "default" case
impossible.

And I don't think it's reachable.  The case statements are:

	case KVM_APIC_MODE_SW_DISABLED:
	case KVM_APIC_MODE_X2APIC:
	case KVM_APIC_MODE_XAPIC_FLAT:
	case KVM_APIC_MODE_XAPIC_CLUSTER:
	case KVM_APIC_MODE_MAP_DISABLED:
	default:

which covers all of the possible enum values.

	enum kvm_apic_logical_mode {
		KVM_APIC_MODE_SW_DISABLED,
		KVM_APIC_MODE_XAPIC_CLUSTER,
		KVM_APIC_MODE_XAPIC_FLAT,
		KVM_APIC_MODE_X2APIC,
		KVM_APIC_MODE_MAP_DISABLED,
	};

The map is explicitly initialized to KVM_APIC_MODE_SW_DISABLED (to avoid relying
on KVM_APIC_MODE_SW_DISABLED==0)

	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;

so unless I've missed a "logical_mode |= ..." somewhere, reaching "default" should
be impossible.
