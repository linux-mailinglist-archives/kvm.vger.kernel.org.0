Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2412D82F9
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 00:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407219AbgLKXzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 18:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407130AbgLKXzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 18:55:31 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B7CC0613D3
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 15:54:51 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w5so7470014pgj.3
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 15:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dgacDrS0riydujVAJCVqJGSgZiFbA+7xuih1JNG67KA=;
        b=ogJjeDtFdyKbay4CVyxPAK1DClalm9TQ3pZvATeoyQBL4yVCa/NtNJVKV3LOrREjDm
         eaCteR0knx/MB1jbJ1YVOFj4HPuoCzJzTIgHsd4IEljnXekDVnM/7HODNplhiaDX0Wd0
         V/rDpKmHP9E0VFrhIHigP81ITLtUzn1Vf15m+WENzyhyQsgx3011qDNSzZnr4gekRkkn
         C0gVWBDKJSc8tFtUtrRyIjRzVeOV6VeyGxRTaJ2nmliqLvnI5W1knpMlbNNw3pdTFOhV
         jLLNdRM4wrixerfhFzwxXyxUVTUJuEQTbu3w6s3gNnM+QATkCe9xpRHsTdCT1RGjjdBg
         Z/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dgacDrS0riydujVAJCVqJGSgZiFbA+7xuih1JNG67KA=;
        b=MjMwLGHeJjUAGlF7eHhO8AbT8Hj7OHNeFdJ9joTS2yvnmQvn6ZL3eeopLtuZ5YeujM
         mJlWtTGvxVvad5FVRJkeM8/QdGrBr+2vWgpeAI9gDyYTAn73KT4yb+uzmokYcm01EtrX
         HCm6KQrAmO6KjnmJomrm7JBof7/Cc74z/X7Gwx7ABP2nIn2TK8c+COH3h9ztgFFed+6p
         +kW0gNTCqziqlIKjABO5HmMmQhuz/RcvflmNk4OjqDBU4QvQgfs+zenxhFSs/KMfh6hO
         LaE51iG19vP4iAVIgDGtrNDrXnOE1t+NdqdI7BuMtWUrrVkCvVqen+MdJrPkXflBct+D
         ZV4Q==
X-Gm-Message-State: AOAM530zZP0Zfjh2t537ndNHEPCGepdWLRanFfE9C7tShkycP1uOW7UJ
        wIRCl6V0L/AbFaZSZPPVsOeacw==
X-Google-Smtp-Source: ABdhPJy/fiexxBBx/YBRcBfudE/6zZgOs9/EoqjkH/B6NjG9OXsA47gcwRhp6LNiYZonAaxHPGvSLQ==
X-Received: by 2002:a65:468d:: with SMTP id h13mr13277740pgr.55.1607730890470;
        Fri, 11 Dec 2020 15:54:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id z9sm11393330pji.48.2020.12.11.15.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 15:54:49 -0800 (PST)
Date:   Fri, 11 Dec 2020 15:54:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        stable@nongnu.org
Subject: Re: [PATCH v3] KVM: mmu: Fix SPTE encoding of MMIO generation upper
 half
Message-ID: <X9QGw9vJfzCrFNzd@google.com>
References: <20201211234532.686593-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211234532.686593-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 11, 2020, Paolo Bonzini wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
> cleaned up the computation of MMIO generation SPTE masks, however it
> introduced a bug how the upper part was encoded:
> SPTE bits 52-61 were supposed to contain bits 10-19 of the current
> generation number, however a missing shift encoded bits 1-10 there instead
> (mostly duplicating the lower part of the encoded generation number that
> then consisted of bits 1-9).
> 
> In the meantime, the upper part was shrunk by one bit and moved by
> subsequent commits to become an upper half of the encoded generation number
> (bits 9-17 of bits 0-17 encoded in a SPTE).
> 
> In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
> has changed the SPTE bit range assigned to encode the generation number and
> the total number of bits encoded but did not update them in the comment
> attached to their defines, nor in the KVM MMU doc.
> Let's do it here, too, since it is too trivial thing to warrant a separate
> commit.
> 
> Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Message-Id: <156700708db2a5296c5ed7a8b9ac71f1e9765c85.1607129096.git.maciej.szmigiero@oracle.com>
> Cc: stable@nongnu.org

I assume you want stable@vger.kernel.org?

> [Reorganize macros so that everything is computed from the bit ranges. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Compared to v2 by Maciej, I chose to keep GEN_MASK's argument calculated,

Booooo.  :-D

Reviewed-by: Sean Christopherson <seanjc@google.com>


> 	but assert on the number of bits in the low and high parts.  This is
> 	because any change on those numbers will have to be reflected in the
> 	comment, and essentially we're asserting that the comment is up-to-date.
