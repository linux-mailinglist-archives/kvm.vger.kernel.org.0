Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E93D780290
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356621AbjHRAKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356669AbjHRAKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:10:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AA73C0C
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:10:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589a45c1b0fso4493587b3.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317417; x=1692922217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RGYnYnVbUYYSVjFpVMoKW4GyT9YCBE6+MRRcctXwEms=;
        b=OwwpahlSHn2WsIv1jkm4dgZeh3mellgfhBb+bvzTHjWkiT+62ofbR17Ov4Vln/EL95
         +GZK48JqTNYW8cVAOeMYt0FYg7M7t014+KHZMsKaktOCA0yzf6qzJvkrc0KdxNgwSpOi
         i5jgTWnJXc07CQC4ahI2mJT+F8kg3Gc0yeQTWWmrX2Au+8wMspjdo6FTFSJszTF3m13p
         +Qjr/EBF5Y8m+9rLgXZIOz1ZohfkR8EHgonAVSAqhQd+R4g/EpPnhQ6EnRVEM44/4HKU
         LHfU+8kMBuA9Qz4IrWdO4O/gADP2+fggFNyyAIhH9UaTYVZ/JxxdDvvIQOpDRvrBmJbH
         YrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317417; x=1692922217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RGYnYnVbUYYSVjFpVMoKW4GyT9YCBE6+MRRcctXwEms=;
        b=iyB7z/2tYgnu+O9AIzLbSxxaIAyxGFkxqp3C8bhF2NtBo8QPf/hmuZdQGY5HUXrnXu
         REG5PHYEQG5B1AaIBlwELuurRuH3hU90oQVyrQLqFp8lWWmOq/f9GPhqMK9eH8MImTy9
         LQHLpCSvYBHIEVo+2gYIcnDHZRCbb54woP0bgGtiNsiYH/GD2UT81JjuU22xnGsV5KF0
         zeBfbb4aQ4M2/R4WAHHFO3sGGUu3Ft/R6GQw/7lPhhpmAPG5gL0SPSeybyu4hwEehDMo
         baqdajSk95k0Jau+oQZKLQhmloPYAceGcS8nu0WejHAZ17+XpRZdhRtN+Yvoaz6GAMFQ
         6OGg==
X-Gm-Message-State: AOJu0YyC92mb2zd1j9gugF6HXgx7fo1xrplmITmHDIjuuvbKYa/jPo2W
        vX7WKpm0W2fQz5KRotKO1nRovWP9n/o=
X-Google-Smtp-Source: AGHT+IFqs4TVheY2Zgf/ctECuRnI/YyIKKz9RpWYLL1cdECAJN9/STpqQHHXgnjfGW+ewzuoY9b6f0Ta13Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1813:b0:d0c:1f08:5fef with SMTP id
 cf19-20020a056902181300b00d0c1f085fefmr13826ybb.12.1692317417588; Thu, 17 Aug
 2023 17:10:17 -0700 (PDT)
Date:   Thu, 17 Aug 2023 17:09:22 -0700
In-Reply-To: <20230808232057.2498287-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230808232057.2498287-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169229705756.1237266.17952019495946517627.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Remove WARN sanity check on hypervisor timer
 vs. UNINITIALIZED vCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yikebaer Aizezi <yikebaer61@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 08 Aug 2023 16:20:57 -0700, Sean Christopherson wrote:
> Drop the WARN in KVM_RUN that asserts that KVM isn't using the hypervisor
> timer, a.k.a. the VMX preemption timer, for a vCPU that is in the
> UNINITIALIZIED activity state.  The intent of the WARN is to sanity check
> that KVM won't drop a timer interrupt due to an unexpected transition to
> UNINITIALIZED, but unfortunately userspace can use various ioctl()s to
> force the unexpected state.
> 
> [...]

Applied to kvm-x86 misc, with a tweaked comment to avoid "smother".

[1/1] KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU
      https://github.com/kvm-x86/linux/commit/7b0151caf73a

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
