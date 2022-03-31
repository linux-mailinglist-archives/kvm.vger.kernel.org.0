Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471C94EDDA1
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 17:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbiCaPoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 11:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbiCaPmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 11:42:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915A5C625F
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 08:37:30 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id p8so22418631pfh.8
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 08:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kj2SlYQeTe0c/VZuVzdXe4XjfgpJ1WwXsE5TNwFDkEM=;
        b=IjMlm+tdzexEH6QTNCon1We60FdSxrq/q2yHIIyjhtEKcFifzdOfMnZEr1zULpHttT
         TKc89m8TBFHmEYNTj8zi4SSYo+++rxoB4sw2sMcGD3kb8F6OOAcgI2sSa0y+kiElWXNg
         QDj8LbHd7bj5QawsFS0w6DjSrWIoO7gt3/zg2lE0ialvNJu7r4q+aJxCor4Qdcfj1/lm
         hrrg9hSaQtqfpv5cN2/ml4OOTonNVwmLMeb4W1cGFxK+vaaX8tn8XXDySP8n6ACvS1aK
         opGAhvtNDmLK2av4iREFMPlQxLHs6XoTtmO3Q8zM2VN/WJZwe3zMtqg/V8TRBAtTkEft
         PeuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kj2SlYQeTe0c/VZuVzdXe4XjfgpJ1WwXsE5TNwFDkEM=;
        b=kPwqAV+YmHbTLalXJrkBjMO28UPNZLe+JtqS6FAj56NhFakpkWSG9xJayNvvZTmoA2
         P94xMvMv/UL5/N5YtFyBT0qD05uK8ZW+BIxofzNp40IK1szTRWc718FhVcQfCIy84oTA
         zIyOrCWZXxxdcA04H/dH/ffA0RL1R6bDJ6y/euhjB8PVuc8SSTT9mfhzBzk7rHPEm6jH
         nagrbB3fd6sV/SlGwt2Zv6VFdqzK4VHDFPHdPkhK+O732DQJVqDEJ9uYOsJMyhdU2EdC
         vz9NHge6usyvR8+r/RroqV7ZPkMbGWrEZlaVuFGRrtUy6gl9mTvp2uawkVPaCmOUC9g6
         KCTw==
X-Gm-Message-State: AOAM533Gr74VyzWRgSX9jsXW3Km7AyncUa+zTENljJ/4gPKIkKhzDZWK
        lHZLOXgiaOXRu8ixoG1+hT3qJQ==
X-Google-Smtp-Source: ABdhPJyzlveTa0/9WEU5iVzJxjWSfEaJ0Sg7Dj9XtakZXWY9//LXk4rW62HCko9WXHK7xjdxynKHMA==
X-Received: by 2002:a63:5b63:0:b0:378:5645:90f6 with SMTP id l35-20020a635b63000000b00378564590f6mr11234181pgm.505.1648741048579;
        Thu, 31 Mar 2022 08:37:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l6-20020a17090a660600b001c985b0cb53sm10209446pjj.26.2022.03.31.08.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:37:27 -0700 (PDT)
Date:   Thu, 31 Mar 2022 15:37:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YkXKtC8PCfIUMs8D@google.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
 <YkT1kzWidaRFdQQh@google.com>
 <72d72639-bd81-e957-9a7b-aecd2e855b66@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72d72639-bd81-e957-9a7b-aecd2e855b66@nutanix.com>
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

On Thu, Mar 31, 2022, Shivam Kumar wrote:
> > > +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> > > +		return 1;
> > I don't love returning 0/1 from a function that suggests it returns a bool, but
> > I do agree it's better than actually returning a bool.  I also don't have a better
> > name, so I'm just whining in the hope that Paolo or someone else has an idea :-)
> I've seen plenty of check functions returning 0/1 but please do let me know
> if there's a convention to use a bool in such scenarios.

The preferred style for KVM is to return a bool for helpers that are obviously
testing something, e.g. functions with names is "is_valid", "check_request", etc...
But we also very strongly prefer not returning bools from functions that have
side effects or can fail, i.e. don't use a bool to indicate success.

KVM has a third, gross use case of 0/1, where 0 means "exit to userspace" and 1
means "re-enter the guest".  Unfortunately, it's so ubiquitous that replacing it
with a proper enum is all but guaranteed to introduce bugs, and the 0/1 behavior
allows KVM to do things liek "if (!some_function())".

This helper falls into this last category of KVM's special 0/1 handling.  The
reason I don't love the name is the "check" part, which also puts it into "this
is a check helper".  But returning a bool would be even worse because the helper
does more than just check the quota, it also fills in the exit reason.
