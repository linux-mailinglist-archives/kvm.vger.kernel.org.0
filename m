Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E969355E2C
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 23:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343788AbhDFVrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 17:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbhDFVry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 17:47:54 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D71C06174A
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 14:47:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s21so8680942pjq.1
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 14:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fcqKGhIrl4188mNZ3hVlP9DuR2h/RaO8Z6p+Nwb4ZQU=;
        b=ISu4UvUrqXV5f8kg/0mlzG5CuSr5VPdA1FOVxNDvyFc0jtMgG9h04erzMjS+DbnZRC
         l9ENlTfwXcrQJ0X3GJor1ckQZGq6eZqgcorNIFmI99hQjA7+k1DUzcA6LDL3U+XEj1rT
         GsMljN3vSvdRrGTbm/BoX24BU6Xm45722VqzPVhamFRf4Fvr8ymov7yv6zlkMx22GqdV
         /SM/fusMQAUZ9/u89EUYGhp5ZTSyPuhjHjUi1XtSXVZ4JwGzpUVan2n69bHXOAaxnyH3
         ZrsPU8GjG5JqsobI65/f6pW8l3+4WjOdOg5oLrVguJvFAfc3jh+ItJGn9x3T/CZiWECb
         YFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fcqKGhIrl4188mNZ3hVlP9DuR2h/RaO8Z6p+Nwb4ZQU=;
        b=Xq83ROA9vls+YA4iO8Jos2KgYZfHtH3gXwdbHg4pn3b2hJWeQ4Iy2fIJ7BTRmUbgrP
         TxuRv7crnm9oz9p1QGrhbHRWp2QphulfjWm2cszckZT8eUQHtFrfwforrPS/2YsnJU4Z
         3sp0kyNpLG/Z/k8mNFPYLx49ROrxj67zjAO9WAmJtg+OGKN22l+Vo8Pc7Fo13CrNlMpZ
         5KUgXwr20sKy0QSRrV4H+iK3+IH1AgVhcmlr3PGCd5DULNeF5mF9WRj7FNbbDwFdSkZd
         kg+7ugW4j2G6UMvrqDCIv5fLGuE9o6vakw28XrCvZe6afz4SlKIur3LJYB1Ju1W4/7GO
         yplw==
X-Gm-Message-State: AOAM531JBvH1BLHrSVgJl9KM0AFoR0PlvNBVcyRtzj8/olPTDjH2HQn0
        rJSz2OdxhpJjwtNFy/XzjGUwUw==
X-Google-Smtp-Source: ABdhPJz1y2gQQsyu5FpE+bnv56hR8SsINwgnPG4t+H/SG21H9py0nQugKZhfkGCk6fr04p1ecNlSoA==
X-Received: by 2002:a17:90b:4c02:: with SMTP id na2mr202435pjb.77.1617745665160;
        Tue, 06 Apr 2021 14:47:45 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y5sm19127058pfl.191.2021.04.06.14.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 14:47:44 -0700 (PDT)
Date:   Tue, 6 Apr 2021 21:47:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Tokarev <mjt@tls.msk.ru>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Commit "x86/kvm: Move context tracking where it belongs" broke
 guest time accounting
Message-ID: <YGzW/Pa/p7svg5Rr@google.com>
References: <36088364-0b3d-d492-0aa4-59ea8f1d1632@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36088364-0b3d-d492-0aa4-59ea8f1d1632@msgid.tls.msk.ru>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021, Michael Tokarev wrote:
> Hi!
> 
> It looks like this commit:
> 
> commit 87fa7f3e98a1310ef1ac1900e7ee7f9610a038bc
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jul 8 21:51:54 2020 +0200
> 
>     x86/kvm: Move context tracking where it belongs
> 
>     Context tracking for KVM happens way too early in the vcpu_run()
>     code. Anything after guest_enter_irqoff() and before guest_exit_irqoff()
>     cannot use RCU and should also be not instrumented.
> 
>     The current way of doing this covers way too much code. Move it closer to
>     the actual vmenter/exit code.
> 
> broke kvm guest cpu time accounting - after this commit, when running
> qemu-system-x86_64 -enable-kvm, the guest time (in /proc/stat and
> elsewhere) is always 0.
> 
> I dunno why it happened, but it happened, and all kernels after 5.9
> are affected by this.
> 
> This commit is found in a (painful) git bisect between kernel 5.8 and 5.10.

Yes :-(

There's a bugzilla[1] and two proposed fixes[2][3].  I don't particularly like
either of the fixes, but an elegant solution hasn't presented itself.

Thomas/Paolo, can you please weigh in?

[1] https://bugzilla.kernel.org/show_bug.cgi?id=209831
[2] https://lkml.kernel.org/r/1617011036-11734-1-git-send-email-wanpengli@tencent.com
[3] https://lkml.kernel.org/r/20210206004218.312023-1-seanjc@google.com
