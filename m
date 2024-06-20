Return-Path: <kvm+bounces-20150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 345F5910F95
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58BAF1C23C29
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850D21B5812;
	Thu, 20 Jun 2024 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PqyjojpX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00321B3F2F;
	Thu, 20 Jun 2024 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906230; cv=none; b=iP4ATLyF+W2KFA35NfSbFo7ThN1BM9AwuYMv6F7N+mgnYPfn0t6KMWVbjm4uqWSrBKrPJ6zy4+xejo5ySkqXxQC5XdurHQ9fAZWNPT3Q+26BHQYSGpN+sFUm6kGwngxyWq3ChP6mfLUEaRZ0MH7e7xlXWvPtPgckH1c+W80+A+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906230; c=relaxed/simple;
	bh=+v4jjUj1lwOTsz8Mxp1G6htBOFCIigsWgsHI5ysa1Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pWjLvqzN/KTRpyj3Xp3sqLFyRnP6GvzI4JJSQDuU0DJjHlLtSuDghSPM6JOVN1sAt4DL4R0dJkhDLexvU3p4Zk/LtWF/icNXQJPjXk1RnPrzUwFduKgp8QTFauVl7gPEh+4YlqCFXuwS7FKVnT6gBm8Mt/ehGi/cj184J1ZWS0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PqyjojpX; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7062c11d0d1so1107834b3a.1;
        Thu, 20 Jun 2024 10:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718906228; x=1719511028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W47tS6B8wqIVT2qpvRqiOMMzdBB5xZ547KnoaR9dSwQ=;
        b=PqyjojpX1b4mgz2H6+lYPRp07fFU2sCPoV03VK1toFN3hNvHH0OZ29cw4r4EYltvsT
         d/NZHXJfPT0+PGADyQHuIcju+T05jil/ldHZIoA5MXkbAMyDdY3AnF/Qc36Dt0hs+Fiu
         vE6PteNhgGh+xKLl6fhgraTms7BgS30RwpmWfG5XQ/+NYkxj+gjSMSxBNDP0Ca7Se3Wa
         GRfCJQ/D6K3hY6bucltqdTX5ZkKVpwQ9J5tK6atcCQtWl9Al6y1/dwor7tLSrLGIUNy4
         eTdoU95nb1v1wkc+naz0Zap3noT6UR2X0DpdZnpDALP4d9fLE7o58WfSkRhd50za2Unk
         PGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906228; x=1719511028;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W47tS6B8wqIVT2qpvRqiOMMzdBB5xZ547KnoaR9dSwQ=;
        b=xOm83k1b3T2P7061m/GC8EoL8iC9N3yIRgp915MVoWjtIwhudItffPScrNCNljR5k9
         uca7c+oKtfDfIZ2uBkrTi/fUf8EDnv3HPZB9kE5PXnSlueghLclJ3uRyMttHKc9/9J6w
         K4SNM9VwnD19ZDc5+dk1DsrUmtRbQGUD2hQGb0hYR+vv3kzS3E6Ca2zGUQ2p++Xecfw2
         UBB6dc84AeS12CbX27jetAsiultuhGOv6NjLuOcuu75uXudUsKmII7vI7cemDgYJnCBO
         YVjCN53nI2G1cKzobX5/iVn4eByIUsqUNbivcwLlGfqSRTwAbiqC+ZJthOw/YZb1BznV
         Du6w==
X-Forwarded-Encrypted: i=1; AJvYcCUmPEpinUDxQ/e7osRM5IgmXW0CNXEZ2CJmzXzCkmMwKmBQnaMbWaDPpnohwC73rTeKCBatyIrWpX9KRlR8ywVf4sFqMjy9aixvy/BTguu2BfuqNx0v/KMakGKhE42hCj57XCpXvC/Oe92xe75+9u+YlEUdshVYNrYYPlplyNUUOVHIEBTUz2E4o91gP/EQ4gScQN5VBK/Dp6RcZ9N/ZxyyOeWZ4l8yGaKEzkyALLvmZaRtmuwm3pnk+iovfNtouZxmcmR9E4ZASWWB/YH27rZZwRdGGLgBtWib327scpTEx/nh8svNY8w+qP471Zw9CIFJrKIwMLZtvWWSDyQskWu6cx3qMqMitkA9uV21RXHzlGLTMlDGXuWcvmuOrL49dFBVu/PUplXttjLYawjSPloNiLEv9yZIVB167y+bHK5YGBsf5Mgcg/VxPOgdoiy3iZThHn4/49/yMxlwcx75qV+4F6N4JhGd/v7iBrtX3hiWaX805W6KpgLh1yvCIoRAkmGfL4zYccwXYTlzrx22fMDGhzPRLnhIECX/gVpMuGRQ1tXj3XlUrC/78Bue+aGQBkYJapRiHrQRZRl9m4W3YMi+sHp32dm3WytFndm+BzMNyFBWob3tku2ElOulzjQw+XZsgeDUlLbJ2KbWxTsWbGfjNq5BqM5eolT8uTqSrnPi7hLTctNoEfUQYBGTHYZO48CJGVOn82gV8NcJgweO2bIasUbiKvCmTmpeg0pT64N01358IJNrWRTDm3truR0VXfJ5M6hYgA==
X-Gm-Message-State: AOJu0YyrGxD4iiAqrh4f6mHA/PYhBsRMQALVJ44xPWjvtc/Me1PTxzj+
	TQr8QREdTH92HpO3yjciemxhwK7dUsjgO5tn7d4WfvEnnI4AB3M2Wy8Db1lzsC0=
