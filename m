Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BE06F6F24
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjEDPge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 11:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjEDPgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 11:36:33 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029B2E54
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 08:36:32 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-24e2b3c19e0so353985a91.2
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 08:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683214591; x=1685806591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PfH0LfzYsSkyftiuS7LtmnoOFhshkGAj7CR6MffFUlU=;
        b=wpfX+Pl85BSzJcy91iW7WjgQSGPJ50qSyfQ5CI0bchuqHTQ+dT12Qwc3JdTbl4cWD/
         o/oGasRenULdteXv7O4W6uMRR6uMMntZhOpJX9wUKPJ7F+NdLgDOA9nPw6FOMuFszmv8
         PYeYkYdq8CY+OXx9Fql7bJC+OGN3BHN+cif4lEFsoMhT3dnYTbEiQwL/NLGqslSY8Qsr
         1G16I30EriX3/E0vF8CBhJjUAVWwDbDkDacAMfVnygNg0XrWS7jq7ecRgz8709zVEbOR
         JEEWi1lXEQ0QS5j708yuHU+eAudY9fv24pos8HEBYpmLqcA6gXzEJ9Zmph8GUd8Dp2gc
         Eweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683214591; x=1685806591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PfH0LfzYsSkyftiuS7LtmnoOFhshkGAj7CR6MffFUlU=;
        b=iPTYMSSOMbA+2UWFBaSjyGDX0GgQtefPWwuPfaR5EyvfNawYbXOne/Od2yf7q4ZBiZ
         naf0HXIQQUT+WSbO+ReQugftVkzDLFXZh6LHCCiy+a/0CIf7WnHAjomNi+5Cnd+A5VEP
         IbU90mlT3vI4BU0YmDHQDTHPqDUMx5rBO3wNjvIGkRFO647oChbYjKReEp46Qjmgxbdo
         qxbrMH3s/rjRPT2HhZ77yv1GOu3YtSQBUaAo5BUZgM+QLzRWusrEd2EACQs9QeohpXcQ
         sBdxfPtKvdylbKp5U5/zvrSqpIuZXFy+zKN/15WnXPoOO1Pqn9Hyah96pbPle8ZH0Lb1
         0+PA==
X-Gm-Message-State: AC+VfDziFPGXtaaCCUI7Qx/rZh5ve8Sp291wwNP+9Ho0FyMA7bJMGc9H
        ml1zO79lvQCCOehi5O3FhsipfXELG+c=
X-Google-Smtp-Source: ACHHUZ6rb91kq7rkad7fXsuCX8Q4St6b080DC8uARN/d3dqaCkveOW3+9FP6eGedWb9B219kb1WJd53SZec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d147:b0:24d:e392:75ce with SMTP id
 t7-20020a17090ad14700b0024de39275cemr726066pjw.2.1683214591542; Thu, 04 May
 2023 08:36:31 -0700 (PDT)
Date:   Thu, 4 May 2023 08:36:29 -0700
In-Reply-To: <ZFN0tVIOfLaZGxX5@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com> <20230503182852.3431281-4-seanjc@google.com>
 <ZFN0tVIOfLaZGxX5@yzhao56-desk.sh.intel.com>
Message-ID: <ZFPQ/bkyKv5mR9kr@google.com>
Subject: Re: [PATCH 3/5] KVM: x86: Use MTRR macros to define possible MTRR MSR ranges
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 04, 2023, Yan Zhao wrote:
> On Wed, May 03, 2023 at 11:28:50AM -0700, Sean Christopherson wrote:
> > Use the MTRR macros to identify the ranges of possible MTRR MSRs instead
> 
> What about using MTRR macros to replace other 0x200 in mtrr.c too?

Ugh, yes, I 'll convert all of those in v2 (wow, there are a lot of them).

Ooh, and I missed that once the SVM usage of kvm_mtrr_valid() goes away, that thing
can be made a static function.

There's quite a bit of cleanup that can be done in the mtrr.c code, I'll see if
there's any other low hanging fruit that can be picked for this series.
