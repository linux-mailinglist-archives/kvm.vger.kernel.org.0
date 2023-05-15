Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF41703B32
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 20:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242332AbjEOSAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 14:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245122AbjEOSAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 14:00:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ABC1BB87
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:57:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a7d92d0f7so23886780276.1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684173429; x=1686765429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=99srR1wR+oKvE5/WokGr4LZs8iI5brQIGfN7GCM4UrE=;
        b=qgBmAUsdMhWoFgdfIMBysrOMi/gESv0r34Xoj0igegtNAqMmPuZYSN8teIqqNTO4qr
         +o9xeOyk9osBGJxQbQuznSPE37lto98WL25ntsbJrltXSslcw1N9UwCjtAleA783eS5O
         9YwANM1uEr3ANtlR1gIiXFGuiQX6HZHez7Az1JmZfWcgZ8XXRvwsKlQVSp1qYogeiohP
         HZiUVEoNqJwtMnWDAcgFy21hoDfY46Zz54Xrc7sGdVcVXFt7SRAKBWqGimi1IwSKlxe6
         LTURlyPrfkfy2KvuKglvcB3GJiMGve4uIMdIImYsP6Uo1qtixcy8iwFrsPFnos8ejlvp
         S2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684173429; x=1686765429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99srR1wR+oKvE5/WokGr4LZs8iI5brQIGfN7GCM4UrE=;
        b=eXP7YrEvBohlBOgwsKb9xeHihEkMsAESU7RTirqcTam5gWGxDffwpdmCtG52w33McT
         iEYIfAtKSuEEsQ73PsehPuS4Z8Q7/H0N3WJs0z8MVilNyqEAZNFAuNWGUO0g7UF2OO6S
         OduK31WimlRZMTME2RBiWowHghZ1WvYWFTqzSI1bFotffxzhPLMLui0Ri2Nhq76Dqbcn
         5iGJuDLrTwGqouT4mIkJ5/K0YLQmDxvQyp4PzAY7AHXyHlQYf3uFqREqhyIjw0g5ikH6
         gL/7R4PTSipyym91MP+ITgWzn7pLcNI67iL9cwPwmlUCUgHmjmzTtpz10v6hWoh+z3Z+
         EuIQ==
X-Gm-Message-State: AC+VfDzPySHF4lSgG5Dl0MqYOpkCJIliMD4o3oaJs19/acIB3/gHUHV/
        Kowb238SoNAn53Xp1fWpq2fOmly0tAY=
X-Google-Smtp-Source: ACHHUZ4He0csQ4Oev4VXrHXbI7rX8wyUIkfOSTVuja6DxDI6qDgf1L+qcXE8dfIu5YKaWZQqJrs9xqp4fJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5454:0:b0:ba2:1a28:c852 with SMTP id
 i81-20020a255454000000b00ba21a28c852mr14179279ybb.7.1684173429090; Mon, 15
 May 2023 10:57:09 -0700 (PDT)
Date:   Mon, 15 May 2023 10:57:07 -0700
In-Reply-To: <66685365-86f9-9ddf-d63b-f87621b05b88@intel.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com> <20230513003600.818142-6-seanjc@google.com>
 <66685365-86f9-9ddf-d63b-f87621b05b88@intel.com>
Message-ID: <ZGJyc7k1Z4gXQH2U@google.com>
Subject: Re: [PATCH v3 05/28] drm/i915/gvt: Explicitly check that vGPU is
 attached before shadowing
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi A Wang <zhi.a.wang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Y Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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

On Mon, May 15, 2023, Zhi A Wang wrote:
> On 5/13/2023 8:35 AM, Sean Christopherson wrote:
> > Move the check that a vGPU is attacked from is_2MB_gtt_possible() to its
> > sole caller, ppgtt_populate_shadow_entry().  All of the paths in
> > ppgtt_populate_shadow_entry() eventually check for attachment by way of
> > intel_gvt_dma_map_guest_page(), but explicitly checking can avoid
> > unnecessary work and will make it more obvious that a future cleanup of
> > is_2MB_gtt_possible() isn't introducing a bug.
> > 
> 
> It might be better move this check to shadow_ppgtt_mm() which is used
> in both shadow page table creation and pinning path so that the path
> can bail out even earlier when creating a shadow page table but a vGPU
> has not been attached to KVM yet.

Ah, yes, that'll work.  I traced through all of the paths that lead to
ppgtt_populate_shadow_entry(), and shadow_ppgtt_mm() is the only caller that isn't
already gated by INTEL_VGPU_STATUS_ATTACHED or INTEL_VGPU_STATUS_ACTIVE (ACTIVE
is set iff ATTACHED is set).

I'll move the check up to shadow_ppgtt_mm() in the next version.

Thanks!


workload_thread() <= pick_next_workload() => INTEL_VGPU_STATUS_ACTIVE
|
-> dispatch_workload()
   |
   |-> prepare_workload()
       |
       -> intel_vgpu_sync_oos_pages()
       |  |
       |  |-> ppgtt_set_guest_page_sync()
       |      |
       |      |-> sync_oos_page()
       |          |
       |          |-> ppgtt_populate_shadow_entry()
       |
       |-> intel_vgpu_flush_post_shadow()
           |
1:         |-> ppgtt_handle_guest_write_page_table()
               |
               |-> ppgtt_handle_guest_entry_add()
                   |
2:                 | -> ppgtt_populate_spt_by_guest_entry()
                   |    |
                   |    |-> ppgtt_populate_spt()
                   |        |
                   |        |-> ppgtt_populate_shadow_entry()
                   |            |
                   |            |-> ppgtt_populate_spt_by_guest_entry() [see 2]
                   |
                   |-> ppgtt_populate_shadow_entry()


kvmgt_page_track_write()  <= KVM callback => INTEL_VGPU_STATUS_ATTACHED
|
|-> intel_vgpu_page_track_handler()
    |
    |-> ppgtt_write_protection_handler()
        |
        |-> ppgtt_handle_guest_write_page_table_bytes()
            |
            |-> ppgtt_handle_guest_write_page_table() [see 1]
