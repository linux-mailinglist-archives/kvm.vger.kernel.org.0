Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E590678D3A
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 02:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbjAXBTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 20:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjAXBTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 20:19:02 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C529EDC
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:19:01 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v3so10347607pgh.4
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rOxlYQn5IVTbZcsZT8BtGideAkmVidS2Y3/OPz6N7C0=;
        b=eXFHzJcyhOw7VhLciS/S1ypBXdK588msqu3ys98NiGGmaI8RAljiz8T6BCKnQppN6m
         z12tOKl7GPpJ0efR4Qetye6eByjbqr+OgwmY23AwF0cj7XXwUfqmwKP+PDOC19PSC9OZ
         2iCcaMAHTb7CokUSejoDSOy6O4fifCsq/63ArbQYuOhuk7x2HaCDTaBi/IsY5bHE93hr
         b4Wdm5KCDkdnoVDWs4oKnLtKvkCwQj62BRrsm7cfedwpEOCNqHlp1BFGiuX99myu/RuX
         PmPN2ntZnHqE50voa+YCcx3HfKQAjuhkAE/QJUg8SRbrPDuZ/nE3DVkMboUL1qqV4C0B
         jWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOxlYQn5IVTbZcsZT8BtGideAkmVidS2Y3/OPz6N7C0=;
        b=LLqncXZPjdA6uEw7THTGsjCFpTUy4iSkK6V5Kb/dowoGhX/A4od5kWDrsQ0Ee9758u
         Gxp0Yx9FncqTS90YBjTnzp/QfZJwnkXRNHY0nWJEjA1iCQhN0iqf+1BrvfqaQ1LTxl3o
         LqL0VRYl5okixSn/ZR8iOoZoF2+nRcIQi6cndYdmnPto2kAaTZvoCFwG3Ubq8inR5Eeg
         NvVUr6c11lGtXEk4ElUTBOIKKtuIdJD9RfMY6nM+GQRHXu/m/FI0NbdmCt+KzPXn0Egr
         OwisxuRhkDxmFP7qHKoOhBkvzU21XOXN5ftvw9szVtRPq4Vdag+5xG0gfpI6BuzMSDMG
         j5yw==
X-Gm-Message-State: AO0yUKXg3hs/3PI0jrvtXTfZDzB2LGvDo7fJmc3AppP4MvK/o3ID1utJ
        TnUPUM70od8OnPSZLuF+Ehuh+w==
X-Google-Smtp-Source: AK7set8MB8x5JTZulDndzboujvV5nEoTMycNiopxs/kJ16Via3RHL9uyHhOy++u9vGcZVbFW0KsmgQ==
X-Received: by 2002:a05:6a00:134c:b0:581:bfac:7a52 with SMTP id k12-20020a056a00134c00b00581bfac7a52mr11256pfu.1.1674523141203;
        Mon, 23 Jan 2023 17:19:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c9-20020aa781c9000000b0058de2c315e6sm218413pfn.158.2023.01.23.17.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:19:00 -0800 (PST)
Date:   Tue, 24 Jan 2023 01:18:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/8] x86/cpu, kvm: Support AMD Automatic IBRS
Message-ID: <Y88yASfHih8o2c7M@google.com>
References: <20230123225700.2224063-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123225700.2224063-1-kim.phillips@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023, Kim Phillips wrote:
> The AMD Zen4 core supports a new feature called Automatic IBRS
> (Indirect Branch Restricted Speculation).
> 
> Enable Automatic IBRS by default if the CPU feature is present.
> It typically provides greater performance over the incumbent
> generic retpolines mitigation.
> 
> Patch 1 [unchanged from v7] Adds support for the leaf that
> contains the AutoIBRS feature bit.
> 
> Patch 2 moves the leaf's open-coded code from __do_cpuid_func()
> to kvm_set_cpu_caps() in preparation for adding the features in
> their native leaf.
> 
> Patches 3-6 introduce the new leaf's supported bits one by one.
> 
> Patch 7 [unchanged from v7] Adds support for AutoIBRS by turning
> its EFER enablement bit on at startup if the feature is available.
> 
> Patch 8 [unchanged from v7] Adds support for propagating AutoIBRS
> to the guest.

A few nits, but otherwise looks good.  Thanks!
