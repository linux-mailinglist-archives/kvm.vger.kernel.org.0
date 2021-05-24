Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EEF38F63E
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhEXXbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXXbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:31:22 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB1C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:29:51 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 66-20020a9d02c80000b02903615edf7c1aso4970780otl.13
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ti4cgFrJdpvqYbMYrp+IlnSpYCTJp9eMSxEDADNx2No=;
        b=Mx5H3mnj7w+wvY0Hsy5o4AnoyKLfSSOqLoA+41srDK54Ms/ywomrVqeXG5LDfOxoa2
         juU9CV8gMxJIKqUyCzKzKInzyHhqfRImrszaB1SGi+o1cPKj0A2Tu7wwmKBvqgloQ2JF
         MuuT9gWj/NlDMyNd+M8qu1XyWMmaC6Uu3ZmCJaA3TtKxChPlnEVFbKskekr9gO9wIG02
         TYNJgqcs+W8gSfxZumpe6pcCD16A2NriYwBg5Vo8ziJAZ9tB8uq7agUhGm/4YoYwMhT9
         jUjSdVy8CPWAR1U0hnLg+PGnzpGefAA2wPM51y6VOAXvoZ1HK3a+h2Sb1DEDBrXGxOQ9
         7iyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ti4cgFrJdpvqYbMYrp+IlnSpYCTJp9eMSxEDADNx2No=;
        b=Nl58Qu1YZYJTM6sFhXUErdNDktMNphpiovqPBXycM6DJBCt8YHnC1KQ9jxR3M0ZgQg
         TvmpPvOKAv8L3rdegk03g9mvLeZ8PKs/eM+k44oNOe27sId0In9Un+/1WJ1cOYri5THl
         JVBz8R2ZLswPp5G6HtUrYP+yF0AyoPS7tbbQeWDrNHBz4ioQjFeAkSBHk37yR0reBIRL
         cX8DIoh1OgEAkZwjaXV7w8mzsheXPIq34pcuanzsOqkznHjzeSXEcq9ywyN2hnaFFgup
         6xEOVxFyBFCFlDHVlsIxDGSK3+tNe0rKvkkrLsDDWCUf0DxL6J62P/s8ajk5UimtbRXh
         sVGg==
X-Gm-Message-State: AOAM532nZeRmrS4kwiQA7fJfi834lUsXvnKih5lMAdZzS5og9rlK+w++
        ESo+u0VWEbJplZrmhmxBXlQh+4MrGVO76nn5GUgTwQ==
X-Google-Smtp-Source: ABdhPJyK5op8Y5YWWsd6zVPg85iXedDYKq9mT6ig7L3VZcIG786KQ2o1kpYu3mKl9epztlQ7Cw37t/pr7PlvHEb1oKw=
X-Received: by 2002:a9d:684e:: with SMTP id c14mr20833064oto.295.1621898990579;
 Mon, 24 May 2021 16:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-3-jmattson@google.com>
 <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com> <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
 <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com> <YKwydQlAXHeockLx@google.com>
 <CALMp9eRQXwpM8N6BzrY+gt0cPCCxYuf2UVgdgxjEN6=SrgTkjg@mail.gmail.com> <YKw1vEzfWG0dPhNM@google.com>
In-Reply-To: <YKw1vEzfWG0dPhNM@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 16:29:39 -0700
Message-ID: <CALMp9eQL_VwYEz8YTg8kQWprmAZSyqDAyCTuXvtNzKMTEza3HA@mail.gmail.com>
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when kvm_check_nested_events
 fails
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 4:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 24, 2021, Jim Mattson wrote:
> > On Mon, May 24, 2021 at 4:10 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, May 24, 2021, Paolo Bonzini wrote:
> > > > On 24/05/21 18:39, Jim Mattson wrote:
> > > > > Without this patch, the accompanying selftest never wakes up from HLT
> > > > > in L2. If you can get the selftest to work without this patch, feel
> > > > > free to drop it.
> > > >
> > > > Ok, that's a pretty good reason.  I'll try to debug it.
> > >
> > > I don't think there's any debug necessary, the hack of unconditionally calling
> > > kvm_check_nested_events() in kvm_vcpu_running() ...
> >
> > We don't unconditionally call kvm_check_nested_events() in
> > kvm_vcpu_running(). We still call kvm_check_nested_events() only when
> > is_guest_mode(vcpu). The only change introduced in this patch is that
> > we stop ignoring the result.
>
> Doh, sorry, bad use of "unconditionally".  I meant "unconditionally when in L2". :-)

Again, the conditions under which we call kvm_check_nested_events are
unchanged. The only "hack" here is the hack of not ignoring the return
value.
