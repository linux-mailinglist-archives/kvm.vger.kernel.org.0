Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67727743EA0
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjF3PV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjF3PVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:21:47 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C14CDF;
        Fri, 30 Jun 2023 08:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1688138506; x=1719674506;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BQVmRLO9m74UMK8I9pR2qF8AU/mjLbuAVCyZ5Z+eWss=;
  b=oib5cg80jhPQK1c2ceJdiPNRHqAndMu/EInfDCpbPgYcm+MYP2aQKtUR
   r5QGPpM0Zn0nBVjuGxxk03GiqXNss88O19qBtkY9BwBF4L1i8XcMlBf0K
   WH5Ob2ZGxZOIJ8Apx7d7se0W4akutSu1tXDiJE3Qbiv2xxGrFrZefF4p6
   4=;
X-IronPort-AV: E=Sophos;i="6.01,171,1684800000"; 
   d="scan'208";a="1140502254"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 15:21:37 +0000
Received: from EX19D007EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 0B45C804E1;
        Fri, 30 Jun 2023 15:21:36 +0000 (UTC)
Received: from EX19D033EUC004.ant.amazon.com (10.252.61.133) by
 EX19D007EUA002.ant.amazon.com (10.252.50.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 30 Jun 2023 15:21:34 +0000
Received: from u40bc5e070a0153.ant.amazon.com (10.1.212.14) by
 EX19D033EUC004.ant.amazon.com (10.252.61.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 30 Jun 2023 15:21:29 +0000
Date:   Fri, 30 Jun 2023 17:21:24 +0200
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
Message-ID: <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJ7mjdZ8h/RSilFX@google.com>
X-Originating-IP: [10.1.212.14]
X-ClientProxiedBy: EX19D041UWA004.ant.amazon.com (10.13.139.9) To
 EX19D033EUC004.ant.amazon.com (10.252.61.133)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote:
> On Fri, Jun 30, 2023, Roman Kagan wrote:
> > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wrote:
> > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
> > >         return counter & pmc_bitmask(pmc);
> > >  }
> > >
> > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
> > > +{
> > > +       if (pmc->perf_event && !pmc->is_paused)
> > > +               perf_event_set_count(pmc->perf_event, val);
> > > +
> > > +       pmc->counter = val;
> >
> > Doesn't this still have the original problem of storing wider value than
> > allowed?
> 
> Yes, this was just to fix the counter offset weirdness.  My plan is to apply your
> patch on top.  Sorry for not making that clear.

Ah, got it, thanks!

Also I'm now chasing a problem that we occasionally see

[3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
[3939579.462836] Do you have a strange power saving mode enabled?
[3939579.462836] Dazed and confused, but trying to continue

in the guests when perf is used.  These messages disappear when
9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") is
reverted.  I haven't yet figured out where exactly the culprit is.

Thanks,
Roman.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



