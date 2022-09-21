Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8896F5C0099
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiIUPAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiIUPA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:00:26 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD70B491D9
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:00:08 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id e68so6210132pfe.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ZOknaCryBKAmeWlgxRHW7gHjFXTydOeqelKEYGngjXY=;
        b=PUy7PwdFlbjhMX+HV+EVVByukRTiTcclVk3Gh3p29DOE3kIfB0GQWHxiBypE8wQ1I2
         Z5KsAhe1HJRtTwOCCXQgvQEzICZJtmMFMOpDNQxGCsTzN/b/f+FD0mW6fiXKpEWlRd3G
         1hbZjt6pUwie9IkNCMPRDBPRr4YHkFKa1A1n8eqWs2/IBaB0pJ8wbZyvex1sCP9EH9l6
         kFM+ajhQLhkRUtyScLSy4cUh4d7F40UEFDeYx/rloGyLfbI/90SvFmQ86dIlhrFt5ZrW
         pU1sv0zA8Z0uwHPeyZFnsh8JB1kcn4F5q3BI+r644UPVJex3SCEzi3X6T7dCFHMw73hQ
         9FCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZOknaCryBKAmeWlgxRHW7gHjFXTydOeqelKEYGngjXY=;
        b=WbpxE6xYqijEAxBr+QwS2xPv4zuOo4P5C/0s35m7V5zmMJrURKwu/Pv0ORsAPmB/TH
         KN5b/B0SPyfMIQSwp+uqGqzzImulmiMafwAHbK16PNJ6A3xCKr3W0pAEqOfY8WU5GV7W
         nnVPbYOQSSwIZWtqgmnX8GdWHypk51VUWLtA9EC/it6hwmvN1G0spc52EVU7VevJw/8q
         2oct7ZrJiyVc4jTlFwkQ+4mChdf+S5M3gPXWaib4cnX5w6eR/GlRKgSnKMXMcX4NE+k7
         ufoQkozdYrkiexVWM5miusTGaCsfdr/KUfepjwren1gG67JrTj9K3TQ0+29WaadI6XXZ
         VQ6g==
X-Gm-Message-State: ACrzQf2zDJnz9xyx/m4DYsdfrPUDiNM0x5RFSKSO1JHaHZGkYiw2SLnH
        drUH0qYaoFHUZbVUVcnUdpWfPA==
X-Google-Smtp-Source: AMsMyM6IzBR+IPGklvkXyceN25rdGLZW+kwuaS+8kPvv30SaIVCr6t2lDehTPAThSJ/06p88g02mIw==
X-Received: by 2002:a63:e352:0:b0:42b:dc03:cc38 with SMTP id o18-20020a63e352000000b0042bdc03cc38mr24169745pgj.545.1663772407953;
        Wed, 21 Sep 2022 08:00:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v9-20020aa799c9000000b00540d03f522fsm2304782pfi.66.2022.09.21.08.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 08:00:07 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:00:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm/x86: reserve bit
 KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
Message-ID: <Yysm8/Nkt6EUI5+k@google.com>
References: <20220908114146.473630-1-kraxel@redhat.com>
 <YxoBtD+3sgEEiaFF@google.com>
 <20220909050224.rzlt4x7tjrespw3k@sirius.home.kraxel.org>
 <20220921134246.xibospqoktp4wjie@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921134246.xibospqoktp4wjie@sirius.home.kraxel.org>
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

On Wed, Sep 21, 2022, Gerd Hoffmann wrote:
> On Fri, Sep 09, 2022 at 07:02:24AM +0200, Gerd Hoffmann wrote:
> > On Thu, Sep 08, 2022 at 02:52:36PM +0000, Sean Christopherson wrote:
> > > On Thu, Sep 08, 2022, Gerd Hoffmann wrote:
> > > > -#define KVM_HINTS_REALTIME      0
> > > > +#define KVM_HINTS_REALTIME                      0
> > > > +#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID  1
> > > 
> > > Why does KVM need to get involved?  This is purely a userspace problem.
> > 
> > It doesn't.  I only need reserve a hints bit, and the canonical source
> > for that happens to live in the kernel.  That's why this patch doesn't
> > touch any actual code ;)

The issue is that this "hint" effectively breaks other VMMs that already provide
an accurate guest.MAXPHYADDR.

> > > E.g. why not use QEMU's fw_cfg to communicate this information to the
> > > guest?
> > 
> > That is indeed the other obvious way to implement this.  Given this
> > information will be needed in code paths which already do CPUID queries
> > using CPUID to transport that information looked like the better option
> > to me.
> 
> I'd like to move forward with this.
> 
> So, any comment further comments and opinions?
> Is it ok to grab a hints bit given the explanation above?
> Or should I go for the fw_cfg approach?

My strong preference is the fw_cfg approach, or if the guest side really wants to
use CPUID, have QEMU define it's own CPUID signature and provide QEMU-specific
hints/quirks that way.
