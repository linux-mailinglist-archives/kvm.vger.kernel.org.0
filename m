Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F11B4C8BF8
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 13:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbiCAMue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 07:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiCAMud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 07:50:33 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722F39318A;
        Tue,  1 Mar 2022 04:49:52 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id p8so14110301pfh.8;
        Tue, 01 Mar 2022 04:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hIkTawNE48vxd1UfJnuejiaVGdnJ+bvfpuNmqFHDU1Y=;
        b=YdGPuKWb4tm6kp1cE1tVsBGFHpk129c368SFydDXdLuDzPkikjr3QoyAAIi16xGx/d
         zHiXvTjfuFvGxiuE8ZU2+YMPsHLf1sAKfa1cRZ6SG4N9lrf0qwA07qTZB+gmsUjNk4mQ
         d3qfU5b98eQbcUBo6CKfdCcCc+NLRu92IIRRZSJbWV5aBKeKqWc0mlmj8VfeIh31nvyL
         odhM/6Ihd5pUw3p/6Yj0AMbhOZ2eSc4PC6wk22PRgG18A+AyA3yXE528fXOzN/rAxT6Y
         lzLhhU/KudinidH3seOLqwxG75BwKXGQ/jQIWl8SXBRjhCROVl7D+4ezAoQxS2ywK1+7
         5zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hIkTawNE48vxd1UfJnuejiaVGdnJ+bvfpuNmqFHDU1Y=;
        b=HlDmv+yoNyywLcrank46MKQSso+MlvxtufjSCbsuTF1li5VNSWWw2QOdmay+TqdwZM
         /9LSCS6IK2/vGR28pqhou3TpEjTdzpDeMg+N6nGqh2/7hzN+x3E1R4xRWcGhZ00rT1k5
         +qD3QH2jf+yd9QZt3zTdvv3tkCgwBSCcj3jz+SG6fk51hP8OkB7n4Awc8oom1x/Knctx
         UdOgoUh1vyZD90kACVueJBkn9tMnz1bP4eXXwVyoNe6exCU7nyzuSp7PHwYLzUb5FJNW
         t6HcZb5p2x/zn4vCCUb3cyDbNS4gq7OBR5vDDVFpKqmuOjva63bpvjMC5ZkIFOXYHcRh
         +vTQ==
X-Gm-Message-State: AOAM5328qu4Ukc0ue/hFCBcUYJS5JZD9Iw7jJkv0iBvi2/qy1U8UZTZz
        42zCFb3dS4giT/FmQi6wVaw=
X-Google-Smtp-Source: ABdhPJy3kd18BXQ2G6PTaZCp2dThZJbNI67UD5cd1pm/J1dXl84UzYbQA3DskahUEuuo8u1qqjn0mw==
X-Received: by 2002:a63:cf01:0:b0:374:2979:8407 with SMTP id j1-20020a63cf01000000b0037429798407mr21080578pgg.521.1646138992038;
        Tue, 01 Mar 2022 04:49:52 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u19-20020a056a00099300b004e16e381696sm17532252pfg.195.2022.03.01.04.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:49:51 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Passing up the error state of mmu_alloc_shadow_roots()
Date:   Tue,  1 Mar 2022 20:49:41 +0800
Message-Id: <20220301124941.48412-1-likexu@tencent.com>
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

Just like on the optional mmu_alloc_direct_roots() path, once shadow
path reaches "r = -EIO" somewhere, the caller needs to know the actual
state in order to enter error handling and avoid something worse.

Fixes: 4a38162ee9f1 ("KVM: MMU: load PDPTRs outside mmu_lock")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b2c1c4eb6007..304bfdc50fea 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3533,7 +3533,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-	return 0;
+	return r;
 }
 
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
-- 
2.35.1

