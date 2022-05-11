Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC95522C3C
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 08:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242154AbiEKGXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 02:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbiEKGXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 02:23:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 950EC1FC2D5
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 23:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652250185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WwyljACqAbVlQtU4LAdoRLkrWe0WUBj5SX13dxtUmBw=;
        b=KPAqoqKPdMjtlH55V3/1X5xt8M5ellDPzfCxOqmXJXFHyt1QaFitDLpflMMBk/PuKhTJk/
        xEDhq/1Z95vMiyBmTHzPsfLZ1Adw04StC+4OqLcv3wfqoKksaB2iWHPvOwdPJ4H8LPJUCt
        ARHx5tcUtUEmUDphveBDL2ujsxgkw7Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-Pe8VWKcdM0iOfsA9QVhRFg-1; Wed, 11 May 2022 02:23:03 -0400
X-MC-Unique: Pe8VWKcdM0iOfsA9QVhRFg-1
Received: by mail-wm1-f69.google.com with SMTP id m124-20020a1c2682000000b00393fcd2722dso360022wmm.4
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 23:23:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WwyljACqAbVlQtU4LAdoRLkrWe0WUBj5SX13dxtUmBw=;
        b=xpQy7sByM4ezw0pqZa37/Z8GogexBGmaTP8fxEslyu2NWRRjKC8HThY7xY8w3xmKe6
         eqfxLbWAgbXj12BPajPz5noiYD56duC/4kG7qdUFWACOKVGZYA7xum4oKRTysLPleVpR
         8rSkYSZ0AhiMb9bzrnY3bpQ3toAR0oVQUCAcTNpOsSa7XrqHEER+K0OKg1+YXJYPmeoY
         JgIvNls3RSFkouQAKSYeudu4YulzQHl9ExwbaZP2nwgGbZba4RqZ6PrDnBp8Z7gBWK/s
         E2S7AieK9yRnMOU9VQ6xyZ3S1QOyPkIgwCTSe9U9DJ/OWhxWXGBXC4a5eLimMC7RLYLM
         R32A==
X-Gm-Message-State: AOAM533CPIPdJI6WkqVVe5psxYuEzkZuk/5ofLbNrnatIZq/j/0cjt+m
        9qOa0jALnP5UjwUFhkIiL+igjZwYhtmOlIYPWa+NXzHa0mSRW7lVmGphFY+6iNUfZuNMXSccZTd
        pJTPgWfE269JA
X-Received: by 2002:a05:600c:5112:b0:394:55bd:5f9d with SMTP id o18-20020a05600c511200b0039455bd5f9dmr3210785wms.188.1652250182464;
        Tue, 10 May 2022 23:23:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcV3T8X8kCnCQofNw+5gZoO6rnCBUJnaiWHS+ZFla1vKmmL1Rqa83V1y1VetYmuhrJXc006Q==
X-Received: by 2002:a05:600c:5112:b0:394:55bd:5f9d with SMTP id o18-20020a05600c511200b0039455bd5f9dmr3210762wms.188.1652250182189;
        Tue, 10 May 2022 23:23:02 -0700 (PDT)
Received: from redhat.com ([2.55.31.58])
        by smtp.gmail.com with ESMTPSA id p19-20020a7bcc93000000b003942a244ecesm1155431wma.19.2022.05.10.23.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 23:23:01 -0700 (PDT)
Date:   Wed, 11 May 2022 02:22:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <20220511021608-mutt-send-email-mst@kernel.org>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 11:23:11AM -0700, Linus Torvalds wrote:
> On Tue, May 10, 2022 at 5:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > A last minute fixup of the transitional ID numbers.
> > Important to get these right - if users start to depend on the
> > wrong ones they are very hard to fix.
> 
> Hmm. I've pulled this, but those numbers aren't exactly "new".
> 
> They've been that way since 5.14, so what makes you think people
> haven't already started depending on them?

Yes they have been in the header but they are not used by *Linux* yet.
My worry is for when we start using them and then someone backports
the patches without backporting the macro fix.
Maybe we should just drop these until there's a user, but I am
a bit wary of a step like this so late in the cycle.

> And - once again - I want to complain about the "Link:" in that commit.
> 
> It points to a completely useless patch submission. It doesn't point
> to anything useful at all.
> 
> I think it's a disease that likely comes from "b4", and people decided
> that "hey, I can use the -l parameter to add that Link: field", and it
> looks better that way.
> 
> And then they add it all the time, whether it makes any sense or not.
> 
> I've mainly noticed it with the -tip tree, but maybe that's just
> because I've happened to look at it.
> 
> I really hate those worthless links that basically add zero actual
> information to the commit.
> 
> The "Link" field is for _useful_ links. Not "let's add a link just
> because we can".
> 
>                            Linus


OK I will stop doing this.
I thought they are handy for when there are several versions of the
patch. It helps me make sure I applied the latest one. Saving the
message ID of the original mail in some other way would also be ok.
Any suggestions for a better way to do this?

-- 
MST

