Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B512F374F
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389638AbhALRgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733158AbhALRgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 12:36:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F587C061786
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:36:09 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id y12so2043311pji.1
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kBoeCrqN2k6hVDBNDBFoP9slGG3T38BN8I1wekGgzs8=;
        b=IJk767It+WkeZlRni4t1QJT6YRO2W0GVVlNuXV5L3VtoFJdJ1V7YbFOINLcHmAX1/5
         qW/ibvQZpy1IyiOqbK89qYW2OT1KM8G7IRF5XTzyfjEKQhlfYOq9yRSpN/iD4M7hBpNS
         LesTKJ0bftCKfPOKD6lojIyze730MgROX19414sH9yuOIPOK3dVuzX2SMc3eVDa+7Eff
         7XYJ35X0Ggqxqp44fWXM9hp60v/rhvLMPkBpJ65qAEZLU/TBR9SGV///ysv0W9sSWDgs
         e57Cu84YuOOI5mC0V5cJXdvCNIFVT0kZHOqpQnFahYAzULSSWKoZR8V2YdUEFRwYHIcV
         VPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kBoeCrqN2k6hVDBNDBFoP9slGG3T38BN8I1wekGgzs8=;
        b=TjX8E1mJah2ASyZw/0f9ePgqhNoaNT34e2Z6OHLxIOdeaPnH4dbC9JH5TDtJ+NGJV0
         ujzQz8LcUdz+Yw17QEz3AdFgSlOp4xwzr9d5mUIS3QhM3kMHIk6wznhYU6SVr48KCw91
         /SUG81hMZvYsNxJGejd1VLJvoNilNEnpEqT2/JJp9Q7O6ez7g1SiQ4168lUNM8icC0UC
         vIQpfYifGYf1CAHNe2H1MCM34kXX2yz7sE2wkRQ+S1Mvf0l68+Nri2cATi4tyIzlxZ4S
         Mv+y4U4S4mxzOeErHsVt/JqVTjJAM0XPkuI5Jzm6/tyGaFAA1BUIl7uz37ofbXuQrpma
         YTbg==
X-Gm-Message-State: AOAM530EMG9+v/OIH9WPMoT6IbwycOyspGOslmTbw6fmxy9NyIf5+NXk
        vwqeVPh9tG3pEmrq0pwDgR1xng==
X-Google-Smtp-Source: ABdhPJycyDGJ7mjxh6atJ3kxaqss3ug8XgjvQHIftL9wwPSdeemCp+9hFzYCBh03Etv8hBGv+BDTqA==
X-Received: by 2002:a17:90a:5298:: with SMTP id w24mr199739pjh.182.1610472968667;
        Tue, 12 Jan 2021 09:36:08 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id p9sm4032823pjb.3.2021.01.12.09.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 09:36:07 -0800 (PST)
Date:   Tue, 12 Jan 2021 09:36:01 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <X/3eAX4ZyqwCmyFi@google.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112063703.539893-1-wei.huang2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Wei Huang wrote:
> From: Bandan Das <bsd@redhat.com>
> 
> While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
> before checking VMCB's instruction intercept.

It would be very helpful to list exactly which CPUs are/aren't affected, even if
that just means stating something like "all CPUs before XYZ".  Given patch 2/2,
I assume it's all CPUs without the new CPUID flag?
