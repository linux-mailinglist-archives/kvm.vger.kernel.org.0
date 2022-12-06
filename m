Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421A7644514
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiLFN47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiLFN4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:56:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89952CDC0
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 05:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670334961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4oz5S+plKf6L2SEwXLgW2hiN1Y4hoTJzX657+agsr4o=;
        b=Gkr5DcGUPEzwTdauciwLU2HeGl1a16L4enEtfqauD4hxw7GJZLwLFj2YM8fTUn9TgXHthO
        F21x5tYI6Y+4oDU9DIYrH29Dyw0/Sskl0jO+lChasjy+nsFPk/VUAZGl732+T8d3IJIQew
        mCPDh/y6nXP+P3fSp/Kk9ukVu9vZn8g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-MBcctp_aMqq4wOGqQO74jQ-1; Tue, 06 Dec 2022 08:55:58 -0500
X-MC-Unique: MBcctp_aMqq4wOGqQO74jQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20D12282382F;
        Tue,  6 Dec 2022 13:55:58 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FB324EA53;
        Tue,  6 Dec 2022 13:55:54 +0000 (UTC)
Message-ID: <82ff8b2d6e2036c3fab19e103f4b90144ba1176e.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 01/27] x86: replace
 irq_{enable|disable}() with sti()/cli()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Date:   Tue, 06 Dec 2022 15:55:52 +0200
In-Reply-To: <332e7d94-4a3b-40d1-dc66-fa296e8d322e@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
         <20221122161152.293072-2-mlevitsk@redhat.com>
         <332e7d94-4a3b-40d1-dc66-fa296e8d322e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-12-01 at 14:46 +0100, Emanuele Giuseppe Esposito wrote:
> 
> Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> > This removes a layer of indirection which is strictly
> > speaking not needed since its x86 code anyway.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  lib/x86/processor.h       | 19 +++++-----------
> >  lib/x86/smp.c             |  2 +-
> >  x86/apic.c                |  2 +-
> >  x86/asyncpf.c             |  6 ++---
> >  x86/eventinj.c            | 22 +++++++++---------
> >  x86/hyperv_connections.c  |  2 +-
> >  x86/hyperv_stimer.c       |  4 ++--
> >  x86/hyperv_synic.c        |  6 ++---
> >  x86/intel-iommu.c         |  2 +-
> >  x86/ioapic.c              | 14 ++++++------
> >  x86/pmu.c                 |  4 ++--
> >  x86/svm.c                 |  4 ++--
> >  x86/svm_tests.c           | 48 +++++++++++++++++++--------------------
> >  x86/taskswitch2.c         |  4 ++--
> >  x86/tscdeadline_latency.c |  4 ++--
> >  x86/vmexit.c              | 18 +++++++--------
> >  x86/vmx_tests.c           | 42 +++++++++++++++++-----------------
> >  17 files changed, 98 insertions(+), 105 deletions(-)
> > 
> > diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> > index 7a9e8c82..b89f6a7c 100644
> > --- a/lib/x86/processor.h
> > +++ b/lib/x86/processor.h
> > @@ -653,11 +653,17 @@ static inline void pause(void)
> >  	asm volatile ("pause");
> >  }
> >  
> > +/* Disable interrupts as per x86 spec */
> >  static inline void cli(void)
> >  {
> >  	asm volatile ("cli");
> >  }
> >  
> > +/*
> > + * Enable interrupts.
> > + * Note that next instruction after sti will not have interrupts
> > + * evaluated due to concept of 'interrupt shadow'
> > + */
> >  static inline void sti(void)
> >  {
> >  	asm volatile ("sti");
> > @@ -732,19 +738,6 @@ static inline void wrtsc(u64 tsc)
> >  	wrmsr(MSR_IA32_TSC, tsc);
> >  }
> >  
> > -static inline void irq_disable(void)
> > -{
> > -	asm volatile("cli");
> > -}
> > -
> > -/* Note that irq_enable() does not ensure an interrupt shadow due
> > - * to the vagaries of compiler optimizations.  If you need the
> > - * shadow, use a single asm with "sti" and the instruction after it.
> Minor nitpick: instead of a new doc comment, why not use this same
> above? Looks clearer to me.
> 
> Regardless,
> Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> 

I am not 100% sure what you mean.
Note that cli() doesn't have the same interrupt window thing as sti().

Best regards,
	Maxim Levitsky

