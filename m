Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A602A2B11
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 13:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgKBM42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 07:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbgKBM4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 07:56:24 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398D9C0617A6
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 04:56:23 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id n15so12457471otl.8
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 04:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U5ses3L4S0EGFIO147NO/jaN4EloOqduj8AeaQfFuV8=;
        b=T3p+MSLRVTQeTCxHlv2KtbWAgQXYXjF/NQ5vZEZ56cGWMPWmhzeFc9ZhAf24TyMNJy
         X8ZVYO+h7DmQjzrCGnwO7PCiNeRaaOGSFYoXqqakqdoymjMzjnu9kMLe6DLLbyq0pqc5
         IQ0xty7dRJBPKhniovuUncjzErvz8QtDqXg1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U5ses3L4S0EGFIO147NO/jaN4EloOqduj8AeaQfFuV8=;
        b=Joh5NfTI4JvcX6+LLV+QetJaKgxhFqxKg906Qe2xRKN5gFpLtQV5cFhrjG9GZvfP1T
         hkFc4OPyLWZC0UKkmmC+d4USvszeeMFDLteYrJD5rFOAu1zKCJjktMW27qGaG7dFaUf5
         rvcQiMuMsQnhq5fVPdzcBgkGMhcsEfaGSSWTdYolNS+ayv01vhyN2szYuRmblmN0xjwJ
         gt4Zzl3n+O7vCou0Zsbes+iAkxRwx2W4LAY4dWUP7y2+dH1KvqioCpFZFqdwycniUCto
         7AnDuM+87+zYJ3DpwMYj4oa6hwSOFfPMAqRyWPPjWpufUL6+5hje1d/Tv5LuXi8rYvXX
         gARQ==
X-Gm-Message-State: AOAM532zfemRSWjOEOPuwqJ6fIgQOfsW82cDpj4lRYSzYUI8zBz9K1t8
        TdPe8kK+ORMLio99gEX+yczWlvvLkqmN3/D048eJHA==
X-Google-Smtp-Source: ABdhPJxuikM8EweOBXPqOBWXx8bGKhMyIqIExlZHbYHppkEx5/UodSudDdaWfAmFL8eR0NFLmbTm21/CfypVpUHeCk4=
X-Received: by 2002:a05:6830:1647:: with SMTP id h7mr12585840otr.281.1604321781980;
 Mon, 02 Nov 2020 04:56:21 -0800 (PST)
MIME-Version: 1.0
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch> <20201030100815.2269-9-daniel.vetter@ffwll.ch>
 <20201102072931.GA16419@infradead.org>
In-Reply-To: <20201102072931.GA16419@infradead.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon, 2 Nov 2020 13:56:10 +0100
Message-ID: <CAKMK7uEe5FQuukYU7RhL90ttC9XyWw6wvdQrZ2JpP0jpbYTO6g@mail.gmail.com>
Subject: Re: [PATCH v5 08/15] mm: Add unsafe_follow_pfn
To:     Christoph Hellwig <hch@infradead.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        "J??r??me Glisse" <jglisse@redhat.com>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 2, 2020 at 8:29 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Oct 30, 2020 at 11:08:08AM +0100, Daniel Vetter wrote:
> > Also mark up follow_pfn as EXPORT_SYMBOL_GPL. The only safe way to use
> > that by drivers/modules is together with an mmu_notifier, and that's
> > all _GPL stuff.
>
> I also think it also needs to be renamed to explicitly break any existing
> users out of tree or int the submission queue.

Ok I looked at the mmu notifier locking again and noticed that
mm->subscriptions has its own spinlock. Since there usually shouldn't
be a huge pile of these I think it's feasible to check for the mmu
notifier in follow_pfn. And that would stuff this gap for good. I'll
throw that on top as a final patch and see what people think.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
