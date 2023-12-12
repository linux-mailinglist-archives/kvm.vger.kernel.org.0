Return-Path: <kvm+bounces-4126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD33080E1B3
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 03:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6876F1F21C7D
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 02:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E2CE57E;
	Tue, 12 Dec 2023 02:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQBudszo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FA7B5;
	Mon, 11 Dec 2023 18:27:55 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-db3fa47c2f7so5477929276.0;
        Mon, 11 Dec 2023 18:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702348074; x=1702952874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+PiVVlt0R1rAcNbEfljLBH21XDutnmdsosj1LGuGRo=;
        b=UQBudszotTGe06Bk8UCTi8Uma8P8G8Msfc7Sa2OFaBp7+vgjGg1LL0YSqMdZKz1wMm
         tIv6gvWAI4f/BQsxV3j18nlNp34tj+G0cwrp5/oKlpWpLHhyhU0av2WRiq+yRfG8MxF1
         bxPOZQBItoy9c0ybPvigf2Ich+ihh3XO9m2zOxb5TBHPTalUlC21uBe3flLXjQmrs3ba
         iRC+WJDkgSobVP8IdCkBqztmZUohxB/nY7wnEgiOiqLy5NLCDqPqxka3ytPmPiR2Zlya
         xi62tG98qrBqO9OxLNT3oYggUi64ss5ntVJM57lO0nGSCSqBIo3KOEONmblBxVmnSVov
         HxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702348074; x=1702952874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C+PiVVlt0R1rAcNbEfljLBH21XDutnmdsosj1LGuGRo=;
        b=XTyeK4oNOLjka8V2Gy6xZUokNAzUJzQuAaqb2v5ZpDxOWNXpL5amT2LTmG+FKepNL6
         dN5S9J58zUELkF2+RHydeBd33GJESRFAgcF2rylGegL3JKg0Gb6RzTiNqL9Tu+zHnT7E
         EwBvQM9PHr82SBJWfaExPIynvoWqPm/1CLQLtPgBb+mJ3W9zHi6NvdepugGif0eGOWon
         6ojBt/rWpHvZ56vl8EDxdAMt6bswxjYK6ly7eFY89o+s8IovujemEePLEGuXRpYcIoGk
         Uu7sC9U9XPKfhUA8cG3r/qY/8oujcw3WMh+CZ1JsBzxXkCy9yf8YKbd8x3V5/0G/dta5
         4cnQ==
X-Gm-Message-State: AOJu0YwtxDj/+8iYpfc87Zn/4Y4I9rVcfcV6aE2WOqv7RnNxNaMhoq/l
	wDtiQD0To3YXrANy4+si9ijF2i8QSiEzxw==
X-Google-Smtp-Source: AGHT+IGYzhPnMEAMXEWXRuumf6RoaD+DrzMTkOOTF2Jfa9W4CrJeSe04vsvmLiH9e40/y+d/NnxEJA==
X-Received: by 2002:a25:3604:0:b0:db9:909c:ab0a with SMTP id d4-20020a253604000000b00db9909cab0amr3469170yba.121.1702348073753;
        Mon, 11 Dec 2023 18:27:53 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:38aa:1c88:df05:9b73])
        by smtp.gmail.com with ESMTPSA id e195-20020a2569cc000000b00db3fca90d6esm2974453ybc.2.2023.12.11.18.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 18:27:52 -0800 (PST)
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
	Jan Kara <jack@suse.cz>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Matthew Wilcox <willy@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v3 01/35] lib/find: add atomic find_bit() primitives
Date: Mon, 11 Dec 2023 18:27:15 -0800
Message-Id: <20231212022749.625238-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231212022749.625238-1-yury.norov@gmail.com>
References: <20231212022749.625238-1-yury.norov@gmail.com>
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

Obviously, the less routine code people have to write themself, the
less probability to make a mistake.

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
cases where KCSAN detects concurrency people should carefully review their
code and likely protect critical sections or switch to atomic
find_and_bit(), as appropriate.

