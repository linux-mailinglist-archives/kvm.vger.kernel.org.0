Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE9F5BEF39
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiITVgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiITVgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 17:36:24 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4336857277
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:36:23 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id iw17so3770077plb.0
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=lW8FaOqfKG8NiNj+wZ8OWwsYMviJret5ZI7CXSUxiuQ=;
        b=VYjRqHztHWgV7OTwnLUGrZt37xjYnO9Gf9F4kTN1Wh3gf04CaojIvHTEl+AW0ayEAu
         89+s7OTNvRvIYiqbwPcYbnakRMBtUyxMNyPPafpMcc1ohOV1wR7s3DhRTIUh7q4gAdzT
         FSRVbZFQmeWsfaRFR4D90B0rceTKJc5Tmu1RhC8s2XyySXvI8HN1dKXKXb38Vvs7V5wK
         uSW5drdckG+gjMT2hiwqQzb0aoLphZGIlKlsorE8XpCnPfmokVxW435OF7ScX1kbHafo
         XnzNSkODUiicx2PqOQnVpxz0jc/L7YhfQaQu2N84+7Ty6Rfi/GrJrJsEaINF4B7mq+IM
         ZMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=lW8FaOqfKG8NiNj+wZ8OWwsYMviJret5ZI7CXSUxiuQ=;
        b=7Tl+NNqYZhm7e+tNrPaASEr+XxMRVT7nR40ZpPTimh806XMbhhsT48sO2XpyFiSwVL
         rkoYYD972iQ8wUYFHQ/TB1tJoC6cMn83jOlGKNEwtphhaGT+il9sSUff57uWhXMWl7nO
         illEUoQfWZa6vJqAP4mt9srpMpA2sTn+hMk1IxVXL9el84+sT7zoMK7S7OZBoauInfNJ
         86aZ58vOBz8H0Thhv4E83thKTXLSUWO4W7TPQ2MCzwqF/JBY39XpZhUp06Vds3/5pix4
         B0Q9Qo9TA9tRPgouaK8r7cVbPZyp2ISifpgOxYEdUEEYmF9iKj/TWti6l/nidrqjTpFg
         QyKQ==
X-Gm-Message-State: ACrzQf36i+nWp9ioSsdKsHzMFZv5nZsUETFhUiLwYhHiQ3w7P1vrPj5Y
        akykjcepKYbmuJLR8BS1tlmlyA==
X-Google-Smtp-Source: AMsMyM5KIlE6akR3/LS3Cv/vtp9FYDBTu+R4aKr9iGDjlkkigm/+Tpoa9URwIn8FbClTdnjQD1CMfw==
X-Received: by 2002:a17:90a:ce8a:b0:203:7b48:dcdf with SMTP id g10-20020a17090ace8a00b002037b48dcdfmr6118848pju.12.1663709782560;
        Tue, 20 Sep 2022 14:36:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902c10400b00168dadc7354sm381057pli.78.2022.09.20.14.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 14:36:22 -0700 (PDT)
Date:   Tue, 20 Sep 2022 21:36:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
Message-ID: <YyoyUp8QAcyrcq01@google.com>
References: <20220920205922.1564814-1-jmattson@google.com>
 <Yyot34LGkFR2/j5f@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyot34LGkFR2/j5f@zn.tnic>
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

On Tue, Sep 20, 2022, Borislav Petkov wrote:
> On Tue, Sep 20, 2022 at 01:59:19PM -0700, Jim Mattson wrote:
> > Jim Mattson (3):
> >   Revert "KVM: SVM: Allow EFER.LMSLE to be set with nested svm"
> >   x86/cpufeatures: Introduce X86_FEATURE_NO_LMSLE
> >   KVM: SVM: Unconditionally enumerate EferLmsleUnsupported
> 
> Why do you need those two if you revert the hack? After the revert,
> anything that tries to set LMSLE should get a #GP anyway, no?

Yes, but ideally KVM would explicitly tell the guest "you don't have LMSLE".
Probably a moot point, but at the same time I don't see a reason not to be
explicit.
