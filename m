Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A34D6C7CA1
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 11:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjCXKbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 06:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjCXKau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 06:30:50 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD0320A1F
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:30:35 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3ed5cf9a455so96255e9.1
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679653833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k9STIq52C2hcQVb/lctxEDHruQQkkD4ezHmgZJrhofI=;
        b=GLiswA4P9BFb0qk156VaUVe66DCsypMWFG+dNI9O8F2bQ/SgFIom0WYCyEPj7ckN83
         KkRwGJTah2fv4wWNipa/7iG5FS6burxI4AQ8f0q3svjiXABiyCfINQhXmIo27euqjlNF
         Z3gRnWwZIGVQSVhw5+KxDcm1TvOX1WsQXrOcLVH8Mx/HFrX2eiEFDrn99OkD7QpZUKMi
         jxiV7Fkn2MLbJUP7lVwALJIcfqkxKZAlqT/7AQYc4567RPSWUdK4DeziRX+tAPchteSb
         HofCK2abqhSH33NgAbq5WN2JuxsJdHRSfxZ6E5rL62SEa5vwALKGLpnGMpBvfGAD/5pH
         +ndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679653833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9STIq52C2hcQVb/lctxEDHruQQkkD4ezHmgZJrhofI=;
        b=5/bdIEWiYUlZmxDSTZAnZJvuOdb3cBWp0xB26kwoZhT6x20d/HsLi+M0n6Wx3J5+YT
         x3PlRGDRTgYmIyc8P+1eGr8B3mrH7kqrfljohbW5NKYAvCvwi0lVyXJiiqGov8kt1fNp
         O13DRwBYz68Rz/Jxg2WFsE3vgzRycYJm0cVcxRfPzNZfyRSFpRlLYMt9UbN8mcbAZP88
         JKElDfL/A0EpdUStxhI2ZH1m7+oMii+gtW5u7+ErsrVvbOfvW1m7eWKdFyQt9X+DbJ8X
         eQ9C26XJajEpjxl7/RCE3nDMujIMk0Yx3xJqlqTwNFytnOcHHc0YFw3v2v04xktwQsL2
         1lYw==
X-Gm-Message-State: AO0yUKW5VfzCR2+OAuuCF2meaozAmTZ8ZCvdqdtP/Ccv3FKwxP8ZAyLv
        SmyGiUGmPT27NlUefUQqSO3VEDbcUIQukK7mLmqOfg==
X-Google-Smtp-Source: AK7set84Y2Mggq4Z4YS/1okH5kpSyO4DdtnWX/kX3WwewUR3AMZ+7IWBtaDva3qZpBJ08EnyiRA1Nw==
X-Received: by 2002:a05:600c:45cc:b0:3df:f3ce:be45 with SMTP id s12-20020a05600c45cc00b003dff3cebe45mr163953wmo.4.1679653833314;
        Fri, 24 Mar 2023 03:30:33 -0700 (PDT)
Received: from google.com (206.39.187.35.bc.googleusercontent.com. [35.187.39.206])
        by smtp.gmail.com with ESMTPSA id h10-20020adffa8a000000b002ce3d3d17e5sm18281411wrr.79.2023.03.24.03.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 03:30:32 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:30:11 +0000
From:   Keir Fraser <keirf@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>, kvm@vger.kernel.org,
        android-kvm@google.com
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
Message-ID: <ZB17s69rC9ioomF7@google.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com>
 <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
 <ZBCC3qEPHGWnx2JO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBCC3qEPHGWnx2JO@google.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 07:21:18AM -0700, Sean Christopherson wrote:
> On Tue, Mar 14, 2023, Jason Chen CJ wrote:
> > On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
> > 
> > > On Mon, Mar 13, 2023, Jason Chen CJ wrote:
> > > > There are similar use cases on x86 platforms requesting protected
> > > > environment which is isolated from host OS for confidential computing.
> > > 
> > > What exactly are those use cases?  The more details you can provide, the better.
> > > E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
> > > the pKVM implementation.
> > 
> > Thanks Sean for your comments, I am very appreciated!
> > 
> > We are expected 
> 
> Who is "we"?  Unless Intel is making a rather large pivot, I doubt Intel is the
> end customer of pKVM-on-x86.  If you aren't at liberty to say due NDA/confidentiality,
> then please work with whoever you need to in order to get permission to fully
> disclose the use case.  Because realistically, without knowing exactly what is
> in scope and why, this is going nowhere.  

This is being seriously evaluated by ChromeOS as an alternative to
their existing ManaTEE design. Compared with that (hypervisor == full
Linux) the pKVM design is pretty attractive: smaller TCB, host Linux
"VM" runs closer to native and without nested scheduling, demonstrated
better performance, and closer alignment with Android virtualisation
(that's my team, which of course is ARM focused, but we'd love to see
broader uptake of pKVM in the kernel).

 -- Keir

> > to run protected VM with general OS and may with pass-thru secure devices support.
> 
> Why?  What is the actual use case?
> 
> > May I know your suggestion of "utilize SEAM" is to follow TDX SPEC then
> > work out a SW-TDX solution, or just do some leverage from SEAM code?
> 
> Throw away TDX and let KVM run its own code in SEAM.
> 
