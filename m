Return-Path: <kvm+bounces-3334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC5A38033E9
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:08:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0401C20AA1
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6B6250F5;
	Mon,  4 Dec 2023 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="glYuk8RX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A384A7;
	Mon,  4 Dec 2023 05:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701695265; x=1733231265;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UpKiTiLV03HLrMK8OyY7m+bGEMtR9L95NOiQzYClrhU=;
  b=glYuk8RXPb0XnOqDmmVCjrF7jpJ9zshznGYsBwZnW6Lp6N9UB3wcJAfW
   RcyKoR3vcNfNkawEw6PplM/CnnVsbAPCOO3ye8XRT4rN3XSwOLz9sb1hU
   7C+6cD/D1sePV5R/GegF2Oygln5+FP4LpN8LETCbSj5emh7LU/EmbTFtR
   dAUdaO++oeIOhU9+SvMmDwUTY7pfPCIkRyf2unXDWTJ2pYQAWOK2AA2Mv
   93RpGe0s7/IwqU+loGPDWvrNJMvLWXNCZjdCDCe8Q32LqxnYlkjlPcodB
   VrGEtbgUe6WUs5DZVI6UwsLf1e6rvg4sOZtvRq/3Q28morjoDvQUepAYu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="15275177"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="15275177"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 05:07:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="763935696"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="763935696"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 05:07:13 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1rA8fA-00000001kqj-2oCl;
	Mon, 04 Dec 2023 15:07:04 +0200
Date: Mon, 4 Dec 2023 15:07:04 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Chaitanya Kulkarni <kch@nvidia.com>,
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
	Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
	Jiri Pirko <jiri@resnulli.us>, Jiri Slaby <jirislaby@kernel.org>,
	Kalle Valo <kvalo@kernel.org>, Karsten Graul <kgraul@linux.ibm.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Kees Cook <keescook@chromium.org>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oliver Neukum <oneukum@suse.com>, Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ping-Ke Shih <pkshih@realtek.com>, Rich Felker <dalias@libc.org>,
	Rob Herring <robh@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>, Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	GR-QLogic-Storage-Upstream@marvell.com, alsa-devel@alsa-project.org,
	ath10k@lists.infradead.org, dmaengine@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-net-drivers@amd.com, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-sound@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mpi3mr-linuxdrv.pdl@broadcom.com,
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
	Jan Kara <jack@suse.cz>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Matthew Wilcox <willy@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH v2 00/35] bitops: add atomic find_bit() operations
Message-ID: <ZW3O-P_98eubKxMU@smile.fi.intel.com>
References: <20231203192422.539300-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231203192422.539300-1-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Sun, Dec 03, 2023 at 11:23:47AM -0800, Yury Norov wrote:
> Add helpers around test_and_{set,clear}_bit() that allow to search for
> clear or set bits and flip them atomically.
> 
> The target patterns may look like this:
> 
> 	for (idx = 0; idx < nbits; idx++)
> 		if (test_and_clear_bit(idx, bitmap))
> 			do_something(idx);
> 
> Or like this:
> 
> 	do {
> 		bit = find_first_bit(bitmap, nbits);
> 		if (bit >= nbits)
> 			return nbits;
> 	} while (!test_and_clear_bit(bit, bitmap));
> 	return bit;
> 
> In both cases, the opencoded loop may be converted to a single function
> or iterator call. Correspondingly:
> 
> 	for_each_test_and_clear_bit(idx, bitmap, nbits)
> 		do_something(idx);
> 
> Or:
> 	return find_and_clear_bit(bitmap, nbits);
> 
> Obviously, the less routine code people have to write themself, the
> less probability to make a mistake.
> 
> Those are not only handy helpers but also resolve a non-trivial
> issue of using non-atomic find_bit() together with atomic
> test_and_{set,clear)_bit().
> 
> The trick is that find_bit() implies that the bitmap is a regular
> non-volatile piece of memory, and compiler is allowed to use such
> optimization techniques like re-fetching memory instead of caching it.
> 
> For example, find_first_bit() is implemented like this:
> 
>       for (idx = 0; idx * BITS_PER_LONG < sz; idx++) {
>               val = addr[idx];
>               if (val) {
>                       sz = min(idx * BITS_PER_LONG + __ffs(val), sz);
>                       break;
>               }
>       }
> 
> On register-memory architectures, like x86, compiler may decide to
> access memory twice - first time to compare against 0, and second time
> to fetch its value to pass it to __ffs().
> 
> When running find_first_bit() on volatile memory, the memory may get
> changed in-between, and for instance, it may lead to passing 0 to
> __ffs(), which is undefined. This is a potentially dangerous call.
> 
> find_and_clear_bit() as a wrapper around test_and_clear_bit()
> naturally treats underlying bitmap as a volatile memory and prevents
> compiler from such optimizations.
> 
> Now that KCSAN is catching exactly this type of situations and warns on
> undercover memory modifications. We can use it to reveal improper usage
> of find_bit(), and convert it to atomic find_and_*_bit() as appropriate.
> 
> The 1st patch of the series adds the following atomic primitives:
> 
> 	find_and_set_bit(addr, nbits);
> 	find_and_set_next_bit(addr, nbits, start);
> 	...
> 
> Here find_and_{set,clear} part refers to the corresponding
> test_and_{set,clear}_bit function. Suffixes like _wrap or _lock
> derive their semantics from corresponding find() or test() functions.
> 
> For brevity, the naming omits the fact that we search for zero bit in
> find_and_set, and correspondingly search for set bit in find_and_clear
> functions.
> 
> The patch also adds iterators with atomic semantics, like
> for_each_test_and_set_bit(). Here, the naming rule is to simply prefix
> corresponding atomic operation with 'for_each'.
> 
> This series is a result of discussion [1]. All find_bit() functions imply
> exclusive access to the bitmaps. However, KCSAN reports quite a number
> of warnings related to find_bit() API. Some of them are not pointing
> to real bugs because in many situations people intentionally allow
> concurrent bitmap operations.
> 
> If so, find_bit() can be annotated such that KCSAN will ignore it:
> 
>         bit = data_race(find_first_bit(bitmap, nbits));
> 
> This series addresses the other important case where people really need
> atomic find ops. As the following patches show, the resulting code
> looks safer and more verbose comparing to opencoded loops followed by
> atomic bit flips.
> 
> In [1] Mirsad reported 2% slowdown in a single-thread search test when
> switching find_bit() function to treat bitmaps as volatile arrays. On
> the other hand, kernel robot in the same thread reported +3.7% to the
> performance of will-it-scale.per_thread_ops test.
> 
> Assuming that our compilers are sane and generate better code against
> properly annotated data, the above discrepancy doesn't look weird. When
> running on non-volatile bitmaps, plain find_bit() outperforms atomic
> find_and_bit(), and vice-versa.

...

In some cases the better improvements can be achieved by switching
the (very) old code to utilise IDA framework.

-- 
With Best Regards,
Andy Shevchenko



