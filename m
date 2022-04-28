Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F3F513934
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 17:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343948AbiD1QB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 12:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiD1QBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 12:01:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5027DAD136
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 08:58:11 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n8so4763845plh.1
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 08:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=D5W8BN5fLNgb1BgZas8DGUwqs+FBpTKYjzFWJMRULiM=;
        b=qsI0KU2AcANsDpqsXtUnUZJOk0dmozYqNgewlnAM2LK8cA/kQnraOZY7+1eCfPzfOh
         VwJvcRX6gaupGUFTEoGwtjBH2rxZONEC3Zta+7r0FY6N+XCvRNP1UQ2txhDbO+9kq3ZT
         ZqMDeIzd0hlCqzQKVKpkJvoBvoAzbauay59lfSR28dsAbkar5A0Gq64Ee/UBcdYIGrgJ
         VMxK/Zu0j6QXj1u0KNoZovieRC/mE8ftoOmOH7OsOZtYMgXjaECbAcy5PtSjMBMSp+vv
         qu2Y1yxr+RrGscUX1XyivmJA40iQB6uwNfjlHfGk1FmwMEcPNd+EVZOUUy5pCiPME+1z
         46Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=D5W8BN5fLNgb1BgZas8DGUwqs+FBpTKYjzFWJMRULiM=;
        b=QjEUAzrK6R4948SJ/XYScrm6KVI+3gob2g7aZlV6cLneCx7sW7eUHYXhu+4bv5+ahj
         TCLXnESyif2x7MaI3AgvUSgE2+pZpH3ylqpb9M1CSui8AciOts08oo24PR9zILwFKU8O
         xxFX6qyuEOWFpyxdyx/HPgSlADDxzgGgh90kUtRVE1knZcQbODyFxX8xJT8/x356ADJm
         IQFOMWtPrA+MMTnOGnHpevrD0K0AhDXdZ2LoMfSlKQZstz5/DVrkP0SdKufalW8nYGW1
         g2V31gNXpL6t9a2Q+S86kbIfj3ag4+W2O96pUxGv+Dx3cvL8x7ew+2rKJWAH8Y/4Be7K
         L5oA==
X-Gm-Message-State: AOAM531NXCrLhGQLPqwjO9bFVuOm8H3PBPx/jeu3Y0I/FYBSHEsUuPu6
        4dfOEj5zmLXm+WscpFBTmijVFg==
X-Google-Smtp-Source: ABdhPJzfpQ9n5T0M/1gYzl/ihQ2cFlEXZ4t7vzP2iLTgnTlDoFcNQteDvy2UeFVkTh+pRLULL2NAdA==
X-Received: by 2002:a17:902:e847:b0:15d:1533:3053 with SMTP id t7-20020a170902e84700b0015d15333053mr21056164plg.49.1651161490637;
        Thu, 28 Apr 2022 08:58:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h132-20020a62838a000000b0050d3d6ad020sm242380pfe.205.2022.04.28.08.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 08:58:10 -0700 (PDT)
Date:   Thu, 28 Apr 2022 15:58:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     SU Hang <darcy.sh@antgroup.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: replace `int 0x20` with `syscall`
Message-ID: <Ymq5jsuPIjkXSQxj@google.com>
References: <YmbFN6yKwnLDRdr8@google.com>
 <20220427092700.98464-1-darcy.sh@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220427092700.98464-1-darcy.sh@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022, SU Hang wrote:
> > It doesn't matter at this time because this framework doesn't ses SYSRET, but
> > this should be USER_CS or USER_CS64.
> Oops, intel SDM vol.3 <chap 5.8.8> says:
> """
> When SYSRET transfers control to 64-bit mode user code using REX.W, the
> processor gets the privilege level 3 target code segment, instruction pointer,
>           stack segment, and flags as follows:
>     • Target code segment — Reads a non-NULL selector from IA32_STAR[63:48] + 16.

Ugh, missed that detail.

>     • Stack segment — IA32_STAR[63:48] + 8.
> """

