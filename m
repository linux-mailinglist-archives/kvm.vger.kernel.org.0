Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3708A4BF450
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiBVJDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiBVJDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:03:19 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A81913777C;
        Tue, 22 Feb 2022 01:02:54 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gf13-20020a17090ac7cd00b001bbfb9d760eso1768565pjb.2;
        Tue, 22 Feb 2022 01:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=LFEBBwpcqufEdu+q4gVGD+04Yq0W1F2dDxbkizD2bWk=;
        b=BWemOTsBscBhV4ThWCBrrOnCqwTRaNGnhDLaWa96svYwp6M96MYMytnPTLsudQxuh7
         4UAARUgjdigtjOTKbHqNd0JralJgj+Jgt8pnosn5MNGtajEvW/btl47ui8ySmxkRmU91
         V+B0cx0kLxw6mcbidz7NzTWwXAZrnFnzZTBTvyJ22brIrar3VsGE5lQqDnRuekB2QLG0
         wIi+XY3QQn+4//q2N2JZcpO+v29tk6VaQsLwv2Q9kLHvq73r6aVOlF/lYmMeURihUZDk
         SjKT706QuSRuDjGW/lEOV0GnPVh1dHir03vOHemutQqLamhgKc1cE4Cdt581Ua1Xq44R
         HtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LFEBBwpcqufEdu+q4gVGD+04Yq0W1F2dDxbkizD2bWk=;
        b=eD0aQ98Bdl6FCC5IpWYdR3XMCaMR+g3j24xnyzIzh3h0Wr7OZ0UQnUep7eTsERJUKd
         sxmPFrSze7GVuFCV2GiXa+GxASimPcBExAa2l67xMcBtKtOXQiGRoMtH4v4WdRw/oE/E
         dr6fu+y90kkHqO8E72EWG5Ippu8tDhtSubRWt0bassdSCDqdOsrNpcLz8cFtm80vIdDj
         WIYivQTCaM4SNeBb5czECRjTk/Cwwts/Ki4LEsTn1TfgsBN+h2VriLqpc+A19sK49dE8
         QaQxG7GyKAzg0o+eTtjh9CNUxWnGDzS2N+Udg6+cn2wIIpc+DjLn0eDsQYy2Q6v7kTM3
         f4jQ==
X-Gm-Message-State: AOAM530545ac2Ivk/6pmL+1KKLdeSq0oa6K0BCePt68rGTATUIwHd2qA
        CmoZTLbBOZ3QapBVZmzwbKrrgguTHjI=
X-Google-Smtp-Source: ABdhPJzaVzFiuqKQy6BOqzvOW3D+kURtS5vjmHf83HpRWKWgPwCRKV2VmOiRoS29sqIOFrwJRz6rBA==
X-Received: by 2002:a17:902:b204:b0:14d:a8c8:af37 with SMTP id t4-20020a170902b20400b0014da8c8af37mr22586018plr.108.1645520573902;
        Tue, 22 Feb 2022 01:02:53 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.googlemail.com with ESMTPSA id k24sm15785290pfi.174.2022.02.22.01.02.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Feb 2022 01:02:53 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] x86/kvm: Don't waste memory if kvmclock is disabled
Date:   Tue, 22 Feb 2022 01:02:03 -0800
Message-Id: <1645520523-30814-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Even if "no-kvmclock" is passed in cmdline parameter, the guest kernel 
still allocates hvclock_mem which is scaled by the number of vCPUs, 
let's check kvmclock enable in advance to avoid this memory waste.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvmclock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index a35cbf9107af..44ed677d401f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -239,6 +239,9 @@ static void __init kvmclock_init_mem(void)
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
+	if (!kvmclock)
+		return 0;
+
 	kvmclock_init_mem();
 
 #ifdef CONFIG_X86_64
-- 
2.25.1

