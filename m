Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787004B902C
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 19:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbiBPS1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 13:27:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbiBPS1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 13:27:35 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63300C114A
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 10:27:23 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id b9-20020a63e709000000b00362f44b02aeso1623772pgi.17
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 10:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=q1VzyPg+DxccSNbFyULTSdM4axXZfBuDbxHMjgb5aP4=;
        b=tSSE6KJK9/pXPxtp2B12po9OJZA2dihexUKG8OAt6wnZqpiPMRE9NHw4mRkReC0hrd
         SspQgDl4QE7E9myL/WDgE8xvd54pGDlQ8a5c/wzTV+woj06v6LJxSodbkPWYCj5LoNzj
         XBa8BhzXLqKQKbhGaKjeTuEIVZiIX3BPE8zLxPxshKlO2W+IsfDgqjLMrh5Xp1Qt8OkN
         NE5ZSFVlqTB+vtZLGY3X9FWeTor7qx2BGby+yKlJvP9OOrhFjA5wNJ9v+41/w1wAwy0l
         fRlYwMZorhXbaEqsgQKr/zi+W8o68dSOmGsaMG9NX20n8oiqNVF4ckDEk9Wz3hl5c4Tv
         orsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=q1VzyPg+DxccSNbFyULTSdM4axXZfBuDbxHMjgb5aP4=;
        b=pMhcBtXfrqUKzzC6lJmW07szj5uI/s3f40aKktn+YMpWEryJmHXkVGI8QdC4EwLFuI
         Q34O3k9paO/YlZbRP9X3s6+/qZlKKqoKrUTVZCE8Zzk6sLQxtU9duT26ar+tjD4tJ5jR
         ckjqpcaUSpfkkOcMbfMnPAeeK8R8fxOto23jLBmc8VnNQkBUWtWZ0cXrK1pkdcWAscpi
         nTop1Ro39czUa1MGTzjhMRQg6aoF4uYyY0HHbJDiIvzDrHIJqOw0SKZ8b9YDZFFxrZZP
         AyB5hHH7q2R9MOd/wxAFGN6NKfdXoFrW8eY+XdtK5LOZ2IH16p3q+KBqCJWlfXIccO4G
         vzOA==
X-Gm-Message-State: AOAM531VxoqPzV/symDzk9nXRvq+R9C7CYYykoJC8qsEFLrGuHaKj3no
        2S3YIW9fyky6oXoYQXis/oNx/G+zW1pAYPOUP+cWGvNH0v0F63l8Oxu3JY/+75rN2ZIKjglGaoU
        mQ2dfcIqjlUzK00PBxEF/o4dwkRG3PYalirrow6BFJZRgrgHZ1pSEpjtuNbatIDU=
X-Google-Smtp-Source: ABdhPJwAOUYg71OO8R71FjgaQVO5ooGTPZf5MALWhQbr4h/hSWSZXI498nNa1j8/iDoC2fhnxE7f+1MzqvTaLQ==
X-Received: from romanton.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:43ef])
 (user=romanton job=sendgmr) by 2002:a17:90a:7f93:b0:1b9:ef73:b2df with SMTP
 id m19-20020a17090a7f9300b001b9ef73b2dfmr88504pjl.0.1645036042252; Wed, 16
 Feb 2022 10:27:22 -0800 (PST)
Date:   Wed, 16 Feb 2022 18:26:54 +0000
Message-Id: <20220216182653.506850-1-romanton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v3] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in always
 catchup mode
From:   Anton Romanov <romanton@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     mtosatti@redhat.com, vkuznets@redhat.com,
        Anton Romanov <romanton@google.com>
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

If vcpu has tsc_always_catchup set each request updates pvclock data.
KVM_HC_CLOCK_PAIRING consumers such as ptp_kvm_x86 rely on tsc read on
host's side and do hypercall inside pvclock_read_retry loop leading to
infinite loop in such situation.

v3:
    Removed warn
    Changed return code to KVM_EFAULT
v2:
    Added warn

Signed-off-by: Anton Romanov <romanton@google.com>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7131d735b1ef..d0b31b115922 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8945,6 +8945,13 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
 		return -KVM_EOPNOTSUPP;
 
+	/*
+	 * When tsc is in permanent catchup mode guests won't be able to use
+	 * pvclock_read_retry loop to get consistent view of pvclock
+	 */
+	if (vcpu->arch.tsc_always_catchup)
+		return -KVM_EFAULT;
+
 	clock_pairing.sec = ts.tv_sec;
 	clock_pairing.nsec = ts.tv_nsec;
 	clock_pairing.tsc = kvm_read_l1_tsc(vcpu, cycle);
-- 
2.35.1.265.g69c8d7142f-goog

