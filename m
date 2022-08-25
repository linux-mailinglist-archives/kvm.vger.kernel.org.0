Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CD25A161E
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 17:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbiHYPtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 11:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiHYPtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 11:49:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A382B69FC
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:49:43 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso5497289pjr.3
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=XnBcNRbuBOvQNrejHxj5gOQgFkqYtm3hqw7VV6S1TjM=;
        b=kbXKPxRB0MLEB91m/6PZh/suS+TQN85X/JCmkLxQGzBEMhG5pk3gX0daKdlWk4ZpzG
         pDvVMNXjPpDkLk75GEPwP3GhjhV8wXV5NKdQKVuNsdURpD+mSfjrv9wqil1rTCcmwuLZ
         PxkaflqQNNnHIK8Fsn4xpxj+pvDOv2gK5WkJvkdXeQFDXo7li5PTEbJSENicwIyxOW88
         zTcWN/m9IkgLWFqQ5zrTVTxdL37vlDqT14eItEVV5qQToKz6c2IyYjUrpBWN/MMdiweL
         kNsaRR1jKXZKn2KmH/u30v7z1zpyst4aXxUF6/2MZC8XqcDGx3siac0tzO4JFLRy++fj
         na6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=XnBcNRbuBOvQNrejHxj5gOQgFkqYtm3hqw7VV6S1TjM=;
        b=XwkMYFOKoiY9LcDGWl3bLKipTbm2hMcI1oO1cjstBaxc8hINiCW9vcdJ8u3ZkzYPmp
         OrjR3+L5xm4ZuPuMIbTwsneDsbYPfHYu0FWuubjgE3vzP6EuHpxTTE8IsSQb8SS9qVbI
         P3bA8lUdtZIFS9Ydz3cgI9WKLAGqbt0IOrinHj4csEfAoOaqfLwHaCnzzkmcim9pT6Mo
         svIAb7itJIezOwnHgRucwL7uIpzuYFvb4fSR2zNv65PsBBBBjt+OasOziZmfQVREryxU
         yoAnThrGQsoyscTGnTCNPU7DjdYADLIqNXJd1jmMlW3ZTkdnqj98eWNPHX/WYahRUNrk
         zR9Q==
X-Gm-Message-State: ACgBeo12BRI5tsNQmYmGzj+1Alc8fUOs4kw6Yp5KhrTeg3RQ5uwUuyjT
        PQ1578gQwc9TutI9ACWnUuGCGA==
X-Google-Smtp-Source: AA6agR7JCOLJ+n/2pdOTFgYwP1eo3mBpnb0G42ds19yiz204HmIBIeIk4KoejwCNvbrNeblvNkT8bw==
X-Received: by 2002:a17:902:7c94:b0:170:aed6:7e6c with SMTP id y20-20020a1709027c9400b00170aed67e6cmr4250792pll.10.1661442583026;
        Thu, 25 Aug 2022 08:49:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g5-20020a170902d1c500b0016eea511f2dsm14602650plb.242.2022.08.25.08.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:49:42 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:49:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Kai Huang <kai.huang@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Message-ID: <YweaEl48I7pxKMm8@google.com>
References: <20220818023829.1250080-1-kai.huang@intel.com>
 <YwbrywL9S+XlPzaX@kernel.org>
 <YweS9QRqaOgH7pNW@google.com>
 <236e5130-ec29-e99d-a368-3323a5f6f741@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <236e5130-ec29-e99d-a368-3323a5f6f741@intel.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Dave Hansen wrote:
> On 8/25/22 08:19, Sean Christopherson wrote:
> >>> This patch, along with your patch to expose AEX-notify attribute bit to
> >>> guest, have been tested that both AEX-notify and EDECCSSA work in the VM.
> >>> Feel free to merge this patch.
> > Dave, any objection to taking this through the KVM tree?
> 
> This specific patch?  Or are you talking about the couple of AEX-notify
> patches in their entirety?

I was thinking just this specific patch, but I temporarily forgot there are more
patches in flight.  It would be a bit odd to have effectively half of the AEX-notify
enabling go through KVM.

So with shortlog/changelog tweaks,

Acked-by: Sean Christopherson <seanjc@google.com>
