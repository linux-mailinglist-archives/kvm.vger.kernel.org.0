Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FEB607EED
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 21:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiJUTRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 15:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiJUTRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 15:17:02 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE54345213
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 12:16:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so7506492pjq.3
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 12:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U2Z9ZRw5c+xGtGCcrQwmxNOVKWX2byTsnaEmUTfETvY=;
        b=RnpgD5C7hYPDg/XNp9MBVa2yK5edP1Io2gSN/atKlNdD0kwy2SNAic3jWBRpnU0ggi
         OiNAuWB4h8uP0Ft9ASHXGK4GEa+gI7MLMCLKleVzgeDEA9pL7e+0jKp5Q+pxgFZ5ZAK2
         3LBufE5BDfWNLmilfcz01giVU6De0RIhmn0eKqo0NDE7jH4qkBm3siEkKl9hvgfKhq4H
         H+RTdWlMX0xWOuMkAt61S1FJR2Uku112q69Ns5PhE+rKzqV+X/nF2sBquD7KI9Z4BZLE
         stGjzZrT7s5Jca2OwRZj/AVjKEcyAnphPDmwjhfv171mhFnfAgUipTMMiZcKUGiXBQhH
         nVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U2Z9ZRw5c+xGtGCcrQwmxNOVKWX2byTsnaEmUTfETvY=;
        b=msAL0HIQ6Oe6eYpXAD3d8AJ+8kMM6gUakr+MjlpBlZuljXYP4wTXIXoMW6FQWi+4Q9
         8XFNyXkPVJQMVzB7KK+UJY6F65YWuJg3O3T+7kK41JVkPdqXLKtXMtgb9bDM7KZrbfzX
         XljVvuiiRKdF//jsJTFtyC5Wo6bwyEvlic/UlOZnx+AXQXX5Q8eGj31QYC0TTRZEUrFY
         3JNtcf/ljemnFcBfjfgdZ14B9Hn1hUPW1ol0fWfpjp3IG3riVIAuc2CzXe92zjq+4Ybl
         mnCBL7aiS9Ks04C0el4mn794ksPLQlQhUV/scR6/7qScGskmAIBlT+mukZoPwsLL87Xs
         9CVA==
X-Gm-Message-State: ACrzQf2NFPTCdUKqTmyLvpxwi7zjiDr6e8NjlBlfPVSJYHvtyObrOBCJ
        xgm4k2omkepXm/2xyx3XkcxAMBCgDmY4pg==
X-Google-Smtp-Source: AMsMyM5/rEQm5DkiHtiGf2DWGn4xC37tKBKbi6R6ibkrhDHc+pqwYr+aIhsV1hvlEKYG/cgJ5iRs3w==
X-Received: by 2002:a17:902:7883:b0:17f:9503:abe5 with SMTP id q3-20020a170902788300b0017f9503abe5mr21277067pll.41.1666379815048;
        Fri, 21 Oct 2022 12:16:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b14-20020a170903228e00b00176e8f85147sm15414425plh.83.2022.10.21.12.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:16:54 -0700 (PDT)
Date:   Fri, 21 Oct 2022 19:16:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 03/13] x86/pmu: Reset the expected
 count of the fixed counter 0 when i386
Message-ID: <Y1LwIgLp3gunyZ/j@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-4-likexu@tencent.com>
 <Yz4Ct/rxI2EZ+I7o@google.com>
 <2401d7da-9c71-4472-10b7-92f0a479ad50@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2401d7da-9c71-4472-10b7-92f0a479ad50@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022, Like Xu wrote:
> On 6/10/2022 6:18 am, Sean Christopherson wrote:
> > > ---
> > >   x86/pmu.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/x86/pmu.c b/x86/pmu.c
> > > index 45ca2c6..057fd4a 100644
> > > --- a/x86/pmu.c
> > > +++ b/x86/pmu.c
> > > @@ -315,6 +315,9 @@ static void check_counter_overflow(void)
> > >   		if (i == nr_gp_counters) {
> > >   			cnt.ctr = fixed_events[0].unit_sel;
> > > +			__measure(&cnt, 0);
> > > +			count = cnt.count;
> > > +			cnt.count = 1 - count;
> > 
> > This definitely needs a comment.
> > 
> > Dumb question time: if the count is off by 2, why can't we just subtract 2?
> 
> More low-level code (bringing in differences between the 32-bit and 64-bit runtimes)
> being added would break this.
> 
> The test goal is simply to set the initial value of a counter to overflow,
> which is always off by 1, regardless of the involved rd/wrmsr or other
> execution details.

Oooh, I see what this code is doing.  But wouldn't it be better to offset from '0'?
E.g. if the measured workload is a single instruction, then the measured count
will be '1' and thus "1 - count" will be zero, meaning no overflow will occur.

Ah, but as per the SDM, the "+1" is needed to ensure the overflow is detected
immediately.

  Here, however, if an interrupt is to be generated after 100 event counts, the
  counter should be preset to minus 100 plus 1 (-100 + 1), or -99. The counter
  will then overflow after it counts 99 events and generate an interrupt on the
  next (100th) event counted. The difference of 1 for this count enables the
  interrupt to be generated immediately after the selected event count has been
  reached, instead of waiting for the overflow to be propagation through the
  counter.

What about adding a helper to measure/compute the overflow preset value?  That
would provide a convenient location to document the (IMO) weird behavior that's
necessary to ensure immediate event delivery.  E.g.

---
 x86/pmu.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index f891053f..a38ae3f6 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -325,16 +325,30 @@ static void check_counters_many(void)
 	report(i == n, "all counters");
 }
 
-static void check_counter_overflow(void)
+static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 {
-	uint64_t count;
-	int i;
-	pmu_counter_t cnt = {
-		.ctr = gp_counter_base,
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
-	};
 	__measure(&cnt, 0);
-	count = cnt.count;
+
+	/*
+	 * To generate overflow, i.e. roll over to '0', the initial count just
+	 * needs to be preset to the negative expected count.  However, as per
+	 * Intel's SDM, the preset count needs to be incremented by 1 to ensure
+	 * the overflow interrupt is generated immediately instead of possibly
+	 * waiting for the overflow to propagate through the counter.
+	 */
+	assert(cnt.count > 1);
+	return 1 - cnt.count;
+}
+
+static void check_counter_overflow(void)
+{
+	uint64_t overflow_preset;
+	int i;
+	pmu_counter_t cnt = {
+		.ctr = gp_counter_base,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+	};
+	overflow_preset = measure_for_overflow(&cnt);
 
 	/* clear status before test */
 	if (pmu_version() > 1) {
@@ -349,7 +363,7 @@ static void check_counter_overflow(void)
 		int idx;
 
 		cnt.ctr = get_gp_counter_msr(i);
-		cnt.count = 1 - count;
+		cnt.count = overflow_preset;
 		if (gp_counter_base == MSR_IA32_PMC0)
 			cnt.count &= (1ull << pmu_gp_counter_width()) - 1;
 
@@ -358,9 +372,7 @@ static void check_counter_overflow(void)
 				break;
 
 			cnt.ctr = fixed_events[0].unit_sel;
-			__measure(&cnt, 0);
-			count = cnt.count;
-			cnt.count = 1 - count;
+			cnt.count = measure_for_overflow(&cnt);
 			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
 		}
 

base-commit: c3e384a2268baed99d4b59dd239c98bd6a5471eb
-- 

