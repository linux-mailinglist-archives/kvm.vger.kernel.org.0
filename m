Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A304740716
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjF1AOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjF1AOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:14:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1881E8
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b7dd061e9aso23592205ad.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911269; x=1690503269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54YEzEQBCutR+gefBVnLuCnoFZSPr1AQvRKrvXs8DRM=;
        b=rssPJ9pe0NTvz6xb8tjHKDIANdYWah6ocqGDWrYFtdHXhtR690CLpGIwP4JxsRyT6R
         ei1iFw3MDnCoowyq7LzVPyYZEvx4ovKQpT/IJ49IWoAwqdC1hnLqjPUBwGEuPSmcoeXH
         GXdPo47a43QoXcdQ0DRPerhCmr0mu+6fpT1Ky+z7naeXZf6NYd2sJfah/GGGqm4Qjb+x
         oRDt3Dm3BoEXk8bMc+LK/XqRlCLSpvCUVHUR65GrBJbFZOwIczJQKJmD3UOh0K3PuGOi
         GqQ9fvA80M/XWHjpFPy7PFGs6pAJCb1EZdQjdAdRs/i3ZZ+6tJoiNj3eRzOsDYp+SBis
         2opw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911269; x=1690503269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=54YEzEQBCutR+gefBVnLuCnoFZSPr1AQvRKrvXs8DRM=;
        b=OWSNKga2pjas5kpg5uAerSH28IrpGi7JUW2wSk07nFSLNcLoZI68QczcQDsqS0rxt+
         Bax6HW7Gnc8LiR0qLmM/gC2KIkWuWI0xripOnb42OqMH6+aakxkvw2d7SrP+FLiRB9FY
         rZ4uwZ0Iwcpr6lF99ewtA9YhLkZ2/rDzDVdezEaWrNDMrRD70ojC+uegZKLK0u1ZbAj6
         3jtX6l3lIk1SzLZT8Uma+CRqmNC6iVlQwReb1+IGK8zD0AVUrO6EW56rEypuQD3nLCvo
         88BwNWxYOfRyw0c107eh/RK73KO9f1YuI1NMze/1joKyHCi5wi4G7lPbUukHgvR9+31S
         RrMA==
X-Gm-Message-State: AC+VfDzjMtC9GjlBk8XaTbmkBr6LPha0jJ6s+C3viQvjLZlU1GBiB3x8
        ZNDcI6RDtkLnzz4PPNqKR7A=
X-Google-Smtp-Source: ACHHUZ50pa0YiATIK/COunvYOh3th4Bjpa5itlHWiS7QVeAqx+bEb4TeM16vZWNOaPfnRdlXozFEbw==
X-Received: by 2002:a17:902:f7c4:b0:1b3:d4aa:461 with SMTP id h4-20020a170902f7c400b001b3d4aa0461mr7901602plw.44.1687911269190;
        Tue, 27 Jun 2023 17:14:29 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:28 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 0/6] arm64: improve debuggability
Date:   Wed, 28 Jun 2023 00:13:49 +0000
Message-Id: <20230628001356.2706-2-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

My recent experience in debugging ARM64 tests on EFI was not as fun as I
expected it to be.

There were several reasons for that besides the questionable definition
of "fun":

1. ARM64 is not compiled with frame pointers and there is no stack
   unwinder when the stack is dumped.

2. Building an EFI drops the debug information.

3. The addresses that are printed on dump_stack() and the use of GDB
   are hard because taking code relocation into account is non trivial.

The patches help both ARM64 and EFI for this matter. The image address
is printed when EFI is used to allow the use of GDB. Symbols are emitted
into a separate debug file. The frame pointer is included and special
entry is added upon an exception to allow backtracing across
exceptions.

[ PowerPC: Please ack patches 1,2 ]
[ x86: Please ack patches 1,2,5 ]

v2->v3:
* Consider PowerPC for reloc and related fixes [Andrew]

v1->v2:
* Andrew comments [see in individual patches]
* Few cleanups

Nadav Amit (6):
  efi: keep efi debug information in a separate file
  lib/stack: print base addresses on relocation setups
  arm64: enable frame pointer and support stack unwinding
  arm64: stack: update trace stack on exception
  efi: print address of image
  arm64: dump stack on bad exception

 .gitignore              |  1 +
 Makefile                |  2 +-
 arm/Makefile.arm        |  3 --
 arm/Makefile.arm64      |  2 ++
 arm/Makefile.common     |  8 +++++-
 arm/cstart64.S          | 13 +++++++++
 lib/arm64/asm-offsets.c |  6 +++-
 lib/arm64/asm/stack.h   |  3 ++
 lib/arm64/processor.c   |  1 +
 lib/arm64/stack.c       | 62 +++++++++++++++++++++++++++++++++++++++++
 lib/efi.c               |  4 +++
 lib/stack.c             | 31 +++++++++++++++++++--
 powerpc/Makefile.common |  1 +
 x86/Makefile.common     |  5 +++-
 14 files changed, 133 insertions(+), 9 deletions(-)
 create mode 100644 lib/arm64/stack.c

-- 
2.34.1

