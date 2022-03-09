Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD654D2916
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 07:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiCIGoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 01:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiCIGod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 01:44:33 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB46F10875C;
        Tue,  8 Mar 2022 22:43:35 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id t19so1149381plr.5;
        Tue, 08 Mar 2022 22:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9mn5K9B417wVFNbI6f3KgoYGVyI5GZhPDEl+ILoDQxo=;
        b=q32i1Mh79YKmt+VYP6HsuEIJyO3w7XO+u38oZMFlPEPsE3G8sXSDgoPb6loVs0o0qy
         68wEp2Cj9uLhbqh51EoFcM1dSS/lnKLHC2se3cA743I0ljILPHnX0gU8NRM46J43PEFX
         Nj165j6Lc+POtck7CT5pVSbz8QshvT19Vzv3HuSnRwtQLuz+iPJcraO55VMurVKqaA8U
         5JJh0wgt6hP08VDwoLEiJx5vBXkNPfFcqc4sLUidenD1PnepKkxR03kSYPpGlDktwUDC
         S4N3XjtHhHpo+SNVbN42gE/C0ug+a/sCK05h8xFoSSd5D7bf7y0LMK6aeJzjcr53YSEp
         HHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9mn5K9B417wVFNbI6f3KgoYGVyI5GZhPDEl+ILoDQxo=;
        b=hId1+lRe3z9RYvo+TE67DHEJu8H1WPAwISSnOVHd7I1BMxHQGaTeXi36JRi18NhnPO
         2iATknTFrd/r5wgFFv4+hUN1EO0damCGEVsyRdzgfYDBsxerA6dWERHokpw5VXNiKomt
         MqQvhlI6w1hHlUlCR1lOyqHNsCwU01wHXUIC4vOV7AzvnPv4PfS5ijBOsjiWMRDjvr/q
         aDU6WtEFubSxvpSkz6pJQW3TKzNrllh1nDiQvGmyQWcHkXzIjRY68E624XrslgRRSY6E
         0B8ltywxLGHSb1N9DF8iuoUs5Oha/roTtVRi0ENQ+Ob+5tGuMtqtmNiBRykCAwhCf2W2
         LodQ==
X-Gm-Message-State: AOAM532jDGT1paL/eNs2dBoN05JSbMo99ehbzaIkdA8dgWsdvA3XUIxy
        5ipNTVhdXvPbg43jgtzitRA=
X-Google-Smtp-Source: ABdhPJxXaP5Afjqm/XUVymXXASG6Af/PTshP2NTF5ciPk6IR7CEOeJXgLJhj9qnHX6CuwtE9nxqZBA==
X-Received: by 2002:a17:90b:3b92:b0:1bf:a61b:742b with SMTP id pc18-20020a17090b3b9200b001bfa61b742bmr3143820pjb.157.1646808215393;
        Tue, 08 Mar 2022 22:43:35 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l1-20020a17090aec0100b001bfa1bafeadsm1913094pjy.53.2022.03.08.22.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 22:43:35 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/xen: Use a safer data type for delta to avoid shift-count-overflow
Date:   Wed,  9 Mar 2022 14:43:24 +0800
Message-Id: <20220309064324.58213-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
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

From: Like Xu <likexu@tencent.com>

Clang warns:

arch/x86/kvm/xen.c:1219:41: warning: right shift count >= width of type [-Wshift-count-overflow]
 1219 |         (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
      |                                         ^~

The delta is long, which is 32-bit on ARCH=i386, hence the overflow
warning. Switch to uint64_t, which is 64-bit and will not overflow.

Fixes: 49c0b9159bce ("KVM: x86/xen: handle PV timers oneshot mode")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8c85a71aa8ca..097181613be5 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1204,7 +1204,7 @@ static bool kvm_xen_hcall_set_timer_op(struct kvm_vcpu *vcpu, uint64_t timeout,
 
 	if (timeout) {
 		uint64_t guest_now = get_kvmclock_ns(vcpu->kvm);
-		long delta = timeout - guest_now;
+		uint64_t delta = timeout - guest_now;
 
 		/* Xen has a 'Linux workaround' in do_set_timer_op() which
 		 * checks for negative absolute timeout values (caused by
-- 
2.35.1