The 1st patch of the series adds the following atomic primitives:

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

CC: Bart Van Assche <bvanassche@acm.org>
CC: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/find.h | 293 +++++++++++++++++++++++++++++++++++++++++++
 lib/find_bit.c       |  85 +++++++++++++
 2 files changed, 378 insertions(+)

diff --git a/include/linux/find.h b/include/linux/find.h
index 5e4f39ef2e72..237513356ffa 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -32,6 +32,16 @@ extern unsigned long _find_first_and_bit(const unsigned long *addr1,
 extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
 extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
 
+unsigned long _find_and_set_bit(volatile unsigned long *addr, unsigned long nbits);
+unsigned long _find_and_set_next_bit(volatile unsigned long *addr, unsigned long nbits,
+				unsigned long start);
+unsigned long _find_and_set_bit_lock(volatile unsigned long *addr, unsigned long nbits);
+unsigned long _find_and_set_next_bit_lock(volatile unsigned long *addr, unsigned long nbits,
+					  unsigned long start);
+unsigned long _find_and_clear_bit(volatile unsigned long *addr, unsigned long nbits);
+unsigned long _find_and_clear_next_bit(volatile unsigned long *addr, unsigned long nbits,
+				unsigned long start);
+
 #ifdef __BIG_ENDIAN
 unsigned long _find_first_zero_bit_le(const unsigned long *addr, unsigned long size);
 unsigned long _find_next_zero_bit_le(const  unsigned long *addr, unsigned
@@ -460,6 +470,267 @@ unsigned long __for_each_wrap(const unsigned long *bitmap, unsigned long size,
 	return bit < start ? bit : size;
 }
 
+/**
+ * find_and_set_bit - Find a zero bit and set it atomically
+ * @addr: The address to base the search on
+ * @nbits: The bitmap size in bits
+ *
+ * This function is designed to operate in concurrent access environment.
+ *
+ * Because of concurrency and volatile nature of underlying bitmap, it's not
+ * guaranteed that the found bit is the 1st bit in the bitmap. It's also not
+ * guaranteed that if @nbits is returned, the bitmap is empty.
+ *
+ * The function does guarantee that if returned value is in range [0 .. @nbits),
+ * the acquired bit belongs to the caller exclusively.
+ *
+ * Returns: found and set bit, or @nbits if no bits found
+ */
+static inline
+unsigned long find_and_set_bit(volatile unsigned long *addr, unsigned long nbits)
+{
+	if (small_const_nbits(nbits)) {
+		unsigned long val, ret;
+
+		do {
+			val = *addr | ~GENMASK(nbits - 1, 0);
+			if (val == ~0UL)
+				return nbits;
+			ret = ffz(val);
+		} while (test_and_set_bit(ret, addr));
+
+		return ret;
+	}
+
+	return _find_and_set_bit(addr, nbits);
+}
+
+
+/**
+ * find_and_set_next_bit - Find a zero bit and set it, starting from @offset
+ * @addr: The address to base the search on
+ * @nbits: The bitmap nbits in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * This function is designed to operate in concurrent access environment.
+ *
+ * Because of concurrency and volatile nature of underlying bitmap, it's not
+ * guaranteed that the found bit is the 1st bit in the bitmap, starting from @offset.
+ * It's also not guaranteed that if @nbits is returned, the bitmap is empty.
+ *
+ * The function does guarantee that if returned value is in range [@offset .. @nbits),
+ * the acquired bit belongs to the caller exclusively.
+ *
+ * Returns: found and set bit, or @nbits if no bits found
+ */
+static inline
+unsigned long find_and_set_next_bit(volatile unsigned long *addr,
+				    unsigned long nbits, unsigned long offset)
+{
+	if (small_const_nbits(nbits)) {
+		unsigned long val, ret;
+
+		do {
+			val = *addr | ~GENMASK(nbits - 1, offset);
+			if (val == ~0UL)
+				return nbits;
+			ret = ffz(val);
+		} while (test_and_set_bit(ret, addr));
+
+		return ret;
+	}
+
+	return _find_and_set_next_bit(addr, nbits, offset);
+}
+
+/**
+ * find_and_set_bit_wrap - find and set bit starting at @offset, wrapping around zero
+ * @addr: The first address to base the search on
+ * @nbits: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Returns: the bit number for the next clear bit, or first clear bit up to @offset,
+ * while atomically setting it. If no bits are found, returns @nbits.
+ */
+static inline
+unsigned long find_and_set_bit_wrap(volatile unsigned long *addr,
+					unsigned long nbits, unsigned long offset)
+{
+	unsigned long bit = find_and_set_next_bit(addr, nbits, offset);
+
+	if (bit < nbits || offset == 0)
+		return bit;
+
+	bit = find_and_set_bit(addr, offset);
+	return bit < offset ? bit : nbits;
+}
+
+/**
+ * find_and_set_bit_lock - find a zero bit, then set it atomically with lock
+ * @addr: The address to base the search on
+ * @nbits: The bitmap nbits in bits
+ *
+ * This function is designed to operate in concurrent access environment.
+ *
+ * Because of concurrency and volatile nature of underlying bitmap, it's not
+ * guaranteed that the found bit is the 1st bit in the bitmap. It's also not
+ * guaranteed that if @nbits is returned, the bitmap is empty.
+ *
+ * The function does guarantee that if returned value is in range [0 .. @nbits),
+ * the acquired bit belongs to the caller exclusively.
+ *
+ * Returns: found and set bit, or @nbits if no bits found
+ */
+static inline
+unsigned long find_and_set_bit_lock(volatile unsigned long *addr, unsigned long nbits)
+{
+	if (small_const_nbits(nbits)) {
+		unsigned long val, ret;
+
+		do {
+			val = *addr | ~GENMASK(nbits - 1, 0);
+			if (val == ~0UL)
+				return nbits;
+			ret = ffz(val);
+		} while (test_and_set_bit_lock(ret, addr));
+
+		return ret;
+	}
+
+	return _find_and_set_bit_lock(addr, nbits);
+}
+
+/**
+ * find_and_set_next_bit_lock - find a zero bit and set it atomically with lock
+ * @addr: The address to base the search on
+ * @nbits: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * This function is designed to operate in concurrent access environment.
+ *
+ * Because of concurrency and volatile nature of underlying bitmap, it's not
+ * guaranteed that the found bit is the 1st bit in the range. It's also not
+ * guaranteed that if @nbits is returned, the bitmap is empty.
+ *
+ * The function does guarantee that if returned value is in range [@offset .. @nbits),
+ * the acquired bit belongs to the caller exclusively.
+ *
+ * Returns: found and set bit, or @nbits if no bits found
+ */
+static inline
+unsigned long find_and_set_next_bit_lock(volatile unsigned long *addr,
+					 unsigned long nbits, unsigned long offset)
+{
+	if (small_const_nbits(nbits)) {
+		unsigned long val, ret;
+
+		do {
+			val = *addr | ~GENMASK(nbits - 1, offset);
+			if (val == ~0UL)
+				return nbits;
+			ret = ffz(val);
+		} while (test_and_set_bit_lock(ret, addr));
+
+		return ret;
+	}
+
+	return _find_and_set_next_bit_lock(addr, nbits, offset);
+}
+
+/**
+ * find_and_set_bit_wrap_lock - find zero bit starting at @ofset and set it
+ *				with lock, and wrap around zero if nothing found
+ * @addr: The first address to base the search on
+ * @nbits: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Returns: the bit number for the next set bit, or first set bit up to @offset
+ * If no bits are set, returns @nbits.
+ */
+static inline
+unsigned long find_and_set_bit_wrap_lock(volatile unsigned long *addr,
+					unsigned long nbits, unsigned long offset)
+{
+	unsigned long bit = find_and_set_next_bit_lock(addr, nbits, offset);
+
+	if (bit < nbits || offset == 0)
+		return bit;
+
+	bit = find_and_set_bit_lock(addr, offset);
+	return bit < offset ? bit : nbits;
+}
+
+/**
+ * find_and_clear_bit - Find a set bit and clear it atomically
+ * @addr: The address to base the search on
+ * @nbits: The bitmap nbits in bits
+ *
+ * This function is designed to operate in concurrent access environment.
+ *
+ * Because of concurrency and volatile nature of underlying bitmap, it's not
+ * guaranteed that the found bit is the 1st bit in the bitmap. It's also not
+ * guaranteed that if @nbits is returned, the bitmap is empty.
+ *
+ * The function does guarantee that if returned value is in range [0 .. @nbits),
+ * the acquired bit belongs to the caller exclusively.
+ *
+ * Returns: found and cleared bit, or @nbits if no bits found
+ */
+static inline unsigned long find_and_clear_bit(volatile unsigned long *addr, unsigned long nbits)
+{
+	if (small_const_nbits(nbits)) {
+		unsigned long val, ret;
+
+		do {
+			val = *addr & GENMASK(nbits - 1, 0);
+			if (val == 0)
+				return nbits;
+			ret = __ffs(val);
+		} while (!test_and_clear_bit(ret, addr));
+
+		return ret;
+	}
+
+	return _find_and_clear_bit(addr, nbits);
+}
+
+/**
+ * find_and_clear_next_bit - Find a set bit next after @offset, and clear it atomically
+ * @addr: The address to base the search on
+ * @nbits: The bitmap nbits in bits
+ * @offset: bit offset at which to start searching
+ *
+ * This function is designed to operate in concurrent access environment.
+ *
+ * Because of concurrency and volatile nature of underlying bitmap, it's not
+ * guaranteed that the found bit is the 1st bit in the range It's also not
+ * guaranteed that if @nbits is returned, there's no set bits after @offset.
+ *
+ * The function does guarantee that if returned value is in range [@offset .. @nbits),
+ * the acquired bit belongs to the caller exclusively.
+ *
+ * Returns: found and cleared bit, or @nbits if no bits found
+ */
+static inline
+unsigned long find_and_clear_next_bit(volatile unsigned long *addr,
+					unsigned long nbits, unsigned long offset)
+{
+	if (small_const_nbits(nbits)) {
+		unsigned long val, ret;
+
+		do {
+			val = *addr & GENMASK(nbits - 1, offset);
+			if (val == 0)
+				return nbits;
+			ret = __ffs(val);
+		} while (!test_and_clear_bit(ret, addr));
+
+		return ret;
+	}
+
+	return _find_and_clear_next_bit(addr, nbits, offset);
+}
+
 /**
  * find_next_clump8 - find next 8-bit clump with set bits in a memory region
  * @clump: location to store copy of found clump
@@ -577,6 +848,28 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 #define for_each_set_bit_from(bit, addr, size) \
 	for (; (bit) = find_next_bit((addr), (size), (bit)), (bit) < (size); (bit)++)
 
+/* same as for_each_set_bit() but atomically clears each found bit */
+#define for_each_test_and_clear_bit(bit, addr, size) \
+	for ((bit) = 0; \
+	     (bit) = find_and_clear_next_bit((addr), (size), (bit)), (bit) < (size); \
+	     (bit)++)
+
+/* same as for_each_set_bit_from() but atomically clears each found bit */
+#define for_each_test_and_clear_bit_from(bit, addr, size) \
+	for (; (bit) = find_and_clear_next_bit((addr), (size), (bit)), (bit) < (size); (bit)++)
+
+/* same as for_each_clear_bit() but atomically sets each found bit */
+#define for_each_test_and_set_bit(bit, addr, size) \
+	for ((bit) = 0; \
+	     (bit) = find_and_set_next_bit((addr), (size), (bit)), (bit) < (size); \
+	     (bit)++)
+
+/* same as for_each_clear_bit_from() but atomically clears each found bit */
+#define for_each_test_and_set_bit_from(bit, addr, size) \
+	for (; \
+	     (bit) = find_and_set_next_bit((addr), (size), (bit)), (bit) < (size); \
+	     (bit)++)
+
 #define for_each_clear_bit(bit, addr, size) \
 	for ((bit) = 0;									\
 	     (bit) = find_next_zero_bit((addr), (size), (bit)), (bit) < (size);		\
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 32f99e9a670e..c9b6b9f96610 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -116,6 +116,91 @@ unsigned long _find_first_and_bit(const unsigned long *addr1,
 EXPORT_SYMBOL(_find_first_and_bit);
 #endif
 
+unsigned long _find_and_set_bit(volatile unsigned long *addr, unsigned long nbits)
+{
+	unsigned long bit;
+
+	do {
+		bit = FIND_FIRST_BIT(~addr[idx], /* nop */, nbits);
+		if (bit >= nbits)
+			return nbits;
+	} while (test_and_set_bit(bit, addr));
+
+	return bit;
+}
+EXPORT_SYMBOL(_find_and_set_bit);
+
+unsigned long _find_and_set_next_bit(volatile unsigned long *addr,
+				     unsigned long nbits, unsigned long start)
+{
+	unsigned long bit;
+
+	do {
+		bit = FIND_NEXT_BIT(~addr[idx], /* nop */, nbits, start);
+		if (bit >= nbits)
+			return nbits;
+	} while (test_and_set_bit(bit, addr));
+
+	return bit;
+}
+EXPORT_SYMBOL(_find_and_set_next_bit);
+
+unsigned long _find_and_set_bit_lock(volatile unsigned long *addr, unsigned long nbits)
+{
+	unsigned long bit;
+
+	do {
+		bit = FIND_FIRST_BIT(~addr[idx], /* nop */, nbits);
+		if (bit >= nbits)
+			return nbits;
+	} while (test_and_set_bit_lock(bit, addr));
+
+	return bit;
+}
+EXPORT_SYMBOL(_find_and_set_bit_lock);
+
+unsigned long _find_and_set_next_bit_lock(volatile unsigned long *addr,
+					  unsigned long nbits, unsigned long start)
+{
+	unsigned long bit;
+
+	do {
+		bit = FIND_NEXT_BIT(~addr[idx], /* nop */, nbits, start);
+		if (bit >= nbits)
+			return nbits;
+	} while (test_and_set_bit_lock(bit, addr));
+
+	return bit;
+}
+EXPORT_SYMBOL(_find_and_set_next_bit_lock);
+
+unsigned long _find_and_clear_bit(volatile unsigned long *addr, unsigned long nbits)
+{
+	unsigned long bit;
+
+	do {
+		bit = FIND_FIRST_BIT(addr[idx], /* nop */, nbits);
+		if (bit >= nbits)
+			return nbits;
+	} while (!test_and_clear_bit(bit, addr));
+
+	return bit;
+}
+EXPORT_SYMBOL(_find_and_clear_bit);
+
+unsigned long _find_and_clear_next_bit(volatile unsigned long *addr,
+					unsigned long nbits, unsigned long start)
+{
+	do {
+		start =  FIND_NEXT_BIT(addr[idx], /* nop */, nbits, start);
+		if (start >= nbits)
+			return nbits;
+	} while (!test_and_clear_bit(start, addr));
+
+	return start;
+}
+EXPORT_SYMBOL(_find_and_clear_next_bit);
+
 #ifndef find_first_zero_bit
 /*
  * Find the first cleared bit in a memory region.
-- 
2.40.1


