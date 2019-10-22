Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25222DFD1E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 07:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbfJVF2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 01:28:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:38073 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbfJVF2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 01:28:22 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46y2904rn7z9sPh; Tue, 22 Oct 2019 16:28:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571722100; bh=p2M3AQlqsAJqlOpYWOhdmQPpGs/Vwl78Ov4vHAcu7rA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JnW7ire2Wv8jCrvNOuI3b35mX1NPHavxSEVxIE6mGTCiBomAgsOWEwAicj1K3JXvI
         dxMZ5HlDJKqwI9043S02oVmTN2fn4jWQBJRRylN465fe2yeNw6L0pIQZjHkgo2SDzD
         lo1upDGS1jVrS0aTEaKDox6Xslr1GQ1Yguw3rcv7GZg7SlmX2naaPyRnTTK5CgCRkU
         Xz/DUSJgUbcw9lOofFP/fRf48AJgi9/p9YxZ70naYtnkRmQ5oH9+hQDS7Yp7YEUUdA
         PsGuIYsDLniFmljesrP2vqwNDH9j7f19xVKEKbgMldhkiyZpriPPVo99xHtXJsiiqd
         HX8aTFCh0tWbw==
Date:   Tue, 22 Oct 2019 16:28:12 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/3] powerpc/kvm/book3s: Replace current->mm by kvm->mm
Message-ID: <20191022052812.GA22958@oak.ozlabs.ibm.com>
References: <20190923212409.7153-1-leonardo@linux.ibm.com>
 <20190923212409.7153-2-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923212409.7153-2-leonardo@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 06:24:07PM -0300, Leonardo Bras wrote:
> Given that in kvm_create_vm() there is:
> kvm->mm = current->mm;
> 
> And that on every kvm_*_ioctl we have:
> if (kvm->mm != current->mm)
> 	return -EIO;
> 
> I see no reason to keep using current->mm instead of kvm->mm.
> 
> By doing so, we would reduce the use of 'global' variables on code, relying
> more in the contents of kvm struct.

This patch led to a crash on shutting down a VM, because of this hunk:

> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index c4b606fe73eb..8069b35f2905 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -255,7 +255,7 @@ static int kvm_spapr_tce_release(struct inode *inode, struct file *filp)
>  
>  	kvm_put_kvm(stt->kvm);
>  
> -	account_locked_vm(current->mm,
> +	account_locked_vm(kvm->mm,
>  		kvmppc_stt_pages(kvmppc_tce_pages(stt->size)), false);

You are referencing kvm->mm after having done kvm_put_kvm a couple of
lines earlier, which means that *kvm can be freed at the point where
you use kvm->mm.  If you want to make this change you will need to
move the kvm_put_kvm call to after the last use of it.

I have dropped this patch for now.

Paul.
