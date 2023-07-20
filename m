Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8803C75BB56
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 01:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjGTXx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 19:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjGTXxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 19:53:55 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121EA1BD;
        Thu, 20 Jul 2023 16:53:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-55b0e7efb1cso739802a12.1;
        Thu, 20 Jul 2023 16:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689897234; x=1690502034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3RMP66qaRBJbW0474zxX1l0UqgGjp6zSPKyUrb9K//Y=;
        b=M0AWHWAUrZ5FjcoAlR5eBMNb3l0R1avJWZhP1n35/cJ95/RpCQ3g29wVvVJFSqL6yz
         UtA9nkGHemd1aJyZWlQ96vt2bO9SBHCJp9sfol9iCjWikpu5Zpv5vJaYZPcD1axphMrK
         tfDBkG2qD7jmxCanT1yuCyBd9zkW+M2MnjfG43tL8X7uNXqg1PSK3tp/thedbLnYnrYv
         V/2mc5adkyw6QVx/+YIijFr8ZMcj5dcQ+gfAkzTpsCRM/6Pt/R3YGPg29WIfayEXaorj
         QlriiGnr2KIUEp+PETj8G7oJwtPkvEGcp+qlIGD1ZiCb8skPq1SWjNb2BMhN6En35x/7
         vZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689897234; x=1690502034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3RMP66qaRBJbW0474zxX1l0UqgGjp6zSPKyUrb9K//Y=;
        b=iayfMlGNTayiBmAX47gwEe4oIGd2lh/D+i8XQY/5pHYIO4f/LfNG3UV7YBffomyXUj
         ELLItBysWAuAE7xNVa6CuslzE/I4l2l92pkoivCDnX4PM4DXDAE64UHGN30gdwJuxpn0
         Ywi38rAceV9NVBC63I9UluS5DS5kSvtXhZ/Wz4pyliM+a/xrRXmUt/SFDtkp22UR148I
         t+rQp+kj/Hs15YhikwrkSeilmElEM9P/mOmufVkav/ImxkmXXZxcRbnYn97FfeIXjWRL
         7fz37lqIdk4YUjbOiCzEEcDmaa6vliOYYLbffFB9pP2LDzic8sbOMrIRAMg0SyNur8JW
         Vj6g==
X-Gm-Message-State: ABy/qLZnPAz4E9mKY/hPo4edHOMv2TfYwyycXaXCCEH+1IQn0msV2Rw9
        NevrgyTxk6u+4c+/Tmmh5tM=
X-Google-Smtp-Source: APBJJlGp3KvCUTFdZf4bUcWWHxddaEd6K2u9j2XP3mI+MnUlmLsqQ6q0sEro9phivu4lr3cqrMy+2Q==
X-Received: by 2002:a05:6a20:1d0:b0:12c:518:b8de with SMTP id 16-20020a056a2001d000b0012c0518b8demr360804pzz.17.1689897234393;
        Thu, 20 Jul 2023 16:53:54 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id x28-20020aa793bc000000b00672401787c6sm1721245pff.109.2023.07.20.16.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 16:53:53 -0700 (PDT)
Date:   Thu, 20 Jul 2023 16:53:52 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v10 2/9] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to
 check CR3's legality
Message-ID: <20230720235352.GH25699@ls.amr.corp.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-3-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230719144131.29052-3-binbin.wu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 10:41:24PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> Add and use kvm_vcpu_is_legal_cr3() to check CR3's legality to provide
> a clear distinction b/t CR3 and GPA checks. So that kvm_vcpu_is_legal_cr3()
> can be adjusted according to new feature(s).
> 
> No functional change intended.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.h      | 5 +++++
>  arch/x86/kvm/svm/nested.c | 4 ++--
>  arch/x86/kvm/vmx/nested.c | 4 ++--
>  arch/x86/kvm/x86.c        | 4 ++--
>  4 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index f61a2106ba90..8b26d946f3e3 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -283,4 +283,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
>  	return vcpu->arch.governed_features.enabled & kvm_governed_feature_bit(x86_feature);
>  }
>  
> +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> +{
> +	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
> +}
> +

The remaining user of kvm_vcpu_is_illegal_gpa() is one left.  Can we remove it
by replacing !kvm_vcpu_is_legal_gpa()?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
