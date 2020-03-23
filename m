Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC526190067
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 22:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCWVd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 17:33:26 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33951 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCWVdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 17:33:25 -0400
Received: by mail-ed1-f66.google.com with SMTP id i24so18135568eds.1
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 14:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zhnknTMAfH/wRzM1aNoHZGvfELya9SoXYzFYD0LL+XY=;
        b=JHiCizBxgvc+j7w2CR8qEtF10rjJazyvP28JcwYjWY87NnULzuRquBD2xdCHOmt58I
         9Bgvr/GpRQrQycF5UnWMEul7qpIT6iQY10T0PpLTH32rvyfntrMD50ZKh7etd0+RE63Q
         L7mAsD3Udvg8QJPSaS8rCC4NL04WOHi/5ZiWE+57KIjPERgxGhGpIcPb9nZKPfuS3+Sn
         L0neJPcZHC0cjgfQZm4waK/O87Z8q1FVKq2koyFn1c5RWjPUGoSvVXGhroDs2BQ9N+D3
         BYdv5NUKccrnJvxxxe//kFazPj7rCGqVspuFjNoHAUaBDQe7JIWS1DrAJVUyzVIqtbyA
         ueXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhnknTMAfH/wRzM1aNoHZGvfELya9SoXYzFYD0LL+XY=;
        b=Cx2Fd3BEIWn9i2PNvGo6JWkIXsUJHt4VFgH13rWfCObxL/Tkobzgk1RwBg4rNucfXV
         pG8bHMgiNz1f+AaPAFXYMwA8bJB8rXilb7G3ZV/zFzqwWMThJjR2mYGY+6HbLyZtfiNP
         IIRxzE2vQ+JbrxnBDQWTVC2M2vgGKFeadLj8a56jj5Q+rUbSyWuybSdvnf4lpnUGpGjH
         kOyhaiBZ9fcitHAZMOTSpFME0hOwYJO9KY6iUH1+RFAivNkIb9dmKgQG6ph/GLM6j2bs
         P49RkI+yMJ1mQNoOD2vG6mZhrjoRO15SVsd0Hune9fUgHveUtCodHCFxyf/sXgILIo0y
         r78A==
X-Gm-Message-State: ANhLgQ3KBnvUY7wHupFAN5BefYpIzLNadXeDiciPhS6xzVfCV/DZxFl/
        H+Lf4ZffY7SSKS6grb0K2nM8widltreF4nlepsoULPWm
X-Google-Smtp-Source: ADFU+vuJarP63ymQBTXL3joEpixrNSQwYHFgXElydF5vi1pdd4W1J4ZjXKpEs9Et3yCFPhnm1VGPn1bDtVwod8wCF6g=
X-Received: by 2002:a17:906:af57:: with SMTP id ly23mr7224694ejb.6.1584999202172;
 Mon, 23 Mar 2020 14:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200320175910.180266-1-yonghyun@google.com> <20200323111404.GA4554@infradead.org>
In-Reply-To: <20200323111404.GA4554@infradead.org>
From:   Yonghyun Hwang <yonghyun@google.com>
Date:   Mon, 23 Mar 2020 14:33:11 -0700
Message-ID: <CAEauFbww3X2WZuOvMbnhOD2ONBjqR-JS2BrxWPO=HqzXVcKakw@mail.gmail.com>
Subject: Re: [PATCH] vfio-mdev: support mediated device creation in kernel
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Moritz Fischer <mdf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 4:14 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Mar 20, 2020 at 10:59:10AM -0700, Yonghyun Hwang wrote:
> > To enable a mediated device, a device driver registers its device to VFIO
> > MDev framework. Once the mediated device gets enabled, UUID gets fed onto
> > the sysfs attribute, "create", to create the mediated device. This
> > additional step happens after boot-up gets complete. If the driver knows
> > how many mediated devices need to be created during probing time, the
> > additional step becomes cumbersome. This commit implements a new function
> > to allow the driver to create a mediated device in kernel.
>
> Please send this along with your proposed user so that we can understand
> the use.  Without that new exports have no chance of going in anyway.

My driver is still under development. Do you recommend me to implement
an example code for the new exports and re-submit the commit?

Thank you,
Yonghyun
