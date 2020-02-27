Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6031725CC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 18:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbgB0R6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 12:58:38 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33149 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730169AbgB0R6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 12:58:38 -0500
Received: by mail-io1-f67.google.com with SMTP id z8so469526ioh.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 09:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B6rcGpYawUM9m0yQ03WTjODUvPD3hJBe9AVyTeKl4kE=;
        b=d7e7wn2sW4fGC0sWWBJzzxX6uQVEv7ov2BhIMQGfHey0s8ln3v55U/sJ80lR4nGtJU
         /K+xiyMbPRZyofaPHoPRKExmGn5dsXUOpeJ420oh/J9N+3qNMndlB9/h1onyVpoUCszg
         oGo1CDtBAFVpNjaCYPIWjMSCWzOgPHRkpDtPfjoSFhiFNxKt3K7/SpiZs7V5ZEMoeoI3
         0MPofhHFBLnyb9uNvUwHfbtamziwNA04RbYlVHKCToNDkV5kQFirkxaIe562qujMyBbi
         ie5ZCkdqdfK0fKuZJx62tSj0qgWXCY7Q7j3T92CdJrdPFtkAHhev2dV3QOYkkiPgzQC3
         bi0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B6rcGpYawUM9m0yQ03WTjODUvPD3hJBe9AVyTeKl4kE=;
        b=XrtcBT44WDCjnNhayurtQvYylAbFFHIgt+OxYNNhLfXBa8waR0Wv8hsKtgNEBaJ/xF
         RyoueEbE56L5lmGvFsVxme2kszBfunMBo4oia6FogDOwfwn2KZubBOJTkYQgkMen6xwl
         7AkbcvPCASg5emUvb7CchLNqL+f1VETQKI/9Zqyptze0X2+U3vqK5XXq6GUTkak9PNL2
         qqFeZZUFxa/NKnCQ+IUS836zK/qv+suIZNksMcKL73F4mpFWnRh+9QS3Sy9PplfjUTKD
         5ZvFnc6fyzH1zPSjJQ4aGHS0hZSCnp4aOOBHVrkExvCnc3Ih0p7uMK/CFHdhXLJoqRSm
         pPqg==
X-Gm-Message-State: APjAAAWYG2KdbcKpgvaZBwHLiqPgDglLA0320GSErJlaUOzhrbUKn2jl
        irZdI2wEBwzzBHZAGmOZyyH5gfrNINYptCEZKrBeaA==
X-Google-Smtp-Source: APXvYqyhzy6uk8Ophi2J6HBvyjfvSvIOFDQ7BS2sQE4GvT6DxIQKE46TgCUwsJZdOmdqvF0M2DO8Yp6Zew1drla42GY=
X-Received: by 2002:a6b:740c:: with SMTP id s12mr452251iog.108.1582826317684;
 Thu, 27 Feb 2020 09:58:37 -0800 (PST)
MIME-Version: 1.0
References: <20200227172306.21426-1-mgamal@redhat.com>
In-Reply-To: <20200227172306.21426-1-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 27 Feb 2020 09:58:26 -0800
Message-ID: <CALMp9eRPxc6OuFZhrbyDJWhkrhtOeBWD5qSwkgg5RuVx8F_RqQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 9:23 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> When EPT/NPT is enabled, KVM does not really look at guest physical
> address size. Address bits above maximum physical memory size are reserved.
> Because KVM does not look at these guest physical addresses, it currently
> effectively supports guest physical address sizes equal to the host.
>
> This can be problem when having a mixed setup of machines with 5-level page
> tables and machines with 4-level page tables, as live migration can change
> MAXPHYADDR while the guest runs, which can theoretically introduce bugs.
>
> In this patch series we add checks on guest physical addresses in EPT
> violation/misconfig and NPF vmexits and if needed inject the proper
> page faults in the guest.
>
> A more subtle issue is when the host MAXPHYADDR is larger than that of the
> guest. Page faults caused by reserved bits on the guest won't cause an EPT
> violation/NPF and hence we also check guest MAXPHYADDR and add PFERR_RSVD_MASK
> error code to the page fault if needed.

What about the #GP that should be delivered if any reserved bits are
set in any of the 4 PDPTRs when the guest loads CR3 in PAE mode?
