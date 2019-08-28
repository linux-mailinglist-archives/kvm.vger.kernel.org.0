Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0249A071E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfH1QTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 12:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfH1QTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 12:19:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17B255AFDE;
        Wed, 28 Aug 2019 16:19:25 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D8F05D9C9;
        Wed, 28 Aug 2019 16:19:23 +0000 (UTC)
Date:   Wed, 28 Aug 2019 18:19:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 10/16] lib: Add UL and ULL definitions
 to linux/const.h
Message-ID: <20190828161920.6w7jfl7gcofozun7@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-11-git-send-email-alexandru.elisei@arm.com>
 <20190828151006.x6bfxlseqp5s55su@kamzik.brq.redhat.com>
 <c476a2cc-98d7-6315-a742-df252ff56be5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c476a2cc-98d7-6315-a742-df252ff56be5@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 28 Aug 2019 16:19:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 04:46:04PM +0100, Alexandru Elisei wrote:
> On 8/28/19 4:10 PM, Andrew Jones wrote:
> > On Wed, Aug 28, 2019 at 02:38:25PM +0100, Alexandru Elisei wrote:
> >> The UL macro was previously defined in lib/arm64/asm/pgtable-hwdef.h. Move
> >> it to lib/linux/const.h so it can be used in other files. To keep things
> >> consistent, also add an ULL macro.
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  lib/linux/const.h             | 7 +++++--
> >>  lib/arm64/asm/pgtable-hwdef.h | 2 --
> >>  2 files changed, 5 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/lib/linux/const.h b/lib/linux/const.h
> >> index c872bfd25e13..e3c7fec3f4b8 100644
> >> --- a/lib/linux/const.h
> >> +++ b/lib/linux/const.h
> >> @@ -21,7 +21,10 @@
> >>  #define _AT(T,X)	((T)(X))
> >>  #endif
> >>  
> >> -#define _BITUL(x)	(_AC(1,UL) << (x))
> >> -#define _BITULL(x)	(_AC(1,ULL) << (x))
> >> +#define UL(x) 		_AC(x, UL)
> >> +#define ULL(x)		_AC(x, ULL)
> >> +
> >> +#define _BITUL(x)	(UL(1) << (x))
> >> +#define _BITULL(x)	(ULL(1) << (x))
> > I don't mind this, but if we want to keep this file consistent with
> > Linux's include/uapi/linux/const.h, which is actually the goal, then we
> > should be adding _UL and _ULL instead. But in that case we'd probably
> > want to leave the define below.
> >
> > Thanks,
> > drew
> 
> Hm... The next patch needs the UL define. Consistency is good, so if we want to
> keep it consistent with include/uapi/linux/const.h, then I will change the
> defines (and the uses) to _UL and _ULL, if that's fine with you.

Yeah, I think that's best.

Thanks,
drew

> 
> Thanks,
> Alex
> >
> >>  
> >>  #endif /* !(_LINUX_CONST_H) */
> >> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
> >> index 045a3ce12645..e6f02fae4075 100644
> >> --- a/lib/arm64/asm/pgtable-hwdef.h
> >> +++ b/lib/arm64/asm/pgtable-hwdef.h
> >> @@ -9,8 +9,6 @@
> >>   * This work is licensed under the terms of the GNU GPL, version 2.
> >>   */
> >>  
> >> -#define UL(x) _AC(x, UL)
> >> -
> >>  #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
> >>  
> >>  /*
> >> -- 
> >> 2.7.4
> >>
