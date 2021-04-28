Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E805B36D5CC
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbhD1KaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238616AbhD1KaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 06:30:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE02613F4;
        Wed, 28 Apr 2021 10:29:28 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lbhRd-009q8t-Vn; Wed, 28 Apr 2021 11:29:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 28 Apr 2021 11:29:25 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, shashi.mallela@linaro.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test into
 KVM and TCG variants
In-Reply-To: <20210428101844.22656-2-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <eaed3c63988513fe2849c2d6f22937af@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.bennee@linaro.org, kvm@vger.kernel.org, shashi.mallela@linaro.org, alexandru.elisei@arm.com, eric.auger@redhat.com, qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-04-28 11:18, Alex Bennée wrote:
> A few of the its-trigger tests rely on IMPDEF behaviour where caches
> aren't flushed before invall events. However TCG emulation doesn't
> model any invall behaviour and as we can't probe for it we need to be
> told. Split the test into a KVM and TCG variant and skip the invall
> tests when under TCG.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Shashi Mallela <shashi.mallela@linaro.org>
> ---
>  arm/gic.c         | 60 +++++++++++++++++++++++++++--------------------
>  arm/unittests.cfg | 11 ++++++++-
>  2 files changed, 45 insertions(+), 26 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 98135ef..96a329d 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -36,6 +36,7 @@ static struct gic *gic;
>  static int acked[NR_CPUS], spurious[NR_CPUS];
>  static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
>  static cpumask_t ready;
> +static bool under_tcg;
> 
>  static void nr_cpu_check(int nr)
>  {
> @@ -734,32 +735,38 @@ static void test_its_trigger(void)
>  	/*
>  	 * re-enable the LPI but willingly do not call invall
>  	 * so the change in config is not taken into account.
> -	 * The LPI should not hit
> +	 * The LPI should not hit. This does however depend on
> +	 * implementation defined behaviour - under QEMU TCG emulation
> +	 * it can quite correctly process the event directly.

It looks to me that you are using an IMPDEF behaviour of *TCG*
here. The programming model mandates that there is an invalidation
if you change the configuration of the LPI.

         M.
-- 
Jazz is not dead. It just smells funny...
