Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4C55088F0
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353869AbiDTNOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiDTNOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:14:03 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2212E39BBB;
        Wed, 20 Apr 2022 06:11:16 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c23so1774611plo.0;
        Wed, 20 Apr 2022 06:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=90Tzna36JvZCbTdn0O+HXfIE/8jQaXux5FeOavE9K5c=;
        b=oo4IlDOQLB9vf9sOvQgt5qcMV1m5fPJRwKVH7AbNJY2YOr6bdY8z56G1I53Y2xaxKj
         Ws09gRdSlzGsduzkYhmv4OYUAV7v+8mjMy9ESxbXeZP+Hue7SOww1d51dnFbW+zjr7fk
         l/5JzBh93qEoVsNXEJFQSEglMlWoJSCVzc7OlmS+EItGcKUpPv0twjJhTSaWNuPtXZq0
         wJ5v7NRno1wsURPZEkEDCP7wYEtnU055PPYbXYo0TIJmvk3bZyAn4B6ZLLUZ0CSSNoYK
         QQWfTI9gKo8BcjMBBuxtV0IejVPei5v4xF+cADxbeATUXPORdVztTiGvmroJ/O+ugU1k
         UcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=90Tzna36JvZCbTdn0O+HXfIE/8jQaXux5FeOavE9K5c=;
        b=InkqzUZ/8kBD3IruL2Ed/vzmFU2nnlT6q7f69P1TbWkKUsC4uA6wQWbYLx7dVtn4+L
         KKiq7kkv7Yv57FnE+GvUnY0Y5fb+r9KT0iDqNCpOxIe608yvPf9Lo9UC12WI+lZIMezz
         0b+Yqp+q/+A4isKLI+iNWgKnXjWb/Va0mfkYkK6vl2U2o0CwWaR5FWV46ouoet4fnaBg
         iycRSvQ2sUKc0hwLEZIA3c1I9Q+raCgHgdUDcE480B3iZYddMMKrgo3zSoLbTwewnxjp
         mqEM+QD05aVZN6Jqfte2PI7MRkCJcghT6SYy3WaxZ/7KdWdoviNvQJCA0vajGGVUFQ3n
         DvZg==
X-Gm-Message-State: AOAM531uw+LnIZqjwf7l1dV3kZO7JiV127aUlf1MMgz7e4lswLUxDNKq
        qmcpvEB2L1qmFODrg6K4artDiX7ai1k=
X-Google-Smtp-Source: ABdhPJxV7JCfrDBJ9iW1SXvIcuclt7clj5Ex9KC5O7Ey2hQ2PgI+iQMc/wCbbhbM+G2BO9BQ375NdA==
X-Received: by 2002:a17:903:1c6:b0:158:d1d8:19b with SMTP id e6-20020a17090301c600b00158d1d8019bmr20237933plh.108.1650460275376;
        Wed, 20 Apr 2022 06:11:15 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm20792882pfj.55.2022.04.20.06.11.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:11:15 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 0/2] KVM: X86/MMU: Fix problem for shadowing 5-level NPT for 4-level NPT L1 guest
Date:   Wed, 20 Apr 2022 21:12:02 +0800
Message-Id: <20220420131204.2850-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

When shadowing 5-level NPT for 4-level NPT L1 guest, the root_sp is
allocated with role.level = 5 and the guest pagetable's root gfn.

And root_sp->spt[0] is also allocated with the same gfn and the same
role except role.level = 4.  Luckily that they are different shadow
pages, but only root_sp->spt[0] is the real translation of the guest
pagetable.

Here comes a problem:

If the guest switches from gCR4_LA57=0 to gCR4_LA57=1 (or vice verse)
and uses the same gfn as the root page for nested NPT before and after
switching gCR4_LA57.  The host (hCR4_LA57=1) might use the same root_sp
for the guest even the guest switches gCR4_LA57.  The guest will see
unexpected page mapped and L2 may exploit the bug and hurt L1.  It is
lucky that the problem can't hurt L0.

Fix it by introducing role.passthrough.

Lai Jiangshan (2):
  KVM: X86/MMU: Add sp_has_gptes()
  KVM: X86/MMU: Introduce role.passthrough for shadowing 5-level NPT for
    4-level NPT L1 guest

 Documentation/virt/kvm/mmu.rst  |  3 +++
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/mmu/mmu.c          | 38 +++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h  |  1 +
 4 files changed, 38 insertions(+), 9 deletions(-)

-- 
2.19.1.6.gb485710b

