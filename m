Return-Path: <kvm+bounces-1999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB477F007C
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 16:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F9D81C20969
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 15:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B99199A2;
	Sat, 18 Nov 2023 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYSJGYNB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CCCD57;
	Sat, 18 Nov 2023 07:51:09 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 3f1490d57ef6-daec4e4c5eeso2803482276.1;
        Sat, 18 Nov 2023 07:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700322668; x=1700927468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T8JQkwQPDN0/NjJdMvrO5YDf2Mt9RQuRmPZfqlcyPOc=;
        b=GYSJGYNBF2n5sW5UXqCkkhcF3eAK216KQH4YTBhWSPOZ93FAZaF+G0jrldUj74Poj/
         m8SWsPWSeK7V5vkY/5KsVt1gGmuMsFGhtqsn7RYa7tg/vQ8uU/+1/I5qP9WOld5QnP4Z
         sWqT2OTR2KlFcBoDQ1N2Bv2sWfvEeBEef+CJhZS0nhOswUQvck9ZhRz/GM5i/A1AD1o3
         0ny+/PSnoY8i+tvXzpqriUJg10hrCyZWPX3fMmcK0IVIYM5/o5ISoCJWfw3kuueja0Za
         HFezDhgGMyN+Rq72e86ybWeQbVRtoT6oyiPgJUlNcCYVnx4YEZzqYq9HO9s9YE85H57l
         tXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700322668; x=1700927468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T8JQkwQPDN0/NjJdMvrO5YDf2Mt9RQuRmPZfqlcyPOc=;
        b=RIC+48dT86rDKj/uBU3beXkCrFN+qo7wiuVQH+Yd190dIeNhJfPwD2eN9K1ROV4/mo
         WFLjLLfbm34Kn5RgrpUZfdNeQYLhQF7gtrRBH18rOByZhDd3o/y51k7J1Su7/43PwBor
         ZMfWkJAlnAWVhM3vUNFgC/0Ty2hMidEyx23d5uHgKDTknPPZWfZNGsdZmoVS969bmy7r
         Qd2AJNrcJ2KSzvcxSwhITLBK/bTEif8DhIUZh1RsmISFKIJyuHnfxh9FHI2Flh0NfcQd
         5zXIA5SLf7opnEshNmrCaxNiYjBdRdTIV22aJOoYelw9EqUVfk9iaR+ihnznRpDi8Ab9
         3jKg==
X-Gm-Message-State: AOJu0YxTAIFecY4pQYWOxJYGsl3VBUzhv/7CSCLwwuUbbXgSaNfRUKGn
	CKvsfXktUDtqxoCIzoHablVa58Ym9PXcAjAC
X-Google-Smtp-Source: AGHT+IFJx/lrMq78Aql9lHzoh+xOXvS0ldCsOe1bBN/nC+9100pFEpSDPw9twx0lzyc1pTk6s9pz2Q==
X-Received: by 2002:a25:5883:0:b0:da3:ab41:31f3 with SMTP id m125-20020a255883000000b00da3ab4131f3mr2199131ybb.8.1700322667764;
        Sat, 18 Nov 2023 07:51:07 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:48a9:bd4c:868d:dc97])
        by smtp.gmail.com with ESMTPSA id 195-20020a2502cc000000b00d7497467d36sm1001026ybc.45.2023.11.18.07.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 07:51:07 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christian Brauner <brauner@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Disseldorp <ddiss@suse.de>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jens Axboe <axboe@kernel.dk>,
	Jiri Pirko <jiri@resnulli.us>,
	Jiri Slaby <jirislaby@kernel.org>,
	Kalle Valo <kvalo@kernel.org>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Kees Cook <keescook@chromium.org>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Rich Felker <dalias@libc.org>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	GR-QLogic-Storage-Upstream@marvell.com,
	alsa-devel@alsa-project.org,
	ath10k@lists.infradead.org,
	dmaengine@vger.kernel.org,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-net-drivers@amd.com,
	linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	netdev@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Matthew Wilcox <willy@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
	Alexey Klimov <klimov.linux@gmail.com>
Subject: [PATCH 00/34] biops: add atomig find_bit() operations
Date: Sat, 18 Nov 2023 07:50:31 -0800
Message-Id: <20231118155105.25678-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helpers around test_and_{set,clear}_bit() that allow to search for
clear or set bits and flip them atomically.

The target patterns may look like this:

	for (idx = 0; idx < nbits; idx++)
		if (test_and_clear_bit(idx, bitmap))
			do_something(idx);

Or like this:

	do {
		bit = find_first_bit(bitmap, nbits);
		if (bit >= nbits)
			return nbits;
	} while (!test_and_clear_bit(bit, bitmap));
	return bit;

