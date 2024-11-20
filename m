Return-Path: <kvm+bounces-32148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0749F9D3A4C
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 13:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1A05285A18
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 12:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42DCE1A0BED;
	Wed, 20 Nov 2024 12:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="o/ganW5D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661B419AA72;
	Wed, 20 Nov 2024 12:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732104556; cv=none; b=qskq3bz5U7mpMYd3UNBVX1pXWUJsTJjkMFxMZV7x3ihZXY1jupCsipuUs3bakqLDp2QL4bBRlD8Y+2ytXFF6VYRhpRlHIRQRh1uYDhupZE7OaKNhwmaUNRF3Ek775kmALvFXclo1ebG20KFIFMdnPafpNMXgEFiAZN3I/Z0TAPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732104556; c=relaxed/simple;
	bh=uxYi+9MYgq+j31VFzROUqasPd1biXohFMxIY5WcgAwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=L0JHeqNw7QPJPd6Gmv5Mzuzyi2l6sUkvNXG9A8rUnjZh6WjFVFSLSLCTw6uzKa3A4rmE42LyX3TaVgfr2kU7+WMvYpx8p9miQghZBHt3SiK0AehFL6/dIDsNvaPKTVN+uOzDZGHACxYKnavdqwu10tknqaSzPZtM7ggIzcm357o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=o/ganW5D; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732104554; x=1763640554;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=Dd57kkU9EzxVIZThbOiKXUHsIvhkPWTCNKEy2o4B7xM=;
  b=o/ganW5Dc4q8z8DGGGy5Nxc5bj/ybDl8+V8w8y22PeqAiPqykRMil8g8
   T3lypfA/FyiTEm/ySLwLXZR6j9xLB4q3tke6tUb2ePXQ98chZ9OGFDHpw
   Utg2cdrqOWMfc5stP9PU0fp5OO4aBAueqoT0G1/TFaH8gF+/9cPswSbBn
   E=;
X-IronPort-AV: E=Sophos;i="6.12,169,1728950400"; 
   d="scan'208";a="675113447"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 12:09:10 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:19497]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.206:2525] with esmtp (Farcaster)
 id afaffc34-8f44-4106-9e35-671ee5b1f179; Wed, 20 Nov 2024 12:09:08 +0000 (UTC)
X-Farcaster-Flow-ID: afaffc34-8f44-4106-9e35-671ee5b1f179
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 20 Nov 2024 12:09:07 +0000
Received: from [192.168.4.32] (10.106.83.27) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Wed, 20 Nov 2024
 12:09:06 +0000
Message-ID: <08aeaf6e-dc89-413a-86a6-b9772c9b2faf@amazon.com>
Date: Wed, 20 Nov 2024 12:09:05 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/4] KVM: ioctl for populating guest_memfd
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>, "David
 Hildenbrand" <david@redhat.com>, Sean Christopherson <seanjc@google.com>,
	<linux-mm@kvack.org>
References: <20241024095429.54052-1-kalyazin@amazon.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJj5ki9BQkDwmcAAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOR1wD/UTcn4GbLC39QIwJuWXW0DeLoikxFBYkbhYyZ5CbtrtAA/2/rnR/zKZmyXqJ6
 ULlSE8eWA3ywAIOH8jIETF2fCaUCzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmPmSL0FCQPCZwACGwwACgkQr5LKIKmaZPNCxAEAxwnrmyqSC63nf6hoCFCfJYQapghC
 abLV0+PWemntlwEA/RYx8qCWD6zOEn4eYhQAucEwtg6h1PBbeGK94khVMooF
In-Reply-To: <20241024095429.54052-1-kalyazin@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D008EUC002.ant.amazon.com (10.252.51.146) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 24/10/2024 10:54, Nikita Kalyazin wrote:
> [2] proposes an alternative to
> UserfaultFD for intercepting stage-2 faults, while this series
> conceptually compliments it with the ability to populate guest memory
> backed by guest_memfd for `KVM_X86_SW_PROTECTED_VM` VMs.

+David
+Sean
+mm

While measuring memory population performance of guest_memfd using this 
series, I noticed that guest_memfd population takes longer than my 
baseline, which is filling anonymous private memory via UFFDIO_COPY.

I am using x86_64 for my measurements and 3 GiB memory region:
  - anon/private UFFDIO_COPY:  940 ms
  - guest_memfd:              1371 ms (+46%)

It turns out that the effect is observable not only for guest_memfd, but 
also for any type of shared memory, eg memfd or anonymous memory mapped 
as shared.

Below are measurements of a plain mmap(MAP_POPULATE) operation:

