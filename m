Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860954533C0
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhKPOOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:14:00 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:40680 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbhKPON4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 09:13:56 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9BFEE1FD26;
        Tue, 16 Nov 2021 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637071858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hNvmd1HYHY5JfEMQ6fzIS8YO9/2TVmGFsGgW8qyoxik=;
        b=NczuAT1a/me+nyICZpVlNDx8Jsu8fTP95KmU+/1RCttl7YYjIcTBsvD1VQ6heaEI+Q/+KG
        QP2+VVMckCPbFAehUo5pCU+X3UKuH/uANQbPuH6fjPkwnd1ebmyZ5Uu89jk00TCuQrqIFA
        ZRXCpj9DROxS5HLAOCcg594P4LjTcxk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0A5B13BAE;
        Tue, 16 Nov 2021 14:10:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id k6tBOfG7k2ExEQAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 16 Nov 2021 14:10:57 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 0/4] x86/kvm: add boot parameters for max vcpu configs
Date:   Tue, 16 Nov 2021 15:10:50 +0100
Message-Id: <20211116141054.17800-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to be able to have a single kernel for supporting even huge
numbers of vcpus per guest some arrays should be sized dynamically.

The easiest way to do that is to add boot parameters for the maximum
number of vcpus and to calculate the maximum vcpu-id from that using
either the host topology or a topology hint via another boot parameter.

This patch series is doing that for x86. The same scheme can be easily
adapted to other architectures, but I don't want to do that in the
first iteration.

I've tested the series not to break normal guest operation and the new
parameters to be effective on x86.

This series is based on Marc Zyngier's xarray series:
https://lore.kernel.org/kvm/20211105192101.3862492-1-maz@kernel.org/

Changes in V2:
- removed old patch 1, as already applied
- patch 1 (old patch 2) only for reference, as the patch is already in
  the kvm tree
- switch patch 2 (old patch 3) to calculate vcpu-id
- added patch 4

Changes in V3:
- removed V2 patches 1 and 4, as already applied
- removed V2 patch 5, as replaced by Marc Zyngier's xarray series
- removed hyperv handling from patch 2
- new patch 3 handling hyperv specifics
- comments addressed

Juergen Gross (4):
  x86/kvm: add boot parameter for adding vcpu-id bits
  x86/kvm: introduce a per cpu vcpu mask
  x86/kvm: add max number of vcpus for hyperv emulation
  x86/kvm: add boot parameter for setting max number of vcpus per guest

 .../admin-guide/kernel-parameters.txt         | 25 +++++++++
 arch/x86/include/asm/kvm_host.h               | 29 +++++-----
 arch/x86/kvm/hyperv.c                         | 15 +++---
 arch/x86/kvm/ioapic.c                         | 20 ++++++-
 arch/x86/kvm/ioapic.h                         |  4 +-
 arch/x86/kvm/irq_comm.c                       |  9 +++-
 arch/x86/kvm/x86.c                            | 54 ++++++++++++++++++-
 7 files changed, 128 insertions(+), 28 deletions(-)

-- 
2.26.2

