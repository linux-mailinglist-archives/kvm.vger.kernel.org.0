Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2BA6C734A
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjCWWra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjCWWrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:47:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455992CC53
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:47:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a2514d5000000b00a3637aea9e1so134659ybu.17
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679611642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8E8aVCuWhbqtZyGkZuNmwdDgkAd71MfzJql9l0jhThA=;
        b=TyUs67XkS8j4MQcuHutRsZYkDHwDAQfZKPJ9vlBjgTOsoCJbkHCJJr6h8wIldoywSH
         ggacQxcshFMFvxWyIJQdD19qNfi+Fhm+Y2Tyzlc1QlNPbxTtLWKpdE4DTv+t0za3AE7v
         e0QDtpR0I1HUBCqsHC+uNDIQKm7Wu1GzlLcLQDuCcYZCCTTFmahW7yDoF/157w2I6wxM
         zbrkEtaiYqkiLDu8/XYpPAyy+XjanCwL3maT6GBSPAd0jBT4K6NvyHiOzf9hPa59W+WM
         moXP3ruj8QQ/CXez4lyiVF4S/jqeD7/Q5kBPp2NtOdHMA6fl/SWRGZ4GudasV07zpWhA
         q2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679611642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8E8aVCuWhbqtZyGkZuNmwdDgkAd71MfzJql9l0jhThA=;
        b=2MBvx2SbL46ZBerlmsVZMtmdypDMDWRkk+ZytMy9uJ5GeuONjfeMusEej2uSPsnvGU
         F8cDX87Icx1mzRy5aKwFUFcQPzNjficjef4cnsHluhwDyeKJ/5apUsz6wvPiGHp88Tw2
         9z3/PgnLs7mBWzW84F2sdfbxxaoNNzw9j1r7k4PKIufKyLxIjDs/AKqn62ZzWpzXn46d
         oUT3Fk6TPL+Ld/T40Qwb4KCiroyFRqsVsdfY7aVVHFKFZwK4VYgVYZ8I+/FQzcvqQ9sR
         2kaNhd2k91/oIhRIP0wzdNVpre36WQeWbWj7wEIbtdrwHyoohpp49Qa8n3yK3X4kTFv+
         y4Aw==
X-Gm-Message-State: AAQBX9cCJZ+jgyx2cELAkNQ6qhxBFhFhcF7884N9nsuY7YGYde1ZRcfr
        jXpVegINlFKrOBfI1j1sjsRBGMyGAYU=
X-Google-Smtp-Source: AKy350a1Hs8kWPC5vHclIwfawQpHAs1pPWg6z4yhzb6SHPk3z4AtSwRQaevo9Dw0nr5ifvd2wCSI8PCjjhw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:72e:b0:b6c:f26c:e5ab with SMTP id
 l14-20020a056902072e00b00b6cf26ce5abmr166454ybt.3.1679611642610; Thu, 23 Mar
 2023 15:47:22 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:47:15 -0700
In-Reply-To: <20230322045824.22970-1-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230322045824.22970-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167950573701.2278450.5893007925720724250.b4-ty@google.com>
Subject: Re: [PATCH 0/4] Add and use helpers to check bit set in CR0/CR4
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, Binbin Wu <binbin.wu@linux.intel.com>
Cc:     robert.hu@linux.intel.com
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

On Wed, 22 Mar 2023 12:58:20 +0800, Binbin Wu wrote:
> Add two helpers
> - kvm_is_cr0_bit_set()
> - kvm_is_cr4_bit_set()
> to do CR0/CR4 check on one specific bit and return the value in bool.
> Replace kvm_read_{cr0,cr4}_bits() with kvm_is_{cr0,cr4}_bit_set() when applicable.
> 
> Also change return type of is_pae(), is_pse(), is_paging() and is_long_mode()
> to bool.
> 
> [...]

Applied to kvm-x86 misc, with a fair bit of massaging to the changelogs.
Thanks much for putting this together!

[1/4] KVM: x86: Add helpers to check bit set in CR0/CR4 and return in bool
      https://github.com/kvm-x86/linux/commit/607475cfa0f7
[2/4] KVM: x86: Replace kvm_read_{cr0,cr4}_bits() with kvm_is_{cr0,cr4}_bit_set()
      https://github.com/kvm-x86/linux/commit/bede6eb4db19
[3/4] KVM: SVM: Remove implicit cast from ulong to bool in svm_can_emulate_instruction()
      https://github.com/kvm-x86/linux/commit/627778bfcfa1
[4/4] KVM: x86: Change return type of is_long_mode() to bool
      https://github.com/kvm-x86/linux/commit/68f7c82ab1b8

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
