Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1D533BA6
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 01:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfFCXBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 19:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfFCXBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 19:01:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB6D43082134;
        Mon,  3 Jun 2019 23:01:20 +0000 (UTC)
Received: from amt.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6071D607C5;
        Mon,  3 Jun 2019 23:01:20 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 5C16A105150;
        Mon,  3 Jun 2019 19:54:56 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x53MsmZB007672;
        Mon, 3 Jun 2019 19:54:48 -0300
Message-Id: <20190603225242.289109849@amt.cnet>
User-Agent: quilt/0.60-1
Date:   Mon, 03 Jun 2019 19:52:42 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-15?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= 
        <rkrcmar@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [patch 0/3] cpuidle-haltpoll driver (v2)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 03 Jun 2019 23:01:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cpuidle-haltpoll driver allows the guest vcpus to poll for a specified
amount of time before halting. This provides the following benefits
to host side polling:

        1) The POLL flag is set while polling is performed, which allows
           a remote vCPU to avoid sending an IPI (and the associated
           cost of handling the IPI) when performing a wakeup.

        2) The HLT VM-exit cost can be avoided.

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
DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)	   1.29   (-3.7%)
UpdateC00T03 (1 thread)   4.72           4.18 (-12%)	   4.53   (-5%)

V2:

- Move from x86 to generic code (Paolo/Christian).
- Add auto-tuning logic (Paolo).
- Add MSR to disable host side polling (Paolo).



