Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BB2673D7D
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 16:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjASP3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 10:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjASP3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 10:29:51 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F67482994
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 07:29:48 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id g23so2586979plq.12
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 07:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JoeZWpRNsWJhyrWOKICRT+p+hJ0pH/jVJe5L8tZzDKE=;
        b=gyEc+zZbgF6XMT7Sm4wHZQXewdDcMta7P6XtP/yslScovv1aoQENuCi1pph/8CZlIq
         9l6PU11qUpOvB6egZTZQHtBe9hMezPpMfF0wXwlfI+A1MEXpFOYwl+wum9n8Fsy8dyFO
         RvZLcIHOA+8xoHjgzx4yicPnekaCFBSM9PDPoVGGlc7roOYIFz1BtCptWO/wsrEZE+pK
         NfxkaX263bnefQ6+baeDeHmLDnZB0KxAfCmuN8DqmUVIrExCUhN/5dh16t0b4CQZy94x
         89HJwkZFOTh0lxO/B8/EfI3h+QPyVgNokSVxxNRwvsagvj1+CuW+TEnC4mB2/eRfE7H/
         vNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JoeZWpRNsWJhyrWOKICRT+p+hJ0pH/jVJe5L8tZzDKE=;
        b=GTkekV/RrDIvtLUmNSNqUhV7ADyAu9uat0XXIxKsTpL4g1UFt4fEzT4xeYbsMHXIok
         HCHWNUNC1evoemht03DfIyg9xDM7VoyeEWUju4tAayKfaGn+GQ7+SIRPnqvxD0jPOZbu
         n5AbU/ljvK0gAOqD3LekPXKaS6rfqNl5aGDVXsssiURAA5ZFoBO73Dq195zmzjN8CoSW
         VR+aI1rqsfYtXseGIFUg9WVd0aA9OjUw+JicmXn8UvtHXWB45zbCyqao+97xbOnXbf1u
         TxSyq/smitmxbezVMO231NrSOR0zZHQ86gGDpja007OD+n+WroeYn4VJ9LdWtthjo+i2
         49pg==
X-Gm-Message-State: AFqh2kq6RtGT/j4DINf8uLvMVz4NL/DScNKC9RRddIckAhugsN25FIMR
        L09GbmwzK1J1PxWXY41F8L/F8g==
X-Google-Smtp-Source: AMrXdXuvS8AZJX42bXwmLQ8QfqUcY4PwFKh/puu96hqRK42cg/DuvMprn5jaOq/Bqv+IZX2KJRBMAQ==
X-Received: by 2002:a17:903:2614:b0:193:256d:8afe with SMTP id jd20-20020a170903261400b00193256d8afemr3075957plb.2.1674142187661;
        Thu, 19 Jan 2023 07:29:47 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186c3afb49esm25186385ple.209.2023.01.19.07.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 07:29:47 -0800 (PST)
Date:   Thu, 19 Jan 2023 15:29:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8lh59ZYZkq4fsOX@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
 <080e0a246e927545718b6f427dfdcdde505a8859.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <080e0a246e927545718b6f427dfdcdde505a8859.camel@intel.com>
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

On Thu, Jan 19, 2023, Huang, Kai wrote:
> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > +static void tdx_clear_page(unsigned long page_pa)
> > +{
> > +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > +	void *page = __va(page_pa);
> > +	unsigned long i;
> > +
> > +	if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {
> > +		clear_page(page);
> > +		return;
> > +	}
> 
> There might be below issues here:
> 
> 1) The kernel says static_cpu_has() should only be used in fast patch where each
> cycle is counted, otherwise use boot_cpu_has().  I don't know whether here you
> should use static_cpu_has().

That documentation is stale[*], go ahead and use cpu_feature_enabled().

https://lore.kernel.org/all/20221107211505.8572-1-bp@alien8.de

> 2) IIUC a CPU feature bit can be cleared by 'clearcpuid=xxx' kernel command

As you note below, using clearcpuid taints the kernel, i.e. any breakage due to
clearcpuid is user error.

> line, so looks you should use CPUID directly otherwise the MOVDIR64B below can
> be unintentionally skipped.  In practice w/o doing MOVDIR64B is fine since KeyID
> 0 doesn't have integrity enabled, but for the purpose you want to achieve
> checking real CPUID should be better.
> 
> But maybe you don't want to do CPUID check here each time when reclaiming a
> page.  In that case you can do CPUID during module initialization and cache
> whether MOVDIR64B is truly present.  static_key is a good fit for this purpose
> too I think.
> 
> But I am also seeing below in the kernel documentation:
> 
>         clearcpuid=X[,X...] [X86]
> 			......
>                         Note that using this option will taint your kernel.
>                         Also note that user programs calling CPUID directly
>                         or using the feature without checking anything
>                         will still see it. This just prevents it from
>                         being used by the kernel or shown in /proc/cpuinfo.
>                         Also note the kernel might malfunction if you disable
>                         some critical bits.
> 
> So the kernel is claiming using this will taint the kernel and it can even
> malfunction.  So maybe it's OK to use static_cpu_has()/boot_cpu_has().
