Return-Path: <kvm+bounces-56834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD559B4437F
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F6815C14F7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 16:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB64831354F;
	Thu,  4 Sep 2025 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="PvrH1zkq"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A3E311963;
	Thu,  4 Sep 2025 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.178.132.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757004224; cv=none; b=QXQY8FhvSmCo+k+InM9VlK3cLleXMZDiqKydzYeBCfb+ZsfVCtEeHfmQORE8tk8sbHCqqdQLoe89cHK9PaUUritDnsxyFpAGVi1uvV4RJmJLZa4SoKLltlWm6M5pieZuTckctq+Lw8ZGYxff3ZzOYKiE+Kv5pcW1HVgBVo45hXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757004224; c=relaxed/simple;
	bh=SJEax+sJCd7KjF37QH115LhRNddCeH4qrcOU8RdH30s=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OXmh+y6ek/h8RpWPsdWtWHHA89El/CgiGgfbVkm7PkE4Ccqz+4jtN86FDDm61rXmOVtLhHTM7iR6u2vnd/usIN5N46OSD66vOLkdW00SaZP4+inKZ3936gaE52dpmhKVSSoc3iUn+zPMZCWpB5UF0zDQVDmznCi73swJQStFOiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=PvrH1zkq; arc=none smtp.client-ip=63.178.132.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1757004222; x=1788540222;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=P42vo7zyNRCoT+Y0yuyfOsLQrHZEK242rnGHx+iqWJc=;
  b=PvrH1zkqcQXXbNBRPk1XcA3ZtqFodKAfXrzrVx0Mkz9Nbqtip3YFa3QN
   PTm98z5lZ7CWsuoXc9n3bbDChOPTCNLMxZCiSyeJKUpnyVprVCrItpI6p
   tYY2BSzp/K9vt4sLkjFXKPdSSQ+RNEPWNvY0jRaqcG/Q6deg5/BhrSJRR
   19gIb990i30YFoMBUnU44Esf7GfC6uecY+A1CuN20wTd/DXsLOWSC/K6r
   AdkxAYoerlPL1SSwYyywCFoweeO0qnKTSbGg6n07hUH6Yuk+A1lZgu3IN
   jqQYWtb3Amia/iY9J4ZDxQUgUAo9nrTX3KM031M7997GxCDcWQZdJ1Emt
   w==;
X-CSE-ConnectionGUID: VbhW2i58QR+l4y4akwjfNw==
X-CSE-MsgGUID: d9TOW0SWShiX/ph1efFPpg==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1553836"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 16:43:32 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:12184]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.219:2525] with esmtp (Farcaster)
 id 2a1e5134-b6e7-4d6e-a935-760d82fd56e1; Thu, 4 Sep 2025 16:43:32 +0000 (UTC)
X-Farcaster-Flow-ID: 2a1e5134-b6e7-4d6e-a935-760d82fd56e1
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 4 Sep 2025 16:43:31 +0000
Received: from [192.168.20.69] (10.106.83.23) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 4 Sep 2025
 16:43:30 +0000
Message-ID: <de7da4d8-0e9d-46f2-88ec-cfd5dc14421c@amazon.com>
Date: Thu, 4 Sep 2025 17:43:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v3 00/15] KVM: Introduce KVM Userfault
To: James Houghton <jthoughton@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Oliver Upton
	<oliver.upton@linux.dev>
CC: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Anish Moorthy <amoorthy@google.com>, Peter Gonda
	<pgonda@google.com>, Peter Xu <peterx@redhat.com>, David Matlack
	<dmatlack@google.com>, <wei.w.wang@intel.com>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
References: <20250618042424.330664-1-jthoughton@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D015EUB004.ant.amazon.com (10.252.51.13) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 18/06/2025 05:24, James Houghton wrote:
> Hi Sean, Paolo, Oliver, + others,
> 
> Here is a v3 of KVM Userfault. Thanks for all the feedback on the v2,
> Sean. I realize it has been 6 months since the v2; I hope that isn't an
> issue.
> 
> I am working on the QEMU side of the changes as I get time. Let me know
> if it's important for me to send those patches out for this series to be
> merged.

