Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BB54EB759
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 02:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbiC3AIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 20:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241388AbiC3AIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 20:08:50 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6B343493
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 17:07:06 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p8so17321249pfh.8
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 17:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y2rRhw4flc97ksCHOd8D6zj8TKfoieAVBtd70rXcpQs=;
        b=o9HHTHEYnmATJjpdZ+6at7qnwRTprPUxz44HrTkQVZVnCOrEgYVmZWSnp4gUPhisJv
         Rmiu/9OTD/qceAnczy4elXmZYfqCtOJj96eJQMuVW9Lc1lYOGiX8XPbzl8WSTIsAt0FI
         9afhf33i8d59GFe3+3rYaQygWjErHAhbVZIako5ZoRr5T0a8YW9Q16JqV/pxo4oBHHo/
         UEXCoV5RfVH/960ntKzVVEko47A4lLAAUFSwvWxPfrN0Y8SkBw/e1ZrQUnG2NqnubIrO
         RzIPQAd1lEWZL6FPCSVd745Vy6Zx7A2+ckbidrCyQzYqyMtumppulGgHbvCydajf90TS
         nKtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y2rRhw4flc97ksCHOd8D6zj8TKfoieAVBtd70rXcpQs=;
        b=BzrjLbHnKhWK75ktUKmuZiCKZsFhbE+4QZiSCWC+60gx4i5PX8Mib20aanD9UoqF4L
         g9sbU0o61Ml++dt+2vdpQXXWmoIO5sEoor1qTMr2yXnSh25F9cKXGQnvpGeDmNjNK9J2
         hF5sTQWbj6kcR1WCnAcB3MmmjORn39I0F0Z3RUbDK7kn1V6xnVF9VOkvgq5QndKBXYfG
         enDQAYCLrXKA9MooqT62oFHK1SZmLCsN6Y8ZpkjTzXMCQOrvcHqVkI+R2q6ciXdO1j3S
         mrIgsKpI0CfX/kVzMIfIaL3eTdZA6pI54ZROdY/GPxlnlqYakEUzyUqwZKtFBJCzX5qc
         6Muw==
X-Gm-Message-State: AOAM532+iq7AwW6XpNKEWUO+jXJjaljQpsgGctKiThECUq1ELWzBgkVL
        s+v2ePyuu7VPCaMI3lAeeY0wIA==
X-Google-Smtp-Source: ABdhPJxUppfMa3o7A5xAfew/ErKXOffjoVHzpxNp8qP8IaCknbYo1DmmtfVP+XIrltUTJl/gsv4W0g==
X-Received: by 2002:a63:dd47:0:b0:381:2bb3:86ba with SMTP id g7-20020a63dd47000000b003812bb386bamr3899371pgj.381.1648598825402;
        Tue, 29 Mar 2022 17:07:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f20-20020a056a00229400b004fb16860af6sm17208497pfe.195.2022.03.29.17.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 17:07:04 -0700 (PDT)
Date:   Wed, 30 Mar 2022 00:07:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH RESEND 3/5] KVM: X86: Boost vCPU which is in critical
 section
Message-ID: <YkOfJeXm8MiMOEyh@google.com>
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
 <1648216709-44755-4-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648216709-44755-4-git-send-email-wanpengli@tencent.com>
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

On Fri, Mar 25, 2022, Wanpeng Li wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 425fd7f38fa9..6b300496bbd0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10375,6 +10375,28 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  	return r;
>  }
>  
> +static int kvm_vcpu_non_preemptable(struct kvm_vcpu *vcpu)

s/preemtable/preemptible

And I'd recommend inverting the return, and also return a bool, i.e.

static bool kvm_vcpu_is_preemptible(struct kvm_vcpu *vcpu)

> +{
> +	int count;
> +
> +	if (!vcpu->arch.pv_pc.preempt_count_enabled)
> +		return 0;
> +
> +	if (!kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_pc.preempt_count_cache,
> +	    &count, sizeof(int)))
> +		return (count & ~PREEMPT_NEED_RESCHED);

This cements PREEMPT_NEED_RESCHED into KVM's guest/host ABI.  I doubt the sched
folks will be happy with that.

> +
> +	return 0;
> +}
> +
