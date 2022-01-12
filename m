Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468FB48CA82
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 18:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355897AbiALR7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 12:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355857AbiALR7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 12:59:33 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70268C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:59:33 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u15so5109709ple.2
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lxclRLr31RsJ2S0clQHvNH9FSmldpFyw3vzSNMFjSFI=;
        b=CAWdvjx4EIviY6PjoqmwBfiBTEBiP2yCL1Zhg1c+jTo0nQbaSdZ7cavQNNpQJlxUOa
         MqJW+H+95+zTC4n2JrC5v8O37hr5S8tJF85taoqIrK4G9YZ9aDYGfIQeLnLgxaozofVN
         WukIDUkb/3u9HHaHemlszAkSG7/6T10REeYRLwBg/msN/qTb+dvBSWbMRXYkc21S2Tj9
         U3B0oEeAq3fWixc1gFqo2/APlTeIlvhOtjULsGPFFm4H5mM5F4eJeoiKeLajXtjWlXtX
         MrPe3nToRSgtNJkf0SzzB8nn88VsDDcH6YyF0rScyBlaaDb7B//tsNm540FV9QRLGm+z
         t5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lxclRLr31RsJ2S0clQHvNH9FSmldpFyw3vzSNMFjSFI=;
        b=4nQQ6P5dVxmqgLzy0Leh2A1YLeZL1x/cOjOlsPkiOnkZbzb9hyUkllzyEHYUR9kKXj
         xtJrkayAWGu/DOjkjKvp7B9Y/UoPgxkzjOVFB3W03Vibs/z1Earni1ac6KH6fqpJVuna
         n/p5UGEpeDySfkGm2BLAZaXtLEaQUXjVkN6GSNcQVLC4+TN2COA3K77y634SpFW8ZJmS
         MFF0TaPhH2jHD+L0F3Q55iN964QWNM89pXKiMc/82D6UeY/JHzY/JYPHuPUuoPk+PV0y
         WjJQx7CdIwJ9R94RgxTj+1kkQIWbjNc7KhPqBnTZ4cykyui6lEmZHilgGbUdYqIyLCK8
         m7og==
X-Gm-Message-State: AOAM532QBxE6P2NT69a06KKR1dEXxFVP5yvmzHdb+eq7i4N5HncggrbJ
        Gz61hLBVibYagAqrtNz7lKLxHg==
X-Google-Smtp-Source: ABdhPJyX3xmDpuVIwP3Tj2o04khmgeJrxi1LlFZLssvNNNqiBbIVjqyCDijaR55cpWlGdkK1yamSLQ==
X-Received: by 2002:a63:35cd:: with SMTP id c196mr667720pga.623.1642010372774;
        Wed, 12 Jan 2022 09:59:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u27sm275481pfg.45.2022.01.12.09.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 09:59:32 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:59:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] KVM: x86: Move check_processor_compatibility from
 init ops to runtime ops
Message-ID: <Yd8XAI7G4sEab9Nh@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-2-chao.gao@intel.com>
 <YdzAzT5AqO0aCsHk@google.com>
 <20220111033629.GC2175@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111033629.GC2175@gao-cwp>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022, Chao Gao wrote:
> On Mon, Jan 10, 2022 at 11:27:09PM +0000, Sean Christopherson wrote:
> >On Mon, Dec 27, 2021, Chao Gao wrote:
> >> so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
> >> from check_processor_compatibility() and its callees.
> >
> >Losing the __init annotation on all these helpers makes me a bit sad, more from a
> >documentation perspective than a "but we could shave a few bytes" perspective.
> 
> This makes sense.
> 
> >More than once I've wondered why some bit of code isn't __init, only to realize
> >its used for hotplug.
> 
> Same problem to some global data structures which can be __initdata if hotplug
> isn't supported.
> 
> >
> >What if we added an __init_or_hotplug annotation that is a nop if HOTPLUG_CPU=y?
> 
> Personally __init_or_hotplug is a little long as an annotation. How about
> __hotplug?
> 
> One concern is: is it acceptable to introduce a new annotation and use it in
> new code but not fix all places that should use it in existing code.
> 
> I think the right process is
> 1. introduce a new annotation
> 2. fix existing code to use this annotation
> 3. add new code.
> 
> There is no doubt that #2 would take great effort. I'm not sure if it is really
> worth it.
> 
> >At a glance, KVM could use that if the guts of kvm_online_cpu() were #idef'd out
> >on !CONFIG_HOTPLUG_CPU.  That also give us a bit of test coverage for bots that
> >build with SMP=n.
> 
> Will do with your suggested-by.

I don't think you should try to add a new annotation in this series.  My question
really was just that, a question to others if there would be value in adding an
annotation to identify symbols that are !__init only because of hotplug.  Such new
functionality is certainly not required for fixing KVM's mishandling of hotplug,
and trying to cram it in here will bloat and slow down this series.
