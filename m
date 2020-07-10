Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1750921BD11
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 20:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgGJSfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 14:35:43 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7518 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727091AbgGJSfn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 14:35:43 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 10 Jul 2020 11:35:38 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id C431440CB1;
        Fri, 10 Jul 2020 11:35:42 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 0/4] x86: svm: bare-metal fixes
Date:   Fri, 10 Jul 2020 11:33:16 -0700
Message-ID: <20200710183320.27266-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches are intended to allow the svm tests to run on bare-metal.
The second patch indicates there is a bug in KVM.

Unfortunately, two tests still fail on bare-metal for reasons that I
could not figure out, with my somewhat limited SVM knowledge.

The first failure is "direct NMI while running guest". For some reason
the NMI is not delivered. Note that "direct NMI + hlt" and others pass.

The second is npt_rw_pfwalk_check. Even after the relevant fixes,
exit_info_2 has a mismatch, when the expected value (of the faulting
guest physical address) is 0x641000 and the actual is 0x641208. It might
be related to the fact that the physical server has more memory, but I
could not reproduce it on a VM with more physical memory.

Nadav Amit (4):
  x86: svm: clear CR4.DE on DR intercept test
  x86: svm: present bit is set on nested page-faults
  x86: remove blind writes from setup_mmu()
  x86: Allow to limit maximum RAM address

 lib/x86/fwcfg.c | 4 ++++
 lib/x86/fwcfg.h | 1 +
 lib/x86/setup.c | 7 +++++++
 lib/x86/vm.c    | 3 ---
 x86/svm_tests.c | 5 +++--
 5 files changed, 15 insertions(+), 5 deletions(-)

-- 
2.25.1

