Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0AC6199AF
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 15:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiKDO03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 10:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiKDOZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 10:25:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD9B31F8D
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 07:23:42 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bp15so7575018lfb.13
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 07:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FjSsE2rirQuGcUR/6pYI8R4bHpVGI9/0jc8c8Ap7X2Q=;
        b=Y8nssBAYhP1SmnFm+LESp/hjU51ywaXJPC1uua2AHBWJl7We4UyWNb5fcLzFQxOoGD
         fD1/lDMWfM09/9YGukz0EFgyKkg4brz7/jEbA48yweBI7TZrxjmmY+RBEoo7vfrMop5R
         Zg0mHr76wZ5qP+oz1FHKWXJi3blobKxco4HZOU2UysEUiLAjUv7+R+VfvblIs0JDdoTb
         ZktRFeNUQxknXXEuT49lxftgVPCZWrhmCbEa5GWeqoMJ8wfYKI7BLMsI2d6UUm1KC609
         zCg9g5NkyttYx7JFs+PJamavQ5qadCmxGoFq3OJXwiamkawuQ1fhF6HrtL0JCENYjN0T
         rzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FjSsE2rirQuGcUR/6pYI8R4bHpVGI9/0jc8c8Ap7X2Q=;
        b=FT+L6BIvNeA0DbBRxmmGT9BtfvLA1FPEorflRkMQfsuyRP6RFp3sR3pjRmEn7EKmT2
         LD8p8AAK7qGTmLprzQW4OHsvu64yxuIiuz7iWFu2L+i+udBmTiPHy2EveMVhrAbW3Mpu
         Rj8pH3JIetfwAHDhUHD0F5afPjFPZyt+MKU1bF/Sho6GASfsdVlA0LkkpijByBfYCDTa
         rTs3/g3cE1ksIUh7P9qU2Kxu7n1bL6PTdkGx00Ni4Lt9pFA7O848Lub/cGgMJoUWOZ2/
         3VF1qoz6STpz+T+WrPnH8O2sZ9FcVUJlHkCjb0ExJhdppeRq84FLu0yPYGjRRgHE+qVp
         0JSQ==
X-Gm-Message-State: ACrzQf0vlin9DVGoF2ZBtpwnSJIICvX4DPOBArM2w6ki75QYhNlRdsJ1
        1j1DsFNOWGcOs9/pKiOplXMTC7eRzq/BXiy9ApzvXcma0tk=
X-Google-Smtp-Source: AMsMyM5iHEbTRx830J7HhoI/9CbY6AYgSyFYmGWkjiFETKMUQ3KQNe4oYmDRe17glTEesm4zSAmyEpPlREZ4jnDnjyc=
X-Received: by 2002:ac2:41c2:0:b0:4b0:e27f:1ef5 with SMTP id
 d2-20020ac241c2000000b004b0e27f1ef5mr8567740lfi.682.1667571821017; Fri, 04
 Nov 2022 07:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221103210421.359837-1-pgonda@google.com> <Y2Q/3A1DSzSJkRAy@google.com>
In-Reply-To: <Y2Q/3A1DSzSJkRAy@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 4 Nov 2022 08:23:29 -0600
Message-ID: <CAMkAt6qHVfpKoi2YYDp4L9CQefU_MAJTdM2P4LoubiS+-64OXQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Only dump VSMA to klog for debugging
To:     Sean Christopherson <seanjc@google.com>
Cc:     jarkko@kernel.org, Harald Hoyer <harald@profian.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Nov 3, 2022 at 4:25 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Nov 03, 2022, Peter Gonda wrote:
> > The KERN_CONT documentation says it defaults back to KERNL_DEFAULT if the
>
> State what actually happens.  Documentation is sometimes wrong, and just saying
> "the docs say XYZ" makes it sound like this is a fix based on code inspection,
> whereas you encountered a real problem.  E.g.
>
>   Explicitly print the VMSA dump at KERN_DEBUG log level, KERN_CONT uses
>   KERNEL_DEFAULT if the previous log line has a newline, i.e. if there's
>   nothing to continuing, and as a result the VMSA gets dumped when it
>   shouldn't.
>
> > previous log line has a newline. So switch from KERN_CONT to
> > print_hex_dump_debug().
>
> Jarkko pointed this out in the original submission, but the buggy patch got queued
> without the fixup.  This is a good opportunity to throw in a link so that it's
> clear that the change is aligned with the original intent.
>
>   Link: https://lore.kernel.org/all/YuPMeWX4uuR1Tz3M@kernel.org

Thanks. I've expanded on the description based on your feedback.

>
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Cc: Harald Hoyer <harald@profian.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: x86@kernel.org
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> >
> > Fixes: 6fac42f127b8 ("KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog")
>
> Fixes: usually goes before everything else, and this should probably Cc stable@
> as well.
>
> With the above tweaks,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Done. Sent a V2 with your review tag.
