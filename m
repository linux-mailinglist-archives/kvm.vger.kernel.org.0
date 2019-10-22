Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9123CDF9FB
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbfJVA70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:59:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59211 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbfJVA70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:59:26 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46xwBg2zFKz9sP4; Tue, 22 Oct 2019 11:59:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571705963; bh=/cWbIec/NNOO7A8EUuS1mohPQfGpWIYlqrsIFTuM/wE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPDqcNvlt+N+3yYNZ3kaNRA5/nn91jwwgZsz5VBUQhFdfGfe5IyPVR1n/WgP/zXF1
         ZlRpCb/mGcUhrC1+sljrwMMoK68t50Yyr7Xyc4pxwRXOIL1DijZgbm8k/SQr2c84N1
         m2SrwPxWhvQnH1C1TMtWkFCd9d8mK/kkhtebhjYiEuwbTn/3hsVa8WGshpa4Iz0bXu
         R15JFAwW8TFs/TMKTiT9tJBIQ0XIFbGOjqsPKgYicyeACfoeJjYt1lSkxvGeGrdAzl
         +gv/W+ZbDN0uA08nzcNZFvRibPay39Az4f328n4UDNZypgoLUdeNpu1LOoMd6elQfb
         UJ6vhxIguWKRA==
Date:   Tue, 22 Oct 2019 11:43:35 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/3] powerpc/kvm/book3e: Replace current->mm by kvm->mm
Message-ID: <20191022004335.GA30981@oak.ozlabs.ibm.com>
References: <20190923212409.7153-1-leonardo@linux.ibm.com>
 <20190923212409.7153-3-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190923212409.7153-3-leonardo@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 06:24:08PM -0300, Leonardo Bras wrote:
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
> 
> Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> ---
>  arch/powerpc/kvm/booke.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index be9a45874194..383108263af5 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -775,7 +775,7 @@ int kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
>  	debug = current->thread.debug;
>  	current->thread.debug = vcpu->arch.dbg_reg;
>  
> -	vcpu->arch.pgdir = current->mm->pgd;
> +	vcpu->arch.pgdir = kvm->mm->pgd;
>  	kvmppc_fix_ee_before_entry();
>  
>  	ret = __kvmppc_vcpu_run(kvm_run, vcpu);

With this patch, I get compile errors for Book E configs:

  CC      arch/powerpc/kvm/booke.o
/home/paulus/kernel/kvm/arch/powerpc/kvm/booke.c: In function ‘kvmppc_vcpu_run’:
/home/paulus/kernel/kvm/arch/powerpc/kvm/booke.c:778:21: error: ‘kvm’ undeclared (first use in this function)
  vcpu->arch.pgdir = kvm->mm->pgd;
                     ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/booke.c:778:21: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:266: arch/powerpc/kvm/booke.o] Error 1
make[2]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:509: arch/powerpc/kvm] Error 2
make[1]: *** [/home/paulus/kernel/kvm/Makefile:1649: arch/powerpc] Error 2
make: *** [/home/paulus/kernel/kvm/Makefile:179: sub-make] Error 2

It seems that you didn't compile-test this patch.

Paul.
