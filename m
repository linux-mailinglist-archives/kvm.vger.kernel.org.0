Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53BD3979C2
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 20:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhFASKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 14:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbhFASKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 14:10:07 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870B0C061756
        for <kvm@vger.kernel.org>; Tue,  1 Jun 2021 11:08:24 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so1908737pjp.4
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 11:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DnmoH9bekRYpYwPbGnzt8MqfxFmGQVDBVeFrYtSfJAg=;
        b=jNgEdYIMirBHf1RlWUpV+0XMt7t6M9Qb3u+Dm5b2Ko72L5Q/aswYluWEgM0Cf1LWE4
         hZ4M7fWl9C2A90MzYiCfu3In2kwCEUcJN5Zc0GAfv75NTC6ApAs0DyLtLGT5urQTNFrG
         7bLFUJEzE9nVbsd9R+hdLTvVTbmopnWQzV0xR04k/6p3ClNRirj1x4wRe6nIlNCbWV4P
         eWrRfI9TcM8sHd6WRL1CPUWeYcmxdECAYdhZRpp9sQDHsU7hqycvpMxzdAFmdAg7h53z
         dCD/VRxEBLWSQ8ecq+4dmDVENZe1rttV1r5JRy+1TOOdWU1A5y1e0hi3zd5sn6bMbQ4K
         eI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DnmoH9bekRYpYwPbGnzt8MqfxFmGQVDBVeFrYtSfJAg=;
        b=UFzApf3wXTkbs79uiWSKucbOpJBbQcWO8u1wUTjbM5ivQT0VDsOeoQM2ovNgEecncm
         TfmoenBayO/wKtKKWWFmAPWS9bcoRNOfjP3ajWpXT4e6LeTjAmBqw8G8uL4PGGfpHbMl
         ug+rbEaNMc8hv8Ltkn7GdvwRJUw4XueMVWHbQgnTBk2duuYIlhueA/kZIgm9hfKAqmi6
         azoeDzMN+TPPWjbf5dxjRPhHGXmILLTn/Ll/vMf4mcTpVkcdYG1rL2KvdGVGjr8fFu33
         lNX/TAWmYE6av+7jpNJ2Vz6GcQDs1dTUWqrlqU6v9HycGvoCbRo/gqth9K7FkH8Bgawa
         Ajyw==
X-Gm-Message-State: AOAM533K2o9STTeRPO/QGVyCyzGB6O2SG+uzTghvYlHT9Swk8TxgVH9q
        B52PDdWv9xBYp1VRP7+YlI0SCQ==
X-Google-Smtp-Source: ABdhPJxKXC66gotDOyho4nO17wIW1CBqdGqeINp4HW5tpxGXIBnz8OWQp2+0yigdIN5+oThSwjq6Qg==
X-Received: by 2002:a17:90b:17c9:: with SMTP id me9mr1124647pjb.13.1622570903889;
        Tue, 01 Jun 2021 11:08:23 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id mr23sm909701pjb.12.2021.06.01.11.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 11:08:23 -0700 (PDT)
Date:   Tue, 1 Jun 2021 18:08:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, Pu Wen <puwen@hygon.cn>,
        Joerg Roedel <jroedel@suse.de>, x86@kernel.org,
        joro@8bytes.org, dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Message-ID: <YLZ3k77CK+F9v8fF@google.com>
References: <YK6E5NnmRpYYDMTA@google.com>
 <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de>
 <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
 <YLZGuTYXDin2K9wx@zn.tnic>
 <YLZc3sFKSjpd2yPS@google.com>
 <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
 <YLZneRWzoujEe+6b@zn.tnic>
 <YLZrXEQ8w5ntu7ov@google.com>
 <YLZy+JR7TNEeNA6C@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLZy+JR7TNEeNA6C@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021, Borislav Petkov wrote:
> On Tue, Jun 01, 2021 at 05:16:12PM +0000, Sean Christopherson wrote:
> > The bug isn't limited to out-of-spec hardware.  At the point of #GP, sme_enable()
> > has only verified the max leaf is greater than 0x8000001f, it has not verified
> > that 0x8000001f is actually supported.  The APM itself declares several leafs
> > between 0x80000000 and 0x8000001f as reserved/unsupported, so we can't argue that
> > 0x8000001f must be supported if the max leaf is greater than 0x8000001f.
> 
> If a hypervisor says that 0x8000001f is supported but then we explode
> when reading MSR_AMD64_SEV, then hypervisor gets to keep both pieces.

But in my scenario, the hypervisor has not said that 0x8000001f is valid, it has
only said that at least one leaf > 0x8000001f is valid.

E.g. if a (virtual) CPU supports CPUID ranges:

  0x80000000 - 0x8000000A
  0x80000020 - 0x80000021

then the below check will pass as eax will be 0x80000021.

	/* Check for the SME/SEV support leaf */
	eax = 0x80000000;
	ecx = 0;
	native_cpuid(&eax, &ebx, &ecx, &edx);
	if (eax < 0x8000001f)
		return;

But we have not yet verified that 0x8000001f is supported, only that the result
of CPUID.0x8000001f can be trusted (to handle Intel CPUs which return data from
the highest supported leaf if the provided leaf function is greater than the max
supported leaf).  Verifying that 0x8000001f is supported doesn't happen until
0x8000001f is actually read, which is currently done after the RDMSR that #GPs
and explodes.

> We're not going to workaround all possible insane hardware/hypervisor
> configurations just because they dropped the ball.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
