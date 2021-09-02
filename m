Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE7C3FF416
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 21:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347370AbhIBTYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 15:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347245AbhIBTYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 15:24:41 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC543C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 12:23:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 18so2436289pfh.9
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 12:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bdRaYL9hM7jiSCUixVQ5zx2AOjhox/HWm2JZjrik6sU=;
        b=P6U3y4+NDgkwLnM7k8tfRmmQNz3FbNimiCjNiDzg2c4/b7cnIMnSgSLYgren5AfpBQ
         FZjBRxEBn/G+JsgTKmLNhBdQ3PtvRchAl+Cd29xQTm+I7A1i4NZ7Izvqp8JwhPR2pQRZ
         Pe8En2Gn2SzcvcfwBCnUDGnLJRsYhSfO3EESmVQl+nTrENWKUYTOG/2PuU/7vl0YaJ09
         V4pmW7LbA0lUJAXT8HrSCOSTkZfuLfCqwmGZE4pVqzcVE1cI6tu3Njp2a0dTpa1LrXfm
         G2uSzRx/JfYiBUtlBJISj6kjnMu9P3OqSnzIN8uEKwvwm9ZnWSwh+yto/yk3zDWuYh+j
         SxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bdRaYL9hM7jiSCUixVQ5zx2AOjhox/HWm2JZjrik6sU=;
        b=rPAio4OMc5LxrKd1kcdZk/VAOOvmCoofM3owHcJsUHv2H4R1HF+SXdDJwoZx0tvFNV
         2N5MCav7WySNINWe043N6sMGt+0WouhZUNob+LJkEPyldEH25pmEuuBcG2euLCwFO0GE
         DcNtfzWyRFdNLpO9di0ANtpjVmKqHr9mWS/bJI1dI4K4VBO0IMpcBv2ROZVoXmaTZd+f
         zk8Yu30Hmtrt+QZstRz3xHSoJOG+zXcP2zNq0FeDoPGMcv9/gVW2Qfb1fCuFrTBHb/e0
         20uzsT9gb3RGBPQxeufMRHMLd0ysnkhC6DsTTBcxWxjUE+WSSSnAB1bjm/BPV4d3ABB+
         qFtA==
X-Gm-Message-State: AOAM531NQCkDLqSyNw/V/VoXplbweVneLWhVmniYLtBNuJ74vhk7fLS7
        SnfGRpvZjHN1P9jTZxncsBuwpg==
X-Google-Smtp-Source: ABdhPJzBzFjoSYZppoJqGPeszZnPa1tw+Regznd0m+yvwVLEvAxR/W5mnHB1AAD6LnodpA7epZnM1g==
X-Received: by 2002:a63:1a64:: with SMTP id a36mr4666097pgm.225.1630610622242;
        Thu, 02 Sep 2021 12:23:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s83sm3183628pfc.204.2021.09.02.12.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:23:41 -0700 (PDT)
Date:   Thu, 2 Sep 2021 19:23:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 0/6] KVM: x86: Add idempotent controls for migrating
 system counter state
Message-ID: <YTEkuXQ1cNhPoqP1@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021, Oliver Upton wrote:
> Applies cleanly to kvm/queue.
> 
> Parent commit: a3e0b8bd99ab ("KVM: MMU: change tracepoints arguments to kvm_page_fault")

This needs a rebase, patch 2 and presumably patch 3 conflict with commit
77fcbe823f00 ("KVM: x86: Prevent 'hv_clock->system_time' from going negative in
kvm_guest_time_update()").

> v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com
> 
> v6 -> v7:
>  - Separated x86, arm64, and selftests into different series
>  - Rebased on top of kvm/queue
> 
> Oliver Upton (6):
>   KVM: x86: Fix potential race in KVM_GET_CLOCK
>   KVM: x86: Create helper methods for KVM_{GET,SET}_CLOCK ioctls
>   KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
>   KVM: x86: Take the pvclock sync lock behind the tsc_write_lock
>   KVM: x86: Refactor tsc synchronization code
>   KVM: x86: Expose TSC offset controls to userspace
> 
>  Documentation/virt/kvm/api.rst          |  42 ++-
>  Documentation/virt/kvm/devices/vcpu.rst |  57 ++++
>  Documentation/virt/kvm/locking.rst      |  11 +
>  arch/x86/include/asm/kvm_host.h         |   4 +
>  arch/x86/include/uapi/asm/kvm.h         |   4 +
>  arch/x86/kvm/x86.c                      | 362 +++++++++++++++++-------
>  include/uapi/linux/kvm.h                |   7 +-
>  7 files changed, 378 insertions(+), 109 deletions(-)
> 
> -- 
> 2.33.0.rc1.237.g0d66db33f3-goog
> 
