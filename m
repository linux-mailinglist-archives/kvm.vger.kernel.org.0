Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2D4B7338
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbiBOQbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 11:31:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiBOQa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 11:30:59 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E29074876
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:30:49 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id l19so29915457pfu.2
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IMlwVgzQyz7Ol8ZT8u19HUTMM/hLQV/cI9HesozCSG8=;
        b=rv5yFZJGQlEFyPHLOy7He2hHDb9greGfCVmwWDwf0yl2jLGg2jOUGs5o3LYdZ7Ey0G
         xdQoOlr2Qod/ywdeUAwIKDJTZY5F9CgIiBof1UsxvpX+Tgny/nAD/pICZoVluQ2ZPANM
         tSG2Sa0AypXLntNY6Oq8kwO6/IYOkFcrYiTVXNKgZMrOjSi4ZGqhdkHWtymjaNM9+DcX
         PpG67b9PgbZ2KY7XIMAxDdUvdsYyF5pwjJoqiSCVSlPCIfy3KWqWuy2lJy0z13lcRoAl
         sGLxCU1I5WZQNr9kWEp0Bbbk0bl1I6HVzFueTr5EoZ9awKNh+FXVIvAi8mf6pqHDh7sK
         +S8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IMlwVgzQyz7Ol8ZT8u19HUTMM/hLQV/cI9HesozCSG8=;
        b=AI/jBsW3Qyd6MI32pWCqJkjXPvB3rnjlb6//WWNmXwO9avUNI84t/1orVggim2lo7X
         5qdbU2iqWpIfA5TCWoENtgK9W8NxrlX8keKoRwP5019+0ypRRwQzu6YRtN97IFbQZG3C
         wZRh2pnXGAKAUEt/VWo11pq4o0MM5Z5CpHwccV3hrnaZWypBBqW95HEDWDTnT2GsnJUF
         DoB1eGfkRz1V5SRfGOIWGVOPNEEAqpD5lCyFzttAAMZMVIdDy9Q1F2UgoyzCBAE580KX
         4wzKjbzW80mHLsHRMiNQHNxq/POy4SocVf+NiPn6zrUvtWgS8kbv3WNQ1oSxqDjyw6tJ
         0aUA==
X-Gm-Message-State: AOAM530Sn4JcireuDoSBEAz3cFBtB5CEUva0ZdcNQwX/j6bZADdVdfVo
        5gW9Ou4j036+T1aCpOcb/+AtdA==
X-Google-Smtp-Source: ABdhPJys3WpZBgOoj61fy1187jRwIkgBsulC+N7VKcxf5cs9IIigOisBdFNqUCLMSF85SYBXamcsHQ==
X-Received: by 2002:a05:6a00:804:: with SMTP id m4mr4897245pfk.45.1644942648750;
        Tue, 15 Feb 2022 08:30:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s2sm9254976pfk.3.2022.02.15.08.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 08:30:48 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:30:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 02/11] KVM: VMX: Handle APIC-write offset wrangling in
 VMX code
Message-ID: <YgvVNNvx4NGDSGUA@google.com>
References: <20220204214205.3306634-1-seanjc@google.com>
 <20220204214205.3306634-3-seanjc@google.com>
 <20220215022221.GA28478@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215022221.GA28478@gao-cwp>
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

On Tue, Feb 15, 2022, Chao Gao wrote:
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -5302,9 +5302,16 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
> > static int handle_apic_write(struct kvm_vcpu *vcpu)
> > {
> > 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
> >-	u32 offset = exit_qualification & 0xfff;
> > 
> >-	/* APIC-write VM exit is trap-like and thus no need to adjust IP */
> >+	/*
> >+	 * APIC-write VM-Exit is trap-like, KVM doesn't need to advance RIP and
> >+	 * hardware has done any necessary aliasing, offset adjustments, etc...
> >+	 * for the access.  I.e. the correct value has already been  written to
> >+	 * the vAPIC page for the correct 16-byte chunk.  KVM needs only to
> >+	 * retrieve the register value and emulate the access.
> >+	 */
> >+	u32 offset = exit_qualification & 0xff0;
> 
> Can we take this opportunity to remove offset/exit_qualification?
> They are used just once.

Definitely should have dropped exit_qualification, not sure why I didn't.

I'd prefer to keep offset to document what is held in vmcs.EXIT_QUALIFICATION
without having to add an explicit comment.
