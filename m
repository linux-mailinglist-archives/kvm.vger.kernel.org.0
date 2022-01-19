Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68AD4931E8
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 01:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344015AbiASAe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 19:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343698AbiASAe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 19:34:28 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1818AC06161C
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 16:34:28 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id n16-20020a17090a091000b001b46196d572so907522pjn.5
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 16:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fhtsshb779foHbUp9uRUsqpWENAGkHqJ8VEZb1EuPfo=;
        b=cts+MA9AHHlyk9r+XBHTWM5nizuHm/1LTrjv907OodM2rP0bLUgF5TK5lIOAzVMUj1
         HLVENadItvTm+SBpER3uaCQow8rmnlyfjxa0twynqbwUdgYG4VrBrmFTD8WeT6Xjj8j6
         XWKN8YaFVAVY4z7kiQ3GKu3vC6oGB6krTdjpTRN1FzH2kZXit0Fc1xV0j6SDZJ6yuUPD
         3RbMsb+P2OeNN2TNvsEtX03QC17a8E5xriYNXIDcRWsZBEX7ux8KHekB9cEH0kiOLQP1
         tliQRaxGJiRzHqTsBDBMnBZL6q/Oq4iDSe0ObdfUe/6WWIxbL+9dRew7xxQtXnVXpM+N
         vdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fhtsshb779foHbUp9uRUsqpWENAGkHqJ8VEZb1EuPfo=;
        b=TukkODGAkHku3R2z2INMDfVAsMTXeP7l5m45vDOsGw0n/DyTq9yXpjEeZnhiUAcf6o
         nI+byjO2D3+0gDSc0BMT6O/DFci0vxE3twX4aYU9m2GK//+jB8kSiIKf70j7C+eOJp94
         OMs/xJOi6cfJ8HXlO4zU87AjD8JQkrLSZyOjTJJicahzK6NO2j4yPhofw6TJ6KglNz7d
         cR8+IRxB0VJ0x06QG29Wp9WQhBkG1him4k6NXvvONANaYQJq7i/roVJ9azPpN35qGfQZ
         n/vRprQ/VIg4cEXe9Zdzl2iIT2EgG1fpSgHVW9yF4Pd03jdMo33HpLdGzJNEla9A3u+o
         V8+g==
X-Gm-Message-State: AOAM531J13bDUnKUfu5SPTegJECd5fnHRYSBakMbqvrg1GSnrOvt1Yz+
        9ljvAaEs2H/BAr+vg168Qfy/dA==
X-Google-Smtp-Source: ABdhPJwzCq8jLEnOzlYAwNNMmWDUPgFImKOrZBeA6SdytoLo6ELVLP75EnatTaR9PDXpvl3+Xr8fRg==
X-Received: by 2002:a17:902:b189:b0:143:8079:3d3b with SMTP id s9-20020a170902b18900b0014380793d3bmr30164103plr.71.1642552467215;
        Tue, 18 Jan 2022 16:34:27 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a20sm9680713pfv.122.2022.01.18.16.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 16:34:26 -0800 (PST)
Date:   Wed, 19 Jan 2022 00:34:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: x86: Remove WARN_ON in
 kvm_arch_check_processor_compat
Message-ID: <YedcjqmGYekhPgec@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-6-chao.gao@intel.com>
 <Ydy6aIyI3jFQvF0O@google.com>
 <BN9PR11MB5276DEA925C72AF585E7472C8C519@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Yd3fFxg3IjWPUIqH@google.com>
 <20220112110000.GA10249@gao-cwp>
 <Yd8RUJ6YpQrpe4Zf@google.com>
 <20220117133503.GA27833@gao-cwp>
 <20220117134608.GA30004@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117134608.GA30004@gao-cwp>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 17, 2022, Chao Gao wrote:
> On Mon, Jan 17, 2022 at 09:35:04PM +0800, Chao Gao wrote:
> >OK. How about:
> >
> >	/*
> >	 * Compatibility checks are done when loading KVM or in KVM's CPU
> >	 * hotplug callback. It ensures all online CPUs are compatible before
> >	 * running any vCPUs. For other cases, compatibility checks are
> >	 * unnecessary or even problematic. Try to detect improper usages here.
> >	 */
> >	WARN_ON(!irqs_disabled() && !cpu_active(smp_processor_id()));
> 
> Sorry. It should be:
> 	WARN_ON(!irqs_disabled() && cpu_active(smp_processor_id()));

Nice!  That's exactly what I was hoping we could do.
