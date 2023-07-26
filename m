Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F68763AC0
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 17:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjGZPSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 11:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjGZPSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 11:18:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184A52D78
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 08:18:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb83eb84e5so38829685ad.1
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 08:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690384701; x=1690989501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lOx8kWw7HF9gNkz5zKREDyGpPsnTo0LNrOBF22V9O60=;
        b=W9r3L9IQlkEmuH9+y30bo+yF4oOSL/RThQsFXXKGl1Gb5VRvmM8aQQw+8QNPeeh0u6
         HL0R4Csrke0J38z0sg2QPH0l8hK9GzkAeAnXGNdaF9OzI/hTHLBK0Ef8943ZzbQo7iPK
         vo0hn5GcIj0nCZyyYleyFxBA0PkNOCeUE7aD8Ut7bQg2ceBD7HeU1t6mPIMlq2et9Qxh
         8WU96fu6t1vPud2qIPyATwNeFUEl22liRt97wh1KDwgYoqP0FqTu0RK92C3Rhzf167aq
         kzr58mOzVKKEz2gx0ABfBpRedBXfxjJ7mxvpDf19BT8AWpiTHMKDALLseXG1+1yJ5y4y
         PDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690384701; x=1690989501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lOx8kWw7HF9gNkz5zKREDyGpPsnTo0LNrOBF22V9O60=;
        b=KgbwZQioj2aoCSd1DxXd5Yeu9aUzOpszWZ1y+0mCZLLGTEASaayCSZy/EZgS0q2Ru7
         T36skIPpWk1+P3N8cF+xlCPKT/vaIGRaKA5CgKCFSEkqgrAwdcqVnpktJCXwmoT392Zg
         x7k7EQfJ7FJCOs1UDF+I+taFK5FI6h98Pfpz6YPuMVkNKRvw3TfDSLvIirOFghP6zdnz
         hhokzPFd6swYlcbFx0NCYqgbIN9zAvbL3ZNlY+GPD7ja4L09AgQEUTtu/e/rXQz+gvNp
         V9sbPlHcX5qf39Pt74syCX6RukRXw6R3Eb7UYgFt69pp/AZgqwDQIz6wSm1h3Wm6npkp
         l0vg==
X-Gm-Message-State: ABy/qLb0ox6U9HVr80gN5RskP68wFXudv3wCN4W+FqLyIAzk+32Bi/Dp
        19PAJQO6e1ptVRDsShouwgt16UycG3w=
X-Google-Smtp-Source: APBJJlHlHmTKWWQJzfHPxtwz7qxJZp1hXgLIUFDM5iljMO0rvRc7TxM4IT/WXpYCnxtYrN5VY0wr7pgs6iM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c3:b0:1b8:b7fc:9aa1 with SMTP id
 u3-20020a170902e5c300b001b8b7fc9aa1mr12291plf.1.1690384701012; Wed, 26 Jul
 2023 08:18:21 -0700 (PDT)
Date:   Wed, 26 Jul 2023 08:17:48 -0700
In-Reply-To: <20230717041903.85480-1-manali.shukla@amd.com>
Mime-Version: 1.0
References: <20230717041903.85480-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <169023364964.112092.16943601501146481152.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: correct the size of spec_ctrl field in VMCB
 save area
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Jul 2023 04:19:03 +0000, Manali Shukla wrote:
> Correct the spec_ctrl field in the VMCB save area based on the AMD
> Programmer's manual.
> 
> Originally, the spec_ctrl was listed as u32 with 4 bytes of reserved
> area.  The AMD Programmer's Manual now lists the spec_ctrl as 8 bytes
> in VMCB save area.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: SVM: correct the size of spec_ctrl field in VMCB save area
      https://github.com/kvm-x86/linux/commit/f1f10c4a1e9b

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
