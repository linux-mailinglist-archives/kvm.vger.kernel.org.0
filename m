Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E266A521D41
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 16:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243242AbiEJPAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 11:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345194AbiEJPAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:00:35 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF00E12816C
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 07:22:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d22so16857499plr.9
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 07:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=96fSaQwSEKdzhJug6s/ISEl8NYk3c2RDSas8DqlcA5w=;
        b=g574joSyahf6XWUX/Lnob9ZLo6UrKXwHHmmJyn3M7gflnngYL0fXMZ1GNnLQlZNRnO
         lk1H5/5/wVOIblC31ckvcokOutL/YExJkjcuVR3T2aK7vXTFv5WsT2sm9GnRnSlUwAJL
         GIXZOHO5Rk8fbMXWLU/J8pwIFvck+ueAanIhtgjqHd90RDfeuHLW5zqqUefkfxGxXWdQ
         Yr2E5nzKPeusenjIgtCSSq6YxaNo97VjySQmB21ZsX7DbJSOQynOuVzf49YfJJhkCQVS
         7sh9FDYfv60HN0muf43DXOEQ7EI1i4Qkdr0Dq7qcDTmuP6SDwupLx+btugKqr0WD9g9p
         1iwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=96fSaQwSEKdzhJug6s/ISEl8NYk3c2RDSas8DqlcA5w=;
        b=m99BlnLeD9/282K6ALQnc0vQxp1d6WHKTTkAChfsrrpFjq9xCYF7DwgQkHExdgnsS4
         iyLDS4idyn9YGQpxbClxGw22YSnexxFoeBa42DuQJgacW1WMobSsNmmyrmKEUeRt0WQ3
         Gan6vY5zgsKaP4cqx5CU8M89GchGvQyvV9tTg5Ii8ZD5I+w9uS/H069vX0cT+4GABo73
         YyutdIJ+7mgBEPkxEPfeG9WWncOYXBSaZ6h0/ughZUG4wibn0LmbsE2PyJcakUTm4mBR
         CDacn9xk3xzZ0wCuKQ4dzjkLU8O+PqteoYIKi5+1VV3we2c18TxMtv4zsGEphtkHet2c
         Ii9A==
X-Gm-Message-State: AOAM533LkauR8DlAd7c9DGQFprNj7Txtb6QOMJ3JW6TG6exaOKLuT1QM
        PXJTG7pWsqbpc7LVIFiNLOHNSw==
X-Google-Smtp-Source: ABdhPJx7PsVQomRvckqYDAybqAGOiMLH95hlWgarTNYXO+eMC+95JlU0QlBLIWIa984tkMCt6p0LIg==
X-Received: by 2002:a17:90b:3e84:b0:1dc:5942:af0e with SMTP id rj4-20020a17090b3e8400b001dc5942af0emr235327pjb.61.1652192535114;
        Tue, 10 May 2022 07:22:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902bd0600b0015e8d4eb265sm2088260pls.175.2022.05.10.07.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 07:22:14 -0700 (PDT)
Date:   Tue, 10 May 2022 14:22:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <Ynp1E73OZtXudLUH@google.com>
References: <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic>
 <YmxzdAbzJkvjXSAU@google.com>
 <Ym0GcKhPZxkcMCYp@zn.tnic>
 <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 30, 2022, Jon Kohler wrote:
> 
> > On Apr 30, 2022, at 5:50 AM, Borislav Petkov <bp@alien8.de> wrote:
> > So let me try to understand this use case: you have a guest and a bunch
> > of vCPUs which belong to it. And that guest gets switched between those
> > vCPUs and KVM does IBPB flushes between those vCPUs.
> > 
> > So either I'm missing something - which is possible - but if not, that
> > "protection" doesn't make any sense - it is all within the same guest!
> > So that existing behavior was silly to begin with so we might just as
> > well kill it.
> 
> Close, its not 1 guest with a bunch of vCPU, its a bunch of guests with
> a small amount of vCPUs, thats the small nuance here, which is one of 
> the reasons why this was hard to see from the beginning. 
> 
> AFAIK, the KVM IBPB is avoided when switching in between vCPUs
> belonging to the same vmcs/vmcb (i.e. the same guest), e.g. you could 
> have one VM highly oversubscribed to the host and you wouldn’t see
> either the KVM IBPB or the switch_mm IBPB. All good. 

No, KVM does not avoid IBPB when switching between vCPUs in a single VM.  Every
vCPU has a separate VMCS/VMCB, and so the scenario described above where a single
VM has a bunch of vCPUs running on a limited set of logical CPUs will emit IBPB
on every single switch.
