Return-Path: <kvm+bounces-298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95BE17DE00E
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C67CCB210DC
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB0010A2B;
	Wed,  1 Nov 2023 11:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4475C10A05
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 11:03:50 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED157FC
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 04:03:47 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 318F32F4;
	Wed,  1 Nov 2023 04:04:29 -0700 (PDT)
Received: from monolith (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E57843F67D;
	Wed,  1 Nov 2023 04:03:41 -0700 (PDT)
Date: Wed, 1 Nov 2023 11:04:23 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: =?utf-8?B?5L2V55C8?= <heqiong1557@phytium.com.cn>
Cc: kvm <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests 1/1] arm64: microbench: Move the read of the
 count register and the ISB operation out of the while loop
Message-ID: <ZUIwt6jWBN037XVf@monolith>
References: <7ac00102.1c5.18b89fcf84f.Coremail.heqiong1557@phytium.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ac00102.1c5.18b89fcf84f.Coremail.heqiong1557@phytium.com.cn>

Hi,

Comments on the patch itself.

On Wed, Nov 01, 2023 at 04:25:39PM +0800, 何琼 wrote:
> hi,
> 
> This patch mainly includes the following content.
> 
> Reducing the impact of the cntvct_el0 register and isb() operation on microbenchmark test results to improve testing accuracy and reduce latency in test results.
> 
> 
> 
> 
> 
> 
> 
> Test in kunpeng920,
> 
> Test results before applying the patch:
> 
> [root@localhost tests]# ./micro-bench
> 
> 
> BUILD_HEAD=767629ca
> 
> 
> Test marked not to be run by default, are you sure (y/N)? y
> 
> 
> timeout -k 1s --foreground 90s numactl -C 0-3 -m 0 /usr/libexec/qemu-kvm -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel /tmp/tmp.y4c4YHIprP -smp 2 # -initrd /tmp/tmp.KLLmjTuq2d
> 
> 
> Timer Frequency 100000000 Hz (Output in microseconds)
> 
> 
> 
> 
> 
> name                                    total ns                         avg ns
> 
> 
> --------------------------------------------------------------------------------------------
> 
> 
> hvc                                      26774980.0                      408.0
> 
> 
> mmio_read_user                 151183350.0                    2306.0
> 
> 
> mmio_read_vgic                  41849830.0                     638.0
> 
> 
> eoi                                       1735610.0                       26.0
> 
> 
> ipi                                        111260770.0                   1697.0
> 
> 
> ipi_hw test skipped
> 
> 
> lpi                                        142124570.0                   2168.0
> 
> 
> timer_10ms                          466660.0                        1822.0
> 
> 
> 
> 
> 
> EXIT: STATUS=1
> 
> 
> PASS micro-bench
> 
> 
> [root@localhost tests]#
> 
> 
> 
> 
> 
> Test results after applying the patch:
> 
> [root@localhost kvm-unit-tests]# cd tests/
> 
> 
> [root@localhost tests]# ./micro-bench
> 
> 
> BUILD_HEAD=767629ca
> 
> 
> Test marked not to be run by default, are you sure (y/N)? y
> 
> 
> timeout -k 1s --foreground 90s numactl -C 0-3 -m 0 /usr/libexec/qemu-kvm -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel /tmp/tmp.FiBID6KLxB -smp 2 # -initrd /tmp/tmp.oSKZeugleF
> 
> 
> Timer Frequency 100000000 Hz (Output in microseconds)
> 
> 
> 
> 
> 
> name                                    total ns                         avg ns
> 
> 
> --------------------------------------------------------------------------------------------
> 
> 
> hvc                                  26721040.0                        407.0
> 
> 
> mmio_read_user             150824560.0                      2301.0
> 
> 
> mmio_read_vgic              41845380.0                       638.0
> 
> 
> eoi                                   1109180.0                         16.0
> 
> 
> ipi                                    106062150.0                     1618.0
> 
> 
> ipi_hw test skipped
> 
> 
> lpi                                    141700760.0                    2162.0
> 
> 
> timer_10ms                      470870.0                         1839.0
> 
> 
> 
> 
> 
> EXIT: STATUS=1
> 
> 
> PASS micro-bench
> 
> 
> [root@localhost tests]#
> 
> 
> 
> 
> 
> 
> 
> 
> Test in phytium S2500,
> 
> Test results before applying the patch:
> 
> [root@primecontroller tests]# ./micro-bench
> 
> 
> BUILD_HEAD=518cd47c
> 
> 
> Test marked not to be run by default, are you sure (y/N)? y
> 
> 
> timeout -k 1s --foreground 90s numactl -C 0-3 -m 0 /usr/local/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel /tmp/tmp.lrJJqSuLmN -smp 2 # -initrd /tmp/tmp.s18C3k2jfO
> 
> 
> Timer Frequency 50000000 Hz (Output in microseconds)
> 
> 
> 
> 
> 
> name                                    total ns                         avg ns
> 
> 
> --------------------------------------------------------------------------------------------
> 
> 
> hvc                                    100668780.0                    1536.0
> 
> 
> mmio_read_user               472806800.0                     7214.0
> 
> 
> mmio_read_vgic               140912320.0                      2150.0
> 
> 
> eoi                                     2972280.0                         45.0
> 
> 
> ipi                                      326332780.0                     4979.0
> 
> 
> ipi_hw test skipped
> 
> 
> lpi                                      359226600.0                     5481.0
> 
> 
> timer_10ms                        1271960.0                         4968.0
> 
> 
> 
> 
> 
> EXIT: STATUS=1
> 
> 
> PASS micro-bench
> 
> 
> [root@primecontroller tests]#
> 
> 
> 
> 
> 
> 
> 
> 
> Test results after applying the patch:
> 
> [root@primecontroller tests]# ./micro-bench
> 
> 
> BUILD_HEAD=518cd47c
> 
> 
> Test marked not to be run by default, are you sure (y/N)? y
> 
> 
> timeout -k 1s --foreground 90s numactl -C 0-3 -m 0 /usr/local/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel /tmp/tmp.IsEtcs1W1g -smp 2 # -initrd /tmp/tmp.885IpeoGw4
> 
> 
> Timer Frequency 50000000 Hz (Output in microseconds)
> 
> 
> 
> 
> 
> name                                    total ns                         avg ns
> 
> 
> --------------------------------------------------------------------------------------------
> 
> 
> hvc                                      99490080.0                    1518.0
> 
> 
> mmio_read_user                 474781300.0                   7244.0
> 
> 
> mmio_read_vgic                 140470760.0                    2143.0
> 
> 
> eoi                                      1693260.0                        25.0
> 
> 
> ipi                                       323551200.0                    4936.0
> 
> 
> ipi_hw test skipped
> 
> 
> lpi                                       355690620.0                    5427.0
> 
> 
> timer_10ms                        1318540.0                        5150.0
> 
> 
> 
> 
> 
> EXIT: STATUS=1
> 
> 
> PASS micro-bench
> 
> 
> [root@primecontroller tests]#
> 
> 
> 
> 
> 
> 
> 
> 
> 

