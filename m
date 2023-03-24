Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBAC6C8910
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 00:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjCXXNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 19:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCXXNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 19:13:41 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44ADC16310
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:13:39 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id pm10-20020a17090b3c4a00b0023ff02aced2so3546190pjb.1
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679699619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DcyHkCN+ppZSMBTdximdTt+L7x4aLTNRaJDAdNPZ4ng=;
        b=odSJ3ACgQqEJX3WSsVrtBVvR1cKZSOG86JAwa9zIOtfifrGXyxzSrkZIWbTOzMbu7+
         kNrnCnvLyIzEiZIn+Wloa9/qENdDRtszbDrcIpQcQzom1LgeABvbxo07uQGQt+XZ8fNe
         OM5pCRDA0AFxNh2TTh+oN9UEukp7X5/2PISXhBT0MVP9nolVA3gYAah4zbA+J3PytKWm
         QfUCKQjSK8lDzkeS6+o23xNKzRBp0/1nkwX4g4QCDJ6Ot2Pda7aTMu1/Mzwr4+ztFbdE
         pRwQQApJ27OMld307ob6SYfmLDyo4e94r6/tb/WueOovi0nSl2KY5GIfNyEQTDCXsjZL
         4gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679699619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DcyHkCN+ppZSMBTdximdTt+L7x4aLTNRaJDAdNPZ4ng=;
        b=0GWyJv95OqA8eCc+h8l3pMXZ/vL7tmMYlWXBLka9f6kUk6wHsuiH4wbJSG3cajIfeN
         E88KtoBIUOzXrWjD5Pl58HPWOIF0zqwEdMpMqy0WEijm2uLWh/eQiFaFgf1qTFZldVa8
         4nIWYpVlUG5q8+YVhoT9iywMigJXolXv3N9Umd8whwJqB6vLe/Z39fcfM/n/8ktozEHr
         pM+ISstFsPiqVEKlnOEi71lEE266u48wJX/nMvFhFXJRiDeQG78wmp2TtQAOTsp4ZAU/
         d68/p0b0dBWWFItKprcB17JhcIdcQ2rOHYCY4V1Pn17kzHjwSe9oma1m5J5EOTsUbBNO
         obBw==
X-Gm-Message-State: AAQBX9c7XDYDnnHLJw3oYG0HkiwDOfnCJSz1gNUjwa5EGuXV8yxndLR7
        YEpmAmuLIBI6fbruxYldQGbRs+qai50=
X-Google-Smtp-Source: AK7set9poMEJJGCyeA2Pj8j7Kdn85X08yTBcBCvExVQxc0PKno5Jvma2+GhBaotZP4G93ZVxxwOcGaUPX90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2313:b0:626:23a1:7b9d with SMTP id
 h19-20020a056a00231300b0062623a17b9dmr2342573pfh.6.1679699618843; Fri, 24 Mar
 2023 16:13:38 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:13:37 -0700
In-Reply-To: <20230313111022.13793-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230313111022.13793-1-yan.y.zhao@intel.com>
Message-ID: <ZB4uoe9WBzhG9ddU@google.com>
Subject: Re: [PATCH v3] KVM: VMX: fix lockdep warning on posted intr wakeup
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023, Yan Zhao wrote:
> The lock ordering after this patch are:
> - &p->pi_lock --> &rq->__lock -->
>   &per_cpu(wakeup_vcpus_on_cpu_lock_out, cpu)
> - &per_cpu(wakeup_vcpus_on_cpu_lock_in, cpu) -->
>   &per_cpu(wakeup_vcpus_on_cpu_lock_out, cpu)
> - &per_cpu(wakeup_vcpus_on_cpu_lock_in, cpu) --> &p->pi_lock
> 
> Currently, &rq->__lock is not held in "path sched_in".
> However, if in future "path sched_in" takes &p->pi_lock or &rq->__lock,
> lockdep is able to detect and warn in that case.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> [sean: path sched_out and path irq does not race, path sched_in does not
> take &rq->__lock]

But there's no actual deadlock, right?  I have zero interest in fixing a lockdep
false positive by making functional changes to KVM.  I am definitely open to making
changes to somehow let lockdep know what's going on, but complicating KVM's actual
functionality is too much.
