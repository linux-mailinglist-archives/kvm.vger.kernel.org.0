Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD6057D667
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 00:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiGUWAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 18:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbiGUWAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 18:00:08 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820A42EB
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:00:05 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w7so3056226plp.5
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7gujx4/vn7+YQjww67d8XBsvreA1sJCQ6MzDAhjTGYE=;
        b=fuqsh1fdgWgyWIc3fyOeUlM0zge5cMl9ja2YPhfmZaLQUb4GzD/h/rXb4XU5wYi5gz
         emIaaSuEyLgh3bCaXJVJ/NFX0ntkQZnOtKlVYksiAGvxFLct8I91wYSSh3wvRVVUFJHO
         8Vj9F9FNB2ZcxFiPlFey/al8u/sSTFnSrTNkc3iXHEM0ZAaNjDfV0O3q3JpA0s9pyjWt
         oMD1/v0EyEu8iSCu63aJLtVvQy5qhW6Fi7afpnn5Bg8E2k35c5xxI7NRLkzj6ddOOGDN
         friI4hPRN++XZFhEe4saVRA+N8GcvRbmA4NLvfLVFfR7Ppy4g8XTu734gCXm+h3ZiGWs
         Wlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7gujx4/vn7+YQjww67d8XBsvreA1sJCQ6MzDAhjTGYE=;
        b=MhX0TtzyZHqCsbDufqweGB2xBODCeI+hrxxk4A7QHZcvyMnNP3cq8kyYGrA1hLmvup
         Sm+EXwnQ7lNKkezi99HAoaAFsIn5Jbp368LicT0QnveU4N/vv587P/jGWEGPZ4vcWsSp
         k76VhdAHVsKZJzftMo6C42PM2/l1VOONiFxkgZ6/QdRZqi8roZRQWoL07bQH/Idk/xIt
         3tGJsOpMsBVwwZZw109ppOKaWXGmy716HlipzR1MI3MG/kQmIffvKRO1j92cZpdJsaVK
         P3eNKgzTNI0H9AsB94pMPQibBaM54+yadx4YWrHdtCQpKqcxUDCdwGJW70QyB7ijWnIR
         Uc3g==
X-Gm-Message-State: AJIora8jQXHcvaa53hsrKdUMIpRtLagNyK8ub1mn+dFlKb9MKv9Ygy+H
        EQhkBq1q636ccW79TaToYThnfSRW4hfRgQ==
X-Google-Smtp-Source: AGRyM1sY/4JL0WvYhndZ87X4aQbb6i7KlSC28zRbWT8KnZlwPKrRh5hGkUHGV+oWANevxZgcFbtYWQ==
X-Received: by 2002:a17:903:11d2:b0:167:8a0f:8d33 with SMTP id q18-20020a17090311d200b001678a0f8d33mr509111plh.95.1658440804817;
        Thu, 21 Jul 2022 15:00:04 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 82-20020a621455000000b0052bae7b2af8sm2243275pfu.201.2022.07.21.15.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 15:00:04 -0700 (PDT)
Date:   Thu, 21 Jul 2022 22:00:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 12/25] KVM: VMX: Check VM_ENTRY_IA32E_MODE in
 setup_vmcs_config()
Message-ID: <YtnMYNR9VCNOXRi5@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-13-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714091327.1085353-13-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> VM_ENTRY_IA32E_MODE control is toggled dynamically by vmx_set_efer()
> and setup_vmcs_config() doesn't check its existence. On the contrary,
> nested_vmx_setup_ctls_msrs() doesn set it on x86_64. Add the missing
> check and filter the bit out in vmx_vmentry_ctrl().
> 
> No (real) functional change intended as all existing CPUs supporting
> long mode and VMX are supposed to have it.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
