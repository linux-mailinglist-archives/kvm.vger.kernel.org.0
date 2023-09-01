Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B657903C3
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351089AbjIAWuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351102AbjIAWub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 18:50:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9EE10D2
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 15:50:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d745094c496so2166577276.1
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 15:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693608620; x=1694213420; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QqklC19HRmnyOe+qCbB/NgjpErPx72qVsTMxsM8zzqc=;
        b=OimVatRK3Zt26W0msB2jgTv8sto1HZTrUt0Eh+bOtgWFPTQhyYpdFy819kHoacTbe4
         3Pw6iU7XS4P40XQijHJAbR9FCVDbwSxy/oJYCikyLPRH4jaZrKV+UxM3hRgGVv7N9feu
         6W2PUDLYuh2NeWpCkwDU1IUH19VeYPQWxBSjQb+veHKTDXJtl6QEdVUVQKLEDZJnvcPi
         gwXyub2KfeG2JaPcT92Q2dquMOzq9y/08Amqb+cbqyxasRLq9rMmVKjhn5Jl5Qly5v5S
         mUuCMr/V2+mJK0yiycVcp4XG7gC+aUVtqdNgq97GPBAOebufYMMUld/lsg1Kdnb6JoDn
         qOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608620; x=1694213420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QqklC19HRmnyOe+qCbB/NgjpErPx72qVsTMxsM8zzqc=;
        b=lXnsYAvebE/cBnzUV2KVL3LOOGhCiLQZogE5CGjVvE51/zl70uHRSTdpjM/VAgmDjN
         U112OlZ4ZeGFGWCYVdjwIUvD+ei7044ttYoDCuyhZm1wCbM0NgowYf6pd+PoFpSSyq3n
         YhdL3nOWDGgGDrleH/f7ZAy/jw/KCnsmxF/fYQl/yTbdJXLmFqxR0vzBYI70sSiTLk0r
         cFRF52+fNc0Wx0fK+N7WGAyiKc9hRQTwEydteyDBoYVnVKr+1YXS2sSA1R13qS1pRZAb
         dg/wIfbpJ+n3WstLhePvOz5FoOUuzSimE8uny5xeI3KSlk9+1CDwriuThHB/WrQAz51s
         nXWA==
X-Gm-Message-State: AOJu0Yw2qX03fmeiB3137Dhczq+MZpcPJ0sqABiOarQ/aJqZFGKZuY/r
        XNm40luwzmfS2bcAv8p/AvelSoKWqC8=
X-Google-Smtp-Source: AGHT+IFqVfZW5KCq8pli4Pvil+4cEaA71y7SZ42e+z2/9y6RVeFHb8NEVHdeNtmOkjWn6lOQM75z0IwDc+E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a56a:0:b0:d77:f7c3:37db with SMTP id
 h97-20020a25a56a000000b00d77f7c337dbmr111769ybi.8.1693608620168; Fri, 01 Sep
 2023 15:50:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 15:50:02 -0700
In-Reply-To: <20230901225004.3604702-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230901225004.3604702-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901225004.3604702-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 6/7] nVMX: Drop testcase that falsely claims to
 verify vmcs.HOST_RIP[63:32]
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excise the completely bogus testcase in test_host_addr_size() which
purports to verify that setting vmcs.HOST_RIP[63:32] to non-zero values is
allowed for 64-bit hosts.  The testcase is mindbogglingly broken: setting
arbitrary, single bits above bit 46 creates a noncanonical address, and
setting arbitrary bits below bit 47 would send the test into the weeds as
a "successful" VMLAUNCH generates a VM-Exit, i.e. would load the garbage
RIP and immediately encounter a #PF.

The only reason the passes is because it does absolutely nothing useful:
vmlaunch() unconditionally writes HOST_RIP before VMLAUNCH, because not
jumping to a random RIP on a VM-Exit is mildly important.

Outright drop the testcase, trying to salvage anything from it would be a
waste of time as simply running any 64-bit guest will generate a huge
variety of RIPs with non-zero values in bits 63:32.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1a340242..9d0f2050 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7616,8 +7616,6 @@ static void test_host_addr_size(void)
 	u64 cr4_saved = vmcs_read(HOST_CR4);
 	u64 rip_saved = vmcs_read(HOST_RIP);
 	u64 entry_ctrl_saved = vmcs_read(ENT_CONTROLS);
-	int i;
-	u64 tmp;
 
 	assert(vmcs_read(EXI_CONTROLS) & EXI_HOST_64);
 	assert(cr4_saved & X86_CR4_PAE);
@@ -7640,14 +7638,6 @@ static void test_host_addr_size(void)
 	vmcs_write(HOST_CR4, cr4_saved);
 	report_prefix_pop();
 
-	for (i = 32; i <= 63; i = i + 4) {
-		tmp = rip_saved | 1ull << i;
-		vmcs_write(HOST_RIP, tmp);
-		report_prefix_pushf("HOST_RIP %lx", tmp);
-		test_vmx_vmlaunch(0);
-		report_prefix_pop();
-	}
-
 	vmcs_write(HOST_RIP, NONCANONICAL);
 	report_prefix_pushf("HOST_RIP %llx", NONCANONICAL);
 	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-- 
2.42.0.283.g2d96d420d3-goog

