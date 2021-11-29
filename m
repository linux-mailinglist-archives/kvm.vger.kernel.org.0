Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4643446269C
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhK2Wz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbhK2WzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:55:00 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66225C111CC5
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 09:35:39 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id r130so17691509pfc.1
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 09:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ih96BbBVwkaa/OAQ5xOmVRG9puh17aiQdZRT/C4C3Ak=;
        b=IB7kdk8Kw4Vt4issjhrdqTqcHxhUbTuN4QjXWmQJ78KndsOpzLhkIIyfu6MGZhY6I4
         lZGE7NR6DIi8zQ6m0ui9wMGtbw2+zKGUuh/DX325VFDyZ/cZZtzWk3vMIrgGE87o/+nQ
         sPjDQhimKVChuR72c+tvHLRvL1wRLaUmxMTk6zlU7g3dKTbI5g2M8l0NcOjt+0Syl5lm
         uGLFwejfa1499k3iVSzq0N47iiSUsbDV5jMVgHgv9FmqFxChnXP3OruuV7tXMoUcQaFh
         bHhdE0vxUZxZIADZtRIVAk6ExnZQYEbH0cC2bpDfiD8hN1pfzF6DuNs+in11fNm9rWP0
         l3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ih96BbBVwkaa/OAQ5xOmVRG9puh17aiQdZRT/C4C3Ak=;
        b=iqg0qZWiJyeULtQ1Q3swDaqFV/18NZy2uuG48Afl1c2fA99seYu44rtPSHM3j28svO
         otXnNiKPbj3a0zaNTowfc3lzd83xlTE5KABam43SmL5k3awDqEkGxa7xZWBDJaDXl9Dn
         DfxFG7znTuEoCY+tFNHw8uTIzcDhyUxq71Cvm5XwSjpfHGlUlE8Kw/gG0E5HevczWE9s
         FZTbyyqIzF22tP8WAGuVL2Nw7Sz+i+LcWPRAkXOb+VZfIbsf0PNeatGAnsc02FBtSINg
         j81apdNxUu4FDqEoDdBS4WK2Pd4S6HgWDQHOpyXtdGOvcBo0OPCuMh8vyy/1F3eSrNj3
         1k1w==
X-Gm-Message-State: AOAM532jqpcE/6q4dYIRPjfUEGaOhQIE21f69cQnHGywjPrBANpdD3kZ
        gyFlFR+TvNAyppGpEb86l9GAyA==
X-Google-Smtp-Source: ABdhPJw8ktOad9TfV2nRroxY5SC1V237eK+PLNwpqF9SV/4/4MaSkNfSKd+yv/2Q/ltiECMCVFT5LQ==
X-Received: by 2002:a65:6488:: with SMTP id e8mr36312690pgv.416.1638207338797;
        Mon, 29 Nov 2021 09:35:38 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d9sm387607pjs.2.2021.11.29.09.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 09:35:37 -0800 (PST)
Date:   Mon, 29 Nov 2021 17:35:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 14/59] KVM: x86: Add vm_type to differentiate
 legacy VMs from protected VMs
Message-ID: <YaUPZj4ja5FY7Fvh@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <60a163e818b9101dce94973a2b44662ba3d53f97.1637799475.git.isaku.yamahata@intel.com>
 <87tug0jbno.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tug0jbno.ffs@tglx>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Thomas Gleixner wrote:
> On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Add a capability to effectively allow userspace to query what VM types
> > are supported by KVM.
> 
> I really don't see why this has to be named legacy. There are enough
> reasonable use cases which are perfectly fine using the non-encrypted
> muck. Just because there is a new hyped feature does not make anything
> else legacy.

Yeah, this was brought up in the past.  The current proposal is to use
KVM_X86_DEFAULT_VM[1], though at one point the plan was to use a generic
KVM_VM_TYPE_DEFAULT for all architectures[2], not sure what happened to that idea.

[1] https://lore.kernel.org/all/YY6aqVkHNEfEp990@google.com/
[2] https://lore.kernel.org/all/YQsjQ5aJokV1HZ8N@google.com/
