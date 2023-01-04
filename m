Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE6965D6BB
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 16:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbjADPAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 10:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjADPAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 10:00:21 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6601EEC1
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 07:00:21 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j8-20020a17090a3e0800b00225fdd5007fso24925520pjc.2
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 07:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VWdAqOaf2J8kFGx5GmjkkSMfxAT7jnHGKS/Wkn2kL/s=;
        b=op4MZAZxo4ZY6ToBUU9OY+2VFCFdMNDuPbS5g6e6iFNJVj55Nm2g4H7Wx4+jgwteJp
         dybTJfGd8OgfQri0wKDJHFbwGRDMBs08g0PhtdRvZHrXVtFzLmsHVuAPpGbljEP6z2Zs
         Q4jcfEVqVTZtLfvBV4YS4IFua0N/JDlWRl60JPnsGaCCA1TW5seQJr658UX/DtRNF2lm
         yGMjNZCIGXNI8+2hYlqbf7joznvOLsJElkhyA2x/31OXvazuA//sY4Qc7pw2+L3XSxP0
         oDklw1d3wjD59bVumzdLVdBRtjcCbUAY4ebPJPLauUMnAvAi6iTuZhMWw44D5/Ih4rQn
         NtKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWdAqOaf2J8kFGx5GmjkkSMfxAT7jnHGKS/Wkn2kL/s=;
        b=gycDN9nyG1cIl7dI4Jl7naojvY2xknNaUJ4nbvFFNuMkKticXUU1GH09rDzQPXJQB5
         yBct/iPKNEop63m0pPrDUC+YemDlJlb4RpKhRZuNupBLtEPhe/jGBMpgtxG808dqjUdz
         66LqxYt/kVGCeV+pa5elhOLb4KmrcLO8JpOSXhUrYw2aWOzPpafV3IfRz8yWDJRvEAHh
         sbpo6SISu+R58AWcyBnPby58g98D/QeVccUFj8y4s/2fmt8j6c6XiOEoPMOs6wOpmu6G
         oByjwccR7BhCZ/7trnTDeOcu1WIfh3UwfMBQt7PnlhHnZtPWl/q4c/bFIks//6NUK/gN
         1iPQ==
X-Gm-Message-State: AFqh2kqeR7C8rKLY2H+bqakz733iUj6OdGV3YsHt1sPb7YKsfP3SsFvm
        SZQeSL5Sr+dm+lbvfgMV1c3oyA==
X-Google-Smtp-Source: AMrXdXsPEgKMMjHmRgdojrhDbnkbsf0Sv08U/01xCaCtH2N0xfl3A/C8fCoSWZ8rOZ89tu/o5+UPlw==
X-Received: by 2002:a05:6a20:5488:b0:a3:d7b0:aeef with SMTP id i8-20020a056a20548800b000a3d7b0aeefmr5551738pzk.0.1672844420743;
        Wed, 04 Jan 2023 07:00:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 64-20020a620543000000b0056bd1bf4243sm22704544pff.53.2023.01.04.07.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 07:00:20 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:00:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Oliver Upton <oliver.upton@linux.dev>,
        Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [PATCH 1/1] KVM: selftests: kvm_vm_elf_load() and elfhdr_get()
 should close fd
Message-ID: <Y7WUgI4muVCn8glt@google.com>
References: <20221220170921.2499209-1-reijiw@google.com>
 <20221220170921.2499209-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220170921.2499209-2-reijiw@google.com>
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

On Tue, Dec 20, 2022, Reiji Watanabe wrote:
> kvm_vm_elf_load() and elfhdr_get() open one file each, but they
> never close the opened file descriptor.  If a test repeatedly
> creates and destroys a VM with __vm_create(), which
> (directly or indirectly) calls those two functions, the test
> might end up getting a open failure with EMFILE.
> Fix those two functions to close the file descriptor.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
