Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1ED1E79DA
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgE2Jvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgE2Jvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:51:42 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F31BC08C5C6
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:51:42 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id k8so1263238edq.4
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L3T/zrsuadN22N6xG3haLfTOv3GRzcC9OXLSwcS0asw=;
        b=CUbh2O4u401oOyVmSr+UxiVM9YNSg49tSmupSq9vlnyzdXchtsnTFrDbOIxrDtUyGz
         VSDVH7X6vU+ivzYL3XwvI7oK1CsC/TtUs62xkdxU3hZ2mfkBU782bT+WYaIVCq7vR0hR
         w6aJo45B16uDl3czX6GaTTGMMzc/uWFng7RsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L3T/zrsuadN22N6xG3haLfTOv3GRzcC9OXLSwcS0asw=;
        b=uFGGgKICZMljJs5HPaaoLxL/dGXvNoTFJxpQIfLBRKRD6WPFUwjczm44acZ2NJSlXI
         p4XMYZaPUGB54O4hVXgczoojoCOwLydZvRRnshVYCVi2uvl+doYr4pj0WwLpkdctDi1E
         CfICQ/ORCPLcLM0GieaY8JJP/EirRh47qF7nIVljATj8J6VBnZVcU/WL2j0ytb/xUGds
         rSgc4b8tEt5pXKOS0VnQ1tS3KPtpxaw7L3n3T+6HYZAcGER5FRxzPXCVtE7tDZ6IorPg
         UPpHb3WCz7NjxGkux+2uNTw3mVjHG3k/kH+bfkdfsBFbJ1tSVBCv8g4r9KW741/qm/Le
         lZQQ==
X-Gm-Message-State: AOAM533iVeoYbClddF088UXOr4oOLLDYjmS/kGxSUaLo+KJFAEu8Eytp
        vbQfHjNqQJ2OFs9usXuC0Ejlo6KZVbYE2qo4zNAo/w==
X-Google-Smtp-Source: ABdhPJxafMjOQwHwV5y/xyLtDUSv1zADexNiJH4YkI0/GygZPk4DEmeSK0M/pVVPdm/cPxsKvpsHsZoiJOp5OSRliSw=
X-Received: by 2002:a50:bb29:: with SMTP id y38mr7328686ede.358.1590745901171;
 Fri, 29 May 2020 02:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegstNYeseo_C4KOF9Y74qRxr78x2tK-9rTgmYM4CK30nRQ@mail.gmail.com>
 <875zcfoko9.fsf@nanos.tec.linutronix.de>
In-Reply-To: <875zcfoko9.fsf@nanos.tec.linutronix.de>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 29 May 2020 11:51:30 +0200
Message-ID: <CAJfpegsjd+FJ0ZNHJ_qzJo0Dx22ZaWh-WZ48f94Z3AUXbJfYYQ@mail.gmail.com>
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

On Thu, May 28, 2020 at 10:43 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> writes:
> > Bisected it to:
> >
> > b95a8a27c300 ("x86/vdso: Use generic VDSO clock mode storage")
> >
> > The effect observed is that after the host is resumed, the clock in
> > the guest is somewhat in the future and is stopped.  I.e. repeated
> > date(1) invocations show the same time.
>
> TBH, the bisect does not make any sense at all. It's renaming the
> constants and moving the storage space and I just read it line for line
> again that the result is equivalent. I'll have a look once the merge
> window dust settles a bit.

Yet, reverting just that single commit against latest linus tree fixes
the issue.  Which I think is a pretty good indication that that commit
*is* doing something.

The jump forward is around 35 minutes; that seems to be consistent as well.

Thanks,
Miklos
