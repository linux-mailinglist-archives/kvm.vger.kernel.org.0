Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96431BCF01
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 23:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgD1VlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbgD1VlX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 17:41:23 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E32C03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:41:23 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id b18so456973ilf.2
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ACzZs1Ub+JzPwjWlCZYoqLzSKkXLRHQ5teSCbVf10s=;
        b=XFPYW2FlDIVWJgOGjHnYsmAIs6v5bOTZkYeIYocvCjVgP550WJIVaORVFld3lr7Z0e
         slAXY2KTK7LNaYj/wGJ19zMz69GV0kwea/5nhapSWD7JKTxrYUfkJgueJFQscnx59imW
         gOO8hzWxVPfZrbk4vd8qKlVzvjtUHdYVp9Vx1kwawTZQnX1mmhrhdkqvv00rdIT6yxGw
         y2yOFWuB1tKgA6AWKi0scouvr26eF0+Gwx5QCW3MHAq5c3Zuzt0ksjCZH+2EfxWsQZ2x
         ymct5MBpwtQaNMaP6bptME0TjRCAvAqIaAPMPKzPyFgD35bGRiMozRc2uRmCfgzcPCVf
         EQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ACzZs1Ub+JzPwjWlCZYoqLzSKkXLRHQ5teSCbVf10s=;
        b=KCyh7ULg2PyLRgf6y2VX2a/SIXP+c4HHM86mGQVmAKdD8x0hcjAYp1GTgbfCmimxjX
         zzRosXEcMAkU8aY8AkIkpMmqlid/1ldZOY9DfssqUYLOZeKfmX7A1FSjcvnvzvbq8vaX
         wBeT+QmCc+WHR/lMILnRbzYqb8DeuA0XxyEWq4zSJVCD/rScQE1RtQ/6NRozt2jfsnKJ
         xjN65ZxXYghD52Q3cJRtPbp9+xeGD1Rpfw0l1UDmk7O2GXGs/+xhqGwmOEUHrB/OwFou
         dZD5j+1LtKjRJ2M69FIrPBFV9q+4z7pNpLWfZDOVeofJCz1HNYhOlyBtsc1n8D9BZLR5
         G8Ig==
X-Gm-Message-State: AGi0Puanl7zteMiFZAhzFZVdt2LQleso2ZnB9+0e/AxEP7lUv9lBY+Ni
        A4Ge82NgiBNJlbciTWa+FTW0EKXYSi/0195PzHk8XQ==
X-Google-Smtp-Source: APiQypLBJxGTQ600pk4rW9iLud+TLfvYfvqO2ZQMUlxQ62lebdRmOwhwL5+cYPtQgLRGFxGy/hObNKTAiobNelwKai0=
X-Received: by 2002:a92:d8ca:: with SMTP id l10mr28452120ilo.118.1588110082556;
 Tue, 28 Apr 2020 14:41:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-4-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-4-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 14:41:11 -0700
Message-ID: <CALMp9eR9bVK4p2ca-N+=PThmMF2UhzE8DvBDUke69ygDE34Uaw@mail.gmail.com>
Subject: Re: [PATCH 03/13] KVM: x86: Set KVM_REQ_EVENT if run is canceled with
 req_immediate_exit set
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Re-request KVM_REQ_EVENT if vcpu_enter_guest() bails after processing
> pending requests and an immediate exit was requested.  This fixes a bug
> where a pending event, e.g. VMX preemption timer, is delayed and/or lost
> if the exit was deferred due to something other than a higher priority
> _injected_ event, e.g. due to a pending nested VM-Enter.  This bug only
> affects the !injected case as kvm_x86_ops.cancel_injection() sets
> KVM_REQ_EVENT to redo the injection, but that's purely serendipitous
> behavior with respect to the deferred event.
>
> Note, emulated preemption timer isn't the only event that can be
> affected, it simply happens to be the only event where not re-requesting
> KVM_REQ_EVENT is blatantly visible to the guest.
>
> Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
