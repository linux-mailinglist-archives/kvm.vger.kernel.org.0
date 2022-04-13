Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768184FFE57
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 21:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiDMTEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 15:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiDMTEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 15:04:15 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FAD6972B
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:01:52 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so3276097pjb.1
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hSOfOlLhxFdBQNwXcbfVqYQzCbjgyv6/C366NTpHEnU=;
        b=BIS6RlcFX0XtejdNifJ+S+xQtgzA1W8+yy8v0OR+Rqn0O4sXLZQNJ4Tza+pctiwzlm
         Um7+bbIMlX5uuulscLMPu2OX/8BG61pIpXlgs6hwN8UtjZxQLhCobT1n//8cEy63qqyg
         P6PMXtuoNEv48Ud7hEyF8FNlPiTT3DfxOmLyXNjVe3hMNqBLCMJrkmw9nLmlA5nU/vAs
         vlJAuIKLNSciDYPR8HrimT7HNhEXrWyurnqPvdB08sNFArMvPG+EbuUb25WaKRypaWAU
         OPPDTWHKpaQJX/Af5gnDuGySoxcTOX51j/AFt1GNhP3uKrokGKc8/JeXU8gaBXM7aqid
         z4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hSOfOlLhxFdBQNwXcbfVqYQzCbjgyv6/C366NTpHEnU=;
        b=744yu8NN1RNIQx4uYxPiUM7QhJJRHkjSLOP5Y8CCkhWF6bCwhq7XKtEkmExI6NFF4v
         WFLjlH/vs5TJ+UGiWxMFEgD+EXuj2/lxLuQNhXcNdkRNw3tEKtAHCjrUokoXz1Pfxe5a
         7UyISVvddDj/wCGd1WRBAD9+q+rSPMQ/fBoxCpFff0nwFmLBU46s87S75TVBelmEjV1D
         ZXX2LlIiPIpPHTgnUAG61g5Ky/qZKwfdZO5G1MCfy7wEE/q4z+SchGu2gRDCvn+LTrSy
         XnGBYKhrEfnv0KSwrs8a0rDgJ9CqrAu33ZJGBrxNcTYBtYERFVLVVbNtlWcUiBluDhX6
         TkKg==
X-Gm-Message-State: AOAM532bJjFKAdcHHSPzW1qePQ/Uoq0P7eNRr1QdrriGkptx8sP0vgAV
        iRKbRY16jB302rV+xUx5M2MsGQ==
X-Google-Smtp-Source: ABdhPJwTjvd1Ev6egPJkZ7/dY56dTBERwCh86MEpzVuSDv1Aul7ugpKeIfo61kfyG+i+N6glbQkrgA==
X-Received: by 2002:a17:902:a712:b0:158:9e75:686c with SMTP id w18-20020a170902a71200b001589e75686cmr5560655plq.56.1649876511950;
        Wed, 13 Apr 2022 12:01:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm42761937pfh.23.2022.04.13.12.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:01:51 -0700 (PDT)
Date:   Wed, 13 Apr 2022 19:01:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 01/10] x86: Move ap_init() to smp.c
Message-ID: <YlceG2R7fH8+XxE/@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-2-varad.gautam@suse.com>
 <YlcZ83yz9eoBjmEt@google.com>
 <Ylcckbw3XXxcJiTL@google.com>
 <YlcdefdD4eqlL8U9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlcdefdD4eqlL8U9@google.com>
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

On Wed, Apr 13, 2022, Sean Christopherson wrote:
> On Wed, Apr 13, 2022, Sean Christopherson wrote:
> > On Wed, Apr 13, 2022, Sean Christopherson wrote:
> > > On Tue, Apr 12, 2022, Varad Gautam wrote:
> > > > @@ -142,3 +143,26 @@ void smp_reset_apic(void)
> > > >  
> > > >  	atomic_inc(&active_cpus);
> > > >  }
> > > > +
> > > > +void ap_init(void)
> 
> Sorry for chaining these, I keep understanding more things as I read through the
> end of the series.  Hopefully this is the last one.
> 
> Can this be named setup_efi_rm_trampoline()?  Or whatever best matches the name
> we decide on.  I keep thinking APs bounce through this to do their initialization,
> but it's the BSP doing setup to prep waking the APs.

Well that didn't take long.  Just realized this isn't unique to EFI, and it also
does the waking.  Maybe wake_aps()?  That makes smp_init() even more confusing
(I keep thinking that it wakes APs...), but IMO smp_init() is the one that needs
a new name.
