Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5476610CFF3
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 00:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfK1XZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 18:25:35 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:51507 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfK1XZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 18:25:34 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47PDJq27m4z9sR2; Fri, 29 Nov 2019 10:25:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1574983531; bh=K3rUI3oKvNc9LFGK8LZbyA4UxPK1ZJoyUWkTY87H/ik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WyMBBKeJv/k/CHoDeakagEbM8YYsaz919gFs2XU5OSL0FYebH4r7KtDuVVajxaDRO
         yUyASs6jPL4YcliuQUGTaSgK3EvHVpZVkPmS6pVcjT779Ss0cGp9ZD+Lp9tbgwLcyT
         19+5fVSkZLHFKDPOUB2SXFEIy+JfjWCY/PolSluVbb69LK8j1tAuQU6S8wA8e6ZhSG
         lPg8aBeEX6kPw0bJPma410yHfo6f7NP/MMIWHlqs9h5tYNdAV4oW7a44eVCmnmgdZs
         OaBm+wmIdefUeNQAjDlctLGfvhpt7vi9nVdrH8x5vJOaUo0gEjHekYE3OODhwuyvQ6
         gcntLNyW3149w==
Date:   Fri, 29 Nov 2019 10:25:28 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [GIT PULL v2] Please pull my kvm-ppc-uvmem-5.5-2 tag
Message-ID: <20191128232528.GA12171@oak.ozlabs.ibm.com>
References: <20191126052455.GA2922@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126052455.GA2922@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Bharata has corrected the issue identified by Hugh Dickins, so please
do a pull from my kvm-ppc-uvmem-5.5-2 tag.

This adds code to manage the movement of pages for a secure KVM guest
between normal memory managed by the host kernel and secure memory
managed by the ultravisor, on Power systems with Protected Execution
Facility hardware and firmware.  Secure memory is not accessible to
the host kernel and is represented as device memory using the
ZONE_DEVICE facility.

Thanks,
Paul.

The following changes since commit 96710247298df52a4b8150a62a6fe87083093ff3:

  Merge tag 'kvm-ppc-next-5.5-2' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into HEAD (2019-11-25 11:29:05 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-uvmem-5.5-2

for you to fetch changes up to 013a53f2d25a9fa9b9e1f70f5baa3f56e3454052:

  powerpc: Ultravisor: Add PPC_UV config option (2019-11-28 17:02:40 +1100)

----------------------------------------------------------------
KVM: Add support for secure guests under the Protected Execution
Framework (PEF) Ultravisor on POWER.

This enables secure memory to be represented as device memory,
which provides a way for the host to keep track of which pages of a
secure guest have been moved into secure memory managed by the
ultravisor and are no longer accessible by the host, and manage
movement of pages between secure and normal memory.

----------------------------------------------------------------
Anshuman Khandual (1):
      powerpc: Ultravisor: Add PPC_UV config option

Bharata B Rao (6):
      mm: ksm: Export ksm_madvise()
      KVM: PPC: Book3S HV: Support for running secure guests
      KVM: PPC: Book3S HV: Shared pages support for secure guests
      KVM: PPC: Book3S HV: Radix changes for secure guest
      KVM: PPC: Book3S HV: Handle memory plug/unplug to secure VM
      KVM: PPC: Book3S HV: Support reset of secure guest

 Documentation/virt/kvm/api.txt              |  18 +
 arch/powerpc/Kconfig                        |  17 +
 arch/powerpc/include/asm/hvcall.h           |   9 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  74 +++
 arch/powerpc/include/asm/kvm_host.h         |   6 +
 arch/powerpc/include/asm/kvm_ppc.h          |   1 +
 arch/powerpc/include/asm/ultravisor-api.h   |   6 +
 arch/powerpc/include/asm/ultravisor.h       |  36 ++
 arch/powerpc/kvm/Makefile                   |   3 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c      |  25 +
 arch/powerpc/kvm/book3s_hv.c                | 143 +++++
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 785 ++++++++++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c                  |  12 +
 include/uapi/linux/kvm.h                    |   1 +
 mm/ksm.c                                    |   1 +
 15 files changed, 1137 insertions(+)
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_uvmem.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_uvmem.c
