Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68632257FAF
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgHaRgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 13:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgHaRgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 13:36:53 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6373EC061573
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 10:36:53 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id j3so6011358otk.13
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 10:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E3KvScyvHzVRYf0RMPiy6x1jOQmJWglaF+6I1c23uFY=;
        b=Hr2aMXSVXg1s1+r7dM0EKKRt59ublxHBQ0MrlCeTvrZ1iHjR4G0NlFh6YCU90q61uB
         shwvxPAWNUpPsx9gdwQ/5nP8Yu2FuvY1VBYqt1c9IrLq8MPPM1TIJs1Qrrr06Z/GDGZe
         ALcfp2lIoLLY3UQgYRJ+PQIlw0FRj7cwpLFqx8B6FVvPaDZRQsRO5OZtR4KGxa9hw7vO
         5BMahIj5Nzw7E7HZ4RxdgnHeo3zkLqt+mn6y2Br5U/4RvqmASrcJ1ZC7sinIBIegwsS5
         l8J0ibf4qloHBue5G5U0Iz1mA0tz0hToEAU6cER7ERSA1klITxRU54g2syrZtCnAmtjd
         a/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3KvScyvHzVRYf0RMPiy6x1jOQmJWglaF+6I1c23uFY=;
        b=UdMj3Fz1WNdkNlZ/moRUuT8YP+NHs2fA7fryCsy75AOT6Fm7cXlShg/huszpJmBbXY
         ZlUO6V9LIemJQGuv5JmX2fBQ81fkny3GFhB6JEmMP5z3eCpq0fEvx9rD3NclFLLB47z9
         rhAAJofnzk2Sv/Ob6jmoWeO7SjLGbkDYovyHiV1TX6hHo7ImbDTK4jLBuZuSPM7OxUlQ
         kTWX7bRVjyF6Ys8ZiUeqhclgjWFD+DLmU3zTXbecNfUYpMpZUM33e61Gp7POrLk7jKhW
         sHZWgnpI+TcMXiDonZmBGhm3S32tyV55kxh2EpQ+G06uMF4XecvIe7Ls1RC/b9stMVkb
         KEDA==
X-Gm-Message-State: AOAM530gz7ifNCCGmsrn/q1fUvubbbJZgA39dkJJr2p5s6EErcDQaNNO
        6pRitgKvxrjhjXwjOGMs3nUoazU6XzWOH5vGBrLGuw==
X-Google-Smtp-Source: ABdhPJwuMU4T7Ks3GLhpcZrjLrGzbpc/wn3gKCrvX7lv1zT7v1CT/3febeogy2pLUzx/7CFwmiVu1EGceOT3zLqJHPY=
X-Received: by 2002:a05:6830:18ca:: with SMTP id v10mr1726338ote.295.1598895412501;
 Mon, 31 Aug 2020 10:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200828085622.8365-1-chenyi.qiang@intel.com> <20200828085622.8365-2-chenyi.qiang@intel.com>
 <CALMp9eThyqWuduU=JN+w3M3ANeCYN+7=s-gippzyu_GmvgtVGA@mail.gmail.com>
 <534a4ad5-b083-1278-a6ac-4a7e2b6b1600@intel.com> <1fbfb77d-4f28-bcb6-a95c-f4ac7a313d2d@intel.com>
In-Reply-To: <1fbfb77d-4f28-bcb6-a95c-f4ac7a313d2d@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 31 Aug 2020 10:36:41 -0700
Message-ID: <CALMp9eRPLDgOkOj_chveHjzzx_PXBOb3zKNkrKTXMr=C=dENRw@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: nVMX: Fix VMX controls MSRs setup when nested
 VMX enabled
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 7:51 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 8/29/2020 9:49 AM, Chenyi Qiang wrote:
> >
> >
> > On 8/29/2020 1:43 AM, Jim Mattson wrote:
> >> On Fri, Aug 28, 2020 at 1:54 AM Chenyi Qiang <chenyi.qiang@intel.com>
> >> wrote:
> >>>
> >>> KVM supports the nested VM_{EXIT, ENTRY}_LOAD_IA32_PERF_GLOBAL_CTRL and
> >>> VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS, but they doesn't expose during
> >>> the setup of nested VMX controls MSR.
> >>>
> >>
> >> Aren't these features added conditionally in
> >> nested_vmx_entry_exit_ctls_update() and
> >> nested_vmx_pmu_entry_exit_ctls_update()?
> >>
> >
> > Yes, but I assume vmcs_config.nested should reflect the global
> > capability of VMX MSR. KVM supports these two controls, so should be
> > exposed here.
>
> No. I prefer to say they are removed conditionally in
> nested_vmx_entry_exit_ctls_update() and
> nested_vmx_pmu_entry_exit_ctls_update().
>
> Userspace calls vmx_get_msr_feature() to query what KVM supports for
> these VMX MSR. In vmx_get_msr_feature(), it returns the value of
> vmcs_config.nested. As KVM supports these two bits, we should advertise
> them in vmcs_config.nested and report to userspace.

It would be nice if there was an API to query what MSR values KVM
supports for a specific VCPU configuration, but given that this is a
system ioctl, I agree with you.
