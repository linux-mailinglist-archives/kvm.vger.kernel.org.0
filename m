Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE74D25C8C6
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 20:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgICScy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 14:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbgICSct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 14:32:49 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239FEC061245
        for <kvm@vger.kernel.org>; Thu,  3 Sep 2020 11:32:48 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id e23so3626001otk.7
        for <kvm@vger.kernel.org>; Thu, 03 Sep 2020 11:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=82HbmK1MEBIFmpgC+4ObPuGeXfJ8JE9e+JzzYbyM3tE=;
        b=X94xHdmwtOXvMxEcdgfpcX4mJtVehcidGAiYCw1Vog/RSDUzgYyod31XsjIavxEQbY
         4xEewzsKjrW3iUx+Y62sBhEBrAdv/m7FZfXszs7J7ppNdjEgwUkM6mJRiP3O1DtVpTWz
         HYV1nQfMyT8IsbhYIy4jmpPqZo/OUsUycK75ro178LPy5svxyfJL9XJsdw0ajeIHttQt
         C/uOGw/OcqNlCn9lsGsA0E1TMvN2xL+9eXVwwVdA17l/A3hey850rNFp+jSw/F4L9k/r
         4P4TRpf8O4VTdBIJ/wIa60c8xQlAi+UZFXizgBr/WhHOwMtMS62EqI0d/HCF1tA20oaO
         ylpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=82HbmK1MEBIFmpgC+4ObPuGeXfJ8JE9e+JzzYbyM3tE=;
        b=CGiYijUfVSgNqDToxyFRwGPADpy2tE/FJW0ccKsPGIC3o3QkDbdb4rPsxheMe0/maj
         PL0mFqpY5oepETZa0En+5QgRDDJhQIJUaU3YPmuAZ6fK/wbKY+lNdtF7QX/QR7+SlJvk
         ecKqmiHG7Y+5m9BvIhqK5mGMJha7Uf/I0aQa6cH23INoU407qpiAIxwkVmVegtuawPay
         qYragi98LKlV4LeTdycbuBuIFXeJirE97bccy+dYj8g0vp13K2EZEgbSe99wRTBM8EAI
         sWzh7CTNSvhJjNGJoudnd4TeTgwAGTWXnKxNx9PavKJKPmA5Nmt7hEf/w/W14dAyZMPX
         ocyg==
X-Gm-Message-State: AOAM531KhpBqBsesWUPoYEEJNtKXBuw2ilZoo8a8q9u3IGs81YWrm3BO
        5Y9KvvFvFgVU2QC3Bl8XeKlAoULeNaQ8rK/U2ZDpcA==
X-Google-Smtp-Source: ABdhPJx4FulqrTQ3lfTEcpEmm4pBJFjbKkKsoNqSqromwGpcbyaKjofyMNw2dD4agncvN2jgU3ZkvPOHjE/BxR0dyUo=
X-Received: by 2002:a9d:1c8f:: with SMTP id l15mr2563980ota.241.1599157966243;
 Thu, 03 Sep 2020 11:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200903141122.72908-1-mgamal@redhat.com> <CALMp9eTrc8_z3pKBtLVmbnMvC+KtzXMYbYTXZPPz5F0UWW8oNQ@mail.gmail.com>
 <00b0f9eb-286b-72e8-40b5-02f9576f2ce3@redhat.com>
In-Reply-To: <00b0f9eb-286b-72e8-40b5-02f9576f2ce3@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Sep 2020 11:32:34 -0700
Message-ID: <CALMp9eS6O18WcEyw8b6npRSazsyKiGtBjV+coZVGxDNU1JEOsQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 3, 2020 at 11:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/09/20 19:57, Jim Mattson wrote:
> > On Thu, Sep 3, 2020 at 7:12 AM Mohammed Gamal <mgamal@redhat.com> wrote:
> >> This patch exposes allow_smaller_maxphyaddr to the user as a module parameter.
> >>
> >> Since smaller physical address spaces are only supported on VMX, the parameter
> >> is only exposed in the kvm_intel module.
> >> Modifications to VMX page fault and EPT violation handling will depend on whether
> >> that parameter is enabled.
> >>
> >> Also disable support by default, and let the user decide if they want to enable
> >> it.
> >
> > I think a smaller guest physical address width *should* be allowed.
> > However, perhaps the pedantic adherence to the architectural
> > specification could be turned on or off per-VM? And, if we're going to
> > be pedantic, I think we should go all the way and get MOV-to-CR3
> > correct.
>
> That would be way too slow.  Even the current trapping of present #PF
> can introduce some slowdown depending on the workload.

Yes, I was concerned about that...which is why I would not want to
enable pedantic mode. But if you're going to be pedantic, why go
halfway?

> > Does the typical guest care about whether or not setting any of the
> > bits 51:46 in a PFN results in a fault?
>
> At least KVM with shadow pages does, which is a bit niche but it shows
> that you cannot really rely on no one doing it.  As you guessed, the
> main usage of the feature is for machines with 5-level page tables where
> there are no reserved bits; emulating smaller MAXPHYADDR allows
> migrating VMs from 4-level page-table hosts.
>
> Enabling per-VM would not be particularly useful IMO because if you want
> to disable this code you can just set host MAXPHYADDR = guest
> MAXPHYADDR, which should be the common case unless you want to do that
> kind of Skylake to Icelake (or similar) migration.

I expect that it will be quite common to run 46-bit wide legacy VMs on
Ice Lake hardware, as Ice Lake machines start showing up in
heterogeneous data centers.
