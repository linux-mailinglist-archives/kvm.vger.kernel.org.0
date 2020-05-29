Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508D71E7D51
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 14:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgE2MeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 08:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgE2MeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 08:34:08 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E76AC03E969
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 05:34:07 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s19so1576866edt.12
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 05:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cPeigCK2KYvMiq+sG6KOj8Q7ndlYO2BcnUQP68RJYdw=;
        b=dYNCwrc6IlS6OKS+HOUMs4HsVIYIFLl3Gqz0TZPCqS9Ciejf3uEtVff4+mgBC61GXT
         NJ/hJPkBr8k58Qzihx7KUMfArdD71UUqclR2W/iM9FLIOLjMEXLVyv6plFqv1dWzEWQ9
         /hOfJz1qPlzSRqe7UWMHr1HOday4CmE9WpEpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cPeigCK2KYvMiq+sG6KOj8Q7ndlYO2BcnUQP68RJYdw=;
        b=gIsu6BG7KycR83DymBgJeib4bhNJYNzNt+bUzjJz9DYjpSh4J/nw0K1S/LPDOvJKDQ
         lpIsvfhDPPoo5an2O0Um7Q+lMEvq7YYGJ3YfosmqJboeFsm6wLm9433LO024F9VowtQ9
         FbLk2F38+yc26cxPTiPiqX3P+O8z3HotJ5lp4aV1CzRntDp2FzNbPsJsGbIiMPh/ppfH
         agEx6BB1sSEk/w+EdZqtULLpM5HxASNJ1+adVHDOTSqfP6QMJ8mvvde/arHsLG6dEdzw
         bXrpa+vW0uzVIjbhHXNaMVpbuUNd+BmoUVWU3vJup1If4m+MuDup5ygbUIdOI5jLBJsM
         iC9Q==
X-Gm-Message-State: AOAM530O1LLzQSfmYEOKF5B3J9jATn+rstjgxLrNSgYZ/3Q7R9ZZ2i/2
        S9qUYG1bkUNBGvlBQCxxPr2uHHFnPnPYnvTWojwnxQ==
X-Google-Smtp-Source: ABdhPJyUnTM45zN0/5rNoZumMBq2dmAT3t3ZWSRcUjdBPA2OW7R/LUnUGuKWy/5vRX1XdxS74d3SlLrqc3MOIkpgBnE=
X-Received: by 2002:a05:6402:17f9:: with SMTP id t25mr8224125edy.134.1590755646368;
 Fri, 29 May 2020 05:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegstNYeseo_C4KOF9Y74qRxr78x2tK-9rTgmYM4CK30nRQ@mail.gmail.com>
 <875zcfoko9.fsf@nanos.tec.linutronix.de> <CAJfpegsjd+FJ0ZNHJ_qzJo0Dx22ZaWh-WZ48f94Z3AUXbJfYYQ@mail.gmail.com>
 <CAJfpegv0fNfHrkovSXCNq5Hk+yHP7usfMgr0qjPfwqiovKygDA@mail.gmail.com>
 <87r1v3lynm.fsf@nanos.tec.linutronix.de> <CAJfpegt6js2WK6SjSZHsz+fg7ZLU+AL6TzrsDYmRfp7vNrtXyw@mail.gmail.com>
In-Reply-To: <CAJfpegt6js2WK6SjSZHsz+fg7ZLU+AL6TzrsDYmRfp7vNrtXyw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 29 May 2020 14:33:55 +0200
Message-ID: <CAJfpegtH7C0cu2iPv8gLq5_+=U3-XWZ3XRsP64h6Gbx-qqyZTQ@mail.gmail.com>
Subject: Re: system time goes weird in kvm guest after host suspend/resume
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 2:31 PM Miklos Szeredi <miklos@szeredi.hu> wrote:

> > Can you please describe the setup of this test?
> >
> >  - Host kernel version

5.5.16-100.fc30.x86_64

> >  - Guest kernel version

75caf310d16c ("Merge branch 'akpm' (patches from Andrew)")

> >  - Is the revert done on the host or guest or both?

Guest.

> >  - Test flow is:
> >
> >    Boot host, start guest, suspend host, resume host, guest is screwed
> >
> >    correct?
>
> Yep.
>
> Thanks,
> Miklos
