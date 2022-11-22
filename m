Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49928633A38
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 11:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbiKVKfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 05:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbiKVKeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 05:34:14 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAA99FEF;
        Tue, 22 Nov 2022 02:31:06 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669113063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hyIj3LmVhEYLX36wfujnCfZwEDiB/P1zQlL73AIEtTc=;
        b=cpDQmqTRoiW4zJJjcEKCD9XuuGn+BRfmpEaX42L8Z0yJQsrtlsRLSMj4W9phuRsIDed2VG
        9gFtP8CbKovyrFODpX+j8mfEcVvEg3+ROgz2qWRpqkf6hODFZQnExjbuyetqlfwYvdx+Yz
        FeQ+wDf3MGhLhA/q34a84itezufzgFDhEzUGYoZQXfYPdhxjpHR1Z2EvjPznhttVolg6H0
        +Dxa90UvxxW3hJ/8WZemPpbEuvCN/AZ2Et/UIUqwUgWNYtckfEkQAMEd85iycIUu+Bzffu
        uLnARxlfknoXvOMXFrtO87NsRC/atGDyq0QFqT8mnKPEDlfqrhAGEQhlBha0AA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669113063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hyIj3LmVhEYLX36wfujnCfZwEDiB/P1zQlL73AIEtTc=;
        b=v3qfWM+1iFsEhZ6c4Ia+vQVM01NXRwxlYDhbENglPpQJ/FJIqF5Je0Mi/8IJ30DWOcnwy+
        dsN+LcrA2cuLuMAg==
To:     Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX
 on demand
In-Reply-To: <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
 <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net>
Date:   Tue, 22 Nov 2022 11:31:02 +0100
Message-ID: <87edtvgu1l.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22 2022 at 10:02, Peter Zijlstra wrote:
> On Mon, Nov 21, 2022 at 01:26:26PM +1300, Kai Huang wrote:
>> +	cpus_read_unlock();
>> +
>> +	return ret;
>> +}
>
> Uhm.. so if we've offlined all the SMT siblings because of some
> speculation fail or other, this TDX thing will fail to initialize?
>
> Because as I understand it; this TDX initialization happens some random
> time after boot, when the first (TDX using) KVM instance gets created,
> long after the speculation mitigations are enforced.

Correct. Aside of that it's completely unclear from the changelog why
TDX needs to run the seamcall on _all_ present CPUs and why it cannot
handle CPU being hotplugged later.

It's pretty much obvious that a TDX guest can only run on CPUs where
the seam module has been initialized, but where does the requirement
come from that _ALL_ CPUs must be initialized and _ALL_ CPUs must be
able to run TDX guests?

I just went and read through the documentation again.

  "1. After loading the Intel TDX module, the host VMM should call the
      TDH.SYS.INIT function to globally initialize the module.

   2. The host VMM should then call the TDH.SYS.LP.INIT function on each
      logical processor. TDH.SYS.LP.INIT is intended to initialize the
      module within the scope of the Logical Processor (LP)."

This clearly tells me, that:

  1) TDX must be globally initialized (once)

  2) TDX must be initialized on each logical processor on which TDX
     root/non-root operation should be executed

But it does not define any requirement for doing this on all logical
processors and for preventing physical hotplug (Neither for CPUs nor for
memory).

Nothing in the TDX specs and docs mentions physical hotplug or a
requirement for invoking seamcall on the world.

Thanks,

        tglx


