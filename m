Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1370915A962
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBLMpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:45:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37038 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgBLMpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 07:45:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so2175609wru.4
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 04:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=LNJyozYZM1m77aE/S79WIDsC4jEtyF6GEWnqSn5M9TI=;
        b=Q4WlqWAboWwJt5QjClPoqpWkT3FzgmYEP5uSfC0VgaqpCblw6XMyAejx6Enm7F81s3
         rXC1pNJEqWd9QmRewSjTdbcRGLokMm+5TsnEZjvhnDPX5y73E+JTQFdmru9pxhr+Zi+J
         Mv0QU3V+NRL3iCkcNENPgqzoP79s40b5+raiR/VArPUxd+64QnKFJXTTrdFJal3p9jP4
         LPiQVrkz6lreYadJg1vMBPQSwy3y/F+ARjoSz3uZnWlbjjLbhlFl6k8D3VSJ/Umq+q0X
         FFn/bZ6yd0+j4o6eJbNsZ1x1XqNGPcW1lE7Er1OIkFoRbluJsQpT2VYs6XuNFZ1M1OG9
         qMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=LNJyozYZM1m77aE/S79WIDsC4jEtyF6GEWnqSn5M9TI=;
        b=NqKYfHA8yQk7kGVH1Fb7Fz6hXOHyRQWtDLfV5GqkByP31JiyJS/ou/DeSqVJo0OTro
         as+B61kexa/QEMSDOi6H2CY9MhKFr0Pgc2mnDZ1QUuVpFH9TZ3jUOU9aBvhHih9cAwb1
         ep7SyjCzJiPbsIXSBxyHdsTMxILls5jgjFcSxvLF7mIPVrD7OsX5/ju4qg7Ueyh9VHTl
         FJIhFX5pqLSVxC03MKCjRw07oJX2+AQ/fyqNSv80+U1Ivy2T9O4F/rawzsg5lUYIBaal
         E8plbJlVk3ZURDA6Bzkll+Phv3ipMOxXp+kM6oUOdISuDKgyyIRSAS0V8KJ885aipOXZ
         Bg6g==
X-Gm-Message-State: APjAAAV3wQYnHl7nezfD+WcU/mLquMiA+MJp6DCoefD5QJtsAdnyFEqc
        fK5TkSINYEoKt1ZHCXKoCuEYSYri
X-Google-Smtp-Source: APXvYqzFtPSoKjz6gDa4b0zoFo3bVscESfJpL8gJPsupWQGVe+JpiMoa27Rg707PdtmU737hLoJHWQ==
X-Received: by 2002:adf:93c1:: with SMTP id 59mr15390097wrp.399.1581511543570;
        Wed, 12 Feb 2020 04:45:43 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b18sm504170wru.50.2020.02.12.04.45.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2020 04:45:39 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com
Subject: [PATCH kvm-unit-tests] vmx: tweak XFAILS for #DB test
Date:   Wed, 12 Feb 2020 13:45:35 +0100
Message-Id: <1581511535-35996-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These were already fixed by KVM_CAP_EXCEPTION_PAYLOAD, but they were failing
on old QEMUs that did not support it.  The recent KVM patch "KVM: x86: Deliver
exception payload on KVM_GET_VCPU_EVENTS" however fixed them even there, so
it is about time to flip the arguments to check_db_exit and avoid ugly XPASS
results with newer versions of QEMU.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ab83146..a7abd63 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8488,7 +8488,7 @@ static void vmx_db_test(void)
 	 * modified DR6, but fails miserably.
 	 */
 	single_step_guest("Software synthesized single-step", starting_dr6, 0);
-	check_db_exit(true, true, false, &post_wbinvd, DR_STEP, starting_dr6);
+	check_db_exit(false, false, false, &post_wbinvd, DR_STEP, starting_dr6);
 
 	/*
 	 * L0 synthesized #DB trap for single-step in MOVSS shadow is
@@ -8498,7 +8498,7 @@ static void vmx_db_test(void)
 	 */
 	single_step_guest("Software synthesized single-step in MOVSS shadow",
 			  starting_dr6, BIT(12) | DR_STEP | DR_TRAP0);
-	check_db_exit(true, true, true, &post_movss_wbinvd, DR_STEP | DR_TRAP0,
+	check_db_exit(true, false, true, &post_movss_wbinvd, DR_STEP | DR_TRAP0,
 		      starting_dr6);
 
 	/*
-- 
1.8.3.1

