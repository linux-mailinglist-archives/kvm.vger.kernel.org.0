Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DD560C066
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 03:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJYBFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 21:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJYBFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 21:05:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3668A6DF
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 17:08:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so5007374pjc.3
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 17:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zz/BZ8N7gBJCXtTyLz8hkK9A2LBqOfEuEbnt41CX/DI=;
        b=tdFfG/N89ItBUway03bB+0x26d36PbThzPpfehyOgLe5nKcmbVXHl76egRTvntYvSD
         lo1RrrkptseBZ9q3Q0bXuqpP7rqL28hiRFW3iqUntjVQHVKMuPl5iEVaeMOLUqCanIso
         Ix+3+iN/7KuSjeKpBMiaehfiyx6Wol3mTz0mx8PmeaZr793jxI5zBFoKiDqvuWNHTko8
         dwECAAwcgC7iVcOYUMfPC0KRYoftv3YX8HA7Mmx+vfLRodMLiVIJzDHh9vwDzGR128dn
         F/iz4N1fdnozp2SB2okHNC4Wb+TDd7CqtnKyIdvITzHgJJ0RAPqWrKTf1CyCqrIC1Xig
         +opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zz/BZ8N7gBJCXtTyLz8hkK9A2LBqOfEuEbnt41CX/DI=;
        b=NoUnlZBvj/TNGbdvvqd827RnITWCli2FIpb/wBOgmvdnCs7IpiCANLLXQXU2IEPRex
         lnM7M9PafA2tX3+kCKxK/mG5dbPSQFPmIJ5uvjeKwMAMVL+YM+IfDiFUClYoU3olE65L
         i2jQ7YX6AJxRvCQpd+Sitp118+6gtpiTY1/tbicO9l/EGd9yW5II8oy/pqfcVXHnFWPM
         PdUalnsz3hvY7xZaof0maeo1HTakDQsTdE6VQwUKG+OHK9taF+Ef3MbRwNq9S2oqahkV
         Yvq0DHtcYtppVepd+mvLn6P1ht4O5Oq2HR5xPBFhTXbAx++ISlZRMzzLbGiUnbgiiP2/
         BBaw==
X-Gm-Message-State: ACrzQf2KeI7cqgRhtlGss4QeT44pFXYa+DJ2vFiil08EYvZAs+/wTNuD
        +N7WxiXM3k0oL9ElYzRlptYfBtHFoNDa/A==
X-Google-Smtp-Source: AMsMyM5Mijhq5j98jv3SqoErPAzXEHj8QwmSNXJTOqlBp3h07Iz6139AjvUK6+BQyfJFiQUqGqrsxQ==
X-Received: by 2002:a17:903:189:b0:183:7473:57f1 with SMTP id z9-20020a170903018900b00183747357f1mr34218440plg.28.1666656514962;
        Mon, 24 Oct 2022 17:08:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f54c00b00179f370dbfasm271215plf.26.2022.10.24.17.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 17:08:34 -0700 (PDT)
Date:   Tue, 25 Oct 2022 00:08:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
        bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1co/8GnSU7C+M0n@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com>
 <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1ckxYst3tc0LCqb@google.com>
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

On Mon, Oct 24, 2022, Sean Christopherson wrote:
> On Sat, Oct 22, 2022, Marc Zyngier wrote:
> > On Fri, 21 Oct 2022 17:05:26 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Fri, Oct 21, 2022, Marc Zyngier wrote:
> > > > Because dirtying memory outside of a vcpu context makes it
> > > > incredibly awkward to handle a "ring full" condition?
> > > 
> > > Kicking all vCPUs with the soft-full request isn't _that_ awkward.
> > > It's certainly sub-optimal, but if inserting into the per-VM ring is
> > > relatively rare, then in practice it's unlikely to impact guest
> > > performance.
> > 
> > But there is *nothing* to kick here. The kernel is dirtying pages,
> > devices are dirtying pages (DMA), and there is no context associated
> > with that. Which is why a finite ring is the wrong abstraction.
> 
> I don't follow.  If there's a VM, KVM can always kick all vCPUs.  Again, might
> be far from optimal, but it's an option.  If there's literally no VM, then KVM
> isn't involved at all and there's no "ring vs. bitmap" decision.

Finally caught up in the other part of the thread that calls out that the devices
can't be stalled.

https://lore.kernel.org/all/87czakgmc0.wl-maz@kernel.org
