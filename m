Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93847255FF2
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 19:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgH1RoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 13:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1RoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 13:44:12 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CB9C061264
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 10:44:12 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id j18so1363492oig.5
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 10:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ka2toJ4SYrtlIK7dbmXsBvo9OeZt2glE+FJPcFz/zOg=;
        b=DPn2RIwp6mfg1MAUt4+Srg5bxuZEx9fYANzGEqGJQISQOlLQrLguIJHV66Rnh81Kr7
         ZZrhgcDcafPJ9LPgWeWeK0F9/LjLT2yAZ7g0EKpo0rc2iDU718WC1UKs3kqUB0LSZFNl
         p9+C1x/wEwBdKQN2ZWy4G9+H4fvx9PJT+3kXCa0j5GkPg2cHu6wbckVO09UfCTzjq1+x
         TC1KtbUzV7qK4BULbgVwydqRTQ3Z7EwMDqj4ujza52SjWvLnCx3Egyk7+XCAps6SL+cW
         JF04vt5QmT69IYNlPK3wIruGGd5KdqR8eIOpkBc295doloy0Pvd4+e2vUKmDwoBjomqG
         Cl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ka2toJ4SYrtlIK7dbmXsBvo9OeZt2glE+FJPcFz/zOg=;
        b=ooBBtri80oWgrrlWCNqUznWxv12v1A6GCNkpUiCRztz2pZTRuj3JkHBBbq1Xf9MEES
         HhC/ngUH632K+fdVe6JA1WoTVx4jgR4OridcjMcxVcZaWY3MMUOMsSdOuxpinypsl1Cb
         ZcltilVcUMzF9JSdSyN7yh6nFig/ER1W8nb6OELQd74mJAx+dR1gvpjQUlhUpALZh4/L
         /aLEq9icveIDsvSckQCnSy4ueD3JCm1tWRSShdOgNdm+LQ4dTr7UF9freDqA03PjQriS
         B175VEgHBArQwVAXBFIUo3gyQG7aIVov8WlHuM9xzxSKrkaU1tgLTMJRjTZ1ctEkicrV
         CxiQ==
X-Gm-Message-State: AOAM532XQyqbTE34yo6HHO2J3dc7VX7QqSk/ii3I7GYi7KMjU7FvkaX5
        JaAvNNxAPiOGPIVlUdyKSMxHeEFgYsMVaYkY6Fi6oQ==
X-Google-Smtp-Source: ABdhPJxtNn8CA5FcxTF8jvHIbj/TkyPMxjPH3XVVcKj9TobvyTQ7+5i4iEqy1KoT4MrD8qO7vzAqYY9rmtVb6NjlbJE=
X-Received: by 2002:aca:4b12:: with SMTP id y18mr125116oia.28.1598636651259;
 Fri, 28 Aug 2020 10:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200828085622.8365-1-chenyi.qiang@intel.com> <20200828085622.8365-2-chenyi.qiang@intel.com>
In-Reply-To: <20200828085622.8365-2-chenyi.qiang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 28 Aug 2020 10:43:59 -0700
Message-ID: <CALMp9eThyqWuduU=JN+w3M3ANeCYN+7=s-gippzyu_GmvgtVGA@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: nVMX: Fix VMX controls MSRs setup when nested
 VMX enabled
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 1:54 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
> KVM supports the nested VM_{EXIT, ENTRY}_LOAD_IA32_PERF_GLOBAL_CTRL and
> VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS, but they doesn't expose during
> the setup of nested VMX controls MSR.
>

Aren't these features added conditionally in
nested_vmx_entry_exit_ctls_update() and
nested_vmx_pmu_entry_exit_ctls_update()?
