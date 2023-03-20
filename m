Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA31A6C20A6
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 20:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCTTAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 15:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCTS73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 14:59:29 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5592C2A6C9
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 11:51:18 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k17-20020a170902d59100b0019abcf45d75so7476736plh.8
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 11:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679338273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cwkFpfls1/6cud8wVygwf0ElwmaxIhRMsIsiLVuOOos=;
        b=Dayu5fXCeLh47JsqiwpPciLjIjD3C0AAkOu61sC4pfDZuHIdddVPd9TBc7TrdvKaDs
         AesZNjWXlmN17p9fJyicCR9PmN9TQLMNsjZAaVj6jTeOHDai4456vD8cPE2gsFgNtmxw
         MzLQI5orQwtXhkBsCWC3pR7sKeepT8ci/xa4MND7VukYX7sfxi239uHpFR34abjq/95M
         4XZnLldT8gzO0pK1If53cNhanwUlb7QHf6h6SBOtG31tWABLvD3h9NVEKsDZUKJFCIGQ
         QorZSyegkyPc7JEL7Q6IjXeWMxAws8+jXaQmACJVt+bHpvkmMe+hLyjiIpAR/vKXPk5Z
         tyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679338273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cwkFpfls1/6cud8wVygwf0ElwmaxIhRMsIsiLVuOOos=;
        b=OpL4DwiZQRwDjZTa56Kgo+4102v2mGyRmZz/2526nQKhXEW2LjHp8AYlP+hmO5ytpW
         I+ggPAnH3dGwmRiGK38gkbzxnd1Zq6q0GM7+w56nQTHaKfR6CJx1bhLAz4DjS/ewRbnP
         v5h7QWMz/JmcaJ3NFGq5JylX/R3f1xKg6H7gk5aFjkdysnJ+38Tq5gdATzk++M8t6luT
         PF+HRJaujc3ZsSLNLf1GXIXUD4nYRwlsMVGxroMAh0LvbyKd21epky+I8uxyEWMzCuo3
         DoAvrr4etd/kDprtra/11tfsp4BVHJ+h+evsAjhbw6HHH/hrPrGA8+0Z1ZJ9gwGH2fiL
         GjyA==
X-Gm-Message-State: AO0yUKUmndon/U+9VL2Fk5+DbnqHYxC3J8gX3husPzPadkkHvzzi/tKd
        njmq/qzbOok1GFrs/ECxWq3PCffZV34=
X-Google-Smtp-Source: AK7set9SaMo9esIin3QfhGtaAPr+Taa8pf+AmaYxRZlcsspkh3rbeDuEeWeqSJzmoNUbCuc7Is5QXPbYerU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:69a1:b0:23f:695a:1355 with SMTP id
 s30-20020a17090a69a100b0023f695a1355mr60129pjj.5.1679338273401; Mon, 20 Mar
 2023 11:51:13 -0700 (PDT)
Date:   Mon, 20 Mar 2023 11:51:11 -0700
In-Reply-To: <20230202182809.1929122-7-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com> <20230202182809.1929122-7-bgardon@google.com>
Message-ID: <ZBirHz+aQJHxvuV9@google.com>
Subject: Re: [PATCH 06/21] KVM: x86/mmu: Get rid of is_cpuid_PSE36()
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02, 2023, Ben Gardon wrote:
> is_cpuid_PSE36() always returns 1 and is never overridden, so just get
> rid of the function. This saves having to export it in a future commit
> in order to move the include of paging_tmpl.h out of mmu.c.

Probably won't matter as I suspect this series is going to end up a burner way
in the back, but FWIW I'd prefer to preserve is_cpuid_PSE36() in some capacity.
I 100% agree the helper is silly, but the mere existice of the flag is so esoteric
these days that I like having obvious/obnoxious code to call it out.
