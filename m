Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D86745D85
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 15:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjGCNeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 09:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjGCNd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 09:33:59 -0400
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B1CE3;
        Mon,  3 Jul 2023 06:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1688391234; x=1719927234;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MZnqhy/csMNXbugFtNWNDpN2XhhdE1oePTXoQDzZgeU=;
  b=j8+tx2eMFLT0PgwFTtZQw0kVMx7+H3or39OowaVAvarHLB94Ff9it+IS
   duh+gLFsqCyy7aOa1ZVQHI6hreQPGkwd6Zrj323xnraG3MfdOEr/cX9C4
   v4t3EFDFN/0tqyJGreFuxthm2ekcMxamrxM+w+yaoQsqVXxyCnYnABsdg
   c=;
X-IronPort-AV: E=Sophos;i="6.01,178,1684800000"; 
   d="scan'208";a="657678907"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 13:33:49 +0000
Received: from EX19D010EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id 226AA40D4B;
        Mon,  3 Jul 2023 13:33:47 +0000 (UTC)
Received: from EX19D033EUC004.ant.amazon.com (10.252.61.133) by
 EX19D010EUA004.ant.amazon.com (10.252.50.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Mon, 3 Jul 2023 13:33:40 +0000
Received: from u40bc5e070a0153.ant.amazon.com (10.1.212.14) by
 EX19D033EUC004.ant.amazon.com (10.252.61.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Mon, 3 Jul 2023 13:33:35 +0000
Date:   Mon, 3 Jul 2023 15:33:29 +0200
From:   Roman Kagan <rkagan@amazon.de>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Borislav Petkov" <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
Message-ID: <ZKLOKc1RbfLyQz7H@u40bc5e070a0153.ant.amazon.com>
Mail-Followup-To: Roman Kagan <rkagan@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>, Mingwei Zhang <mizhang@google.com>
References: <20230504120042.785651-1-rkagan@amazon.de>
 <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com>
 <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com>
 <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <ZJ74gELkj4DgAk4S@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJ74gELkj4DgAk4S@google.com>
X-Originating-IP: [10.1.212.14]
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D033EUC004.ant.amazon.com (10.252.61.133)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 08:45:04AM -0700, Sean Christopherson wrote:
> On Fri, Jun 30, 2023, Roman Kagan wrote:
> > On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote:
> > > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wrote:
> > > > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
> > > > >         return counter & pmc_bitmask(pmc);
> > > > >  }
> > > > >
> > > > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
> > > > > +{
> > > > > +       if (pmc->perf_event && !pmc->is_paused)
> > > > > +               perf_event_set_count(pmc->perf_event, val);
> > > > > +
> > > > > +       pmc->counter = val;
> > > >
> > > > Doesn't this still have the original problem of storing wider value than
> > > > allowed?
> > >
> > > Yes, this was just to fix the counter offset weirdness.  My plan is to apply your
> > > patch on top.  Sorry for not making that clear.
> >
> > Ah, got it, thanks!
> >
> > Also I'm now chasing a problem that we occasionally see
> >
> > [3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
> > [3939579.462836] Do you have a strange power saving mode enabled?
> > [3939579.462836] Dazed and confused, but trying to continue
> >
> > in the guests when perf is used.  These messages disappear when
> > 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") is
> > reverted.  I haven't yet figured out where exactly the culprit is.
> 
> Can you reverting de0f619564f4 ("KVM: x86/pmu: Defer counter emulated overflow
> via pmc->prev_counter")?  I suspect the problem is the prev_counter mess.

We observe the problem on a branch that predates this commit

Thanks,
Roman.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



