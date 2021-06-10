Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F913A34F8
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 22:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFJUlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 16:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJUlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 16:41:24 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63535C061574
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 13:39:28 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so1015932otl.3
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 13:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ck7H0hz6o0YhV91Txi7wpOJIaqu4RijViLYlRdIhLfM=;
        b=By+NnpKGJuanFoeLYeT24kdQmKVTzcBSAxXmtf6j8dEQXv2QKv0JRz8NGNQDUR5Vri
         YUukEDPtppsh+UCHr54/dFztxlzEkHHdp5e2PtCh8Yb3Z0eX8BQw2eEt10YLFj1gp/x+
         /NOQ9Mdy4xgmiC3vwJff9lLLKSrlC6LJ3Tz4CaDTti73oPpF2ZKlEi96/uAC2HHfXWa/
         JR93BBJrxCfAwXdWsiEkJUcAcC/frNbRoSotCKPcvgsvwNe3QlMNrHqCR5StNBvS+ss9
         /3lFdSix4TqRmT6ib7MvoiDgLrAI0dtvFNmiVweKFQAEsFqxSGWUS4h/dPfT04W+oUhv
         Lc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ck7H0hz6o0YhV91Txi7wpOJIaqu4RijViLYlRdIhLfM=;
        b=l7HcT90942f/Ca9ZLuGHujO1dopAqNeVZo3iIBw3tEerfTpw7cx74HAF4lx00qNg7d
         4sMxCllZh07yhVTrurUvn3iEcnMRHEZm0QPF83IxAkDgL5oYl3FuSfBiZuvlo0Czgi9c
         Iln+CB4Fym77zM492Ypb4OoQ19h0uyszf8aW3Xenyo+Uqzha3TXiNOM/XDLgwV7qUQ9U
         09Q+N4ZfN7SbIrkmKRMrioUKvSyEPpc6+3sKvsdPmCCkdG5s3uhtJ05VZfWlC04NkkEL
         H8UjCZCj305Ln/wCF9Cg0DSX/DlKuwSmIBusAb8O2pXkeiC4BV+WYA3bGft0nStB2P0T
         oXuw==
X-Gm-Message-State: AOAM530vh3Tpi48kmL23f8AkVCN/GghVhjVG6OKmaS8b2/QWb8yYUEX+
        T4zIh9tJiIuc7+y9tS8kJW4QE85BKd4eVJgeqmu90dpP1ySa6Q==
X-Google-Smtp-Source: ABdhPJx5HQOFcgWVEOSLY6jmStUiPjWsmx6Zr8GjewGImpCvsFQXE4t4CXSYlyLDoJN+Bi7y4Ipn011Y2NqEOxS2H8o=
X-Received: by 2002:a9d:2c9:: with SMTP id 67mr217030otl.56.1623357566868;
 Thu, 10 Jun 2021 13:39:26 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 10 Jun 2021 13:39:15 -0700
Message-ID: <CALMp9eRWBJQJBE2bxME6FzjhDOadNJW8wty7Gb=QJO8=ndaaEw@mail.gmail.com>
Subject: [RFC] x86: Eliminate VM state changes during KVM_GET_MP_STATE
To:     kvm list <kvm@vger.kernel.org>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The call to kvm_apic_accept_events(vcpu) from
kvm_arch_vcpu_ioctl_get_mpstate() is just, oh, so wrong. First, it can
change all kinds of vCPU state, which imposes undocumented
dependencies on reliable orderings of the KVM_GET_* family of ioctls
for serializing VM state. But, even worse, it can modify guest memory,
even while all vCPU threads are stopped! Just follow the call chain
down to vmx_complete_nested_posted_interrupt(). That path wasn't there
when the call to kvm_apic_accept_events(vcpu) was added to
kvm_arch_vcpu_ioctl_get_mpstate() back in 2013, but it's there now.

I'm not entirely sure why this call was added in the first place. Was
this simply to avoid serializing the two new bits in
apic->pending_events? It seems that we now *do* serialize
KVM_APIC_INIT in the kvm_vcpu_events struct. Strangely, we call it
smi.latched_init, but it looks like we put the pending_events bit in
there all the time, regardless of what's happening with SMM.

Would anyone object to serializing KVM_APIC_SIPI in the
kvm_vcpu_events struct as well? Or would it be better to resurrect
KVM_MP_STATE_SIPI_RECEIVED? In any event, the call to
kvm_apic_accept_events(vcpu) from kvm_arch_vcpu_ioctl_get_mpstate()
has to go.
