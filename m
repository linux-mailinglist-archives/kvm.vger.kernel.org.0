Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0824D5BE1
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 08:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346951AbiCKHEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 02:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbiCKHEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 02:04:13 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C1C3FBF1;
        Thu, 10 Mar 2022 23:03:10 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q29so5774545pgn.7;
        Thu, 10 Mar 2022 23:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5hJy0hutkdM4u08aGmI8gfz2cIMPdqRV3zTky+0cr9M=;
        b=bMKXmOGDPOR3g6EyPrBFxz8FDZ/cBZO9TbcHP3hv9AdfJpsR8U7AD1/wxfpfNd5kzg
         /2hg7KBn4JhFYGZNMJYI6ZJB8WIozUWKSnn7zIbVFTIsUPxnfLX/sYglpbdkk5Qkdr6v
         5InOTt+G+7GI2/8XEpkGDGtxP/k6JY9uzZhLBEQRnAG17RvcrgAnvn6lvITczc8IRodK
         DQJDmXun1T/EvVgxxlRt9u0/ZcEo6cAJ21g4+pk0x8Dr/A+3Nc09BDngVgA+YeeI+pnp
         cnb/NfAzva/ex3ESfqnh5BstXbC3tBBq/dRxZCdKjxakugJjjk73ie6+LzjgQVnESpPX
         HkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5hJy0hutkdM4u08aGmI8gfz2cIMPdqRV3zTky+0cr9M=;
        b=bj6hs+JBxcaO3r56MgiHzgJ+2NiLvC44AFv708kURkaUut+bz3sO8m2+GQhrKxRlAt
         HV2lsbgcK+LG17yNOl+WuEIxqA5Xm3n+KuIOYfZEPbQ9uUPdp2GAi70sNLQHujwjQjwb
         uF5hoBkZ/sk1Ix0DqhRw8LBeWw58GW+xrqFHLOxnDBW2j8N+l57mmuegvlOal2CQ80Pt
         D+r/l2hRPfpom9bJs2/L9URfRcgmbLWoIOWNmmQEFmL8Tp5YPXA+7W8IprTQIoqpzU7d
         7lKXtVndBCxaPsS2JLfEDy0/XSh5EepnyyyVwcLBcSUBTLldommfT5px8Q7pZZqiH+RX
         CJaw==
X-Gm-Message-State: AOAM530EgOS1ENxOnqQVFwsoNFhdU2VLDF1D3ndN5yOkTIxtJPwcgBV/
        lXhSpC3Kmq/YjDQCxGvEzJCktweiJ04=
X-Google-Smtp-Source: ABdhPJz/f97pUdRr97Cc8nR4ebhAVh3dc2WSqGIIOS0hjVgdOFl4ziRiAJj8iEallJoOZqsKQj/rQQ==
X-Received: by 2002:a63:6c01:0:b0:37c:73a0:a175 with SMTP id h1-20020a636c01000000b0037c73a0a175mr7125920pgc.415.1646982189451;
        Thu, 10 Mar 2022 23:03:09 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a00114d00b004c122b90703sm9069157pfm.27.2022.03.10.23.03.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Mar 2022 23:03:09 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V2 0/5] KVM: X86: permission_fault() for SMAP
Date:   Fri, 11 Mar 2022 15:03:40 +0800
Message-Id: <20220311070346.45023-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Some change in permission_fault() for SMAP.  It also reduces
calls two callbacks to get CPL and RFLAGS in come cases, but it
has not any measurable performance change in tests (kernel build
in guest).

Changed from 1:
	gross implicit access into @access as Sean suggested.

	Use my official email address (Ant Group).  The work is backed
	by my company and I was incorrectly misunderstood that
	XXX@linux.alibaba.com is the only portal for opensource work
	in the corporate group.

[V1]: https://lore.kernel.org/kvm/20211207095039.53166-1-jiangshanlai@gmail.com/

Lai Jiangshan (6):
  KVM: X86: Change the type of access u32 to u64
  KVM: X86: Fix comments in update_permission_bitmask
  KVM: X86: Rename variable smap to not_smap in permission_fault()
  KVM: X86: Handle implicit supervisor access with SMAP
  KVM: X86: Only get rflags when needed in permission_fault()
  KVM: X86: Propagate the nested page fault info to the guest

 arch/x86/include/asm/kvm_host.h |  6 +++-
 arch/x86/kvm/kvm_emulate.h      |  3 +-
 arch/x86/kvm/mmu.h              | 54 ++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/mmu.c          | 10 +++---
 arch/x86/kvm/mmu/paging_tmpl.h  | 16 ++++++----
 arch/x86/kvm/svm/nested.c       | 10 ++----
 arch/x86/kvm/vmx/nested.c       | 11 +++++++
 arch/x86/kvm/x86.c              | 32 ++++++++++---------
 8 files changed, 89 insertions(+), 53 deletions(-)

-- 
2.19.1.6.gb485710b

