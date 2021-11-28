Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E103460426
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 05:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhK1FCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 00:02:13 -0500
Received: from rere.qmqm.pl ([91.227.64.183]:27624 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhK1FAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 00:00:11 -0500
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4J1x6D5pcGz4f;
        Sun, 28 Nov 2021 05:56:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1638075413; bh=Ir3YT3zeL32xImHXMHm+HUkV1uXH+xu9Pk/FdYqejaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qfJt/SEuYDHvacc6G0xjNLwg1Fq717EReqm4qKjJKbJ29nVz4pRzLhvuTEs+OdzmQ
         YBtV69D9aVFvnRVlMgScH974MXYPVrPlxykIPQGi6nNOPfU8kRQpmThuzgG3a1CYgY
         78OZwIEmZp1nYVyJFPH7JKcWetX0Tq4RrwhOe1BNAr0LCbznthHDe87CltKf4hscrH
         sWADjOEt9FmXj+haWSNMnvon1BnukXnjVIZdfR+TS1YetB95pCqlXSq9QBZTNBbDdH
         rZ7A1g9OqzSsLIRp6DvBumXPrVPGV6Vae36X2F9VPlEfprs7mm6t+Np5204AGclKvP
         Nz6Jqvfks862Q==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.3 at mail
Date:   Sun, 28 Nov 2021 05:56:51 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/9] lib/cpumask: add
 num_{possible,present,active}_cpus_{eq,gt,le}
Message-ID: <YaMME60Jfiz5BeJF@qmqm.qmqm.pl>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <20211128035704.270739-8-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211128035704.270739-8-yury.norov@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 27, 2021 at 07:57:02PM -0800, Yury Norov wrote:
> Add num_{possible,present,active}_cpus_{eq,gt,le} and replace num_*_cpus()
> with one of new functions where appropriate. This allows num_*_cpus_*()
> to return earlier depending on the condition.
[...]
> @@ -3193,7 +3193,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
>  
>  	/* allocate pages */
>  	j = 0;
> -	for (unit = 0; unit < num_possible_cpus(); unit++) {
> +	for (unit = 0; num_possible_cpus_gt(unit); unit++) {

This looks dubious. The old version I could hope the compiler would call
num_possible_cpus() only once if it's marked const or pure, but the
alternative is going to count the bits every time making this a guaranteed
O(n^2) even though the bitmap doesn't change.

Best Regards
Micha³ Miros³aw
