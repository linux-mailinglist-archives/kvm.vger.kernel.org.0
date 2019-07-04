Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681D75F4A4
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 10:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfGDIdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 04:33:10 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34273 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfGDIdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 04:33:10 -0400
Received: by mail-oi1-f193.google.com with SMTP id l12so4374246oil.1;
        Thu, 04 Jul 2019 01:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QcBh93VFBddAYtzF82VXStOQknTxL1BWk6hVzs+I7IQ=;
        b=KNLjBnlY+rI0iWYv0+qE8TGI3fnx7kzYX01TrdS2ebJSH//2NrMeEbgfeOPyq3snpb
         N4OxT86vizA3wtboJXgxJ80tBEM1MCUSRT+8sKQycXqWH34xE3O2iszOJpC3q+fSH1Wi
         dG+EDcYI9OP+XFKGx/gcBGuyzyA9hI77+4O4kxBcd9QzS38/NOr3+H3K0UNiE2Pv7KIK
         w9C+VebJWZdpbA61tP78Hhf3kSdnETTrXDCdd8QieTTzGPWyowX5f/Coi8nsdNSiWK91
         /6rV1b3Im9cSqhsJBdVbkBjwuKBrkF+WV+R5njP9Hrqwg2Tvl7UGGYa9FwQNiO1XfbzS
         noGw==
X-Gm-Message-State: APjAAAVJ96qFAH4lzRm+ZZPC7759eLLsIaCLEHUGs9vsyoSsqshgUGOY
        inQ7B4q2h3jBEjcyctAlvIJfmZXVFe001DTK3mc=
X-Google-Smtp-Source: APXvYqxCbU3d4s3NtZPiBXB59OF0I2cXGXBbE/he2GcjxUKXbn2jmODr6z83QuznkAl/LN5ao+gzv7orFEOsicc5lts=
X-Received: by 2002:aca:5a41:: with SMTP id o62mr1220117oib.110.1562229189249;
 Thu, 04 Jul 2019 01:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190703235124.783034907@amt.cnet>
In-Reply-To: <20190703235124.783034907@amt.cnet>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 4 Jul 2019 10:32:56 +0200
Message-ID: <CAJZ5v0jU4MC9j+qWpmZrD86YMS8iKO-m8c94N_MuX1nYrSEmRg@mail.gmail.com>
Subject: Re: [patch 0/5] cpuidle haltpoll driver and governor (v6)
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 4, 2019 at 1:59 AM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> (rebased against queue branch of kvm.git tree)
>
> The cpuidle-haltpoll driver with haltpoll governor allows the guest
> vcpus to poll for a specified amount of time before halting.
> This provides the following benefits to host side polling:
>
>          1) The POLL flag is set while polling is performed, which allows
>             a remote vCPU to avoid sending an IPI (and the associated
>             cost of handling the IPI) when performing a wakeup.
>
>          2) The VM-exit cost can be avoided.
>
> The downside of guest side polling is that polling is performed
> even with other runnable tasks in the host.
>
> Results comparing halt_poll_ns and server/client application
> where a small packet is ping-ponged:
>
> host                                        --> 31.33
> halt_poll_ns=300000 / no guest busy spin    --> 33.40   (93.8%)
> halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73   (95.7%)
>
> For the SAP HANA benchmarks (where idle_spin is a parameter
> of the previous version of the patch, results should be the
> same):
>
> hpns == halt_poll_ns
>
>                            idle_spin=0/   idle_spin=800/    idle_spin=0/
>                            hpns=200000    hpns=0            hpns=800000
> DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78   (+1%)
> InsertC16T02 (100 thread) 2.14           2.07 (-3%)        2.18   (+1.8%)
> DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)      1.29   (-3.7%)
> UpdateC00T03 (1 thread)   4.72           4.18 (-12%)       4.53   (-5%)
>
> V2:
>
> - Move from x86 to generic code (Paolo/Christian)
> - Add auto-tuning logic (Paolo)
> - Add MSR to disable host side polling (Paolo)
>
> V3:
>
> - Do not be specific about HLT VM-exit in the documentation (Ankur Arora)
> - Mark tuning parameters static and __read_mostly (Andrea Arcangeli)
> - Add WARN_ON if host does not support poll control (Joao Martins)
> - Use sched_clock and cleanup haltpoll_enter_idle (Peter Zijlstra)
> - Mark certain functions in kvm.c as static (kernel test robot)
> - Remove tracepoints as they use RCU from extended quiescent state (kernel
> test robot)
>
> V4:
> - Use a haltpoll governor, use poll_state.c poll code (Rafael J. Wysocki)
>
> V5:
> - Take latency requirement into consideration (Rafael J. Wysocki)
> - Set target_residency/exit_latency to 1 (Rafael J. Wysocki)
> - Do not load cpuidle driver if not virtualized (Rafael J. Wysocki)
>
> V6:
> - Switch from callback to poll_limit_ns variable in cpuidle device structure
> (Rafael J. Wysocki)
> - Move last_used_idx to cpuidle device structure (Rafael J. Wysocki)
> - Drop per-cpu device structure in haltpoll governor (Rafael J. Wysocki)

It looks good to me now, but I have some cpuidle changes in the work
that will clash in some changes in this series if not rebased on top
of it, so IMO it would make sense for me to get patches [1-4/5] at
least into my queue.  I can expose an immutable branch with them for
the KVM tree to consume.  I can take the last patch in the series as
well if I get an ACK for it.

Would that work for everybody?
