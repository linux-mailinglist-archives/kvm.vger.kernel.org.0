Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DA7434325
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 03:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhJTB63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 21:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhJTB62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 21:58:28 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F068DC06161C;
        Tue, 19 Oct 2021 18:56:14 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id x27-20020a9d459b000000b0055303520cc4so6395781ote.13;
        Tue, 19 Oct 2021 18:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=THkcJGTXLjxpKELessb5DvMNyRq5o0OQ4/ZTqiQjBE8=;
        b=bP4d90q4mfezbbLWsUmbM02c0g3avxhDcqqV/XACuW9VK/5fHSvtXAVZlpsTnK+Ptd
         bX1n8SRZIjCj4w1Qa8ZBc/op+7WdQvk4zdiH61g9lpqvVdS07JbshBlizoJ0tt0as9FQ
         9R/bz9lT4rnupaCo3QBiv8x/h7riIfXvjkpwxtDG9AaRfEDGuYdepT0HT5aadHt9JSfj
         lzhgAjhisbl4snmLecqejd5DW+hLMyc//AqPtGcaGheqLjFW1zbl9pEnSEuOwwWYawK8
         phfI8K3A+Np7PI78Y1EpjXfuOT3h2KszSjWDkiSrY6v/7S/KOITfozAyolITVvsFI9R+
         HDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=THkcJGTXLjxpKELessb5DvMNyRq5o0OQ4/ZTqiQjBE8=;
        b=ECB91rZWtSB4yTK4sp1fCt+kyFKkNiG10IlT2ExYLgkqstub0A3E9PqUaOrK0dIZOV
         NdGrTNUKIqRI/w8M7V+HIc+EXzROLfGYaoMrsRlO2XKxyGRmiefI/INXs8XcWtmw3U55
         o3ZkagwaRsPdcDboaSl6E4VfejYfuV9mLIpFTfh6pdkVV3TrhQuCXPuxvfWpoRM2iK5X
         SbNNSNFgLkLaS346yRqVgRvuQj48V/yma+ozSdFIsZTI54sxkcPvgbBEg4orY5LpZnZj
         WYQ0dgb6FnfD8N2FtObkL4C+K7vvwrGrA6Nnf75H/SMyAuC9a3syWCP/dMrj5zNQcz6T
         jn1A==
X-Gm-Message-State: AOAM533A0g83f8huW/soiTrAf4lu1khvB/AUoGLb1oLmsqPOhF6dOzk2
        Q4ooYScxUxHOA92ymVo0tx3cOA3jKYcMmCd8ks4=
X-Google-Smtp-Source: ABdhPJy4i7Er4jMtJy5dgcdVRa7+yvv6pVUHVj/BOlB6iKTcWnYxzFubPn2ngJJSSZBt+F5D0eGUvuOSpsbpcFP3UsM=
X-Received: by 2002:a9d:ea3:: with SMTP id 32mr8324507otj.0.1634694974401;
 Tue, 19 Oct 2021 18:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com> <39b178d0-f3aa-9bab-e142-60f917b0f707@redhat.com>
In-Reply-To: <39b178d0-f3aa-9bab-e142-60f917b0f707@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Oct 2021 09:56:03 +0800
Message-ID: <CANRm+CxXogoP0vh9_qPz_d4+p+ZQwy_SdJ6exuG1dd7+3weHSg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] KVM: emulate: Don't inject #GP when emulating
 RDMPC if CR0.PE=0
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 at 01:00, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/10/21 10:12, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > SDM mentioned that, RDPMC:
> >
> >    IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter))
> >        THEN
> >            EAX := counter[31:0];
> >            EDX := ZeroExtend(counter[MSCB:32]);
> >        ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
> >            #GP(0);
> >    FI;
> >
> > Let's add the CR0.PE is 1 checking to rdpmc emulate, though this isn't
> > strictly necessary since it's impossible for CPL to be >0 if CR0.PE=0.
>
> Why not just add a comment then instead?

Will do.

    Wanpeng
