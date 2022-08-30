Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5991A5A6F5C
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 23:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiH3Vnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 17:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbiH3Vnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 17:43:41 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1938C446
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:43:33 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c2so12376574plo.3
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=yxuPGAgyr2YjlkXSwoWeZko/CUmlXgmDG76kUE3q7zA=;
        b=aH4Waxy1Ly1CTXiseORnUequMFv5g4WKFXKSK01Tg3E5FoZ7Voi3A6YVqRdS/Dd0Yl
         1IoVc+nowFtPr5sPbdRIHZ1iyG9u4lJTSJyCUmSP0X7QPDn3TFtRJYxHIeF3+PHo083R
         QBmouR14BZZWovfe7pvOcUGHQWH546mpL+nAEYCtDfZjacoRQiIDC7mlRqp0vVxvWbG7
         QNG0bk3KcvENRkbms8yzQC87X4mXCIxqcG9eNc8FQ43O7QkXjA43sNzxIXJ5HI8HjdL/
         ciJz06EE+gFPjAaYrwoEe1da4NDUZ9u5CAwUolpEhve8fC45OLNAdyfxeU4E3Gyyxus2
         pZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=yxuPGAgyr2YjlkXSwoWeZko/CUmlXgmDG76kUE3q7zA=;
        b=gvJeZ+5Ab6d7b4nkn/IclonlzJXo8Vg7oZmCaY+9bYEdFa7Ciy9UNLywxyE83i5z6c
         7MOVGR3wrADjcbY46yzcTsLbZmUt9TbbyqC0uQGpvIjD7i600SwjRijum/Zqx+UxlNWj
         itOuL07uoxyITrHzOdlYBVIlgcvI8nAKoD3jBwEJqTF4tCBZs5hAjuMvfY9Wp0b1S1HW
         McEua/eTuSwoQwjUjFluhh4tltPNfsACkYguV1J96Yy28oOXllevprZTNFUBJrHaqpFR
         ZZdCLhJ7RZ9MlezHgxIV8b4wXfQwg3uVF3hs0YGnE/M1UWDewuRNh6OniM8njocOkwvR
         xtZg==
X-Gm-Message-State: ACgBeo0IgkLUCgQhmAO4Uol7XrMMzuLhjoc5CBXagKS+YFsWHWa69x6N
        CWRKZVjUp5634MrM72kTGEwsSYES2XNkbQ==
X-Google-Smtp-Source: AA6agR4d9a86XOYmekbqcUomIz+HR7ZC0q/6LOY3PB+81Acv7okg/KHbPM8scoZKhlG1pAM+Wzz7Eg==
X-Received: by 2002:a17:902:edd5:b0:174:a6e6:51f4 with SMTP id q21-20020a170902edd500b00174a6e651f4mr13206714plk.82.1661895812536;
        Tue, 30 Aug 2022 14:43:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j8-20020a170903024800b00172e97382cdsm10404872plh.285.2022.08.30.14.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:43:32 -0700 (PDT)
Date:   Tue, 30 Aug 2022 21:43:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM/VMX: Avoid stack engine synchronization uop in
 __vmx_vcpu_run
Message-ID: <Yw6EgFOcnCGa5hOo@google.com>
References: <20220816211010.25693-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816211010.25693-1-ubizjak@gmail.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022, Uros Bizjak wrote:
> Avoid instructions with explicit uses of the stack pointer between
> instructions that implicitly refer to it. The sequence of
> POP %reg; ADD $x, %RSP; POP %reg forces emission of synchronization
> uop to synchronize the value of the stack pointer in the stack engine
> and the out-of-order core.
> 
> Using POP with the dummy register instead of ADD $x, %RSP results in a
> smaller code size and faster code.
> 
> The patch also fixes the reference to the wrong register in the
> nearby comment.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---

Pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Note, the commit IDs are not guaranteed to be stable.
