Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6226A74441B
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 23:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjF3Vwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 17:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjF3Vwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 17:52:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DE23C0E
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 14:52:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c11d081de8dso2253038276.1
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 14:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688161950; x=1690753950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O2DSJWtpsrCCk+IYLMl5nWMZX09GggCCFGqt1waWzdE=;
        b=SiSzf7gN0xCWh79ZS3qJeOHm8I9bKCR3pXct/yN6sWy464Z1eFUC1+4oDtRXclphfi
         K1N9CMuOVivVcRCdMSRipN0xtUrqH88WIkODzSU3OiVmfBxwk7OrWDaB7Cls4KvMOZRo
         U1hJjBSSYvlJAujXaAuJZ1wDyiH+q8eLKtgsQvTmHOaUz7FTg9PYQzNcFZludXMYc5Wq
         LT89ndpeWd+9A4LpkyTDWrGCkIBiC/O1mjvVQRDvQ++Y4/MvcKiPOmXfE7XfrMZpn8Xc
         V19KggsxAoNOCsdDoisFEOfXwQlHrH44QhuzsxMdpoWz2Y50P5928hqzCjG23krK+2Rt
         L4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688161950; x=1690753950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2DSJWtpsrCCk+IYLMl5nWMZX09GggCCFGqt1waWzdE=;
        b=Zg4hLfaIdw2hMsezmdmjBxu5sZS3cfBF22vAzWiT/8lf+dN6tX/LtOtxu3+RVxfLmx
         ktubpr0dhWrseIfrb8zrBJs9zED9IH8tzgRwjTlcpFIIjZbYmhcwRrcdSN8xlnUBZDrv
         Tt1Zm65kPmkjg9sO0s7jr/BJBcvj7Ibwr0t2zZgZ6aDDNd34qyGI7G6YPsNNYyqRmG2Q
         ryetMdHJHfrr9/twtoYs4f9A94bzoJCCbQM3oz00X2lVn0RDce5eyH8hOCMvNbnNiB02
         I1WWYdsEA/qbDrmqXpAC79DdwPLi//YNNF1+9AkMuSMCeNv8fUO5j3iW/JwwNQ/eGeUT
         8itA==
X-Gm-Message-State: ABy/qLYE+BWlMvZRYJE/DTYjuUSGhbpF5wbUn8Q0lFHHLk/EoHeq5oPi
        5QokuGsYl8YNH/zRbw3f+k6REXOjNXA=
X-Google-Smtp-Source: APBJJlFXD/UbdAW/cdkToC8dgaurZjQ08MjiydGPc6meRpJTZ7czfP17yX8k+h/X/miqBfwfAvQml4YjjH4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:db43:0:b0:c15:42bf:22f with SMTP id
 g64-20020a25db43000000b00c1542bf022fmr34575ybf.9.1688161950591; Fri, 30 Jun
 2023 14:52:30 -0700 (PDT)
Date:   Fri, 30 Jun 2023 14:52:28 -0700
In-Reply-To: <4338da4e-300b-12f9-609e-d4b1d69eda0b@amd.com>
Mime-Version: 1.0
References: <20230615063757.3039121-1-aik@amd.com> <a209f165-b9ae-a0b3-743c-9711f5123855@amd.com>
 <6c5d1e74-0f6d-7c9d-c4e7-a42342ca60aa@amd.com> <ZJWqBO6mPTWyMgMj@google.com> <4338da4e-300b-12f9-609e-d4b1d69eda0b@amd.com>
Message-ID: <ZJ9OnJ9dzSmHFirC@google.com>
Subject: Re: [PATCH kernel 0/9 v6] KVM: SEV: Enable AMD SEV-ES DebugSwap
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
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

On Fri, Jun 30, 2023, Alexey Kardashevskiy wrote:
> 
> 
> On 24/6/23 00:19, Sean Christopherson wrote:
> > On Fri, Jun 23, 2023, Alexey Kardashevskiy wrote:
> > > Sean, do you want me to repost with "v6" in all patches or this will do?
> > 
> > No need on my end.
> 
> Cool. My colleagues are gently asking if this is any closer to getting
> pulled or not just yet? :) Thanks,

Just looked through it.  A few nits, but nothing I can't fix when applying.  I'm
planning on applying it for 6.6 (pending testing, etc.), though I'm out next week
so it'll be a week or three before that actually happens.
