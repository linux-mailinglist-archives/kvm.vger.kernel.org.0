Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313E976A043
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 20:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjGaSXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjGaSW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 14:22:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1F3E49
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:22:57 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fe0eb0ca75so7692439e87.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690827775; x=1691432575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6BmQQ8xDHQ3qzVuwILJuAltF2TxUquAINpFxWwuR3w=;
        b=RTUp1GcE9TWV1qTvNE1C02wFkvp/rEJhtk+51nISvyjgPTusv53crdnWdpbT2WDNpC
         9czQGReCauWeNFu8mJtHkId8ASDjhvZWALHZh+SyhEMqoUTqhxssydzxa6uZBKj0qYrD
         vcyzEEjHdxO76TNZyKc9O24YAUeb5rdAfQi7xglRc7Oz8U/VK20seE+TqLxPiIUEF2AF
         p2ypuV+xtoforGGsa/Lt/KyL8w4KTS3XdMdpYfXyMrVCX/d56Us0p1xCWIGjqH506lyL
         NZbaDWWhUfPFLWX9TmHQaEyEA1UmGoVZusjLFfEFIf7D4qJ0RegD+CSe3GcPeA3rkzoJ
         xi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690827775; x=1691432575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q6BmQQ8xDHQ3qzVuwILJuAltF2TxUquAINpFxWwuR3w=;
        b=XCfO4QnrtSWrZXNXAYI3+yzh5zKLX5VzVN7gbBooHa4cQ6Gw6DAEyI72cfyJ8Zu0P3
         I+I4QyX0yZ5fJxXdfIOt0wz8gCFKUVT6O2z5Ge0GAMr1QmRKei4ftPDG6JgJBI6Glr4k
         T8SkAXFWl0jEmiQzvqM6siyaTGwHpDwgGnq/twan2tVlcVEtKyIKWdLcVWHZBsZNVFaQ
         Fl+pHLi6yVIpMf28yvfcSXO/a3APcTw51OWfXwdhCSyvEC1NQmCJbJ8AR7x53PUxnS3o
         LD9+pnHEPa3m8YumRovOzVBDkWmlcMWLNiWq0SLjAywXicaWRr/v0CLxlQJXinVc3Wfl
         Pxrg==
X-Gm-Message-State: ABy/qLaRJCPnEMwkzPfLHzxuJ/W/0Zn6HVsodaZ0jCCfXf4Bw5yKZ2Aw
        KRs98u/0+8xG0eu2WM9g+a/L3rzSxjHyWQJr+xE=
X-Google-Smtp-Source: APBJJlE51QtfiG+1ENPBZcz/MTN10/l7Xyhmr/3dD4Lp00ivZz+NffJEl0iYsoUxrdAsUIsDuqY10A==
X-Received: by 2002:ac2:5e34:0:b0:4fe:3e89:fcb1 with SMTP id o20-20020ac25e34000000b004fe3e89fcb1mr383296lfg.68.1690827775288;
        Mon, 31 Jul 2023 11:22:55 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id u7-20020a170906408700b0098de7d28c34sm6476150ejj.193.2023.07.31.11.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 11:22:54 -0700 (PDT)
Date:   Mon, 31 Jul 2023 20:22:54 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v4 09/34] KVM: selftests: Add a selftest for guest prints
 and formatted asserts
Message-ID: <20230731-4335e61b2b2688a925025a9c@orel>
References: <20230729003643.1053367-1-seanjc@google.com>
 <20230729003643.1053367-10-seanjc@google.com>
 <20230731-91b64a6b787ba7e23b285785@orel>
 <ZMfpgu8bHH0jA8Si@google.com>
 <ZMftM3qz/VqalbPg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMftM3qz/VqalbPg@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 10:19:47AM -0700, Sean Christopherson wrote:
> On Mon, Jul 31, 2023, Sean Christopherson wrote:
> > On Mon, Jul 31, 2023, Andrew Jones wrote:
> > > diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> > > index 4cf69fa8bfba..4adf526dc378 100644
> > > --- a/tools/testing/selftests/kvm/include/ucall_common.h
> > > +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> > > @@ -6,8 +6,19 @@
> > >   */
> > >  #ifndef SELFTEST_KVM_UCALL_COMMON_H
> > >  #define SELFTEST_KVM_UCALL_COMMON_H
> > > +#include <linux/kvm.h>
> > >  #include "test_util.h"
> > >  
> > > +#if defined(__aarch64__)
> > > +#define UCALL_EXIT_REASON      KVM_EXIT_MMIO
> > > +#elif defined(__x86_64__)
> > > +#define UCALL_EXIT_REASON      KVM_EXIT_IO
> > > +#elif defined(__s390x__)
> > > +#define UCALL_EXIT_REASON      KVM_EXIT_S390_SIEIC
> > > +#elif defined(__riscv)
> > > +#define UCALL_EXIT_REASON      KVM_EXIT_RISCV_SBI
> > > +#endif
> > > +
> > >  /* Common ucalls */
> > >  enum {
> > >         UCALL_NONE,
> > > 
> > > and then compiled the test for riscv and it passed. I also ran all other
> > > riscv tests successfully.
> > 
> > Can I have your SoB for the ucall_common.h patch?  I'll write a changelog and fold
> > in a separate prep patch for that change.
> 
> On second thought, I take that back.  I think it makes more sense to add a ucall.h
> for each arch and #define the exit type there.  All then move all of the
> ucall_arch_do_ucall() implementations to ucall.h (except maybe x86 while it has
> the horrific save/restore GPRs hack...).  That way the #define is colocated with
> the code that generates the exit reason.

Yup, feel free to just take the above as inspiration and create a
different patch. If you decide you want an s-o-b for the above, though,
then here's one

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
