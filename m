Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30B62277C3
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 06:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgGUEy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 00:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgGUEy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 00:54:28 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA5FC061794;
        Mon, 20 Jul 2020 21:54:28 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4B9mTt2d5Zz9sSJ; Tue, 21 Jul 2020 14:54:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1595307266; bh=RQE08isQf+lBELg3C8LRhn+T91bIrsMyhyCDly9itjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Udf9255C4Pb0JsIeovrxWm1+Cgw67ckgCelFZEEI5ONfcB529BVnIiUek2+i2mUcA
         cN/1kMZosYyV4sEMOztqQwRWGSS/bhlMtc0tqLWRfHeFmRK8Ql+/I2O7IKYfyzFt+3
         AKRJwhhYdJGxiV7DAi7kE2G41vSv9nto5+xc8i2/meTd3R0EFXIj75Ubt8fp7JCtMw
         JKJGLs1+StWjkodJ88zF4QQbQCkt8z5uswJz16Zvmwh1mdDkVJmkDQ8vBpX2S3Fclf
         OdniE7bhslmcJyWXrig9cq2prnoqonFLNnOFzrN5cAkRgYO3eKkAN0IhS0WSgNwDgu
         657tg8jJG7ynQ==
Date:   Tue, 21 Jul 2020 13:54:20 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        maddy@linux.vnet.ibm.com, mikey@neuling.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        ego@linux.vnet.ibm.com, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org
Subject: Re: [v3 02/15] KVM: PPC: Book3S HV: Cleanup updates for kvm vcpu MMCR
Message-ID: <20200721035420.GA3819606@thinks.paulus.ozlabs.org>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-3-git-send-email-atrajeev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594996707-3727-3-git-send-email-atrajeev@linux.vnet.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 17, 2020 at 10:38:14AM -0400, Athira Rajeev wrote:
> Currently `kvm_vcpu_arch` stores all Monitor Mode Control registers
> in a flat array in order: mmcr0, mmcr1, mmcra, mmcr2, mmcrs
> Split this to give mmcra and mmcrs its own entries in vcpu and
> use a flat array for mmcr0 to mmcr2. This patch implements this
> cleanup to make code easier to read.

Changing the way KVM stores these values internally is fine, but
changing the user ABI is not.  This part:

> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
> index 264e266..e55d847 100644
> --- a/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> @@ -510,8 +510,8 @@ struct kvm_ppc_cpu_char {
>  
>  #define KVM_REG_PPC_MMCR0	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x10)
>  #define KVM_REG_PPC_MMCR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x11)
> -#define KVM_REG_PPC_MMCRA	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x12)
> -#define KVM_REG_PPC_MMCR2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x13)
> +#define KVM_REG_PPC_MMCR2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x12)
> +#define KVM_REG_PPC_MMCRA	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x13)

means that existing userspace programs that used to work would now be
broken.  That is not acceptable (breaking the user ABI is only ever
acceptable with a very compelling reason).  So NAK to this part of the
patch.

Regards,
Paul.
