Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FB558512A
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiG2NxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbiG2NxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:53:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43BF50073
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:53:14 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so5312745pjf.5
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=g4LT+6Vc6EAW7pOz6CH6o1bZ0MDiGNCAo1jgsVCoQag=;
        b=hmsmQLanMwnWzEgOVGlslRv1ShxsFCWhqRUllHlVRCXoJvohWgLtMX3mpxz5w1QAo5
         ojwpxTMrkr07++O/fg1cuHuCk1DTLX/980o0jnaaI45We6DdCyxajzhKUnk6eS9EPuo2
         dnf03PVazcRno8nVhB4adrUZGiGCGD75l3+FHAy/HzMVIzRv1Q7IQeBWQj06UXwNGXIZ
         MJClL/qy7kbIEVvmKjv/dblqvt+ITCVl61rbucdmybcyiD+CDdRKJJY/dGIuKDsiUSVZ
         HfNaVdJKO+jXoO+tHLasEqoHYwTjm5dxrKAbRC4cvJSzNKPJ8cn1zGqGHr12EUnI0vbC
         l9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=g4LT+6Vc6EAW7pOz6CH6o1bZ0MDiGNCAo1jgsVCoQag=;
        b=4BGxdC4uC9ZDtk8NJnIjpdT2NsjDEmAQC5LD6XXFrct49bRFE6ruUA1PWdXBS79s8b
         FsNnl5guiUOX9XT5A/xPH9FJNL7tALYCA+QcQ9FfJhsvbzOU5/dE15YcmitYxc2LzOcY
         LtAsJ3d/+tN/ie1ohD2gf7LV5bQoGrHgzBDwGIhpStWlp1toEyBfCy44wUbg3ArWGJNR
         ALai0tTYaaCTqXDz95fIZdjmeQmZzqXbUt9yj0E1akR6Ta6nrdPnTFGVDdMpBBe1scTK
         +ehsfzopm+djim2dgZOkLacWSFDn3VThTTrX/OjEFb+CotEhbIZE/PCzB7t4SWrk0HX8
         XIBw==
X-Gm-Message-State: ACgBeo2N6ioPFKe2PpNoVdJkVJ61uXYQaO8iSbhcFsC7UCEp1no/I0YM
        cjKu7NiQXIRLk1+pUyRDKtu8Ww==
X-Google-Smtp-Source: AA6agR6kysUOxI+yQ+wn8SjwdttWDeEfbpR2glp/K1ujc4LvCyuxBwvyKJzdpW02VhsqGY4qyhv2GA==
X-Received: by 2002:a17:903:40ce:b0:16e:c71b:8b0e with SMTP id t14-20020a17090340ce00b0016ec71b8b0emr228498pld.154.1659102794078;
        Fri, 29 Jul 2022 06:53:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u1-20020a170902e5c100b001618b70dcc9sm3684540plf.101.2022.07.29.06.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:53:13 -0700 (PDT)
Date:   Fri, 29 Jul 2022 13:53:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Shukla, Santosh" <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 5/7] KVM: SVM: Add VNMI support in inject_nmi
Message-ID: <YuPmRbBcUp931KMP@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-6-santosh.shukla@amd.com>
 <Yth2eik6usFvC4vW@google.com>
 <23b43ea0-0a92-e132-ada3-ebe86dbaf673@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b43ea0-0a92-e132-ada3-ebe86dbaf673@amd.com>
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

On Fri, Jul 29, 2022, Shukla, Santosh wrote:
> Hi Sean,
> 
> On 7/21/2022 3:11 AM, Sean Christopherson wrote:
> > On Sat, Jul 09, 2022, Santosh Shukla wrote:
> >> +	++vcpu->stat.nmi_injections;
> >> +	if (is_vnmi_enabled(svm)) {
> >> +		vmcb = get_vnmi_vmcb(svm);
> >> +		WARN_ON(vmcb->control.int_ctl & V_NMI_PENDING);
> > 
> > Haven't read the spec, but based on the changelog I assume the flag doesn't get
> > cleared until the NMI is fully delivered.  That means this WARN will fire if a
> > VM-Exit occurs during delivery as KVM will re-inject the event, e.g. if KVM is
> > using shadow paging and a #PF handle by KVM occurs during delivery.
> > 
> 
> Right,.
> 
> 
> For the above scenario i.e.. if VMEXIT happens during delivery of virtual NMI
> then EXITINTINFO will be set accordingly and V_NMI_MASK is saved as 0.
> hypervisor will re-inject event in next VMRUN.
> 
> I just wanted to track above scenario,. I will replace it with pr_debug().

No, this is normal (albeit uncommon) behavior, don't print anything.  Even if it
weren't normal behavior, pr_debug() is usually the wrong choice in KVM.
