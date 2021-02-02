Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7CA30CA4A
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhBBSn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238873AbhBBSmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:42:53 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2999C061573
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:42:12 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id j12so14933071pfj.12
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YTgp3gQH+UBjxDnuoHSJe2E7rMRGSXfHDHxNctlP+No=;
        b=ONuysSWxPvPEF1csQbpuXTENOsPRO1RZpI/JgJrvWqnAUZ5mSJVlP7PKIsZT8LJCS7
         9nXfG65FT8ciJOv8Yoo3NHYrjrV02DmCZT3wu1IPfkIUnDQFE9Tyhy1442fO8Rh8BC18
         MsgU3qYQIiaTMjbgLbjkXr4EAw0l+bw2fCLcxAb08njGC6JnMm9bBVE9uAW1j2Db/zOg
         b/ijc+WpRMMc27QLLWt6tsv3Nx3RHOeJQ5sa1vUbuHAx4YQ6WntFtRrX4k1zQjsyKRgo
         pa6QX7qvCHqcgnmnqI+PqLwbzLGVVgUXfZz3l7cNkxjwRKiMbCsxjsDb97jJ/69ntFoa
         4Yxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YTgp3gQH+UBjxDnuoHSJe2E7rMRGSXfHDHxNctlP+No=;
        b=BrOSDkNI+oCWd2N8R0+IjMz2Pa1+TrZ7fgsK4LLzxylJey3uoxUP13AAxfDvl5iAux
         nKt9WdBXe74yowa+oawllKpUiGa0jiAcxJkNTWlFk1Ffj4Pvk9U+8Ns6J6BIu9rRkXyP
         PLzNYyRWfpnyHBrKq2vHZgBMZ0wYzlJWuVV7fgJ470j6+m4/slrnQfU3gyCPzwMCq2b2
         NijrEHYcvqmUGTsqJMiUVwJd0bGJ1eNrNvHJ+cG7+Wn+pwV65nbVsNn7kvTURJyWZne2
         qhAKYYDdvXJxLVOMsv/a6IzstdPe/VwcNN4rexe2+PN6ndzNZiJx+/Ht9YxKxHW2VMVz
         6Ohg==
X-Gm-Message-State: AOAM533UDQdtZqkocMKA00u7WY0M+Sj52uDW1bda0gMChzXt3lAu8yDm
        1rXEzEProElrmgMoB2+Jr2j9KQ==
X-Google-Smtp-Source: ABdhPJx/Fa72tAGu1Nd2n7c6WTneyUPE8P+QUh0M/5mPzebk3jNNAYe9MOCNHQ+TlvmegftvkHDFTg==
X-Received: by 2002:a63:4713:: with SMTP id u19mr8349192pga.209.1612291332414;
        Tue, 02 Feb 2021 10:42:12 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id t15sm3478875pjy.37.2021.02.02.10.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 10:42:11 -0800 (PST)
Date:   Tue, 2 Feb 2021 10:42:05 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <YBmc/T8L9RCoyeWr@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
 <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
 <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
 <YBVdNl+pTBBm6igw@kernel.org>
 <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
 <89755f15-a873-badc-b3d6-d4f0f817326e@redhat.com>
 <87a8a3f4-3775-21f1-cb67-107cca1a78e5@intel.com>
 <88e25510-a2e0-c4b8-4dcf-0afb78d5532c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88e25510-a2e0-c4b8-4dcf-0afb78d5532c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Paolo Bonzini wrote:
> On 02/02/21 19:00, Dave Hansen wrote:
> > > /* "" Basic SGX */
> > > /* "" SGX Enclave Dynamic Memory Mgmt */
> > Do you actually want to suppress these from /proc/cpuinfo with the ""?
> > 
> 
> sgx1 yes.  However sgx2 can be useful to have there, I guess.

Agreed, /proc/cpuinfo's sgx1 will always be in lockstep with sgx, so it won't
be useful for dealing with the fallout of hardware disabling SGX due to software
disabling a machine check bank via WRMSR(MCi_CTL).  I can't think of any other
use case for checking /proc/cpuinfo's sgx1.
