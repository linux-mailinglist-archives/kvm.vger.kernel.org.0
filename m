Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137E43398E0
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 22:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhCLVKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 16:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbhCLVKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 16:10:19 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DB7C061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 13:10:19 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y67so2719834pfb.2
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 13:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pAFjvyG2BbuTR3wtn+p9SqjjHJsHfZYBaKEIukNmkVY=;
        b=vc6FxzbYVVZjdJEOtsXsduPQatLfiaVPUx7lsOMuWZRohiMgayTvLyeV0MwzdexptK
         Bm7Vc9Au744meaK5aoM+NFWSf8U+JGpmsaD445FNT5K1mQiBDhIeJgdCw5AL+rShRVPy
         752uzcppiFQZa6/ExdAzCZp8TnMbPQAH6uXQyeZlZKEVfzTp7Lg0iqLaqSzDJy0v5KzE
         OkPackqgyz9EWoFSsQFavX3gYpLEv4l/p0vqPrC4Si/JVzFXxtE3HBhtHu8wUUxlKVlU
         PZX92mQZuR9qYIdAFlwntQDcqmYC4GAiPD+zK/xpmWPeCm62eZg2gx0iZ2pFPtOeqP7Q
         rgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pAFjvyG2BbuTR3wtn+p9SqjjHJsHfZYBaKEIukNmkVY=;
        b=XEMPsiDfsU6skD6Cp/Kwybd8dAbVx3lWkRH8FgabsOybevH/z4pufn6ZvnovncLTXJ
         RJMUYGdLxKJCWZq8LQbpoJdNmFrWKSPhvFdnt0ZVhC79nV4BHRAw8gz/ScoKZ8m77P4O
         iAl8kuiyU7DPp69VJ83A2tWzlJ6tqCek855KEbmjIxO/QWY/899kCKD31L8QkpvzJQWt
         ear9CkFdPgA0gGHMANO4QOg/lmcQ1Iev50XFI7zJbVtEdZkpykCyjXDrCUKu+KfJj8Je
         KFnLvyzWP7FuQYmEMCmrNZr61browl9rJDzSGiLsI6GyiM4/dtS7BYg/ACb9g9HU692F
         wL5A==
X-Gm-Message-State: AOAM531OUF19/fb3qgF+5TNCI0+eukBO2ui/EBtyk9S0fR2Hmx6wv/8+
        He5nOeKSMujI/LlVL6/lgoluNgSnC2gHdA==
X-Google-Smtp-Source: ABdhPJzZqo8fypR7EoA+WAQj0FiBpOz4ZTPpaT51JQKOswutZAbZB0I1mU0vdImvhQDzgMdCafHRuA==
X-Received: by 2002:a63:cd08:: with SMTP id i8mr13355788pgg.49.1615583418687;
        Fri, 12 Mar 2021 13:10:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id q95sm2911339pjq.20.2021.03.12.13.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:10:18 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:10:11 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <YEvYsx+jUfALD8Py@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <164745a2de1b9c5bede8c08a3a57566b75a61ae1.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164745a2de1b9c5bede8c08a3a57566b75a61ae1.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021, Kai Huang wrote:
> @@ -290,6 +290,8 @@
>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
>  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> +#define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
> +#define X86_FEATURE_SGX2        	(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */

There are spaces immediately after _SGX2 that can be replace by a tab.
