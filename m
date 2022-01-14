Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC4B48EDB6
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 17:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbiANQLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 11:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiANQLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 11:11:11 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3470FC06161C
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:11:11 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id f144so2370890pfa.6
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tC8qJnbYbWP6QdaPJ2osPUbjtWXJeQECYSB26Wwwd6g=;
        b=UzerWBLJz+/e18gWqtzVZSrfcA2uZN3HhkdxVKNSglYHKiQSTQszmuhbEs5H1ePCwp
         BZQw5Jp1y+WZUj34UMw9L28z3W6ZfGwtmcqt1jZ6lXCoCvaw4EVdPpxh3L7XhLyNZ7lP
         bRAbpKjy9pLdsnZVqNN7O37U3TNPJvOcFqkboeMtjOPlzaClg1UnqYbEmCEf8ZigE5U+
         DrTrPpITf2dnTn5H5uQTzFqdbySFQxQV/hvj1jRW0UUxejHs8sVSWuUbEU1wdcrZh7sT
         rk9SoTH6eTwapLd3pHSHlaKz/+d50r2LnXN6tmtz3eFWrQNEEVvGzBLl5hcdt3fHVxBe
         /WJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tC8qJnbYbWP6QdaPJ2osPUbjtWXJeQECYSB26Wwwd6g=;
        b=EJHAgIaSf5/F9fUkuwPlYq1tSX9/dhAmnK5oLZ9a5DziNkRPoDWuvt1lbdWBZ6Kduy
         ZaZgq5Chve92xgHNqJS2W3NY8EusWox9h80UvMfiZJ9oPs1bKyoqalrIsF8jIQXdPsom
         Wy/RxET1pHrWBAgLUPkcrc/vcDXfjqCpCc/Lb5ddQVDfE2dnj9HvxjBSpwIomjGHFdfH
         jFNjAfsixMUYxH+GPv/7n5f2zeC6LukzPoTqUG8L5BdfAJQfM3DTdVlU6U08JJ/okUq7
         V0WsXznEXBbAT5VzUJtwzkhBqd/Zes9YPerDYfSwrISwu8qLP4eE0iTjRaff+Y/l+IzI
         GyFA==
X-Gm-Message-State: AOAM530sq4oTiR+f8Ddu7jlED4VYT7VmOTH8SXs5QfhD/AGZ1UyiGQSr
        ApCTgP1RBSsX4caFO+WN5Nra/A==
X-Google-Smtp-Source: ABdhPJw9sbYlwiqTiGOWMhWDdtz/PSNLiTHyi89hGB4PVkKlOL1eE3BFzC1pAxadmaE4KrkjL2H1pw==
X-Received: by 2002:a05:6a00:1413:b0:4bf:a0d7:1f55 with SMTP id l19-20020a056a00141300b004bfa0d71f55mr9533416pfu.13.1642176670498;
        Fri, 14 Jan 2022 08:11:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m6sm3417195pff.112.2022.01.14.08.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:11:09 -0800 (PST)
Date:   Fri, 14 Jan 2022 16:11:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        maz@kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        nsaenzju@redhat.com, palmer@dabbelt.com, paulmck@kernel.org,
        paulus@samba.org, paul.walmsley@sifive.com, pbonzini@redhat.com,
        suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 1/5] kvm: add exit_to_guest_mode() and
 enter_from_guest_mode()
Message-ID: <YeGgmgyz9q8AvpKN@google.com>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-2-mark.rutland@arm.com>
 <YeCMVGqiVfTKESzy@google.com>
 <YeFi9FTPSyLbQytu@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFi9FTPSyLbQytu@FVFF77S0Q05N>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Mark Rutland wrote:
> I'd like to keep this somewhat orthogonal to the x86 changes (e.g. as other
> architectures will need backports to stable at least for the RCU bug fix), so
> I'd rather use a name that isn't immediately coupled with x86 changes.

Ah, gotcha.
 
> Does the guest_context_{enter,exit}_irqoff() naming above work for you?

Yep, thanks!
