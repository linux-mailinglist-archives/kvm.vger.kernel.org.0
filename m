Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC62494544
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbiATBBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiATBBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:01:48 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D27DC06161C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:01:48 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 78so3865043pfu.10
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2mfWUUkdEONMpGOlT6Rolu4VTQEpKACj2ssCBbPWHRQ=;
        b=MZyC4bb/dwsiefnVH0I7NG1POrw6S9lLex8pyoPh9/ZCHIzABO2zi4jvhM5U00TVHj
         Bdr8TVxSl4z2a/3v9UQcGnaUpRvxtt21TohxflF4DYioyS9WnWoKFac27ha+qMsLRV6a
         87pbcXdwlTADh+lIgbmb8jySFU0CiUzjB97q4e9ZY2b4oRQDhj73HPMCWtc9CbkAzzcN
         DXB5swzvsz/4nIqu9EqHLmDd6AQQeYczTOCqz6XWDoe/MUNDGvzsF0RyYqaZaUCMHwCS
         lfTCJZhbRSW8O20+zf3hPl2hiwWUWfkuG7HuBYjQTRA3XzFLZo1FKVl0hrnwOlZSuTMU
         LjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2mfWUUkdEONMpGOlT6Rolu4VTQEpKACj2ssCBbPWHRQ=;
        b=bh1HqoziaV+l0BNrFstB6nqEYRKPyyYKqAnP6MpmAUo6Xm096bpXI9WaApSvPfm+rR
         VS8bF75UUXzeq5E0nUt6I6A3I0CJPuT71JQCLYeNxuiJmcxeYLeW1wVFC7Y1GO/1nKMg
         6KicwbyNZ84EQcsMEI1XMaK85Y+dyjZDMTbh5c6fuXG8wkJqRmsfaGd+EnUQWxVyGKMM
         UEq+M8/57wKMU5nZ+ou8wkQ5syR83xd1clA9hNBwCQwQiQUzoRHYL/wYAj0EfxJkSkl0
         y0qdpR8QR3BTiAHFVUZLFJTLi2oN62z8dw9RNe/xkDG+zsJ181BLzTI6YbNR/Y1h+EmW
         fyvA==
X-Gm-Message-State: AOAM530ygPwuD4JnJbzXE5+X3jdmEm1mwAcYeM6+Zeex9UD0tWlRNQRx
        Mxsa05wNl+CEXwyVIAVudDgA4Q==
X-Google-Smtp-Source: ABdhPJzntDENP9AYuT7H4j+098QA18SsfU+Q2JPLu9VgsH1SlSi1UmHfR7SWTzjGW/VtiKk4aFQQ6g==
X-Received: by 2002:a63:8f09:: with SMTP id n9mr29365981pgd.38.1642640507369;
        Wed, 19 Jan 2022 17:01:47 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l8sm790580pfc.187.2022.01.19.17.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 17:01:46 -0800 (PST)
Date:   Thu, 20 Jan 2022 01:01:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v5 8/8] KVM: VMX: Resize PID-ponter table on demand for
 IPI virtualization
Message-ID: <Yei0d0KVnNphPrP3@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-9-guang.zeng@intel.com>
 <YeCjHbdAikyIFQc9@google.com>
 <43200b86-aa40-f7a3-d571-dc5fc3ebd421@intel.com>
 <YeGiVCn0wNH9eqxX@google.com>
 <67262b95-d577-0620-79bf-20fc37906869@intel.com>
 <Yeb1vkEclYzD27R/@google.com>
 <aba84be5-562a-369e-913d-1b834c141cc6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aba84be5-562a-369e-913d-1b834c141cc6@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022, Zeng Guang wrote:
> It's self-adaptive , standalone function module in kvm, no any extra
> limitation introduced

I disagree.  Its failure mode on OOM is to degrade guest performance, _that_ is
a limitation.  OOM is absolutely something that should be immediately communicated
to userspace in a way that userspace can take action.

> and scalable even future extension on KVM_MAX_VCPU_IDS or new apic id
> implementation released.
>
> How do you think ? :)

Heh, I think I've made it quite clear that I think it's unnecesary complexity in
KVM.  It's not a hill I'll die on, e.g. if Paolo and others feel it's the right
approach then so be it, but I really, really dislike the idea of dynamically
changing the table, KVM has a long and sordid history of botching those types
of flows/features.
