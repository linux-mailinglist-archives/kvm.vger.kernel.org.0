Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E344B0056
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 23:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbiBIWbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 17:31:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbiBIWbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 17:31:12 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEC3E019272
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 14:31:07 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso3700059pjh.5
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 14:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gMdWYeczAEnuPDFI5U/rcqR5QQiEcUd/G7kNkRPl+cg=;
        b=O6f4dj/rj1hQIEcFmKHUKyXs5lZaUsNv7lViYwECcgBjt+0wp+huDvrt03hImbTaZ3
         5jRwRC+z4A88lnri9+Itmm14MLExlomS2wq5VlIIqP0TsMZRQHhyp6VAMiRqPDDIbDCO
         lRmHtix97OWmO5I+qzpcyWMGsuEzz6s/xdz04juEj+9YYuihgka9Yy3Gmcn+d3ar+ZBo
         juY6rOE12f5XKWKYg0tNnrITvLdpWKl7otvP5TJmRUFGESMAiEXPDJKbntUy0sFG3cvq
         KE4eB8AJJNn0QnQZpQksWZDoMpJjzbPNPAskfG55h3xEE7zBS2xXTu155Cnm08YoSDID
         E1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gMdWYeczAEnuPDFI5U/rcqR5QQiEcUd/G7kNkRPl+cg=;
        b=RHQHpEYwJ1WEA7e+rdtsbCY2fBwxjjCBxxSdiRgRg+lfnHGnLrisTENfHAi8ai36px
         jeIP7bYXqBk5CxwnZInlvsN/Ku+/Q+mkZMSPWurJdJt4ffYg6ceVrUPYLghnCEVSMFTj
         ve3ePtxnMokBqEfw8wvgjAQm6374x5ys8yoPFncJENoTZQAv70Vx57X3Ga6M3/ekC3j8
         LtmXivZSzLW+H9Zdb8o+iQzCzawlZo4AbwYFtMyGIi/YKVEgmuUVbuRVrv0yegrJsVE1
         dmeBzBEUOmL3KoMmM6aR8g+xjlYzlBUbIScQ56zZphtb39+7mI8890l8PMqZOCDDF+Ed
         +Grg==
X-Gm-Message-State: AOAM531roWZkOOCLoFiF42KFA3irdi2KKSqP+024U7B9C6sMehFDGEg4
        uMePyS04Vhw/W80+vyb6O1LWgQ==
X-Google-Smtp-Source: ABdhPJzqzBbgGgmmAfV9iBPDWzGyXr8MgZC7SbLh0l+Hj1n4VK3u4lCfrMejEgjGHAHLb1vkU9dPqA==
X-Received: by 2002:a17:902:7fce:: with SMTP id t14mr4283322plb.101.1644445867191;
        Wed, 09 Feb 2022 14:31:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c14sm19821275pfm.169.2022.02.09.14.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:31:06 -0800 (PST)
Date:   Wed, 9 Feb 2022 22:31:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 00/23] KVM: MMU: MMU role refactoring
Message-ID: <YgRApq20ds4FDivX@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
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

On Fri, Feb 04, 2022, Paolo Bonzini wrote:
> Paolo Bonzini (23):
>   KVM: MMU: pass uses_nx directly to reset_shadow_zero_bits_mask
>   KVM: MMU: nested EPT cannot be used in SMM
>   KVM: MMU: remove valid from extended role
>   KVM: MMU: constify uses of struct kvm_mmu_role_regs
>   KVM: MMU: pull computation of kvm_mmu_role_regs to kvm_init_mmu
>   KVM: MMU: load new PGD once nested two-dimensional paging is
>     initialized
>   KVM: MMU: remove kvm_mmu_calc_root_page_role
>   KVM: MMU: rephrase unclear comment
>   KVM: MMU: remove "bool base_only" arguments
>   KVM: MMU: split cpu_role from mmu_role
>   KVM: MMU: do not recompute root level from kvm_mmu_role_regs
>   KVM: MMU: remove ept_ad field
>   KVM: MMU: remove kvm_calc_shadow_root_page_role_common
>   KVM: MMU: cleanup computation of MMU roles for two-dimensional paging
>   KVM: MMU: cleanup computation of MMU roles for shadow paging
>   KVM: MMU: remove extended bits from mmu_role
>   KVM: MMU: remove redundant bits from extended role
>   KVM: MMU: fetch shadow EFER.NX from MMU role
>   KVM: MMU: simplify and/or inline computation of shadow MMU roles
>   KVM: MMU: pull CPU role computation to kvm_init_mmu
>   KVM: MMU: store shadow_root_level into mmu_role
>   KVM: MMU: use cpu_role for root_level
>   KVM: MMU: replace direct_map with mmu_role.direct

Heresy!  Everyone knows the one true way is "KVM: x86/mmu:"

  $ glo | grep "KVM: MMU:" | wc -l
  740
  $ glo | grep "KVM: x86/mmu:" | wc -l
  403

Dammit, I'm the heathen...

I do think we should use x86/mmu though.  VMX and SVM (and nVMX and nSVM) are ok
because they're unlikely to collide with other architectures, but every arch has
an MMU...
