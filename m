Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A105F4765
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 18:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiJDQVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 12:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiJDQUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 12:20:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EB34DB49
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664900430;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WIVlQm/eJCK+Dkb+zIV3zL4TzRL4MQMkAUsBE4hUHzo=;
        b=XZs1F6khmqNzeurTA0oY+9YqZZ4wvZgMKNf8gXKLK1lSjeWV9xi2dw1XoFdLVx+XXsZOL0
        /Os+06PKsDY/l08HZuxsQLPn/MAJmZstIkNJvPGeEGrj0RPbMnEIAiCOSmCj5XiMbGrGXt
        w7HenKjbhgjw8a5c5MZRJ/mOj0KoDFQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-FQd5VEeOMQ69hgNxGTpIrA-1; Tue, 04 Oct 2022 12:20:29 -0400
X-MC-Unique: FQd5VEeOMQ69hgNxGTpIrA-1
Received: by mail-qv1-f69.google.com with SMTP id y14-20020a0cf14e000000b004afb3c6984bso8569600qvl.21
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 09:20:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=WIVlQm/eJCK+Dkb+zIV3zL4TzRL4MQMkAUsBE4hUHzo=;
        b=VCAOzJrkzyM8KcOgAwRBgUHS1TfjCQZLA7xir20Xw+ndDwzxypQ/ERUkkEMeXpDrD7
         wnb2wpLuFbWBZJ5nn68V6JVCW26hQrlq+oUP6bvE2IWhMrwVQE4EJeYLa783MsBmjjq0
         oQ3U0wlUKOafqWWg9pHFv1sl0BlrwGNu65D76A0BxL8DxIeLub+wtfQcugKBCoLWurFn
         AyPZ89XPBFWnLdUxFgVOHXOS5GSGOQYrwH82ZhHAAJTYT/EdLNBf0r9SRiKOTRFwnEEW
         GKancra58cHiJ7MQ3nvj6Nh9ADSU+OCentVytoYXI004Z4G63EE7X9t+VLdB6XWWowr/
         VGHQ==
X-Gm-Message-State: ACrzQf27y0zPZ7QitJcTpRtimHsRpIEFg66PfHnSglpM1KMNyq9nETaZ
        0yujS5gm7onMPeoTatoVH2fYWswadgJkxBHbN80oge7NG4B/9FO7a6nvHsf2wnGHZxmH2dn5EyR
        5af3Iy5oY5Hxo
X-Received: by 2002:a05:6214:250c:b0:4b1:a1e7:1d89 with SMTP id gf12-20020a056214250c00b004b1a1e71d89mr5522042qvb.1.1664900428097;
        Tue, 04 Oct 2022 09:20:28 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7+nPWaq060lSF2LRYxAqI+BNzr2KIZuva9V6DU3zsjrZjyusvZrLO0SYMelN6m2LvYkgbBxA==
X-Received: by 2002:a05:6214:250c:b0:4b1:a1e7:1d89 with SMTP id gf12-20020a056214250c00b004b1a1e71d89mr5522019qvb.1.1664900427766;
        Tue, 04 Oct 2022 09:20:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bx8-20020a05622a090800b0038e24268c29sm381869qtb.79.2022.10.04.09.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 09:20:26 -0700 (PDT)
Message-ID: <89c93f1e-6e78-f679-aecb-7e506fa0cea3@redhat.com>
Date:   Tue, 4 Oct 2022 18:20:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: pmu: Fixes for bare metal
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20220805004139.990531-1-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220805004139.990531-1-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo, Marc,

On 8/5/22 02:41, Ricardo Koller wrote:
> There are some tests that fail when running on bare metal (including a
> passthrough prototype).  There are three issues with the tests.  The
> first one is that there are some missing isb()'s between enabling event
> counting and the actual counting. This wasn't an issue on KVM as
> trapping on registers served as context synchronization events. The
> second issue is that some tests assume that registers reset to 0.  And
> finally, the third issue is that overflowing the low counter of a
> chained event sets the overflow flag in PMVOS and some tests fail by
> checking for it not being set.
>
> Addressed all comments from the previous version:
> https://lore.kernel.org/kvmarm/20220803182328.2438598-1-ricarkol@google.com/T/#t
> - adding missing isb() and fixed the commit message (Alexandru).
> - fixed wording of a report() check (Andrew).
>
> Thanks!
> Ricardo
>
> Ricardo Koller (3):
>   arm: pmu: Add missing isb()'s after sys register writing
>   arm: pmu: Reset the pmu registers before starting some tests
>   arm: pmu: Check for overflow in the low counter in chained counters
>     tests
>
>  arm/pmu.c | 56 ++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 39 insertions(+), 17 deletions(-)
>
While testing this series and the related '[PATCH 0/9] KVM: arm64: PMU:
Fixing chained events, and PMUv3p5 support' I noticed I have kvm unit
test failures on some machines. This does not seem related to those
series though since I was able to get them without. The failures happen
on Amberwing machine for instance with the pmu-chain-promotion.

