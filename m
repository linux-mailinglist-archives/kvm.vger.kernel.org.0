Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952044E6B7D
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 01:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356822AbiCYAKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 20:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347893AbiCYAKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 20:10:13 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62815167D7
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 17:08:41 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id y6so3883879plg.2
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 17:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fbhAasjsFq+DCPOkZ056UEhAK9GneQ3ssLZTa7vJBEY=;
        b=WBjZU6Ujv4ue++AV8YveRa9jaY7zVtS5fTEy9wBFOzoSXFXQL57wkYaMwyfuT1L+Ni
         NjPPjW1f3JN/F9XwrDmNXdxHQRRYFKJ8O+dR8ZVJWBmxmB2GLLDVIAShsJ6yNdUSmNkh
         kzihAv4xPCKD1Lbd28mH3XxHlIsbRZxAPJ+lFN9lXJvElNPTY/o8iJ+eulmAAMhDLpFE
         vgIGQjWnrHBbo1FR/+j7xuO89WAufPDsS7SX0BWfCRddsz4ONVlbsj8V1GYeI7gYX2je
         2drgX8beDy0dHTUBvFWdM18sZruWCT/qCDJO9eZW1a6/g+r+Ko90ndYbxrCZANwwo/TP
         QqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fbhAasjsFq+DCPOkZ056UEhAK9GneQ3ssLZTa7vJBEY=;
        b=13Q1F09Br++KJvcuaA59FfpDsmYYfjRw6mYkn8YkAF8+c19TKYkRQNDai5XX4HRrDO
         ivMq8nvL154GNWkwIvEiDmcrjRRlNpgApXCw6OsoOe3U0hXjuUtuGCmemgk2XTBGZyZn
         4UAEX0eCaWwvMBWzdQLTK8E7RUbsHOrO3Fl1mHbAjhp7eN4UySEKJZ61myUrd6Wm+Ogd
         pmRl62Daij9Pswyxvbp1J5qzCL2E9aQwwqKlHHE9W/3VpM6CSpZVnWMX/Z3QCpwP5TA+
         rsGAdhy3J0eJJrMfFPcNLGZXF1qNO2X66yMP25MAoVop5SempL2keItkl0fkaZuuXyzj
         D2AQ==
X-Gm-Message-State: AOAM5306JfgMH64kSQNOqaqXG5PhHJXS1IhqhxkkWRyAMj75g93fnNPG
        oeSDy4FK8ykdY0DZokGeFLyl5A==
X-Google-Smtp-Source: ABdhPJzCEXXkG7e5jj//np460GZUktYUf+qmz7V1ij2woHUf+GpcmcX2Io2+wjHWaOVYD+6eptKZIA==
X-Received: by 2002:a17:902:f70f:b0:153:ebfe:21b3 with SMTP id h15-20020a170902f70f00b00153ebfe21b3mr8572494plo.119.1648166920531;
        Thu, 24 Mar 2022 17:08:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q21-20020a63e215000000b00373efe2cbcbsm3501410pgh.80.2022.03.24.17.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 17:08:39 -0700 (PDT)
Date:   Fri, 25 Mar 2022 00:08:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     SU Hang <darcy.sh@antgroup.com>
Cc:     kvm@vger.kernel.org,
        =?utf-8?B?6LWW5rGf5bGx?= <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX:  replace 0x180 with EPT_VIOLATION_*
 definition
Message-ID: <Yj0IBGTu45TZkqGi@google.com>
References: <20220321094203.109546-1-darcy.sh@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321094203.109546-1-darcy.sh@antgroup.com>
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

On Mon, Mar 21, 2022, SU Hang wrote:
> Using self-expressing macro definition EPT_VIOLATION_GVA_VALIDATION
> and EPT_VIOLATION_GVA_TRANSLATED instead of 0x180
> in FNAME(walk_addr_generic)().
> 
> Signed-off-by: SU Hang <darcy.sh@antgroup.com>
> ---
>  arch/x86/include/asm/vmx.h     | 2 ++
>  arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..a6789fe9b56e 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -546,6 +546,7 @@ enum vm_entry_failure_code {
>  #define EPT_VIOLATION_READABLE_BIT	3
>  #define EPT_VIOLATION_WRITABLE_BIT	4
>  #define EPT_VIOLATION_EXECUTABLE_BIT	5
> +#define EPT_VIOLATION_GVA_VALIDATION_BIT 7

VALIDATION isn't quite right, EPT_VIOLATION_GVA_IS_VALID is more appropriate.
VALIDATION makes it sound like the CPU has does some form of validation on the GVA.

>  #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
>  #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
>  #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
> @@ -553,6 +554,7 @@ enum vm_entry_failure_code {
>  #define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
>  #define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
>  #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
> +#define EPT_VIOLATION_GVA_VALIDATION	(1 << EPT_VIOLATION_GVA_VALIDATION_BIT)
>  #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
>  
>  /*
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 95367f5ca998..7853c7ef13a1 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -523,7 +523,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	 * The other bits are set to 0.
>  	 */
>  	if (!(errcode & PFERR_RSVD_MASK)) {
> -		vcpu->arch.exit_qualification &= 0x180;
> +		vcpu->arch.exit_qualification &= (EPT_VIOLATION_GVA_VALIDATION
> +			| EPT_VIOLATION_GVA_TRANSLATED);

Please put the | before the newline, and align the stuff inside the parantheses.
That makes it must easier to see what the code is doing at a glance.

		vcpu->arch.exit_qualification &= (EPT_VIOLATION_GVA_IS_VALID |
						  EPT_VIOLATION_GVA_TRANSLATED);

>  		if (write_fault)
>  			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_WRITE;
>  		if (user_fault)
> -- 
> 2.32.0.3.g01195cf9f
> 
