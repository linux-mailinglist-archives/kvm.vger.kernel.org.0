Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D0967758C
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 08:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjAWHYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 02:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjAWHYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 02:24:04 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E5B83F3
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 23:23:40 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id k16so8236658wms.2
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 23:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lHDUwD9h83rnJJNpiNqVvc264bAbkxnGNGF4uJhWa/4=;
        b=nTC0VsEDMVCq51+/vS2Hfn5Olr7QgbCq59wjcP1VLY3nsFBTsL9nVs3hLr3gZHz3F1
         6bDu2mSuvfmYwKklX5L966Rl9e+v/8jK7ZYfRQD3Dd92CaTGZuq9+wVT8mQIKi1TWh9m
         VpdsH0uJr6YEhYaoA8bPkoI2NXXNCO+xMcT2fNWjlqlg1XUp1u3GhTftq8WW4bXYfkUL
         PtCazKxBQ3+RiLYsQs8Y6K7Z9yyyL1MAwVxrrCY2VIriyGVrYhWWipgKfaHRxojpI6Lm
         onGXJ8MZBe3A9GJ1cvpgbJcxDdF+kOfBYIXST0clqK1FojNz13ueodHOL2y3Dsvp6/Sg
         yhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lHDUwD9h83rnJJNpiNqVvc264bAbkxnGNGF4uJhWa/4=;
        b=bbinSUR5+L8MPe5pe+F/weqhOGB3h61bP8cghJHJ5A7k0vS+D9QhgYCNwpQuqCJD6l
         KzFDeQb4k6k7eqoP6lVGEHisQE5Xm3KhSwvm9hhaF4Oi6Z91Q/jtxM1mpyc5pc9Gbszd
         rLZzGtkygMdx7AhCzjDQ5JbpPBIEd3QRYU3wPSl5g1kXa9gmVo1j7tOm1EMERFRv8+h8
         t4RAvCTbvrWECsmNFV+GX8RVVUxNzgxuroz9ZvVLV5A2dyI348P1Z4KDhC1YhGIJk2B+
         eDqxbdpEjFWeOpLuuWIx3tYosMi3DZ2XfciVf4X8I62x8tqlTpOzs/pHqnkFeFXPz7g5
         wtsg==
X-Gm-Message-State: AFqh2kqeAmZ1rTbO+lmQqTHEeDNhD2LHvws3/YuPsN68Gq+JeR9NdtAg
        WRQLGtBXDSlZQ4WY7yZnM9FovM5bNbcu8JbI
X-Google-Smtp-Source: AMrXdXv8xVPK5ZnPEwN9D/XIIKFQAhkecskCNPxBbANGzQ04+rcnNPqSFlI5pwS7jAiL3p5FecVHwA==
X-Received: by 2002:a05:6402:49:b0:49e:33ce:144d with SMTP id f9-20020a056402004900b0049e33ce144dmr41323983edu.37.1674458609281;
        Sun, 22 Jan 2023 23:23:29 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id s1-20020aa7cb01000000b00463b9d47e1fsm21134322edt.71.2023.01.22.23.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 23:23:28 -0800 (PST)
Date:   Mon, 23 Jan 2023 08:23:27 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 10/11] RISC-V: KVM: Implement perf support without
 sampling
Message-ID: <20230123072327.4k4ai6mwfy4uc6qq@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-11-atishp@rivosinc.com>
 <20230113114502.hiebgkujduwcmsuk@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113114502.hiebgkujduwcmsuk@orel>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 12:45:02PM +0100, Andrew Jones wrote:
> On Thu, Dec 15, 2022 at 09:00:45AM -0800, Atish Patra wrote:
...
> > +	/* Start the counters that have been configured and requested by the guest */
> > +	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
> > +		pmc_index = i + ctr_base;
> > +		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
> > +			continue;
> > +		pmc = &kvpmu->pmc[pmc_index];
> > +		if (flag & SBI_PMU_START_FLAG_SET_INIT_VALUE)
> > +			pmc->counter_val = ival;
> > +		if (pmc->perf_event) {
> > +			if (unlikely(pmc->started)) {
> > +				sbiret = SBI_ERR_ALREADY_STARTED;
> > +				continue;
> > +			}
> > +			perf_event_period(pmc->perf_event, pmu_get_sample_period(pmc));
> > +			perf_event_enable(pmc->perf_event);
> > +			pmc->started = true;
> > +		} else {
> > +			kvm_debug("Can not start counter due to invalid confiugartion\n");
>                                    ^ Cannot                             ^ configuration
> 
> > +			sbiret = SBI_ERR_INVALID_PARAM;
> > +		}
> > +	}
> 
> Possibly a spec oversight is that we continue to try and start counters,
> even when we've seen errors. The problem with implementing that is that
> if we have both errors we only return the last one. I.e. one counter
> was already started and another counter resulted in invalid-param, we
> only return invalid-param. We also don't say anything about the number
> of failures / successes. I think we should bail on the first error and
> even stop counters that we started. Callers can then try again after
> correcting their input without potentially getting already-started errors.
> We'd need to change the spec to do that though.
>

Thinking about this some more, the spec doesn't prohibit implementations
from bailing on the first error, so we can do that. But maybe we don't
need to stop the counters we started. We can leave it to the driver to
sort out what got configured/started and what didn't when it gets an
error.

Thanks,
drew
