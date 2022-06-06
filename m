Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E4B53ECBA
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiFFRKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 13:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiFFRIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 13:08:49 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E6A3561E5
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 09:56:55 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s68so13371355pgs.10
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 09:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/5dOkIUPK4LW5OYTDk812LAqaFzKUe0vwtcKi0hbnlM=;
        b=GfFJBUVisv0PqVkrWuDqO6GnJbD1uVivcukZ2+zrLhAY0TYOAzF6hiVnTS/CwdWapc
         vHuX33w6RmbXVpASnBf2DFOa7iXRJUxB/RnVvyVZ6CVZfGYZrcBW0esQofH9Pfe2Qldq
         tRTqaMscD14X5BSW1w/68cLagRaTKeX/s1p8FMrm6Bgpkebje8Y+zV72+0lHB1Q7r13P
         dMy0wgR9NRSuFyCmXn7Be3ir3d/b2+rJN5r9K8qdPVkW3JgpEGyy/uq1wLbjfKfSqVBv
         +w1zAPlN1+BKXWgm7S0oYoz0uEj27PZq+4e4HWQ6B5TMSQOSg9Bym9Q/DhQQ0M6AqUSC
         JChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/5dOkIUPK4LW5OYTDk812LAqaFzKUe0vwtcKi0hbnlM=;
        b=mbvUaRtEgNaU6yw7ViLLLmFqyTAlshkYZab4DOwz9IfRU3eNbb+QDWj627AiJKAO79
         C3xz74sXsWyI2wRUZKl7ohj+ypk0xRKGpT/CcztpKr95NDZEIqSkI82F131F5SA2UNY0
         l33SoUkMvib3iZtsclpH1z/Tw687g1k1UBkiOnJ5B0YmlyFc04tRh/SsbWSf8ABVBiLB
         17NN2AVt0ukCGpxv1WJOoUGgR3P9cM6HajC5PXmkcKOg893n07KlsTOuAd/v4nYg7Mqq
         RSumvRZ5Ugbm5HUUWpu3bIR07jdoz887w9Vlqb6LwhO62s+pr97UUsYOmoaAoDcnKdmb
         yZbw==
X-Gm-Message-State: AOAM532vG4GXOt5R88v+GVgcOD3bdvk3i4yXa2ujisYbtYUgEyXSVy8E
        fWsE6sGEgaN+HwEWcBFhpoKQHA==
X-Google-Smtp-Source: ABdhPJzy0DhsW4eKfoBaeYDIxyjKg9hmQ606VqWBBDwKWv0HdUX2/WGwySfqlcnEBs1qM/iBMCCCCw==
X-Received: by 2002:a05:6a00:2293:b0:51c:155a:1868 with SMTP id f19-20020a056a00229300b0051c155a1868mr7220103pfe.79.1654534614798;
        Mon, 06 Jun 2022 09:56:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u5-20020a170903108500b00161f9e72233sm10592208pld.261.2022.06.06.09.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:56:54 -0700 (PDT)
Date:   Mon, 6 Jun 2022 16:56:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     shaoqin.huang@intel.com
Cc:     pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ben Gardon <bgardon@google.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86/mmu: Check every prev_roots in
 __kvm_mmu_free_obsolete_roots()
Message-ID: <Yp4x0twziuEr3KRm@google.com>
References: <20220607005905.2933378-1-shaoqin.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607005905.2933378-1-shaoqin.huang@intel.com>
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

On Mon, Jun 06, 2022, shaoqin.huang@intel.com wrote:
> From: Shaoqin Huang <shaoqin.huang@intel.com>
> 
> When freeing obsolete previous roots, check prev_roots as intended, not
> the current root.
> 
> Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
> Fixes: 527d5cd7eece ("KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped")

Because KVM patches aren't guaranteed to be backported without it (though it's
"only" v5.18 that's affected), this needs:

  Cc: stable@vger.kernel.org 

Reviewed-by: Sean Christopherson <seanjc@google.com>
