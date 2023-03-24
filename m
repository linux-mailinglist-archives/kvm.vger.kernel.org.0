Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A981D6C7A34
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 09:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjCXIsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 04:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjCXIsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 04:48:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD25C6A44;
        Fri, 24 Mar 2023 01:48:07 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i13so1236232lfe.9;
        Fri, 24 Mar 2023 01:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679647686; x=1682239686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CugmSPVEAZOl/CDM7KlMPccXmc+KAo4sr0tOOU2lzo=;
        b=DzE9VR66YJCpiAMR2ue8DQQZU/WpMFWbYvqlSkzQE2/auGrisKzwzVvwCBHfmHGjat
         q9RLyui9fhtGIq+qWQvCQdmwDVOW1iK0T7aJtEdyzLoQDDhU49UwKa4+T0wqHpcMMloj
         BhLiDUwKenTq8OyYrJsr6irE64Y5MCnljKU6b3vN8SmZJE1MjdQcUUmESbl+XtRDt4tj
         jBqmMvrYxyhvwFq/hzPMCcE99md0r+lFkGSVO5MQmQBDXCMsMcUubIPuhsNekrLubHRT
         +ajV2bqYZ555AbHHaxEgkxYWhmXe+EfQrRublF/9RRNEudyqXilrkaPsRWBae3ozarhP
         cVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679647686; x=1682239686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+CugmSPVEAZOl/CDM7KlMPccXmc+KAo4sr0tOOU2lzo=;
        b=bLvGzD22WD0k3AUXj6mzlGWu9XdYgdTX1yUUmn6xvDOOpxY9mQYQd49cWq3oKKFp83
         7S6Gh9nNM/JZ+gBsi25CM0OJa6lQPgmSK681/4FbUpgrQgYC2r17BhEd5clLC/5RBTkz
         mYI3RRcIgR3wDr821DjONskTtwe94Kffu2kwuQZ2pBEcOEywU6MOMoVfhiH3P3vLd3T8
         slQ0xGlL/yxgRmM4fOilJwWwrEj8+Wcl38U2BJBouQf5lWNUUZmuTZdDQGeg7Qf2uaK1
         WyaCfPnvLewoHUVOsorTHsAI8kfmvExJysVrY4hicfGnmRX4loYTj6vn/xpDEge1IdA8
         eClA==
X-Gm-Message-State: AAQBX9cmzJC15jS4aK3ETljH4L4N1soUYH0j3rv4lcrkH82bzcEeT90C
        T348zFqto16QCvj98++RWvs=
X-Google-Smtp-Source: AKy350YOkO6htfPjqLXF4hqhI4/3CLaSuQiI48ioIvGg6kkEEsMUurmu24YQrCVANbaWmKSxA4Ze5w==
X-Received: by 2002:ac2:5fe6:0:b0:4db:3467:f2ff with SMTP id s6-20020ac25fe6000000b004db3467f2ffmr342159lfg.5.1679647685831;
        Fri, 24 Mar 2023 01:48:05 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id g6-20020a19ee06000000b004e9b183fc5bsm2379251lfb.8.2023.03.24.01.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 01:48:05 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:48:03 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 5/6] KVM: x86: Virtualize FLUSH_L1D and passthrough
 MSR_IA32_FLUSH_CMD
Message-ID: <20230324104803.000036e9.zhi.wang.linux@gmail.com>
In-Reply-To: <ZBzQDv9gIHIhOP8Y@google.com>
References: <20230322011440.2195485-1-seanjc@google.com>
        <20230322011440.2195485-6-seanjc@google.com>
        <20230323050753.rufixzrzt2sf3avv@desk>
        <ZBzQDv9gIHIhOP8Y@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Mar 2023 15:17:50 -0700
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Mar 22, 2023, Pawan Gupta wrote:
> > On Tue, Mar 21, 2023 at 06:14:39PM -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 85bb535fc321..b32edaf5a74b 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -95,6 +95,7 @@ static const struct svm_direct_access_msrs {
> > >  #endif
> > >  	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
> > >  	{ .index = MSR_IA32_PRED_CMD,			.always = false },
> > > +	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
> > >  	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
> > >  	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
> > >  	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
> > > @@ -4140,6 +4141,10 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0,
> > >  				     !!guest_has_pred_cmd_msr(vcpu));
> > >  
> > > +	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
> > 
> > Just curious, will this ever be true on AMD hardware? AFAIK,
> > X86_FEATURE_FLUSH_L1D is Intel-defined CPU feature.
> 
> Don't know myself, but I assume/home there was actual motivation behind adding
> support for AMD.

Hmm. I took a look on the APM[1] published on Jan 2023, 3.2.9 Speculation
control MSRs. It only has SPEC_CTL/PRED_SMD so far. Also, the information
here [2] shows this is a mitigation only for Intel CPUs. Looks like AMD
does not require this so far.

[1] https://www.amd.com/system/files/TechDocs/40332.pdf
[2] https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html
