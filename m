Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E096C6AB3
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjCWOVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjCWOUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:20:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F7B33CEB
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:20:23 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5416d3a321eso222283207b3.12
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679581222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QRX6sPRd8a6SahqYkbNk803jOwTEEdt3q5tQLScdFlk=;
        b=OSk5klwKaXYV/X4alxHR+Vdkd4KrCGvaIkocdeCGrG1eEAZBBZW08zMpFUz6imPBSR
         fZbTxAd7/mRgnvhBLwScLg7OiZBvLm/7bBUIvu6aQ7WrGHvPqfkNjEQkPbjDhRY2dZ5N
         Aow0le1bRns4qUYXhvOW4L52+KS3MfLD3GJXYG27U2PsfkgM0jg5IKgpaeDgUtkMIVHx
         WRxTsF56pJ+kA6RAmQogg3eEg+JqJsehB4tAi3M2Jws27S5uaJ2ITab2Y7FrFsxLqC+/
         UKUhPb5TU/MbmsyGSFhT4DtiISzUWRVmb18IbRCDOymU38TsQYPdpea6YU9gKsMvXfGP
         AgzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679581222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QRX6sPRd8a6SahqYkbNk803jOwTEEdt3q5tQLScdFlk=;
        b=JC9OdwQQKIAOuMjszmRX1pZjG5dWBo3Wr8iiHxY6Ocg2xd8u1uIDtP4v4zrc2+dxCt
         2zCuFzR0u42mvuPHVf/rVVwTxVgCYW317bnl5bgWXvr2ApBkuj41jMRwDCJjhQjsy2fD
         ap9FEl5lI0E2K1XP0u97lwlOWKbgGOufanVIjVgG6DSZQVjUU+jySVN0Osvv5HMOmVgi
         3m5N2/6T4wBkBv7Af0GYl02GZ/tGDRFY6hqwLZUnsUkhkKC/872XKrRhGb95gDvTTKGZ
         L5LUTCxeftFAehbupl5gwpCkLKuFLED32p10ygBSJLnf6tEAONPzvfSaoYyJ0/Hk7ylv
         TVig==
X-Gm-Message-State: AAQBX9dWFK2XnbK+6EdY76Tr2pHMHW05IkARmp5usGFYyW2j7DM/F3TZ
        gb6QUMjxdfuSIS+5STwkOLpqpf6QPp4=
X-Google-Smtp-Source: AKy350ZDjOZv1GjhY+V0sPes42kEydeYNBZ3Z3KV7pjwDgETBQNX+Rlz32gXgbj7ye6wD99ouvES7uZr/sA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:72d:b0:b48:5eaa:a804 with SMTP id
 l13-20020a056902072d00b00b485eaaa804mr2025042ybt.0.1679581222595; Thu, 23 Mar
 2023 07:20:22 -0700 (PDT)
Date:   Thu, 23 Mar 2023 07:20:21 -0700
In-Reply-To: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
Mime-Version: 1.0
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
Message-ID: <ZBxf+ewCimtHY2XO@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
From:   Sean Christopherson <seanjc@google.com>
To:     lirongqing@baidu.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        x86@kernel.org
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

On Thu, Mar 23, 2023, lirongqing@baidu.com wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread
> is not needed to create

Unless userspace forces the mitigation to be enabled, which can be done while KVM
is running.  I agree that spinning up a kthread that is unlikely to be used is
less than ideal, but the ~8KiB or so overhead is per-VM and not really all that
notable, e.g. KVM's page tables easily exceed that.

The kthread could be spun up on demand, but that adds a non-trivial amount of
complexity due to the kthread being per-VM, and KVM and userspace would have to
deal with potential errors in a path that really shouldn't fail.

If we really want to avoid the overhead, one idea would be to add a "never" option
to the module param and make it sticky.
