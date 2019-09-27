Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD43C05C9
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfI0MzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 08:55:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0MzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 08:55:06 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04ADB1F58E;
        Fri, 27 Sep 2019 12:55:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC7FA1001938;
        Fri, 27 Sep 2019 12:55:03 +0000 (UTC)
Date:   Fri, 27 Sep 2019 14:55:01 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: gic: check_acked: add test
 description
Message-ID: <20190927125501.4ikcg6mdrgolpeu6@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-2-andre.przywara@arm.com>
 <20190927121845.wjes372uf2hhw2wz@kamzik.brq.redhat.com>
 <20190927134016.3d137629@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927134016.3d137629@donnerap.cambridge.arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 27 Sep 2019 12:55:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 01:40:16PM +0100, Andre Przywara wrote:
> On Fri, 27 Sep 2019 14:18:45 +0200
> Andrew Jones <drjones@redhat.com> wrote:
> 
> Hi,
> 
> > On Fri, Sep 27, 2019 at 11:42:22AM +0100, Andre Przywara wrote:
> > > At the moment the check_acked() IRQ helper function just prints a
> > > generic "Completed" or "Timed out" message, without given a more
> > > detailed test description.
> > > 
> > > To be able to tell the different IRQ tests apart, and also to allow
> > > re-using it more easily, add a "description" parameter string,
> > > which is prefixing the output line. This gives more information on what
> > > exactly was tested.
> > > 
> > > This also splits the variable output part of the line (duration of IRQ
> > > delivery) into a separate INFO: line, to not confuse testing frameworks.
> > > 
> > > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > > ---
> > >  arm/gic.c | 17 ++++++++++-------
> > >  1 file changed, 10 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arm/gic.c b/arm/gic.c
> > > index ed5642e..6fd5e5e 100644
> > > --- a/arm/gic.c
> > > +++ b/arm/gic.c
> > > @@ -60,7 +60,7 @@ static void stats_reset(void)
> > >  	smp_wmb();
> > >  }
> > >  
> > > -static void check_acked(cpumask_t *mask)
> > > +static void check_acked(const char *testname, cpumask_t *mask)
> > >  {
> > >  	int missing = 0, extra = 0, unexpected = 0;
> > >  	int nr_pass, cpu, i;
> > > @@ -88,7 +88,9 @@ static void check_acked(cpumask_t *mask)
> > >  			}
> > >  		}
> > >  		if (nr_pass == nr_cpus) {
> > > -			report("Completed in %d ms", !bad, ++i * 100);
> > > +			report("%s", !bad, testname);
> > > +			if (i)
> > > +				report_info("took more than %d ms", i * 100);  
> > 
> > Any reason for dropping the '++'? Without it we don't account for the last
> > 100 ms.
> 
> Actually we expect the interrupt to either fire immediately, or to not fire at all (timeout). So the previous message of "Completed in 100 ms" was somewhat misleading, because this was just due to the mdelay(100) above, and the IRQ was most probably delivered before this delay loop even started.
> 
> I had "took less than ++i *100 ms" before (and can revert to that if you like), but then figured that filtering for the most common case (immediate delivery) is more useful.

OK, with that argument we can leave the '++' off.

Thanks,
drew
