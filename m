Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5271A05C3
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 17:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfH1PKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 11:10:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbfH1PKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 11:10:11 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC13F3091761;
        Wed, 28 Aug 2019 15:10:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C8AD52D2;
        Wed, 28 Aug 2019 15:10:09 +0000 (UTC)
Date:   Wed, 28 Aug 2019 17:10:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 10/16] lib: Add UL and ULL definitions
 to linux/const.h
Message-ID: <20190828151006.x6bfxlseqp5s55su@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-11-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566999511-24916-11-git-send-email-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 28 Aug 2019 15:10:11 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 02:38:25PM +0100, Alexandru Elisei wrote:
> The UL macro was previously defined in lib/arm64/asm/pgtable-hwdef.h. Move
> it to lib/linux/const.h so it can be used in other files. To keep things
> consistent, also add an ULL macro.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/linux/const.h             | 7 +++++--
>  lib/arm64/asm/pgtable-hwdef.h | 2 --
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/linux/const.h b/lib/linux/const.h
> index c872bfd25e13..e3c7fec3f4b8 100644
> --- a/lib/linux/const.h
> +++ b/lib/linux/const.h
> @@ -21,7 +21,10 @@
>  #define _AT(T,X)	((T)(X))
>  #endif
>  
> -#define _BITUL(x)	(_AC(1,UL) << (x))
> -#define _BITULL(x)	(_AC(1,ULL) << (x))
> +#define UL(x) 		_AC(x, UL)
> +#define ULL(x)		_AC(x, ULL)
> +
> +#define _BITUL(x)	(UL(1) << (x))
> +#define _BITULL(x)	(ULL(1) << (x))

I don't mind this, but if we want to keep this file consistent with
Linux's include/uapi/linux/const.h, which is actually the goal, then we
should be adding _UL and _ULL instead. But in that case we'd probably
want to leave the define below.

Thanks,
drew

>  
>  #endif /* !(_LINUX_CONST_H) */
> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
> index 045a3ce12645..e6f02fae4075 100644
> --- a/lib/arm64/asm/pgtable-hwdef.h
> +++ b/lib/arm64/asm/pgtable-hwdef.h
> @@ -9,8 +9,6 @@
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
>  
> -#define UL(x) _AC(x, UL)
> -
>  #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
>  
>  /*
> -- 
> 2.7.4
> 
