Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A6E4A6037
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 16:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbiBAPet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 10:34:49 -0500
Received: from foss.arm.com ([217.140.110.172]:47380 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbiBAPer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 10:34:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D119113E;
        Tue,  1 Feb 2022 07:34:47 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DA123F40C;
        Tue,  1 Feb 2022 07:34:46 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:34:54 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool 5/5] mmio: Sanitize addr and len
Message-ID: <YflS+zn1EPpVj8EM@monolith.localdoman>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
 <429afc3bf48379e3e981c3e63325cb83f8991e20.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <429afc3bf48379e3e981c3e63325cb83f8991e20.1642457047.git.martin.b.radev@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Martin,

On Tue, Jan 18, 2022 at 12:12:03AM +0200, Martin Radev wrote:
> This patch verifies that adding the addr and length arguments
> from an MMIO op do not overflow. This is necessary because the
> arguments are controlled by the VM. The length may be set to
> an arbitrary value by using the rep prefix.

The Arm architecture doesn'tt have instructions to access 0 bytes of
memory. By "rep prefix" you mean the x86 rep* instructions, right?

> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
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

Would you mind rewriting the left side of the inequality to addr + len to match
the argument to rb_int_search_range() below?

Otherwise looks good:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> +		return NULL;
> +
>  	node = rb_int_search_range(root, addr, addr + len);
>  	if (node == NULL)
>  		return NULL;
> -- 
> 2.25.1
> 
