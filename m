Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63DE368EB2
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 10:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbhDWIQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 04:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbhDWIQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 04:16:07 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7CFC061574;
        Fri, 23 Apr 2021 01:15:30 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id u16so31164282oiu.7;
        Fri, 23 Apr 2021 01:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTgYKXVFN4z09HpmN1O6TXEkHZJ19ni7p0W0OFc/XYA=;
        b=ik2Q6Z3wpY5lOE8J+UQbLUUMuQfnRBx/FK+TB+EvupFs3gvyNdt3yUHiSKS7In+Y9p
         k62QLI6AfpvDIuGo7vodSr9IGHazllQc6sTvmokp8cL5jBm4RQVRceGzYobQOFrq/JMd
         uY5dXUK7skZKYwYKunJsjYlD9ZwGLvTmO1hSJYw5v72TLHuVJTdKCgUlxaDKDGUOTzDQ
         cQtLCLmszlZnhzP9CXuQ9krxad9LqlPBk4rIrp7Say/LsKa95Q1yR62oFxY8OSs462Sv
         aCcQZMdBF+ymkLwmr5ZOjz3OrzNGoURxWmmEF3LSaAvXryo2vLi02DxEPvZua7c0DXL1
         Bzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTgYKXVFN4z09HpmN1O6TXEkHZJ19ni7p0W0OFc/XYA=;
        b=O6Br7sfyvLQlNe9uLErrvfGGO+fbJIo/8x2fyxoNJ8P5gdw7z7QYkls0fwbLAFWJnV
         kkRe3J1ItOa3dy+2anyIBP/ZLJ+fmjlrCBOt/54seC8E4iKFY6UNVIdg1vLYfAjWgHja
         vVIXtKzX4XxeYvf/bmpV/dAMwVw4sWGMCB3WIqOvq6LomlkBwOusD18PjETEYVVUQcu7
         u1pMtIc5uXawHpj2q+VFby8zDE5Qg06qlvyV9pYxh8tFUdVbNB3B/KG4D0xuhWLL4Nxd
         tdy4WVwiRU6HIYFEDf1GiepVWdIOnd+PCZsShwYJjH599UdLMqDjL7m5lP+5K6f+ZgsY
         18hg==
X-Gm-Message-State: AOAM530dQZla56zxOAcsZp5MKJi+BSGZsRu02+0Ej2PV19xzqCYWv0pn
        0Pt8WYi9qu2J56qlnmcFSmjuYI5vXkLkmo2CNUY=
X-Google-Smtp-Source: ABdhPJyysdq1QM5DrMQvundaY6dMneomaGYygEwKV4TNz+HAgaZxYrkFMtY5tYXGJDxMJ+1VGB8tyIyecpfcjp0lP8A=
X-Received: by 2002:aca:c08a:: with SMTP id q132mr2961354oif.5.1619165730242;
 Fri, 23 Apr 2021 01:15:30 -0700 (PDT)
MIME-Version: 1.0
References: <1619161883-5963-1-git-send-email-wanpengli@tencent.com> <f025b59c-5a8a-abf7-20fc-323a5b450ba5@redhat.com>
In-Reply-To: <f025b59c-5a8a-abf7-20fc-323a5b450ba5@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 23 Apr 2021 16:15:18 +0800
Message-ID: <CANRm+CxcqMW-m7WNmMv6uP3DusPTWmizf3AwOh9tY43HgrugBg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/xen: Take srcu lock when accessing kvm_memslots()
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

On Fri, 23 Apr 2021 at 16:13, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/04/21 09:11, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > kvm_memslots() will be called by kvm_write_guest_offset_cached() so
> > take the srcu lock.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> Good catch.  But I would pull it from kvm_steal_time_set_preempted to
> kvm_arch_vcpu_put instead.

Will do. :)

    Wanpeng
