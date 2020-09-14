Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5FF268806
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgINJMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 05:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgINJL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 05:11:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0331CC06174A;
        Mon, 14 Sep 2020 02:11:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so11047182pgl.2;
        Mon, 14 Sep 2020 02:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W99SjuNiSKU93XEYz/Th2BW6EoBeF9ur8RNXOTGpu1M=;
        b=sJ2tO4m0oAnD4IaHdgbfzhxN5kDs6Q6yaRjZx0vSj69gJ2svy7mwhZj48Fp1mDoA8Q
         545/bKHg24Jc3SikYhxQDfPuuet3bSA7DBWIlkiy6X/7OuRvpmdnxydqYecICFR9Rkzu
         X+CvkyptRbWjn2NU192KPEUspCNs8LIXSAutLIdwbsQpKY0OWpgStK4QLry5ZwOEnBqd
         ylcgCsUPHHoMAAXCQJVo3eWidBqlg2H92E20PtXHfOGiLNlsyR+JxRohGalIaCUwiBuM
         DT5hgy1x7RezAF+6DZb7yE6BUwfSt7fTem8r0vmZ5SQDBZ1osry7KftwH7WHPPQKyk16
         P45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W99SjuNiSKU93XEYz/Th2BW6EoBeF9ur8RNXOTGpu1M=;
        b=rPFaZ9WnFqHFjWOyrE4HFIEA3vqf0ReH8gNVF6zDKecCsf9gp5gj704NxA22TZVCVp
         srdW0rmJkmEEX9eNmUjTpwiN84zMYVkOGSwnDPjoRHuHGWg4mXC98WSEJpL4CVvvyWpO
         j222RtBsGn3jnUpFp8KWCMinQ74eE0PGBkLNHMPpOo9y6DFtIVLm1zSGR4MxzrwkHogL
         wDKRLPW/q7em7gaDJeUVvnGOQiNVMdwaX9Vly3fxpCRHKviFG9NRAJsWL62xI7kU9/3B
         UEAsgSBoixr+/pNBCQptIZERIxKpuFAuf+RRhZeU1SUo2qTJjQ/hSK7ULjETbY1g6E4z
         COQw==
X-Gm-Message-State: AOAM533YgFBvPOiFC93jjsLRX8/osiRMKW53e98MwxSL/MzAll/tku7z
        r+UDEMsRyRP/D5tRgq5gEfjewlqzVXW+
X-Google-Smtp-Source: ABdhPJxMww6wS2eqYuQaeZ4VZ5IYPYRduHbFKZ5oVJyid82p9FRMSJPhl9wvm4P9kGOW419jmV9EVA==
X-Received: by 2002:a62:1cc4:0:b029:13c:1611:653d with SMTP id c187-20020a621cc40000b029013c1611653dmr12858988pfc.15.1600074717033;
        Mon, 14 Sep 2020 02:11:57 -0700 (PDT)
Received: from LiHaiwei.tencent.com ([203.205.141.65])
        by smtp.gmail.com with ESMTPSA id m13sm8765179pjl.45.2020.09.14.02.11.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2020 02:11:56 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, lihaiwei@tencent.com
Subject: [PATCH 0/2] Fix the allocation of pv cpu mask
Date:   Mon, 14 Sep 2020 17:11:46 +0800
Message-Id: <20200914091148.95654-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

Hi,

There is a old version patch of 'KVM: Check the allocation of pv cpu mask'
in upstream. The v2 and what is discussed is in url:

https://lore.kernel.org/kvm/87o8mlooki.fsf@vitty.brq.redhat.com/

In this patch, i fix the build error and make changes as suggested.

Haiwei Li (2):
  KVM: Fix the build error
  KVM: Check if __pv_cpu_mask was allocated instead of assigning ops too
    late

 arch/x86/kernel/kvm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.18.4

