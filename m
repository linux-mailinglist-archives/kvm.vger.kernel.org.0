Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B588C38F1EF
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhEXRFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbhEXRFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 13:05:02 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B120C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 10:03:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k5so15196364pjj.1
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 10:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c6Iy6FMGjuqTNcke/wtyVN9yLyUyNWeFx4AIjoXtdGM=;
        b=mlaxQ74HN0sNwu+oG2Ld4AqVBNmKroxXRBMuvQZnV4xskZzsABo1JEEDORZVOGfckh
         M7Zev5Rjx8fkNu6umrXA2eEOY5yHYlGp010dYWIFtFiB1KoHYM8TdzdOIGw8K908g49L
         MjpVY5yGCw278Opbod19Aqytfdl+XarmBvTC5KSU2uLvg3N9HNkg4ZnnqfpAIMS5y3TW
         fL76zBcEhZQi5P1xu7CrkGAVbbNvDc3gz4b2ea2DDuHx4KdCjCPo1zOOEfkRJgJ7lKyV
         BjODbkFhTvb8m9Ou6hskxROp+i61flyfMaK3ROKa+XfShw6UK4C3cWk/8A/sJIp6elyE
         JAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c6Iy6FMGjuqTNcke/wtyVN9yLyUyNWeFx4AIjoXtdGM=;
        b=gXIE9zKByoKuzOT1X3tPlYSH56yY+vV5IL5MGEamBHTqYXb6NxbKMHRb8QiscDhumF
         EWMTC1r/i6dmFkMULX1/MHxflqZt1lrlZ84bB1N3jwUcZZv6QlSRSjiscqTCJ5ePz5Pt
         PBN1TFEjJYZFmUaHTFJ6zJMjciz9mUkHa28chixosMFPlGMujDRbt9dJIuNgRNAujhF7
         u4i9mpWJbwma6UKMlv4pKL4Te5FGLJ4fzKvoWGSmSM4RO3vCU5W/PzCdUM/KWAmSpcZL
         JeDloDU+3+ygnOAH0ykzitgZbgrm4WirxQA4ULj6wKjSf9iJUFgb+beQdjGnZtszDIQU
         3B0Q==
X-Gm-Message-State: AOAM531s/tTltqCqWxGSxRYK1frBJ/7d1YBvsLt+V8jH75uXvp5EzMiL
        96C8Pnyhz2JcE+o0QkYjUuoB3g==
X-Google-Smtp-Source: ABdhPJyU6NnplYdMxlnsV2vJ0azspjxXb/mL29igsx7D8M4cqgMnVkqLn2NBHPnUKtkbOhSbiOjOtw==
X-Received: by 2002:a17:90a:29c4:: with SMTP id h62mr27052028pjd.177.1621875813567;
        Mon, 24 May 2021 10:03:33 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s65sm10654632pjd.15.2021.05.24.10.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 10:03:32 -0700 (PDT)
Date:   Mon, 24 May 2021 17:03:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
Message-ID: <YKvcYeXaxTQ//87M@google.com>
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
 <87pmxg73h7.fsf@vitty.brq.redhat.com>
 <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
 <87tums8cn0.fsf@vitty.brq.redhat.com>
 <211d5285-e209-b9ef-3099-8da646051661@amd.com>
 <c6864982-b30a-29b5-9a10-3cfdd331057e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6864982-b30a-29b5-9a10-3cfdd331057e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Paolo Bonzini wrote:
> On 24/05/21 15:58, Tom Lendacky wrote:
> > > Would it hurt if we just move 'vcpu->arch.guest_state_protected' check
> > > to is_64_bit_mode() itself? It seems to be too easy to miss this
> > > peculiar detail about SEV in review if new is_64_bit_mode() users are to
> > > be added.
> > I thought about that, but wondered if is_64_bit_mode() was to be used in
> > other places in the future, if it would be a concern. I think it would be
> > safe since anyone adding it to a new section of code is likely to look at
> > what that function is doing first.
> > 
> > I'm ok with this. Paolo, I know you already queued this, but would you
> > prefer moving the check into is_64_bit_mode()?
> 
> Let's introduce a new wrapper is_64_bit_hypercall, and add a
> WARN_ON_ONCE(vcpu->arch.guest_state_protected) to is_64_bit_mode.

Can we introduce the WARN(s) in a separate patch, and deploy them much more
widely than just is_64_bit_mode()?  I would like to have them lying in wait at
every path that should be unreachable, e.g. get/set segments, get_cpl(), etc...

Side topic, kvm_get_cs_db_l_bits() should be moved to svm.c.  Functionally, it's
fine to have it as a vendor-agnostic helper, but practically speaking it should
never be called directly.