Hi Sean and others,

Are there any blockers for merging this series?  We would like to use 
the functionality in Firecracker for restoring guest_memfd-backed VMs 
from snapshots via UFFD [1].  [2] is a Firecracker feature branch that 
builds on top of KVM userfault, along with direct map removal [3], write 
syscall [4] and UFFD support [5] in guest_memfd (currently in discussion 
with MM at [6]) series.

Thanks,
Nikita

[1]: 
https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/handling-page-faults-on-snapshot-resume.md
[2]: 
https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3]: https://lore.kernel.org/kvm/20250828093902.2719-1-roypat@amazon.co.uk
[4]: https://lore.kernel.org/kvm/20250902111951.58315-1-kalyazin@amazon.com
[5]: https://lore.kernel.org/kvm/20250404154352.23078-1-kalyazin@amazon.com
[6]: 
https://lore.kernel.org/linux-mm/20250627154655.2085903-1-peterx@redhat.com

> Be aware that this series will have non-trivial conflicts with Fuad's
> user mapping support for guest_memfd series[1]. For example, for the
> arm64 change he is making, the newly introduced gmem_abort() would need
> to be enlightened to handle KVM Userfault exits.
> 
> Changelog:
> v2[2]->v3:
> - Pull in Sean's changes to genericize struct kvm_page_fault and use it
>    for arm64. Many of these patches now have Sean's SoB.
> - Pull in Sean's small rename and squashing of the main patches.
> - Add kvm_arch_userfault_enabled() in place of calling
>    kvm_arch_flush_shadow_memslot() directly from generic code.
> - Pull in Xin Li's documentation section number fix for
>    KVM_CAP_ARM_WRITABLE_IMP_ID_REGS[3].
> v1[4]->v2:
> - For arm64, no longer zap stage 2 when disabling KVM_MEM_USERFAULT
>    (thanks Oliver).
> - Fix the userfault_bitmap validation and casts (thanks kernel test
>    robot).
> - Fix _Atomic cast for the userfault bitmap in the selftest (thanks
>    kernel test robot).
> - Pick up Reviewed-by on doc changes (thanks Bagas).
> 
> Below is the cover letter from v1, mostly unchanged:
> 
> Please see the RFC[5] for the problem description. In summary,
> guest_memfd VMs have no mechanism for doing post-copy live migration.
> KVM Userfault provides such a mechanism.
> 
> There is a second problem that KVM Userfault solves: userfaultfd-based
> post-copy doesn't scale very well. KVM Userfault when used with
> userfaultfd can scale much better in the common case that most post-copy
> demand fetches are a result of vCPU access violations. This is a
> continuation of the solution Anish was working on[6]. This aspect of
> KVM Userfault is important for userfaultfd-based live migration when
> scaling up to hundreds of vCPUs with ~30us network latency for a
> PAGE_SIZE demand-fetch.
> 
> The implementation in this series is version than the RFC[5]. It adds...
>   1. a new memslot flag is added: KVM_MEM_USERFAULT,
>   2. a new parameter, userfault_bitmap, into struct kvm_memory_slot,
>   3. a new KVM_RUN exit reason: KVM_MEMORY_EXIT_FLAG_USERFAULT,
>   4. a new KVM capability KVM_CAP_USERFAULT.
> 
> KVM Userfault does not attempt to catch KVM's own accesses to guest
> memory. That is left up to userfaultfd.
> 
> When enabling KVM_MEM_USERFAULT for a memslot, the second-stage mappings
> are zapped, and new faults will check `userfault_bitmap` to see if the
> fault should exit to userspace.
> 
> When KVM_MEM_USERFAULT is enabled, only PAGE_SIZE mappings are
> permitted.
> 
> When disabling KVM_MEM_USERFAULT, huge mappings will be reconstructed
> consistent with dirty log disabling. So on x86, huge mappings will be
> reconstructed, but on arm64, they won't be.
> 
> KVM Userfault is not compatible with async page faults. Nikita has
> proposed a new implementation of async page faults that is more
> userspace-driven that *is* compatible with KVM Userfault[7].
> 
> See v1 for more performance details[4]. They are unchanged in this
> version.
> 
> This series is based on the latest kvm-x86/next.
> 
> [1]: https://lore.kernel.org/kvm/20250611133330.1514028-1-tabba@google.com/
> [2]: https://lore.kernel.org/kvm/20250109204929.1106563-1-jthoughton@google.com/
> [3]: https://lore.kernel.org/kvm/20250414165146.2279450-1-xin@zytor.com/
> [4]: https://lore.kernel.org/kvm/20241204191349.1730936-1-jthoughton@google.com/
> [5]: https://lore.kernel.org/kvm/20240710234222.2333120-1-jthoughton@google.com/
> [6]: https://lore.kernel.org/all/20240215235405.368539-1-amoorthy@google.com/
> [7]: https://lore.kernel.org/kvm/20241118123948.4796-1-kalyazin@amazon.com/#t
> 
> James Houghton (11):
>    KVM: Add common infrastructure for KVM Userfaults
>    KVM: x86: Add support for KVM userfault exits
>    KVM: arm64: Add support for KVM userfault exits
>    KVM: Enable and advertise support for KVM userfault exits
>    KVM: selftests: Fix vm_mem_region_set_flags docstring
>    KVM: selftests: Fix prefault_mem logic
>    KVM: selftests: Add va_start/end into uffd_desc
>    KVM: selftests: Add KVM Userfault mode to demand_paging_test
>    KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
>    KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd toggle tests
>    KVM: Documentation: Add KVM_CAP_USERFAULT and KVM_MEM_USERFAULT
>      details
> 
> Sean Christopherson (3):
>    KVM: x86/mmu: Move "struct kvm_page_fault" definition to
>      asm/kvm_host.h
>    KVM: arm64: Add "struct kvm_page_fault" to gather common fault
>      variables
>    KVM: arm64: x86: Require "struct kvm_page_fault" for memory fault
>      exits
> 
> Xin Li (Intel) (1):
>    KVM: Documentation: Fix section number for
>      KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
> 
>   Documentation/virt/kvm/api.rst                |  35 ++++-
>   arch/arm64/include/asm/kvm_host.h             |   9 ++
>   arch/arm64/kvm/Kconfig                        |   1 +
>   arch/arm64/kvm/mmu.c                          |  48 +++---
>   arch/x86/include/asm/kvm_host.h               |  68 +++++++-
>   arch/x86/kvm/Kconfig                          |   1 +
>   arch/x86/kvm/mmu/mmu.c                        |  13 +-
>   arch/x86/kvm/mmu/mmu_internal.h               |  77 +---------
>   arch/x86/kvm/x86.c                            |  27 ++--
>   include/linux/kvm_host.h                      |  49 +++++-
>   include/uapi/linux/kvm.h                      |   6 +-
>   .../selftests/kvm/demand_paging_test.c        | 145 ++++++++++++++++--
>   .../testing/selftests/kvm/include/kvm_util.h  |   5 +
>   .../selftests/kvm/include/userfaultfd_util.h  |   2 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  42 ++++-
>   .../selftests/kvm/lib/userfaultfd_util.c      |   2 +
>   .../selftests/kvm/set_memory_region_test.c    |  33 ++++
>   virt/kvm/Kconfig                              |   3 +
>   virt/kvm/kvm_main.c                           |  57 ++++++-
>   19 files changed, 489 insertions(+), 134 deletions(-)
> 
> 
> base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
> --
> 2.50.0.rc2.692.g299adb8693-goog
> 


