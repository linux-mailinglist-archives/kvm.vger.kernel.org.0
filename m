Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354664BB04D
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 04:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiBRDlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 22:41:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiBRDlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 22:41:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6751324BDC
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 19:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645155686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hArr4mJlPZnwAWrYBTIVC2/1c3VQ46oZ6y6rsQQSe+k=;
        b=e2PDR2R23RT312eTFtcxpKYXtW1Om/lr4MO29SvFRa7+VrCqJ7+Ruu1oTu5UZfYnnNCXUw
        bEeQrgsGfe91zksgEXS+HFoBspvVhuxpIPGJsjXVWAYz/AfF0WLOvunDWb22dULTojyDtJ
        Y61y9bHncYGTgm8R5YCcWpsevY2nkK8=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-tWoNG8zgPbmJrfFQqCVDZg-1; Thu, 17 Feb 2022 22:41:25 -0500
X-MC-Unique: tWoNG8zgPbmJrfFQqCVDZg-1
Received: by mail-oi1-f198.google.com with SMTP id r15-20020a056808210f00b002d0d8b35b4eso878505oiw.23
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 19:41:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hArr4mJlPZnwAWrYBTIVC2/1c3VQ46oZ6y6rsQQSe+k=;
        b=up67BCVPIXFS9ztgLI4u7rvszrNViKkQbEFq76o5lty5Fp7utDr26h1eaRhgxG1rzS
         /TCRZI4z/XpDAh8mXWxlitJ1TqvPZGewb0c9iwv0sZ9rwn9BJ43kPUFlOmhmXz2+L7TG
         78XUEvJ18io+vzWQKOfkaih4KgmmzrO5Jx2EbqkBqM3TiSVtAQxhIy5DshTzcfzPwAd6
         fADJxz6G8zjdoy00DhzPhvfW9zJ+FFa6met0/PuwQeKdizKohwxv3+MelxN0vYX7UJYJ
         LWTnneXBjExyaZfZ/kSB2g9ukZSiIrmVcW3TVhZdW0n6JU5fcjN1At9Lf7OH0LEjPFQY
         kAaw==
X-Gm-Message-State: AOAM530RQnw/vmR2ryAegKOamN2YlyS3TmFrXyVygJS85id5HEWKC9Bo
        RqyH8fGxjS5x3v6ly/jI8ubFJBMSDiJcM9Hjda8F7g8hyrthIqKfNjM6vvmwpHstW8U1k4wb2bE
        DnrMoYgTsOeOO
X-Received: by 2002:a9d:2c8:0:b0:59e:bea0:a9f4 with SMTP id 66-20020a9d02c8000000b0059ebea0a9f4mr1930288otl.221.1645155684417;
        Thu, 17 Feb 2022 19:41:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0+GdnkfLgkCWNJkBfsRH9CCeWqV4vimJP6tkia4RuKX0EWc/0JV/P6rzXwl8ah+7NPZFpXw==
X-Received: by 2002:a9d:2c8:0:b0:59e:bea0:a9f4 with SMTP id 66-20020a9d02c8000000b0059ebea0a9f4mr1930266otl.221.1645155684208;
        Thu, 17 Feb 2022 19:41:24 -0800 (PST)
Received: from localhost.localdomain ([2804:431:c7f1:c12c:38a3:24a6:f679:3afd])
        by smtp.gmail.com with ESMTPSA id 189sm694698ooi.9.2022.02.17.19.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 19:41:23 -0800 (PST)
From:   Leonardo Bras <leobras@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Leonardo Bras <leobras@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH v1 1/1] x86/kvm: Fix compilation warning in non-x86_64 builds
Date:   Fri, 18 Feb 2022 00:41:00 -0300
Message-Id: <20220218034100.115702-1-leobras@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On non-x86_64 builds, the helper gtod_is_based_on_tsc() is defined but
never used, which results in an warning with -Wunused-function, and
becomes an error if -Werror is present.

Add #ifdef so gtod_is_based_on_tsc() is only defined in x86_64 builds.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca0fae020961..b389517aa6ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2363,10 +2363,12 @@ static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 	return tsc;
 }
 
+#ifdef CONFIG_X86_64
 static inline int gtod_is_based_on_tsc(int mode)
 {
 	return mode == VDSO_CLOCKMODE_TSC || mode == VDSO_CLOCKMODE_HVCLOCK;
 }
+#endif
 
 static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 {
-- 
2.35.1

