Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC0C505FE8
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 00:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiDRWwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 18:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbiDRWww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 18:52:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEF5E0AC
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 15:50:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n11-20020a17090a73cb00b001d1d3a7116bso817641pjk.0
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 15:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qzBPeq4Z1Lm/THhXP/p+Guvp3S0k6RUjKQr12jgDsss=;
        b=hLZrBdUqWLV/GYiIngWtZXbHDACKG/z6epibpsJFq1BaIhs2Z2KJfmWYmL7JO8Vs5k
         4swMjagpii7pBDxG9mRqPPeS6+cXe1apDmO4ek/Qv/mUAJpFaHx9fhZDvMXAl0AlShoJ
         XYxbWbjmNfZ32PLyYRZM4m4EXp55UekXWcwtBstrxxz6hHxw7520F0RQzIFyToh8VP+D
         Ffs8JDKtdWvIpEbxcRKUFlIVYZe53XaVIxtRxrDLAJS9WEBVF5gJL1ic/B5qPNae79ZJ
         yjrkV6x3IGT0C7jaHqXpaQxE41HZ84QaMG7W4wvJaomQFPKmNNzqNhQelaGrVlO38sDw
         jFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qzBPeq4Z1Lm/THhXP/p+Guvp3S0k6RUjKQr12jgDsss=;
        b=skZ6jOeA3qNAFRddW/WqwUdZIoo5co+gDQTl+/9hbrzFi4Z7hT4S0qwBkd92vhkG6Y
         5m3hDyWB2AHXM8E8Pwb10Jhm4zO1D1VcFwNEQP/YWJ9YrtjFjttAsfjQ8TntU9Lsg2+d
         TVSgF8Qpu5T9hufeemzLeB88uo7Ktsci93aZYv7kZTWeRqWYamIENCrT1/1s/R6mD51+
         j6QXtOxPtEWD0H6RYtvEEv0SAEMMEHettUx8HorjScJ2HjXc+IRzOIauUJX+nU4vxWlB
         SrgCT7jmBkN6SfuYlTeDIdXHtaJ6FeOrsv+tvBjkxWk+8ZmjmDoBPUEKWVTxoZvYNe87
         77Pw==
X-Gm-Message-State: AOAM530biN6o3vG1ECrv6LwKiF5GOIN14AzJwAYZI5tilXVJ41+G6l5O
        VzYO+jHbokkiVa9TUV3r08zyUg==
X-Google-Smtp-Source: ABdhPJw+yaMkUZUnbOjaOzUM4WWyFmXWGGeEaX9APFm/5xhK/PVs2+8n3UnfCm5Ue6KnHOXHo1K/8w==
X-Received: by 2002:a17:902:7404:b0:158:bff8:aa13 with SMTP id g4-20020a170902740400b00158bff8aa13mr12845518pll.133.1650322211428;
        Mon, 18 Apr 2022 15:50:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id bt21-20020a056a00439500b0050a4dfb7c44sm10012680pfb.155.2022.04.18.15.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 15:50:10 -0700 (PDT)
Date:   Mon, 18 Apr 2022 22:50:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
Subject: Re: [PATCH v3 01/21] x86/virt/tdx: Detect SEAM
Message-ID: <Yl3rHxI6M/+7nzNq@google.com>
References: <cover.1649219184.git.kai.huang@intel.com>
 <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
 <8e2269a7-3e71-5030-8d04-1e8e3fc4323f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e2269a7-3e71-5030-8d04-1e8e3fc4323f@linux.intel.com>
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

On Mon, Apr 18, 2022, Sathyanarayanan Kuppuswamy wrote:
> > +static void detect_seam_ap(struct cpuinfo_x86 *c)
> > +{
> > +	u64 base, mask;
> > +
> > +	/*
> > +	 * Don't bother to detect this AP if SEAMRR is not
> > +	 * enabled after earlier detections.
> > +	 */
> > +	if (!__seamrr_enabled())
> > +		return;
> > +
> > +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
> > +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
> > +
> > +	if (base == seamrr_base && mask == seamrr_mask)
> > +		return;
> > +
> > +	pr_err("Inconsistent SEAMRR configuration by BIOS\n");
> 
> Do we need to panic for SEAM config issue (for security)?

No, clearing seamrr_mask will effectively prevent the kernel from attempting to
use TDX or any other feature that might depend on SEAM.  Panicking because the
user's BIOS is crappy would be to kicking them while they're down. 

As for security, it's the TDX Module's responsibility to validate the security
properties of the system, the kernel only cares about not dying/crashing.

> > +	/* Mark SEAMRR as disabled. */
> > +	seamrr_base = 0;
> > +	seamrr_mask = 0
> > +}