X-Google-Smtp-Source: AGHT+IETPnhQIIAFAn3PVCfwnEc7SkEbk6ro/qDz0Ch8QyPc2IoUZATwJ2GjFRkYml1JLqHQ4RqduQ==
X-Received: by 2002:a05:6a00:1712:b0:704:12fc:7b30 with SMTP id d2e1a72fcca58-70629c565e1mr5514020b3a.17.1718906227709;
        Thu, 20 Jun 2024 10:57:07 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb6b11bsm12644924b3a.154.2024.06.20.10.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 10:57:07 -0700 (PDT)
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
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v4 00/40] lib/find: add atomic find_bit() primitives
Date: Thu, 20 Jun 2024 10:56:23 -0700
Message-ID: <20240620175703.605111-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

--- 

This v4 moves new API to separate headers, as adding stuff to find.h
concerns people, particularly Linus. It also adds few more conversions
alongside other cosmetic changes. See full changelog below.

---

Add helpers around test_and_{set,clear}_bit() to allow searching for
clear or set bits and flipping them atomically.

Using atomic search primitives allows to implement lockless bitmap
handling where only individual bits are touched by concurrent processes,
and where people now have to protect their bitmaps to search for a free
or set bit due to the lack of atomic searching routines.

The typical lock-protected bit allocation may look like this:

	unsigned long alloc_bit()
	{
		unsigned long bit;

		spin_lock(bitmap_lock);
		bit = find_first_zero_bit(bitmap, nbits);
		if (bit < nbits)
			__set_bit(bit, bitmap);
		spin_unlock(bitmap_lock);

		return bit;
	}

	void free_bit(unsigned long bit)
	{
		spin_lock(bitmap_lock);
		__clear_bit(bit, bitmap);
		spin_unlock(bitmap_lock);
	}

Now with atomic find_and_set_bit(), the above can be implemented
lockless, directly by using it and atomic clear_bit().

Patches 36-40 do this in few places in the kernel where the
transition is clear. There is likely more candidates for
refactoring.

The other important case is when people opencode atomic search
or atomic traverse on the maps with the patterns looking like:

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

Obviously, the less routine code people have to write themself, the
less probability to make a mistake. The patch #33 fixes one such
mistake.

The new API is not only a handy helpers - it also resolves a non-trivial
issue of using non-atomic find_bit() together with atomic
test_and_{set,clear)_bit().

The trick is that find_bit() implies that the bitmap is a regular
non-volatile piece of memory, and compiler is allowed to use such
optimization techniques like re-fetching memory instead of caching it.

For example, find_first_bit() is implemented like:

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
__ffs(), which is an undefined behaviour. This is a potentially
dangerous call.

find_and_clear_bit() as a wrapper around test_and_clear_bit()
naturally treats underlying bitmap as a volatile memory and prevents
compiler from such optimizations.

Now that KCSAN is catching exactly this type of situations and warns on
undercover memory modifications. We can use it to reveal improper usage
of find_bit(), and convert it to atomic find_and_*_bit() as appropriate.

In some cases concurrent operations with plain find_bit() are acceptable.
For example:

 - two threads running find_*_bit(): safe wrt ffs(0) and returns correct
   value, because underlying bitmap is unchanged;
 - find_next_bit() in parallel with set or clear_bit(), when modifying
   a bit prior to the start bit to search: safe and correct;
 - find_first_bit() in parallel with set_bit(): safe, but may return wrong
   bit number;
 - find_first_zero_bit() in parallel with clear_bit(): same as above.