mmap(NULL, 3ll * (1 << 30), PROT_READ | PROT_WRITE, MAP_PRIVATE | 
MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
  vs
mmap(NULL, 3ll * (1 << 30), PROT_READ | PROT_WRITE, MAP_SHARED | 
MAP_ANONYMOUS | MAP_POPULATE, -1, 0);

Results:
  - MAP_PRIVATE: 968 ms
  - MAP_SHARED: 1646 ms

I am seeing this effect on a range of kernels. The oldest I used was 
5.10, the newest is the current kvm-next (for-linus-2590-gd96c77bd4eeb).

When profiling with perf, I observe the following hottest operations 
(kvm-next). Attaching full distributions at the end of the email.

MAP_PRIVATE:
- 19.72% clear_page_erms, rep stos %al,%es:(%rdi)

MAP_SHARED:
- 43.94% shmem_get_folio_gfp, lock orb $0x8,(%rdi), which is atomic 
setting of the PG_uptodate bit
- 10.98% clear_page_erms, rep stos %al,%es:(%rdi)

Note that MAP_PRIVATE/do_anonymous_page calls __folio_mark_uptodate that 
sets the PG_uptodate bit regularly.
, while MAP_SHARED/shmem_get_folio_gfp calls folio_mark_uptodate that 
sets the PG_uptodate bit atomically.

While this logic is intuitive, its performance effect is more 
significant that I would expect.

The questions are:
  - Is this a well-known behaviour?
  - Is there a way to mitigate that, ie make shared memory (including 
guest_memfd) population faster/comparable to private memory?

Nikita


Appendix: full call tree obtained via perf

MAP_RPIVATE:

       - 87.97% __mmap
            entry_SYSCALL_64_after_hwframe
            do_syscall_64
            vm_mmap_pgoff
            __mm_populate
            populate_vma_page_range
          - __get_user_pages
             - 77.94% handle_mm_fault
                - 76.90% __handle_mm_fault
                   - 72.70% do_anonymous_page
                      - 31.92% vma_alloc_folio_noprof
                         - 30.74% alloc_pages_mpol_noprof
                            - 29.60% __alloc_pages_noprof
                               - 28.40% get_page_from_freelist
                                    19.72% clear_page_erms
                                  - 3.00% __rmqueue_pcplist
                                       __mod_zone_page_state
                                    1.18% _raw_spin_trylock
                      - 20.03% __pte_offset_map_lock
                         - 15.96% _raw_spin_lock
                              1.50% preempt_count_add
                         - 2.27% __pte_offset_map
                              __rcu_read_lock
                      - 7.22% __folio_batch_add_and_move
                         - 4.68% folio_batch_move_lru
                            - 3.77% lru_add
                               + 0.95% __mod_zone_page_state
                                 0.86% __mod_node_page_state
                           0.84% folios_put_refs
                           0.55% check_preemption_disabled
                      - 2.85% folio_add_new_anon_rmap
                         - __folio_mod_stat
                              __mod_node_page_state
                   - 1.15% pte_offset_map_nolock
                        __pte_offset_map
             - 7.59% follow_page_pte
                - 4.56% __pte_offset_map_lock
                   - 2.27% _raw_spin_lock
                        preempt_count_add
                     1.13% __pte_offset_map
                  0.75% folio_mark_accessed

MAP_SHARED:

       - 77.89% __mmap
            entry_SYSCALL_64_after_hwframe
            do_syscall_64
            vm_mmap_pgoff
            __mm_populate
            populate_vma_page_range
          - __get_user_pages
             - 72.11% handle_mm_fault
                - 71.67% __handle_mm_fault
                   - 69.62% do_fault
                      - 44.61% __do_fault
                         - shmem_fault
                            - 43.94% shmem_get_folio_gfp
                               - 17.20% 
shmem_alloc_and_add_folio.constprop.0
                                  - 5.10% shmem_alloc_folio
                                     - 4.58% folio_alloc_mpol_noprof
                                        - alloc_pages_mpol_noprof
                                           - 4.00% __alloc_pages_noprof
                                              - 3.31% get_page_from_freelist
                                                   1.24% __rmqueue_pcplist
                                  - 5.07% shmem_add_to_page_cache
                                     - 1.44% __mod_node_page_state
                                          0.61% check_preemption_disabled
                                       0.78% xas_store
                                       0.74% xas_find_conflict
                                       0.66% _raw_spin_lock_irq
                                  - 3.96% __folio_batch_add_and_move
                                     - 2.41% folio_batch_move_lru
                                          1.88% lru_add
                                  - 1.56% shmem_inode_acct_blocks
                                     - 1.24% __dquot_alloc_space
                                        - 0.77% inode_add_bytes
                                             _raw_spin_lock
                                  - 0.77% shmem_recalc_inode
                                       _raw_spin_lock
                                 10.98% clear_page_erms
                               - 1.17% filemap_get_entry
                                    0.78% xas_load
                      - 20.26% filemap_map_pages
                         - 12.23% next_uptodate_folio
                            - 1.27% xas_find
                                 xas_load
                         - 1.16% __pte_offset_map_lock
                              0.59% _raw_spin_lock
                      - 3.48% finish_fault
                         - 1.28% set_pte_range
                              0.96% folio_add_file_rmap_ptes
                         - 0.91% __pte_offset_map_lock
                              0.54% _raw_spin_lock
                     0.57% pte_offset_map_nolock
             - 4.11% follow_page_pte
                - 2.36% __pte_offset_map_lock
                   - 1.32% _raw_spin_lock
                        preempt_count_add
                     0.54% __pte_offset_map

