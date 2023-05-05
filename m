Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6D86F872F
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 19:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjEERBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 13:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjEERB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 13:01:29 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93E19427;
        Fri,  5 May 2023 10:01:27 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCcQt2Hl7zMqBQp;
        Fri,  5 May 2023 19:01:26 +0200 (CEST)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCcQl2DxJzMpxhN;
        Fri,  5 May 2023 19:01:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683306086;
        bh=Gz496lWCqtEQGiFhDAnNdISGi/Ti3+4r45rZfW9pMhA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=0n9dK6yocwQrPoCyZhLiYaFRP+Rrc+AesC8U5DRpIAduml7GS9dfUNu27anU/Nq9H
         X7nX6pZrCIdpSbikNeBpaLS6XS4cxGwP59sL8dmULJe3HbrVsb+7OJzRnuN4Tp0SIU
         jtv1NK7dS4Wb0Fq0T7+YdNL/W/Ml/YkRAsZVmseM=
Message-ID: <39125b11-659f-35f4-ac7a-a3ba31365950@digikod.net>
Date:   Fri, 5 May 2023 19:01:18 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v1 4/9] KVM: x86: Add new hypercall to set EPT permissions
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?Q?=c8=98tefan_=c8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
References: <20230505152046.6575-1-mic@digikod.net>
 <20230505152046.6575-5-mic@digikod.net> <ZFUyhPuhtMbYdJ76@google.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <ZFUyhPuhtMbYdJ76@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 05/05/2023 18:44, Sean Christopherson wrote:
> On Fri, May 05, 2023, Mickaï¿½l Salaï¿½n wrote:
>> Add a new KVM_HC_LOCK_MEM_PAGE_RANGES hypercall that enables a guest to
>> set EPT permissions on a set of page ranges.
> 
> IMO, manipulation of protections, both for memory (this patch) and CPU state
> (control registers in the next patch) should come from userspace.  I have no
> objection to KVM providing plumbing if necessary, but I think userspace needs to
> to have full control over the actual state.

By user space, do you mean the host user space or the guest user space?

About the guest user space, I see several issues to delegate this kind 
of control:
- These are restrictions only relevant to the kernel.
- The threat model is to protect against user space as early as possible.
- It would be more complex for no obvious gain.

This patch series is an extension of the kernel self-protections 
mechanisms, and they are not configured by user space.


> 
> One of the things that caused Intel's control register pinning series to stall
> out was how to handle edge cases like kexec() and reboot.  Deferring to userspace
> means the kernel doesn't need to define policy, e.g. when to unprotect memory,
> and avoids questions like "should userspace be able to overwrite pinned control
> registers".

The idea is to authenticate every changes. For kexec, the VMM (or 
something else) would have to authenticate the new kernel. Do you have 
something else in mind that could legitimately require such memory or CR 
changes?


> 
> And like the confidential VM use case, keeping userspace in the loop is a big
> beneifit, e.g. the guest can't circumvent protections by coercing userspace into
> writing to protected memory .

I don't understand this part. Are you talking about the host user space? 
How the guest could circumvent protections?
