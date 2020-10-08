Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D733328737C
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 13:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgJHLly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 07:41:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50112 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgJHLlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 07:41:53 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602157311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=g/Jsl2uiLHc5Ap/XsgGvFNBsexXIvrGHdTQCU932ay8=;
        b=NLI4ht9hPipTJL7lPMkN0/FPnzHSkHh/qVPybdaKy4cZHuMGVo6SGcMI0QRxE78HSw7KU9
        xhjBVBLmi0B1qVtZLsssyt6pF6DpWEU/rT7G2vPDUCTlsHbLQmP3nR1EUKRNS/yl/QDYOi
        z59lwiKcS9RvQW9D28x//5NSP+fVNWgsJr78r6OQp7qSiAseOBRXcCScJL03VKbo7IKEdD
        c+8HHiS8tydDZE5Ad8Q1Rp0RHjoZ9Tpk2ItI5dilQFoN71Nl9CyFKs07jFRVZBQXCA4Yld
        HqIFNMNwYEj4lNIv3fW8+rEX5NMMD5nSLgPhwy0WOak2ZmjnmzY+eYn8MdYzxA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602157311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=g/Jsl2uiLHc5Ap/XsgGvFNBsexXIvrGHdTQCU932ay8=;
        b=U8An+/slO+j8wcwzLvODp2mnjnASz1wb1qBsazXKYwy+aKotNzFfaCq6BVAiNonk7YFCEM
        MjcGIXZWCK8xBABQ==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86/ioapic: Handle Extended Destination ID field in RTE
In-Reply-To: <20201007122046.1113577-3-dwmw2@infradead.org>
Date:   Thu, 08 Oct 2020 13:41:51 +0200
Message-ID: <87o8ldvta8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 13:20, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> The IOAPIC Redirection Table Entries contain an 8-bit Extended
> Destination ID field which maps to bits 11-4 of the MSI address.
>
> The lowest bit is used to indicate remappable format, when interrupt
> remapping is in use. A hypervisor can use the other 7 bits to permit
> guests to address up to 15 bits of APIC IDs, thus allowing 32768 vCPUs
> before having to expose a vIOMMU and interrupt remapping to the guest.
>
> No behavioural change in this patch, since nothing yet permits APIC IDs
> above 255 to be used with the non-IR IOAPIC domain. Except for the case
> where IR is enabled but there are IOAPICs which aren't in the scope of
> any IOMMU, which is totally hosed anyway and needs fixing independently
> of this change.

Again: IOAPICs which are not covered by IR are detected and prevent IR
enablement which makes the above a fairy tale. Changelogs are about
facts.

> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> index a1a26f6d3aa4..e65a0b7379d0 100644
> --- a/arch/x86/include/asm/io_apic.h
> +++ b/arch/x86/include/asm/io_apic.h
> @@ -78,7 +78,8 @@ struct IO_APIC_route_entry {
>  		mask		:  1,	/* 0: enabled, 1: disabled */
>  		__reserved_2	: 15;
>  
> -	__u32	__reserved_3	: 24,
> +	__u32	__reserved_3	: 17,
> +		ext_dest	:  7,

This wants to be explicitely named 'virt_ext_dest'.

Thanks,

        tglx
