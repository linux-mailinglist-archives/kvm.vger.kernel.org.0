Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF74AC88A
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiBGSaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbiBGSWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 13:22:38 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8A5C0401DA
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 10:22:37 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id c188so17963871iof.6
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 10:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m1aEU9lTWic1NUePNrGVLLAAvoSXwyOyW0XsALGO3ic=;
        b=I6Ns2zNQjYYUhsjmo4FhGBQwNUNHfGIj0aaK1ncQXvJaLdSwEPT6rlxqByHXlfSTt9
         WKYYzaHLDlLr37dkbPpOmRVN4zIZ4EEYJOWqNg/vsTyEZIMEvvzX4VjFoC5AdzPJ55Z8
         /goR609JewRZejUAL5HAZHvLWcuWV/Zz++QM32eawl/7wzqZpJJnf2zZHcGbkmwtSWgQ
         3kiIDeBT8n9nnfcSlbTi2i+igsjo1P5kjLDuaM6nV7rqJS5MRvNVfoYSRFUYslgBI2RM
         FfpwaZgzNZETdh5miRm4qkD1QI5VHVBUxczkWpJpNm6GZyXFtATiStPA6dE9R6spK8H5
         FoKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m1aEU9lTWic1NUePNrGVLLAAvoSXwyOyW0XsALGO3ic=;
        b=pICjSnYqBQCQG7F6BrM8/uFUXGFM/1/nCa3l5D17leo33PxdpUm3McDHGnEfOh0Cu6
         Pu4SRyi4+hd4UdRVfsWIfV9qvwW5D6vPJVtAg/T1E3gXUaBfro6nJlrtZRNNAiLaG1g+
         NS6E71KbuMaQcSGRpX1sp9ezJnq6cWpc8YWDFzTjN3JOjVBeN44Rai5OF88DzjsNYnjw
         YwxMNNBYpBfqVdqqdPdMYHOTm6GE5Z6sJV15qHxD9uxYT3P1ky+wTwaH/WFGVmIb58p3
         TV3019Xe5BqJmA/g8Sgd3rYEwWQCGHaBn9zQppU66Voht/VgjhDFfFDT+08maljWfzhw
         obYQ==
X-Gm-Message-State: AOAM531U6SF8l9nLGtEUVDr3XxiidZa1uMyfewhhMlcAPtbr2Xg5H4z5
        lMUyd6MaIGryJc5g/Biy2bprsA==
X-Google-Smtp-Source: ABdhPJzFTfrgwxcuMdlys/v7RgLC4dl/PoF6oBZY/kZc5ErXuveG++/q/VAuSsZTtfkgYk8lUWAvYA==
X-Received: by 2002:a02:3b67:: with SMTP id i39mr483908jaf.32.1644258156987;
        Mon, 07 Feb 2022 10:22:36 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id ay35sm6454591iob.3.2022.02.07.10.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:22:36 -0800 (PST)
Date:   Mon, 7 Feb 2022 18:22:33 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <YgFjaY18suUJjkLL@google.com>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-2-oupton@google.com>
 <ce6e9ae4-2e5b-7078-5322-05b7a61079b4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce6e9ae4-2e5b-7078-5322-05b7a61079b4@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Mon, Feb 07, 2022 at 06:21:30PM +0100, Paolo Bonzini wrote:
> On 2/4/22 21:46, Oliver Upton wrote:
> > Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
> > when guest MPX disabled"), KVM has taken ownership of the "load
> > IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls. The ABI
> > is that these bits must be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
> > MSRs if the guest's CPUID supports MPX, and clear otherwise.
> > 
> > However, KVM will only do so if userspace sets the CPUID before writing
> > to the corresponding MSRs. Of course, there are no ordering requirements
> > between these ioctls. Uphold the ABI regardless of ordering by
> > reapplying KVMs tweaks to the VMX control MSRs after userspace has
> > written to them.
> 
> I don't understand this patch.  If you first write the CPUID and then the
> MSR, the consistency is upheld by these checks:
> 
>         if (!is_bitwise_subset(data, supported, GENMASK_ULL(31, 0)))
>                 return -EINVAL;
> 
>         if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
>                 return -EINVAL;

Right, this works if KVM chose to clear the bit, but userspace is trying
to set it. If KVM chose to set the bit, and userspace attempts to clear
it, these checks would pass.

> If you're fixing a case where userspace first writes the MSR and then sets
> CPUID, then I would expect that KVM_SET_CPUID2 redoes those checks and, if
> they fail, it adjusts the MSRs.

I am fixing the case where userspace issues KVM_SET_CPUID2 then writes
to the corresponding MSRs.

Until recently, this all sort of 'worked'. Since we called
kvm_update_cpuid() all the time it was possible for KVM to overwrite the
bits after the MSR write, just not immediately so. After the whole CPUID
rework, we only update the VMX control MSRs immediately after a
KVM_SET_CPUID2, meaning we've missed the case of MSR write after CPUID.

The entire spirit of this series is to back KVM out of touching these
bits, but it seemingly requires a quirk to do so given the userspace
expectations around these bits. Given that, these first two patches fix
the ordering issue between KVM_SET_CPUID2 and an MSR write and enforce
KVM ownership unconditionally.

--
Thanks,
Oliver
