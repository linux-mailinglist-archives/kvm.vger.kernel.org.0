Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6731F62D6
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 09:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgFKHmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 03:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgFKHmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 03:42:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293AD2072F;
        Thu, 11 Jun 2020 07:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591861357;
        bh=gKJMd5utUWukaitgLZGRza7ui70C0kpqMr9sxdjD8/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KFqoZB/lJU4/f4epVDrDHxmP+O9tSVmWZ9vwm72Y2fn4eZGAMXQWihXl2JAI4FS72
         UqbCTonXJ0Ycg0aPDpTrq2bK/znskSWa72A+cKKnHvHHm+0q+A2Ze1gBPrDX5T95DW
         zyqKCImV0KfIgaDkJAgPptVndfnb+CFq3aZUfJQ8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjHr9-0021J7-Lk; Thu, 11 Jun 2020 08:42:35 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 11 Jun 2020 08:42:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 14/21] KVM: Move x86's version of struct
 kvm_mmu_memory_cache to common code
In-Reply-To: <20200605213853.14959-15-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-15-sean.j.christopherson@intel.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <f57fc7237ffba4f22042b42efb18d2e4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org, pfeiner@google.com, pshier@google.com, junaids@google.com, bgardon@google.com, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2020-06-05 22:38, Sean Christopherson wrote:
> Move x86's 'struct kvm_mmu_memory_cache' to common code in anticipation
> of moving the entire x86 implementation code to common KVM and reusing
> it for arm64 and MIPS.  Add a new architecture specific asm/kvm_types.h
> to control the existence and parameters of the struct.  The new header
> is needed to avoid a chicken-and-egg problem with asm/kvm_host.h as all
> architectures define instances of the struct in their vCPU structs.
> 
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/arm64/include/asm/kvm_types.h   |  6 ++++++
>  arch/mips/include/asm/kvm_types.h    |  5 +++++
>  arch/powerpc/include/asm/kvm_types.h |  5 +++++
>  arch/s390/include/asm/kvm_types.h    |  5 +++++
>  arch/x86/include/asm/kvm_host.h      | 13 -------------
>  arch/x86/include/asm/kvm_types.h     |  7 +++++++
>  include/linux/kvm_types.h            | 19 +++++++++++++++++++
>  7 files changed, 47 insertions(+), 13 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_types.h
>  create mode 100644 arch/mips/include/asm/kvm_types.h
>  create mode 100644 arch/powerpc/include/asm/kvm_types.h
>  create mode 100644 arch/s390/include/asm/kvm_types.h
>  create mode 100644 arch/x86/include/asm/kvm_types.h
> 
> diff --git a/arch/arm64/include/asm/kvm_types.h
> b/arch/arm64/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..d0987007d581
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_types.h
> @@ -0,0 +1,6 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM64_KVM_TYPES_H
> +#define _ASM_ARM64_KVM_TYPES_H
> +
> +#endif /* _ASM_ARM64_KVM_TYPES_H */
> +
> diff --git a/arch/mips/include/asm/kvm_types.h
> b/arch/mips/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..5efeb32a5926
> --- /dev/null
> +++ b/arch/mips/include/asm/kvm_types.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_MIPS_KVM_TYPES_H
> +#define _ASM_MIPS_KVM_TYPES_H
> +
> +#endif /* _ASM_MIPS_KVM_TYPES_H */
> diff --git a/arch/powerpc/include/asm/kvm_types.h
> b/arch/powerpc/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..f627eceaa314
> --- /dev/null
> +++ b/arch/powerpc/include/asm/kvm_types.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_KVM_TYPES_H
> +#define _ASM_POWERPC_KVM_TYPES_H
> +
> +#endif /* _ASM_POWERPC_KVM_TYPES_H */
> diff --git a/arch/s390/include/asm/kvm_types.h
> b/arch/s390/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..b66a81f8a354
> --- /dev/null
> +++ b/arch/s390/include/asm/kvm_types.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_S390_KVM_TYPES_H
> +#define _ASM_S390_KVM_TYPES_H
> +
> +#endif /* _ASM_S390_KVM_TYPES_H */

Instead of carrying an empty include file for at least two of the 
architectures
(s390 and Power), how about having it in asm-generic, and updating
arch/$ARCH/include/asm/Kbuild to point to the generic one?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
