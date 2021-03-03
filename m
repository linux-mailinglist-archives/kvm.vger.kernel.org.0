Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE2832C6B7
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451099AbhCDA3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:55 -0500
Received: from foss.arm.com ([217.140.110.172]:53272 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233875AbhCCRgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 12:36:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57FC131B;
        Wed,  3 Mar 2021 09:36:02 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 894263F7D7;
        Wed,  3 Mar 2021 09:36:01 -0800 (PST)
Date:   Wed, 3 Mar 2021 17:35:57 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 1/6] arm64: Remove unnecessary ISB when
 writing to SPSel
Message-ID: <20210303173557.0626667d@slackpad.fritz.box>
In-Reply-To: <20210227104201.14403-2-alexandru.elisei@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
        <20210227104201.14403-2-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 27 Feb 2021 10:41:56 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Software can use the SPSel operand to write directly to PSTATE.SP.
> According to ARM DDI 0487F.b, page D1-2332, writes to PSTATE are
> self-synchronizing and no ISB is needed:
> 
> "Writes to the PSTATE fields have side-effects on various aspects of the PE
> operation. All of these side-effects are guaranteed:
> - Not to be visible to earlier instructions in the execution stream.
> - To be visible to later instructions in the execution stream."
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

I am always a bit wary about *removing* barriers, but I can confirm
that the ARM ARM indeed makes this guarantee above, and SP access
sounds like an easy enough case, so:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arm/cstart64.S | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 0428014aa58a..fc1930bcdb53 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -54,7 +54,6 @@ start:
>  	/* set up stack */
>  	mov	x4, #1
>  	msr	spsel, x4
> -	isb
>  	adrp    x4, stackptr
>  	add     sp, x4, :lo12:stackptr
>  

