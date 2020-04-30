Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B5B1C0B0D
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 01:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgD3Xnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 19:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726473AbgD3Xnw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 19:43:52 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BDFC035494;
        Thu, 30 Apr 2020 16:43:52 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 19so1319076oiy.8;
        Thu, 30 Apr 2020 16:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0aGv0fmrEJ3JJMEKSeFGrmFzZQ6kdpuZGzPNRlg6rjs=;
        b=C4X8EDtceCxZshXONhK22Wegzl24zM8hjRGgow9ZuAZ2Awgl7NFJxzLZFZ3uKQCqNv
         sjx1JWmFZZETWsxJB+JaVPL6Mj5RyUH512ZAiB7Q85piO+GOKz77YotMgdftEPPiLnGx
         IK01bAvAbAVGOqZkf40dI7V2BKmIcby0u1dru/Bow9eqcP5z+EMO/wuw2gxOJMoH84K7
         Gx5na7rvaCwehKr1Qp66oRR49wAmxZboy01aZaGZagKUZSl74hfomJtfEQBH0KeOJh2V
         pyfIL9yW5JNRne4k5+YwMvK/rk2aErJJcCtQTEDCtGMcEQajArGhUF2WZCLESk0xY6aP
         EGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0aGv0fmrEJ3JJMEKSeFGrmFzZQ6kdpuZGzPNRlg6rjs=;
        b=euePuV+RX16Eqt0+gsYdwPmC4uwg3m8wgR0qAOXLyqicgzthd2YuqmtSelGAbI+kh/
         eiXyb7dmqaNKr87IxyBZcVOunbjw8XLi/INY5WG+XPf9epPdYtZE4ijFcwiI/PuhqXO0
         yoVJQIWs9ZeHKjOzk3C6YkaSogWCSo7iwW4BqnPLiUs35EswFaCwyDdtVQatJbFu3WOX
         f/kVv3Mkfh1WadrKK+leZgwhwMIsX/2ZGlEf36qNlDK2S1QC4nB4YWspCDqn8p4qAmmq
         D+3RRZUXlXVmprAU3vk2csIjmrT3loEjEqvXSHO6wYV0neZmWiyykbgSqdVRlobw8ERt
         1cAA==
X-Gm-Message-State: AGi0PuauwfpEKY8SP3V1gkEhouESzQFr13qrXz0/M5wRtqPLkiH0f1Vu
        aITCDJ6A7/PXvkiM7n6NewIWBsuE1V8t6K4bB6w=
X-Google-Smtp-Source: APiQypINoCIP865Z1PjWDIxHES1z1ui7oERxj+R2/nSdMVlMel/fZqfjvxZlD3onMnJE8wogYdPogvuFxE9ly4cP6ik=
X-Received: by 2002:aca:2801:: with SMTP id 1mr1156134oix.141.1588290231959;
 Thu, 30 Apr 2020 16:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
 <1588055009-12677-6-git-send-email-wanpengli@tencent.com> <66fd6180-8e8b-1f9c-90f1-a55af1467388@redhat.com>
In-Reply-To: <66fd6180-8e8b-1f9c-90f1-a55af1467388@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 1 May 2020 07:43:40 +0800
Message-ID: <CANRm+Cz_nxVXmBoHU6NQGRGKbK+MWtZ476376AMJtoWvH=Kbgw@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] KVM: VMX: Optimize posted-interrupt delivery for
 timer fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Apr 2020 at 21:32, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 28/04/20 08:23, Wanpeng Li wrote:
> > -     if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST &&
> > -         kvm_vcpu_exit_request(vcpu))
> > -             exit_fastpath = EXIT_FASTPATH_NOP;
> > +     if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST) {
> > +             if (!kvm_vcpu_exit_request(vcpu))
> > +                     vmx_sync_pir_to_irr(vcpu);
> > +             else
> > +                     exit_fastpath = EXIT_FASTPATH_NOP;
> > +     }
>
> This part should be in patch 3; not a big deal, I can reorganize that
> myself.

Great, thanks.

    Wanpeng
