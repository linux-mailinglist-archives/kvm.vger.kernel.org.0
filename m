Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424D25A212C
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 08:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245106AbiHZGrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 02:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245145AbiHZGq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 02:46:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1C1D25C4;
        Thu, 25 Aug 2022 23:46:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo7190056pjd.3;
        Thu, 25 Aug 2022 23:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=WmnvVRurxH2Zy86fWf6pyYN4Ha80RUgYK6P1tlQP2/g=;
        b=Nwefa+9WuBFgFgAQdGg0tE6ijaCa2/hmsYfjKjBxOTHUcMWLYHNP8LQn7KrpCCeM1x
         EmFBiYrvovfVSzwpldwWAmZnnJm+mrnRYW/bZvDyZ9Ny7OR6XnB6nLK+bhBHIhhumF44
         ZHHJDnYJbJpa8wY212ebXF1UcO4zaXlEu2mB4pHWdXfqKNtbotLVY+SvMVdLmIkYv+Rx
         WvDPTjGTVc1Cu6w6+ntMdNdxjcaWvCsfUgVMdHuOJaydE3xKUr0e3blaFXKccAvBx8wD
         /9O3eka5Qa+adDogE2BDKFD8epXT2mDExe9d2GecR264lBRne+ZMZuvRNfCNv25jFNCZ
         qNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=WmnvVRurxH2Zy86fWf6pyYN4Ha80RUgYK6P1tlQP2/g=;
        b=e6/io5xSagmZze+cXn2tml5ylvhqtqPq59RQamCdhmkllIBVjWiPOi93qAPBwPCZpz
         8nxv+nHo0iCaxu59oC2a4IAlDxVk+B924FUy1sBGfgWFLqYLNoxzbsjIouZBrysoi4wE
         pFdmApQyHNfs1zzcyoSOP2dOj2NZItFfGMnkBU9VQU0puTc7ck0HdkjU1ArNPoFxvZ1N
         sNO+dSSR1a0PpEJmAj7MyS+X4ACWosd89BeMNwQW+8eDxCuapgynr/4eym0br9tmQwLH
         Y1M8qerTItDaJ92QCQC+Q+NQRGBpnd22jfAmjc1rQZlXSJ3QhntUhkGafiNrOaPF8AEH
         yzSw==
X-Gm-Message-State: ACgBeo3wK/MmlZ5/jkqixPKYmCUZfpf8pcGiysg4NNkP7rmSN+21VZqL
        sZuzP1qynR8qpWCQpVhkFuY=
X-Google-Smtp-Source: AA6agR61OhIkcofx2MFfuNJ7+sdXf0VwtDAAD/RfJrASsh7FidaByoWOrUOri//GsJNftXUSsNpYYg==
X-Received: by 2002:a17:902:7845:b0:16e:d647:a66c with SMTP id e5-20020a170902784500b0016ed647a66cmr2364885pln.64.1661496391012;
        Thu, 25 Aug 2022 23:46:31 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0016ec8286733sm706933pla.243.2022.08.25.23.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 23:46:30 -0700 (PDT)
Date:   Thu, 25 Aug 2022 23:46:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v8 095/103] KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
Message-ID: <20220826064629.GG2538772@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <ce183d47a93012c46472b32077e80dc8b56c88ed.1659854791.git.isaku.yamahata@intel.com>
 <CAAhR5DH2y=MXMSiM0YDn0qj3s3D3SBg6L3_uBP+a8KeC2u2jyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhR5DH2y=MXMSiM0YDn0qj3s3D3SBg6L3_uBP+a8KeC2u2jyQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 03:40:24PM -0700,
Sagi Shahar <sagis@google.com> wrote:

> On Sun, Aug 7, 2022 at 3:03 PM <isaku.yamahata@intel.com> wrote:
> > +static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
> > +{
> > +       u32 index = tdvmcall_a0_read(vcpu);
> > +       u64 data = tdvmcall_a1_read(vcpu);
> > +
> > +       if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ) ||
>                                                                    ^
> This should be KVM_MSR_FILTER_WRITE

Oops. Thanks. I'll fix it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
