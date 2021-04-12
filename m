Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D922135CAB1
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243042AbhDLQE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbhDLQEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 12:04:25 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AECFC061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 09:04:07 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id z16so9751509pga.1
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 09:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JBvLAe+XdwyC1TahhE2etbWctmaxYBIUWvV5rmz141I=;
        b=iP2BummN96o3Ez8aj7V9/rOfsPo8UnTnLCwQVbYCglNGVspy6LsiU1mUu4Y41zmXKu
         taawvpF5xCOgJFc5Qmz1GCLztVn8ao0dJMHcYBmTf3JzFmQg6DoyPQr3BU1mv9GLAKkr
         VcMBBq2+t4OjMccea/TY0zBqiIfOzdUcrxVVyTnlGcIpy7Q+HBHbw5oBvvmO6gwcm9Uu
         jwJKM1dM8a88MjHK4t2lik4OT7cq83tXjotwfEfB0ThjwoPLZo5+VuKx0lH5O5rtDSEU
         RU1GIMh+SOVczf5cJU/YGCl4nqVGlOYXHOG6JJB+4nZzrSDoCeNA6tOfOLsDKHObcggc
         DmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JBvLAe+XdwyC1TahhE2etbWctmaxYBIUWvV5rmz141I=;
        b=eivTSvvQHGgxbLcPWaAWFyJwnzNNdP+g/YJhARBFI3D3bzYa5q3MEIeb2ufkA317tE
         8a4bsxtDFTxtg3/dwvmD43wLAWDJ1rzS16slPvxfEMyi3QWiCiDuUrv8EENbfsxT8Zhd
         e6kPf34A0lmUreDhXdpBnbdm8qoFtKKT9qcK03QGwXoQy7Mlg2zVPs3pOvXkL895kLVk
         2WCvuR0yRWw9xxLoT3WiRzWmJevW+lZtWl3u4aKkA+b73fGsusuwKGMp9PIoWdO7fc8M
         6lNdKIHL82JUkmuRQPNj+sWOK4fDAC2CwGhQNSKFoEtxP0lcdFVy5vyoqPmxTJQk10iC
         /9OA==
X-Gm-Message-State: AOAM531YakVHlN3FPJ2EU1tQbCWMTUYBzH4YBLZQ150UOQ2AiFKDXalE
        8mE0yhdwAcxmEdgRC2DSuUfnqg==
X-Google-Smtp-Source: ABdhPJxhOXb9IE7zbrpJuSGroimic3OsWCTWvzSPzW/IeB9YaZiZiXzrb8oqA2lnlZXfDq9mXWEk7A==
X-Received: by 2002:a63:6cc:: with SMTP id 195mr28628134pgg.153.1618243446756;
        Mon, 12 Apr 2021 09:04:06 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id ev24sm8085263pjb.9.2021.04.12.09.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 09:04:05 -0700 (PDT)
Date:   Mon, 12 Apr 2021 16:04:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 5/6] KVM: SVM: pass a proper reason in
 kvm_emulate_instruction()
Message-ID: <YHRvchkUSIeU8tRR@google.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
 <20210412130938.68178-6-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412130938.68178-6-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Aaron

On Mon, Apr 12, 2021, David Edmondson wrote:
> From: Joao Martins <joao.m.martins@oracle.com>
> 
> Declare various causes of emulation and use them as appropriate.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/svm/avic.c         |  3 ++-
>  arch/x86/kvm/svm/svm.c          | 26 +++++++++++++++-----------
>  3 files changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 79e9ca756742..e1284680cbdc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1535,6 +1535,12 @@ enum {
>  	EMULREASON_IO_COMPLETE,
>  	EMULREASON_UD,
>  	EMULREASON_PF,
> +	EMULREASON_SVM_NOASSIST,
> +	EMULREASON_SVM_RSM,
> +	EMULREASON_SVM_RDPMC,
> +	EMULREASON_SVM_CR,
> +	EMULREASON_SVM_DR,
> +	EMULREASON_SVM_AVIC_UNACCEL,

Passing these to userspace arguably makes them ABI, i.e. they need to go into
uapi/kvm.h somewhere.  That said, I don't like passing arbitrary values for what
is effectively the VM-Exit reason.  Why not simply pass the exit reason, assuming
we do indeed want to dump this info to userspace?

What is the intended end usage of this information?  Actual emulation?  Debug?
Logging?

Depending on what you're trying to do with the info, maybe there's a better
option.  E.g. Aaron is working on a series that includes passing pass the code
stream (instruction bytes) to userspace on emulation failure, though I'm not
sure if he's planning on providing the VM-Exit reason.
