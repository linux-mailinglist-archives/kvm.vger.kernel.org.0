Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6C8770B1B
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 23:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjHDViI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 17:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjHDViH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 17:38:07 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D46AC
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 14:38:06 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbbc4ae328so20050515ad.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 14:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691185086; x=1691789886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9zaXJKmcj+MwCrZ8Trkm9EFDo0x/bUBjbe64OrU0o0E=;
        b=X6kn5AgZtYo94YUVeDf2+BOWljOG+XKtCYClw5OZnE6uoDzKhPvXX0M7r0Vv9WP546
         CvNWqAwD7gr+FXeRR14zI2JOfXcmh+l8nDjxc4/iGxtAsBPpOM9cS//pz9YV8UVxY6sC
         YPSUbwkOrVgGuH2sRkOmTh1NlztGxoZ9cqHjq4DL9p9ydU2odLeCoU2s3w2G3VYvhG1Q
         28uI/kshRQw3nQWWYcjgEbtlwpTQRSwVQWcDD7QXKI0+krPX2Kn8D013iMAASy//82e2
         BnYeawn+smwXRZIQN8V9cBE2k+D1iWGQJIrT3BUgK8qp2biJFbgM5Mm7ML4zGOg8ENfq
         vmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691185086; x=1691789886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9zaXJKmcj+MwCrZ8Trkm9EFDo0x/bUBjbe64OrU0o0E=;
        b=ZGChSt1Gcdu9uET4TM0kXaTel92UFG6qe7aMx9mgJhfNWZCOuzFi2vUPShy0UaYFb0
         HfaaEnKXjGxHmmahNaM6wnrUaLmDZ5+T7dXcGpjcXLTSg4I9PZL5iNKO0+ZUGU5MeeJU
         jldyfQKpKknrPIIxluJ62kIt11jE/RjCYDWGlNduYbAjG/SYPpenhVD3/mJMbnp4qkEH
         FIKQX46nwdVi7QzCL7mAiaEghuQvUxlZY/OMhcV6mKlRhQvC78cpjWtuKAOFL8zXuvDH
         YSkcrsZ12W6xK6sSx48N4IOg6SxmQbKEPZuIg55YB8SwSyYSw3gutrw9/Kpt1kAU8dAW
         YwoA==
X-Gm-Message-State: AOJu0Ywj8h0BOwFaBnqk9+yWbhItVNTdJoXLk3byfH8HQz49gktt+vY3
        nVW3J2d81szHGCaUD2dSgRDIiedFCAk=
X-Google-Smtp-Source: AGHT+IGGk2IDJa6Z8Ep+FOLngbthi5gSNKGWUlaniY88MHg2phf1p6AxKIWHuuumkT7wFldITMHPqtyhGDg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e844:b0:1bb:91c9:d334 with SMTP id
 t4-20020a170902e84400b001bb91c9d334mr10999plg.0.1691185085970; Fri, 04 Aug
 2023 14:38:05 -0700 (PDT)
Date:   Fri, 4 Aug 2023 14:38:04 -0700
In-Reply-To: <20230803042732.88515-19-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com> <20230803042732.88515-19-weijiang.yang@intel.com>
Message-ID: <ZM1vvHXCOtbHVX8z@google.com>
Subject: Re: [PATCH v5 18/19] KVM:nVMX: Refine error code injection to nested VM
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is not "refinement", this is full on supporting a new nVMX feature.  Please
phrase the shortlog accordingly, e.g. something like this (it's not very good,
but it's a start).

  KVM: nVMX: Add support for exposing "No PM H/W error code checks" to L1

Regarding shortlog, please update all of them in this series to put a space after
the colon, i.e. "KVM: VMX:" and "KVM: x86:", not "KVM:x86:".

>  static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 96952263b029..1884628294e4 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -284,6 +284,13 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
>  	       __kvm_is_valid_cr4(vcpu, val);
>  }
>  
> +static inline bool nested_cpu_has_no_hw_errcode(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	return vmx->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE;

The "CC" part of my suggestion is critical to this being sane.  As is, this reads
"nested CPU has no hardware error code", which is not even remotely close to the
truth.

static inline bool nested_cpu_has_no_hw_errcode_cc(struct kvm_vcpu *vcpu)
{
	return to_vmx(vcpu)->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
}

[*] https://lore.kernel.org/all/ZJ7vyBw1nbTBOfuf@google.com
