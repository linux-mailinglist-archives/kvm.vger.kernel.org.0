Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629E16A6C1F
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 13:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjCAMJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 07:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCAMJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 07:09:09 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E997D9B;
        Wed,  1 Mar 2023 04:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1677672476; i=erbse.13@gmx.de;
        bh=jW9QqbNiXOx9cSB+L+BuNqUp884nAnRhvACcY0amjgY=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Tb5LO9l1Y3HYnpzuLYsuCG63NhqCbi3sA+tRcO2vCiYIPN6laSjLD0NiLX93T2pFg
         K2eVPQeZJ5y49yPGgtQnZYwvuctg9Jj1MhWCWL2JKFMolG69d5YPlhGQyPnxvTpv7J
         RFcGw1y6222RDmLkNqhZn3RunlK5Mjr7thpnnynN7ZbkYONdFaFuPL8lG15qj187ex
         NxAAjA9yRUhS8ZNZEuTlSFnNAdphzpc5RnyewkF5xKtchnJZIwHI5/a5q7z7SCksGi
         mXshF9eYo79WPYnBmSZ9Id35VkznJP7uPVhs/i7cu0AGuVEXMoTGocCe91x7TFQx/N
         MbgUeus/LfVsw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([134.147.116.198]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MORAa-1p7SOg1pde-00Pxza; Wed, 01
 Mar 2023 13:07:56 +0100
Date:   Wed, 1 Mar 2023 13:07:47 +0100
From:   Tom Dohrmann <erbse.13@gmx.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 15/56] x86/sev: Invalidate pages from the direct
 map when adding them to the RMP table
Message-ID: <Y/9AEyiMLKfj+/mK@notebook>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-16-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220183847.59159-16-michael.roth@amd.com>
X-Provags-ID: V03:K1:QAZfbcKAW91F2JHdCAu5cRq7q3g4qY9Nr1ls991Uxd34cj28wu4
 gFgR+oTH8ZbPRHLZpBhl4NYmMW8WX2lBFowFZhD5+jFThO3mMnNTgmEBNRiYbYonDMhOz+R
 zjLWYNL6TgjNmzKfnzwCu+728YITrxzAsF4A1hUmwF6jjASlkSwhevasq+/XUPFeziAS9iA
 lCQJWTRgA4V/DccUsgqTQ==
UI-OutboundReport: notjunk:1;M01:P0:1Jgywx4vEhk=;2NZfYQAX5/O0Apb5Etjyh5/d2qh
 eoZenyL9fVz4LLWYn1aL6JAUcleXQbzD+mOwwVtCG+S25b4ODoMeXnKTCJwyr5AawnOintaUY
 3eOl3NoC9v9Loic97MjO5ALcja6B+siNBQs+3FAbNfGYjT9IGhdFKXwpic6nW/HPEb1Wf80Rx
 GZuP5Nhwpp5EcJcdrhCFe0yJFUQRh5mBOILWXiNLqI3VIdhaF1cRCKRAUm9zttvfiklJfELAJ
 g/ccPpWbfxd8fvZtWHGjAQ5bDY3YMnumdeK/klor4tDCjYUxXtAU8SGV4peI9JDW8ApKwpNot
 /D/jvOrh5uC+Dbyjw5TDtmrl9MRrzonWkVlnyi9CD/vt/IX5K2caSov+eUinh9QJolwJngSBY
 YuM2FoYztSiTU/cetwl0vlGctwwdeY+H0E7mG7cTjCkrgRwPrTGj4e3Hf5JbBGw/eFOZdHovG
 9c7tW/eIn+kBZA1tNK1KXXOSgFnyov3ZiH7Qbmjl0QCtcVapnDBwJYzuVSK4PBFit+ZCYggO5
 OBDhItKwjvKj/t6OD1xwRvr+pxRm3zHL5o3+PB7WcU19ImxJ6V+vkjTmsUMN52M+QsDQk4eFi
 3C2KMwlC7Xfk/ypUcAWyFQS/iuWhx52WdKnxJL/OfEsqLiHhVrx0cB6jOp5d9ckbFhw4yfCZn
 y26KcJ6psULQkv1vhyCt+xsBsEdtoD/YGZtssqQeuHOwaC6mN9gPLDno/aMIv+3kxkYOJMeGg
 EXeyUze3ZSF0P6gyvpvFSIZvesTGINW83Z2EV6a3M2S9eb5AUYRcZ1Zc12Pm5UG/+r8IMohPP
 ykUXcdbRW7eapvjEGlKeqGEOdrxcL/F7iN7DYoLyyG4agX00F/MhT8cQvPy7iAbSbKehuoSZQ
 wWlBDcl+8bI+Hv+v54K2msu5Tn7jADDoaLZqOQx29HKGdYL1Xi7SGEKh+CnJGHzr8kt+D2gm3
 eOolEjxJ36f6NoUOuJNRQvUe3Co=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 12:38:06PM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The integrity guarantee of SEV-SNP is enforced through the RMP table.