In last 2 cases find_bit() may not return a correct bit number, but
it may be OK if caller requires any (not exactly the first) set or clear
bit, correspondingly.

In such cases, KCSAN may be safely silenced with data_race(). But in most
cases where KCSAN detects concurrency we should carefully review the code
and likely protect critical sections or switch to atomic find_and_bit(),
as appropriate.

This patch adds the following atomic primitives:

	find_and_set_bit(addr, nbits);
	find_and_set_next_bit(addr, nbits, start);
	...

Here find_and_{set,clear} part refers to the corresponding
test_and_{set,clear}_bit function. Suffixes like _wrap or _lock
derive their semantics from corresponding find() or test() functions.

For brevity, the naming omits the fact that we search for zero bit in
find_and_set, and correspondingly search for set bit in find_and_clear
functions.

The patch also adds iterators with atomic semantics, like
for_each_test_and_set_bit(). Here, the naming rule is to simply prefix
corresponding atomic operation with 'for_each'.

This series is not aimed on performance, but some performance
implications are considered.

In [1] Jan reported 2% slowdown in a single-thread search test when
switching find_bit() function to treat bitmaps as volatile arrays. On
the other hand, kernel robot in the same thread reported +3.7% to the
performance of will-it-scale.per_thread_ops test.

Assuming that our compilers are sane and generate better code against
properly annotated data, the above discrepancy doesn't look weird. When
running on non-volatile bitmaps, plain find_bit() outperforms atomic
find_and_bit(), and vice-versa.

So, all users of find_bit() API, where heavy concurrency is expected,
are encouraged to switch to atomic find_and_bit() as appropriate.

The 1st patch of this series adds atomic find_and_bit() API, 2nd adds
a basic test for new API, and all the following patches spread it over
the kernel.

[1] https://lore.kernel.org/lkml/634f5fdf-e236-42cf-be8d-48a581c21660@alu.unizg.hr/T/#m3e7341eb3571753f3acf8fe166f3fb5b2c12e615

---
v1: https://lore.kernel.org/netdev/20231118155105.25678-29-yury.norov@gmail.com/T/
v2: https://lore.kernel.org/all/20231204185101.ddmkvsr2xxsmoh2u@quack3/T/
v3: https://lore.kernel.org/linux-pci/ZX4bIisLzpW8c4WM@yury-ThinkPad/T/
v4:
 - drop patch v3-24: not needed after null_blk refactoring;
 - add patch 34: "MIPS: sgi-ip27: optimize alloc_level()";
 - add patch 35: "uprobes: optimize xol_take_insn_slot()";
 - add patches 36-40: get rid of locking scheme around bitmaps;
 - move new API to separate headers, to not bloat bitmap.h @ Linus;
 - patch #1: adjust comments to allow returning >= @size;
 - rebase the series on top of current master.

