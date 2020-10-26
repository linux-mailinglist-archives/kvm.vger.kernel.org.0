Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81AD298F90
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 15:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781710AbgJZOi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 10:38:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50509 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1780843AbgJZOg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 10:36:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id 13so11889422wmf.0
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 07:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MerDsv/XmBWBzmLIOlTgREdfdkOm0MotoeVYk/L2CXA=;
        b=Pqj0b7NAxAQeGChbWijWaY4tsNONaAR9oWWuCz66Rw4h3OvJOXQRMudZ+Rp+j3Bo3X
         JncmRLLVjT6tY5sgPuZ7iWz8Bj0uvPru028mnI+pJs8h+/FqmdDCNbgCRnrlFel++ifw
         iOwzQyimqGCGDTwM/i5wxNwoa8GS+9T2U4WXahJW4qImsDZuVCP+BI69yLwIZb0e5TP6
         DVbNdVRVVwWXmBfiPsfcNkKasuDoPIW1bsL3jUbGkGzijWc7CnBMfhG4C+FRJ4ukWyUK
         5hG0llpleWM1WFGvZNHkZWqZd/2e0t93rAFOREJp1pHqaLHvNnma1EKIcplUoPHwUX9S
         HdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MerDsv/XmBWBzmLIOlTgREdfdkOm0MotoeVYk/L2CXA=;
        b=YWUK1AemvBlySl3pfaYSc5M8LrrnMtZpqii+35cTzWD85MiNUDWTMa8w+R2ue4RP+X
         yvRXT2bO2FLoOrSUTYp7w8wkLsFhec+PENmtt6KtKKSvLbsQ5VASe0xw0bn5veyNpjFS
         ixDFN+ggdL5RiUMti+aJDSL2CT8PBRy1WCTh/A1hHV/AN2LLHgoWdl9+FZgpMvGXyslk
         Q61Srl7VMn8rBNepF/M8wnUQoBV2rNObsO2+BbHs0N0mHxJ4l2E/KQGYo63Bpz+epOKe
         IqavbAL8JJlb9r54VZ2BxZ1TEBxnEerKdEuNhGbZt0mqdbq4drFnMHR+PTqP8JaLeDZ7
         oLuA==
X-Gm-Message-State: AOAM5325lsRjIScCvrsuzB6pDgkYrbUNVuz6wfpKVG3XSpqxPJXhhvWu
        5M4IM9pIr8tx6oyAkTUjU6tZ4g==
X-Google-Smtp-Source: ABdhPJyeJBArajEh/qV0h65NryMws8JKnoPSvxRiqZYn8gQ8o5uMxcIaCVxiY2Ofp3J6w3GhdnhfXw==
X-Received: by 2002:a7b:c0d3:: with SMTP id s19mr6858264wmh.102.1603722987718;
        Mon, 26 Oct 2020 07:36:27 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
        by smtp.gmail.com with ESMTPSA id c18sm20080039wmk.36.2020.10.26.07.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 07:36:27 -0700 (PDT)
Date:   Mon, 26 Oct 2020 14:36:23 +0000
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH 1/8] KVM: arm64: Don't corrupt tpidr_el2 on failed HVC
 call
Message-ID: <20201026143623.GA2229434@google.com>
References: <20201026095116.72051-1-maz@kernel.org>
 <20201026095116.72051-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026095116.72051-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday 26 Oct 2020 at 09:51:09 (+0000), Marc Zyngier wrote:
> The hyp-init code starts by stashing a register in TPIDR_EL2
> in in order to free a register. This happens no matter if the
> HVC call is legal or not.
> 
> Although nothing wrong seems to come out of it, it feels odd
> to alter the EL2 state for something that eventually returns
> an error.
> 
> Instead, use the fact that we know exactly which bits of the
> __kvm_hyp_init call are non-zero to perform the check with
> a series of EOR/ROR instructions, combined with a build-time
> check that the value is the one we expect.

Alternatively, could we make __kvm_hyp_init non-SMCCC compliant? While I
understand how it makes sense to be compliant for 'proper' HVCs, this
one really is an odd one that only makes sense on a very transient state.
That would let us define our convention, and we can just say x0-x18 can
be clobbered like any function call, which eradicates the issue Andrew
tried to avoid with this tpidr_el2 trick.

Thoughts?

Thanks,
Quentin
