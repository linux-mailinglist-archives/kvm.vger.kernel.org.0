Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E73F520D02
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 06:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbiEJEl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 00:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiEJEly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 00:41:54 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8A975214;
        Mon,  9 May 2022 21:37:58 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v10so13672436pgl.11;
        Mon, 09 May 2022 21:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=sKl5pNCwJXU7WqvT/LDmg67nZYMXHrw3gGTNE00KDiM=;
        b=YePOexK84CQ26EIabu9A5b/dbFhTTZfpTaQ9ubxq1XtqEoLg3vJG5MoS27rmCWDTos
         QdVx/dA4Gn6rzw8xAYF+fnnaO2t00OFrbbLXBrEVi5toVKZ0x8MFvY8LMcKaeOjy+LlY
         txxRSWSM/8MSlK4nm2MEXKXNESUA7m9BiT7HbEzuKSA5m4YEUvGIS+QeBI50gKpaP33d
         9SLIk8stQK7Gu2mytwvcrQY4TrI8je+YG+dXa0CL0YRwg92qBJu43lC2Mc6Gbs5o+WMe
         Jv+wl1g0+xdRzyFJZcUpjhNH2bv9IdKSj872B0vVOF4t0pc6WAl5JmaM3MliwGo5uGqw
         f0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=sKl5pNCwJXU7WqvT/LDmg67nZYMXHrw3gGTNE00KDiM=;
        b=uIi5Fjb8wAP6TX2cpsstYm4DyYAe0ZMJ+HRJkP/eMegGBzK1Kh+OhDjaI8Jt+8MsnD
         Cw+hextevFtn7gNz/6HlXGGfeJIhUymyfq2QLfeyLlgjKYEKhw90pQsfLneMPTVsnoq3
         1qUS0Maya1gtMZ/glgU8UkJMJCylSnDdQum2tRAaT82VACJwhHZ58TaAlKU9eNh95XRP
         526G6x+RbineqAvJ3YRm9Rnj7EfVoLatb+PgLeT5LXiPVztzrFaJrHThcH8w6fIy71dz
         FQrsmJQt5K3J/bMjo+OhvcBm+zgTx09SJubZlP265C5RerBpNHuqFYTQ6NI0JyATnLad
         tVvQ==
X-Gm-Message-State: AOAM531eyalcVEIuRmSDUJvZkEsNQ3crCChCDpH4gahUMfDiyM77uudT
        NDzvLVmKaaEbjurdKH/cOWg=
X-Google-Smtp-Source: ABdhPJxf8HyqGkQnaloAnkZ5hnwQl0PRFEqFWflgOFMeNq7L2seaOFZiS7nRWqVRztzEuTFZ5gcFBw==
X-Received: by 2002:a63:3e44:0:b0:3c3:dabd:eb03 with SMTP id l65-20020a633e44000000b003c3dabdeb03mr15260729pga.15.1652157478224;
        Mon, 09 May 2022 21:37:58 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id 67-20020a621946000000b0050dc7628190sm9570550pfz.106.2022.05.09.21.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 21:37:57 -0700 (PDT)
Message-ID: <f3a7fc7c-959e-9f7f-b6f7-25f51b4caed6@gmail.com>
Date:   Tue, 10 May 2022 12:37:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH V2 2/3] KVM: x86/pmu: Don't pre-set the pmu->global_ctrl
 when refreshing
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220509102204.62389-1-likexu@tencent.com>
 <20220509102204.62389-2-likexu@tencent.com>
In-Reply-To: <20220509102204.62389-2-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Assigning a value to pmu->global_ctrl just to set the value of
pmu->global_ctrl_mask in a more readable way leaves a side effect of
not conforming to the specification. The value is reset to zero on
Power up and Reset but keeps unchanged on INIT, like an ordinary MSR.

Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- Explicitly add parentheses around;

  arch/x86/kvm/vmx/pmu_intel.c | 5 ++---
  1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index cff03baf8921..7945e97db0af 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -525,9 +525,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
          setup_fixed_pmc_eventsel(pmu);
      }

-    pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
-        (((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
-    pmu->global_ctrl_mask = ~pmu->global_ctrl;
+    pmu->global_ctrl_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
+        (((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
      pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
              & ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
                  MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
-- 
2.36.1



