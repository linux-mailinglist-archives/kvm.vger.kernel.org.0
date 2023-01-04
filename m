Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE19D65CB29
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 02:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbjADBBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 20:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238680AbjADBBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 20:01:18 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AC6B89
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 17:01:18 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so37514729pjj.2
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 17:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B1SMUQWNqPdQW0vO6rH84bqxMDgoVgXICRobpbo8urw=;
        b=DRqws/vK/yhWoIfP64vLyodOJO4aCujC4wtDuEc4ApqYy8FwZmg5t+EYLiXT5evOXC
         jcnpHczN04p7z4HPZvK1/Tm34zMcYewsweOd9ZXvrMrJQncMzmxUO5IbCa+iT/C2Qv1t
         jugot8Wk4KWUoeV849df+IpR59GKuNLabhlwRmnbRqv4B/EueamuxkWBYHlqr42yD45y
         Zl3hXc4nm1ucdN7hMhhbOTAeeQeEY3Qtb7usTkQB3GemLvrlmU+ysAMc22HonWftP6nx
         6sNDRBe9XQhEryl/Rbg4G6tV41jJfOPH6jWsCYOioTC30FSFddiIoAAT0Fj8S8qLJc8U
         qN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B1SMUQWNqPdQW0vO6rH84bqxMDgoVgXICRobpbo8urw=;
        b=CM/mgb63jTZZEyXPOK/JdmyiibyRvZyPJ/TChsd2ve1rHnaRedmm12ZuzZb3jzSeht
         LD+S7ofBNDx4MMkEY/ApLt4miA77sKqhxwMyfhjVVufNcd0iMLBExS+Z/Qe66mPi1aW7
         Doth7CBZH0ZRT3VUXGLRRcAChdws8YjZspOZtNttdli45DnA0ZitaE8g5nwC7WccfX5L
         Bi8dmz1WWvfPL5hR5YTJbGUey/sEqMCvitOJwxoV4LjhX3Gbz1OJyHA2beTF7o6hJZO1
         v7xdlHPDmfu2+ij9iz2jCFrmMGAJ2HCJY66WHwmj13ZMrLoavYikaZFFh/AkGx8PCpvk
         Gg3Q==
X-Gm-Message-State: AFqh2kpxTry5b2H0tzOV2dOTLAWGfdw0qCf3f1+VfhISpsAq5YzCyMVE
        g6TqWzhHT3Y0nP/u1lPRRNzvcg==
X-Google-Smtp-Source: AMrXdXsm/+/BaD9fLXEmdyPUwmXboK5FhSwSBAmF4xBlElysJQkpfj+2+SO3cgOhhSP9sHTKG4Q2yw==
X-Received: by 2002:a17:902:ce90:b0:192:8a1e:9bc7 with SMTP id f16-20020a170902ce9000b001928a1e9bc7mr2235855plg.0.1672794077489;
        Tue, 03 Jan 2023 17:01:17 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z11-20020a170902d54b00b0018941395c40sm22630397plf.285.2023.01.03.17.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 17:01:17 -0800 (PST)
Date:   Wed, 4 Jan 2023 01:01:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 00/27] drm/i915/gvt: KVM: KVMGT fixes and page-track
 cleanups
Message-ID: <Y7TP2R01VAbmmfcT@google.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <Y6VvVrYURd/an3Zp@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6VvVrYURd/an3Zp@yzhao56-desk.sh.intel.com>
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

On Fri, Dec 23, 2022, Yan Zhao wrote:
> On Fri, Dec 23, 2022 at 12:57:12AM +0000, Sean Christopherson wrote:
> > Fix a variety of found-by-inspection bugs in KVMGT, and overhaul KVM's
> > page-track APIs to provide a leaner and cleaner interface.  The motivation
> > for this series is to (significantly) reduce the number of KVM APIs that
> > KVMGT uses, with a long-term goal of making all kvm_host.h headers
> > KVM-internal.  That said, I think the cleanup itself is worthwhile,
> > e.g. KVMGT really shouldn't be touching kvm->mmu_lock.
> > 
> > Note!  The KVMGT changes are compile tested only as I don't have the
> > necessary hardware (AFAIK).  Testing, and lots of it, on the KVMGT side
> > of things is needed and any help on that front would be much appreciated.
> hi Sean,
> Thanks for the patch!
> Could you also provide the commit id that this series is based on?

The commit ID is provided in the cover letter:

  base-commit: 9d75a3251adfbcf444681474511b58042a364863

Though you might have a hard time finding that commit as it's from an old
version of kvm/queue that's probably since been force pushed.

> I applied them on top of latest master branch (6.1.0+,
> 8395ae05cb5a2e31d36106e8c85efa11cda849be) in repo
> https://github.com/torvalds/linux.git, yet met some conflicts and I
> fixed them manually. (patch 11 and patch 25).
> 
> A rough test shows that below mutex_init is missing.
> But even with this fix, I still met guest hang during guest boots up.
> Will look into it and have a detailed review next week.

Thanks again for the reviews and testing!  I'll get a v2 out in the next week or
so (catching up from holidays) and will be more explicit in documenting the base
version.
