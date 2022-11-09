Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F38622ED1
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 16:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiKIPOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 10:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiKIPOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 10:14:10 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA6B1182F
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 07:14:07 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d20so16297012plr.10
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 07:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UtJwvJLci/JkatzPK3HpdffetRpjfLyKGKg9pHS1Les=;
        b=MwKhsKJKuWT7rUX72ct9BRC3oqwZp+jCkoE4Wj4/KI6/IAHTVWqF+i1o6oWMA6UrEG
         1h/4GOO/9ys3qzDeMRBQ2oZRjeXrAp/SvFOnZ6Cqh/qX215D9d/QEteSI5UvFpASq+Dk
         7kCGz8qmfvs0D+OUhAMN6Zlbe6DO8JZWgxdLqReTuzVODyRy9yuH719baf+Kl6/q2zjA
         vsI0dRXhaT6Vt0MU32TLShFbaXhdkyCn16OnvMzzEkKpmDUCakpm00+4ManMWm7JKc7j
         q9avGzkB5W8zoWyqjelAmfCiQDV/O7qLitX3GLKtfjGd8dDKd8W8bN4yTVaQ0ZU4QuRk
         mtyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UtJwvJLci/JkatzPK3HpdffetRpjfLyKGKg9pHS1Les=;
        b=dN3nXqjVyvQU++GCOBLIOPZuOTJa3DMiaqjDzYWAbACQjQBr7WPvKJCG7YPa1aXWv+
         bfPgiuya1PVH/Ao2oywnKgAGeRq0l3iulsHft4bR7GAIy25/OL4aHJr+oND+T/ywTcYN
         BmCcXrNCrD6Nbyf/kZumdZv5KJWVnpLJC3yK1r4TyIAiKP3SrAq/3r3YDBv+SI2HW4W1
         uV3kV+Mjojq1nIQTKDPuiMuqtiZbs0VopHuOQVx9BXTgO71slhpw8PoaVzPmMhSzHwGJ
         ND+YQNpm990pc1zyCP2TmLhsecIVVcuCnAVRe03vBGIyRXwzOuHsQQKn9Yqd4bDUel6W
         xikQ==
X-Gm-Message-State: ANoB5pkwASaOd3eJ+sB5Fcw5yG/NFbGVeHHK9WjFeguvtzsPKkQOG3Rk
        9caFT14LpHjzfKYOLySK1Bs7rw==
X-Google-Smtp-Source: AA0mqf5uG8MYfxZdmmvFGzKC7bnnIjzg8XzE+ryacGjVjx1GXT2Idp4er6qqAOaAC1YFbCO4UEwJcg==
X-Received: by 2002:a17:902:ce88:b0:188:6429:fedd with SMTP id f8-20020a170902ce8800b001886429feddmr28807424plg.0.1668006846620;
        Wed, 09 Nov 2022 07:14:06 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n6-20020a170903110600b001865c298588sm9252603plh.258.2022.11.09.07.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 07:14:06 -0800 (PST)
Date:   Wed, 9 Nov 2022 15:14:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, jmattson@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/11] KVM: SVM: replace regs argument of __svm_vcpu_run
 with vcpu_svm
Message-ID: <Y2vDujWx1Zz29VvF@google.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
 <20221109145156.84714-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109145156.84714-3-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, () on function names.  Maybe I should offer to buy you a beer every time you
remember to add parantheses :-)

On Wed, Nov 09, 2022, Paolo Bonzini wrote:
> Since registers are reachable through vcpu_svm, and we will
> need to access more fields of that struct, pass it instead
> of the regs[] array.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
