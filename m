Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408236D0143
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjC3Kcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 06:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjC3Kcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 06:32:39 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5023883DB
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 03:32:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so21477100pjt.2
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 03:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680172355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lF8w+v1I1As3PcRa2mFbl+1Nj6II4gicPPy/HXfsPUE=;
        b=agjBVM6haHpie21j60SdRYXaMuqusHQ6I0SiDhcGf8GOmptk/rQjZJdRkqp/wDdc1y
         Isp6hWQflYExQE4t87mFCstZ+dk4qjf+cIw7ZGjtk+3Ej5AZLCN+WtpNks/pvVxBgC9Q
         0tX4GjssDMYbRqzu4MAOjI3jpg8o9nXxp3J+bE38x+xr+Zq/ABpLd+ZZoeLBFrmlaA7p
         01SwwdmXUYsJ8ZJZuNxKLWGxmly3H7ZVW1aIJQI1WAjRcTGMxItcJ7YiJFt1L4oqFRYw
         Fx3DYtGh6hUyFKDrJLeLGcXA3+t4CbrM988MG5kHhVLvw6rCtOcBlgL1sT67h3cZcmAV
         YtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680172355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lF8w+v1I1As3PcRa2mFbl+1Nj6II4gicPPy/HXfsPUE=;
        b=WubGoNkYSG801gJeBGulOONh+bOvnqbq8RrVpAv0Ba+EdgmQwVuuNBlOmdAgy47LWI
         T+TCIV8T3PmIq2E+dqji33iya1Vwd6gpyqKuhdFAPYFLMRb8+jcYF9RTag3t5aOJ67ID
         /XsQxFyIEsAJJwLhJyyCe5w3L3iGGLzKNuXsOBDQMhK/DR38Wiy1FoIuZeVOimo4UxzT
         dhFxetTd85gaYUUnmGm74OPCfznd538qmSpes9cCITCKK/xrVEMKBJ6xf2gYlCtV2Q6I
         S15NkzzAV3qviVU2grTaBZttz8+qlsIwlpWK2L57flM3H9Z8HsnfCCGRTwRhgtzqW/UP
         5Opw==
X-Gm-Message-State: AAQBX9c0FeAxvlaQezqGczy0Taldm25PIq+FNbXxVyWz5lLce4IDQvdp
        bBMu7ejIZWWRO5eDfGnyVcA+1L/PnJw=
X-Google-Smtp-Source: AKy350bVPCbrPrrJ8o+kZqey+ilR1iv3/onIOPz19yPsTPV9nu8tgtJn3o74QlkOKNaBVEMQOfE3xQ==
X-Received: by 2002:a17:90b:3b90:b0:23d:500f:e826 with SMTP id pc16-20020a17090b3b9000b0023d500fe826mr24512461pjb.14.1680172354675;
        Thu, 30 Mar 2023 03:32:34 -0700 (PDT)
Received: from bobo.ibm.com ([203.220.177.81])
        by smtp.gmail.com with ESMTPSA id 6-20020a17090a08c600b0023440af7aafsm2895219pjn.9.2023.03.30.03.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 03:32:33 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        "Paul Mackerras" <paulus@ozlabs.org>,
        "Michael Neuling" <mikey@neuling.org>
Subject: [PATCH v2 0/2] KVM: PPC: Book3S HV: Injected interrupt SRR1
Date:   Thu, 30 Mar 2023 20:32:22 +1000
Message-Id: <20230330103224.3589928-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I missed this in my earlier review and testing, but I think we need
these in the prefix instruction enablement series before the final patch
that enables HFSCR[PREFIX] for guests.

Thanks,
Nick

Nicholas Piggin (2):
  KVM: PPC: Permit SRR1 flags in more injected interrupt types
  KVM: PPC: Book3S HV: Set SRR1[PREFIX] bit on injected interrupts

 arch/powerpc/include/asm/kvm_ppc.h     | 27 ++++++++++++++--------
 arch/powerpc/kvm/book3s.c              | 32 +++++++++++++-------------
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 13 +++++++----
 arch/powerpc/kvm/book3s_hv.c           | 23 ++++++++++++------
 arch/powerpc/kvm/book3s_hv_nested.c    |  9 +++++---
 arch/powerpc/kvm/book3s_pr.c           |  4 ++--
 arch/powerpc/kvm/booke.c               | 13 +++++++----
 arch/powerpc/kvm/emulate_loadstore.c   |  6 ++---
 arch/powerpc/kvm/powerpc.c             |  4 +++-
 9 files changed, 81 insertions(+), 50 deletions(-)

-- 
2.37.2

