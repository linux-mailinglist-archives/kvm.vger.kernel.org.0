Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABF751537D
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379944AbiD2SXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379774AbiD2SXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:23:02 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6536BD0A99
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:19:43 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p6so7806196plf.9
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wBht/QJpKirnQLRjfU3qpuPFg9KVLlBJOHxobySJY84=;
        b=r7pzjeEkU56Xb/PrhsyeDT3rj09eyhkVOOf0c9svwGplQYdNJteW3ugc9U+C8hivVT
         3Mrr0tnEK/GrhuqlPEIeeQs3+x1u8NuGrbxafMRv4MHcs6KPq8HlXZAedK+JwJ1cvL5S
         V1mtlsbCRaz1aGXyrKHvizHqdvZTw4DHpcXI2A5x+PftjUVXFrczZzXU/MGYemogzsk3
         vz37LiqE8poSl+Wp+M/APmNHWeRuSE/tTYhpsjnq2P9cUumI3ezmDpne8lCw77Yc1Au0
         mxgaVRaoMfyIZHLISRiDb2E0MIAP43ZmJy/rD9V7X2XmW9swkIWlKd67VwVeY+9GwgK7
         lNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wBht/QJpKirnQLRjfU3qpuPFg9KVLlBJOHxobySJY84=;
        b=Yq3fUkl7CfY/uLbvJcNnpXSFSl7p0j6ejJe0fv6uL2kSYPy8Zum3cvlt/H0FoYp5Q1
         K1UFhPcenKoOxH9oNFzPKSd9DrYlXxDEnvDFtz85jgtk28J68GBbFZbku6ixECC9svK/
         OZNaebDuwJDHjTyslf9t5MayXR2fO2y7CVbanqHlU0yZDk0P7zIWpQNjpBIGE4QHvUv8
         KNGqXSP1zZrd9j9y8rOzl0V1+Z9ZgJd90eBjyfeh3T8OQho3HHMOOfqR+pQnXl4eQx2N
         PBe473+PcwuRlke+l1bf2REbactl+oUfGvG0lpc5puDg9gwvPEHSWBqAR/asPVIN5waF
         D5dw==
X-Gm-Message-State: AOAM5331ZOhAespQ0w8KrVTcNygJB5vz1M7vD62ADBRCX3fdciQp5pm5
        X3FPhKUzUzG8cXhMOFDjTNaCpA==
X-Google-Smtp-Source: ABdhPJzIbOlJ2QDNab19z2WyabpDVNPH1SwLU2cRelG7TFhZ87ku6YiqDSuoNAqPH7kzRGC4ljGIlw==
X-Received: by 2002:a17:903:1109:b0:15e:7c4b:5045 with SMTP id n9-20020a170903110900b0015e7c4b5045mr641211plh.3.1651256382703;
        Fri, 29 Apr 2022 11:19:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u19-20020a63b553000000b003c14af50616sm6518855pgo.46.2022.04.29.11.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 11:19:41 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:19:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Subject: Re: [PATCH v3 13/21] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Message-ID: <YmwsOo4TCq1/5hgd@google.com>
References: <cover.1649219184.git.kai.huang@intel.com>
 <ffc2eefdd212a31278978e8bfccd571355db69b0.1649219184.git.kai.huang@intel.com>
 <c9b17e50-e665-3fc6-be8c-5bb16afa784e@intel.com>
 <3664ab2a8e0b0fcbb4b048b5c3aa5a6e85f9618a.camel@intel.com>
 <5984b61f-6a4a-c12a-944d-f4a78bdefc3d@intel.com>
 <Ymv2h1GYCMQ9ZQvJ@google.com>
 <c875fc4a-c3c0-dab1-c7cb-525b0bff5ae3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c875fc4a-c3c0-dab1-c7cb-525b0bff5ae3@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022, Dave Hansen wrote:
> On 4/29/22 07:30, Sean Christopherson wrote:
> > On Fri, Apr 29, 2022, Dave Hansen wrote:
> ...
> >> A *good* way (although not foolproof) is to launch a TDX VM early
> >> in boot before memory gets fragmented or consumed.  You might even
> >> want to recommend this in the documentation.
> > 
> > What about providing a kernel param to tell the kernel to do the
> > allocation during boot?
> 
> I think that's where we'll end up eventually.  But, I also want to defer
> that discussion until after we have something merged.
> 
> Right now, allocating the PAMTs precisely requires running the TDX
> module.  Running the TDX module requires VMXON.  VMXON is only done by
> KVM.  KVM isn't necessarily there during boot.  So, it's hard to do
> precisely today without a bunch of mucking with VMX.

Meh, it's hard only if we ignore the fact that the PAMT entry size isn't going
to change for a given TDX module, and is extremely unlikely to change in general.

Odds are good the kernel can hardcode a sane default and Just Work.  Or provide
the assumed size of a PAMT entry via module param.  If the size ends up being
wrong, log an error, free the reserved memory, and move on with TDX setup with
the correct size.

> You can arm-wrestle the distro folks who hate adding command-line tweaks
> when the time comes. ;)

Sure, you just find me the person that's going to run TDX guests with an
off-the-shelf distro kernel :-D
