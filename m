Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8947469E53
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 16:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358004AbhLFPiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 10:38:08 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:41930 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387701AbhLFPbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 10:31:44 -0500
Received: by mail-oi1-f175.google.com with SMTP id u74so22006763oie.8;
        Mon, 06 Dec 2021 07:28:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vmY9WY/IdHkBubH/d9+H2NnZMjAMu0umDpKHxPiSoSU=;
        b=Jrg7IbYxtnNeP+fRmAsa1q5NHAFnrjui64xBACd1AENxji6+7hIFdIld6eJ1acRjAC
         wXZ8lkl1jxQn1yJ5Mhj2wuKIs4Rbr8EULUD3TSKnnoD79YJL0z6pYupseU3ZTUGGKKmx
         yJ3Rlc/REdpufwwa13+371WDKPdnAMMZ3E0tvQSDhNVIuK6Ch2pv3qdGXhQkm4oZqWaY
         UxQe/a4DMnl7tQVtAilUnLDo8RvNn+Z+Z864WfbE8WBqclvUI84G+LnXdiBSmSlf2/Rz
         zz/rQGuxvPvVL0IWLLf052G7eDInRGXcZNAmHaJVJf6DrQ3BdQqENq/1KvxyVZXZLA/m
         4ejg==
X-Gm-Message-State: AOAM533BgTBbtOrFxOO58v/7bLYS5pe+9dcRYqt+wjUNl96NnLcO3CxU
        AdvZdlrskmJ6ep+K9EGtWw==
X-Google-Smtp-Source: ABdhPJyfHepTpy+8C5WIBaswVad+pb+ARigaK7+tiIrrbzB1awNCTodg/k/StbwlXs0D2pl0zwBHtg==
X-Received: by 2002:a05:6808:218b:: with SMTP id be11mr25541435oib.80.1638804495458;
        Mon, 06 Dec 2021 07:28:15 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id o10sm2141225oom.32.2021.12.06.07.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 07:28:14 -0800 (PST)
Received: (nullmailer pid 2069157 invoked by uid 1000);
        Mon, 06 Dec 2021 15:28:13 -0000
Date:   Mon, 6 Dec 2021 09:28:13 -0600
From:   Rob Herring <robh@kernel.org>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     linux-kernel@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: Re: [RFC 0/6] Sparse HART id support
Message-ID: <Ya4sDX974/dVEOQw@robh.at.kernel.org>
References: <20211204002038.113653-1-atishp@atishpatra.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211204002038.113653-1-atishp@atishpatra.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 03, 2021 at 04:20:32PM -0800, Atish Patra wrote:
> Currently, sparse hartid is not supported for Linux RISC-V for the following
> reasons.
> 1. Both spinwait and ordered booting method uses __cpu_up_stack/task_pointer
>    which is an array size of NR_CPUs.
> 2. During early booting, any hartid greater than NR_CPUs are not booted at all.
> 3. riscv_cpuid_to_hartid_mask uses struct cpumask for generating hartid bitmap.
> 4. SBI v0.2 implementation uses NR_CPUs as the maximum hartid number while
>    generating hartmask.
> 
> In order to support sparse hartid, the hartid & NR_CPUS needs to be disassociated
> which was logically incorrect anyways. NR_CPUs represent the maximum logical|
> CPU id configured in the kernel while the hartid represent the physical hartid
> stored in mhartid CSR defined by the privilege specification. Thus, hartid
> can have much greater value than logical cpuid.

We already have a couple of architectures with logical to physical CPU 
id maps. See cpu_logical_map. Can we make that common and use it here? 
That would also possibly allow for common populating the map from DT.

Rob
