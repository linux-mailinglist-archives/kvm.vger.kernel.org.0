Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC35E717909
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 09:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbjEaHxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 03:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjEaHwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 03:52:24 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A8C125;
        Wed, 31 May 2023 00:51:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d2e1a72fcca58-64d2467d640so6255620b3a.1;
        Wed, 31 May 2023 00:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685519468; x=1688111468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gdwwVTrlhtX+5DSC9fXBJMoGfz6wjbsQlSprVqEeSn8=;
        b=sabBT9LSb+JP8+jmnubHp4wKdxjz44rRuVMYu17NCTV8v5bVTf17iIFVlBd68Cms/+
         OA9YufLPvxMaxousG1Cxl0pPy1ni66HrNMqawkwYpW6Ji6NERoIZR9EBbsRYLE48iEQM
         rEtG9pNqcFC6e5MWWMUfg2hhgMEdmHhu1KKbROV0gX6ChI3rr3gSmbWvpPlXZreep6Rr
         o+gYbKDAryciO/Ksamc3UJg7VdwgoAoUV9QEZjeXBinSjeC7RJQsCGZTQac99bhZ1CYL
         5GPtt9522aXo20R08cjxyikQwe4Nb6O94x7fVMXgbsL8jgjPPi7sz0s2BjOR4WggmBpN
         ernw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685519468; x=1688111468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gdwwVTrlhtX+5DSC9fXBJMoGfz6wjbsQlSprVqEeSn8=;
        b=epktWWQ1nTbVcKVrSl46ri0X5rEWvx3k4Z+s3Swa6XIUWrYspN6++IQQt2gSKvTmag
         VBKnPSYcveSlWrQ3a+HTR7LXLxy9GFVgcQnjTF0Uwz3iVQE7SSEJneP/LrCPXgFYTBaK
         LtBr4RX0DINb+psYp7vWpHvOqXgdCfcp4X2TIeX0q7OpfkpRHIK3Hlrh0DGOw2yNSH4y
         3PQqP753aU8dtly9vHKbaPf3tqwdfuWoO7d8GTD/wdNVz7hQTMp1/dcFewwzo0VZP1vb
         ezU+6rjPzj68wbpRNAWZ2XHkKmDRGzxcB3bcmZV09RsueeDbxDvmt+QZ92UNHS9n4rKS
         v7XQ==
X-Gm-Message-State: AC+VfDzs6MrXj2tNk3+XXcllLaGHtugrUpj9f+6186j5ponMGwmzd4x8
        55WXsTG12rMQoZXl+vsHt30=
X-Google-Smtp-Source: ACHHUZ5THrdoAWJkwwwqtYPwycJnK4XFyJXky2kEOCWypNcTsm6C/jHfFkJisj3/MW2B0jspwFdwnw==
X-Received: by 2002:a05:6a20:12c4:b0:10f:1f0:9b43 with SMTP id v4-20020a056a2012c400b0010f01f09b43mr5941801pzg.6.1685519467721;
        Wed, 31 May 2023 00:51:07 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i9-20020aa79089000000b0064f95bc04d3sm2797803pfa.20.2023.05.31.00.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 00:51:07 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: x86/pmu: Add documentation for fixed ctr on PMU filter
Date:   Wed, 31 May 2023 15:50:52 +0800
Message-Id: <20230531075052.43239-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
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

From: Jinrong Liang <cloudliang@tencent.com>

Update the documentation for the KVM_SET_PMU_EVENT_FILTER ioctl
to include a detailed description of how fixed performance events
are handled in the pmu filter. The action and fixed_counter_bitmap
members of the pmu filter to determine whether fixed performance
events can be programmed by the guest. This information is helpful
for correctly configuring the fixed_counter_bitmap and action fields
to filter fixed performance events.

Suggested-by: Like Xu <likexu@tencent.com>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304150850.rx4UDDsB-lkp@intel.com
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---

v3:
- Rebased to 5c291b93e5d6(tag: kvm-x86-next-2023.04.26)
- Revise documentation to enhance user understanding. (Sean)
- Post this patch separately from the selftests changes. (Sean)

v2:
- Wrap the code from the documentation in a block of code; (Bagas Sanjaya)

v1:
https://lore.kernel.org/kvm/20230414110056.19665-5-cloudliang@tencent.com

 Documentation/virt/kvm/api.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a69e91088d76..9f680eb89b2b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5122,6 +5122,24 @@ Valid values for 'action'::
   #define KVM_PMU_EVENT_ALLOW 0
   #define KVM_PMU_EVENT_DENY 1
 
+Via this API, KVM userspace can also control the behavior of the VM's fixed
+counters (if any) by configuring the "action" and "fixed_counter_bitmap" fields.
+
+Specifically, KVM follows the following pseudo-code when determining whether to
+allow the guest FixCtr[i] to count its pre-defined fixed event::
+
+  FixCtr[i]_is_allowed = (action == ALLOW) && (bitmap & BIT(i)) ||
+    (action == DENY) && !(bitmap & BIT(i));
+  FixCtr[i]_is_denied = !FixCtr[i]_is_allowed;
+
+KVM always consumes fixed_counter_bitmap, it's userspace's responsibility to
+ensure fixed_counter_bitmap is set correctly, e.g. if userspace wants to define
+a filter that only affects general purpose counters.
+
+Note, the "events" field also applies to fixed counters' hardcoded event_select
+and unit_mask values.  "fixed_counter_bitmap" has higher priority than "events"
+if there is a contradiction between the two.
+
 4.121 KVM_PPC_SVM_OFF
 ---------------------


base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
-- 
2.31.1

