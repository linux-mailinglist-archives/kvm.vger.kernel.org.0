Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850FE5391EE
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 15:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344832AbiEaNjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 09:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344860AbiEaNjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 09:39:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E2F986D1;
        Tue, 31 May 2022 06:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k8+0kfbh15DqVWqmUPPXqZdwpqwvfa3/efB+Um28rcA=; b=UuX0SRaS1swoA6ODqc2CXz3ZXz
        +87aNOIPluPRRrIt5Qjh/RnrRiSPO0UJzukTRFNHhAZUWnN9xVhi9ElcMEoEVuiTZky3ZTleab2K7
        LP4o72J4GK3V0rlEi5c1FJQzKwpuPeJyMDIjMVMYfWl7d7MBXxkZibkzKiJ3OsKFetKq5fxBq8jSY
        w3UiOqZzaykYkG50Ksp91LqxhuFw+4xF/DdG2r7UCoMVfUzn8W/GNl+NxUnRxhWccT+8DBhQ/pBA7
        xUhB+NcqVT6UcSKlv/G+P+Jq40MtS6SYWagvMLG1NFISorW8tSe/RiwFyOg6GFenMZyBXPOav3o9V
        srcjQW8Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nw255-005PYu-FN; Tue, 31 May 2022 13:38:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3F7A83001F7;
        Tue, 31 May 2022 15:38:40 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2BA6D2097B8EF; Tue, 31 May 2022 15:38:40 +0200 (CEST)
Date:   Tue, 31 May 2022 15:38:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jack Allister <jalliste@amazon.com>
Cc:     diapop@amazon.co.uk, metikaya@amazon.co.uk,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: CPU frequency scaling for intel x86_64 KVM
 guests
Message-ID: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
References: <20220531105925.27676-1-jalliste@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531105925.27676-1-jalliste@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 10:59:25AM +0000, Jack Allister wrote:
> A VMM can control a vCPU's CPU frequency by interfacing with KVM via
> the vCPU file descriptor to enable/set CPU frequency scaling for a
> guest. Instead of creating a separate IOCTL to this this, KVM capabil-
> ities are extended to include a capability called
> KVM_CAP_CPU_FREQ_SCALING.
> 
> A generic set_cpu_freq interface is added to kvm_x86_ops
> to allow for architecture (AMD/Intel) independent CPU frequency
> scaling setting.
> 
> For Intel platforms, Hardware-Controlled Performance States (HWP) are
> used to implement CPU scaling within the guest. Further information on
> this mechanism can be seen in Intel SDM Vol 3B (section 14.4). The CPU
> frequency is set as soon as this function is called and is kept running
> until explicitly reset or set again.
> 
> Currently the AMD frequency setting interface is left unimplemented.
> 
> Please note that CPU frequency scaling will have an effect on host
> processing in it's current form. To change back to full performance
> when running in host context an IOCTL with a frequency value of 0
> is needed to run back at uncapped speed.

Nowhere does this explain *WHY* we would want to do this?
