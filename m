Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FBA502C61
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354865AbiDOPNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354858AbiDOPNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:13:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C42C8BE0E
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 08:11:13 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id be5so7295935plb.13
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 08:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XpMI5o1rh+ASC743fTR6XcDs+QqXkiVRQcevUp4zbQE=;
        b=Pw9QlbYBEdNuOSpCDdRCElWVqIH9UdeidruHkQv62YDy+yRw3YBIONulcDGLIEJDVs
         Ch5Sistmn0s2JtIVfPTuBi3h6qeth8GDo4+SJ4aeyfMGqK5tfI8yc6OxhJyAaoqckGeQ
         elSD03uyypngyXnD1dfEsXnJKNRco3mTL8g0+DF6/E2U4YbF8K1WWzhgTBmXEVbPXLko
         6K5d6cS+ntxAuA05y9t19IyFMDcGX4jdQPKlCn+/ig8uCGzjOCQYtT16klslidzGHn0V
         V0D+gY2DMs3uoK0fGvmYmPn3b/CI4GfmOAq3jNaALPweh9hTmVKPIR/gh8CrJV1o2C11
         sggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XpMI5o1rh+ASC743fTR6XcDs+QqXkiVRQcevUp4zbQE=;
        b=sQXUDtdHDfT7ZjVW3txZWUi8Iu2pmfZSP9HDW2gohH4YcCA34nT/yGnQ2kfkoQL6Xq
         EonqB9cR411koAxF8Ycb67OLgcF3S/hNvtlOA2SNbG/i5OWZtDXUF0FLLTUm632Irvg0
         2yJn1m8RHzqJORvxIHakpKt1FpmMv9HdPemTWYS42BVPijsqWoHHHVTQHXaic8ybwxaR
         oNu4Z83Ya9LsK0nHzuoYx/Cm1/CyH2blhvHwB1RC/wLeXTEuphIN0xMaAkAU2+GPI+Py
         x/7rRuFnDQOUWsODivoilHTNNlaG/8Jx1W+rUdaE4UtBv69FQXrWyD8ByurjdT/gEslz
         Swqg==
X-Gm-Message-State: AOAM530htCM/3clf/3v3pc07GxS+tLYIgfCqJCXEa8GOLUHX6t75fl98
        tXNCYJhGjjshA+wgLsYwNz5B/A==
X-Google-Smtp-Source: ABdhPJwRXN1RrezyBqEZ+IY/VFhjmhlZMehG7cvvOaL9gxMM5+8b7OuhIia8rfhpjyKECtKZUzAh/g==
X-Received: by 2002:a17:902:7001:b0:158:43ba:56cc with SMTP id y1-20020a170902700100b0015843ba56ccmr29258356plk.135.1650035472580;
        Fri, 15 Apr 2022 08:11:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l22-20020a17090aaa9600b001ca7a005620sm4933327pjq.49.2022.04.15.08.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 08:11:11 -0700 (PDT)
Date:   Fri, 15 Apr 2022 15:11:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v8 7/9] KVM: Move kvm_arch_vcpu_precreate() under
 kvm->lock
Message-ID: <YlmLDFPtQeI5wIoI@google.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-8-guang.zeng@intel.com>
 <YlmIko9PbQMMKceU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlmIko9PbQMMKceU@google.com>
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

On Fri, Apr 15, 2022, Sean Christopherson wrote:
> > It's safe to invoke kvm_arch_vcpu_precreate() within the protection of
> > kvm->lock directly rather than take into account in the implementation for
> > each architecture.
> 
> This absolutely needs to explain _why_ it's safe, e.g. only arm64, x86, and s390
> have non-nop implementations and they're all simple and short with no tendrils
> into other code that might take kvm->lock.
> 
> And as before, I suspect arm64 needs this protection, the vgic_initialized()
> check looks racy.  Though it's hard to tell if doing the check under kvm->lock
> actually fixes anything.

Ah, I bet this code in vgic_init() provides the necessary protection.

	/* Are we also in the middle of creating a VCPU? */
	if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus))
		return -EBUSY;
