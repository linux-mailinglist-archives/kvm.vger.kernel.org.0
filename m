Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EFB51B257
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347522AbiEDWxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379070AbiEDWxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E70E527F3
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:37 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id bj12-20020a170902850c00b0015adf30aaccso1364177plb.15
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=309h4CdGAPcwiHb0ZM4SWUVDb0T/f6xUJOwKAgDDSGM=;
        b=ZUrelAy0Bnhc0z7Dj1FvhcDcGJufecyEo9sS9WZIefn7dmdWq21xt4WaQ2OXpsybKq
         o6ilh7c+GhOO9FjT9yt5ae/jq0ta7aIPRzCDwZeVNNbqSrdav/H60mydYTiPdR6oD7bW
         51zuLMcd6dho3EGrqFALGhLITdC/t4A2JX2TIUlTcHdcMEjnvi4PaFEdSmUUtHoLW4fR
         geMCTJUNfo5r9O715SPThADanpQl9PQvGb2WAnzGHWTgOwnR6FUn+hy5jGDSAbKfqWZv
         y1rAgl4LxLNEMPcc7zX8/ZWhdzOekI9X9riy55mouWBfcpRER2apGHf5AXDAZ+mp7CGg
         pnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=309h4CdGAPcwiHb0ZM4SWUVDb0T/f6xUJOwKAgDDSGM=;
        b=tuvlc7L68kgzmbLlSsIbakuB94z2dhwfKJzRKT/dUV+qHBy9Eh/kz2ilzmkGiHg1sW
         uTh+tM5mtT02mRrJaorVMXxaBHqlhEaK2GiOH24C7g4FwZ4kPLv85XdmDuFTPzVDB0iO
         8gAWFe94SYvc6RMbCxARcAzDG3fZCFpuKfbC+z88/D/rL+8fyZABHDIB09x1xeFL/fB7
         uXzmna5OLLfS/LeA2QlB7G+xpAvLO8A2sTMVoml+BfWFA/cyCQTubbPEKhNHDXSio86c
         6Rc4xkm5ARII6SrhMmIMHPHsd7ZPwDcCyMJqjita68g6MkKham4nyKAPcCAAGuJYhHOE
         gsBA==
X-Gm-Message-State: AOAM5310hCAB4iqDo4omqqWJK4D7f7IAR71aukFzulo4S9/t7HWqI87J
        ToX1GYd+2lAP9P3QzARk7Yaf4W+s0vg=
X-Google-Smtp-Source: ABdhPJyroa6y79geaC1Voqxr63GiFITL3Z3N0TL80As4HKXy0ciZTzff0PRUBNCA1EGsP1cZU0jjKr5Viis=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa09:b0:159:684:c50d with SMTP id
 be9-20020a170902aa0900b001590684c50dmr24671868plb.51.1651704576963; Wed, 04
 May 2022 15:49:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:09 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 003/128] KVM: selftests: Unconditionally compile KVM selftests
 with -Werror
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Specify -Werror when compiling KVM's selftests, there's zero reason to
let warnings sneak into the selftests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index af582d168621..c8efaaeb0885 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -153,7 +153,7 @@ LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
 else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
-CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
+CFLAGS += -Wall -Werror -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
-- 
2.36.0.464.gb9c8b46e94-goog

