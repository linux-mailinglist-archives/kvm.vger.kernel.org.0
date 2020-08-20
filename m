Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF58C24C7C1
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 00:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgHTW3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 18:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgHTW3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 18:29:09 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E25FC061385
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 15:29:08 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id l204so3315346oib.3
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 15:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZbJOUvrr39DetrYaNu8Aw1l2Kc1EsYm0qqTkYiF+RSo=;
        b=Hci9tzMkgpaQuMlJUp4nYpZIfjvAvpqgcTFkVPGOowL4s/Dp4Y+zsFMDfKIHQKQr6w
         BYc6r1UWA2pUZaMx7UJHBii6uVyEqD9Nq2qJSlXTxOFkJo80PhV/TAyKEKlkQ7vsG81s
         0AW2X5fECPIDYTL4WCtN4rCQQwE/QgG/gYAquXDvveK1Pd3UN6hxB536gbphKKUeXYPl
         8Z2BZ/FATbuZ50CPT99Zx/h76UyrMN71rMjiPC/FrBwndZd8M0SOc9wC26Cx3irqW7GI
         2BPoVgCHfuqXyENu2ITfnl1Vlw8wGEf0lCeegVJVUSQW8fLd5O6rrLiwX4jqtP5J+M/I
         RhpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZbJOUvrr39DetrYaNu8Aw1l2Kc1EsYm0qqTkYiF+RSo=;
        b=G2nTBO5mP7VaayZ+zgl7GnfDsm3PrytnTq/GG8+hH2UWbvEm5OECTvugf3v13lS9fO
         VPNyLzK4sZMWw6155TJyaPqNqnSnyK0edF+NDykMkKg5eb5VPBfXJR6gN/5L7agnDrJY
         sV+TwGCcbyjsU7kuVYF3ONRZ5XlI+joEf1/sFDRgoeMndiIRHIjqBlSvp3gUz+LaS6kG
         fSvtFyLOXXfc8f8667/fOYmfbjzBHA245R581NpGlziobxIAIHzLtPEju+zuy/P/0FUH
         GyBD3gaW5pllxUS0Z9+Wz92XptnFYnB/SRuiLW3YSTUtfzZO/LgiBLEz6r26BrPIOXD7
         KZJw==
X-Gm-Message-State: AOAM531TqZdNOIzn9mbWqhNbXZswYg69bqp9By4GK4/GQVvyaBrkHRF8
        wkT9UPMGkyu2EVQxG8w+Eo6HVpkqJBNVr23Dd6A6wQ==
X-Google-Smtp-Source: ABdhPJznspehsQ9XINRb2DinTqmDlgR+ebrK8fz4JZp0gfn35JVCSsp6iME6moNsRLZt2vYVSESkMFc5K74ezzZf7i0=
X-Received: by 2002:aca:670b:: with SMTP id z11mr80750oix.6.1597962547012;
 Thu, 20 Aug 2020 15:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-5-aaronlewis@google.com> <b8bbbd5d-9411-407d-7757-f31e1ee54ae2@amazon.com>
 <CALMp9eT5_zq52kzQjSM2gK=oQ1UMFNZhNgK0px=Y2FLzxHxqhA@mail.gmail.com> <c9ea8956-69e1-ae28-888a-06f230a84a53@amazon.com>
In-Reply-To: <c9ea8956-69e1-ae28-888a-06f230a84a53@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 15:28:55 -0700
Message-ID: <CALMp9eQ0xSQi3UsnZDDtQj-A9FiNZZ9SmDmuK5cJ5uXhYB5Y7w@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] KVM: x86: Add ioctl for accepting a userspace
 provided MSR list
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 2:49 PM Alexander Graf <graf@amazon.com> wrote:

> The only real downside I can see is that we just wasted ~8kb of RAM.
> Nothing I would really get hung up on though.

I also suspect that the MSR permission bitmap modifications are going
to be a bit more expensive with 4kb (6kb on AMD) of pertinent
allow-bitmaps than they would be with a few bytes of pertinent
deny-bitmaps.

> If you really desperately believe a deny list is a better fit for your
> use case, we could redesign the interface differently:
>
> struct msr_set_accesslist {
> #define MSR_ACCESSLIST_DEFAULT_ALLOW 0
> #define MSR_ACCESSLIST_DEFAULT_DENY  1
>      u32 flags;
>      struct {
>          u32 flags;
>          u32 nmsrs; /* MSRs in bitmap */
>          u32 base; /* first MSR address to bitmap */
>          void *bitmap; /* pointer to bitmap, 1 means allow, 0 deny */
>      } lists[10];
> };
>
> which means in your use case, you can do
>
> u64 deny = 0;
> struct msr_set_accesslist access = {
>      .flags = MSR_ACCESSLIST_DEFAULT_ALLOW,
>      .lists = {
>          {
>              .nmsrs = 1,
>              .base = IA32_ARCH_CAPABILITIES,
>              .bitmap = &deny,
>          }, {
>          {
>              .nmsrs = 1,
>              .base = HV_X64_MSR_REFERENCE_TSC,
>              .bitmap = &deny,
>          }, {
>          {
>              .nmsrs = 1,
>              /* can probably be combined with the ones below? */
>              .base = MSR_GOOGLE_TRUE_TIME,
>              .bitmap = &deny,
>          }, {
>          {
>              .nmsrs = 1,
>              .base = MSR_GOOGLE_FDR_TRACE,
>              .bitmap = &deny,
>          }, {
>          {
>              .nmsrs = 1,
>              .base = MSR_GOOGLE_HBI,
>              .bitmap = &deny,
>          },
>      }
> };
>
> msr_set_accesslist(kvm_fd, &access);
>
> while I can do the same dance as before, but with a single call rather
> than multiple ones.
>
> What do you think?

I like it. I think this suits our use case well.