In both cases, the opencoded loop may be converted to a single function
or iterator call. Correspondingly:

	for_each_test_and_clear_bit(idx, bitmap, nbits)
		do_something(idx);

Or:
	return find_and_clear_bit(bitmap, nbits);

Obviously, the less routine code people have write themself, the less
probability to make a mistake. Patch #31 of this series fixes one such
error in perf/m1 codebase.

Those are not only handy helpers but also resolve a non-trivial
issue of using non-atomic find_bit() together with atomic
test_and_{set,clear)_bit().

The trick is that find_bit() implies that the bitmap is a regular
non-volatile piece of memory, and compiler is allowed to use such
optimization techniques like re-fetching memory instead of caching it.

For example, find_first_bit() is implemented like this:

      for (idx = 0; idx * BITS_PER_LONG < sz; idx++) {
              val = addr[idx];
              if (val) {
                      sz = min(idx * BITS_PER_LONG + __ffs(val), sz);
                      break;
              }
      }

On register-memory architectures, like x86, compiler may decide to
access memory twice - first time to compare against 0, and second time
to fetch its value to pass it to __ffs().

When running find_first_bit() on volatile memory, the memory may get
changed in-between, and for instance, it may lead to passing 0 to
__ffs(), which is undefined. This is a potentially dangerous call.

find_and_clear_bit() as a wrapper around test_and_clear_bit()
naturally treats underlying bitmap as a volatile memory and prevents
compiler from such optimizations.

Now that KCSAN is catching exactly this type of situations and warns on
undercover memory modifications. We can use it to reveal improper usage
of find_bit(), and convert it to atomic find_and_*_bit() as appropriate.

The 1st patch of the series adds the following atomic primitives:

	find_and_set_bit(addr, nbits);
	find_and_set_next_bit(addr, nbits, start);
	...

Here find_and_{set,clear} part refers to the corresponding
test_and_{set,clear}_bit function, and suffixes like _wrap or _lock
derive semantics from corresponding find() or test() functions.

For brevity, the naming omits the fact that we search for zero bit in
find_and_set, and correspondingly, search for set bit in find_and_clear
functions.

The patch also adds iterators with atomic semantics, like
for_each_test_and_set_bit(). Here, the naming rule is to simply prefix
corresponding atomic operation with 'for_each'.

This series is a result of discussion [1]. All find_bit() functions imply
exclusive access to the bitmaps. However, KCSAN reports quite a number
of warnings related to find_bit() API. Some of them are not pointing
to real bugs because in many situations people intentionally allow
concurrent bitmap operations.

If so, find_bit() can be annotated such that KCSAN will ignore it:

	bit = data_race(find_first_bit(bitmap, nbits));

This series addresses the other important case where people really need
atomic find ops. As the following patches show, the resulting code
looks safer and more verbose comparing to opencoded loops followed by
atomic bit flips.

In [1] Mirsad reported 2% slowdown in a single-thread search test when
switching find_bit() function to treat bitmaps as volatile arrays. On
the other hand, kernel robot in the same thread reported +3.7% to the
performance of will-it-scale.per_thread_ops test.

Assuming that our compilers are sane and generate better code against
properly annotated data, the above discrepancy doesn't look weird. When
running on non-volatile bitmaps, plain find_bit() outperforms atomic
find_and_bit(), and vice-versa.

So, all users of find_bit() API, where heavy concurrency is expected,
are encouraged to switch to atomic find_and_bit() as appropriate.

1st patch of this series adds atomic find_and_bit() API, and all the
following patches spread it over the kernel. They can be applied
separately from each other on per-subsystems basis, or I can pull them
in bitmap tree, as appropriate.

[1] https://lore.kernel.org/lkml/634f5fdf-e236-42cf-be8d-48a581c21660@alu.unizg.hr/T/#m3e7341eb3571753f3acf8fe166f3fb5b2c12e615 

