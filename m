Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDB76279A3
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiKNJ4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiKNJ4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:56:31 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0959038A2;
        Mon, 14 Nov 2022 01:56:31 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso13305783pjc.0;
        Mon, 14 Nov 2022 01:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ooseHmVLLt4/9zPKjmPpC1Mx4v+3GYdtTTFlVzlVkC0=;
        b=NVdpzrRBsawOQO2VFvUgQSlCWiQA6Cb4TxB5BPPFNzFehOgBSDZW9U36fM5ckbdOQW
         9Hb6sadY4OVW05QD6tngzIcDHFJm6Mhr6uFDNHCdK6RJhvTxXTYtb8qi4E6cH83ZDyqd
         7T+Hwqqg0f9mcyo2h+x/Q6vtgvMLtWpmyvA7uWOaHsMmUQkod9IfuVTplG+q5gqbxbfF
         UYZLQ//uqqz4Qd5i7xHpyXnuqLb/Zt8C1Crt/2klV/bK0LnK7wtDFQTNrs5bJ7uezM84
         iBXKNl8Oajpoh2D9plhZiq4kd7igIFIqwsvrb2JOtLC1l4lrBF2zgALf3e9dSV+qKBlI
         fGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ooseHmVLLt4/9zPKjmPpC1Mx4v+3GYdtTTFlVzlVkC0=;
        b=hVyeQYD8H90LfJ4lkebagsBeFiK25Ip0BEEazFaJ3TpVwMZQ1m7yJR5+VmRVz7Om/j
         EFGUv9t1MOjVgSf1SRQS/f0m8z+XyHz2/+/D0uzOt/HF54Dshz8mZlFN3EnFAFhXEYM6
         2Ai6MikkANx4Pp1NRgJYCTE6qGpGYgIiSDrhnA02/B527ObQ2PJULS0cQWQFAELUNoAf
         hp20yJVbCPdNHs/vRx/JTclWV4oQAEZAiSDmCJ2YAuh+nmSgIyqCsK9OjCn6K5MJdG9A
         qxuO1YITHm723E1tFBeVO8Csx2A6YQuvSwmL5Hq2Ra6X2lMOMeZyRIFiiHy0z83DG/Vf
         7hJQ==
X-Gm-Message-State: ANoB5plg7rbeS39DWO+uGWoMv7PSc1IBy8gLVDpYDZqbEqehYvfEtY+y
        foG8GEOnGf5CKfA1t6+zjyX42Xpo5igOcH0B
X-Google-Smtp-Source: AA0mqf4IKMzxXrUOxeZkI4JnEoB3V0dG6zF/7mZPOR7R3diNA2JS1CJA4eEMPxXa268HZGigwfIddA==
X-Received: by 2002:a17:902:d395:b0:187:3a54:9b93 with SMTP id e21-20020a170902d39500b001873a549b93mr13345751pld.2.1668419790540;
        Mon, 14 Nov 2022 01:56:30 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:30 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] KVM: x86: Remove unnecessary export of kvm_cpu_has_pending_timer()
Date:   Mon, 14 Nov 2022 17:55:53 +0800
Message-Id: <20221114095606.39785-2-likexu@tencent.com>
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

From: Sean Christopherson <seanjc@google.com>

Don't export x86's kvm_cpu_has_pending_timer(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index d8d50558f165..04a009fbdf8a 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -31,7 +31,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 	return r;
 }
-EXPORT_SYMBOL(kvm_cpu_has_pending_timer);
 
 /*
  * check if there is a pending userspace external interrupt
-- 
2.38.1

