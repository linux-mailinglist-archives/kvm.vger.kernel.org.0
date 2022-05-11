Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA15522CEF
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 09:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbiEKHNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 03:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbiEKHN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 03:13:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD9FB1059D3
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 00:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652253206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sQHjzpYWUbx4DIbzDfueaE5axYdznIwfVWGZh8Ng7j8=;
        b=E1TAumzSrApuYqQD3z86Yinh8vhSe8J71/qC4BqJWXtDhff2LdYp+v1AZiv9zFvasWG0wo
        /LimWa0HmJQ6W4ZbRQnWSjgx34fhyUOgsRULko/p54EJnBBQ6RmxtDBFYB+KTi2RLz4Icy
        UhgSl9ajF4xtIWwqq110YOeH7xzkQ44=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-viZOICWJMvWhPqGoKZ7T3A-1; Wed, 11 May 2022 03:13:22 -0400
X-MC-Unique: viZOICWJMvWhPqGoKZ7T3A-1
Received: by mail-wr1-f70.google.com with SMTP id k29-20020adfb35d000000b0020adc94662dso470503wrd.12
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 00:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sQHjzpYWUbx4DIbzDfueaE5axYdznIwfVWGZh8Ng7j8=;
        b=Ot0AB/k2/N4vzsZK18Yhj8wFq0seKai+qgpUQ7EjlTGi3pLKW69eeS/q4e+cNHCbjT
         edlF1N6a6MrYoDbmWreQBigbzYYaXwbYmUkmKNt8cHtiq7iKtkayxWNZJPgilH7qXkvv
         /PTosQ7d2gv9N0AwWuVvAb+cAAgNJuHN6cYpx4o0rwK1oV/IrJ6YBgpt9wI0lwkevrqa
         PBFsxsWmpGVaqM7NKmoHAmJxPwKgBfkHVORKOAsCfPtRZFfktca3dkKorjtxi8Gy4vSC
         LSCn1zewdHXF5uaQ+IKbBTjHop8ldMFi5xmU0iJdOIfr4AayaIjtv8pdWKqLvMOe41PX
         IrhQ==
X-Gm-Message-State: AOAM532EANHbtItaeKwkcq0DHG3Pk7H1UHhr8D4EC5EK+L9U2C5doUVN
        6Nd7xU/qXqOQKON2yr9z47BQ1fK259uYG0EW/xZQbvYHlfvTMaNzihLPTTe9O5sb083cCngItQQ
        S6yyKUqewQObE
X-Received: by 2002:a05:6000:156e:b0:20c:5218:8907 with SMTP id 14-20020a056000156e00b0020c52188907mr21286293wrz.297.1652253201350;
        Wed, 11 May 2022 00:13:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxTTooDnLmLT4EcFTkOSjKBlkOtgpHLONSlsyygQ8QPYyAJluPBdZsBfMCA6OcI1SOoePXNQ==
X-Received: by 2002:a05:6000:156e:b0:20c:5218:8907 with SMTP id 14-20020a056000156e00b0020c52188907mr21286271wrz.297.1652253201133;
        Wed, 11 May 2022 00:13:21 -0700 (PDT)
Received: from redhat.com ([2.55.46.133])
        by smtp.gmail.com with ESMTPSA id o20-20020a05600c2e1400b003944821105esm1239510wmf.2.2022.05.11.00.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 00:13:19 -0700 (PDT)
Date:   Wed, 11 May 2022 03:13:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <20220511030407-mutt-send-email-mst@kernel.org>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X>
 <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 04:50:47PM -0700, Linus Torvalds wrote:
> On Tue, May 10, 2022 at 4:12 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > For what it's worth, as someone who is frequently tracking down and
> > reporting issues, a link to the mailing list post in the commit message
> > makes it much easier to get these reports into the right hands, as the
> > original posting is going to have all relevant parties in one location
> > and it will usually have all the context necessary to triage the
> > problem.
> 
> Honestly, I think such a thing would be trivial to automate with
> something like just a patch-id lookup, rather than a "Link:".
> 
> And such a lookup model ("where was this patch posted") would work for
> <i>any</i> patch (and often also find previous unmodified versions of
> it when it has been posted multiple times).
> 
> I suspect that most of the building blocks of such automation
> effectively already exists, since I think the lore infrastructure
> already integrates with patchwork, and patchwork already has a "look
> up by patch id".
> 
> Wouldn't it be cool if you had some webby interface to just go from
> commit SHA1 to patch ID to a lore.kernel.org lookup of where said
> patch was done?

Yes, that would be cool!

> Of course, I personally tend to just search by the commit contents
> instead, which works just about as well. If the first line of the
> commit isn't very unique, add a "f:author" to the search.
>
> IOW, I really don't find much value in the "Link to original
> submission", because that thing is *already* trivial to find, and the
> lore search is actually better in many ways (it also tends to find
> people *reporting* that commit, which is often what you really want -
> the reason you're doing the search is that there's something going on
> with it).
> 
> My argument here really is that "find where this commit was posted" is
> 
>  (a) not generally the most interesting thing
> 
>  (b) doesn't even need that "Link:" line.
> 
> but what *is* interesting, and where the "Link:" line is very useful,
> is finding where the original problem that *caused* that patch to be
> posted in the first place.
> 
> Yes, obviously you can find that original problem by searching too if
> the commit message has enough other information.
> 
> For example, if there is an oops quoted in the commit message, I have
> personally searched for parts of that kind of information to find the
> original report and discussion.
> 
> So that whole "searching is often an option" is true for pretty much
> _any_ Link:, but I think that for the whole "original submission" it's
> so mindless and can be automated that it really doesn't add much real
> value at all.
> 
>                 Linus

For me a problematic use-case is multiple versions of the patchset.
So I have a tree and I apply a patchset, start testing etc. Meanwhile author
posts another version. At that point I want to know which version
did I apply. Since people put that within [] in the subject, it
gets stripped off.

Thinking about it some more, how about sticking a link to the *cover
letter* in the commit, instead?  That would serve an extra useful purpose of
being able to figure out which patches are part of the same patchset.
And maybe Change "Link:" to "Patchset:" or "Cover-letter:"?

-- 
MST

