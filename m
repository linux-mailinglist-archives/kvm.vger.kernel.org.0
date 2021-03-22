Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE94E343D8A
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 11:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCVKNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 06:13:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhCVKMm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 06:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616407961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pOGJBjEA44tF10xFCHydnZPtBbjTBxUUqxxaVRKKVvI=;
        b=T7Z87Y/UKBi3fM3xC8RqA9UMFokasHIKmDhfZJZdc39gIWPA+p68mZ4+hT5MRPzAeLGuP0
        5TB61IRlDHPXJhg+XEmSWfTFIeayhFPCziUsGvXC7CiCStr2P65PlNL3kiIcoNpmqKS8E9
        43Zxcu6fhJsOFRfggRXT1J61Z7OJ2Fo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-vSEOePalNDmBrHzAk7LvmA-1; Mon, 22 Mar 2021 06:12:34 -0400
X-MC-Unique: vSEOePalNDmBrHzAk7LvmA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C563801817;
        Mon, 22 Mar 2021 10:12:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4619110023B0;
        Mon, 22 Mar 2021 10:12:32 +0000 (UTC)
Date:   Mon, 22 Mar 2021 11:12:29 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/4] arm/arm64: Avoid calling
 cpumask_test_cpu for CPUs above nr_cpu
Message-ID: <20210322101229.5f4epjxjzaq7i5ti@kamzik.brq.redhat.com>
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210319122414.129364-2-nikos.nikoleris@arm.com>
 <20210322093125.qlbr3wjvinyu7o6m@kamzik.brq.redhat.com>
 <df9a70d0-0129-d3a4-9530-77a7354b8e47@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9a70d0-0129-d3a4-9530-77a7354b8e47@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 09:45:09AM +0000, Nikos Nikoleris wrote:
> Hi Drew,
> 
> On 22/03/2021 09:31, Andrew Jones wrote:
> > On Fri, Mar 19, 2021 at 12:24:11PM +0000, Nikos Nikoleris wrote:
> > > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > ---
> > >   lib/arm/asm/cpumask.h | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/lib/arm/asm/cpumask.h b/lib/arm/asm/cpumask.h
> > > index 6683bb6..02124de 100644
> > > --- a/lib/arm/asm/cpumask.h
> > > +++ b/lib/arm/asm/cpumask.h
> > > @@ -105,7 +105,7 @@ static inline void cpumask_copy(cpumask_t *dst, const cpumask_t *src)
> > >   static inline int cpumask_next(int cpu, const cpumask_t *mask)
> > >   {
> > > -	while (cpu < nr_cpus && !cpumask_test_cpu(++cpu, mask))
> > > +	while (++cpu < nr_cpus && !cpumask_test_cpu(cpu, mask))
> > >   		;
> > >   	return cpu;
> > 
> 
> Thanks for reviewing this!
> 
> 
> > This looks like the right thing to do, but I'm surprised that
> > I've never seen an assert in cpumask_test_cpu, even though
> > it looks like we call cpumask_next with cpu == nr_cpus - 1
> > in several places.
> > 
> 
> cpumask_next() would trigger one of the assertions in the 4th patch in this
> series without this fix. The 4th patch is a way to demonstrate (if we apply
> it without the rest) the problem of using cpu0's thread_info->cpu
> uninitialized.

Ah, I see my error. I had already applied your 4th patch but hadn't
reviewed it yet, so I didn't realize it was new code. Now it makes
sense that we didn't hit that assert before (it didn't exist
before :-)

> 
> > Can you please add a commit message explaining how you found
> > this bug?
> > 
> 
> Yes I'll do that.

If you just write one here then I'll add it while applying. The rest of
the patches look good to me. So no need to respin.

Thanks,
drew

