Return-Path: <kvm+bounces-50868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 926E5AEA4E6
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 822691899475
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D343E2ED178;
	Thu, 26 Jun 2025 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T2bJXFS3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D59217F55
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750961080; cv=none; b=MzwfRTCQ1wI8RrSaL8mWVo8ff4PTXpdKntGicpG078nUl80O/0V/eKhkAHdlfeCfIR4lfYcTkhfvGJ0BGdOVXohRptj/RXqEsYLyQphyt9FsrxdD0Idf7i+0Iy9+jZTbEDusMIgjsDlfgVnEdJi8mYESDR1NBjjBW27OcdBKU/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750961080; c=relaxed/simple;
	bh=oFnd5nSOQkRlObazVScUgmNRzKqKb2Uq7Duiioo1u9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mZTFlwPLLoqZlpd8CtM06xkY8qpnTjhr4pQYCpj0KCpt7SDJsgamqV6o89XscvmUoV/UwDofvWJ9Lqd5vp4sk8RbPdx/oYh+UuqeEBEmi70JemiIO+Aja2LIBl5TS/CU/kEAI0huS4ajkD18Yu6JFrDq8o6k9BmMfpwYx8T0mI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T2bJXFS3; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74880a02689so1089334b3a.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 11:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750961076; x=1751565876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lExAmKeJ7h4efNmmSkOG8NmFsCc+VGGAYwMTZWxckvE=;
        b=T2bJXFS3UVkHgbeHCsAi9aCcNPlMHRlSFnFcGezjnUJkuk00YA88xCI68I6VmRsLwj
         PbgSXYgJwRa1OEIqMOhbrhuGPlrXBXR87m4AbNmyweHu9OAQ1FqvfmkUcpnE+dhfcgnj
         XyVeoFqIQtf+oAv/MdJP5ZriJvrmnKAj4PokoUmyg6+UWufKN8UBwlRRHB3LSt1ZglT7
         dEXb4DzkG7pXWfL6+pZAhJNO4crxH2pXBvMm4Jn2xiGEv6jHVPNRsur6mQRRbTgMqZYR
         utr4ZVepDlgboCTpCH0wb3eytdhFUivqyeCLOX5bSbv2PzUAkO7hvOkcUdJh/Gqy1eAU
         KEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750961076; x=1751565876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lExAmKeJ7h4efNmmSkOG8NmFsCc+VGGAYwMTZWxckvE=;
        b=UdyAQTKPOxhD8iMPt5igYQQP06I01O56ccZPveHR9rO63Wfbmvupd4VGMLIMoM0WK0
         Y4iE1JYurMeSdA5Zz0XqC4N7ZOmZPJ8SeyokEaz2jGHov7wYrl9b5YB3DFF+c24k72hO
         0SUXAYiKgYfEZU7goocKzGnVxs+Bhw9Ug6zNz3Dh9AVWrCv369IxJqei96uIo9ggKXJ3
         xHnC+/oH09hXp1AdU21hPsMCZJlc2TKa8YPJmzMmttB3pSKUUv0URW6Z2RLFxGbCWxMC
         OyT6ufQevuffVVXAmlCwX72WN3/sUm9Y5TK5w6Bi3JUk9mrtS3Tj2C6kOHLypn7PCFAd
         yw0g==
X-Gm-Message-State: AOJu0Yw42BRH1DKozNfZLOTnJCNp/LXonJM42ykYNmbT9kbKnahwK/vm
	d93C6I6D3peKP4QLP5NOcNGlnOWUUUSn2+6F3dI+iVYS4BDFOMK+RcvoQsolkmBiqXSpu89XLWy
	GKiCd7k1DTRhgUo80jRCE2w==
X-Google-Smtp-Source: AGHT+IEfwbLcqezzGLB9hrnfjd5I6PD2YY+bSYILLfWJufMtCKMrPEWkiApc6FHyrdsmtwZvcWgZM335VQtJ1hwE
X-Received: from pfbcj25.prod.google.com ([2002:a05:6a00:2999:b0:746:2187:b5c8])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3387:b0:1f5:8c05:e8f8 with SMTP id adf61e73a8af0-2207f269be2mr11507283637.25.1750961075632;
 Thu, 26 Jun 2025 11:04:35 -0700 (PDT)
Date: Thu, 26 Jun 2025 18:04:23 +0000
In-Reply-To: <20250626180424.632628-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626180424.632628-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626180424.632628-3-aaronlewis@google.com>
Subject: [RFC PATCH 2/3] vfio: selftests: Introduce the selftest vfio_flr_test
From: Aaron Lewis <aaronlewis@google.com>
To: alex.williamson@redhat.com, bhelgaas@google.com, dmatlack@google.com, 
	vipinsh@google.com
Cc: kvm@vger.kernel.org, seanjc@google.com, jrhilke@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce the VFIO selftest "vfio_flr_test" as a way of demonstrating a
latency issue that occurs when multiple devices are reset at the
same time.  To reproduce this issue simply run the selftest, e.g.

  $ VFIO_BDF_1=0000:17:0c.1 VFIO_BDF_2=0000:17:0c.2 ./vfio_flr_test
  [0x7f61bb888700] '0000:17:0c.2' initialized in 108.6ms.
  [0x7f61bc089700] '0000:17:0c.1' initialized in 212.3ms.

