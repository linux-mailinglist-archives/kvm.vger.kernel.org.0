Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6690867DCB9
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 04:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjA0DuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 22:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjA0DuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 22:50:14 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11E359B78
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 19:50:12 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id 22so1907042vkn.2
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 19:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GrQMLPA2+6YJ2nrnlqQhHB+M1ekzvtKiEZXAuyk27TU=;
        b=hJct9Tl+rIs1BfCLM+aaHnrRvZ7/fj2NAOfbyyP+oXHmoNLLryLegV9Am9PHnmyuYi
         m+6f3bNJHrkgnBcWyuZCPwUTU0fCWiyhPnJ5thHn08FlsWUQXm+YnmpYEUkS6wdq1whP
         S6czdWwx+2lnhgi0Le+L2z6R6zTWdUHONXRdXovwWn/nRZpeXG05vi2HP8YArCulDLwh
         7JELNsmOJfRJCI8Me/SfqjFC5zYwtakpbTilFls927W3IoBt6mD1NH9DQ9XGfhul4RW+
         YX3LTk+gVOci3TE/2X1HEKkY9gu79w9cOYnLBvenC2rhAX1SPgL6m1/f6rKcnZLzPn1U
         WaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GrQMLPA2+6YJ2nrnlqQhHB+M1ekzvtKiEZXAuyk27TU=;
        b=SP6rfPg0FQWqnuSd8Y53KMG8Me3Mimd9XT6RBkGIPXJYmd1xUSN3EOEsN342bGhAEU
         jQC6OjemwfgzG3tebXl6A7hfh5TpEEYt7xj4PZBb6N28/xzIlgbgA5DOXVkxGodFyH2C
         ouR37iGFzCCNQHRRQxp2erOTUGBRtkIzDi+BlOqkn0/kemUNa8W57ntEj/P9J3xpqTWZ
         nG6u09vPGNp4Qvf6mEOThcdjlvZNrzY+/BxpkdLyOFl6ODzKM9WpDBVCS1rFoyrDVs3D
         v040cHqQC8wl7amirFkYGhH20FAcykZ571PRFLiLkyzz8tu5qzSxcJnBoW80yzA9jRk9
         h4CA==
X-Gm-Message-State: AFqh2kpThgA/vNA7woSRIgwR2IIQN3E2Psq0RySRHWBSqP6KeokdAana
        6jfawVuKGHK6v3h6lA1KbkT6bkpWDBmZYlMKbgDRIQ5MyDj6PwWj
X-Google-Smtp-Source: AMrXdXsXebuQ2QERobwmPTcWNxNO0CpUGZswZKOvF78Ux5WxRkq3PuMA0audZdYFiVWU4aX6w6+jUrQYaWo41FB1pfU=
X-Received: by 2002:a1f:5945:0:b0:3d5:9937:886 with SMTP id
 n66-20020a1f5945000000b003d599370886mr5094133vkb.5.1674791411914; Thu, 26 Jan
 2023 19:50:11 -0800 (PST)
MIME-Version: 1.0
References: <20230126210401.2862537-1-dmatlack@google.com> <Y9MA0+Q/rO5Voa0D@google.com>
 <CALzav=dXWkX7aFga=T9fk1auXcArECLXMOEotWnGODeGVL44iQ@mail.gmail.com> <Y9MulRF8QXEiGIog@google.com>
In-Reply-To: <Y9MulRF8QXEiGIog@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 26 Jan 2023 19:49:45 -0800
Message-ID: <CALzav=e2udiG0q4Hz_GbusfbNZowBZVuinCdCwO1vCJ63fnvWw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Replace tdp_mmu_page with a bit in the role
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Jan 26, 2023 at 5:53 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jan 26, 2023, David Matlack wrote:
> > On Thu, Jan 26, 2023 at 2:38 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, Jan 26, 2023, David Matlack wrote:
> > > > Link: https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/
> > >
> > > Drop the trailing slash, otherwise directly clicking the link goes sideways.
> >
> > I don't have any problem clicking this link, but I can try to omit the
> > trailing slash in the future.
>
> Ha!  Figured out what happens.  Gmail gets confused and thinks the forward slash
> indiciates a continuation, e.g. the original mail sends me to:
>
>   https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/Signed-off-by

Ohhh I do see the same behavior when clicking the link in my original
email. The copy of the link in your reply had nothing on the line
after it so clicking it there worked just fine :)

>
> I bet the above now works because there's whitespace. For giggles....
>
> https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/
> will_it_blend
