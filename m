Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4A86C73D6
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 00:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjCWXDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 19:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjCWXDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 19:03:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F2CEB71
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 16:03:46 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54476ef9caeso1181427b3.6
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 16:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679612625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qekwgGC0xRX3K6DWcKWey+3EZoIXPhmnZFalhCYYdOw=;
        b=VsIRj7Thrs8LotUFl5cLTOnXbLC0XnExZXKRdypgTtuQ8rhoABNg+8iK8K00Bq7o7h
         dD5DkxIp97Ozv9U9s575NFrcIr5/XJL8LNFT6Wt44ib//kEqh3UFFXXGsCqkuohgoREf
         bwgo5qGHA+dZUNOxICbtmfC7jaxMCDvY+EDYhumRc0+ot9fjWxZwzsgzFoemDiHAes4I
         bEtRfqAZeX32oDUMONrr/w20gtAPGSbdzr1MUzZK1FpVs9iSMoiTDzRCXcy395VrxiqQ
         DooqBZn/WPAtRcJ+JkOaM08xNA08nI9Wlv65I9ttQmf+lPXdf4Auf1weoTurCSkn7oGz
         IFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679612625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qekwgGC0xRX3K6DWcKWey+3EZoIXPhmnZFalhCYYdOw=;
        b=3AFEo/8LM4D1c+839IFdziS8tKxpLd7CP7vIMe+jICj7/Daxc4qC5ysDgjsKkIGwC8
         CUKNYyhEpqeClLqjlEIn+DXlzweahd7yS1EZeKdnokeBtUHCtL/idsoqn6GM0w92Ea+t
         pGLzNU7h3tX9eZeBuJIFdD9gG1QvHE0rgzI5w2lBnyLO8c7sDnYpM3u7aN/A9b6xC8Nj
         v2ZF9GSJTuCo9/4qBqehVFvUj4N3PelEgej92E2ymV5OIg938Y0uoKCgse9hfaLqyE8R
         HSRSwOH7CdbAC3RXdVNYI/geqYH3eVenxkE2+/fVBj7RavxESKYz/peaZzlR0eFVwh8d
         wcHA==
X-Gm-Message-State: AAQBX9cMgc5etuuq/2OnLBCxCdlN9jE87e48agTD1hApdDJbB2pCvf4k
        ocFDTLkZJx9s0ih5rFruW+dljx5t55c=
X-Google-Smtp-Source: AKy350YlNeIun48L5LqOQcfyTQw1OzYp4VqvTVqNfqETIJmSMG2ZAwEOMEOj2p4RSMVJCDIItZypOwoh7i8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bd46:0:b0:533:99bb:c296 with SMTP id
 n6-20020a81bd46000000b0053399bbc296mr101924ywk.5.1679612625458; Thu, 23 Mar
 2023 16:03:45 -0700 (PDT)
Date:   Thu, 23 Mar 2023 16:02:04 -0700
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167961243530.2554153.5370298632861319341.b4-ty@google.com>
Subject: Re: [PATCH 00/21] KVM: x86/MMU: Formalize the Shadow MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

On Thu, 02 Feb 2023 18:27:48 +0000, Ben Gardon wrote:
> This series makes the Shadow MMU a distinct part of the KVM x86 MMU,
> implemented in separate files, with a defined interface to common code.
> 
> When the TDP (Two Dimensional Paging) MMU was added to x86 KVM, it came in
> a separate file with a (reasonably) clear interface. This lead to many
> points in the KVM MMU like this:
> 
> [...]

Applied the first three to kvm-x86 mmu, which just makes me look like a jerk
since they're all my patches.  :-(

[01/21] KVM: x86/mmu: Rename slot rmap walkers to add clarity and clean up code
        https://github.com/kvm-x86/linux/commit/727ae3770132
[02/21] KVM: x86/mmu: Replace comment with an actual lockdep assertion on mmu_lock
        https://github.com/kvm-x86/linux/commit/eddd9e8302de
[03/21] KVM: x86/mmu: Clean up mmu.c functions that put return type on separate line
        https://github.com/kvm-x86/linux/commit/f3d90f901d18

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
