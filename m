Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264334CA2F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 11:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbfFTJBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 05:01:46 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33687 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfFTJBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 05:01:45 -0400
Received: by mail-ot1-f68.google.com with SMTP id i4so2064588otk.0;
        Thu, 20 Jun 2019 02:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9XWALfDZsuDseMJ4aeFkChWWJWcZ4a9nteKLEt49TTw=;
        b=qrr7l1CioNR8wIDkHD1EIRbzrQW1RxP5Hz3hm/662yglpTWvNKcW92yKLXiHIy/vEs
         4WQEMK3OwEsAcQS/P2A7tNYixmS87ThBPQfjCpy8KcWRdBpjN1isNVjhnzZH6YeRW+jv
         tebU05wd+GKmL5PrLPzewMTSHpO3B2o/EZ6mZWfyeKb1AAqJBiX6lBBcWEt+ZVOmoCsd
         a+FALgnN31H8fup1wDenMvMG1BEm0ho5ZXezWF7SETv5CWXGMh3d+9bPMOWmIpjwD7gZ
         mAHpDG9fyfV+ysI/gGjME78ayzQUu8gEqgIBwRTm4NaX0ynXfhCHxAXS18jQahGo96a6
         cauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9XWALfDZsuDseMJ4aeFkChWWJWcZ4a9nteKLEt49TTw=;
        b=AQwtCgcRbrTB65Q5RP/DqQUD8iPoldwILkfwvjfTrraY6YIs1UG1vQQaId71HHheWf
         eC6bELBUvFJ4Zu06puq+IBUrUHBQH7LumqzWwwKNgld1tv0huCFKo+pvcGDTq9SdZ/Ou
         32jadjQl50HoEnpL6a4KqdW6/Ici+9UFsPKiwqLoNdqdp8yDKr00DzrATDH0ppcfsGh6
         n1PTtcNoZDTI5PwIKMXXCgkUxwvMWgpK2tQcurnbSMODccjRlCJG0lfKG+rFR4V7dgGs
         dhXlICcwhesHNX5BCf3lBzlxqKnVBXEt5rajVPk1im1H5vfXXIZj4fM2GfBur5J+1xtq
         fOUw==
X-Gm-Message-State: APjAAAV51HDxbBAVte0hVrQyqYS6Go48OC80Ia9BVCWkLu8yQNvvNjhC
        plLON6+P5Perv7UL3cvqmHzFb8Rm/oY1OK8pR04=
X-Google-Smtp-Source: APXvYqwWsIIp/o0pN10sFuCvbSWrFLP/so3UOmDqaKG5SeJWGBQd2M4ahM1uMfnCI4vJRjkEmfHH/DmQ3kI8JZc/VL4=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr2613071otk.56.1561021304529;
 Thu, 20 Jun 2019 02:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190620050301.1149-1-tao3.xu@intel.com> <CANRm+Cwg7ogTN1w=xNyn+8CfxwofdxRykULFe217pXidzEhh6Q@mail.gmail.com>
 <f358c914-ae58-9889-a8ef-6ea9f3b2650e@linux.intel.com> <b3f76acd-cc7e-9cd7-d7f7-404ba756ab87@redhat.com>
 <2032f811-b583-eca1-3ece-d1e95738ff64@linux.intel.com> <d9b3e4ff-e14b-1bc5-2a7e-c89b545bb2fc@redhat.com>
In-Reply-To: <d9b3e4ff-e14b-1bc5-2a7e-c89b545bb2fc@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 20 Jun 2019 17:02:56 +0800
Message-ID: <CANRm+Cx2qsBJkauu9OryN7mR_dEgyha_KUZC=5-uqc5JoSgvPA@mail.gmail.com>
Subject: Re: [PATCH] KVM: vmx: Fix the broken usage of vmx_xsaves_supported
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Tao Xu <tao3.xu@intel.com>, Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jun 2019 at 16:59, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/06/19 10:55, Xiaoyao Li wrote:
> >
> >> However I may be wrong because I didn't review the code very closely:
> >> the old code is obvious and so there is no point in changing it.
> >
> > you mean this part about XSS_EXIT_BITMAP? how about the other part in
> > vmx_set/get_msr() in this patch?
>
> Yes, only the XSS_EXIT_BITMAP part.  The other is a bugfix, I didn't
> understand Wanpeng's objection very well.

https://lkml.org/lkml/2019/6/20/227 A more complete one.

Regards,
Wanpeng Li
