Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2E2706794
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 14:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjEQMIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 08:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjEQMH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 08:07:59 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEDC1FE9
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 05:05:02 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5304913530fso610620a12.0
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 05:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684325102; x=1686917102;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RuKZVWH9E7N/bubLeMmfAj/B0LbPIeQTO+7UjwwqYA0=;
        b=kW96/xL3Oewn4JzD8YhL5YGujFjzqvhdyJTaWpQCxMeZc2hxieroK3+uuAEZD41bk9
         uz1qwGBzp/Sg1QJ62y5suMtqed8bGWJhSe+HHMoz2TKtHhjATtmXp5P01mGt2KBSjlMp
         tPm0r1PTbmEJvecSu4KW5F7zaiukRMfYfLk62PszVKGHLpLk51n67tE5NGwYNJhDF3Vy
         IPmhLfk/PYvxmMrzWGq9BB7s2wAesYSaKoHZr8FSAiDrZhBMOghlqtoZ1vKcKfwYclrO
         muWcoyqcYfoZHAV/cqn/3MCwrcY2IVb381d4hil47IuZmjdseNd1Rl0vR3ZhcVZik9OK
         I+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684325102; x=1686917102;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RuKZVWH9E7N/bubLeMmfAj/B0LbPIeQTO+7UjwwqYA0=;
        b=i4cJv36YtC2T9hVISk1aYiUoZVm7eg8DdMkseNFMcjZyv++n1qMmMG0f3T9M+yfPHU
         kXtjsGooEIaRnY5w8vAUbWHzShH1CIbS6v2mBWLVBPiRUpdN/Q3cE0IUgsJwEWbviof+
         2U2WLCRjZdZicY0ZKpa2rRQViQZzbfy9bCgYHODk61ua6QX81d6Cp0s6jlzUegXafk6l
         2cIh/Rp2vzCnrLl/SCP3o8LKi3aENqT1N3gOO0R6ZhQzFAT2t9dVqcggbFz4KUDLTBie
         hcylDBnUinVop3RajEkmZ+6I+vorgM2FEbOIDN+eFjUJD/zqrTfNB9LuVxQGUT5KLfW6
         ETKQ==
X-Gm-Message-State: AC+VfDzHUB+Cmr/er+qMb4hR9FqAfcK+Sc0as/HYaMy0ocZeoXmW6kX5
        aZpSGOwv/Mnuf/3stm6CT8ktlg==
X-Google-Smtp-Source: ACHHUZ6Abo1Ie9JeRcHIHLtMHVsxt+lqr1HCJV1Wcgikm3IKVHU0UqSCXlanfXqRhwy8QHmEKHckwg==
X-Received: by 2002:a05:6a20:734f:b0:107:35ed:28b5 with SMTP id v15-20020a056a20734f00b0010735ed28b5mr4963420pzc.2.1684325102467;
        Wed, 17 May 2023 05:05:02 -0700 (PDT)
Received: from n37-012-157.byted.org ([180.184.49.4])
        by smtp.gmail.com with ESMTPSA id u26-20020aa7839a000000b0063b86aff031sm839311pfm.108.2023.05.17.05.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 05:05:02 -0700 (PDT)
From:   "dengqiao.joey" <dengqiao.joey@bytedance.com>
To:     seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: SVM: Update destination when updating pi irte
Date:   Wed, 17 May 2023 20:04:58 +0800
Message-Id: <20230517120458.3761311-1-dengqiao.joey@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <ZGOnPMTEKqRq89jt@google.com>
References: <ZGOnPMTEKqRq89jt@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This seems to be a different issue. Joao's patch tries to fix the issue
that IRTE is not changed. The problem I encountered is that IRTE does
get changed, thus the destination field is also cleared by
amd_iommu_activate_guest_mode(). 
