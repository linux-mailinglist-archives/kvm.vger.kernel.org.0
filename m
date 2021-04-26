Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E96436BA34
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 21:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241158AbhDZTpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 15:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241107AbhDZTpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 15:45:02 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056BAC061756
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 12:44:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id j7so31323949pgi.3
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 12:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q7xHJfw/FAhgI41nQLC+0GDChDTWCH6jbZ5uXcC3R7g=;
        b=uD57Nba9LUxaDOPNkbfoekPsVIVOiTlq7mL7WjBlh8kgRJ/axmZqfORTOxQoVro8lj
         1qWWRxjQoLn4LIabeWCqyATH1tGLzIkFP93h0/KCwe3+lf7J/bNO+gSRvVjc4KubiynV
         9whS8Wt1a5TRg4llRu/KD5emff1wMaXZvt0FC1e3xsEHqtU3FieP22PRvWUfvLtuCTCq
         yDZG2QlYpuT4i4SV17wJ6NjrRZ7nvQUlzLekhq9lZB8E7zspM54nwU5UkTlqyi0tajGW
         DjuC9MhNXNNuvuGK0kLXf1Jt0ktIb5rgGl7bAUa31PzLXXEfSPV0zy6ja4Xp+tCvcLBb
         04cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q7xHJfw/FAhgI41nQLC+0GDChDTWCH6jbZ5uXcC3R7g=;
        b=jYF7Moy9UwldHZ3U5aHyoA/0BGerAiy9nUciSjqxxfgKcSrHP64H0rb4xGg5g7JGl0
         8fO2ryKBjb1YZqA1dGx73qKn2aCEzE9ut144Fp50Az64HUEGFc9oipLiPSNb/LySjsKP
         BNzSMB3YWoU3MzUSyyVFwiZsxD8GM6vwXB0aCs8vzzI35Ch5T3VidGzxSiRcOw2rh+T/
         JOg6L5L4lgmgG9c6nM4dJg8lr1PvsnYM5RkBRddCc6ce/w7UWnqTb1afz0QSCS+5Qokf
         vqOJ9EGDzimSNQdbF6FDpGehu8/xwyiCPTDEzSNHGwgQEI3xYp/txtAxV2eYMqErfFCF
         29Jw==
X-Gm-Message-State: AOAM530oEh/wms2xi7ykMHJ0GKj/FCiS5G6bMo5h379MG6pVN7nCZQkf
        AUWY2ZKku/Yrtc4lNwrO3w6CJA==
X-Google-Smtp-Source: ABdhPJxY6NwR+9EgPKHRao08vemcJNCILzzyv2nNnxcZUp9VbbYuAUuxe6Go3zdHBHkkWjE81VzIQw==
X-Received: by 2002:a63:ce03:: with SMTP id y3mr18095661pgf.414.1619466252386;
        Mon, 26 Apr 2021 12:44:12 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x22sm12322889pgx.19.2021.04.26.12.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 12:44:11 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:44:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v3 2/4] KVM: SVM: Clear MSR_TSC_AUX[63:32] on write
Message-ID: <YIcYCAANV6o3EI1n@google.com>
References: <20210423223404.3860547-1-seanjc@google.com>
 <20210423223404.3860547-3-seanjc@google.com>
 <87k0opfmo9.fsf@vitty.brq.redhat.com>
 <YIcSBIeLpqQ0sDF7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIcSBIeLpqQ0sDF7@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021, Sean Christopherson wrote:
> On Mon, Apr 26, 2021, Vitaly Kuznetsov wrote:
> > Actually, shouldn't we just move wrmsrl() here? Assuming we're not sure
> > how (and if) upper 32 bits are going to be used, it would probably make
> > sense to not write them to the actual MSR...
> 
> Argh.  I got too clever in trying to minimize the patch deltas and "broke" this
> intermediate patch.  Once the user return framework is used, the result of
> setting the MSR is checked before setting svm->tsc_aux, i.e. don't set the
> virtual state if the real state could not be set.
> 
> I'm very tempted to add yet another patch to this mess to do:
> 
> 		if (wrmsrl_safe(MSR_TSC_AUX, data))
> 			return 1;
> 
> 		svm->tsc_aux = data;
> 
> And then this patch becomes:
> 
> 		data = (u32)data;
> 
> 		if (wrmsrl_safe(MSR_TSC_AUX, data))
> 			return 1;
> 
> 		svm->tsc_aux = data;
> 
> The above will also make patch 3 cleaner as it will preserve the ordering of
> truncating data and the wrmsr.

Ah, never mind, Paolo already pushed this to kvm/next with your above fix.
