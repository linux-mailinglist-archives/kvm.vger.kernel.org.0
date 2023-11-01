Return-Path: <kvm+bounces-294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AFDB7DDEED
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF2D32817A2
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 10:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033C0101E5;
	Wed,  1 Nov 2023 10:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wIGEZrPG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE9DDDB2
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 10:06:38 +0000 (UTC)
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578C2121
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 03:06:33 -0700 (PDT)
Date: Wed, 1 Nov 2023 11:06:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698833189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLPunNIwluMq2Ifk5XXfp2WR0lvQFg847GVDmaPtfFM=;
	b=wIGEZrPGN+3hM0g7pjTQquc2/Be+hQe4PaLDcvOkrP+n/SIIFe8PJcyvK0xuWbSRkVt+cf
	EZOc9ktUB2BaNIXy2PL3xI3SDf+Lfg7nEyJxKgdBtCL5Oc/XaQzjFQrRPV9vaJr7Goy4ZK
	mAALMnylDOH//kwbU7WgiOPs5ebvuWQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?5L2V55C8?= <heqiong1557@phytium.com.cn>
Cc: kvm <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests 1/1] arm64: microbench: Move the read of the
 count register and the ISB operation out of the while loop
Message-ID: <20231101-923f359769ccf8db69c25c4f@orel>
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
X-Migadu-Flow: FLOW_OUT

Hi,

It's quite hard to read this mail because of the formatting. Also, please
do not submit patches as attachments. Despite it being an attachment, I
took a look and it looks fine, but it's missing a signed-off-by.

Please resubmit with this mail as a cover-letter and formatted properly
with line wraps, etc. and the patch, as it's own message, in-reply-to the
cover letter. You may want to use git-send-email.

Thanks,
drew



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
>  
>  	if (test->post) {
>  		test->post(ntimes, &total_ticks);
> -- 
> 2.31.1
> 


