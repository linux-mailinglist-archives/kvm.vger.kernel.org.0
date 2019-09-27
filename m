Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCEFC0551
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 14:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfI0MkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 08:40:20 -0400
Received: from foss.arm.com ([217.140.110.172]:51226 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0MkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 08:40:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83C8B1000;
        Fri, 27 Sep 2019 05:40:19 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D06FF3F67D;
        Fri, 27 Sep 2019 05:40:18 -0700 (PDT)
Date:   Fri, 27 Sep 2019 13:40:16 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: gic: check_acked: add test
 description
Message-ID: <20190927134016.3d137629@donnerap.cambridge.arm.com>
In-Reply-To: <20190927121845.wjes372uf2hhw2wz@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
        <20190927104227.253466-2-andre.przywara@arm.com>
        <20190927121845.wjes372uf2hhw2wz@kamzik.brq.redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Sep 2019 14:18:45 +0200
Andrew Jones <drjones@redhat.com> wrote:

Hi,

> On Fri, Sep 27, 2019 at 11:42:22AM +0100, Andre Przywara wrote:
> > At the moment the check_acked() IRQ helper function just prints a
> > generic "Completed" or "Timed out" message, without given a more
> > detailed test description.
> > 
> > To be able to tell the different IRQ tests apart, and also to allow
> > re-using it more easily, add a "description" parameter string,
> > which is prefixing the output line. This gives more information on what
> > exactly was tested.
> > 
> > This also splits the variable output part of the line (duration of IRQ
> > delivery) into a separate INFO: line, to not confuse testing frameworks.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm/gic.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arm/gic.c b/arm/gic.c
> > index ed5642e..6fd5e5e 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -60,7 +60,7 @@ static void stats_reset(void)
> >  	smp_wmb();
> >  }
> >  
> > -static void check_acked(cpumask_t *mask)
> > +static void check_acked(const char *testname, cpumask_t *mask)
> >  {
> >  	int missing = 0, extra = 0, unexpected = 0;
> >  	int nr_pass, cpu, i;
> > @@ -88,7 +88,9 @@ static void check_acked(cpumask_t *mask)
> >  			}
> >  		}
> >  		if (nr_pass == nr_cpus) {
> > -			report("Completed in %d ms", !bad, ++i * 100);
> > +			report("%s", !bad, testname);
> > +			if (i)
> > +				report_info("took more than %d ms", i * 100);  
> 
> Any reason for dropping the '++'? Without it we don't account for the last
> 100 ms.

Actually we expect the interrupt to either fire immediately, or to not fire at all (timeout). So the previous message of "Completed in 100 ms" was somewhat misleading, because this was just due to the mdelay(100) above, and the IRQ was most probably delivered before this delay loop even started.

I had "took less than ++i *100 ms" before (and can revert to that if you like), but then figured that filtering for the most common case (immediate delivery) is more useful.

> 
> >  			return;
> >  		}
> >  	}
> > @@ -105,8 +107,9 @@ static void check_acked(cpumask_t *mask)
> >  		}
> >  	}
> >  
> > -	report("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
> > -	       false, missing, extra, unexpected);
> > +	report("%s", false, testname);
> > +	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
> > +		    missing, extra, unexpected);
> >  }
> >  
> >  static void check_spurious(void)
> > @@ -185,7 +188,7 @@ static void ipi_test_self(void)
> >  	cpumask_clear(&mask);
> >  	cpumask_set_cpu(smp_processor_id(), &mask);
> >  	gic->ipi.send_self();
> > -	check_acked(&mask);
> > +	check_acked("IPI to self", &mask);  
> 
> Could even do "IPI: self"
>               "IPI: directed"
>               "IPI: broadcast"
> 
> to improve parsibility

Indeed.

Thanks for having a look!

Cheers,
Andre.



> 
> >  	report_prefix_pop();
> >  }
> >  
> > @@ -200,7 +203,7 @@ static void ipi_test_smp(void)
> >  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
> >  		cpumask_clear_cpu(i, &mask);
> >  	gic_ipi_send_mask(IPI_IRQ, &mask);
> > -	check_acked(&mask);
> > +	check_acked("directed IPI", &mask);
> >  	report_prefix_pop();
> >  
> >  	report_prefix_push("broadcast");
> > @@ -208,7 +211,7 @@ static void ipi_test_smp(void)
> >  	cpumask_copy(&mask, &cpu_present_mask);
> >  	cpumask_clear_cpu(smp_processor_id(), &mask);
> >  	gic->ipi.send_broadcast();
> > -	check_acked(&mask);
> > +	check_acked("IPI broadcast", &mask);
> >  	report_prefix_pop();
> >  }
> >  
> > -- 
> > 2.17.1
> >  
> 
> Thanks,
> drew 