Yury Norov (40):
  lib/find: add atomic find_bit() primitives
  lib/find: add test for atomic find_bit() ops
  lib/sbitmap; optimize __sbitmap_get_word() by using find_and_set_bit()
  watch_queue: optimize post_one_notification() by using
    find_and_clear_bit()
  sched: add cpumask_find_and_set() and use it in __mm_cid_get()
  mips: sgi-ip30: optimize heart_alloc_int() by using find_and_set_bit()
  sparc: optimize alloc_msi() by using find_and_set_bit()
  perf/arm: use atomic find_bit() API
  drivers/perf: optimize ali_drw_get_counter_idx() by using
    find_and_set_bit()
  dmaengine: idxd: optimize perfmon_assign_event()
  ath10k: optimize ath10k_snoc_napi_poll()
  wifi: rtw88: optimize the driver by using atomic iterator
  KVM: x86: hyper-v: optimize and cleanup kvm_hv_process_stimers()
  PCI: hv: Optimize hv_get_dom_num() by using find_and_set_bit()
  scsi: core: optimize scsi_evt_emit() by using an atomic iterator
  scsi: mpi3mr: optimize the driver by using find_and_set_bit()
  scsi: qedi: optimize qedi_get_task_idx() by using find_and_set_bit()
  powerpc: optimize arch code by using atomic find_bit() API
  iommu: optimize subsystem by using atomic find_bit() API
  media: radio-shark: optimize the driver by using atomic find_bit() API
  sfc: optimize the driver by using atomic find_bit() API
  tty: nozomi: optimize interrupt_handler()
  usb: cdc-acm: optimize acm_softint()
  RDMA/rtrs: optimize __rtrs_get_permit() by using
    find_and_set_bit_lock()
  mISDN: optimize get_free_devid()
  media: em28xx: cx231xx: optimize drivers by using find_and_set_bit()
  ethernet: rocker: optimize ofdpa_port_internal_vlan_id_get()
  bluetooth: optimize cmtp_alloc_block_id()
  net: smc: optimize smc_wr_tx_get_free_slot_index()
  ALSA: use atomic find_bit() functions where applicable
  m68k: optimize get_mmu_context()
  microblaze: optimize get_mmu_context()
  sh: mach-x3proto: optimize ilsel_enable()
  MIPS: sgi-ip27: optimize alloc_level()
  uprobes: optimize xol_take_insn_slot()
  scsi: sr: drop locking around SR index bitmap
  KVM: PPC: Book3s HV: drop locking around kvmppc_uvmem_bitmap
  wifi: mac80211: drop locking around ntp_fltr_bmap
  mailbox: bcm-flexrm: simplify locking scheme
  powerpc/xive: drop locking around IRQ map

 MAINTAINERS                                  |   2 +
 arch/m68k/include/asm/mmu_context.h          |  12 +-
 arch/microblaze/include/asm/mmu_context_mm.h |  12 +-
 arch/mips/sgi-ip27/ip27-irq.c                |  13 +-
 arch/mips/sgi-ip30/ip30-irq.c                |  13 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c           |  33 +-
 arch/powerpc/mm/book3s32/mmu_context.c       |  11 +-
 arch/powerpc/platforms/pasemi/dma_lib.c      |  46 +--
 arch/powerpc/platforms/powernv/pci-sriov.c   |  13 +-
 arch/powerpc/sysdev/xive/spapr.c             |  34 +-
 arch/sh/boards/mach-x3proto/ilsel.c          |   5 +-
 arch/sparc/kernel/pci_msi.c                  |  10 +-
 arch/x86/kvm/hyperv.c                        |  41 +--
 drivers/dma/idxd/perfmon.c                   |   9 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c       |  16 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.h        |  11 +-
 drivers/iommu/msm_iommu.c                    |  19 +-
 drivers/isdn/mISDN/core.c                    |  10 +-
 drivers/mailbox/bcm-flexrm-mailbox.c         |  21 +-
 drivers/media/radio/radio-shark.c            |   6 +-
 drivers/media/radio/radio-shark2.c           |   6 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c    |  17 +-
 drivers/media/usb/em28xx/em28xx-cards.c      |  38 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |  18 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c   |  12 +-
 drivers/net/ethernet/sfc/rx_common.c         |   5 +-
 drivers/net/ethernet/sfc/siena/rx_common.c   |   5 +-
 drivers/net/ethernet/sfc/siena/siena_sriov.c |  15 +-
 drivers/net/wireless/ath/ath10k/snoc.c       |  10 +-
 drivers/net/wireless/realtek/rtw88/pci.c     |   6 +-
 drivers/net/wireless/realtek/rtw89/pci.c     |   6 +-
 drivers/pci/controller/pci-hyperv.c          |   8 +-
 drivers/perf/alibaba_uncore_drw_pmu.c        |  11 +-
 drivers/perf/arm-cci.c                       |  25 +-
 drivers/perf/arm-ccn.c                       |  11 +-
 drivers/perf/arm_dmc620_pmu.c                |  10 +-
 drivers/perf/arm_pmuv3.c                     |   9 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c              |  22 +-
 drivers/scsi/qedi/qedi_main.c                |  10 +-
 drivers/scsi/scsi_lib.c                      |   8 +-
 drivers/scsi/sr.c                            |  15 +-
 drivers/tty/nozomi.c                         |   6 +-
 drivers/usb/class/cdc-acm.c                  |   6 +-
 include/linux/cpumask_atomic.h               |  20 ++
 include/linux/find.h                         |   4 -
 include/linux/find_atomic.h                  | 324 +++++++++++++++++++
 kernel/events/uprobes.c                      |  15 +-
 kernel/sched/sched.h                         |  15 +-
 kernel/watch_queue.c                         |   7 +-
 lib/find_bit.c                               |  86 +++++
 lib/sbitmap.c                                |  47 +--
 lib/test_bitmap.c                            |  62 ++++
 net/bluetooth/cmtp/core.c                    |  11 +-
 net/smc/smc_wr.c                             |  11 +-
 sound/pci/hda/hda_codec.c                    |   8 +-
 sound/usb/caiaq/audio.c                      |  14 +-
 56 files changed, 747 insertions(+), 493 deletions(-)
 create mode 100644 include/linux/cpumask_atomic.h
 create mode 100644 include/linux/find_atomic.h

-- 
2.43.0


