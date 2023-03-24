Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822B56C8961
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 00:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjCXXi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 19:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjCXXiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 19:38:54 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E861C1FEA
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:38:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5458201ab8cso33005387b3.23
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679701129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2dnyoD6VWM4xW2f/BvT9EKeRZfC67qcdFu+S762Gjo=;
        b=H0NOwMU314Q5/XFq3ro3x4baTmxBeI1CtF8wSXMacBu4RkxHOVfqtW8EakMrXY/MuY
         tARQg2LRKQWGSKMkuyP9hP/yTgfsxv5xxeuCyxNu5t8WOaWhRSMW/mogT8zKHA7gSeCb
         umYmvhSiMwYI1uUBq7qLY87j543BM+Fxt1f/k7mkvXKXNEdDj7XvorbFD0G5Q4lkTehT
         n7RKBFpYyGuRAkFhZ1CAEfWsbv9CiJAPlc+MwCaBYmD4RdTkIjv/zO4P9VDF8/rvyu00
         dsT4IevGrnVqOUuaEd0CLwSHEHCJ1kpBaujRJORSmPsm65/bl/YpwOsCqSZpOhvrViAa
         ofNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679701129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2dnyoD6VWM4xW2f/BvT9EKeRZfC67qcdFu+S762Gjo=;
        b=g0Ky5rnxOJpF3jzwTVZjuoLmvjv3qHE30IvaIhcM/GY6P0oGgpfsj2en4YRYlR2nhV
         6XQOn0sa8pp4E8bK/T9SnvcdLBwKmOd4JppdRfxYLLHMy2cifl2U1rYySYb84P9EAj6P
         RFpIMg4VZtdE6vX1VdFiUjIo3Eiq7pcylSh3o4Y8NwGkiAkCSL62Si4zxpP22Y0NjQX0
         QVqtv9obavb0VNv27aJFxWnVOQzaU1ONluzr/NfOlfgZNaYGCgGJBaSYqhVy628LjySd
         VATabdXgGEmRRrGQYMB8qMf/jPeoUdu7ugEftcy4c4+BCVBeS2QQJsnnC4+nOt6bncmm
         V4ZQ==
X-Gm-Message-State: AAQBX9dQ+Ifocg6jml7L6rYvHCJ4y2JWsATR4g3MIpa1pWPohKL/U++H
        KJqYJ+1ofpd2NbaMz5Pnj89c8E3QmGk=
X-Google-Smtp-Source: AKy350bZGUre6Bzcbvmk+y2F5rIOewj0Q8wKexpqKj4LUzk3IIf4OJgNoJ8KiANlvItQ/6aqu+S/2Hf/Iuk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b65f:0:b0:545:611c:8d19 with SMTP id
 h31-20020a81b65f000000b00545611c8d19mr1904621ywk.4.1679701129182; Fri, 24 Mar
 2023 16:38:49 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:38:10 -0700
In-Reply-To: <20230308072936.1293101-1-robert.hu@intel.com>
Mime-Version: 1.0
References: <20230308072936.1293101-1-robert.hu@intel.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167969131862.2756020.6614712034582392847.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Remove a redundant guest cpuid check in kvm_set_cr4()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, Robert Hoo <robert.hu@intel.com>
Cc:     robert.hoo.linux@gmail.com
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

On Wed, 08 Mar 2023 15:29:36 +0800, Robert Hoo wrote:
> If !guest_cpuid_has(vcpu, X86_FEATURE_PCID), CR4.PCIDE would have been in
> vcpu->arch.cr4_guest_rsvd_bits and failed earlier kvm_is_valid_cr4() check.
> Remove this meaningless check.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Remove a redundant guest cpuid check in kvm_set_cr4()
      https://github.com/kvm-x86/linux/commit/99b30869804e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
