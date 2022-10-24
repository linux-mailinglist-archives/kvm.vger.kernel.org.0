Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F20160B142
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 18:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiJXQR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 12:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbiJXQPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 12:15:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A952A98E8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 08:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666623732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ba4Qg30t9AsqrIhOitPyNyPwxW9XItjD3vaGeWLN5+0=;
        b=TPFsG+HSLkXzyhcZ1FgWvH/rYL7FdxhXY05XIhSKY/kLYzl2m2Pp0GRYg500yYLsVRbr8+
        b9U8uDgPDWxZPs/5rdhmPG/VQXS3a78c+MiDZ4vC2+Bc8+i5FmsM2Hh5S+ma/h0YdtIcPU
        Tg2/NqlVo+jqIOdz4PA1Te/b1anhHL4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-272-WHW-qxtINZGoVuLWJUM6aA-1; Mon, 24 Oct 2022 08:40:11 -0400
X-MC-Unique: WHW-qxtINZGoVuLWJUM6aA-1
Received: by mail-qt1-f197.google.com with SMTP id n11-20020ac8674b000000b0039c9e248175so7002012qtp.14
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ba4Qg30t9AsqrIhOitPyNyPwxW9XItjD3vaGeWLN5+0=;
        b=vxyckvYZvIdNGlXFz23vDwriuwrhh90hr4oSjv45VvYN2Kv0h+jx78QONwXA3mjp04
         QUJ7LJoaC4QBGNptG2YVQiMxgS97EdGuxsUouFFT4xmwspG9MPOTF4JG94kK1vQVPEN1
         iHNYcJRijQU63h1zfbdA/r+akmGSEtJcp5FhwwOYvFUDVya3HPt5x6YghE29gIuVVT7n
         v2QLISQdP7kAGK/i+Iv/hyRIq46UJO2n/C15irjyYeM8dXo3REW5p5Lgw8ez+A3dHTnD
         /SmL0FATxKQyBHR96CuOHiA/E3RqUr/Q8WvqIcyAA9YgX9qdeTG+LWMbOtZJ643OXIRp
         nO/A==
X-Gm-Message-State: ACrzQf1iM9Eli/CED4bqhlfrsdfgU24v4boSOmrg8ti2X1LRvrywucpS
        5y/Eg1lNltfkVBR7HXapISV2xSCi3uJeJsMA3H1SgYrNNx4cj2HkdEl3QuSvKb0LWyBWMYkEjOJ
        Lc5Q5GTmcwLIL
X-Received: by 2002:a05:622a:164a:b0:39c:fac2:fee5 with SMTP id y10-20020a05622a164a00b0039cfac2fee5mr23631611qtj.447.1666615210251;
        Mon, 24 Oct 2022 05:40:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5niOv2+5XofBPMe4wK6cEIskRP9PaeKbZ/2keblgXDQPbVWpy0GHMSa/7fYmG+Deybym99Ew==
X-Received: by 2002:a05:622a:164a:b0:39c:fac2:fee5 with SMTP id y10-20020a05622a164a00b0039cfac2fee5mr23631600qtj.447.1666615210029;
        Mon, 24 Oct 2022 05:40:10 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id d11-20020ac85d8b000000b003986fc4d9fdsm13169671qtx.49.2022.10.24.05.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:40:09 -0700 (PDT)
Message-ID: <9d7a1e809a19709a3785847c7b79d5bb45dc23e8.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 11/16] svm: add svm_suported
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:40:07 +0300
In-Reply-To: <Y1GRwf071rJDqVbh@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-12-mlevitsk@redhat.com>
         <Y1GRwf071rJDqVbh@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 18:21 +0000, Sean Christopherson wrote:
> s/suported/supported
> 
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> 
> Please provide a changelog.
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  lib/x86/svm_lib.h | 5 +++++
> >  x86/svm.c         | 2 +-
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> > index 04910281..2d13b066 100644
> > --- a/lib/x86/svm_lib.h
> > +++ b/lib/x86/svm_lib.h
> > @@ -4,6 +4,11 @@
> >  #include <x86/svm.h>
> >  #include "processor.h"
> >  
> > +static inline bool svm_supported(void)
> > +{
> > +       return this_cpu_has(X86_FEATURE_SVM);
> 
> Why add a wrapper?  The only reason NPT and a few others have wrappers is to
> play nice with svm_test's "bool (*supported)(void)" hook.

For consistency with other code. The other way around as you suggest is also reasonable.

> 
> I would rather go the opposite direction and get rid of the wrappers, which IMO
> only make it harder to understand what is being checked.



> 
> E.g. add a required_feature to the tests and use that for all X86_FEATURE_*
> checks instead of adding wrappers.  And unless there's a supported helper I'm not
> seeing, the .supported hook can go away entirely by adding a dedicated "smp_required"
> flag.

I rather not add the .required_feature, since tests might want to test for more that one feature.
It rather better (and more visible to user) to have the test itself check for all features
it need at the start of it).

So I rather would remove the .supported() at all.

Best regards,
	Maxim Levitsky

> 
> We'd probaby want helper macros for SMP vs. non-SMP, e.g.
> 
> #define SVM_V1_TEST(name, feature, ...)
>         { #name, feature, false, ... }
> #define SVM_SMP_V1_TEST(name, feature, ...)
>         { #name, feature, true, ... }
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 7aa3ebd2..2a412c27 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -170,6 +170,7 @@ test_wanted(const char *name, char *filters[], int filter_count)
>  
>  int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
>  {
> +       bool smp_supported = cpu_count() > 1;
>         int i = 0;
>  
>         ac--;
> @@ -187,7 +188,10 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
>         for (; svm_tests[i].name != NULL; i++) {
>                 if (!test_wanted(svm_tests[i].name, av, ac))
>                         continue;
> -               if (svm_tests[i].supported && !svm_tests[i].supported())
> +               if (svm_tests[i].required_feature &&
> +                   !this_cpu_has(svm_tests[i].required_feature))
> +                       continue;
> +               if (svm_tests[i].smp_required && !smp_supported)
>                         continue;
>                 if (svm_tests[i].v2 == NULL) {
>                         if (svm_tests[i].on_vcpu) {
> diff --git a/x86/svm.h b/x86/svm.h
> index 0c40a086..632287ca 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -9,7 +9,8 @@
>  
>  struct svm_test {
>         const char *name;
> -       bool (*supported)(void);
> +       u64 required_feature;
> +       bool smp_required;
>         void (*prepare)(struct svm_test *test);
>         void (*prepare_gif_clear)(struct svm_test *test);
>         void (*guest_func)(struct svm_test *test);
> 


