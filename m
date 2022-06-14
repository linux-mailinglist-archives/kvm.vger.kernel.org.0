Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3D554B39C
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 16:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245182AbiFNOlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 10:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiFNOlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 10:41:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC17C25298
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:41:35 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x4so8734521pfj.10
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MuH+vWInhDg8Ee66SrhIJxczipqkeISxPHcZ8pdGyXM=;
        b=fbrqPIQpkXMk0pt5ps33Fv7aL7ejWzbalpV2J2UpOZpq3oyhqsMbVn4Pq1Brai70cd
         8tu6IvG++44WlDrrbKY3y+aSEBIzl+uLUlDshVeF8uU5KbsZy+S+HUxIhnf/HlMqHtfN
         F1i2KTce9INBkQPER0FK+Taoa4gijTyuzCQ+G0bnZGRBnObMrt93nzPF1VDlIZ8mOrzg
         +psIazUKvPDW5pmCB6ZGB1m4Zad/8sHDhSOFOMHyng6KnSrtMUEjoYNVSHmaKV+8fMU0
         eCYysoC5PSvpTVVswRwfgEzfY/s3PK8g4WI0lUy+TpCrmJHhIfGQyITUl/a6W/pr1/4d
         fZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MuH+vWInhDg8Ee66SrhIJxczipqkeISxPHcZ8pdGyXM=;
        b=GazxzK6hN35P5RvqtOTygArnZY1Safwvj5FB7qM1J0jyubD0hQbuBhBVGGXOOEjvzI
         wrjaKg/cM2w0atqsZjYZjye7HzrAPkDK93nLyLRgtbHYqwBF22AxXk7Vqj90NXKDAzot
         Ag8TLGPuO6UiCQNS+DqfyK8FZhjPY+SLXHLRJryWWKAKdb19LgYeXx4+AeaB7iCFD/la
         fhfs6DG1PlipCYWyTFwzIgJLbx0CWNIFp4VBqb7C0f6ydwy0Wt8V2RtTHZz7rCztNH3O
         A3ERYbyaYRNW2rEO0GIq9BgEPtT0DbBYeGH+JXsLAGxc92T/yNlYutyFdWWB6tbvXjjF
         Dnzg==
X-Gm-Message-State: AOAM533hsqc9TjVOazRKoScrHhO+gcA9jFef8fUOoA203egRgxbPdlHb
        4gjOjTKTLih+4YOIjfWBw4FlaA==
X-Google-Smtp-Source: ABdhPJzj+yDrwzEZIMjIDmIinqO+ZsHHwxuFMxHf3Cz+4bchBuN2ZvDRC4iX9dFKEm8qZ8uesvR34Q==
X-Received: by 2002:a63:5c26:0:b0:405:2650:d202 with SMTP id q38-20020a635c26000000b004052650d202mr4850303pgb.276.1655217695062;
        Tue, 14 Jun 2022 07:41:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902ea4a00b001637997d0d4sm7322191plg.206.2022.06.14.07.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:41:34 -0700 (PDT)
Date:   Tue, 14 Jun 2022 14:41:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     wangguangju <wangguangju@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, dave.hansen@linux.intel.co,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.orga
Subject: Re: [PATCH] KVM: x86: add a bool variable to distinguish whether to
 use PVIPI
Message-ID: <YqieGua0ouUePWol@google.com>
References: <1655124522-42030-1-git-send-email-wangguangju@baidu.com>
 <YqdxAFhkeLjvi7L5@google.com>
 <20220614025434.GA15042@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614025434.GA15042@gao-cwp>
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

On Tue, Jun 14, 2022, Chao Gao wrote:
> On Mon, Jun 13, 2022 at 05:16:48PM +0000, Sean Christopherson wrote:
> >The shortlog is not at all helpful, it doesn't say anything about what actual
> >functional change.
> >
> >  KVM: x86: Don't advertise PV IPI to userspace if IPIs are virtualized
> >
> >On Mon, Jun 13, 2022, wangguangju wrote:
> >> Commit d588bb9be1da ("KVM: VMX: enable IPI virtualization")
> >> enable IPI virtualization in Intel SPR platform.There is no point
> >> in using PVIPI if IPIv is supported, it doesn't work less good
> >> with PVIPI than without it.
> >> 
> >> So add a bool variable to distinguish whether to use PVIPI.
> >
> >Similar complaint with the changelog, it doesn't actually call out why PV IPIs
> >are unwanted.
> >
> >  Don't advertise PV IPI support to userspace if IPI virtualization is
> >  supported by the CPU.  Hardware virtualization of IPIs more performant
> >  as senders do not need to exit.
> 
> PVIPI is mainly [*] for sending multi-cast IPIs. Intel IPI virtualization
> can virtualize only uni-cast IPIs. Their use cases don't overlap. So, I
> don't think it makes sense to disable PVIPI if intel IPI virtualization
> is supported.
> 
> The question actually is how to deal with the exceptional case below.
> Considering the migration case Sean said below, it is hard to let VM
> always work in the ideal way unless KVM notifies VM of migration and VM
> changes its behavior on receiving such notifications. But since x2apic
> has better performance than xapic, if VM cares about performance, it can
> simply switch to x2apic mode. All things considered, I think the
> performance gain isn't worth the complexity added. So, I prefer to leave
> it as is.
> 
> [*]: when linux guest is in *xapic* mode, it uses PVIPI to send uni-case IPI.

Hmm, there are definitely guests that run xAPIC though, even if x2apic is supported.

That said, I tend to agree that trying to handle this in KVM and/or the guest kernel
is going to get messy.  The easiest solution is for VMMs to not advertise PV IPIs
when the VM is going to predominately run on hosts with IPIv.

> >That said, I'm not sure that KVM should actually hide PV_SEND_IPI.  KVM still
> >supports the feature, and unlike sched_info_on(), IPI virtualization is platform
> >dependent and not fully controlled by software.  E.g. hiding PV_SEND_IPI could
> >cause problems when migrating from a platform without IPIv to a platform with IPIv,
> >as a paranoid VMM might complain that an exposed feature isn't supported by KVM.
> >
> >There's also the question of what to do about AVIC.  AVIC has many more inhibits
> >than APICv, e.g. an x2APIC guest running on hardware that doesn't accelerate x2APIC
> >IPIs will probably be better off with PV IPIs.
> >
> >Given that userspace should have read access to the module param, I'm tempted to
> >say KVM should let userspace make the decision of whether or not to advertise PV
> >IPIs to the guest.
