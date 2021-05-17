Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17CC383BDF
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 20:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbhEQSGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 14:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbhEQSGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 14:06:17 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D8BC061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:05:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 6so5189550pgk.5
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RK9CKsxYiZ0SKcAPJMjkDQ9/exTOSP2ko5N4Ci6GuXs=;
        b=LSaIZZlsx3p9ej1B86/ciNnrvYc8952OFvB5rJLgzDWArbdNp7pJvfg3PGluQUAgUu
         fsovaLGtnPco/Y6H4PoNWmd6Jip2Ipp/eMy91HQAhHrUQhhg1R3giyX+8v1bmTCfue6S
         M5Wi7U4j4xv//BZj/r9x5A57SzVUUGr8aAPyZcOnHnd5AsLLtYgMa4j7mhAMXbZ8IWdJ
         LZkw+RyAMRe/0NGmrBQOyRrtbIrFwWOwGiu0gnTV1FdXG3BEtqGUd575jX8dj/w/7yXY
         LeMc9aOJYHIZ8Zlw/TwwMWBKMbkih0xiE3/wCFspJPArkT8JoUDBFgpWMaJIEtJZDzR7
         t4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RK9CKsxYiZ0SKcAPJMjkDQ9/exTOSP2ko5N4Ci6GuXs=;
        b=ugwo+pIYlMNEKGJFFZJgpowIlJKGdirMXRH4hBnResa7Iz/3YYOkFWXaWvSr2wE17M
         d9srZcDmK8xnfec9wMlh16f0MEY+Ogf+0TBvV1FQCvOnXgibWTg7g7O+uh1/xOXAelyD
         /exHV+iL5hrd0nHNMX6c6R2UNrvAm3cHYLUkpm7dYae5ChtueItSF0fCDrg4iwk0W+e/
         tUI/cWknd3HEre4KKjX6DChNcauYo6pJL822IP3BJro3hK9L/nuF4teps6dTHvVmZnDo
         St4QONk8FLOJhg7bvSvxOlC/SkCervVBk+WQ1rll37stHN27PgNC+weoELITVdf4u2HW
         QjAw==
X-Gm-Message-State: AOAM533tEW96g3JK+WkMC8TgZYMMhQZ+1ChLzVBMmUW1/5abCwfR21qd
        i0mNB1tFEy0w0swNaXmEeMM4Cw==
X-Google-Smtp-Source: ABdhPJwrHdcqHaaCzqnkXKeuTTo/NFeQCxMKnHCAmext9WOsmA4UolhzEow6UhPiLLfsr6hujFEtrg==
X-Received: by 2002:a65:6183:: with SMTP id c3mr715412pgv.403.1621274700186;
        Mon, 17 May 2021 11:05:00 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x184sm11459121pgb.36.2021.05.17.11.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 11:04:59 -0700 (PDT)
Date:   Mon, 17 May 2021 18:04:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Message-ID: <YKKwSLnkzc77HcnG@google.com>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
 <5e01d18b-123c-b91f-c7b4-7ec583dd1ec6@redhat.com>
 <YKKqQZH7bX+7PDjX@google.com>
 <4e6f7056-6b66-46b9-9eac-922ae1c7b526@www.fastmail.com>
 <342a8ba9-037e-b841-f9b1-cb62e46c0db8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342a8ba9-037e-b841-f9b1-cb62e46c0db8@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Dave Hansen wrote:
> On 5/17/21 10:49 AM, Andy Lutomirski wrote:
> >> The least awful solution would be to have the NMI handler restore
> >> the host's PKRU.  The NMI handler would need to save/restore the
> >> register, a la CR2, but the whole thing could be optimized to run
> >> if and only if the NMI lands in the window where the guest's PKRU
> >> is loaded.
> > 
> > Or set a flag causing nmi_uaccess_ok() to return false.
> 
> Oh, that doesn't sound too bad.  The VMENTER/EXIT paths are also
> essentially a context switch.

I like that idea, too.

The flag might also be useful to fix the issue where the NMI handler activates
PEBS after KVM disables it.  Jim?

> Will widening the window where nmi_uaccess_okay()==false anger any of
> the perf folks?  It looks like perf knows how to handle it nicely.
