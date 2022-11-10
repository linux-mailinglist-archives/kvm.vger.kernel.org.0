Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4287624A5B
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiKJTKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiKJTKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:10:13 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B924853EF8;
        Thu, 10 Nov 2022 11:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668107324; x=1699643324;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aOltYfGZXNfb4QrtqdeCodHtFaXJI4WUvkI+Z6sZAVI=;
  b=TUFt96ePKwVmj+3NFcrVb+exvZsQDooCi1zjUEcym9bdUZ8vd2c75IZg
   SWzgbKHiWt8uVrALQNbmJkZj9fLgQ4MXlyWy1jbeN2auL8xWkR0dETatz
   gMutMXJe793PpnS079QnnRG8QkQc+69Y2qlTkNdwpx2Zb91vqVGrz7ZnQ
   DKNqeTkYx/WkVx60kmb+5ewc0/PPnRfACUQqrLP6/B2SpiiQA+coqMnOd
   8wQfuv6/T21b3X59li9cmomkPsSW482xS7nzsFrwP0k1Xx06+l6mLPLzB
   4VukqZjeUz2zDTyZ7ru+11NLNSFF6jLsQn/b3Qyo1jGKmMQD4B4RpP5jH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="338173627"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="338173627"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 10:59:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="966529519"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="966529519"
Received: from araj-dh-work.jf.intel.com (HELO araj-dh-work) ([10.165.157.158])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 10:59:14 -0800
Date:   Thu, 10 Nov 2022 18:59:08 +0000
From:   Ashok Raj <ashok_raj@linux.intel.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [RESEND PATCH 1/6] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Message-ID: <Y21J/CehGK7a4Lva@araj-dh-work>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-2-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110061545.1531-2-xin3.li@intel.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 10:15:40PM -0800, Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> IRQ_MOVE_CLEANUP_VECTOR is the only one of the system IRQ vectors that
> is *below* FIRST_SYSTEM_VECTOR. It is a slow path, so just push it
> into common_interrupt() just before the spurios interrupt handling.

nit: 
s/spurios/spurious


> 
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>  arch/x86/kernel/irq.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 766ffe3ba313..7e125fff45ab 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -248,6 +248,10 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
>  	desc = __this_cpu_read(vector_irq[vector]);
>  	if (likely(!IS_ERR_OR_NULL(desc))) {
>  		handle_irq(desc, regs);
> +#ifdef CONFIG_SMP
> +	} else if (vector == IRQ_MOVE_CLEANUP_VECTOR) {
> +		sysvec_irq_move_cleanup(regs);
> +#endif
>  	} else {
>  		ack_APIC_irq();
>  
> -- 
> 2.34.1
> 