> The RMP is used with standard x86 and IOMMU page tables to enforce
> memory restrictions and page access rights. The RMP check is enforced as
> soon as SEV-SNP is enabled globally in the system. When hardware
> encounters an RMP-check failure, it raises a page-fault exception.
>
> The rmp_make_private() and rmp_make_shared() helpers are used to add
> or remove the pages from the RMP table. Improve the rmp_make_private()
> to invalidate state so that pages cannot be used in the direct-map after
> they are added the RMP table, and restored to their default valid
> permission after the pages are removed from the RMP table.
>
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kernel/sev.c | 57 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
>
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index a49f30c10dc1..3e5ff5934e83 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2595,6 +2595,37 @@ int psmash(u64 pfn)
>  }
>  EXPORT_SYMBOL_GPL(psmash);
>
> +static int restore_direct_map(u64 pfn, int npages)
> +{
> +	int i, ret =3D 0;
> +
> +	for (i =3D 0; i < npages; i++) {
> +		ret =3D set_direct_map_default_noflush(pfn_to_page(pfn + i));
> +		if (ret)
> +			goto cleanup;
> +	}
> +
> +cleanup:
> +	WARN(ret > 0, "Failed to restore direct map for pfn 0x%llx\n", pfn + i=
);
> +	return ret;
> +}
> +
> +static int invalidate_direct_map(u64 pfn, int npages)
> +{
> +	int i, ret =3D 0;
> +
> +	for (i =3D 0; i < npages; i++) {
> +		ret =3D set_direct_map_invalid_noflush(pfn_to_page(pfn + i));
> +		if (ret)
> +			goto cleanup;
> +	}
> +
> +cleanup:
> +	WARN(ret > 0, "Failed to invalidate direct map for pfn 0x%llx\n", pfn =
+ i);
> +	restore_direct_map(pfn, i);

This immediately restores the direct map after invalidating it. It
probably needs to put behind if(ret).

Regards, Tom

> +	return ret;
> +}
> +
>  static int rmpupdate(u64 pfn, struct rmp_state *val)
>  {
>  	int max_attempts =3D 4 * num_present_cpus();
> @@ -2605,6 +2636,21 @@ static int rmpupdate(u64 pfn, struct rmp_state *v=
al)
>  	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>  		return -ENXIO;
>
> +	level =3D RMP_TO_X86_PG_LEVEL(val->pagesize);
> +	npages =3D page_level_size(level) / PAGE_SIZE;
> +
> +	/*
> +	 * If page is getting assigned in the RMP table then unmap it from the
> +	 * direct map.
> +	 */
> +	if (val->assigned) {
> +		if (invalidate_direct_map(pfn, npages)) {
> +			pr_err("Failed to unmap %d pages at pfn 0x%llx from the direct_map\n=
",
> +			       npages, pfn);
> +			return -EFAULT;
> +		}
> +	}
> +
>  	do {
>  		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
>  		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> @@ -2630,6 +2676,17 @@ static int rmpupdate(u64 pfn, struct rmp_state *v=
al)
>  			 attempts, val->asid, ret, pfn, npages);
>  	}
>
> +	/*
> +	 * Restore the direct map after the page is removed from the RMP table=
.
> +	 */
> +	if (!val->assigned) {
> +		if (restore_direct_map(pfn, npages)) {
> +			pr_err("Failed to map %d pages at pfn 0x%llx into the direct_map\n",
> +			       npages, pfn);
> +			return -EFAULT;
> +		}
> +	}
> +
>  	return 0;
>  }
>
> --
> 2.25.1
>
