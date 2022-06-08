Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD2A542329
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242951AbiFHDDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 23:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243883AbiFHDAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 23:00:13 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F8E1F4FEA
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 17:29:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id e24so17159863pjt.0
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 17:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mYgGsy34+GhGM7pdMGfpARvQd5PGAcTP7M1pLkZ3n0Q=;
        b=G4e3xzjU94Fdu/P6jLsglG9MfMd29F+E2gRGiU/qlHt8JnRKZ5hEgAhx0/z4pnd5cL
         w5if0VJQCC+MPegl6D/elfj2u6VIzEyPT+YANRSpBDS+5ypmfS+kQ/KWjzISTp94Nwov
         Z8sSRgM1TzeW2PCgiezYag9bFs1U6JKqD+GN6+wdikfXOLbFGA07mgKi/WtfeXkGJpik
         t894dJ0xgmKjZDwD8TET8aYZt0kDYt33OmI9aEbiv5f73AZymzEJZrK4exdvSQr3BnNS
         b7Tql8YnpEQgHbVLtZYi58uq/P1xzr+8uy0uH0I1DLE+EnEw51uPKEke7ZlCAfuHRGbA
         NhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mYgGsy34+GhGM7pdMGfpARvQd5PGAcTP7M1pLkZ3n0Q=;
        b=jA4W72H8FA/hyHHwQ52+qfSxzlo5CXLjiIX3NHh2/ctRVF+9QK6Vd6/wmAjCnMhiG6
         5Yzc2YLnksPlN9uBWoJtKYsRQtlec5snhmWrmiIRVALC1A+aYhikdbz26jVyZeaoGbSa
         i3UW8IFllJvtLOZiDfxyz1nGlYVD45jgpiG7DxIydFTA25Sh/7aCoROP7V/Ed4IB4wRo
         2RdapVE8QpzFE3akkA3j5JAQZuCjaSfn13Rkcv7U6vXRl9e+Ejth8cbd2ULaSy/yjt9R
         0oXYNM9vEP/3ejSQAz5L4kGMTX5omLS0kBEbVcmbgk+69/7G0FPTyJ2gDaMWilJY1QMB
         Tpqw==
X-Gm-Message-State: AOAM5304FuAeadrgqJ2y8J6Elv6L5EaPl7F/q/xaVyoCPmY7g0UIuaeR
        QgCZWzcDd0lmURq9ztRtE9iOgHWaQJFXDA==
X-Google-Smtp-Source: ABdhPJz5WEkY5NqvKutF00y/oV8CTyDQ1bEkAFD5sJg1BI0cYIx96wtvZpQSViXxo9UogaX8C+2u3A==
X-Received: by 2002:a17:90b:682:b0:1e3:142:a562 with SMTP id m2-20020a17090b068200b001e30142a562mr50504302pjz.91.1654648045289;
        Tue, 07 Jun 2022 17:27:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h15-20020a170902680f00b001641b2d61d4sm12999997plk.30.2022.06.07.17.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 17:27:24 -0700 (PDT)
Date:   Wed, 8 Jun 2022 00:27:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "anup@brainfault.org" <anup@brainfault.org>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <Yp/s6aEHqNiys7Jf@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
 <Yp+0qQqpokj7RSKL@google.com>
 <Yp/Z7KE5C/QVpAeF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp/Z7KE5C/QVpAeF@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 07, 2022, Sean Christopherson wrote:
> On Tue, Jun 07, 2022, Sean Christopherson wrote:
> > +Raghu
> > 
> > On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > > Marc, Christian, Anup, can you please give this a go?
> > 
> > Raghu is going to run on arm64, I'll work with him to iron out any bugs (I should
> > have done this before posting).  I.e. Marc is mostly off the hook unless there's
> > tests we can't run.
> 
> arm64 is quite broken, the only tests that pass are those that don't actually
> enter the guest.  Common tests, e.g. rseq and memslots tests, fail with the same
> signature, so presumably I botched something in lib/aarch64, but I haven't been
> able to find anything via inspection.
> 
> Raghu is bisecting...

Ha!  Looks like it's an issue with running upstream selftest using one of our many
internal framework things.  Running a few of the tests manually works.  We should
have full results tomorrow.

I did find one bug during my inspection, in case someone gets ambitious and wants
to run tests too :-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 0de9b0686498..b5f28d21a947 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -55,7 +55,7 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
        if (gic_fd < 0)
                return gic_fd;

-       kvm_device_attr_get(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0, &nr_irqs);
+       kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0, &nr_irqs);

        kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
                            KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
