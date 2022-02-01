Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8980A4A60C3
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 16:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240704AbiBAPxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 10:53:24 -0500
Received: from foss.arm.com ([217.140.110.172]:48424 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237890AbiBAPxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 10:53:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB077113E;
        Tue,  1 Feb 2022 07:53:22 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFEBC3F40C;
        Tue,  1 Feb 2022 07:53:21 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:52:51 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH kvmtool 5/5] mmio: Sanitize addr and len
Message-ID: <20220201155251.78749967@donnerap.cambridge.arm.com>
In-Reply-To: <429afc3bf48379e3e981c3e63325cb83f8991e20.1642457047.git.martin.b.radev@gmail.com>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
        <429afc3bf48379e3e981c3e63325cb83f8991e20.1642457047.git.martin.b.radev@gmail.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jan 2022 00:12:03 +0200
Martin Radev <martin.b.radev@gmail.com> wrote:

> This patch verifies that adding the addr and length arguments
> from an MMIO op do not overflow. This is necessary because the
> arguments are controlled by the VM. The length may be set to
> an arbitrary value by using the rep prefix.

Mmh, interesting, so does the kernel collate this into one
"giant" KVM_EXIT_MMIO with an arbitrary length? I wonder if there are
assumptions in the MMIO code of len never being bigger than say 16. On
ARM/ARM64 we probably never see len being bigger than 8 on those exits.

But the check is certainly fine anyway...

> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks,
Andre

> ---
>  mmio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mmio.c b/mmio.c
> index a6dd3aa..04d2af6 100644
> --- a/mmio.c
> +++ b/mmio.c
> @@ -32,6 +32,10 @@ static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
>  {
>  	struct rb_int_node *node;
>  
> +	/* If len is zero or if there's an overflow, the MMIO op is invalid. */
> +	if (len + addr <= addr)
> +		return NULL;
> +
>  	node = rb_int_search_range(root, addr, addr + len);
>  	if (node == NULL)
>  		return NULL;

