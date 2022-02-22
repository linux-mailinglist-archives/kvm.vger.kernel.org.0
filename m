Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCEE4BF64A
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 11:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiBVKlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 05:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBVKli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 05:41:38 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3664815A232;
        Tue, 22 Feb 2022 02:41:13 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id u16so11567692pfg.12;
        Tue, 22 Feb 2022 02:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I9dQ69bEOiFN9+rBuQg6s1G1Wep3TZE77BZiSV92wtQ=;
        b=OyiB4gaHOIdaE3uBgx1J9AQUorgVfhqoRVazWydswpKKADdLEhtA0AlnJoHM9NESfi
         mY/PuOK7XWgaGly+85IauWN3qJ5QjlUlYIlINRLH8oPNcHYQ1qz3pNMd5PJqz3/L1Ud3
         v0CVrMUnM+U/ujprQxpCtVKVdzizn6eYB6wEkQvwAOkeylMk1dqtc6eY7c2gADTxkcJd
         pedmYwe1sHm3coNOF871kF4XSZZmLmZGD+LfqX2uv7i5lK9YJRgv2U4IOOkAteHa3WI4
         aTLe+BAuGnrGfzm2rfhtJ3rZvVRPM4PZVd7dXzXQsLCphHcfGESpmshp0Yib95lbdCsR
         iePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I9dQ69bEOiFN9+rBuQg6s1G1Wep3TZE77BZiSV92wtQ=;
        b=hV7TNVdl20kK178pC82FL35dwPd4KagWdgRPQGvlkwljr4PFTTmdnksLnyFo3BHW6s
         fj6HbgQ1I5MjzCUth2SFLFAydnXqAlXIWbI0Igfd12yMsm6yIR6KXcZzhgdTdm7w7RSw
         8q4S8YqKsjYaPK4s5aH2QFbIdU645i+TJOEDF9YT3b1DfzX3ieDSVhe6oA+Kvxm4rtPe
         6rH+iooydRovqkaC4GJ/r4A0skDi1VlCvUsBbYnnbq2F+7WVo+68/0iljPfqKLWYACyQ
         qLAurs4ffQxIMGk+01FzhwskwCOrKlEeAtbV3MEB3qeGmeLSkIpTNqYFBJLPtdONr/8P
         PGWQ==
X-Gm-Message-State: AOAM533o/6nKqiCrJsveq7qn8AHxNYCKOdrhi8QBRFlgp0Nn7SY02ZoX
        AXhGV7KAlJt+Koone/mF92g=
X-Google-Smtp-Source: ABdhPJwVYvxsdwWft3Upv9hJNaf86IJIoBwMd0geiyLwJiw1zwbzptyXbbqHmilqNRGXHJjPrNnXPA==
X-Received: by 2002:a63:ad0c:0:b0:374:50b4:c955 with SMTP id g12-20020a63ad0c000000b0037450b4c955mr6698033pgf.530.1645526472766;
        Tue, 22 Feb 2022 02:41:12 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id l14sm2189424pjz.32.2022.02.22.02.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 02:41:12 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM:VMX:Remove scratch 'cpu' variable that shadows an identical scratch var
Date:   Tue, 22 Feb 2022 18:39:54 +0800
Message-Id: <20220222103954.70062-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

 From: Peng Hao <flyingpeng@tencent.com> 

 Remove a redundant 'cpu' declaration from inside an if-statement that
 that shadows an identical declaration at function scope.  Both variables
 are used as scratch variables in for_each_*_cpu() loops, thus there's no
 harm in sharing a variable.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ba66c171d951..6101c2980a9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7931,7 +7931,6 @@ static int __init vmx_init(void)
 	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
 	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
 	    KVM_EVMCS_VERSION) {
-		int cpu;
 
 		/* Check that we have assist pages on all online CPUs */
 		for_each_online_cpu(cpu) {
-- 
2.27.0