While further investigating I noticed there is a lot of variability on
the kvm unit test mem_access_loop() count. I can get the counter = 0x1F
on the first iteration and 0x96 on the subsequent ones for instance.
While running mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E) I was
expecting the counter to be close to 20. It is on some HW.

        for (int i = 0; i < 20; i++) {
                write_regn_el0(pmevtyper, 0, MEM_ACCESS |
PMEVTYPER_EXCLUDE_EL0);
                write_sysreg_s(0x1, PMCNTENSET_EL0);
                write_regn_el0(pmevcntr, 0, 0);
                isb();
                mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
                isb();
                report_info("iter %d, MEM_ACCESS counter #0 has value
0x%lx",
                            i, read_regn_el0(pmevcntr, 0));
                write_sysreg_s(0x0, PMCNTENCLR_EL0);
        }

[I know there are some useless isb's by the way but that's just debug code.]

gives

INFO: PMU version: 0x1
INFO: PMU implementer/ID code: 0x51("Q")/0
INFO: Implements 8 event counters
INFO: pmu: pmu-chain-promotion: iter 0, MEM_ACCESS counter #0 has value
0x1f
INFO: pmu: pmu-chain-promotion: iter 1, MEM_ACCESS counter #0 has value
0x96 <--- ?
INFO: pmu: pmu-chain-promotion: iter 2, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 3, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 4, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 5, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 6, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 7, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 8, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 9, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 10, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 11, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 12, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 13, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 14, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 15, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 16, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 17, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 18, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 19, MEM_ACCESS counter #0 has value
0x96

If I run the following sequence before the previous one:
        for (int i = 0; i < 20; i++) {
                write_regn_el0(pmevtyper, 0, SW_INCR |
PMEVTYPER_EXCLUDE_EL0);
                write_sysreg_s(0x1, PMCNTENSET_EL0);
                write_regn_el0(pmevcntr, 0, 0);

                set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
                for (int j = 0; j < 20; j++)
                        write_sysreg(0x1, pmswinc_el0);
                set_pmcr(pmu.pmcr_ro);

                report_info("iter %d, 20 x SW_INCRs counter #0 has value
0x%lx",
                            i, read_regn_el0(pmevcntr, 0));
                write_sysreg_s(0x0, PMCNTENCLR_EL0);
        }

I get

INFO: pmu: pmu-chain-promotion: iter 0, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 1, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 2, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 3, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 4, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 5, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 6, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 7, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 8, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 9, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 10, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 11, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 12, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 13, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 14, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 15, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 16, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 17, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 18, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 19, 20 x SW_INCRs counter #0 has
value 0x14
INFO: pmu: pmu-chain-promotion: iter 0, MEM_ACCESS counter #0 has value
0x96 <---
INFO: pmu: pmu-chain-promotion: iter 1, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 2, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 3, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 4, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 5, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 6, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 7, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 8, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 9, MEM_ACCESS counter #0 has value 0x96
INFO: pmu: pmu-chain-promotion: iter 10, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 11, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 12, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 13, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 14, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 15, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 16, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 17, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 18, MEM_ACCESS counter #0 has value
0x96
INFO: pmu: pmu-chain-promotion: iter 19, MEM_ACCESS counter #0 has value
0x96

So I come to the actual question. Can we do any assumption on the
(virtual) PMU quality/precision? If not, the tests I originally wrote
are damned to fail on some HW (on some other they always pass) and I
need to make a decision wrt re-writing part of them, expecially those
which expect overflow after a given amount of ops. Otherwise, there is
either something wrong in the test (asm?) or in KVM PMU emulation.

I tried to bisect because I did observe the same behavior on some older
kernels but the bisect was not successful as the issue does not happen
always.

Thoughts?

Eric








