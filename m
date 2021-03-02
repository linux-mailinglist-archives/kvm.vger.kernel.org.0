Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A515C32B59C
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381580AbhCCHSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239530AbhCBTVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 14:21:09 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BFFC061788
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 11:20:24 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d11so12591794plo.8
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 11:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nTR1gSY8AyYBmlkN5NsyaE59tkLRlPt3XQnuP/gtEls=;
        b=FYAaFJLMeUfXUwWCbf1ENPmBFy0H5/UzPli0k0XMaUSiA/XyNFmOM6M8gz9PTSZzPd
         4oy+ZkmwVTFba1Hy/LJ45HqVSbLbMMmYiBYbqM9DkazTMipXqfsdXX/HFVdG0Kg+PG4/
         Jw9G6Lrh5c/pwwUjafGnSmAVGjiSknjwRA3/XmN/SL9Y3xwir4FQ4qjnWGMRZ1K7Gs06
         +l2/f67IZKCQ1cXg6+U/bxe8sekLMG7htcF5LHJXbyQ9/Fk8nAF5RRUbUb8MGQ07p/4x
         ctydUAtxPAvChUQdFQa7d+JC1eps48K7ZiNO+/glmI+fX+SSaJBnbXdOcOEAzQZgvyXn
         XAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nTR1gSY8AyYBmlkN5NsyaE59tkLRlPt3XQnuP/gtEls=;
        b=bAFGj7b3i0h9pbrSnFomf6PnnzsycZAUaVZuex+XnHCdo++EmobD5CM31g2qI5ApoX
         A+hfiNXXXIQxi0+cXhSCqpDU0VeV23gvWK7AevxtWsrjn8ps7vxmclRWAB6ze/V5sIOx
         AZ4WlrfIf2UhplG179jk/3gJuRQA7QWTeSWXfXqV44va/eN2VAIUdgL50w5MyFJh2Eby
         91QA7ycjoHR1JzbUIxxk68WnGQnF1kSsy1sctmqotU3PPtdEbAlwUSCuEwl1e9hRSW28
         iT19PUdpLvQeXC2qE0Q8APjJMpa0HPDksSYxfxYKz5jsgPp2+fJpcW9mXoqnxS5ArGpV
         tLZw==
X-Gm-Message-State: AOAM532thG1u6T2Ri7hlHa3iL/nY5EsqnTPE2mEcOCoV2uCKj5Hf0w3u
        cTJiCAGH25VQkjkRL1SrJf05ug==
X-Google-Smtp-Source: ABdhPJzCY3Cp3rFD0UgLcAl5GfX9tJC8u7gu1D91cETA8vt2rNf28lrXCjk6d40ldU7B1AsGIPtJew==
X-Received: by 2002:a17:902:9d82:b029:e4:b5a9:ff9f with SMTP id c2-20020a1709029d82b02900e4b5a9ff9fmr4944015plq.75.1614712824062;
        Tue, 02 Mar 2021 11:20:24 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id w128sm22095590pfw.86.2021.03.02.11.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 11:20:23 -0800 (PST)
Date:   Tue, 2 Mar 2021 11:20:17 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Subject: Re: [PATCH] KVM: SVM: Clear the CR4 register on reset
Message-ID: <YD6P8TbrZKD4zbxV@google.com>
References: <161471109108.30811.6392805173629704166.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161471109108.30811.6392805173629704166.stgit@bmoger-ubuntu>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021, Babu Moger wrote:
> This problem was reported on a SVM guest while executing kexec.
> Kexec fails to load the new kernel when the PCID feature is enabled.
> 
> When kexec starts loading the new kernel, it starts the process by
> resetting the vCPU's and then bringing each vCPU online one by one.
> The vCPU reset is supposed to reset all the register states before the
> vCPUs are brought online. However, the CR4 register is not reset during
> this process. If this register is already setup during the last boot,
> all the flags can remain intact. The X86_CR4_PCIDE bit can only be
> enabled in long mode. So, it must be enabled much later in SMP
> initialization.  Having the X86_CR4_PCIDE bit set during SMP boot can
> cause a boot failures.
> 
> Fix the issue by resetting the CR4 register in init_vmcb().
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>

Cc: stable@vger.kernel.org

The bug goes back too far to have a meaningful Fixes.

Reviewed-by: Sean Christopherson <seanjc@google.com>


On a related topic, I think we can clean up the RESET/INIT flows by hoisting the
common code into kvm_vcpu_reset().  That would also provide good motivation for
removing the init_vmcb() call in svm_create_vcpu(), which is fully redundant
with the call in svm_vcpu_reset().  I'll put that on the todo list.
