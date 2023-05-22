Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2017A70CF99
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbjEWAkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbjEWAIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:08:52 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA00E130
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:44:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53ba38cf091so739031a12.1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684799077; x=1687391077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ekC19PIQyLsypV92abyxoKEPsTE8/RNRPDLgJ2n15Xw=;
        b=XN/1MyZIwyCwFy4GqYg6SisMPygLRn1w/KxRcndnfp8FedfFhluWIe6zqiyVwM1UeU
         OY3vFQ7yEZup9IP1qga1LMBRrXj1JEolz+4/QZH6GQaFLPN4BEnXY4r0VeLy4lJyOFr1
         xIijqf8wziKNLu2DAMq8dy1p8VzmANU0vqlnAhRzV1ZamylAV6SuxDH/pAnFlbCaXwbV
         btkpSqyMvH6DsaKKoCxMVNEVOaAjW2rTlfACiBbW7CKRtJRnCVFfF91T5cPV0dsX+Qd7
         ZcFvB3MhTQOQQHBWsYX+VU2Pxav357ooGahGZKk8WApiGh245eAIH909YarXj2hsxQmz
         puLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684799077; x=1687391077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ekC19PIQyLsypV92abyxoKEPsTE8/RNRPDLgJ2n15Xw=;
        b=Q6JQA0zgxNCppfMsBu/VWXjba7zlcMlyyz2lgLNeFjCc5xC2+d105HUjshzDARzskI
         iUstgjVoJccHKHP6fN0LjVMIQYaUCAQqNjrHoKYQ4K4wS9K18wrnxvyl/3LKUdJFHvH0
         Atkhr55I6lAT6wYmPBdd2YiE/qLMc89ol2/Qwi5zNYeb2so6GSBbNxn9dCyvnVh5kjCu
         +5jEUH6mMzmpAWcyr+YrMeW7I2lZmP3wllZ5a9E7VpbToFYtwk2JgmQDf9zlCp+PsW3K
         Ix+THg6mYZ8ejSXZAKpOzW4oISjGxFp3E256yQ2Z/SXCfxmYLpHQeXHv6swzW89LuV/P
         oFfQ==
X-Gm-Message-State: AC+VfDwlLCaf2BSff+yHVngpH3FaSOCZCsGK63pew5yzXMopfn5QgFYS
        HGDEeD7IUDlxuTAAiEhBfLSh46gDY08=
X-Google-Smtp-Source: ACHHUZ6leO5Vmh8zUNRcRrjagXuDYXWcmz5f+cnsQUQm7TRoPMqL/SN38GZZq3MvTYMy4RRqDh3fnL2MuPw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6451:0:b0:51b:61f8:6d6 with SMTP id
 s17-20020a656451000000b0051b61f806d6mr2905284pgv.0.1684799077101; Mon, 22 May
 2023 16:44:37 -0700 (PDT)
Date:   Mon, 22 May 2023 16:44:35 -0700
In-Reply-To: <20230411125718.2297768-7-aik@amd.com>
Mime-Version: 1.0
References: <20230411125718.2297768-1-aik@amd.com> <20230411125718.2297768-7-aik@amd.com>
Message-ID: <ZGv+Y60qvbjeTY57@google.com>
Subject: Re: [PATCH kernel v5 6/6] x86/sev: Do not handle #VC for DR7 read/write
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023, Alexey Kardashevskiy wrote:
> With MSR_AMD64_SEV_DEBUG_SWAP enabled, the guest is not expected to
> receive a #VC for reads or writes of DR7.
> 
> Update the SNP_FEATURES_PRESENT mask with MSR_AMD64_SNP_DEBUG_SWAP so
> an SNP guest doesn't gracefully terminate during SNP feature negotiation
> if MSR_AMD64_SEV_DEBUG_SWAP is enabled.
> 
> Since a guest is not expected to receive a #VC on DR7 accesses when
> MSR_AMD64_SEV_DEBUG_SWAP is enabled, return an error from the #VC
> handler in this situation.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
> Changes:
> v4:
> * rebased on top of SNP feature negotiation
> 
> v2:
> * use new bit definition
> ---
>  arch/x86/boot/compressed/sev.c | 2 +-
>  arch/x86/kernel/sev.c          | 6 ++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)

Can you post this separately (or bribe Boris to grab it)?  IIUC, this has no
dependency on the KVM enabling, i.e. can/should go through the tip tree without
waiting for the KVM patches to be applied.
