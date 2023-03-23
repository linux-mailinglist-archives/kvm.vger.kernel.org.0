Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319986C7351
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCWWvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjCWWvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:51:08 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351E27AA7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:51:06 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id qa18-20020a17090b4fd200b002400d8a8d1dso1475378pjb.7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679611865;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AqFc8A4lyhPY/42dCbIU0IYFB1GySYWnAocQAi1+h4Q=;
        b=BPiGWjMeDRpQTgZB97UOimTIL3OYBXSDT/6fJgZVC6gQgZ5fCzvw1lRDNKKawrXLv2
         E4PvzehXk27nt/drVvcaTHR9RfvY1ewNnFoU10fr+1Bw5wJGJAEvr9IlV+tYUIe1jSLS
         go12kdYqwO37wrDkww5Pk4Sg28nsUokR0/t6+6HxBHhBgfvCdRRiq82yIPmJWwekGzv5
         7hiF3kgoFEvlUc2wb11M9OqS7XWiI6j6q12XRxrhO9zaDi8/tNMkKP01RUNiQlh4ugyh
         6GgqD3giutQ3Oy505lN1UgV0cSUu3sK69NQGcsNXXvMU0zCcFLrIZTwUHA23JZUJ87hE
         wwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679611865;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AqFc8A4lyhPY/42dCbIU0IYFB1GySYWnAocQAi1+h4Q=;
        b=5eRe198ctP28MqbTJfIxFRYBUunr6W3UF719jzywquxIsw3eLTjr2qBTpQnvKmL8Yh
         2OwkhGI3J6sU9fv7k9lJE2CDGm4uxRFNfr9FpDWijN1HlPQty7xsxiYYXhW6XelXi41l
         hswWlLrmPnEerq5hTsh/8ACuQbBVewzHqkePfRvEVpuhQT/PZ716lNihsN042FxQLh2q
         Zr47AGEEkiOUlZUTtDSU2n6UWKfg2677sOfsFu+OPDELo+tS+6FeJPz/sj4OfgdsHo/G
         vpmm8jsftEPzh8xOhl3DqQBtNzm8Umb3D6Cx7eN7Xv36L3NQJXZ5hwLkjSUDTK12xmeB
         1XAg==
X-Gm-Message-State: AO0yUKU7opJrrJEdBhE+hqcu20TXDU9eJtWEpZgCWLzvW8a5UrseCJ9p
        6S1r4Pv++z6thpBPUaG6kE4e3eDj9Fw=
X-Google-Smtp-Source: AK7set+c5Oe8EOFfr51iU86OvsiSeB7dYNOcFLpSUDdYqdgPEt9K+BfSwaK38fcJtMRO5Wf6VIN+Mei8mGY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8891:0:b0:5a8:daec:c325 with SMTP id
 z17-20020aa78891000000b005a8daecc325mr3364999pfe.1.1679611865307; Thu, 23 Mar
 2023 15:51:05 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:50:30 -0700
In-Reply-To: <20230113122910.672417-1-jiangshanlai@gmail.com>
Mime-Version: 1.0
References: <20230113122910.672417-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167934153606.1941128.1026865175616779306.b4-ty@google.com>
Subject: Re: [PATCH] kvm: x86/mmu: Simplify pte_list_{add|remove}
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Jan 2023 20:29:10 +0800, Lai Jiangshan wrote:
> Simplify pte_list_{add|remove} by ensuring all the non-head pte_list_desc
> to be full and addition/removal actions being performed on the head.
> 
> To make pte_list_add() return a count as before, @tail_count is also
> added to the struct pte_list_desc.
> 
> No visible performace is changed in tests.  But pte_list_add() is no longer
> shown in the perf result for the COWed pages even the guest forks millions
> of tasks.
> 
> [...]

Applied to kvm-x86 mmu, thanks!  I added quite a few comments and a BUG_ON() to
sanity check that the head is never empty when trying to remove an entry, but I
didn't make anything changes to the code itself.

[1/1] kvm: x86/mmu: Simplify pte_list_{add|remove}
      https://github.com/kvm-x86/linux/commit/141705b78381

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
