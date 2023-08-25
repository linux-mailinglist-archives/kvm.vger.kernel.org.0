Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E881788F12
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjHYTCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 15:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjHYTC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 15:02:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E122127
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:02:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d72403b9e03so1523597276.0
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692990144; x=1693594944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2K0JSd6jxFl8ipBHN+l565B5wkNlVNWV8ekqr5bF1n4=;
        b=qHVFfUV8BKk0oZU9PwHloLgH4qETAfSzOtrxF8+gycFEWyDAPyHO43wFaRRhNQJ2Vc
         fGRYsMtykC4NKXEPkKvxahmesu2aqIhOfYn7+NQ+90GP86wailVQVfqqLVxZqSlm0lcu
         rGCiLMYcNn/W7VuDir3peiUb/8BgOddcuXuUESAaU6G9cuNBgySd/Nglo22a/8foWfKO
         c3mO5IrO14qIkg6wsBJgDCRsVyt5Usiqz2+HMcTV7TsTOeumX+aq/FaBnnKW0OQKCwIR
         kFU+nee88jx/VTP3ViKRBYZc0/gajCVc4qw/xkKJ3upuheIVqOuh3twr+9eHZBmQFfbp
         cE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692990144; x=1693594944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2K0JSd6jxFl8ipBHN+l565B5wkNlVNWV8ekqr5bF1n4=;
        b=KWGfZDidM/WKhWtlNlH9qs08xJvEK20+vRaZQHjgKvPrlOS6BTq/omXKlR842n9Acy
         dUU2yr6Ul4ArG9lj6pZCvoMeHYolW1tAv8mVOCr/1k5EXFiHd0aq9U4n6zdsujCzukM/
         7dgjbmF4bhbX9K6LEMwUl7DdHErRxkHyBdCkto7b4ex0X4wCTQ7Dd5gKdxrWGZ8YhWwY
         mQ04JdTB8AiyYSt8QyYy1EEdIKWGo+tGOOg3TMLyzo/kyQXXwTz2WXZmmkdA9515yNGW
         cIiliFUIsP0AaoqOCXv2U5231r4KKsjRuLBNmqsVGL1KDBUX/nPbTzUzmBhrIIEyBRW8
         wNhA==
X-Gm-Message-State: AOJu0YzGlzXV3qUH/DOu2WIwJ7cxjrejFhxNbpnLQnyPn4czgaZ3FiSP
        4he4lLEp5qG1Oif7r3hln7Ziuh1E5j8=
X-Google-Smtp-Source: AGHT+IG+IorwBNnRSS6CuqDsu7VIk2ZVe2xbdIGHpt3EhOGOj+ZNVqkAy2YgcGlFXz+l4zRLZeHGYnzSCCE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c5c8:0:b0:d78:2f82:b8de with SMTP id
 v191-20020a25c5c8000000b00d782f82b8demr241187ybe.6.1692990144788; Fri, 25 Aug
 2023 12:02:24 -0700 (PDT)
Date:   Fri, 25 Aug 2023 12:02:07 -0700
In-Reply-To: <20230825022357.2852133-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825022357.2852133-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <169297922637.2870680.4959975012627419790.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix SEV-ES intrahost migration
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Aug 2023 19:23:55 -0700, Sean Christopherson wrote:
> Fix two fatal bugs in SEV-ES intrahost migration, found by running
> sev_migrate_tests (:shocked-pikachu:).
> 
> IIRC, for some reason our platforms haven't played nice with SEV-ES on
> upstream kernels for a while, i.e. the test hasn't been run as part of my
> usual testing.
> 
> [...]

Applied to kvm-x86 svm, thanks for the quick reviews!

[1/2] KVM: SVM: Get source vCPUs from source VM for SEV-ES intrahost migration
      https://github.com/kvm-x86/linux/commit/f1187ef24eb8
[2/2] KVM: SVM: Skip VMSA init in sev_es_init_vmcb() if pointer is NULL
      https://github.com/kvm-x86/linux/commit/1952e74da96f

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
