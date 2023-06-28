Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38089741AE4
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjF1Van (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjF1Val (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:30:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476CE1FDC
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:30:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-be47a3b3a01so155300276.2
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687987839; x=1690579839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VcnjYg/WB2vQn+tBGvK3Q2gluatWaUqvXxEopMzKdso=;
        b=nBCEFq9b2TG3gseb06QDgnUtN/CScBK+uLIbOaLLRsI3KJk84omXwh3k8Fj4OMTxi7
         TWGDjSmRl95Za+Hc1FBI/a1ypwBtn4txANo14deOfMtjacON+9hju13X74roaEUQd5WY
         fKQyjYRf1wHfKWXBhRWvTg1azXTGz2C+RoDWlQEksAORrVyZNlkbDXLH9k/y9tp73P3i
         ZJAUAyMhFFbWYUTpGgLaOhoRTDUKP9+ebdp00PodHiXW1qlx0Bz17w58BRy538VJcFbM
         B8v4CiztnM28Vj536xtLaLbwutOFZrYY6jDpo4b5N+VeJw17SSvHoaD5q/0HknmbBDRQ
         3o8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687987839; x=1690579839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VcnjYg/WB2vQn+tBGvK3Q2gluatWaUqvXxEopMzKdso=;
        b=AxxhQHPFF2WG5nezI9c9202JQRy4rddwUg2oELDTmITiJh2OF2Ubbts5GGTV2QDgiy
         Mg6gPwLwjf7rQkgSruYWh7alanR+KiRc8lb8zKVAFR2dcuUw981C4AXD8PLpjdjGr7YM
         9Lsh79FsdfCDt7gx7aE4P306JvcEx2HhfAqkleLEg3ARNprQ7ZSFIzX5451uD1I4mMQq
         1zhX92rpIB22HufM/m5EdbQsONkFMhm9eOuPCiQePIT3YeGNw9Y2cVHQ6mu4Nn0lLBxA
         QHXo2R7yIFkmqm77nCvzyJTBQOnoINgfYbhJf3K+KXlhrQp3nlBigAVuYQa3rBu+k2B7
         ysCA==
X-Gm-Message-State: AC+VfDxTiJTetSlT5oglWUEQv5qRCjUg2pEX4Uu9BN/KmO4YwAr1ReTO
        9MSfD7HC7KrOGN4Y0KVCr1kauWaa46c=
X-Google-Smtp-Source: ACHHUZ5XelWl+F2ma1SfdrNipVHrp8infBaeoZzX2b9ZqRCrkICVXeVBv8pkxbJ+G47QSPPaNsQPsAdxz0Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab6b:0:b0:c1b:4347:b3db with SMTP id
 u98-20020a25ab6b000000b00c1b4347b3dbmr3335327ybi.6.1687987839556; Wed, 28 Jun
 2023 14:30:39 -0700 (PDT)
Date:   Wed, 28 Jun 2023 14:30:37 -0700
In-Reply-To: <20230607123700.40229-5-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230607123700.40229-1-cloudliang@tencent.com> <20230607123700.40229-5-cloudliang@tencent.com>
Message-ID: <ZJymfTf+fRFnDsyW@google.com>
Subject: Re: [PATCH v3 4/4] KVM: selftests: Test gp event filters don't affect
 fixed event filters
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023, Jinrong Liang wrote:
>  static void __test_fixed_counter_bitmap(struct kvm_vcpu *vcpu, uint8_t idx,
>  					uint8_t nr_fixed_counters)
>  {
> @@ -881,6 +894,25 @@ static void __test_fixed_counter_bitmap(struct kvm_vcpu *vcpu, uint8_t idx,
>  						       bitmap);
>  		TEST_ASSERT(!!count == !(bitmap & BIT(idx)),
>  			    "Fixed event filter does not work as expected.");
> +
> +		/*
> +		 * Check that setting both events[] and fixed_counter_bitmap
> +		 * does not affect the consistency of the fixed ctrs' behaviour.

Spell out "counters".  And this isn't about "consistency", the fixed_counter_bitmap
should straight up win, i.e.

		/*
		 * Check that fixed_counter_bitmap has higher priority than
		 * events[] when both are set.
		 */
