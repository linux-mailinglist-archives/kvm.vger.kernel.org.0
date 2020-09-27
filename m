Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDD627A1E4
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgI0Qrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Sep 2020 12:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgI0Qrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Sep 2020 12:47:35 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621EAC0613CE
        for <kvm@vger.kernel.org>; Sun, 27 Sep 2020 09:47:35 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id k25so6359921ljg.9
        for <kvm@vger.kernel.org>; Sun, 27 Sep 2020 09:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=1TVkOq4aT2dyr9tdCFG4kScf4u8CmGUui+tIslD2Iic=;
        b=uOhK8SlBZa7EXKMEFF2ImcrrohDCSDf4QQlzzp5dmxtHrk0uQQutky+QeHPqf32vOD
         +2spmg5l736sg6hWRlnBm8Cb2nIfgvjbfCaAUiXOOpUrXokQqaBqrhPeeaqcZ+s/LPyx
         XGPBn61F+e1wEd4UPF+fqCZj6bltNy6ivf3Co=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=1TVkOq4aT2dyr9tdCFG4kScf4u8CmGUui+tIslD2Iic=;
        b=nJUKtqi9Y8KzhMjtJCqsmmNyVSlKEwJg2x7xORlcI7tlnogyuc6RS9KzHI2RL3u6AU
         t1FFvOd1JzrKFuSQ5MuKnqxi9/goYfCk2QbXnoYX7xcJIlGyM+HiVgUqB9CRvsdk9nnP
         ROCxBxszhEUE+q6awxPOYJJ7i7hVziJGcr/w+nhRWaPT+FSIvKS9DDZJqp0tzLWYMDxZ
         F+aEdDE98gc9Ddud3mVHnrSWQ/AFwTW4lYUWQ/bsBhoqVvlPOnzRYHiIjVYugDFpnH6K
         58TeGLTjj8bwJkVf9bUldnYYYu4d5Tg0+qnvR8FZ6xuybR/VsUmB5un6sKAe/01hdom2
         mfkg==
X-Gm-Message-State: AOAM530MfYTb8QYdZae1QVpCkiXQnlyNOnNLdKOzcQn5F90iZrJCePbU
        m/qBNyiqXJWWUjS+NVrcf1Bdq32mfiVD9Kh+QwsBtQ==
X-Google-Smtp-Source: ABdhPJzWrBHocnSe9bhfazPGw5KQh1DAXNgs+VrCOp+8qTpT4+LmPQjKDLDL0JaADObYaaRlQ71bcShU/GSMat7Mg7Y=
X-Received: by 2002:a2e:a411:: with SMTP id p17mr4281841ljn.282.1601225253726;
 Sun, 27 Sep 2020 09:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+FJ1nW8E7f6_4OpbbyNyx9m2pzQA-pRvh3pQgLvdgGbHg@mail.gmail.com>
 <440273d7-2c10-a433-8250-032a21d5eaf2@redhat.com>
In-Reply-To: <440273d7-2c10-a433-8250-032a21d5eaf2@redhat.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Sun, 27 Sep 2020 22:17:22 +0530
Message-ID: <CAJGDS+Ed2SF=B+r4cnp54-YQSKhLCRzwW4yRiU7Us32y6geJBQ@mail.gmail.com>
Subject: Re: Which clocksource does KVM use?
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you Paolo for this information. I believe setting the default
clocksource to HPET would be a more deterministic option in my case.

On Sat, Sep 26, 2020 at 1:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/09/20 04:36, Arnabjyoti Kalita wrote:
> >
> > Does KVM change the clocksource in any way? I expect the clocksource
> > to be set at boot time,
> > how and why did the clocksource change later? Does KVM not support the
> > tsc clocksource ?
>
> The TSC clocksource might fail, in which case Linux will fallback to
> HPET.  Using kvmclock (which you have disabled) avoids the fallback.
>
> Paolo
>
