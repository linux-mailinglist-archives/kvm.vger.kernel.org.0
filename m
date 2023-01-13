Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D5D669C26
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjAMP3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 10:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjAMP2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 10:28:22 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38B977D03
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 07:21:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o18so1583708pji.1
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 07:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g9YfzH5zKGAWD5WagxwC+0aZDoyNg2SDmBAwauSl/+s=;
        b=SESCF6u/Xps5hlU0zKsOMf7UJvRF43RHivcNYz3gp7zAC2kSF8CAU6ed+Q1iPdmGKS
         PBzxqZeeSV1nFsICGTZw4J+n4aeznS/XVOHz2+sKct9j3PkprHH20M4cGvQWXzjBI0D3
         yjUb2tt3TXo43k/g1F9QaD9qufjPkwMaFC6k3c3uwzgAW0pPOtSKFH0wEm8HOIDNIS8C
         XfqOipeIpoQ7fitlgrwvoFcwBfqZSbFIfcFma4cjVX+ul/XKTWE30xSc8ty1h5fojb+N
         XkQKkShuVkABQOZ5by5Ggl6pMUtxOPyJ8zpmOq3JK+NpfLvLV3wauTmeloiA3HdQeoe9
         HZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9YfzH5zKGAWD5WagxwC+0aZDoyNg2SDmBAwauSl/+s=;
        b=IgqFqvpXwzPGVZBqvlozae3RdaMBVx70eaz0RVpJ5vx0a4LQZGDJpofsMu+ryZGaby
         HSLh6ajcnv2s56FRNQsH7rDmmeY6q8RXr7V9dcGmPV7gzxMopZEK13/Ia0GJ8zaVrulK
         MwJUpq5kI8tcC21W+/Q04ay83iYwdQvCeOccAjWsZ129P2d6hJ4kddjp81imvgLPlxfL
         POnG2uOyW+CzNZ508IieFhsucPLH6tljJbcgh2D08SL++tnLbCJS4ZE20rqS4rFCp3Ww
         buqBQqbhr7PObr6yyL840oBJTZFAUq64ObZRhA+RV2d1qvXRqWF/8mZhWkp3+unJsL4X
         IFLQ==
X-Gm-Message-State: AFqh2kqlmM3MSicS3YWdTE1YK1rWiz+uG7QkVLCCdsgHh+5kUzbo7R8u
        WfsrW689Wsr69HWTZtZjEbkEKsQo4jETlsbP
X-Google-Smtp-Source: AMrXdXtl4mEVlVyUN6ZBZk69yfDOipBvbK+FFzqa2vsCfOmdq7h0HOIN0AWuzCCExEXpk+FwXQOzEw==
X-Received: by 2002:a17:903:2614:b0:193:256d:8afe with SMTP id jd20-20020a170903261400b00193256d8afemr1189233plb.2.1673623318408;
        Fri, 13 Jan 2023 07:21:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902b18700b0019335832ee9sm9954324plr.179.2023.01.13.07.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 07:21:57 -0800 (PST)
Date:   Fri, 13 Jan 2023 15:21:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 013/113] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
Message-ID: <Y8F3Eo2lKB4hupQI@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <241994f1f6782753f3307fe999a3dad434477c16.1673539699.git.isaku.yamahata@intel.com>
 <20230113144712.00006f41@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113144712.00006f41@gmail.com>
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

On Fri, Jan 13, 2023, Zhi Wang wrote:
> On Thu, 12 Jan 2023 08:31:21 -0800 isaku.yamahata@intel.com wrote:
> > @@ -132,6 +136,31 @@ static struct notifier_block tdx_memory_nb = {
> >  	.notifier_call = tdx_memory_notifier,
> >  };
> >  
> > +/* TDX KeyID pool */
> > +static DEFINE_IDA(tdx_keyid_pool);
> > +
> > +int tdx_keyid_alloc(void)
> > +{
> > +	if (WARN_ON_ONCE(!tdx_keyid_start || !nr_tdx_keyids))
> > +		return -EINVAL;
> 
> Better mention that tdx_keyid_start and nr_tdx_keyids are defined in
> another patches.

Eh, no need.  That sort of information doesn't belong in the changelog because
when this code is merged it will be a natural sequence.  The cover letter
explicitly calls out that this needs the kernel patches[*].  A footnote could be
added, but asking Isaku and co. to document every external dependency is asking
too much IMO.

[*] https://lore.kernel.org/lkml/cover.1670566861.git.kai.huang@intel.com
