Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F0B44F96
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 00:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfFMWzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 18:55:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfFMWzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 18:55:10 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 417B785363;
        Thu, 13 Jun 2019 22:55:10 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C5526085B;
        Thu, 13 Jun 2019 22:55:06 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 16506105181;
        Thu, 13 Jun 2019 19:53:03 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5DMqwSl025647;
        Thu, 13 Jun 2019 19:52:58 -0300
Message-ID: <20190613224532.949768676@redhat.com>
User-Agent: quilt/0.66
Date:   Thu, 13 Jun 2019 18:45:32 -0400
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        linux-pm@vger.kernel.org
Subject: [patch 0/5] cpuidle haltpoll driver and governor (v4)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 13 Jun 2019 22:55:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cpuidle-haltpoll driver with haltpoll governor allows the guest
vcpus to poll for a specified amount of time before halting. 
This provides the following benefits to host side polling:

         1) The POLL flag is set while polling is performed, which allows
            a remote vCPU to avoid sending an IPI (and the associated
            cost of handling the IPI) when performing a wakeup.

         2) The VM-exit cost can be avoided.

The downside of guest side polling is that polling is performed
even with other runnable tasks in the host.

Results comparing halt_poll_ns and server/client application
where a small packet is ping-ponged:

host                                        --> 31.33
halt_poll_ns=300000 / no guest busy spin    --> 33.40   (93.8%)
halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73   (95.7%)

For the SAP HANA benchmarks (where idle_spin is a parameter
of the previous version of the patch, results should be the
same):

hpns == halt_poll_ns

                           idle_spin=0/   idle_spin=800/    idle_spin=0/
                           hpns=200000    hpns=0            hpns=800000
DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78   (+1%)
InsertC16T02 (100 thread) 2.14           2.07 (-3%)        2.18   (+1.8%)
DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)      1.29   (-3.7%)
UpdateC00T03 (1 thread)   4.72           4.18 (-12%)       4.53   (-5%)

V2:

- Move from x86 to generic code (Paolo/Christian)
- Add auto-tuning logic (Paolo)
- Add MSR to disable host side polling (Paolo)

V3:

- Do not be specific about HLT VM-exit in the documentation (Ankur Arora)
- Mark tuning parameters static and __read_mostly (Andrea Arcangeli)
- Add WARN_ON if host does not support poll control (Joao Martins)
- Use sched_clock and cleanup haltpoll_enter_idle (Peter Zijlstra)
- Mark certain functions in kvm.c as static (kernel test robot)
- Remove tracepoints as they use RCU from extended quiescent state (kernel
test robot)

V4:
- Use a haltpoll governor, use poll_state.c poll code (Rafael J. Wysocki)



