Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F9850314C
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353792AbiDOVWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 17:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354043AbiDOVWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 17:22:33 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A227F3C703;
        Fri, 15 Apr 2022 14:19:54 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso7934903pjv.0;
        Fri, 15 Apr 2022 14:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gQjMse/tU1IHt4tZkhdWjeMaB5otgPpvVS0b4/z5Ptw=;
        b=FSxfRkR+oDX+rgDN9EG6Ss8iEba237QXZMX7KKHOtvtXZuNn66HR2x5xCM2y1VI4+R
         mBKBc+PVJQYi5Pj602EW5ymCIR8WHWSCBQG0Y7ivopjbyzmooHhy2U8NfJRxPO2TsqQ7
         eEtghjJiP0hFBefRThKYPukYArPaM8jNnzJ0G4yjf9X02PgwvQaqUJQAm7R5Yi+zcEpu
         v9qf0awsOhjNPWq41QhghUFEMf0na5WzbdYF4R0UUjEe6xT0PhzJ4AKf9dXnRziIaa0T
         XRGTUiLvwiLsy/7S8ghwYGJxt5Nsu1UBBJNBZd/yAYaBEJwCGNFAm/uaOjjWek25cR81
         7XPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gQjMse/tU1IHt4tZkhdWjeMaB5otgPpvVS0b4/z5Ptw=;
        b=5HVv6tKmvmeEb2AKbMDTqejR1w4wRl00PjLqX6X0FfPMwKzhj3IG2uVnmDcz0izuJF
         rbmi31dUil1FrZ1eXq9AgDYGSA1fDgc3BPcbKDuD5Lktq+AkircZrIz/1KWn4PLt9vH4
         rNkLlzaS9V9/vj3L6JJXF1Wvmb/VOltw7i+LnckWbkf+7qFXglKAjPpoQqFOLBclrRGE
         MDjgjGEF90e6PQ2ZXKjeFPHNu1Df8Kn3u6dqXWXUcEpEq9EGiZZRTIwZmNXBZXsd8O6b
         eZ5CGlpPGCcf9D20JLs5Avpjxtg0bbl6aNOpmu7K5Mb3VaeofqgAprZJRUCf6MKELQEV
         Szzw==
X-Gm-Message-State: AOAM531t/jD+aBQ8C7AVKJRPv8ooLYwlJu17GjklPJ6/NVkeTjlMZQ7u
        ArNV84gL3O3GuNMD2lcIMYY=
X-Google-Smtp-Source: ABdhPJyVdyfobNaoLYq0/yrSeS21r3R4JIrrKGURs6GCDVbQZa/3+rOhLvjvgk7i0An+QhVcppEuVg==
X-Received: by 2002:a17:90a:6402:b0:1c9:9377:dd0e with SMTP id g2-20020a17090a640200b001c99377dd0emr753895pjj.211.1650057593993;
        Fri, 15 Apr 2022 14:19:53 -0700 (PDT)
Received: from localhost (c-107-3-154-88.hsd1.ca.comcast.net. [107.3.154.88])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090ad99000b001bcbc4247a0sm5363455pjv.57.2022.04.15.14.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:19:53 -0700 (PDT)
Date:   Fri, 15 Apr 2022 14:19:47 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 000/104] KVM TDX basic feature support
Message-ID: <20220415211947.GA1182280@private.email.ne.jp>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <4a508ded-8554-2e54-8b61-50481e536854@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a508ded-8554-2e54-8b61-50481e536854@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 05:18:42PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Hi.  Now TDX host kernel patch series was posted, I've rebased this patch
> > series to it and make it work.
> > 
> >    https://lore.kernel.org/lkml/cover.1646007267.git.kai.huang@intel.com/
> > 
> > Changes from v4:
> > - rebased to TDX host kernel patch series.
> > - include all the patches to make this patch series working.
> > - add [MARKER] patches to mark the patch layer clear.
> 
> I think I have reviewed everything except the TDP MMU parts (48, 54-57).  I
> will do those next week, but in the meanwhile feel free to send v6 if you
> have it ready.  A lot of the requests have been cosmetic.

Thank you so much. I'm updating patches now.


> If you would like to use something like Trello to track all the changes, and
> submit before you have done all of them, that's fine by me.

Sure. I've created public trello board.
If you want to edit it, please let me know. I'll add you to the project member.

https://trello.com/kvmtdxreview

thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
