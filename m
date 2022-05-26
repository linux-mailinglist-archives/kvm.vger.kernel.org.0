Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E59C535305
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbiEZR6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbiEZR6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:58:50 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14EF6585
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:58:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c14so2306546pfn.2
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lq+7ekq1VhjuWxGZnXvXBsDT3rIpmhuwIq/hZorQPlo=;
        b=CAh1C/E5od5VBEJgxeJ8MbdiDZZ1EQuNUR8pkcw+bA5GV2gsKgWSgRP+kdGTb9QRPM
         OklCzfebzDUf6pW6sYENj/s5ARFLihNOJNJRg4haR1lxEZAsmxlBEw15Xee9xW0bWHhq
         0KsCBcROn2Lecmhq7ZvGlErdnZ9NDdSKAdvvAMI4GGBuTwFGbNmSd0hWsmwH6k6iiY11
         KF+S8asuSsZWovYznf1NohyScSqSd6bG+Pol22WEisUwWfhiUG7ydU251QtYASuj3/Xg
         0Go6No2bELC8hrxNks8MDikJYbXE5sczV51yzeTv/wTo4ORZqExqYGS6GdIJXZREwYbk
         8xeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lq+7ekq1VhjuWxGZnXvXBsDT3rIpmhuwIq/hZorQPlo=;
        b=xLCKsbjyqkdfI7Ii3cKnlZCiFJCFneAn32sJ301ONAREUREB1xcehIE47i+/ylDVdM
         GQCOI8sqkazwc4uL4SM0m8wQtJ8eRtmd/R7UYnfp1nb4OoikMgoYNrYXv547nhPmvHHU
         JpJKCbBFR70ug+kw0t7jxUIS8jgFh2epf6H7MTaxHWoNjJmvefe5ZSVwL3PiOPz5zu1G
         MuQtYyFI1CkeY8JNkIrSI0Fk1xaKJXBcbxg4w771Q7mzDRWowL8gSVCzNWUszCAJvlSo
         CDnDtYGJke6MkbK2ZP8+Rzi19ifOPTBnmkWbPKkFsgGYvxAnd0IpBlI679zfjRN/w/3p
         m4gg==
X-Gm-Message-State: AOAM533s5ix30OOb1LKoznPnfH12l2kbciUeFP6xaV+xQLWabE/uuv8b
        BbPVZZidbJP6/+uJXj9Opx4ZQw==
X-Google-Smtp-Source: ABdhPJw2xE5/tkXGWmMwwE7CwWmW1BONubKITtCuhF5bXSJ2HzUvNfPdyGGhH/oFBiSstjDTqYi4yQ==
X-Received: by 2002:a05:6a00:1a08:b0:510:979e:f5b with SMTP id g8-20020a056a001a0800b00510979e0f5bmr39906114pfv.34.1653587928890;
        Thu, 26 May 2022 10:58:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d129-20020a623687000000b00519022b8076sm1778803pfa.134.2022.05.26.10.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:58:48 -0700 (PDT)
Date:   Thu, 26 May 2022 17:58:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 2/4] KVM: arm64: Dirty quota-based throttling of vcpus
Message-ID: <Yo+/1Uf7J3pBwq8N@google.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
 <20220521202937.184189-3-shivam.kumar1@nutanix.com>
 <87fskzmmgf.wl-maz@kernel.org>
 <c9f4b959-7282-231c-024e-810ddb8024c6@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9f4b959-7282-231c-024e-810ddb8024c6@nutanix.com>
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

On Thu, May 26, 2022, Shivam Kumar wrote:
> 
> On 24/05/22 12:44 pm, Marc Zyngier wrote:
> > On Sat, 21 May 2022 21:29:38 +0100,
> > Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
> > > Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
> > > equals/exceeds dirty quota) to request more dirty quota.
> > > 
> > > Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> > > Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> > > Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> > > Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> > > Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> > > ---
> > >   arch/arm64/kvm/arm.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index ecc5958e27fe..5b6a239b83a5 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -848,6 +848,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> > >   	ret = 1;
> > >   	run->exit_reason = KVM_EXIT_UNKNOWN;
> > >   	while (ret > 0) {
> > > +		ret = kvm_vcpu_check_dirty_quota(vcpu);
> > > +		if (!ret)
> > > +			break;
> > >   		/*
> > >   		 * Check conditions before entering the guest
> > >   		 */
> > Why do we need yet another check on the fast path? It seems to me that
> > this is what requests are for, so I'm definitely not keen on this
> > approach. I certainly do not want any extra overhead for something
> > that is only used on migration. If anything, it is the migration path
> > that should incur the overhead.
> > 
> > 	M.
> I'll try implementing this with requests. Thanks.

I've no objection to using a request, avoiding the extra checks is quite nice,
and x86's fastpath loop would Just Work (though VMX's handle_invalid_guest_state()
still needs manually checking).

The only gotchas are that it'll likely require a small amount of #ifdeffery, and
the quota will need to be "temporarily" captured in 'struct kvm_vcpu' because
there's no guarantee that the next exit to userspace will be due to the dirty
quota, i.e. something else might ovewrirte the exit union in vcpu->run.
