Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E671F7AC
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjFBBT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbjFBBT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:19:27 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE940F2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:19:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d44d14db4so1049806b3a.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685668765; x=1688260765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UkeNsFigxkQFw8vfrE2KyWVToDLxnuVHQRF9ydkx2yI=;
        b=ucuV6+pMNRPpXUp7aE8Ryilvr9OHuYpLnNdhrAeOg67dWXB+Lw2+h2WrFN9CV2ubH7
         H1u6BcWTXtlAYtIIEWm/ShZTbmLzO5HSw5MB9el5/XAOZZmoY9iEbqgPsWxsLoI47VM5
         i/8r2tAHNLBnksPjocDh75mYs9ZJPJcWibOkHKL49FhBAGDS/1ZvJrGa0aN3Z6ePzuue
         P7QKvZqozTul+XcdIV/YEfFYG1q7b0ZAT9ZSROp8l4u37x57LrTXhoVjhbf342EUfgHi
         hx2Z07Ry9d3BBt2Lee8lqWnxnN1xmhh8YX357UIJiYct4osjxLwlfsHoGIBOW/18+PxG
         EArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685668765; x=1688260765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UkeNsFigxkQFw8vfrE2KyWVToDLxnuVHQRF9ydkx2yI=;
        b=iUpa0L5PKS1jV4AcxRHrbLV+DxoFiykMVjbsvCUrG9qkDw6JcfSjDeLaUeP9UEhzbQ
         xuSp4opVWFmJte2c4MlaYNn1zsEnhW9TjtrbnnKKeP32mxLZjmWLsMctxwjjjaMgthi+
         us9OUA7GmF5cWLVvE8kHmTl04L8u8obuJ9C0BvGvm/9QrxNzGY1l60gdNLNCd3SH/zPp
         6Z0IZHEh/fyqs/HipFnn4MYPGd09mVLx/U/9NaiNHvc/F2WAxIsXV+xKwmp78FqvrYAp
         dWXAQ/WOQCzQsFitYIHlqnMbBwuw408QRwfGokteMCSYr53TYoXgTClbQVbq56Gns9a/
         DgAA==
X-Gm-Message-State: AC+VfDyr05Ed7PlOo/M04KnPPFGZW6rkyAUObEvSEvFXsKYsPYKOGm2B
        pi5cehblTFocxGJ89zjnZLRpHyffqFQ=
X-Google-Smtp-Source: ACHHUZ5rwQns80ema4xerhNQtjoyY1leAyHsb/0l9B6hxou2XZ2sBgNrpz+y65lHHdrLKgeAEY3VSM1URgU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1c91:b0:64d:602a:2483 with SMTP id
 y17-20020a056a001c9100b0064d602a2483mr764350pfw.2.1685668765446; Thu, 01 Jun
 2023 18:19:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Jun 2023 18:19:19 -0700
In-Reply-To: <20230602011920.787844-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602011920.787844-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602011920.787844-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Account fastpath-only VM-Exits in vCPU stats
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Increment vcpu->stat.exits when handling a fastpath VM-Exit without
going through any part of the "slow" path.  Not bumping the exits stat
can result in wildly misleading exit counts, e.g. if the primary reason
the guest is exiting is to program the TSC deadline timer.

Fixes: 404d5d7bff0d ("KVM: X86: Introduce more exit_fastpath_completion enum values")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e..a609e39b2cb8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10754,6 +10754,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
 			break;
 		}
+
+		/* Note, VM-Exits that go down the "slow" path are accounted below. */
+		++vcpu->stat.exits;
 	}
 
 	/*
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

