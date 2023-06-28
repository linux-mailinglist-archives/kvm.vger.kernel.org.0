Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD61B741AE1
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjF1V3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjF1V3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:29:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D321BEA
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:29:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-57325434999so2341277b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687987742; x=1690579742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S4+NG0E282pExx69hOpqlYJL4D++Sscbft5Jezcu1U4=;
        b=LmTiMTLjtNU8B+N2wm1qv1Xh+WY5DCUp3/vCPG22i+LFvSuz4Z8BwGRQgKrdosqrED
         8KVLYu5kYeA9sXbrtaC5xRgq12Vn0+jvo2NS9FLX2LoVDN7s6lIqJncjVsTOxKDbSs/t
         qmWHZuANGKIhnEeC5aO9RIfyOD2dsd+EBfvThphHldcD8OElNd8OFdMTrLG6DGcxVUMr
         /eTTF8mTqrNEzid+Gjd117s+xAtn9r5f2QzMeSYYZe7yxL0+jjhc9mlb5l1VEz4t38du
         C+w0gdJaiY+6ADDV+ee0nUnzlJPd4yq+N++z02+jMjaYwzgoHHeZQeGQqoPH+LPTsanU
         0eOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687987742; x=1690579742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S4+NG0E282pExx69hOpqlYJL4D++Sscbft5Jezcu1U4=;
        b=MHUIGhOQlb8Ml/71DGq2crnZxDzd9mJ7tMPtHnjhBvAolh5ILITSL6PoUc/La/Ujna
         QnRdWP72LcdfJLV9iFj4tJOuFJYc8GOuFBHA5wCo4EOm1SCV9pjJo8TyOdBHaTRLhuxN
         8xIdv1skXUtUvqqlynWrivOdwlTAs/u6n59j7ttKOkpBzo9PAXKM3Ffg359EKNHeujaD
         gswePKEfPQjhiyo1/22oJswpev+8yi4b7EodYQTxCFlenx2iPnETjAa2zcz+AMXcr0Bg
         F/seenarqzSSMiSa9L4k5WDDyFX8gMbt+d7p0Dh83T5xTAk9v89qYAEM4dQdwJOGL3x7
         XVjA==
X-Gm-Message-State: AC+VfDz+MEuXf8GKxQI9PVHRo6erDdvBJIS+Od/y8UHa9dy8Me6b0Th3
        /ohw05FVfPSEDq/z35j/ayNgBNwrbYQ=
X-Google-Smtp-Source: ACHHUZ4n8a2QLF6VBqJGBRku7htondlRkoTsoqSbam1pQTzOu9LsAReH81erivYUgmkTY3xJRw3s1hR6jZA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:708:b0:576:a5a8:f686 with SMTP id
 bs8-20020a05690c070800b00576a5a8f686mr4556851ywb.9.1687987741909; Wed, 28 Jun
 2023 14:29:01 -0700 (PDT)
Date:   Wed, 28 Jun 2023 14:29:00 -0700
In-Reply-To: <20230607123700.40229-4-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230607123700.40229-1-cloudliang@tencent.com> <20230607123700.40229-4-cloudliang@tencent.com>
Message-ID: <ZJymHAKx9XNAFYPk@google.com>
Subject: Re: [PATCH v3 3/4] KVM: selftests: Check if event filter meets
 expectations on fixed counters
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Jun 07, 2023, Jinrong Liang wrote:
> +	/*
> +	 * Check the fixed performance counter can count normally works when
> +	 * KVM userspace doesn't set any pmu filter.
> +	 */
> +	TEST_ASSERT(run_vcpu_to_sync(vcpu),
> +		    "Fixed counter does not exist or does not work as expected.");

No punctuation, and print the unexpected return value so that debug isn't too
painful.

> +
> +	for (i = 0; i < BIT(nr_fixed_counters); i++) {
> +		bitmap = BIT(i);
> +		count = test_with_fixed_counter_filter(vcpu, KVM_PMU_EVENT_ALLOW,
> +						       bitmap);
> +		TEST_ASSERT(!!count == !!(bitmap & BIT(idx)),
> +			    "Fixed event filter does not work as expected.");

No punctuation please.

> +
> +		count = test_with_fixed_counter_filter(vcpu, KVM_PMU_EVENT_DENY,
> +						       bitmap);
> +		TEST_ASSERT(!!count == !(bitmap & BIT(idx)),
> +			    "Fixed event filter does not work as expected.");
> +	}
> +}
