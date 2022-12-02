Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4860064098E
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 16:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbiLBPtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 10:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiLBPtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 10:49:32 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB1EDB0D4
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 07:49:31 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id s7so4980953plk.5
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 07:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DyYjQXepcIbzGGZBsmjIHP+6MBxFisvUmuz9uOlal90=;
        b=QgblYDa1UHXmusNEhRA1SXEQt6qUJxGSgOgm0vHv6mYiK5mcZQkhNqW8Gflw3kmWM0
         FG6n7SPAeo4qwl8fkumIKNb7wgGL7bi7LQ/Z9siNk+J1pK9YhLY3osIDWTQywv7ira2D
         oq/CJ7ijyu/el/oEsQZdO9xbu4otycY7myNvjt1Vb3yz8CNVOpNFvY2jiNHDAl8aczQC
         aYBrGJ7QPqflmDTAgN6I+I+srChSFSyao7XsAr7vHkPez+xZP4BkmbJ+13tLzFSc/WiF
         ztkz2liYkezUxcPqJelaakiUo0czw/Jg1Zjjvs40yVLOfdTP3fsfc8QukSYXrEau7DyO
         bGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DyYjQXepcIbzGGZBsmjIHP+6MBxFisvUmuz9uOlal90=;
        b=B9Rr1Db/XycJHyo9RDCmLnTr829mTs+++SHOvt+E6QKq9LTcfH8Vx6HBMWoT4EoBiC
         oHbdPJX0Yklf5RF5NAxsQRNHfUHCdBG+0amR1duEqKxjpJKVF5clg+zSrKRe2dDg7gxU
         hoQ3PyMaVsnadbkgLZ36zWD7n9KS+OSDpjEcUAeGraDyhz3zVLRJvPYf+xGKTWX64D4k
         tD7nmm870ZA++PGejNiebmAah0gjwsN6pJ4AmzpAR53QEJ3x9Ta0swT5gRgrnE64Q1zi
         QGDQcREyPpsVPSVjV01/gFmJR2f7W0KLFI3U7mu2ezjawLfVzi4+oVbrlz6XxKYIE7wb
         OF1Q==
X-Gm-Message-State: ANoB5pnV/FIYsGMWF6Q7lbBYeuc4CCwqsfXWni1TbEQrl6MCSusIKvQr
        qTl3XBeMwTCE1dnTsQvIR+W4Mw==
X-Google-Smtp-Source: AA0mqf6h2qn7y7jsYhPTQrDSXOOhGa0+ryoI1RU+O7IyslS1qQ7k3Pxe4SKQnxmJmDjQ7uuEmNXHLQ==
X-Received: by 2002:a17:903:289:b0:189:25fb:8e83 with SMTP id j9-20020a170903028900b0018925fb8e83mr55598112plr.20.1669996171241;
        Fri, 02 Dec 2022 07:49:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i14-20020a17090332ce00b00189422a6b8bsm5800996plr.91.2022.12.02.07.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 07:49:30 -0800 (PST)
Date:   Fri, 2 Dec 2022 15:49:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mlevitsk@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix APICv/x2AVIC disabled when vm reboot by
 itself
Message-ID: <Y4oeh6XWw2qzETEQ@google.com>
References: <1669984574-32692-1-git-send-email-yuanzhaoxiong@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669984574-32692-1-git-send-email-yuanzhaoxiong@baidu.com>
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

On Fri, Dec 02, 2022, Yuan ZhaoXiong wrote:
> This patch fixes that VM rebooting itself will cause APICv
> disabled when VM is started with APICv/x2AVIC enabled.
> 
> When a VM reboot itself, The Qemu whill reset LAPIC by invoking
> ioctl(KVM_SET_LAPIC, ...) to disable x2APIC mode and set APIC_ID
> to its vcpuid in xAPIC mode.
> 
> That will be handled in KVM as follows:
> 
>      kvm_vcpu_ioctl_set_lapic
>        kvm_apic_set_state
> 	  kvm_lapic_set_base  =>  disable X2APIC mode
> 	    kvm_apic_state_fixup
> 	      kvm_lapic_xapic_id_updated
> 	        kvm_xapic_id(apic) != apic->vcpu->vcpu_id
> 		kvm_set_apicv_inhibit(APICV_INHIBIT_REASON_APIC_ID_MODIFIED)
> 	   memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s))  => update APIC_ID
> 
> kvm_apic_set_state invokes kvm_lapic_set_base to disable x2APIC mode
> firstly, but don't change APIC_ID, APIC_ID is 32 bits in x2APIC mode
> and 8 bist(bit 24 ~ bit 31) in xAPIC mode. So kvm_lapic_xapic_id_updated
> will set APICV_INHIBIT_REASON_APIC_ID_MODIFIED bit inhibit and disable
> APICv/x2AVIC.
> 
> kvm_lapic_xapic_id_updated must be called after APIC_ID is changed.
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> 
> Signed-off-by: Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
> ---
>  arch/x86/kvm/lapic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d7639d1..bf5ce86 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2722,8 +2722,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>  			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
>  			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
>  		}
> -	} else {
> -		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
>  	}
>  
>  	return 0;
> @@ -2759,6 +2757,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	}
>  	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
>  
> +	if (!apic_x2apic_mode(apic))
> +		kvm_lapic_xapic_id_updated(apic);
> +

Already posted[*], along with a pile of other APIC fixes.  Hopefully it will land
in 6.2.

[*] https://lore.kernel.org/all/20221001005915.2041642-7-seanjc@google.com
