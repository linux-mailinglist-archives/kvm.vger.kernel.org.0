Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE406279B0
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbiKNJ5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiKNJ5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:57:14 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA2D1F608;
        Mon, 14 Nov 2022 01:56:46 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id io19so9583116plb.8;
        Mon, 14 Nov 2022 01:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9O/MeRTj6vUllTHQtkLeqz0csgML4hUFgOMRjMmUV24=;
        b=bQ1zwF6qZi8Dcje/G5UL3RxSEmA77bJ6t5DsCzbBw7Xqci5D8WYvcD856OASHsKDW9
         AJ4SvTboMYuOldY9f+cHVc0dMMqQAaMjxXobCRbCYiJizoFCKVl7n0POH+daiipBXl6K
         ISH/+/q58PHWS7Yk1g/ysMjo4NvbKJkli4fn0982Ue29odIfMQZC7LXD7BzDet8+sTmW
         EtiGJmn+VCJsb4iMSGO9gC4B/N9qYu0YGs93hzXLXZ45vLGRs4o7VF2B0WYvn2yHdBio
         ydZRAbERJy5m7Mstc+nwU1H+E/TD6ISuZCNhgl5WaWcJU8MHspZdSnlbI4DNhwRlqNAi
         +Zqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9O/MeRTj6vUllTHQtkLeqz0csgML4hUFgOMRjMmUV24=;
        b=pNbqiJQUFSK4WU0Z+ZL2h+JpxoPjirl6gVp7lCOIZ0IOb/ayh7L25YCUcO1mvVn5Jh
         X7pGZwsgC+WXJji/CMuV76HofUA8QO0CokFlN+bZK+01umzDum9HrKpHfm2DY9iBna+F
         ++PefB/4f+aBbO9c0lYtrqeKVRu/rsoYW2Eh3rT5FwOzkw7QCD1wVGnszrMpzR++T1+y
         Ci5v7EFhVOhGwE29NDNQmN2vFKOMJ+8oZKyfkMEBUXLH0UxKBRmf6ombUymx8rQ4DJND
         U69/csLByx+VHrByL6tMzwq6a9nXjrzmCLTP/P3l1jmXFmS9tt49s3I3RcU5SXPkBPuT
         RXcg==
X-Gm-Message-State: ANoB5plraLZhTsAshmM5tQ1jRAY64smf6v2w3lNFpIVJBjJ2tyZJ3zxF
        mBBiIwKgn+PQshR0hNlqZyuJ/G5HVQ0I/0bd
X-Google-Smtp-Source: AA0mqf48C8XpHVGl+JjJVl4NXtJbrISs0aFuyY18GczBhq1/sc/h0c+JvLtpyF4t3aXxd/+R+IoiMQ==
X-Received: by 2002:a17:90a:5a4a:b0:20a:f469:7307 with SMTP id m10-20020a17090a5a4a00b0020af4697307mr13185831pji.213.1668419806240;
        Mon, 14 Nov 2022 01:56:46 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:45 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] KVM: x86: Remove unnecessary export of kvm_emulate_as_nop()
Date:   Mon, 14 Nov 2022 17:56:00 +0800
Message-Id: <20221114095606.39785-9-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Don't export x86's kvm_emulate_as_nop(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee63b5ab507d..41b6361dde62 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2058,7 +2058,6 @@ int kvm_emulate_as_nop(struct kvm_vcpu *vcpu)
 {
 	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_as_nop);
 
 int kvm_emulate_invd(struct kvm_vcpu *vcpu)
 {
-- 
2.38.1