Yury Norov (34):
  lib/find: add atomic find_bit() primitives
  lib/sbitmap; make __sbitmap_get_word() using find_and_set_bit()
  watch_queue: use atomic find_bit() in post_one_notification()
  sched: add cpumask_find_and_set() and use it in __mm_cid_get()
  mips: sgi-ip30: rework heart_alloc_int()
  sparc: fix opencoded find_and_set_bit() in alloc_msi()
  perf/arm: optimize opencoded atomic find_bit() API
  drivers/perf: optimize ali_drw_get_counter_idx() by using find_bit()
  dmaengine: idxd: optimize perfmon_assign_event()
  ath10k: optimize ath10k_snoc_napi_poll() by using find_bit()
  wifi: rtw88: optimize rtw_pci_tx_kick_off() by using find_bit()
  wifi: intel: use atomic find_bit() API where appropriate
  KVM: x86: hyper-v: optimize and cleanup kvm_hv_process_stimers()
  PCI: hv: switch hv_get_dom_num() to use atomic find_bit()
  scsi: use atomic find_bit() API where appropriate
  powerpc: use atomic find_bit() API where appropriate
  iommu: use atomic find_bit() API where appropriate
  media: radio-shark: use atomic find_bit() API where appropriate
  sfc: switch to using atomic find_bit() API where appropriate
  tty: nozomi: optimize interrupt_handler()
  usb: cdc-acm: optimize acm_softint()
  block: null_blk: fix opencoded find_and_set_bit() in get_tag()
  RDMA/rtrs: fix opencoded find_and_set_bit_lock() in
    __rtrs_get_permit()
  mISDN: optimize get_free_devid()
  media: em28xx: cx231xx: fix opencoded find_and_set_bit()
  ethernet: rocker: optimize ofdpa_port_internal_vlan_id_get()
  serial: sc12is7xx: optimize sc16is7xx_alloc_line()
  bluetooth: optimize cmtp_alloc_block_id()
  net: smc: fix opencoded find_and_set_bit() in
    smc_wr_tx_get_free_slot_index()
  ALSA: use atomic find_bit() functions where applicable
  drivers/perf: optimize m1_pmu_get_event_idx() by using find_bit() API
  m68k: rework get_mmu_context()
  microblaze: rework get_mmu_context()
  sh: rework ilsel_enable()

 arch/m68k/include/asm/mmu_context.h           |  11 +-
 arch/microblaze/include/asm/mmu_context_mm.h  |  11 +-
 arch/mips/sgi-ip30/ip30-irq.c                 |  12 +-
 arch/powerpc/mm/book3s32/mmu_context.c        |  10 +-
 arch/powerpc/platforms/pasemi/dma_lib.c       |  45 +--
 arch/powerpc/platforms/powernv/pci-sriov.c    |  12 +-
 arch/sh/boards/mach-x3proto/ilsel.c           |   4 +-
 arch/sparc/kernel/pci_msi.c                   |   9 +-
 arch/x86/kvm/hyperv.c                         |  39 ++-
 drivers/block/null_blk/main.c                 |  41 +--
 drivers/dma/idxd/perfmon.c                    |   8 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |  15 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.h         |  10 +-
 drivers/iommu/msm_iommu.c                     |  18 +-
 drivers/isdn/mISDN/core.c                     |   9 +-
 drivers/media/radio/radio-shark.c             |   5 +-
 drivers/media/radio/radio-shark2.c            |   5 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c     |  16 +-
 drivers/media/usb/em28xx/em28xx-cards.c       |  37 +--
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  11 +-
 drivers/net/ethernet/sfc/rx_common.c          |   4 +-
 drivers/net/ethernet/sfc/siena/rx_common.c    |   4 +-
 drivers/net/ethernet/sfc/siena/siena_sriov.c  |  14 +-
 drivers/net/wireless/ath/ath10k/snoc.c        |   9 +-
 .../net/wireless/intel/iwlegacy/4965-mac.c    |   7 +-
 drivers/net/wireless/intel/iwlegacy/common.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c   |  19 +-
 drivers/net/wireless/realtek/rtw88/pci.c      |   5 +-
 drivers/net/wireless/realtek/rtw89/pci.c      |   5 +-
 drivers/pci/controller/pci-hyperv.c           |   7 +-
 drivers/perf/alibaba_uncore_drw_pmu.c         |  10 +-
 drivers/perf/apple_m1_cpu_pmu.c               |   8 +-
 drivers/perf/arm-cci.c                        |  23 +-
 drivers/perf/arm-ccn.c                        |  10 +-
 drivers/perf/arm_dmc620_pmu.c                 |   9 +-
 drivers/perf/arm_pmuv3.c                      |   8 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c               |  21 +-
 drivers/scsi/qedi/qedi_main.c                 |   9 +-
 drivers/scsi/scsi_lib.c                       |   5 +-
 drivers/tty/nozomi.c                          |   5 +-
 drivers/tty/serial/sc16is7xx.c                |   8 +-
 drivers/usb/class/cdc-acm.c                   |   5 +-
 include/linux/cpumask.h                       |  12 +
 include/linux/find.h                          | 289 ++++++++++++++++++
 kernel/sched/sched.h                          |  52 +---
 kernel/watch_queue.c                          |   6 +-
 lib/find_bit.c                                |  85 ++++++
 lib/sbitmap.c                                 |  46 +--
 net/bluetooth/cmtp/core.c                     |  10 +-
 net/smc/smc_wr.c                              |  10 +-
 sound/pci/hda/hda_codec.c                     |   7 +-
 sound/usb/caiaq/audio.c                       |  13 +-
 53 files changed, 588 insertions(+), 481 deletions(-)

-- 
2.39.2


