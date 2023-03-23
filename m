Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C6E6C7363
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjCWWxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjCWWxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:53:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEF52ED48
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:53:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a4eba107so564197b3.19
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679611982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W6+Qn6EJMHI+3I/L2O6DcxdAJ0N7a/1zdIIWx5jxJMI=;
        b=lPRzXXsmxANtqW5g73lEWfTE9t87KJhwBulJ2jb4CXk1fhH834elw1IMt+G2RURXet
         uS2wvECcsZveg4IYcaPYOJKetzv9Figak4PRmehi0PaUJ8oFmgOi3kylQRF0ELdh/GKi
         xmAsx0GT54177CJ1ns9ILiUH+rowuFK+5N8+l3XEoO7xDB006uypOuUYK0qFKP1d0qyi
         nP7pFMSVzP68WM1fuLgJmJlePpq+r4YABvtBxXg+UlVFHJLmsWGlgrqft3CZO2gsXznf
         DrREFzhQte4JrGxlovC6qHX0nLzs4RtFEsANSt/CKLgnHgLcnydvfTSE78QgKaojbTM+
         PFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679611982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6+Qn6EJMHI+3I/L2O6DcxdAJ0N7a/1zdIIWx5jxJMI=;
        b=b+0K1XFp670MgRBm4M0uOG1jCcIDgy5i80uHl2qtP5O0bPSe/3fo2zhLcwoDW+qL9Y
         a9lfJ43wvRa0MXI4WWtpkdtJIAqhbW9caaha8znooKIKd6cinyQO/5pH+c6j0HVeCnHh
         MixNSfHt01oe3mF6/Ig6pFG9TUpS8amVRVI9NdDwkmpSYNNAWJIajTTvHKVLw/BnUrYB
         Ee80yMDpx47YIUKXDNxeP2oP1HYjxBYTiwnDZyCwa1QsQpArt6yUErgq+pxWXb8Md0Fc
         1rOxnTrC3MiCsyOV8uGf7vMYLBBBk3fan7KZy57V/kLXeobD809sH1Wj7neCUvQDwNzf
         k+UQ==
X-Gm-Message-State: AAQBX9dkNcY3TD9sOpsJY3Y5elPfKR2g18qiSMFVCdlFIaLNqRlsFS8Z
        BcHuKqZ4tikut9+R4oGREHBJwGnsz90=
X-Google-Smtp-Source: AKy350aD3v+u24+02eF93jNscPBMXl81ZfnIUCEHD8aAAK+EKBKMkSSJWX59LqWYUu8CYTMAdDRJuuk3J2A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af5d:0:b0:541:8285:b25 with SMTP id
 x29-20020a81af5d000000b0054182850b25mr78379ywj.10.1679611981974; Thu, 23 Mar
 2023 15:53:01 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:50:34 -0700
In-Reply-To: <20230322013731.102955-1-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230322013731.102955-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167949641597.2215962.13042575709754610384.b4-ty@google.com>
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP users
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

On Wed, 22 Mar 2023 02:37:25 +0100, Mathias Krause wrote:
> v3: https://lore.kernel.org/kvm/20230201194604.11135-1-minipli@grsecurity.net/
> 
> This series is the fourth iteration of resurrecting the missing pieces of
> Paolo's previous attempt[1] to avoid needless MMU roots unloading.
> 
> It's incorporating Sean's feedback to v3 and rebased on top of
> kvm-x86/next, namely commit d8708b80fa0e ("KVM: Change return type of
> kvm_arch_vm_ioctl() to "int"").
> 
> [...]

Applied 1 and 5 to kvm-x86 mmu, and the rest to kvm-x86 misc, thanks!

[1/6] KVM: x86/mmu: Avoid indirect call for get_cr3
      https://github.com/kvm-x86/linux/commit/2fdcc1b32418
[2/6] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
      https://github.com/kvm-x86/linux/commit/01b31714bd90
[3/6] KVM: x86: Ignore CR0.WP toggles in non-paging mode
      https://github.com/kvm-x86/linux/commit/e40bcf9f3a18
[4/6] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
      https://github.com/kvm-x86/linux/commit/74cdc836919b
[5/6] KVM: x86/mmu: Fix comment typo
      https://github.com/kvm-x86/linux/commit/50f13998451e
[6/6] KVM: VMX: Make CR0.WP a guest owned bit
      https://github.com/kvm-x86/linux/commit/fb509f76acc8

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