When the devices are initialized in the test, despite that happening on
separate threads, one of the devices will take >200ms.  Initializing a
device requires a FLR (function level reset), so the device taking
~100ms to initialize is expected, however, when a second devices is
initialized in parallel the desired behavior would be that the FLR
happens concurrently.  Unfortunately, due to a lock in
vfio_df_group_open() that does not happen.

As for how the selftest works, it requires two BDF's be passed to it as
environment variables as shown in the example above:
 - VFIO_BDF_1
 - VFIO_BDF_2

It then initializes each of them on separate threads and reports how long
they took.

The Thread ID is included in the debug prints to show what thread they
are executing from, and to show that this is a parallel operation.

Some of the prints are commented out to allow the focus to be on the
issue at hand, however, they can be useful for debugging so they were
left in.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/vfio/Makefile        |   1 +
 tools/testing/selftests/vfio/vfio_flr_test.c | 120 +++++++++++++++++++
 2 files changed, 121 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_flr_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 324ba0175a33..57635883f2c2 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -1,5 +1,6 @@
 CFLAGS = $(KHDR_INCLUDES)
 TEST_GEN_PROGS += vfio_dma_mapping_test
+TEST_GEN_PROGS += vfio_flr_test
 TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_driver_test
diff --git a/tools/testing/selftests/vfio/vfio_flr_test.c b/tools/testing/selftests/vfio/vfio_flr_test.c
new file mode 100644
index 000000000000..5522f6d256dc
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_flr_test.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <pthread.h>
+#include <stdlib.h>
+
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <linux/limits.h>
+#include <linux/pci_regs.h>
+#include <linux/sizes.h>
+#include <linux/vfio.h>
+
+#include <vfio_util.h>
+
+#define NR_THREADS 2
+
+double freq_ms = .0;
+
+static bool is_bdf(const char *str)
+{
+	unsigned int s, b, d, f;
+	int length, count;
+
+	count = sscanf(str, "%4x:%2x:%2x.%2x%n", &s, &b, &d, &f, &length);
+	return count == 4 && length == strlen(str);
+}
+
+static const char *vfio_get_bdf(const char *env_var)
+{
+	char *bdf;
+
+	bdf = getenv(env_var);
+	if (bdf) {
+		VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
+		return bdf;
+	}
+
+	return NULL;
+}
+
+static inline uint64_t rdtsc(void)
+{
+	uint32_t eax, edx;
+	uint64_t tsc_val;
+	/*
+	 * The lfence is to wait (on Intel CPUs) until all previous
+	 * instructions have been executed. If software requires RDTSC to be
+	 * executed prior to execution of any subsequent instruction, it can
+	 * execute LFENCE immediately after RDTSC
+	 */
+	__asm__ __volatile__("lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
+	tsc_val = ((uint64_t)edx) << 32 | eax;
+	return tsc_val;
+}
+
+static void init_freq_ms(void)
+{
+	uint64_t tsc_start, tsc_end;
+
+	tsc_start = rdtsc();
+	sleep(1);
+	tsc_end = rdtsc();
+	freq_ms = (double)(tsc_end - tsc_start) / 1000.0;
+	// printf("[0x%lx] freq_ms = %.03lf\n", pthread_self(), freq_ms);
+}
+
+static double now_ms(void)
+{
+	return (double)rdtsc() / freq_ms;
+}
+
+static double time_since_last_ms(double *last_ms)
+{
+	double now = now_ms();
+	double duration = now - *last_ms;
+
+	*last_ms = now;
+	return duration;
+}
+
+static void *flr_test_thread(void *arg)
+{
+	const char *device_bdf = (const char *)arg;
+	struct vfio_pci_device *device;
+	double last = now_ms();
+
+	device = vfio_pci_device_init(device_bdf, default_iommu_mode);
+	printf("[0x%lx] '%s' initialized in %.1lfms.\n",
+	       pthread_self(), device_bdf, time_since_last_ms(&last));
+
+	vfio_pci_device_cleanup(device);
+	// printf("[0x%lx] '%s' cleaned up in %.1lfms\n",
+	//        pthread_self(), device_bdf, time_since_last_ms(&last));
+
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	const char *device_bdfs[NR_THREADS];
+	pthread_t threads[NR_THREADS];
+	int i;
+
+	init_freq_ms();
+
+	device_bdfs[0] = vfio_get_bdf("VFIO_BDF_1");
+	device_bdfs[1] = vfio_get_bdf("VFIO_BDF_2");
+
+	// printf("[0x%lx] nr_threads = '%d'\n", pthread_self(), NR_THREADS);
+
+	for (i = 0; i < NR_THREADS; i++)
+		pthread_create(&threads[i], NULL, flr_test_thread,
+			       (void *)device_bdfs[i]);
+
+	for (i = 0; i < NR_THREADS; i++)
+		pthread_join(threads[i], NULL);
+
+	return 0;
+}
-- 
2.50.0.727.gbf7dc18ff4-goog


