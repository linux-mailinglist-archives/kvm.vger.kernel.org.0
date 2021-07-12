Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8423C61D0
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhGLR0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 13:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbhGLR0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 13:26:03 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D13C0613E5
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:23:14 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so19630961oti.2
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BA8pDDOUvp6d/xPytywlLcoRhVoy9eZrqJDmTRrxqlQ=;
        b=q1/slnPrL96kz9b2UR4Xvv++1BDjB7aaDsvPs4OKGMG7Am1SN7GGpB3iPZ2Llfj2CP
         wcGSV7sAZ4/jkKgFpJ8yC053amfGf6wy+ZECpr69m0/gAR5ngLUmSGjnFagkLkNZJj8E
         4IeFx9TSVRwT6igKIy8ivzOLl1iAF6Q7xTvG5jNZDQMPX1gyO7HaSoYkFiI60213FPHE
         KCpep6I6PzmZA+zLWt/2Hvdija9vv8bIpA4LGem/h250OIHUhi5YaafYituQyKEYUHTj
         AoBa2OWAkKLAkFqx3EcxVlWRddu0givKOoYujaRXGyAcpsDZzvAizAaIIyAquT+3u3SP
         3RKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BA8pDDOUvp6d/xPytywlLcoRhVoy9eZrqJDmTRrxqlQ=;
        b=RvkM3PXkzlZC87qM2fgvjkdts13NlHpCL817csVCXb1hxV1qT/HKoTqVyvsBQhAaDY
         adxX+4z/fDnjHIV6cUqVFzqwC0fD3H8FFIGFUPkdLk3TRwzdGVYPckV11futkglEpAmz
         muSXQy+wxcvs7/8G5TbzaH2Wm+NZ0k1HyjQB/gM+vj54y3GsiL8FyLOYZB+y03JSBN25
         rRsQzG2MbkV229b4Yqe0SCkbB2tNBSrzbAxdmuGdXCuK4NIiQxiZqQ6OKrI3nRql6bu8
         plG2VjkxeHV3jBPEWwg0+ScxSIl/z1pmRUpmHXaIRndr+5mPiNk9hT0je+Ch1ht9WMFK
         AOJg==
X-Gm-Message-State: AOAM532TulLNfmYLPFPpWJw0NnOhZEIgVuqIbZRkqBIVjOtCcoGU1RF2
        rJBKY4ITTNrY1gh6i+ECUPmOrNERjbkeRy9QGhExLg==
X-Google-Smtp-Source: ABdhPJxYvGopP+Xl7pOuU5xiZGAIMBRw8f3dSjyb5D1cRCD9vbQYdGehGbtYXBjx8d7BEfgLlo+KSxhUfOuILcfUKR0=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr58035oth.241.1626110593467;
 Mon, 12 Jul 2021 10:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com> <20210712095034.GD12162@intel.com>
In-Reply-To: <20210712095034.GD12162@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Jul 2021 10:23:02 -0700
Message-ID: <CALMp9eQLHfXQwPCfqtc_y34sKGkZsCxEFL+BGx8wHgz7A8cOPA@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL state
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 2:36 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> On Fri, Jul 09, 2021 at 03:54:53PM -0700, Jim Mattson wrote:
> > On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > >
> > > If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> > > and reload it after vm-exit.
> >
> > I don't see anything being done here "before VM-entry" or "after
> > VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
> >
> > In any case, I don't see why this one MSR is special. It seems that if
> > the host is using the architectural LBR MSRs, then *all* of the host
> > architectural LBR MSRs have to be saved on vcpu_load and restored on
> > vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
> > that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
> > restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
> I looked back on the discussion thread:
> https://patchwork.kernel.org/project/kvm/patch/20210303135756.1546253-8-like.xu@linux.intel.com/
> not sure why this code is added, but IMO, although fpu save/restore in outer loop
> covers this LBR MSR, but the operation points are far away from vm-entry/exit
> point, i.e., the guest MSR setting could leak to host side for a signicant
> long of time, it may cause host side profiling accuracy. if we save/restore it
> manually, it'll mitigate the issue signifcantly.

I'll be interested to see how you distinguish the intermingled branch
streams, if you allow the host to record LBRs while the LBR MSRs
contain guest values!
