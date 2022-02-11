Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68594B2A7A
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 17:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351559AbiBKQer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 11:34:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242130AbiBKQeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 11:34:46 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D728D66
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:34:45 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso12492759pjg.0
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nnbh1kcsPFrkObOs46hEdsbrlaqoVOUtEvBqKgaq+f4=;
        b=d5ekGY39eMlMbpMvv/K+V1eUuxLZLh3unB3n7ncytffyG3c1xxOj/pnvUaDvLHp2tL
         qq4LwyufFmnekBFCTOqBEYSAxUA2btVoNm4NcMJWppvrT+2DLu8mFLyPAoz2Bku6lqeW
         yip7ROgpgf0Q+h3mdGz8mTAeHlts9S2wE7Ftp+NZsLeZzpognpiS1WYm5IEWnDYpVAJW
         p1XGTbhWJmW9nrKPuWbqdp6oNrd8Qm0OwrPogu8zogjsPH1SL3xuDopFI97uitonJz9e
         GKqRae9DJ/uf/ZbACdhh7jRxtuqm955H07JuDE/rqkcN+WqMZAVeRFL0Ey3MUYpNJAo/
         Ecug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nnbh1kcsPFrkObOs46hEdsbrlaqoVOUtEvBqKgaq+f4=;
        b=Ll/1PfyVhZJtySKWdwqodbqdFFZk/F9clzl/5E6A8Rw0c2DHgiTsY6Kqp6EXxWNVUj
         y2BX+irIFA1o8UyLqV0Mq3eXAM97wovvvgASqoqcvaumyemzLWDCKrBGv+Ckc86DspdE
         LNiXhtc9iaYGcxCqO58d1/kNtcoAKOY4acOGTYigFOIqNSddtc2DpRmq3GpVnjU3wHZl
         O9CmddLTnAKT0UKkpgezgdhSobQWtePjkIN81ouyhGPvTey5rlt0i4CxQSyXbOErFQt2
         8X7jhH6a++8UOruiHxS2dhS9OyxoEMec29eWlc9MHgiUKPUm6H2hqP2BvgT9qvX+5O/w
         FjZw==
X-Gm-Message-State: AOAM5311ctl8X74nU+EiByFC1JSH7TbZnwYpy2Nfr30w8+ZjRFvruB8T
        7Cox4wtpdzwvIh1t3sXbkjd8ug==
X-Google-Smtp-Source: ABdhPJx+osARJx/twyvZl7y4qsl5OM6D7RX8kmclkHHmc/IvYT0ruVeU/6sp/h17pjZsGWSbBXpqbg==
X-Received: by 2002:a17:90a:ea85:: with SMTP id h5mr1201105pjz.13.1644597284563;
        Fri, 11 Feb 2022 08:34:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id md9sm5690196pjb.6.2022.02.11.08.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:34:43 -0800 (PST)
Date:   Fri, 11 Feb 2022 16:34:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 07/49] KVM: x86: replace bitmap_weight with bitmap_empty
 where appropriate
Message-ID: <YgaQIJfgJhe4LY9H@google.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
 <20220210224933.379149-8-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210224933.379149-8-yury.norov@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022, Yury Norov wrote:
> In some places kvm/hyperv.c code calls bitmap_weight() to check if any bit
> of a given bitmap is set. It's better to use bitmap_empty() in that case
> because bitmap_empty() stops traversing the bitmap as soon as it finds
> first set bit, while bitmap_weight() counts all bits unconditionally.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
