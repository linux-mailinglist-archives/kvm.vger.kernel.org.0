Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A42575690
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 22:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiGNUsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 16:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiGNUsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 16:48:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216C46D54C
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 13:48:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so9699774pjr.4
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 13:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mSRou1PhzsYjm7k/grZYwfjL/pwkxUatLT38df/fPoI=;
        b=pBGoXZdTh2ue9+c7H3VZEU5J6f4gMUBXHGUoPjJIGhDY8uAT3LxEHkL5gR2z/kKn2O
         /oWTpOYtUTH9PwycJPyXH6pqnqvsUY14Q7KT0+0ky554VNtXa06Joa2XYzKiw9cUrtdS
         6LNeVAmlGJRMquH8hyrvz/nBpeXuYZ9W6sZ8X2/5oAwJmQAIn5CTAkTekW92AD0CSFTo
         FgJRK9M68Jj5c9QZCkzHnkZheJs5YiGK99a6nEEThYpBSAz8J1Z+AkYS2TtcS+2mGpze
         yIZk6lZqJlkb3eKaHScjqar0vR7OKJBii/ZgsoTFlbp8Zrmd28UXpqQX876L8wd6MeRT
         HGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mSRou1PhzsYjm7k/grZYwfjL/pwkxUatLT38df/fPoI=;
        b=o3ScRdg01r/NM8qOZpn/jlhFHHwKbMmG/zml9Ybh6exaGgg69a1aDBVE4NsbLJupNd
         RnJhwNIHVkzKnSqClA7PZz8W0e53/rrgQ+eaOlpOggoTxrjAp+f9a+KnirlaYLBlKJHS
         Ho2sxPQhWtUU9+EA8onJvhA/r0sfgyO9ov3dIuMUT4wOzY1bn/j531/7+PiRZWOTCrea
         2Lk2JbXg/6YOnlrRpP68d2FmQjafQtAH4+UijZIcH+LBzb1/y3jZ7cnRdDq02Ur/GD+r
         fB+vqAvhFm/ABQRXZDbFI0pT/LQNV0iLeipzVu2/qmVLGlyW+A2W9tqQ88wtvgis0cws
         7J0Q==
X-Gm-Message-State: AJIora/ImQk+kvAlYHW+rLNhbXWhEb05OywmFlMNMLb5YEnCMw2taRS0
        6Ht7H/1jV/fBTk2Ub12QVyxHyw==
X-Google-Smtp-Source: AGRyM1t6lm6gtW7mhlQX+tJ8yq+NHR/YlGDlJZGmx0AZnqYEErBsfIaRObkiVIjHGPdA9qtPK4nKGw==
X-Received: by 2002:a17:903:451:b0:16c:b873:4a8 with SMTP id iw17-20020a170903045100b0016cb87304a8mr2962140plb.47.1657831688513;
        Thu, 14 Jul 2022 13:48:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p13-20020a63e64d000000b0040c9df2b060sm1831377pgj.30.2022.07.14.13.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 13:48:07 -0700 (PDT)
Date:   Thu, 14 Jul 2022 20:48:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YtCBBI+rU+UQNm4p@google.com>
References: <20220521202937.184189-2-shivam.kumar1@nutanix.com>
 <87h75fmmkj.wl-maz@kernel.org>
 <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
 <878rqomnfr.wl-maz@kernel.org>
 <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org>
 <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
 <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
 <YtBanRozLuP9qoWs@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtBanRozLuP9qoWs@xz-m1.local>
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

On Thu, Jul 14, 2022, Peter Xu wrote:
> Hi, Shivam,
> 
> On Tue, Jul 05, 2022 at 12:51:01PM +0530, Shivam Kumar wrote:
> > Hi, here's a summary of what needs to be changed and what should be kept as
> > it is (purely my opinion based on the discussions we have had so far):
> > 
> > i) Moving the dirty quota check to mark_page_dirty_in_slot. Use kvm requests
> > in dirty quota check. I hope that the ceiling-based approach, with proper
> > documentation and an ioctl exposed for resetting 'dirty_quota' and
> > 'pages_dirtied', is good enough. Please post your suggestions if you think
> > otherwise.
> 
> An ioctl just for this could be an overkill to me.
>
> Currently you exposes only "quota" to kvm_run, then when vmexit you have
> exit fields contain both "quota" and "count".  I always think it's a bit
> redundant.
> 
> What I'm thinking is:
> 
>   (1) Expose both "quota" and "count" in kvm_run, then:
> 
>       "quota" should only be written by userspace and read by kernel.
>       "count" should only be written by kernel and read by the userspace. [*]
> 
>       [*] One special case is when the userspace found that there's risk of
>       quota & count overflow, then the userspace:
> 
>         - Kick the vcpu out (so the kernel won't write to "count" anymore)
>         - Update both "quota" and "count" to safe values
>         - Resume the KVM_RUN
> 
>   (2) When quota reached, we don't need to copy quota/count in vmexit
>       fields, since the userspace can read the realtime values in kvm_run.
> 
> Would this work?

Technically, yes, practically speaking, no.  If KVM doesn't provide the quota
that _KVM_ saw at the time of exit, then there's no sane way to audit KVM exits
due to KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.  Providing the quota ensure userspace sees
sane, coherent data if there's a race between KVM checking the quota and userspace
updating the quota.  If KVM doesn't provide the quota, then userspace can see an
exit with "count < quota".

Even if userspace is ok with such races, it will be extremely difficult to detect
KVM issues if we mess something up because such behavior would have to be allowed
by KVM's ABI.

> > ii) The change in VMX's handle_invalid_guest_state() remains as it is.
> > iii) For now, we are lazily updating dirty quota, i.e. we are updating it
> > only when the vcpu exits to userspace with the exit reason
> > KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.
> 
> At least with above design, IMHO we can update kvm_run.quota in real time
> without kicking vcpu threads (the quota only increases except the reset
> phase for overflow).  Or is there any other reason you need to kick vcpu
> out when updating quota?

I'm not convinced overflow is actually possible.  IMO the current (v4) patch but
with a REQUEST instead of an in-line check is sufficient.
