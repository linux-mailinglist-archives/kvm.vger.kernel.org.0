Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100FB29E780
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 10:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgJ2Ji2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 05:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgJ2Ji1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 05:38:27 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF51C0613D4
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 02:38:27 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id o14so1708187otj.6
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 02:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Egb29gKTqFSxWvJdyyI+gXsFyuWERrGbUzIe36GvMh0=;
        b=WN/T3qojfZLOiwWrcArWiy5sVDza4QAlNXW9uwA8epIyHde70y+LwP9IzcHYl+6ykJ
         TAk8UrMTzmau/HOuQondzD4ErZSwoLwV9gqj9wxMlA+Nc7EpAQq6Kw0NuRKGuGv3z2Q3
         wXk6V662Zo5+uF5oqJou8URYRaL/kPvUOFj5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Egb29gKTqFSxWvJdyyI+gXsFyuWERrGbUzIe36GvMh0=;
        b=RAnQ8VoDxjLaFeQSrbPJNcm/2HKWnZCdIAGG+zaEaxsEdNqNxEHJ2G8Tg9NK9yNpgq
         2VQgcYKGgbpFh7IjRxv1WUa6aRjqz3xvCzpY4T+alHZwxnD7Uj1HcvWeIhvqLojvgTeO
         rpuhu+TZqFog4TexXluyIrto1NNiB/aeBGHETITwi8vugVfaFB+xx34lxFXOHU05qagO
         kij+A270kj1bJ+afN75gfbpuyYDEp40T1A/VaWjjDc7fiDrf9Es1mQsYpFbZ1gKAeuig
         NdLdcoV5mM20bQXeYE9tlXEPhv+uJWpq0ev7FOly8+V/OSv34j7VRqLzSQhRg/Et2Bm/
         xnEg==
X-Gm-Message-State: AOAM533C1nbAivoG2ilfI5Iwb0/unOhTc2tl6l9QrEPy3lAbFTp0cbNX
        94XX0Pm3re6d2DmM3pfslFirROaKZP4iTjOywUwtpg==
X-Google-Smtp-Source: ABdhPJx7W4rK7T8Tetk1+e1/J1/olWsPDBEjgbzX/L+3bK6RKH7lBWpMwtzMdyCSKSKNvm+bdKwtPXqJrc1sPDUR5+Q=
X-Received: by 2002:a05:6830:1c3c:: with SMTP id f28mr2715883ote.188.1603964307018;
 Thu, 29 Oct 2020 02:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
 <20201029085749.GB25658@infradead.org> <CAKMK7uEV7sQ48w1Dd=WCY1r6LrY+aEq3ASnouOebQoo=Zr=CTQ@mail.gmail.com>
 <20201029092800.GA494@infradead.org>
In-Reply-To: <20201029092800.GA494@infradead.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 29 Oct 2020 10:38:16 +0100
Message-ID: <CAKMK7uG=R2372bVTK1Zh+P7uRd2QJSw5EgcJ6JJwVtNyJ7SJtQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/15] follow_pfn and other iomap races
To:     Christoph Hellwig <hch@infradead.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 10:28 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Oct 29, 2020 at 10:25:16AM +0100, Daniel Vetter wrote:
> > On Thu, Oct 29, 2020 at 9:57 AM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > Maybe I'm missing something, but shouldn't follow_pfn be unexported
> > > at the end of the series?
> >
> > kvm is a legit user and modular afaict. But since you can't use this
> > without an mmu_notifier anyway (or digging around in pagetable
> > locking), maybe it should be EXPORT_SYMBOL_GPL now at least?
>
> I think it should then take the notifier as an argument even if it isn't
> diretly used as a safety check, and get a new name describing it.

Hm so Jason and me discussed this, but e.g. the s390 is safe with with
just the pagetable locks. So we'd need two versions.

The more practical problem is that I haven't found a reasonable way to
check that a passed in mmu_notifier is registered against the mm we're
working on, and without that check it feels a bit silly. But if you
see how to do that I think we can do an EXPORT_SYMBOL_GPL follow_pfn
which takes the notifier, and an __follow_pfn for s390 and similar
internal code which isn't exported.

> EXPORT_SYMBOL_GPL is probably ok for now, but I'm drafting a new
> EXPORT_SYMBOL_FOR_MODULE() which will export symbols that can only be
> used by one specific module, with kvm being a prime user due to all
> the odd exports it requires that aren't really the kernel interface by
> any normal means.

Hm yeah that's another one. There's also some virt stuff that's
currently on unsafe_follow_pfn and needs to be switched over, and I
think that would also need an mmu notifier of some sorts to close the
gaps.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
