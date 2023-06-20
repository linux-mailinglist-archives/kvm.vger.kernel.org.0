Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24D7737677
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 23:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjFTVNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 17:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjFTVNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 17:13:39 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075A1E2
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 14:13:39 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-4718ddce780so1318426e0c.1
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 14:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687295618; x=1689887618;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tDFMiEyTFCNcCofuAvTmueHcfkEsL/r/lI8i21xCuUg=;
        b=sugIGRe+WH7wDcI50HaCXG1NCXcWDoee4nh/MGdjZ1mWd7HS8tAZkkL+zlxjWs1Yk/
         839OAG3n3dx6eHVwoOVLLPL0cdVJhEb7sRjrqK/X4x8FllcEKpBPb2DNjFEwoMUNfoh/
         1AERdyDfiv0/3K9qqebQXxfimXYobaTj8gNr+6xAnpjlQYF2vsc+2Vs3V8Fh4j9M+Iia
         XlNPm02LeR46inXW0xJamYdEiNSwx76RrRiKc4BnQJEHqo5uKAkdeYUTeHRx7SkNWPIx
         OL1QdCxV3gJ5/jDGmvK8Y3J3SkaSyWguoaAOf3NcD9Cf5CpAFd7LsaaMt0VZozpjMORW
         wXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687295618; x=1689887618;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDFMiEyTFCNcCofuAvTmueHcfkEsL/r/lI8i21xCuUg=;
        b=BvjPGwGbNurIZopNqCmnsOqOcbz2l1D/fU23e/V7TQLgd6/4EmiccSx9iz/YfWcCoj
         LrfE1DJiPw3jAEfL2jAFz/PnYahoxW824Whl1xgK+4q1ARhDZQoeqM9ULqlXVspMq9hG
         Z4Fs5Wjz8BxheRj5Uu0vAcnIhrBc0glSYdlfp141lF/c1NLbZFg0auZ9M3KQWfSxps4Q
         Ejyqeqb4Jnlz9zOc92AxOIR0xPfm+ziFZDO3GiHJdk1pcaPopV6Q7sYjLvCJv6jxR46g
         c9xvIXwSKu10+TFwDd+OtzKehYc/BgYFgYNCIQ8IhsI8Ms0yRQa3XykVppDf5Ra7y+dp
         jV/A==
X-Gm-Message-State: AC+VfDxw6zX67MSp0/cvAiJXHyetS+oWJ3yzy1uZMVA7FcdX/ePyDVe/
        QXQxvknN98jVihMB2Zb5uS4OIFbt2lJrwsjTTSAfKw==
X-Google-Smtp-Source: ACHHUZ7MGyWfvm7Qjk2VFxWWuav74M2wp1KPvukonWJsSS6eyCfFNqh93vnu/OWvy4ITzTlVmjSFtwNQuw/sTKfFkL4=
X-Received: by 2002:a1f:450e:0:b0:471:549e:c1ff with SMTP id
 s14-20020a1f450e000000b00471549ec1ffmr5615772vka.7.1687295617999; Tue, 20 Jun
 2023 14:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com>
In-Reply-To: <ZIn6VQSebTRN1jtX@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 20 Jun 2023 14:13:02 -0700
Message-ID: <CAF7b7mo-16NERWPF9ZDaX_Ao8DLPuKuQ2f99kbE5WtFf1Nvqxw@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for all the review Sean: I'm busy with other work at the
moment, so I can't address this all atm. But I should have a chance to
take the feedback and send up a new version before too long :)
