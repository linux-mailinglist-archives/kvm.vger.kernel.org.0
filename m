Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2302CE16D
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 23:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731697AbgLCWNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 17:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCWNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 17:13:08 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2266C061A53
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 14:12:22 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id u19so3805153edx.2
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 14:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bKhCstt4LI00tAA1/I8UmId9d82cpn40uOIiWSbRBis=;
        b=QzlwGj9S7OxKZ2+3ymIUaXpnNrcyLk+7ld0r+j7ZH1nJZTxFxEeixOFyFCURiV1Kyw
         3Y5IqlNWJBREyhItL90yoJIemUmE5rDRvoMm7bJfP2WawnwZu3bMGz20xwfdYMvciXhN
         2+Po3yJU5oHj4W8W3RJtPfDZcBXSdvMNpNyQzCfgoSkz68LkrOK01BE6z/YCiJug9Lz2
         yAr7cmkR7ZduCv956Ab7p/FgdbO6tcrpMXrkzITEj65IA0FJX/c6BA07uc7N1vKj8gbR
         a8dPASUh+vdekQw0jYksBgofCMqkD8Exc5y0/q0d6q0CAOlNG06hpacNTypMjAl/BNmo
         dysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bKhCstt4LI00tAA1/I8UmId9d82cpn40uOIiWSbRBis=;
        b=IURgHFb+zz+dTksrSI9GAenkimGh6U6CQ+Jjh2JPRNRD19eFbrdSeyrku2hEjZfJUw
         mmWHrlpurpXS0+0JkOd/u6Fmfr5gPhBIskR3bgLlopNjO1GnHpA7m9BZHY+eVIy7De4D
         VSY/XayliCqZ02kV6tIg+PlDfQcxi2VMLqO/IegWy0vt+YtZgRKlCjtzmImmYSWpyqAW
         nKjbh21kJOmguyhtTgdX7coW/L8RCsdrNiOh2rksMNbHprfQu1dX11l2wfZgHwMEMOcQ
         zeGY72ArtFpzNqlpvWQoqVVsn7K+sd0y1dvRS7Gv0x5Wb7MvdH5HA0FQqq7VrWM81w5E
         Pdsg==
X-Gm-Message-State: AOAM532Udqq5ry6/YU+3gBf8WkNFg1cxta77UvHswQzWKcbGflis1QEX
        CihHDgTmjtBYwk796nq/3Luo3SsdbXXpLwaneeuJbQ==
X-Google-Smtp-Source: ABdhPJwSosJqWfHH2u4oURDm6N9uJoHHqhNu53iai2SyRZrQaH3rS8lwBgaQlnzH7eCrbgfxb8Sd6JGIicsDi9SnTYY=
X-Received: by 2002:aa7:df91:: with SMTP id b17mr4998991edy.272.1607033541096;
 Thu, 03 Dec 2020 14:12:21 -0800 (PST)
MIME-Version: 1.0
References: <20201012194716.3950330-1-aaronlewis@google.com>
 <20201012194716.3950330-5-aaronlewis@google.com> <CAAAPnDGP13jh5cC1xBF_gL4VStoNPd01UjWvkDqdctDRNKw0bQ@mail.gmail.com>
 <1e7c370b-1904-4b54-db8a-c9d475bb4bf5@redhat.com> <CAAAPnDFpfiYRs7GZ0o0wSXdzD2AFxLy=XOhRyhcEaQKmaYJzGw@mail.gmail.com>
 <71f1c9c0-b92c-76f9-0878-e3b8b184b7f0@redhat.com> <CAAAPnDHkZaPZP6ht3y1A5mXkP=T6mDppy-zygKje1Hs5s8huWw@mail.gmail.com>
 <db1e99c9-e328-53bf-45de-dd15585d3467@amazon.com>
In-Reply-To: <db1e99c9-e328-53bf-45de-dd15585d3467@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 3 Dec 2020 14:12:09 -0800
Message-ID: <CAAAPnDG-LNJt1v2R+idi8DS6mUbNioU2fNuK7GKa3Hx1fo7YYA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] selftests: kvm: Test MSR exiting to userspace
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >>
> >> Yes, I'm queuing it.  Any objections to replacing x86_64/user_msr_test.c
> >> completely, since this test is effectively a superset?
> >>
> >> Paolo
> >>
> >
> > Hi Paolo,
> >
> > The main difference between the two tests is my test does not exercise
> > the KVM_MSR_FILTER_DEFAULT_DENY flag.  If Alex is okay with that test
> > being replaced I'm okay with it. However, I wouldn't be opposed to
> > adding it from user_msr_test.c into mine.  That way they are all in
> > one place.
>
> I think that would be best. Would you happen to have some time to just
> merge them quickly? It's probably best to first apply both, and then
> have one patch that merges them. :)

Yes, I can merge them.

>
>
> Thanks!
>
> Alex
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
