Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFE95F5DF2
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJFApT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJFApQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:45:16 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89652E9EC
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:45:15 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q3-20020a17090311c300b0017898180dddso202025plh.0
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zBb7RTEDwtbJKoC58wvS836EviryRkUcplcnarH/ioY=;
        b=a6owNo3bcqp5q/S4VMqZHwjIkS+/H60hmq+9QekUXqbf7pjJrSrozsEQk/4mp1x3iF
         Mr2KtXu2m3CxYl5PyGxrd+yNRjxA+5XI0OlQQOaKF77LQDQ6vrKRStS8Vx0dP83Zl/qG
         gbABLLjC+aqTxxV4lJ6voMATFsc0bwt2A4mGYSJT+Ut2zzsK1X/dv3uu4ZTmaAKjGkvo
         Hali+cmTo87FgOUJ/glaWlNdyzcTu746CrKR00vHEjGP6iep/e9FCprnuSyNlHv8TsED
         HcpsUU04J5NFjbQs2cMEQKiKAkE0W8D9RVcVgO917dDrvFrftrcxSXNi8e5dEEhxY6sq
         Ea7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBb7RTEDwtbJKoC58wvS836EviryRkUcplcnarH/ioY=;
        b=QKyAPDYO19kdc+U8Yf+eW3ffoTpG6rILgXl7sHkzrUK6vGCviEMc2sNzIGAqiJIxRH
         nWkKAZM0XqEinf071GcEyUaWNlWFDWlKVQsHJgGGRg8+ovhQG4fCLBuXdn8i5e4Oxmrk
         rmbhElzNJbjxtgjb9YzAdwJIyVIQlaYghQw4zpLt2B02IKXuZDOaGG/Cfqk9DcRnE1uY
         L4B8arzd4IC0KrCish/y/Reb22P7q6h54KYUBkvaanjWqfDC0se5zgOR7RQG0dHkwKgk
         smIHk9oe/EppJv6/DtQeBJpUyv1nGVZvFSWFvzI7X5oVj5t/9ouoJ6fqEUGIOrrmfGDZ
         1GKA==
X-Gm-Message-State: ACrzQf21dbkSgo6zwQjcJv9WhB/fUfURBsgPVB/5j5/g4wlvTc1jq0LL
        cDpPJcIRDyAgVCDayGSqaffl9m/One4=
X-Google-Smtp-Source: AMsMyM7MLZO1nsdknxuJ6jPSzt4bJqH2g3TrBtvRk+AkcPbI/9+W1JrjW6SqoyI2eIOtnDN9OzOaQo2logQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:852:b0:544:5907:7520 with SMTP id
 q18-20020a056a00085200b0054459077520mr2032392pfk.31.1665017115341; Wed, 05
 Oct 2022 17:45:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:45:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006004512.666529-1-seanjc@google.com>
Subject: [PATCH 0/7]KVM: selftests: Clean up x86 page walker utilities
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up and dedup x86 utilities that walk page tables, e.g. to insert new
mappings or to retrieve existing mappings.  There's no end user that
benefits from the refactoring; I did all the work thinking that I needed
some super fancy test to hit an NX huge page bug...

Patch 1 has been posted by Vitaly (at my request)[*], but should be
identical, i.e. the order shouldn't matter.

[*] https://lore.kernel.org/all/20221004123956.188909-37-vkuznets@redhat.com

Sean Christopherson (7):
  KVM: selftests: Drop helpers to read/write page table entries
  KVM: selftests: Drop reserved bit checks from PTE accessor
  KVM: selftests: Remove useless shifts when creating guest page tables
  KVM: selftests: Verify parent PTE is PRESENT when getting child PTE
  KVM: selftests: Use virt_get_pte() when getting PTE pointer
  KVM: selftests: Use vm_get_page_table_entry() in addr_arch_gva2gpa()
  KVM: selftests: Play nice with huge pages when getting PTEs/GPAs

 .../selftests/kvm/include/x86_64/processor.h  |  19 ++-
 .../selftests/kvm/lib/x86_64/processor.c      | 159 ++++++------------
 .../kvm/x86_64/emulator_error_test.c          |   8 +-
 3 files changed, 70 insertions(+), 116 deletions(-)


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.38.0.rc1.362.ged0d419d3c-goog

