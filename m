Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44740C052A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfI0MbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 08:31:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfI0MbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 08:31:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A6E0191864C;
        Fri, 27 Sep 2019 12:31:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B1575D6A7;
        Fri, 27 Sep 2019 12:31:20 +0000 (UTC)
Date:   Fri, 27 Sep 2019 14:31:18 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 6/6] arm: Add missing test name prefix
 calls
Message-ID: <20190927123118.mbp3ybviz6xve7qr@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-7-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927104227.253466-7-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Fri, 27 Sep 2019 12:31:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 11:42:27AM +0100, Andre Przywara wrote:
> When running the unit tests in TAP mode (./run_tests.sh -t), every single
> test result is printed. This works fine for most tests which use the
> reporting prefix feature to indicate the actual test name.
> However psci and pci were missing those names, so the reporting left
> people scratching their head what was actually tested:
> ...
> ok 74 - invalid-function
> ok 75 - affinity-info-on
> ok 76 - affinity-info-off
> ok 77 - cpu-on
> 
> Push a "psci" prefix before running those tests to make those report
> lines more descriptive.
> While at it, do the same for pci, even though it is less ambigious there.
> Also the GIC ITARGETSR test was missing a report_prefix_pop().
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c      | 2 ++
>  arm/pci-test.c | 2 ++
>  arm/psci.c     | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 66dcafe..ebb6ea2 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -480,6 +480,8 @@ static void test_targets(int nr_irqs)
>  	test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
>  
>  	writel(orig_targets, targetsptr + GIC_FIRST_SPI);
> +
> +	report_prefix_pop();
>  }
>  
>  static void gic_test_mmio(void)
> diff --git a/arm/pci-test.c b/arm/pci-test.c
> index cf128ac..7c3836e 100644
> --- a/arm/pci-test.c
> +++ b/arm/pci-test.c
> @@ -19,6 +19,8 @@ int main(void)
>  		return report_summary();
>  	}
>  
> +	report_prefix_push("pci");
> +
>  	pci_print();
>  
>  	ret = pci_testdev();
> diff --git a/arm/psci.c b/arm/psci.c
> index 5cb4d5c..536c9b7 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -126,6 +126,8 @@ int main(void)
>  {
>  	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
>  
> +	report_prefix_push("psci");
> +
>  	if (nr_cpus < 2) {
>  		report_skip("At least 2 cpus required");
>  		goto done;
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
