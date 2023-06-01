Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B8B71F6BD
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 01:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjFAXkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 19:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFAXkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 19:40:41 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B74BE51
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 16:40:30 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-258caf97a4eso453076a91.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 16:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685662830; x=1688254830;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0XvmQSwr0mCxObK3MzFZIgIzpC/cE3GSOx8vLaSE+0M=;
        b=3uoqd6qN76UCqUThv8krW8tmhYBkKbfHCmX5A8TDxztGUhslLro864nOjLhTJk/dm3
         6HkXnEKTibcnkx305OW+z/zk9KsiKstemyhs32b5Y6g/eKipjob0IeM5lfSrwMLUtPNI
         dO/U7VY5ft1AhnhfN8PfHcvMNkdo131C3mZlRlJTHc/7KEQClinVoic9yVti9HKMFxKQ
         ntdFFGhqPWQ6wj4cnBxXvax3R/Fhg2/NwGL65UVvW+dYZm9orwMoq423tMHvFFFPO0wD
         UN4nVCd8wFh5KwPBgj6xuVrGiqTK/lMi+c8KZOs80oCTcUOl61Ai8zgHgom7sEBC0jeT
         4GEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685662830; x=1688254830;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0XvmQSwr0mCxObK3MzFZIgIzpC/cE3GSOx8vLaSE+0M=;
        b=k9PmcfQXN+sJ/dNfgY2IkL3QAPdjYhgoZylaxcZbk1ZIelmUGekIKXnCzHgHK4pjt7
         ZYthnzl1iJ1B25fQedByasrQOdQTvJ4wVS3DTYPV6IzNZRB/0Y/EZUAtY2vzVsQyBCaM
         IbpBS5NLISHjfykfaX/zRu4tn7HhVT4I5UaKBHjQSxkhe+HRxZ17OBXmTi581+MRR9t5
         FCDdFdsxZFqQRx/nAExGOM6TbWR70mlQbOct/ePv7ZIcM+iywlHdyAB1PrMCQqjF2LO1
         3neEtgqiEq8IOg53oC2KnvG6KaYoueZ5sOE1wWn06tjERZ0iINHw/gmIwDoUl9SE2/6V
         vCdw==
X-Gm-Message-State: AC+VfDw8gA39nnEKSU3j8fqRdOUM9l7JChOpf0e0V9r7O0H2gMd/WHAw
        Yhmvhw6oSCL02S2X++3f8a2F1PuqGXU=
X-Google-Smtp-Source: ACHHUZ46ko/gb9Hf+MvQEv5oPOT4paCbzWhd4fIAz51nPCijZ9ImA6WrM2WZOQ/Fd1YBLztN3oj0lMjej8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d185:b0:256:3e18:39e with SMTP id
 fu5-20020a17090ad18500b002563e18039emr187908pjb.3.1685662829913; Thu, 01 Jun
 2023 16:40:29 -0700 (PDT)
Date:   Thu, 1 Jun 2023 16:40:28 -0700
In-Reply-To: <ZHklss/E5uQdRktD@google.com>
Mime-Version: 1.0
References: <20230526235048.2842761-1-seanjc@google.com> <20230526235048.2842761-4-seanjc@google.com>
 <ZHklss/E5uQdRktD@google.com>
Message-ID: <ZHksbJGKbNJpNcJI@google.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Add test for race in kvm_recalculate_apic_map()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023, Sean Christopherson wrote:
> On Fri, May 26, 2023, Sean Christopherson wrote:
> > From: Michal Luczaj <mhal@rbox.co>
> > 
> > Keep switching between LAPIC_MODE_X2APIC and LAPIC_MODE_DISABLED during
> > APIC map construction to hunt for TOCTOU bugs in KVM.  KVM's optimized map
> > recalc makes multiple passes over the list of vCPUs, and the calculations
> > ignore vCPU's whose APIC is hardware-disabled, i.e. there's a window where
> > toggling LAPIC_MODE_DISABLED is quite interesting.
> > 
> > Signed-off-by: Michal Luczaj <mhal@rbox.co>
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |  1 +
> >  .../kvm/x86_64/recalc_apic_map_race.c         | 76 +++++++++++++++++++
> >  2 files changed, 77 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c
> 
> Since there's another bug+test related to kvm_recalculate_apic_map()[*], I think
> it makes sense to name this recalc_apic_map_test, and then fold the LDR test into
> this one.  The LDR test is tiny enough that I don't think it's worth a separate
> binary, even though I generally prefer to keep the selftests small.

Actually, the x2APIC test is a better fit in xapic_state_test.  I'll probably
still rename this to match (almost) every other selftest name.
