Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE65948CB83
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 20:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356522AbiALTHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 14:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbiALTHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 14:07:15 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363CDC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 11:07:15 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id i6so5543984pla.0
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 11:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/E6LcRT46+1wvC1FNtzkLHlaM7J38R0FPn8cliv4VpA=;
        b=qsUNooEQNDBCnxbG0FLaC1OM64KjCFr+xvpND3ycqSBodr6CIhQgxjLl6UeXbNGbCd
         wDkkwBgUUM+GJ3czVIiot3ZKXLXjKsD/PVzKsUz3CPIZ5oRLbb395wZa3eB7QBvSyGE0
         M6ujxerWXtzQBwWwyDfycfLqv2gCJEJhhbuIOT86+NTjPBjK+JBxa38hBtAA2pIaX4mR
         60PdkxuNUKGzISBowjUEbrheQMhMjcZlCHMPFM6dNTxrxxte1bDedCXrsZAWG6uXUgC0
         bPO7vc34eGEM8LMw13GgsmMK04CpgUF1jJsKzeMKWfCSQvgk73y1pAWl56OgbO4/iHYR
         teOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/E6LcRT46+1wvC1FNtzkLHlaM7J38R0FPn8cliv4VpA=;
        b=cBkSEtHDoFeXhN0AxhUFFZJ1dwWuUI73OJjUVZ7e/IcWdHSVv89ax+AWDpTzHYLDon
         2cI191BS97wIMtd4d2VcArCX6Sk4i/eq4X8Vbwi/rMk+nmxo9AFJ6povmgnvMd3tsXp7
         +QAkj4qHu71kxOl0ywX+umQqUvBeEHqR+YVo1sXzZDIMcQuWhVo2K+vRMwap4Bq1iGBF
         ivIbNmINvuRKzXdrAkZE5Zx5Puryd38GuC1xPMBK+QrneufunsFvU0wXM6HNxdNILTc8
         a+dqhvxJScKYq0Yg4xJGasrMTHnv+0ELKBBdOTEBY343dagcPkH5ea9MCqm1KKOdNCwP
         RcaQ==
X-Gm-Message-State: AOAM530uQuxqM6vEAsobhwr60aV/2vkCK3FOYJZtbHLmq9T83Y0BIK/t
        b9UaS8r7oI9PwocFNTAwMh8fEQ==
X-Google-Smtp-Source: ABdhPJxMEkpSjEwGJFbpw1qoMan0wZMPMYOiaOQxTgFWzGT4vjTc3UPc+1oPzOCirQw6S1Poz3Rsjg==
X-Received: by 2002:a63:338c:: with SMTP id z134mr880544pgz.459.1642014434409;
        Wed, 12 Jan 2022 11:07:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x15sm364293pfh.157.2022.01.12.11.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 11:07:13 -0800 (PST)
Date:   Wed, 12 Jan 2022 19:07:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Li RongQing <lirongqing@baidu.com>, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Message-ID: <Yd8m3SA/77LRKOJH@google.com>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
 <7d96787e-d2e8-b4cd-c030-bcda3fe23e55@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d96787e-d2e8-b4cd-c030-bcda3fe23e55@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Paolo Bonzini wrote:
> On 1/12/22 18:30, Sean Christopherson wrote:
> > > Uhhmm, why not? Who says the vcpu will run the moment it becomes
> > > runnable again? Another task could be woken up meanwhile occupying the
> > > real cpu.
> > Hrm, but when emulating HLT, e.g. for an idling vCPU, KVM will voluntarily schedule
> > out the vCPU and mark it as preempted from the guest's perspective.  The vast majority,
> > probably all, usage of steal_time.preempted expects it to truly mean "preempted" as
> > opposed to "not running".
> 
> I'm not sure about that.  In particular, PV TLB shootdown benefits from
> treating a halted vCPU as preempted, because it avoids wakeups of the halted
> vCPUs.

Ah, right.  But that really should be decoupled from steal_time.preempted.  KVM
can technically handle the PV TLB flush any time the vCPU exits, it's just a
question of whether the cost of writing guest memory outweighs the benefits of
potentially avoiding an IPI.  E.g. modifying KVM's fastpath exit loop to toggle
a flag and potentially handle PV TLB flushes is probably a bad idea, but setting
a flag immediately before static_call(kvm_x86_handle_exit)() may be a net win.
