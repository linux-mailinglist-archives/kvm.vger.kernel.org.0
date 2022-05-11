Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF8352352E
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244480AbiEKOQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 10:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244482AbiEKOQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 10:16:32 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4B433A0C
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 07:16:27 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id v11so2111269pff.6
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 07:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H9znQm3l58h668UMa1/nGYFyCygWkXj4lFrqzT2Mi3k=;
        b=Q1ftWo7aYKnDcpW/ufHlb5/Zut9TMvrfn+7W02M64xEZOd4PAOw7Tq7np7XZ66YzmO
         AH2mEZ5SGCeLhwRyXUDuu+2q5goKKfYhoOQnvc7HXpyJ4Ccr8urGgYGnoHuosAitn5ae
         luHe653VBQsHxVAnuSS9aiHDHeWlT/lE7OPMLZuNMAuPoDQI3wswfV8Fj4DjXz4Yp7W3
         1r0HkoGg+XzgAZ+faHHikGK5A5FAxBSRF6I94wogQdltHQsP3IQC0e1REy65rR3zMfYF
         GReuB6Tvrxl4Mz4RcOOkW97/cw2ezkrKNf96Yg2ixELwwbYDoWH1AbRaavVCeZbX3Uvq
         uhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H9znQm3l58h668UMa1/nGYFyCygWkXj4lFrqzT2Mi3k=;
        b=SRfNcbMT+QeLE9yMdQ9MZSjvL3/+Oi7qtaP4QnIpd4/oIn7SeE57tW+R2bN4aLY0J3
         x4M66+OiXUce3q+bmNnrlLZudF/b108/Uyc2wYpl7l9WKQwbfJiKf4OjAP1IZbHGNYH6
         1Zd1Y6ncEBMx9pN9UiselRDxXJh4kOjI0xj1O4M3LpFi53/ojGP9SOVoC2bjU9cdCFH8
         RU0FQ/zlvHGNm3KdAqKMbIa1WmW400eaxaokUWkWQSecNSaqEOOPyPS2I8rPTcs7D922
         BTm81OX7tHSjChFkqxaVJCDrJ5cbb7UicsrTi9lnl+01UStVfd332Rd5JhzyB2SExBSF
         YSNw==
X-Gm-Message-State: AOAM532kU1t8GovnVmjRNXj20uLaa4Dk52VQJnm4WJ9maMjIXGsFilFC
        4L8aHWvRmCPnKz4hHyeBSsSClA==
X-Google-Smtp-Source: ABdhPJxVH9/MMEs5gO1ZjtzcvCmkVSQDRzSMrIe56h5ywiO6eNv+HjLvWTpFPbMWsaoifKohpgn/Fw==
X-Received: by 2002:a63:8a43:0:b0:3c2:2b52:848a with SMTP id y64-20020a638a43000000b003c22b52848amr21148777pgd.1.1652278587283;
        Wed, 11 May 2022 07:16:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q16-20020a170902dad000b0015e8d4eb297sm2104870plx.225.2022.05.11.07.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 07:16:26 -0700 (PDT)
Date:   Wed, 11 May 2022 14:16:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
Message-ID: <YnvFN7nT9DzfR8fq@google.com>
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com>
 <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
 <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
 <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com>
 <YnvBMnD6fuh+pAQ6@google.com>
 <CAJGDS+GMxG1gXMS1cW1+sS1V67h65iUpMGwQ=+-MVTE6DTOBjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGDS+GMxG1gXMS1cW1+sS1V67h65iUpMGwQ=+-MVTE6DTOBjg@mail.gmail.com>
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

On Wed, May 11, 2022, Arnabjyoti Kalita wrote:
> Hello Jim and Sean,
> 
> Thank you for your answers.
> 
> If I re-inject the #BP back into the guest, does it automatically take
> care of updating the RIP and continuing execution?

Yes, the guest "automatically" handles the #BP.  What the appropriate handling may
be is up to the guest, i.e. skipping an instruction may or may not be the correct
thing to do.  Injecting the #BP after VM-Exit is simply emulating what would happen
from the guest's perspective if KVM had never intercepted the #BP in the first place.

Note, KVM doesn't have to initiate the injection, you can handle that from userspace
via KVM_SET_VCPU_EVENTS.  But if it's just as easy to hack KVM, that's totally fine
too, so long as userspace doesn't double inject.
