Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348BA39BC13
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 17:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhFDPkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 11:40:08 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:43532 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhFDPkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 11:40:06 -0400
Received: by mail-pj1-f52.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so6100124pja.2
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 08:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LS+pVGO6lepWheguoL9jNQS5bAjZn1OmNQofMIhLGLs=;
        b=dMutLh5fistVaDLzLU1mFkRhUBWIPLb//w/PNNl7WxFCXB2Vdbm14D0/ITQsvyYl1k
         VKQzxaWLpzLVkUxn+Eo6i1Cd1fo6dhonC9q98hriiNob6Yy9RnjZ5/iZvTYTgR13zBJW
         IUX1vA8zJAAQrpTbfTbDpHqSRqxtvTwponEL3WNiQMbQYQDR8VKnRLEFpEQZ6dHeN2X3
         plkqygYxnu8mii23D9UJzCzeqf5qZVKhDeH2GmBiSvhQMiFZGAr53a2bJixttQr5oW4w
         p2vT/2x3gVdw6GfVFR1YvOjz/xUyT7p1N31cjrjBMoKiglMySuSZKHse90tVPJ3ELqFR
         GLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LS+pVGO6lepWheguoL9jNQS5bAjZn1OmNQofMIhLGLs=;
        b=VSQKpCnaTWOGMprsraP4bao3S7HLanlgzfg3EBh+mOoB7w6+YRzm72PVntZ4sBFCpR
         1fGNJ9vhi4UutpMSGn8EWIUZt9vUCPeEhFAisysZVbAYsP4pH+DzP6blhcPu/quHRMpz
         n06gFJTdZ+Tq55bUoOBOGIHig8JTd37xvbcBo/CoTYh5PeBmLDutJrqi3a6Q7bK0r7K3
         PRdD0gFT9dwus2oX+6LzMbo3FiRyzbmskADslxMrMT7cItYUGFcn23sCc6mzcqQgoErg
         J1XKSOuObSYUxHu+L03FrkG+rbC7/Tqj9jfW2trj3AxAZWEiL5BCjrhvI/Z0PJ1++gT2
         lDlw==
X-Gm-Message-State: AOAM533L8n5bkXsMMgpaD7hltUVuFyO6MvSclgNhVMSU23mFZulZ4YfG
        87EvJeA58N1VDeXpzh9OtYK6FA==
X-Google-Smtp-Source: ABdhPJzXCnn/exCbTxMz3psca2pXzg5HIQbkYkMNVsSI2w7AR3aChmi4WGl7T+1P8T3i7qGXXFuAug==
X-Received: by 2002:a17:90a:5507:: with SMTP id b7mr17218278pji.27.1622821027043;
        Fri, 04 Jun 2021 08:37:07 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m5sm2406492pgl.75.2021.06.04.08.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 08:37:06 -0700 (PDT)
Date:   Fri, 4 Jun 2021 15:37:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] KVM: LAPIC: write 0 to TMICT should also cancel
 vmx-preemption timer
Message-ID: <YLpIni1VKYYfUE8D@google.com>
References: <1622710841-76604-1-git-send-email-wanpengli@tencent.com>
 <YLjzJ59HPqGfhhvm@google.com>
 <CANRm+CxSAD9+050j-1e1_f3g1QEwrSaee6=2cB6qseBXfDkgPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CxSAD9+050j-1e1_f3g1QEwrSaee6=2cB6qseBXfDkgPA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021, Wanpeng Li wrote:
> On Thu, 3 Jun 2021 at 23:20, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Jun 03, 2021, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > According to the SDM 10.5.4.1:
> > >
> > >   A write of 0 to the initial-count register effectively stops the local
> > >   APIC timer, in both one-shot and periodic mode.
> > >
> > > The lapic timer oneshot/periodic mode which is emulated by vmx-preemption
> > > timer doesn't stop since vmx->hv_deadline_tsc is still set.
> >
> > But the VMX preemption timer is only used for deadline, never for oneshot or
> > periodic.  Am I missing something?
> 
> Yes, it is upstream.

Huh.  I always thought 'tscdeadline' alluded to the timer being in deadline mode
and never looked closely at the arming code.  Thanks!

Maybe name the new helper cancel_apic_timer() to align with start_apic_timer()
and restart_apic_timer()?  With that:

Reviewed-by: Sean Christopherson <seanjc@google.com>
