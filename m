Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDB269259A
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 19:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbjBJSph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 13:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbjBJSpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 13:45:34 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDBF7A7F1
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 10:45:33 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso9185511pju.0
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 10:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PLq/Mzr8440h4rqzutXNOZm+oL1xDtZlc6Z+oggEf4Q=;
        b=Juk+l4ZEzsWfLMJ2plf3CPB8rCMIbve+DTwBR8/C48iczq96dm+UZ/2tNIRtT6Y5jI
         pvVhTx6/sujdbCo1eiGsoO104QGCjtpshDd5ILv4w8jDb0cKLKgBJs9TuiRGSy4k9UNM
         QuCYYuZ3inmNVY+uuFei1BdFgU6V9BR92yTxjiqipj5vRFrSALRdS4wlpOzMTHohP2Si
         oqY/b+kgU4AopdSEv045V7HqWJWrpMQZ8mCqPUaqzrsaqAVnTE2tqoOjVFpXA1pU+YYL
         D1dGI2Z4h8IE/nLDPfSpaPa4JqgRMf6BGllmm3i0HVYsmiJML23PiZb/7stjRr4RQirL
         rSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLq/Mzr8440h4rqzutXNOZm+oL1xDtZlc6Z+oggEf4Q=;
        b=iwRGV2BMWlIJuecjJI9Z8H89zSBqiua1Mluzl4VAKhAwOUmepPxGA6F2A2py4lK965
         jB+xYexMA+ioalPfd05BXjR2VVRH9b3f1cxA6OBjhUNHVegbyR/qmb2B6dvEp0WAMel3
         Hewp3R9alTeaoI/oUqvtyZsXDggHF/sXv4htCzMcVQf5g/c2lqae0ikvFsw6aDN456Qm
         g9N3yAmlz7njRfPoU2xZBY8yHDp4WYwtIbVQ6Snp5W9QyhXiHcN/pjFAqXohvIdlT/3p
         nrk+3OmTPdvUag9mutDSvK5TJXp5VqhAcYdgyt1NdLwe9Z8N6RAT1PCQ42EWCBVu8TJ7
         N03g==
X-Gm-Message-State: AO0yUKUrKFJrlh4ZvMTShDXN+6/I7R+shBFnYM5an9YbNEz9dYMwIqiH
        sntkFtgFGdNmLbjbZ1VFNNe5mA==
X-Google-Smtp-Source: AK7set+orDhCW8fO3sDLC9SJZSkePX9IrYiCNYicSjDmTlOeezv6IkqFzBwqLexg8wsetP+5OgV7Rw==
X-Received: by 2002:a17:902:c1d2:b0:198:af50:e4e4 with SMTP id c18-20020a170902c1d200b00198af50e4e4mr5916plc.10.1676054732683;
        Fri, 10 Feb 2023 10:45:32 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jl14-20020a170903134e00b0019117164732sm3670140plb.213.2023.02.10.10.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 10:45:32 -0800 (PST)
Date:   Fri, 10 Feb 2023 18:45:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
Message-ID: <Y+aQyFJt9Tn2PJnC@google.com>
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023, Jeremi Piotrowski wrote:
> Hi Paolo/Sean,
> 
> We've noticed that changes introduced in "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing"
> conflict with a nested Hyper-V enlightenment that is always enabled on AMD CPUs 
> (HV_X64_NESTED_ENLIGHTENED_TLB). The scenario that is affected is L0 Hyper-V + L1 KVM on AMD,
> 
> L2 VMs fail to boot due to to stale data being seen on L1/L2 side, it looks
> like the NPT is not in sync with L0. I can reproduce this on any kernel >=5.18,
> the easiest way is by launching qemu in a loop with debug OVMF, you can observe
> various #GP faults, assert failures, or the guest just suddenly dies. You can try it
> for yourself in Azure by launching an Ubuntu 22.10 image on an AMD SKU with nested
> virtualization (Da_v5).
> 
> In investigating I found that 3 things allow L2 guests to boot again:
> * force tdp_mmu=N when loading kvm
> * recompile L1 kernel to force disable HV_X64_NESTED_ENLIGHTENED_TLB
> * revert both of these commits (found through bisecting):
> bb95dfb9e2dfbe6b3f5eb5e8a20e0259dadbe906 "KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages"
> efd995dae5eba57c5d28d6886a85298b390a4f07 "KVM: x86/mmu: Zap defunct roots via asynchronous worker"
> 
> I'll paste our understanding of what is happening (thanks Tianyu):
> """
> Hyper-V provides HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE
> and HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST hvcalls for l1
> hypervisor to notify Hyper-V after L1 hypervisor changes L2 GPA <-> L1 GPA address
> translation tables(Intel calls EPT and AMD calls NPT). This may help not to
> mask whole address translation tables of L1 hypervisor to be write-protected in Hyper-V
> and avoid vmexits triggered by changing address translation table in L1 hypervisor. 
> 
> The following commits defers to call these two hvcalls when there are changes in the L1
> hypervisor address translation table. Hyper-V can't sync/shadow L1 address space
> table at the first time due to the delay and this may cause mismatch between shadow page table
> in the Hyper-V and L1 address translation table. IIRC, KVM side always uses write-protected
> translation table to shadow and so doesn't meet such issue with the commit.
> """
> 
> Let me know if either of you have any ideas on how to approach fixing this.
> I'm not familiar enough with TDP MMU code to be able to contribute a fix directly
> but I'm happy to help in any way I can.

As a hopefully quick-and-easy first step, can you try running KVM built from:

  https://github.com/kvm-x86/linux/tree/mmu

specifically to get the fixes for KVM's usage of range-based TLB flushes:

  https://lore.kernel.org/all/cover.1665214747.git.houwenlong.hwl@antgroup.com
