Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4A1B4A74
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 18:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgDVQ20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 12:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgDVQ20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 12:28:26 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6D9C03C1A9
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 09:28:25 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so3061254iob.3
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 09:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T67dHM2n+6dU+w98XrJDyqOWeidWrP2wtqbNJsX8zX0=;
        b=QRNrSB0tov0sZZieYm+a79JzcW16FP/s8uF17RRoyS1T0qh0vCU30Uzxn1Thdkb34M
         3frjRaBNVbApxc6h5BSuhM4cEeZmG2TwhmCADcZHAwPAOLyWxXOFUp8RlOUkqCucIJZB
         a3O87tzBVFWqhyoK86+QdHZxKAi2dX9Ymzj4HGuZiIjm8qVtw2EfaxGrqfbsuoyhsTU1
         1q5s2E+vNkpLj28sdczbDa+o+3T87w+yYoYdn/AA8mhpu0/E1stjP6MPVRbTMsV5BYbK
         gTOWBDSUrnmkN+ObKMbifLS/hAS+p4xqTidonjqLCJeL/SFUgdYXftW0+nDZ0eLpjTPu
         Yn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T67dHM2n+6dU+w98XrJDyqOWeidWrP2wtqbNJsX8zX0=;
        b=XGQ02/NsmaAdgR10lTMzL2rS+TDg6cl7c+JmFK0ESZ1Fz6wPDZ/rUnS8WUI4DmF+wS
         ntdm/w9ibJVDqlyw5HS/euTdDtmJftd8W/5moJr3oakGZUBtfb4RlifSKV1D11tSBsCk
         QknU1GqT+7sVyI8enrEwWo5ISWeZHuTak+d/3oN8dKRp9yHwf/17bu/fg4/NDQHPJLoo
         2eW2X4s01NrqxFM4MigrF+lqtFSwlejWAhYNqBt/tI5pxhd7UglvON4ZQKlfOAluuvds
         swRL0ftgB+xDP1kpMG/59mjae2RPa618ywQCvqsbY3SSnb9yLsT3s1OCGY9rcitNeyRv
         u4Tg==
X-Gm-Message-State: AGi0PuZLrkvQ2jea2q0g+uQFyxbHlGIR1FR+i0Lm/gnPIR2U0slKtqzW
        qmWgRN4c43LfRmGLNOctTjzGwxBhy0+6aviw5+GG2Q==
X-Google-Smtp-Source: APiQypJolv7AIY7fI4KjIREodV12IUGdcgAjfoT5ZtFnNJdxnOqwZyQm855dnNSCHfUnfPoMHRXEoZ76XMXRnMEH1LA=
X-Received: by 2002:a02:8447:: with SMTP id l7mr14932522jah.54.1587572905067;
 Wed, 22 Apr 2020 09:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200414000946.47396-1-jmattson@google.com> <20200414000946.47396-2-jmattson@google.com>
 <83426123-eca6-568d-ac3e-36c4e3ca3030@redhat.com>
In-Reply-To: <83426123-eca6-568d-ac3e-36c4e3ca3030@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 22 Apr 2020 09:28:13 -0700
Message-ID: <CALMp9eR75_F6su19oMKeNU1NE4yPRGdNrxfHR+WskncRDSfvkg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 1:30 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/04/20 02:09, Jim Mattson wrote:
> > Previously, if the hrtimer for the nested VMX-preemption timer fired
> > while L0 was emulating an L2 instruction with RFLAGS.TF set, the
> > synthesized single-step trap would be unceremoniously dropped when
> > synthesizing the "VMX-preemption timer expired" VM-exit from L2 to L1.
> >
> > To fix this, don't synthesize a "VMX-preemption timer expired" VM-exit
> > from L2 to L1 when there is a pending debug trap, such as a
> > single-step trap.
>
> Do you have a testcase for these bugs?

Indeed. They should be just prior to this in your inbox.
