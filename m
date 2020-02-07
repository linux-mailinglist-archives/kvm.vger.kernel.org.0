Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5DA15578A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 13:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBGMTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 07:19:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31566 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726674AbgBGMTw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 07:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581077991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OTNUC9fsNE6VxpNL7r78PwDWNHM+b+0JIyuBMuACd1o=;
        b=A8KyB5Su9G77Uvw2+tiojlwY0ppqMnwGX0bUq8IwwJfNZgkSdTW4BRBxcEXQVaWPNfaKuG
        CyLtNewi7BGR68c+ugHJYgiy+h+6bOqncSldDKeUTEj4PT5WwEQJfW1c5rmXKu+FjnFgcg
        6+hi2ANDbhPdIbpWxvCBuhoE8EZzF78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-L5xCDUqvPKSy6tgTy0YJPw-1; Fri, 07 Feb 2020 07:19:47 -0500
X-MC-Unique: L5xCDUqvPKSy6tgTy0YJPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A17ED108838A;
        Fri,  7 Feb 2020 12:19:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18FEB60BEC;
        Fri,  7 Feb 2020 12:19:40 +0000 (UTC)
Date:   Fri, 7 Feb 2020 13:19:37 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 07/14] arm/arm64: gicv3: Enable/Disable
 LPIs at re-distributor level
Message-ID: <20200207121937.qstc3m55icpcn5rr@kamzik.brq.redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-8-eric.auger@redhat.com>
 <20200207121437.qtvonx2x2xh3dvgc@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207121437.qtvonx2x2xh3dvgc@kamzik.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 01:14:37PM +0100, Andrew Jones wrote:
> On Tue, Jan 28, 2020 at 11:34:52AM +0100, Eric Auger wrote:
> > This helper function controls the signaling of LPIs at
> > redistributor level.
> > 
> > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > 
> > ---
> > 
> > v2 -> v3:
> > - move the helper in lib/arm/gic-v3.c
> > - rename the function with gicv3_lpi_ prefix
> > - s/report_abort/assert
> > ---
> >  lib/arm/asm/gic-v3.h |  1 +
> >  lib/arm/gic-v3.c     | 17 +++++++++++++++++
> >  2 files changed, 18 insertions(+)
> > 
> > diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> > index ec2a6f0..734c0c0 100644
> > --- a/lib/arm/asm/gic-v3.h
> > +++ b/lib/arm/asm/gic-v3.h
> > @@ -96,6 +96,7 @@ extern void gicv3_lpi_set_config(int n, u8 val);
> >  extern u8 gicv3_lpi_get_config(int n);
> >  extern void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set);
> >  extern void gicv3_lpi_alloc_tables(void);
> > +extern void gicv3_lpi_rdist_ctrl(u32 redist, bool set);
> >  
> >  static inline void gicv3_do_wait_for_rwp(void *base)
> >  {
> > diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> > index c33f883..7865d01 100644
> > --- a/lib/arm/gic-v3.c
> > +++ b/lib/arm/gic-v3.c
> > @@ -210,4 +210,21 @@ void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set)
> >  		byte &= ~mask;
> >  	*ptr = byte;
> >  }
> > +
> > +void gicv3_lpi_rdist_ctrl(u32 redist, bool set)
> 
> _set_clr_ ?

No, probably not _set_clr_ here. The function could be
static though, with other functions to enable/disable

void gicv3_lpi_rdist_enable(redist) { gicv3_lpi_rdist_ctrl(redist, true); }
void gicv3_lpi_rdist_disable(redist) { gicv3_lpi_rdist_ctrl(redist, false); }

But whatever.

> 
> > +{
> > +	void *ptr;
> > +	u64 val;
> > +
> > +	assert(redist < nr_cpus);
> > +
> > +	ptr = gicv3_data.redist_base[redist];
> > +	val = readl(ptr + GICR_CTLR);
> > +	if (set)
> > +		val |= GICR_CTLR_ENABLE_LPIS;
> > +	else
> > +		val &= ~GICR_CTLR_ENABLE_LPIS;
> > +	writel(val,  ptr + GICR_CTLR);
> > +}
> >  #endif /* __aarch64__ */
> > +
> 
> stray blank line here
> 
> > -- 
> > 2.20.1
> >
> 
> I'm not sure why this needs its own patch. I could just be part of the
> next patch.
> 
> Thanks,
> drew
> 

