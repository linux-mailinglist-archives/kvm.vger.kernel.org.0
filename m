Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903596DA662
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 01:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjDFX7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 19:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjDFX7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 19:59:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5280583F6
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 16:59:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b124-20020a253482000000b00b72947f6a54so40714577yba.14
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 16:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680825541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QMEPAF1E1IZrnwY8tvnyjvRvlqSvc75nThGi8TdMbSk=;
        b=I5M+mpkpEo0DpZjjc3xV/1Vnwnko9JlfUhRuT2hJz5PbN2QhxkFAEn/XBmbtG+8J3V
         Yo+IgIYa8xU4t1HA69pek6UjKqXVGp7OI0WjNiE1fIuO+b17QWIb014gxo67WBQti0gp
         fAlezY6tJ5AeHR3gZag6OqV0JabdUQIX9Aa58BOzm//JVlwPk94SMLG2hM6QBX2Damkx
         gdleJfoSbTtrihBnovd/u1r997cA8z6OzJoFIX5pEvJAVMZ+3BORW8pg0KgsHVW0fdCA
         a34BhxPLJ9wqnK+8n0JdKkJzVjWQ5skz5VyUI1ewbsU5Mx7IVpYlOLl80UPHQLUA99kP
         T/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680825541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QMEPAF1E1IZrnwY8tvnyjvRvlqSvc75nThGi8TdMbSk=;
        b=0vRarIsKmsJuYriW7J4iQ7sEfWMmj5UkEt3vfP/CX6FfCU8zn6fQNCZT2B6TzWU82x
         lGJ3lyeY8Stmimgo/xW2zhpYxtQwzR7h2vjUgmry114ZIe46gYBv3pes0n0MlYoh3dSs
         CEDvh2t+3ukg769g2HSyUZSzDhfLbVo2fVTUexpla7UZAoiG4vMXqnlugqiVmgBHCo2d
         GS/rQLP8sXPLvgUBhQavqIiUkNDM5l+4URWy+0xreq2kF8Xu4JnL5jhRw0xXaISHVBSv
         WHKTieWFSDYamOXKUtBKzIN0KD81T7bMOc33sg6+21JyWf9SssJJ0Oj0zL1Tb4N2GTKc
         ECvA==
X-Gm-Message-State: AAQBX9ed/vwRwxhegqEQwhsLTMlS4X/AzjshzK12nYBGR9iyTCiyHh/u
        1nTa5VAPH3YtfHLgBwzHDKO+6CRRNMw=
X-Google-Smtp-Source: AKy350ZsWx/CKdBWfQUpkDo9VC27TVKeH2Q9lZ8nOXSntM6FUNrGRiEzlqVLgWBAabELoR7qx7GNBRlVlls=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b384:0:b0:544:d154:fd3c with SMTP id
 r126-20020a81b384000000b00544d154fd3cmr65417ywh.1.1680825541640; Thu, 06 Apr
 2023 16:59:01 -0700 (PDT)
Date:   Thu, 6 Apr 2023 16:59:00 -0700
In-Reply-To: <20230214050757.9623-8-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-8-likexu@tencent.com>
Message-ID: <ZC9cxD6lLcF5tYHF@google.com>
Subject: Re: [PATCH v4 07/12] KVM: x86/cpuid: Use fast return for cpuid "0xa"
 leaf when !enable_pmu
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

KVM: x86: Explicitly zero cpuid "0xa" leaf when PMU is disabled

On Tue, Feb 14, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Add an explicit !enable_pmu check as relying on kvm_pmu_cap to be
> zeroed isn't obvious. Although when !enable_pmu, KVM will have
> zero-padded kvm_pmu_cap to do subsequent cpuid leaf assignments,
> one extra branch instruction saves a few subsequent zero-assignment
> instructions, speeding things up a bit.

Drop the performance blurb, as I stated multiple times, optimizing this code is
a non-goal.
