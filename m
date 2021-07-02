Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5823B9FCD
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhGBLch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhGBLch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:32:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40199C061762;
        Fri,  2 Jul 2021 04:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eqfd8cFaZGh4/grSU6hjK3iw6WZVk1WxbSLXgtHMWzU=; b=MlnNJAyCmGjTjIPmxJIbGH/r7X
        WeXces7qS6uEgqLtwk7aXl3fdfHfWzDbgRDfnYwvsuHCc+3vwUc/smUE3ArdvYhD7FpcJuFfQwMeN
        kq9zMcs/QmBemTeybRgginHdqwEHhoAsIvzgkoj+55XVfnV4fYzdCP6oaDgT0QRposwnsLQysvaRH
        gCeKE3ecuVRS41ZcO6nrT7ZE3MUg9hZWXrHA51lvtSwG2KO4cenRPO9vSQN8KZeAtNptqjTU8E7g3
        +F6lTnzpl9xayHSYW9Js94xY5/I4NwNyUT1VenwnsN7iz4KQpivupHzh+fbMdMWCSVWQ+3oW0dkei
        kHffWtjg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzHLs-007eKR-Mj; Fri, 02 Jul 2021 11:29:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8663F3001DC;
        Fri,  2 Jul 2021 13:28:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7BD3D20244CE2; Fri,  2 Jul 2021 13:28:55 +0200 (CEST)
Date:   Fri, 2 Jul 2021 13:28:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH V7 03/18] perf/x86/intel: Handle guest PEBS overflow PMI
 for KVM guest
Message-ID: <YN74d+LwFbwO75N3@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622094306.8336-4-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 05:42:51PM +0800, Zhu Lingshan wrote:
> +DECLARE_STATIC_CALL(x86_guest_state, *(perf_guest_cbs->state));
> +
> +/*
> + * We may be running with guest PEBS events created by KVM, and the
> + * PEBS records are logged into the guest's DS and invisible to host.
> + *
> + * In the case of guest PEBS overflow, we only trigger a fake event
> + * to emulate the PEBS overflow PMI for guest PBES counters in KVM.
> + * The guest will then vm-entry and check the guest DS area to read
> + * the guest PEBS records.
> + *
> + * The contents and other behavior of the guest event do not matter.
> + */
> +static void x86_pmu_handle_guest_pebs(struct pt_regs *regs,
> +				      struct perf_sample_data *data)
> +{
> +	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> +	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
> +	struct perf_event *event = NULL;
> +	unsigned int guest = 0;
> +	int bit;
> +
> +	if (!x86_pmu.pebs_vmx || !x86_pmu.pebs_active ||
> +	    !(cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask))
> +		return;
> +
> +	guest = static_call(x86_guest_state)();
> +	if (!(guest & PERF_GUEST_ACTIVE))
> +		return;

I think you've got the branches the wrong way around here; nobody runs a
VM so this branch will get you out without a load.

Only if you're one of those daft people running a VM, are you interested
in any of the other conditions that are required.

Also, I think both pebs_active and pebs_vmx can he a static_branch, but
that can be done later I suppose.
