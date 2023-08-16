Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0702677ECF8
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 00:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbjHPWRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 18:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346906AbjHPWRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 18:17:01 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB735270D
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:16:30 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58cb845f2f2so13263977b3.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692224186; x=1692828986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dQPG8Efy+rsq8wzo6XfJjIjptk0+/tc6IFY7Rg+eSxM=;
        b=PX1Z9kgj4/WatQvt+2+WOV04Apzf72VTZ7TMj9f8FPUrMGSCMgByo3Df6hfwfo9lxB
         sTyOu58X/u6q7VGUnQfpq8Z9H2DTKYefNcdCKv8OrpSf6ihgAhEt31lnau4W8HxEO9oY
         A9oQL5DYMTkLT/7x5qpCt2TrHSY9IXSaKhFsnzju1IR4fdVE+HGu+Jg7RcA0r22tn2mB
         VXe9MtxfaT4toZh/IO83e7Bp093VBrSWNSQscb19MtJqsR3o3vGrEwbs5jgRCyAmLvd9
         fPUKTPhliYX9+D4KPYtxnGIcRJsR/hxcc6da3I/OQTEU/zj7eJm36EH3bbMEDgY/CI+R
         nTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692224186; x=1692828986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQPG8Efy+rsq8wzo6XfJjIjptk0+/tc6IFY7Rg+eSxM=;
        b=kLKaxH3qvNpxCjRCKu2huB8qniVx3w9l4uT1QUjoDa8Ya5TndQHKIP3IQYLhNGPvnK
         Gl7ruV05HPN3u7S336F7C98HuZFsJ7X7Gn9+dOMqi4SQqDjD2NEQAjME7ETPJQ0NbsO1
         eqW/AMsBBbTXOY7YzKsTlumVsvcTtLSxlUHH401gxVeTJeDEyFlGmmpjcNtDBybSlZs7
         2KwZShWbCosKlUHV0WgRereqpQSS+b31llU/82Im17HYjV3FF8BzAyMpAY6RsiSpd3N2
         ScbuIbb/WXmBwh9N+DaB0NFarWorfeNpI+fpdtvy5yxA3WXeCL5uCoY4g/zl1aMhRt4a
         +W6g==
X-Gm-Message-State: AOJu0Yzxvk+T1ln0TVPHHildCVBi0isENCnJ/7lGLXxeKu1uwVcrLMXt
        6uk7N/OWZBPMwAsJdkDNtPC3cisBIuY=
X-Google-Smtp-Source: AGHT+IGt2t67uE18q/XroCh6BBcIXFfgpJ9GwLzkJwAO1GCxQ0tIL9AYPYeSVxDGXYagq2tb5okE4jPYguY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b245:0:b0:589:a935:b13 with SMTP id
 q66-20020a81b245000000b00589a9350b13mr53615ywh.5.1692224186272; Wed, 16 Aug
 2023 15:16:26 -0700 (PDT)
Date:   Wed, 16 Aug 2023 15:16:24 -0700
In-Reply-To: <20230601142309.6307-3-guang.zeng@intel.com>
Mime-Version: 1.0
References: <20230601142309.6307-1-guang.zeng@intel.com> <20230601142309.6307-3-guang.zeng@intel.com>
Message-ID: <ZN1KuB3ZdD/E1tae@google.com>
Subject: Re: [PATCH v1 2/6] KVM: x86: Virtualize CR4.LASS
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Belatedly, same complaints as the LAM series[*], this patch doesn't actually
virtual LASS.  Just squash this with the previous patch, "KVM: VMX: Implement and
apply vmx_is_lass_violation() for LASS protection", though I would keep the
shortlog from this patch.

[*] https://lore.kernel.org/all/ZN1CjTQ0zWiOxk6j@google.com

On Thu, Jun 01, 2023, Zeng Guang wrote:
> Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
> as CR4.LASS generally set once for each vCPU at boot time and won't be
> toggled at runtime. Besides, only if VM has LASS capability enumerated with
> CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
> to set CR4.LASS.
> 
> Updating cr4_fixed1 to set CR4.LASS bit in the emulated IA32_VMX_CR4_FIXED1
> MSR for guests and allow guests to enable LASS in nested VMX operaion as well.
> 
> Notes: Setting CR4.LASS to 1 enable LASS in IA-32e mode. It doesn't take
> effect in legacy mode even if CR4.LASS is set.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
