Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7209860D23D
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiJYRHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 13:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiJYRHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 13:07:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DAE15200D
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 10:07:01 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f140so12465752pfa.1
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 10:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=napLP0njighkCcO4W1DZOY6rgUMs4xcUsx9lyU2OHdk=;
        b=gPOSE8m2CJTzYky/bqt3bvTv2GqxLf0g5LzYFNecRaGofPocb4j5dbAh/8jSFL4e/A
         aJoAGa7c2trrl3i19O3tj/5uDwjfXF6vplhXyO0+nUuSIY01QD0yBp3J+cQDxrK+Zgzo
         w//NsicbvHJrxIdq+dAP9smd2hZHaWyKmf1Ht6/Diga2rt3N3LgOSU4q4u5bir1jCZQB
         SYQn9KKKIMAVXyCmeQp0TAe02+PBOQkjpldxpW4D6Wn7LRkCgFOIBZcYoYkKbjPguy8B
         Q9h3Yg2e9Hbgatqg7PAG66+F3/V04tKE9v/oIf8MLPlNTYV5P7h8L957K6kQLRFswCGa
         1NtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=napLP0njighkCcO4W1DZOY6rgUMs4xcUsx9lyU2OHdk=;
        b=pyV8qgfQe2OzG6dw7MgtQF3Yxee65O8ZrE3gNgmyXHiA3A/c60K+Q1aqa1sUEIY5Xp
         r0GhmxgNDV72XHpizDNnWczAUYxOvgEapTUs7iC7Nf9G5pqEUrVDkqmLOm2+tMtIgw+M
         4PhFC2zkYTGEKsHbylAvoybpUfYbIohtHP03muQPozU5+Oc8cocN2uMopcHp1djOVCE3
         nH3lv5B7IbvjsEnORfzSuv7wsox6U0Qhz+y2MXo5u9dwHENrt1BFSRKLD8oS1bnRCWOJ
         W6psPk/nGj8ztRLESB2FiLfMm+p9wmfhMrtI51mnNY6qewsOLm19BhWa2ufMgXozBzd8
         p4Zg==
X-Gm-Message-State: ACrzQf0K/s5ZFrskL2r+mQ9CkZhdhODFo7i70G8zdempABzllqsQFCyo
        6pnYGrCk5J9Z2BOPnaSFv/af5Q==
X-Google-Smtp-Source: AMsMyM6I6vLBD3d3/4wDmQWDD3rOE2C/HNRN5WzdWxYdwhclsUQhL1e+6B6e+wGDNL2Or2lbcChJcQ==
X-Received: by 2002:a63:b59:0:b0:434:2374:6d12 with SMTP id a25-20020a630b59000000b0043423746d12mr33575235pgl.311.1666717621393;
        Tue, 25 Oct 2022 10:07:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jc20-20020a17090325d400b001830ed575c3sm1437993plb.117.2022.10.25.10.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 10:07:00 -0700 (PDT)
Date:   Tue, 25 Oct 2022 17:06:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Mi, Dapeng1" <dapeng1.mi@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
Subject: Re: [PATCH] KVM: x86: disable halt polling when powersave governor
 is used
Message-ID: <Y1gXseyl0f3IUnDh@google.com>
References: <20220915073121.1038840-1-dapeng1.mi@intel.com>
 <Y0BnKIW+7sqJbTyY@google.com>
 <PH0PR11MB48240C29F1DEBC79EA933285CD5E9@PH0PR11MB4824.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB48240C29F1DEBC79EA933285CD5E9@PH0PR11MB4824.namprd11.prod.outlook.com>
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

On Sat, Oct 08, 2022, Mi, Dapeng1 wrote:
> > > +				!strncmp(policy->governor->name,
> > "powersave",
> > 
> > KVM should not be comparing magic strings.  If the cpufreq subsystem can't get
> > policy->policy right, then that needs to be fixed.
> 
> Yeah, using magic strings looks a little bit strange, but this is what is
> cpufreq doing.  Currently cpufreq mechanism supports two kinds of drivers,
> one is the driver which has the built-in governor, like intel_pstate driver.
> For this kind of driver, the cpufreq governor is saved in the policy->policy
> field. The other is the traditional driver which is independent with cpufreq
> governor and the cpufreq governor type is saved in the governor->name field.
> For the second kind of cpufreq driver, the policy->policy field is
> meaningless and we have to read the governor name. 

That doesn't mean it's ok to bleed those internal details into KVM.  I would much
rather cpufreq provide a helper to get the effective policy, e.g.

  unsigned int cpufreq_cpu_get_policy(unsigned int cpu)
  {
	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
	unsigned int pol;

	if (!policy)
		return CPUFREQ_POLICY_UNKNOWN;

	pol = policy->policy
	if (pol == CPUFREQ_POLICY_UNKNOWN && policy->governor)
		pol = cpufreq_parse_policy(policy->governor->name);

	cpufreq_cpu_put(policy);
  }