> From 518cd47c33fce60ef86ed66dfa9e904b66499933 Mon Sep 17 00:00:00 2001
> From: heqiong <heqiong1557@phytium.com.cn>
> Date: Wed, 1 Nov 2023 15:06:28 +0800
> Subject: [kvm-unit-tests 1/1] arm64: microbench: Move the read of the count
>  register and the ISB operation out of the while loop
> 
> Reducing the impact of the cntvct_el0 register and isb() operation
> on microbenchmark test results to improve testing accuracy and reduce
> latency in test results.
> ---
>  arm/micro-bench.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index fbe59d03..ee5b9ca0 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -346,17 +346,18 @@ static void loop_test(struct exit_test *test)
>  		}
>  	}
>  
> +	start = read_sysreg(cntpct_el0);
> +	isb();
>  	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
> -		isb();
> -		start = read_sysreg(cntvct_el0);
>  		test->exec();
> -		isb();
> -		end = read_sysreg(cntvct_el0);
>  
>  		ntimes++;
> -		total_ticks += (end - start);
> -		ticks_to_ns_time(total_ticks, &total_ns);
>  	}
> +	isb();
> +	end = read_sysreg(cntpct_el0);
> +
> +	total_ticks = end - start;
> +	ticks_to_ns_time(total_ticks, &total_ns);

A few notes:

* The counter that is being used has been changed from the physical to the
  virtual counter. Accesses to the physical counter trap on nVHE systems.
  That might not be desirable if what you're after is to reduce latency.

* You need an ISB before reading 'start', otherwise the counter read might be
  reworded earlier in program order.

* Memory loads or stores are not order by using an ISB. If there are memory
  accesses before 'start' is read, you probably want them to be finished before
  the counter is read. Similarly, I don't think there are any restrictions on
  what the test->exec() function is allowed to do, so there might be memory
  accesses as part of the test.

I suggest something like this:

	dsb();	// Wait for loads and stores to complete.
	isb();	// Order the counter read after the DSB.
	start = read_sysreg(cntvct_el0);
	isb();	// Order the counter read before the loop.
	// No DSB needed, as per ARM DDI 0487J.a, page D11-5991.

	/* test loop */

	dsb();	// Wait for loads and stores to complete.
	isb();	// Order the counter read after the DSB.
	end = read_sysreg(cnvct_el0);
	// No DSB or ISB needed, as per ARM DDI 0487J.a, page D11-5991.

Thanks,
Alex

>
>  	if (test->post) {
>  		test->post(ntimes, &total_ticks);
> -- 
> 2.31.1
> 


