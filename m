Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0795136D3
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 16:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348316AbiD1O23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 10:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348308AbiD1O22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 10:28:28 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138A213CCE
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 07:25:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q12so4092666pgj.13
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 07:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TlawIu8gUQdtMxZhaj9GVkTl4M/PnXrCnZW+L5pZKe0=;
        b=tKZ1Q2krSUMLYZ6CSInNA0TRI1pjrsEg7+OqZ8ze8ewZGs+I86Z0NhYlnUsFJ9/lEI
         TNURtOJoogb52Y7Kwpiyz6Jb+YTfNOc0mBQWEFsiBYDrd+P9/qiUvCybpaXHtnKxID8c
         Id315fHpOrKcHEh8Q1ZcImwdC0G396PPk8cRO1Pbi08i0ITda+o2d7EzUjpf6q59Kabu
         0qeUkMSPq8p5kX33jjNK1DQvo56WWZ/22LDg/zUOAFlPE9oEYsdWwDy6soUlvHtuWQD5
         EquFgQgQXuSC3M+C5DdmMvUHPH4IeyhMbRZaZmzBlauiBPL5OKEdhWwIKBpFWYRwOWrr
         H4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TlawIu8gUQdtMxZhaj9GVkTl4M/PnXrCnZW+L5pZKe0=;
        b=BEBOPb4Fx8vqJtQGQxPl3vwS90AXdICabt5W9/Jc3H70cAlT/TZEVF9mccOllwYxy0
         bmm3id/vL3SOZxSYm8pcTyVd/OTNvF9IEjC2a6EYLBP6F3PCFBM4zEMCyspmTcubTerN
         NJBJtvWwUKCS8rh5gtNkLA0cldjywpyj6IOusCwnwIcJTAN6tngo2pTb8ZwSQlJaFv/1
         IITKDGV8d2SGBfxsUqeg7mWTU5wjWLMydeAIqFLJw4SzFafIVzaZ16FgmIfd+tnXJRBN
         365KmUQ34TQfk0kVt9ReTzXbsWNxCfEPeqcnyi6fWbelUHHbAzhFJ84eQCV4iM5Ti9Pg
         ay6A==
X-Gm-Message-State: AOAM530VMgZ4tAOdMQdk5a5K7IYDqDP00JCTg2iZHycoI35fAo0br7zz
        lImN0GFkY1b5nSWi7kGnq1UorQ==
X-Google-Smtp-Source: ABdhPJyF9oLJ1Bh5rjVR522O+z3xuw2GtfFl9NHA0CBZ6FswvOiHNlk9DB1Jx8TyNlFm/XGsktvEbg==
X-Received: by 2002:a65:6946:0:b0:39d:a0c3:71f with SMTP id w6-20020a656946000000b0039da0c3071fmr28007435pgq.160.1651155912175;
        Thu, 28 Apr 2022 07:25:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v21-20020a631515000000b003c14af50603sm3147541pgl.27.2022.04.28.07.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:25:11 -0700 (PDT)
Date:   Thu, 28 Apr 2022 14:25:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 05/11] KVM: SVM: Re-inject INT3/INTO instead of
 retrying the instruction
Message-ID: <YmqjxNQiMABl+tX7@google.com>
References: <20220423021411.784383-1-seanjc@google.com>
 <20220423021411.784383-6-seanjc@google.com>
 <051f508121bcf47d8cbc79ee2c0817aafbe5af48.camel@redhat.com>
 <9553b164-67a6-3634-34c5-f7319ce2dc60@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9553b164-67a6-3634-34c5-f7319ce2dc60@maciej.szmigiero.name>
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

On Thu, Apr 28, 2022, Maciej S. Szmigiero wrote:
> On 28.04.2022 11:37, Maxim Levitsky wrote:
> > On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
> > > @@ -1618,7 +1644,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> > >   	nested_copy_vmcb_control_to_cache(svm, ctl);
> > >   	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> > > -	nested_vmcb02_prepare_control(svm, save->rip);
> > > +	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip);
> > 
> > Is this change intentional?
> 
> It looks to me the final code is correct since "svm->vmcb->save"
> contains L2 register save, while "save" has L1 register save.
> 
> It was the patch 1 from this series that was incorrect in
> using "save->rip" here instead.

Yeah, I botched the fixup.
