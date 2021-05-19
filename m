Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4850D3886CD
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345428AbhESFlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345556AbhESFjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:39:18 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A3DC061345
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:36:11 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s4so4811531plg.12
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PF0Q9frtyuRcpG5BnVwblhIE9pTcOMwFzNkIPovg6ss=;
        b=fPntYKFrfOpVF5bsRxvyNYfSvgwcRiEFZauBnsgNc714SkShf+0dbqLl8QmDVYhrfH
         kgwFCSECHlKHRwVGCGHNvDDajtJHW6W6k8EZC8hvEZvwBw1Vt3CfRqFKSdty1pmnyJcC
         KHODAHZ3o/KfJGHNlrUR94dVV1ocjzG8NjPuf5CgVUVe37K4DALkP+uky+FyubR0mDxq
         7yudjjySKl1FF/foqnvQEba2Ra/eGdaMvVhmiAiWI9J8J2D8Gx1C0hNwm7XrAgrMX40p
         qN+i412QPwTL4OoOYS1g5p4JhO/9/zfIJfzb60IpMxup9jLBi649xfCzE+n9y77tfJvf
         MV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PF0Q9frtyuRcpG5BnVwblhIE9pTcOMwFzNkIPovg6ss=;
        b=YHeqw0KcdY9CWBv714Hsr1w5PP3FG/vKFQQkHbHPZ3aMMHk3YYpjkibg8LfpjoyoOB
         z4fOhMiFtQT+bhftVFOKdsjGC/VUi5obPAHg/FHB9yKyiDmcdYFLC0i+zEuLYE09Lu6f
         ydiui1wpDk/fbWu2uKHj+6PFfroDpL+lpvlg7RZDaAbB6bUtR0oSljMPMpcY4ApsFmZx
         Im1qNW3tphU003M3Q8Rd92tcmsXHLj0m9uIaM1T8Yam7twLPs+aLZ9tWjT9R6JdSCgbi
         myK3I217LxBRZGU6C9z8dVcDnxT/MIDJIQ4u8CnBNQK2ez1GyRe+5GKtFcg84P1Yo07W
         G1Ng==
X-Gm-Message-State: AOAM531212EYX8Pejk43Frg6AY6Swrplx3X9v/84g3H2NUshlIEI/fJU
        M4tTFPwwYBWJG8gM2T1SH+HzfGKcU6WTydWPUyuZCA==
X-Google-Smtp-Source: ABdhPJyA79FOqU3/Od6UZdXL1PxGWbUxYoT7oxm+gXEJ1WS7h82tWs1Q0kPfOgfMXPQz7HFvZPc3NztpIBNSyIqi+Nk=
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr5791984pjb.168.1621402571226;
 Tue, 18 May 2021 22:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-34-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-34-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:35:55 -0700
Message-ID: <CAAeT=FwtKXc6_gjf8YAx9yLn+aTXZ3rdzxXW-+dxPWR_mm=uDA@mail.gmail.com>
Subject: Re: [PATCH 33/43] KVM: VMX: Refresh list of user return MSRs after
 setting guest CPUID
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:55 PM Sean Christopherson <seanjc@google.com> wrote:
>
> After a CPUID update, refresh the list of user return MSRs that are
> loaded into hardware when running the vCPU.  This is necessary to handle
> the oddball case where userspace exposes X86_FEATURE_RDTSCP to the guest
> after the vCPU is running.
>
> Fixes: 0023ef39dc35 ("kvm: vmx: Set IA32_TSC_AUX for legacy mode guests")
> Fixes: 4e47c7a6d714 ("KVM: VMX: Add instruction rdtscp support for guest")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
