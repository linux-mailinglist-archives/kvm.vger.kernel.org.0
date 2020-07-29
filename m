Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AC82317B6
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 04:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgG2Cib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 22:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731030AbgG2Cia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 22:38:30 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91E9C061794;
        Tue, 28 Jul 2020 19:38:30 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id p25so7097296oto.6;
        Tue, 28 Jul 2020 19:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K6A3KO8txqzFG9jCJSeANxOVnNRmay2PfFUV2ifoI8g=;
        b=POa67tstwY8Q5qfUKdouIi54li2VWidsrp6f7xa56h+qZj0Rjroros1jeFILbGUuq7
         7d2wyeedEEF6YLATbQ3WRyQgMUJLOVqaqOly98aEAtBrdydAPwT2wgPZRDsMmlt8i3Fi
         VLqYmGZPpyj5NBVXSXABLaH7uY8Xd6zeC/iF0xS9qM8LyOb79GpsAr4bB6zTZQjbDrD6
         E8Tce25t0JxvJbp2F7Hins7k9qqaHlnmN5rCMjEPJcmzwitpHSYdPg9fVUL1x9lKvD0I
         oIVI3k60yHZL2LAuYpkNHp3sMtpxu2ci4dHod2KjOLtJ+z8vkySBh5GtAXFHWwS/AxXQ
         mdaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K6A3KO8txqzFG9jCJSeANxOVnNRmay2PfFUV2ifoI8g=;
        b=Wybx+hkFdO6N1Gi483CGOpmYLNUulFWxslSXH5zh8DQc1hO3GFLrlomCvv54RX+UAu
         XJXBG4uB995Rr2wB0h8/hjnB8OvoTe5We27ioQLwgiSIl81iVzRE6Nhd0aU9IhxnuqZ3
         X2KChmHVTRrXaYkkkjINVotcivdZ8UsaEe9958g9X0IWOk1cnPTis3eMLwf+wEcLw5XX
         k/LNjZlJ4sSJbRvhkKaunlF1VOy/J/BsiOdkBFydAQ/Xk4uwLxJxtGUcB+kpio7SOX+N
         jos9p9GFEu7YfC7NBY/EtACCl4VPGu9DtOuZHuPLuMWdQtm7m3gMszJecmAonFhGN1S+
         AGpQ==
X-Gm-Message-State: AOAM533D4sHueEzUlKLG5L1oOUFmtdmnr1aPkevIqnSC3f2xFf5C2mSF
        IkEyPh02Y8DxfEOUIydykCQyMsepzAAoXza/LEE=
X-Google-Smtp-Source: ABdhPJzsvywrWS8TM3/1mOWcu/7q5UfAoRRvnRgCRRdxGnVsRyFrNYbRHEYoCzXpqcdGF4EMfGx+XGB6rWzre4STFY0=
X-Received: by 2002:a05:6830:23a1:: with SMTP id m1mr14704705ots.185.1595990309932;
 Tue, 28 Jul 2020 19:38:29 -0700 (PDT)
MIME-Version: 1.0
References: <ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com> <CANRm+Cywhi1p5gYLfG=JcyTdYuWK+9bGqF6HD-LiBJM9Q5ykNQ@mail.gmail.com>
In-Reply-To: <CANRm+Cywhi1p5gYLfG=JcyTdYuWK+9bGqF6HD-LiBJM9Q5ykNQ@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 29 Jul 2020 10:38:18 +0800
Message-ID: <CANRm+CwrT=gxxgkNdT3wFwzWYYh3FFrUU=aTqH8VT=MraU7jkw@mail.gmail.com>
Subject: Re: WARNING: suspicious RCU usage - while installing a VM on a CPU
 listed under nohz_full
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nitesh=EF=BC=8C
On Wed, 29 Jul 2020 at 09:00, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Tue, 28 Jul 2020 at 22:40, Nitesh Narayan Lal <nitesh@redhat.com> wrot=
e:
> >
> > Hi,
> >
> > I have recently come across an RCU trace with the 5.8-rc7 kernel that h=
as the
> > debug configs enabled while installing a VM on a CPU that is listed und=
er
> > nohz_full.
> >
> > Based on some of the initial debugging, my impression is that the issue=
 is
> > triggered because of the fastpath that is meant to optimize the writes =
to x2APIC
> > ICR that eventually leads to a virtual IPI in fixed delivery mode, is g=
etting
> > invoked from the quiescent state.

Could you try latest linux-next tree? I guess maybe some patches are
pending in linux-next tree, I can't reproduce against linux-next tree.
