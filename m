Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4EB67D5E7
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 21:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjAZUGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 15:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjAZUGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 15:06:48 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C444C12
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 12:06:47 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d132so3443271ybb.5
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 12:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kjtLi/8WKn2oW5QyDUOhA67hgly+UmbkPzhgpNv8AMU=;
        b=oH3bXQN+JoJrVUu+Bz51byhgL8DsonLwrvM3zDrglgjuerp6zGBifzPPKrO554Mgzd
         pc/nBHlOhF3mzB3iCssigSAh234VYPnccD4sFe5zf65HSpjX9uTG+SjVMHsBWLDHbEPJ
         88GjLBRCtx+6g5g3Uhg0EoLU2sLieJ1QyUCSnbInSf1ydeItkvirLZIf+dwIz7A5WF7z
         bFvFt6r315QxZFoH11EK/oo0z8VFmRtNj3LhECRcQpu3V2blKJGOTorbknjZ0AA5UB8S
         wMAgmR5jzmCfdH824v6Vy8MsfEMckIIylbhZV2gsgYfRaVmubSZm9OPymf9ZEWNgy8MC
         4sCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kjtLi/8WKn2oW5QyDUOhA67hgly+UmbkPzhgpNv8AMU=;
        b=Z1CuGi3dAIGH2qJGy/PZu3Sq7yMKE7shSkFzpeKxac9zxu9vLNKOkQjUgVvnd+up/0
         o4VW4ipoLuNHftF77JqDuC73JwKBvQWxEwk+Sc7OOjTIEyskbf7YcFpEJDUn6aXD0R1/
         WXg6ybu0DpIpm4oDkwkF4dgA1uoh662c64nSYLf4FsPMk0AnIP7uGPotkNpyDcF0+1hm
         KseiKPMB4FoHZ2WD5utrI1eGzVEy6vOBu+tOj5XG1t9IHNz6gMQ9G4Aa58TvKz8WM8WL
         u6/A2j9NzidLAUh1YxRd7/rUg7DeUPtjY0cJ1U9q620haonAYgFlTqKb0gwVb+sINiyG
         u9pw==
X-Gm-Message-State: AFqh2krJXXPY9inPUVy6AW58fozmwVAzuoh4oZuxGTDPxnxOY9+8fmam
        ik11qAPbuJv5SOVYrt6xuXgXjHb48gPIBIrk4EHUl71vLN1HMNxj
X-Google-Smtp-Source: AMrXdXvulrX9qsSyygd1hulQLBBseHXK9nztfSRV2xngfTj5Kv9OdDT4Le8mrK95TeaxnpS6iQKCwUMin1YiuVJUDIg=
X-Received: by 2002:a25:6a0b:0:b0:7d1:5a92:eb5c with SMTP id
 f11-20020a256a0b000000b007d15a92eb5cmr4400549ybc.166.1674763606261; Thu, 26
 Jan 2023 12:06:46 -0800 (PST)
MIME-Version: 1.0
References: <20230125182311.2022303-1-bgardon@google.com> <20230125182311.2022303-3-bgardon@google.com>
In-Reply-To: <20230125182311.2022303-3-bgardon@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 26 Jan 2023 12:06:10 -0800
Message-ID: <CAHVum0ex4=X_iD_hKMQAkNVEcVzZSNUb_V0ApjPKxpCX+oFV6w@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] selftests: KVM: Add dirty logging page splitting test
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Jan 25, 2023 at 10:23 AM Ben Gardon <bgardon@google.com> wrote:

> +static void run_vcpus_get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
> +{
> +       int i;
> +
> +       iteration++;
> +       for (i = 0; i < VCPUS; i++) {
> +               while (READ_ONCE(vcpu_last_completed_iteration[i]) !=
> +                      iteration)
> +                       ;
> +       }
> +
> +       get_page_stats(vm, stats, stage);

get_page_stats() is already called in run_test() explicitly for other
stats. I think it's better to split this function and make the flow
like:

run_vcpus_till_iteration(iteration++);
get_page_stats(vm, &stats_populated, "populating memory");

This makes it easy to follow run_test_till_iteration() and easy to see
where stats are collected. run_test_till_iteration() can also be a
library function used by other tests like dirty_log_perf_test


> +       dirty_log_manual_caps = 0;
> +       for_each_guest_mode(run_test, NULL);
> +
> +       dirty_log_manual_caps =
> +               kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> +
> +       if (dirty_log_manual_caps) {
> +               dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> +                                         KVM_DIRTY_LOG_INITIALLY_SET);
> +               for_each_guest_mode(run_test, NULL);
> +       }

Should there be a message to show  that this capability is not tested
as it is not available?
Or, there can be a command line option to explicitly provide intent of
testing combined,  split modes, or both? Then test can error out
accordingly.
