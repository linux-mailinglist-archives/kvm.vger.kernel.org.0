Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7841D21BFFC
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 00:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGJWhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 18:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGJWhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 18:37:24 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D89C08C5DC
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 15:37:23 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z24so8121081ljn.8
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 15:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ead7Tm1iob1rVOVfiweQNSGvHhGRf+Xbq2BHArnv6zQ=;
        b=FrX8P1eOreflctNc090EpWoFGJACL/miAvtrHtSNwKLpQ2FZ/8n13odOYV0JoVaKSV
         g1sLXp6KQEHYRWdTAiQor0aP5DVDm3jzhdpPij4f+6JwE98m4mLsKqJolx0y50gJqBJm
         RcHHrlJ/MVNK2RS+lKKA2j3lvzRqh/pzaq1Z92m+gbvVBthi16aI5yF+vGEUAdHiceHd
         2GS51KMUNY3iYNmXNEM2gRz5x4ZxQV7is0Lb5zvTOnIiywmlfoQBfEJEta4BkYcjCvnB
         jONdR7Bj67quKNRn2fRGWga/yJdv9LRsavAuioRxgQnA4t3NBuFDMH2ruXbzL99aIgwB
         kcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ead7Tm1iob1rVOVfiweQNSGvHhGRf+Xbq2BHArnv6zQ=;
        b=USPEdqcnXLJlTl0o4zM6F5bPi6lFxieyRO5zNsmrzzlJu/dHg0k9/kArkUL7SgWM6W
         pH37/+1L6teMsgXCtxrjo6idu+PQY931fhfTb+31Ff64aqG93PdaxczsEscF8ddqKmDp
         m80Scml1mnczHBsJP2/QQSvZbBCcuz05aM/RGhcFG3AspWbzT8Ndcwx8gvqC0kxbg8nO
         MKkahqDW0EH2lsjdbxU3R/+g28RqJTS9/gMN1o0ZoggWpvfnzzrWwf6sUe1ulHQwuEN8
         5lUcvw6xRlzfQ/GqLOtZ1ewZBWtAtsp/L7TFRIBjjpOdBh3SRoWXnC59qXv+0x0dfM1j
         ELxw==
X-Gm-Message-State: AOAM532riQAHmuYrTbpEqzUYIkkhYn43pH7PXf2l1qG0fKWrwrlB+PiG
        9u4UxbgtKaYk+f/tLd9dlzAob1E2oP8hu5440IHEyCa+
X-Google-Smtp-Source: ABdhPJzHD2GsQi+5XXyN339Bdf9m8rZqrq1MR8ySRetVG1oEguvuRbm2CJD42J6dCpWjRj3tBzvmJpzNhVYKvd9JdnM=
X-Received: by 2002:a2e:9c3:: with SMTP id 186mr42802404ljj.293.1594420642097;
 Fri, 10 Jul 2020 15:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200710200743.3992127-1-oupton@google.com> <61da813b-f74b-8227-d004-ccd17c72da70@redhat.com>
 <CALMp9eS1NB25OjVmAOLPEHu7eEMSJFy1FpYbXLSSKwp0iDs_QA@mail.gmail.com>
In-Reply-To: <CALMp9eS1NB25OjVmAOLPEHu7eEMSJFy1FpYbXLSSKwp0iDs_QA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 10 Jul 2020 15:37:11 -0700
Message-ID: <CAOQ_QshP02y1XLmaEXvEP55L2aih-4UGH9fw3tagpmG+CMgHgA@mail.gmail.com>
Subject: Re: [PATCH 1/4] kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 3:09 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Jul 10, 2020 at 1:38 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 10/07/20 22:07, Oliver Upton wrote:
> > > From: Peter Hornyack <peterhornyack@google.com>
> > >
> > > The KVM_SET_MSR vcpu ioctl has some temporal and value-based heuristics
> > > for determining when userspace is attempting to synchronize TSCs.
> > > Instead of guessing at userspace's intentions in the kernel, directly
> > > expose control of the TSC offset field to userspace such that userspace
> > > may deliberately synchronize the guest TSCs.
> > >
> > > Note that TSC offset support is mandatory for KVM on both SVM and VMX.
> > >
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Peter Hornyack <peterhornyack@google.com>
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
> > >  arch/x86/kvm/x86.c             | 28 ++++++++++++++++++++++++++++
> > >  include/uapi/linux/kvm.h       |  5 +++++
> > >  3 files changed, 60 insertions(+)
> >
> > Needless to say, a patch that comes with tests starts on the fast lane.
> >  But I have a fundamental question that isn't answered by either the
> > test or the documentation: how should KVM_SET_TSC_OFFSET be used _in
> > practice_ by a VMM?
>
> One could either omit IA32_TIME_STAMP_COUNTER from KVM_SET_MSRS, or
> one could call KVM_SET_TSC_OFFSET after KVM_SET_MSRS. We do the
> former.
>
> This isn't the only undocumented dependency among the various
> KVM_SET_* calls, but I agree that it would be helpful to document it.

Sorry, I was AFK for a bit but it seems Jim beat me to the punch :-)

I'd be glad to add a bit of color on this to the documentation.
