Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD9D479EE
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 08:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfFQGQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 02:16:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49819 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfFQGQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 02:16:15 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45S1Ds52mKz9sN4; Mon, 17 Jun 2019 16:16:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560752173; bh=BfRpAModXR8tXIi6RYOirDbI3DXYGaFUuTy9scjmSuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bMdmQ09XCEOlI4FjRKObT5b4KJxEIn36wtYr0X0JdRKAbr2Vsam4P2Egv7srA5gsL
         Q6sMi9gxI6IUPXdjfmyln+uTHIb8SyRsBoK++TfgzxnVAPErBtKfGBOYflkOEYGMA0
         8oK3z4aMGK4QB/iq69cpc1lSoCZ5nQ+/2cxe6RKP9zOOxP7dbuuQ3p57/jMdei0C3d
         T58sJgC22PzPnTUeJh20CQ6rCwRMSBTNAl7KQReJJA+HaOAkWS0Xh9IcdgskMUZYUu
         mfR39UmgMZFeSEehyla2phYbkngpakMSKYUVlJwXPHdDN/BKwiyxmdQ9S74Ge+Qm1T
         Avp+wn5WAuL3Q==
Date:   Mon, 17 Jun 2019 16:16:08 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        david@gibson.dropbear.id.au, aik@ozlabs.ru
Subject: Re: [PATCH v2] KVM: PPC: Report single stepping capability
Message-ID: <20190617061608.y5qw26i53si76qqt@oak.ozlabs.ibm.com>
References: <20190529222219.27994-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529222219.27994-1-farosas@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 29, 2019 at 07:22:19PM -0300, Fabiano Rosas wrote:
> When calling the KVM_SET_GUEST_DEBUG ioctl, userspace might request
> the next instruction to be single stepped via the
> KVM_GUESTDBG_SINGLESTEP control bit of the kvm_guest_debug structure.
> 
> We currently don't have support for guest single stepping implemented
> in Book3S HV.
> 
> This patch adds the KVM_CAP_PPC_GUEST_DEBUG_SSTEP capability in order
> to inform userspace about the state of single stepping support.

Comment/question below:

> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -538,6 +538,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_IMMEDIATE_EXIT:
>  		r = 1;
>  		break;
> +	case KVM_CAP_PPC_GUEST_DEBUG_SSTEP:
> +#ifdef CONFIG_BOOKE
> +		r = 1;
> +		break;
> +#endif

In the !CONFIG_BOOKE case, this will fall through to code which will
return 0 for HV KVM or 1 for PR KVM.  Is that what was intended?
If so, then why do we need the CONFIG_BOOKE case?  Isn't hv_enabled
always 0 on Book E?

In any case, I think this needs at least a /* fall through */ comment
in the code, and something explicit in the patch description to say
that we intend to return 1 on PR KVM.

Paul.
