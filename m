Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B682C3038
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 19:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404361AbgKXSwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 13:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404170AbgKXSwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 13:52:21 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF76C0613D6
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 10:52:21 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t21so18292353pgl.3
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 10:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sFK91XydZyXQWY1gobkRf01DMmXQEgpxPXEOFflyrhY=;
        b=wGHb/mKJwXBv7u/QmzjzG/MALQoIbanNCslwdtiAftMUjmxQA/tSmpHkH1LfnlM5WQ
         Bgb4vK7OZ01J6Psj4OwntFDMq8R9j8Ns0ZwSrLkO7xjNNGdQDW04KlAgdiCiyD8LNNWQ
         5aiaY+8GManhjhn+E5aO/tBswdaEw+HM2xRXaLymjZr5oIMM6uH5VL9sNAhxRPFgVgpr
         4vzldQvxySfqaCH6UzhkfvBpVaAyJRFj3N51hqssxV5l43RuEcShm6lTXyQ4Zi54d7Qf
         r70QPVWMNYXF7S9rbkgTKIWF47ApUWOgxguUVoBBVU4MHU1pr4TEd5zPuooD6N5PNjIN
         Or4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sFK91XydZyXQWY1gobkRf01DMmXQEgpxPXEOFflyrhY=;
        b=GXm8At842DNyhr/TaxtcmniD8a3qMJmWgvnXvCUHNDF/K9Y9hHwDgYDCEFKNqlGjhh
         jlHqw6ChlKkFjNSQfOAl88DEqN36vWqIru3HbaBCphbprcGMkcjTrlYo4+P2T80Scwef
         +jYeyqIjX7y4anPBGGPLBlNAF3vw1fyWbecCx6v70HEuzvGduz7NMHPL8MDtF4vYCAPB
         6yTOHKsf7YpsV2WhnBUu58/MtCj6d3UT6mAKLH5LmCU1DySJ7fJgT7k//zj41wm+nFjZ
         w9CzAnSqRsf1m7SQ/juG+isxb0R6m4QjkVgzqb/vy+6eu9CLWsCka5Pzz5Smd7cMaAFr
         WxAg==
X-Gm-Message-State: AOAM531yk+CISvL9dLn7ZjYgEXXUsuzWtrcZegd+MZP2TrmicxVMrJYe
        r2y2zJfuGez0Jey5Liu+EkL1NQ==
X-Google-Smtp-Source: ABdhPJybo0H5UE8SaKWsWUCBD/xp4c5gfAW+uTMZ/XhWwYLinb9fg4R73/Z9DQdE8oxNEfZbE+mB/Q==
X-Received: by 2002:a17:90b:3781:: with SMTP id mz1mr6463471pjb.229.1606243941279;
        Tue, 24 Nov 2020 10:52:21 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id m13sm5454151pfa.115.2020.11.24.10.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 10:52:20 -0800 (PST)
Date:   Tue, 24 Nov 2020 18:52:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v4 00/34] SEV-ES hypervisor support
Message-ID: <20201124185216.GA235281@google.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
 <347c5571-2141-44e5-4650-f63d93fd394f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <347c5571-2141-44e5-4650-f63d93fd394f@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 23, 2020, Tom Lendacky wrote:
> On 11/17/20 11:07 AM, Tom Lendacky wrote:
> > From: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > This patch series provides support for running SEV-ES guests under KVM.
> 
> Any comments on this series?

I'm planning on doing a thorough review, but it'll probably take me a few more
weeks to get to it.
