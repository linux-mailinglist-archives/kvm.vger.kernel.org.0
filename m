Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3A23E8674
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 01:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhHJX1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 19:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbhHJX1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 19:27:14 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E33C0613D3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 16:26:51 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w20so1409496lfu.7
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 16:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IpS+g8UvsiLyUgpdgVvZlXwMvzb3ABnt39ksJ0ei0ms=;
        b=QxvhkwExnPz/tWcFlp6413i0rHFKRAWk6FwIR79Xm+KaIfqQvOft7zcgKjZp+EvXTJ
         ZX3wakPItvvD1wNI9SwnCChiF5OTB/0QU2rj7CKnWFX3oPEyHA8XBR1oMqge5Tp7F/Gk
         hLn3mviBbttPU0/dOkmUcLw0PKIX6gD9EJ0tl8h0eP184uUA3aUDhwxae1jj5shA42/g
         VoZkmgkl7AdhN4kpRGjuUJ5xv63BZoFbbX6dBvX+vyo3BwNMhNqerDKaCzP3ad2kkH8X
         SU+uLWtH3y/idPTg2060QaUoIbvIce5RgTZOWVi/M36qQgPR+qkFN4cqj0j2hFhh15SH
         PFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IpS+g8UvsiLyUgpdgVvZlXwMvzb3ABnt39ksJ0ei0ms=;
        b=gsfzM3fkcN+Tq762Z5k6MTyTAT2G8IzmAk4qyCaEdwsz0NL4JZcKyuCTTwo1qFsOg4
         EAwMbnzmh5vDEXfdiNkeYsjrDIogKt8BGTdEtAqbJshpn++dKJrqAhkLEeVaelY2mmcY
         5R2KE48qfexgzAYQP3PSkX/918/W1xgG2+6HlBFhn7UpxVZRNKEbVrG0KgRP7mQZmzod
         M+ZtcpM2Wwb8tOIg3fIvNN27hrtEYkUvReoLn6DrgK5YBAh4f+jSFZDR6gyU+P4hjAr5
         wFSBlkJ1o0sG4swGHQTRl12ShXAblDyz7haWiHHO1qZjLpXyUp5WXpFFIqNAxfbKpiqN
         Do9Q==
X-Gm-Message-State: AOAM530K/W8Q4yOScrSFcV5r2i3i9nHNUSyezWBF0ZfPh8mVscSkKn0R
        Ms0H51yjV1y5fdHhaO3tN2nqEG1N/giChKkC5KtLrA==
X-Google-Smtp-Source: ABdhPJx1KBXlnWNnAiYPtByvCPAUGB6rQIpnAmgTrV7HDzSBU8i66K5pas2kI5wSd18D2DuqiSzloOUi0mUKH/riftM=
X-Received: by 2002:a05:6512:4025:: with SMTP id br37mr2238361lfb.23.1628638009569;
 Tue, 10 Aug 2021 16:26:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210810223238.979194-1-jingzhangos@google.com>
 <CAOQ_QshcSQWhEUt9d7OV58V=3WrL34xfpFYS-wp6H4rzy_r_4w@mail.gmail.com> <CAM3pwhE=JCVrGoh3qJtxUYfjSB8Kfax+NKkqK_fVn6_1nU7OZQ@mail.gmail.com>
In-Reply-To: <CAM3pwhE=JCVrGoh3qJtxUYfjSB8Kfax+NKkqK_fVn6_1nU7OZQ@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 10 Aug 2021 16:26:38 -0700
Message-ID: <CAOQ_QsjS8tgx76Q3GDZO2UcA8XtFoUyZUjUhSk92Ei6baGn+kQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of
 dirty pages
To:     Peter Feiner <pfeiner@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 4:15 PM Peter Feiner <pfeiner@google.com> wrote:
> > Races to increment by a few pages might be OK, so long as imprecision
> > is acceptable, but decrementing by an entire bitmap could cause the
> > stat to get waaay off from the state of the VM.
>
> My original use case was to know the rate at which memory was being
> dirtied to predict how expensive a live migration would be. I didn't
> need full precision, but I would have needed a bound on the slop. A
> "few pages" isn't a bound :-)

I think the agreement with VM-scoped statistics is that slop is OK,
better than paying the cost of locking/atomics. If we want to be
exact, it'd have to be a vCPU stat.

> IMO, this patch isn't worth figuring out without a use case. It's
> complex and has perf overhead. Maybe just drop it?

Knowing the approximate rate at which pages are being dirtied would be
a nice-to-have for debugging, IMO. Just treating this stat as
monotonic would greatly simplify it and avoid the overhead.

--
Thanks,
Oliver
