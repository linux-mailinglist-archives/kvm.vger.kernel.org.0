Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517D44BA4A5
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 16:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbiBQPld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 10:41:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238291AbiBQPlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 10:41:31 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AE82B2E38
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:41:16 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 75so5357321pgb.4
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GSlLfplsOOLuMoTCJXa0hQO7aoEhUgFZ0UfAir+9mn8=;
        b=Qzlxkk2BG4nIhKCKMXUoICWJGooUZN3uSuhjUrJI3t624YVIs5S58N9h8iyHTBuMBD
         uHVutlgvrd5r/gQ5+joSeFf/3uxsaog4MYgDe1f2Oh1tIT8QAYyTqA5C0YWrquyRMCK8
         xq12DNfyH2thhs0d3aYZUWWyrRw2NGpm5ZK/r9lX83nIYnusxiI2y9XCZODif1XiX9Yc
         UCGz9ujVdfPXoeJpp5NbFOKxq1+jhG9d6QUViSURCT+X7Xjox96jnCugatu4xoxbce2C
         v44eJqoKN6kQVyC4oH6r9sXbxkY74eHdJJ1h9ePxiuRxRhLl7NIpkQYqemdFBOHX8xOr
         BYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GSlLfplsOOLuMoTCJXa0hQO7aoEhUgFZ0UfAir+9mn8=;
        b=jBwWRkjQ9b0tkIQNZnRycJ++CSRkDL2Xew51ED0m3C7R1wtRhySsYDMeyoGfLIKMzH
         FtMG5f2CYLcPYV1uA2NR8HVRH/XDuGz2f3HJX176PVNphzk4GsAUNCOJloPdQNeXH2gb
         pifcgo/q2sV0v9DHGYgYJoE1l2GeQ+pTUGbovnZHsElGolBv6pIHpiHtqTgTFRdXDTkc
         hM9bYN47uqMOMW5wZ92r3a/yfiXDtrcdrL3xJQ0eMHJU+y/P3n3oYkqusrNWuxzNUFoI
         HCX6n4tsOKTZA2Dlg+bTXWQzrxjRUe28Y+mVBWX3Ll3qPKJyYilG2Hk0kRFBeMxqUQ3T
         Qy8g==
X-Gm-Message-State: AOAM530zRApNul0JHd4UMUPkUnj8ZJ4SORlDfX9nh7ai4rbr8I1nh/wS
        TMZXiKw/BQom4UiNUO4Wkksf6/2qQbjgAA==
X-Google-Smtp-Source: ABdhPJxeLXpOjVMZmx3Lyht9qoLvfiyVlO+cz4Vz+eeIWdoPmpXonzJaxJcliV2S/nyEiFxhzjQ3NA==
X-Received: by 2002:a65:4c4c:0:b0:35e:3c81:5b7f with SMTP id l12-20020a654c4c000000b0035e3c815b7fmr2953268pgr.162.1645112476195;
        Thu, 17 Feb 2022 07:41:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l8sm9079910pgt.77.2022.02.17.07.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 07:41:15 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:41:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Anton Romanov <romanton@google.com>, mtosatti@redhat.com,
        kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in
 always catchup mode
Message-ID: <Yg5sl9aWzVJKAMKc@google.com>
References: <20220215200116.4022789-1-romanton@google.com>
 <87zgmqq4ox.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgmqq4ox.fsf@redhat.com>
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

On Wed, Feb 16, 2022, Vitaly Kuznetsov wrote:
> Anton Romanov <romanton@google.com> writes:
> 
> > If vcpu has tsc_always_catchup set each request updates pvclock data.
> > KVM_HC_CLOCK_PAIRING consumers such as ptp_kvm_x86 rely on tsc read on
> > host's side and do hypercall inside pvclock_read_retry loop leading to
> > infinite loop in such situation.
> >
> > v2:
> >     Added warn

Versioning info goes in the "ignored" section, not the changelog.

> > Signed-off-by: Anton Romanov <romanton@google.com>
> > ---

This part is ignored by git.  Versioning info, and/or any commentary that doesn't
belong in the changelog, for a patch goes here.

> >  arch/x86/kvm/x86.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 7131d735b1ef..aaafb46a6048 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8945,6 +8945,15 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
> >  	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
> >  		return -KVM_EOPNOTSUPP;
> >  
> > +	/*
> > +	 * When tsc is in permanent catchup mode guests won't be able to use
> > +	 * pvclock_read_retry loop to get consistent view of pvclock
> > +	 */
> > +	if (vcpu->arch.tsc_always_catchup) {
> > +		pr_warn_ratelimited("KVM_HC_CLOCK_PAIRING not supported if vcpu is in tsc catchup mode\n");
> > +		return -KVM_EOPNOTSUPP;
> 
> I'm not sure this warn is a good idea. It is guest triggerable and
> 'tsc_always_catchup' is not a bug, it is a perfectly valid situation in
> the configuration when TSC scaling is unavailable. Even ratelimited,
> it's not nice when guests can pollute host's logs.

Agreed.  And if we want to alert the user/admin, it'd probably be better do so on
tsc_always_catchup first being set.  Doubt it's worth it though, assuming my other
patch to prevent KVM from setting tsc_always_catchup=true on non-ancient hardware
without userspace interaction gets merged.

> Also, EOPNOTSUPP makes it sound like the hypercall is unsupported, I'd
> suggest changing this to KVM_EFAULT.

Eh, it's consistent with the above check though, where KVM returns KVM_EOPNOTSUPP
due to the vclock mode being incompatible.  This is more or less the same, it's
just a different "mode".  KVM_EFAULT suggests that the guest did something wrong
and/or that the guest can remedy the problem in someway, e.g. by providing a
different address.  This issue is purely in the host's domain.
