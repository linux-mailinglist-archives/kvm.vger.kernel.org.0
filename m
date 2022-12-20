Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE23765252D
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiLTRKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLTRKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:03 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B101DD
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:10:03 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p6-20020a170902e74600b001896ba6837bso9501884plf.17
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nNHr9j59bZrTuZ537vTDmatftD+RR/sjwCZzNQZEgR8=;
        b=n33r3Qedx7x6tqd+SCHxjWjmijIxqhKNgPbnGHJ33CKZH826eRHSh+8zdHlUkjXJyN
         MAw9jtRnKgqcespY6CVWbTY5nR+4Rr1s8bOvFA7P7A0ekb5cqrfonnMO0nM7Tr9mOrDD
         ytwEWZkR/vTvqw8Vo9HU309e9sK/dHFxGDCuzgvuY5QqrnqPdxhb1gpujDi4GXI5Ueey
         oakRlbGmJ69VmwiTzfSsiQmnyvWVeTyv83gwDSQexDEq/i/CQ8L87OilAbex6F+y35iF
         1EbzO75oU5MUeAgP7L9APKu8dPooEcoDxbrL74sGi0tZQeSRzsSjAopH0Ip2A4XQKlTN
         VLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nNHr9j59bZrTuZ537vTDmatftD+RR/sjwCZzNQZEgR8=;
        b=JPld4ZAX9JmX/FZluRrJ47XC3w3h4wgbWisOf2pArvYBt3rIzvhR2Tkozu3nEFYKQ7
         plV0huFUi2DrOOxRR4d7P2GXnR8U54NLjwL5Kw+q2YByHaACp/LI7PtEMI0g6YUU/cOJ
         +3Y9G9WCxnkZI8ggkRbflcTEUojcFfS4qa9Q7pHcvuJUIvzgwwYxSzI3jskmLaVcuIlq
         d4fVYdtRuCf8u1+DYlB1m4jZkh+N+5oKSnL1v4TWy6mmJNo5zebQcLt7kPjJ2EuFaR4S
         8ijH0+Nde0d7dSwJ6Psf5a42HtUQFI7DuEPwt/x5+/yZiPOnDMYG0dPjUh3PzF/o5f+/
         KHQQ==
X-Gm-Message-State: AFqh2kok19aX+wXU80XfROJUOUe93OusZK3eacwVdZoARW+vdMAYPoxa
        Qgqn7AKa9DlpQy8yDk1l9mo7BtHYg4M=
X-Google-Smtp-Source: AMrXdXu+DJZ+foE8FYoZ82/lnfH437ZRjyDyoRbb9kkS8l8OKsC56zm8XbU8bg63gHgOrXuyqg3K/qmcjkQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:2a8f:b0:219:5b3b:2b9f with SMTP id
 j15-20020a17090a2a8f00b002195b3b2b9fmr46292pjd.2.1671556202622; Tue, 20 Dec
 2022 09:10:02 -0800 (PST)
Date:   Tue, 20 Dec 2022 09:09:20 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220170921.2499209-1-reijiw@google.com>
Subject: [PATCH 0/1] KVM: selftests: kvm_vm_elf_load() and elfhdr_get() should
 close fd
From:   Reiji Watanabe <reijiw@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Andrew Jones <andrew.jones@linux.dev>,
        Reiji Watanabe <reijiw@google.com>
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

kvm_vm_elf_load() and elfhdr_get() open one file each, but they
never close the opened file descriptor.  Fix those two functions
to close the file descriptor.

This patch is the same as the one included in the patch series [1],
with minor updates to the commit log (including adding Reviewed-bys
I got).

[1] https://lore.kernel.org/linux-arm-kernel/20220217034947.180935-1-reijiw@google.com/

Reiji Watanabe (1):
  KVM: selftests: kvm_vm_elf_load() and elfhdr_get() should close fd

 tools/testing/selftests/kvm/lib/elf.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.39.0.314.g84b9a713c41-goog

