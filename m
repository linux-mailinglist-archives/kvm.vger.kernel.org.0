Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F95B1A9270
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 07:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405568AbgDOF1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 01:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389364AbgDOF1O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 01:27:14 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C05C061A0C;
        Tue, 14 Apr 2020 22:27:13 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b62so16018960qkf.6;
        Tue, 14 Apr 2020 22:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ct0hBuohHuHlRfoGecOViSQANLKNyL7v3AAbn8mtpmI=;
        b=bi9PW74S2tR6/OEmNB3G6K5L+UoHkLnJybBMMNSv1RBtGZEM6EOe8FC7uyksNsYrGE
         ytL62J4Efm00kGtcTP/YRdgQD1P3sI7xkHRzsbNwNobA19+SpaKpxc+K8yf+roTmOKXo
         Tj9iM3DZsJQglNjLKO8q/TFauvei+8QVy12+mWTYA1h3RVgyVpFQ7jaq3XsB+zihYIPv
         b9J87QCNy5OddX6h6qY74gMOxgjMS/m3snoIMoNzA25FconMtwYsKkBeCm8MQGWx19Q9
         VouscXGisUU8EsyHuT5Dx1meDV6TUnrrI8+dZXaj0CH7iE1TSAgnXLJ/A6dWoB5XJVWA
         bHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ct0hBuohHuHlRfoGecOViSQANLKNyL7v3AAbn8mtpmI=;
        b=FW7HeEs4XS60uQsAVQrfvHZ1aU42S6m4demD5D7r6XB3DT31NlkidWR3OnuP0sXSPc
         cEFiYC/8SQs/cDU90B4SdKJSbo4VeRTM40rpY2rRFy9LmpTR3DyxxIuT+qisjqY7rfpf
         k2YBiF2WR0b8r2L779sEevIyDnL9eotKPNLE1rJ4dy5GwRw9QKRwmLDoOD4CmV/N8tRp
         KqkUUHwhXkcWwCXOjW8gHHZbk9c7SsdHYrm43NahLxNG23rUKtO+7445GRj6xIBj0iqx
         V1JcZZuGT+xchfQAv5a1dG88ncNrIGQkgaLNw9631CIWYUOwDbgBeqPk9b9oX1kcsitD
         m3wg==
X-Gm-Message-State: AGi0Pua/8dIYKNQyzU6iaSK3SJgQkB/8QlBxvj8LVRpxHJm9ssgFUvP+
        2ppD2YWUwU98rY5lR7uMQK/n7tkRCDV2RTgrjurFEaB0pR0=
X-Google-Smtp-Source: APiQypKssePFI6UhQtg8SF7PbNhoguf9oD2a6cXt10K44wIbpgtLtWPSB9ygg60X1uxamG9sttyTJ7xnQTqaNq+RebA=
X-Received: by 2002:a37:84c7:: with SMTP id g190mr24227289qkd.335.1586928432947;
 Tue, 14 Apr 2020 22:27:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200415012320.236065-1-jcargill@google.com> <20200415023726.GD12547@linux.intel.com>
 <20200415025105.GE12547@linux.intel.com>
In-Reply-To: <20200415025105.GE12547@linux.intel.com>
From:   Eric Northup <digitaleric@gmail.com>
Date:   Tue, 14 Apr 2020 22:27:01 -0700
Message-ID: <CAPC9edWgcrC+mc1pQSYmJjPs17VZ-Af1LJ+s6PaeY=9fPA89NQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Northup <digitaleric@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 7:51 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Apr 14, 2020 at 07:37:26PM -0700, Sean Christopherson wrote:
> > On Tue, Apr 14, 2020 at 06:23:20PM -0700, Jon Cargille wrote:
> > > From: Eric Northup <digitaleric@gmail.com>
> > >
> > > Return L2 cache and TLB information to guests.
> > > They could have been set before, but the defaults that KVM returns will be
> > > necessary for usermode that doesn't supply their own CPUID tables.
> >
> > I don't follow the changelog.  The code makes sense, but I don't understand
> > the justification.  This only affects KVM_GET_SUPPORTED_CPUID, i.e. what's
> > advertised to userspace, it doesn't directly change CPUID emulation in any
> > way.  The "They could have been set before" blurb is especially confusing.
> >
> > I assume you want to say something like:
> >
> >   Return the host's L2 cache and TLB information for CPUID.0x80000006
> >   instead of zeroing out the entry as part of KVM_GET_SUPPORTED_CPUID.
> >   This allows a userspace VMM to feed KVM_GET_SUPPORTED_CPUID's output
> >   directly into KVM_SET_CPUID2 (without breaking the guest).

This is a much better commit message, thanks.

> >
> > > Signed-off-by: Eric Northup <digitaleric@google.com>
> > > Signed-off-by: Eric Northup <digitaleric@gmail.com>
> > > Signed-off-by: Jon Cargille <jcargill@google.com>
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> >
> > Jim's tag is unnecessary, unless he was a middleman between Eric and Jon,
> > in which case Jim's tag should also come between Eric's and Jon's.
> >
> > Only one of Eric's signoffs is needed (the one that matches the From: tag,
> > i.e. is the official author).  I'm guessing Google would prefer the author
> > to be the @google.com address.
>
> Ah, Eric's @google.com mail bounced.  Maybe do:
>
>   Signed-off-by: Eric Northup (Google) <digitaleric@gmail.com>
>
> to clarify the work was done for Google without having a double signoff
> and/or a dead email.

That works for me. Thanks for upstreaming these patches Jon!
