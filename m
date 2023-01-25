Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC5667A8AA
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 03:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjAYCT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 21:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYCTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 21:19:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C0710AAB
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 18:19:54 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so597232pjb.2
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 18:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sxlIvtDzxqsw9xKk15YZymubLIPz2ce8m4nZ6o2rlno=;
        b=QrISVRH/ok+70p7lcmGUQ3rxG+VIiPRW9lTxKzlScvIb963BD+BQPe13i3qbUkNQnV
         V88oRqKVkl2o3REbPASeDrot+TLJdDuZcPqrC/Q/N/2Mkz+KYK3NrpKawx9zYSuqSh70
         1SjEAjqHMr77AMQo9pw4lWcS0WZfMhfImWP+X8jGenxNl+acf/mowRb1DVECft3DZDu8
         RewTYA7y2SA8Pt5qJZtbc3Ab4wQ0+90+0rEuvLNhmXC39E6eeldUxbqzqgofhaAHtZp3
         Lk+xuxEW+bmrlWLnuf1RGxZ+D9ERcpIJ+52oIa37SN+V1cPxs4wZFb8GY4BBu/40uSqU
         85Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxlIvtDzxqsw9xKk15YZymubLIPz2ce8m4nZ6o2rlno=;
        b=T7dfFxn8nIBGPhFYpvUL5f0hHBBHoFzyKl3GolBi0MPRcJALdgQZljSxS0bS5BKySm
         1h7dwifWpjmFzb6g4luri2Vpz5HUjj/VmkrIJnEYgpm+1wIQ6MnprH0WG/hP8awaFayR
         6A8ebQwsC+kYXpIGKyneF82eG9vVNyLitXoJ6qzfUZH/OGe+JHZg8dg8dJzxIcsthNMG
         zrAgojYmnl3urwg19S2HFeuyWRm6lWWqU6yEQ7f9BKEBj/gH96sd7cOEcl3PoMGMc8qX
         QbexOLg+32yO8M+LaOEJ8y/HvmPs5azwDUgVH7Y4hKHka7B8IdgYKQXt9Q6vf78NMxKp
         Vxjw==
X-Gm-Message-State: AO0yUKWm90VjZ3SNw46GPimOV/tb9hfDYU37V4hsb3ap4Av47xJGDuCp
        yUGyEMVx5llYyQ5gyiC2QRJQXQ==
X-Google-Smtp-Source: AK7set8AKxJM1PHSBKVE6deFS0mz7/47MnLQ9LeR0ToWCL/gcMgJ4IQX8zQF+B+FrRtJTG2JR3Dy1w==
X-Received: by 2002:a17:90b:1955:b0:229:f4e9:75c7 with SMTP id nk21-20020a17090b195500b00229f4e975c7mr482766pjb.0.1674613193803;
        Tue, 24 Jan 2023 18:19:53 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id l11-20020a17090a384b00b00226369149cesm256246pjf.21.2023.01.24.18.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 18:19:53 -0800 (PST)
Date:   Tue, 24 Jan 2023 18:19:49 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
Message-ID: <Y9CRxb2YvPtX340D@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
 <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>
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

On Wed, Jan 18, 2023 at 09:58:38PM -0800, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
> > @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >
> >         pmu_reset_stats();
> 
> This isn't directly related to the patch.
> But, as bits of pmovsclr_el0 are already set (although interrupts
> are disabled), I would think it's good to clear pmovsclr_el0 here.
> 
> Thank you,
> Reiji
> 

There's no need in this case as there's this immediately before the
pmu_reset_stats();

	report(expect_interrupts(0), "no overflow interrupt after counting");

so pmovsclr_el0 should be clear.

> 
> >
> > -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > +       write_regn_el0(pmevcntr, 0, pre_overflow);
> > +       write_regn_el0(pmevcntr, 1, pre_overflow);
> >         write_sysreg(ALL_SET, pmintenset_el1);
> >         isb();
> >

