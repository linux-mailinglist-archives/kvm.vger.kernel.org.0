Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D2D6743CD
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjASU6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjASU4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:56:08 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3E94C32
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:55:31 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4fb212e68b7so24684547b3.0
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7fI85XABax6CE1jNNhi9yCUkpck1zGw624Fdq4pyak=;
        b=bqqaMmG+/CEA/HE9qA7YcWGxhrDx8X7soMAGZZ/Q6hCDN9M0thT8I8odWemTiWHYea
         nFdb5S8aY6RRcmnxZ+M77J1p5WJIvD2dr0lDK/qFjlU+3O+oQ3aBwD4o2sbQ8WGCfm+N
         a3R3tMbK+U1LBlIBwpq/OavBHl+mqtDlh3pmKj2aRsIxkTcRpDSeLyk8KvorfpP8cMk5
         sK4UQCR7jnm+dhDtsSQzt+FXp75NBpSDZh9ve6LtdJOQQgpGzk8Wdq81fWjGlGa346v4
         ID8FKVsYuqEK3refHzinZLtrGl/dMM6ryZ7ASBHRTF8R6YEdACr/s7dkT2XlvDJ/rARf
         xJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7fI85XABax6CE1jNNhi9yCUkpck1zGw624Fdq4pyak=;
        b=GKCLiiDvkZYi6nGit9PugkbNo9HQTCtV2ZJlEUxWdGl0yGlc9q499RlJX4e+jq0Iyk
         GilnMfimojDRB2Cbu2S9WL5ZLNex+UySbdi8I3GVCY7EKhDZFuxbTDLqxY6nqqhql2f0
         iCEtWFE1BXsDvzTJrUJ8WGhagLrixaAIjd20F+LWUXxSE7PcZ4RtsdBHvqOKmhnNHCYd
         2yKFOFMevO0AoRhfG0+wPUAjTWTAX5+KDHDrJGccyeVI+bLP4t3WuwHkhKi2uwwJG9mk
         gX7aA6xY6VSCa8eEZ4WG+D26rQD8trs+DFA7CZMrRHmNYsZ5d45XSvcY87+oPA/4hRCu
         TVCw==
X-Gm-Message-State: AFqh2krcfM/Ny+R4jAYd7wkNtmU5O+a/pxWXDhYruzjG2+0+OqtAILU3
        DGB7Sc47YSGmr8RRVpQvVxJaa3WdWPU=
X-Google-Smtp-Source: AMrXdXtcZlLJLiYaPzvAsftAgCeJXgtZP4ubmEZiK6f5isqNi41hurQk5tr53uJNanJgDEUePKWmpEceSJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:793:0:b0:4fe:fc97:58d1 with SMTP id
 141-20020a810793000000b004fefc9758d1mr2229ywh.91.1674161730824; Thu, 19 Jan
 2023 12:55:30 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:54:02 +0000
In-Reply-To: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
Mime-Version: 1.0
References: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408992939.2370458.7888282998581500159.b4-ty@google.com>
Subject: Re: [PATCH v4 0/6] KVM: x86/mmu: Fix wrong usages of range-based tlb flushing
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Oct 2022 20:19:11 +0800, Hou Wenlong wrote:
> Commit c3134ce240eed ("KVM: Replace old tlb flush function with new one
> to flush a specified range.") replaces old tlb flush function with
> kvm_flush_remote_tlbs_with_address() to do tlb flushing. However, the
> gfn range of tlb flushing is wrong in some cases. E.g., when a spte is
> dropped, the start gfn of tlb flushing should be the gfn of spte not the
> base gfn of SP which contains the spte. Although, as Paolo said, Hyper-V
> may treat a 1-page flush the same if the address points to a huge page,
> and no fixes are reported so far. So it seems that it works well for
> Hyper-V. But it would be better to use the correct size for huge page.
> So this patchset would fix them and introduce some helper functions as
> David suggested to make the code clear.
> 
> [...]

David and/or Hou, it's probably a good idea to double check my results, there
were a few minor conflicts and I doubt anything would fail if I messed up.

Applied to kvm-x86 mmu, thanks!

[1/6] KVM: x86/mmu: Move round_gfn_for_level() helper into mmu_internal.h
      https://github.com/kvm-x86/linux/commit/bb05964f0a3c
[2/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in kvm_set_pte_rmapp()
      https://github.com/kvm-x86/linux/commit/564246ae7da2
[3/6] KVM: x86/mmu: Reduce gfn range of tlb flushing in tdp_mmu_map_handle_target_level()
      https://github.com/kvm-x86/linux/commit/c6753e20e09d
[4/6] KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
      https://github.com/kvm-x86/linux/commit/4fa7e22ed6ed
[5/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in validate_direct_spte()
      https://github.com/kvm-x86/linux/commit/976d07c25056
[6/6] KVM: x86/mmu: Cleanup range-based flushing for given page
      https://github.com/kvm-x86/linux/commit/f9309825c4b1

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
