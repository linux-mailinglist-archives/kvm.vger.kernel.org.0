Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2283543D19
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 21:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiFHTtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 15:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbiFHTth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 15:49:37 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEEF20BB07
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 12:49:35 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id q18so18514498pln.12
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 12:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VEjo109UU6vyMJaWpJ5ZAEaj/fsluHwQF6ABTzm5Vqk=;
        b=OKAfshPLtVGbddgYGpjaJH6MWgYvGLHZOYpCNxSFAc51y9hzgRZqZbv3+VLDsV/rPN
         Ldv4+Bl9aCJE58WvgIvf6qeT2We6fXT2veKEpCNSDpLYZj3UeeAHFcVOXyAmEVTp+vGw
         ku1L+JpJ87qN2eW1kwBVF/Lcm7kh+sKLvgpw5JNZLj1fo116MWqG4fd0tbJH024xsmwn
         yHzudUEZgfRiOxxBfrBR0kallfrK6nIfhIPivNpeqwewkKKfE0qJ8nac8nqkrERYmTYy
         XkOd0rjQhQfHBVBV8kbnBos7tJ1D9r3+uFCuEBwtRJvZ/ZAZxYfvA/22S9Y9qiiqaipA
         2V6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VEjo109UU6vyMJaWpJ5ZAEaj/fsluHwQF6ABTzm5Vqk=;
        b=QtsjeJwOJAx77HJfH6yr1NEvj2OAH2kYq1AAxQsoJSZ0elsRvAonExBP4Gw3nxSnxP
         WTXzQ3Mo76zyu7hAAlznuSspW9fxH5oUZ2/Bw9jXmiFArKKn9sREFQLb8olveQwPNi0w
         J2eV3qeKZRg1ssxJEAlbDXUMKwp3pFkbXR6mQtxAsWqoNUp7g3y/dVSzI1tQ6S2o66sL
         mb9fgzVy+GikFMFxwiQifWAUQ6tVwgmHylpVqwXzSi1jeSSDupMFwM9dPenjik9mC/bk
         y1aH/4L3FabiLZVyOIJhVvNeUSpr4uuGn3EiCc7GGLrWEcYxcRo+czw4C/f6X5b9PVRn
         fc0A==
X-Gm-Message-State: AOAM5331QvzyfF8/pDrXTjI5q0LKBIhxtWExnkXB3KJ01sW8JnnfsDz+
        vaOeObqTI69fRPpGEBJq4HUTew==
X-Google-Smtp-Source: ABdhPJxzoSD/U+UWEntTfAhoBbf8dbSHxS3qOPycaK0n9wSvvXjHFLbT0tyoXEtV4jK3PbZHG85Ivw==
X-Received: by 2002:a17:902:b70c:b0:156:16f0:cbfe with SMTP id d12-20020a170902b70c00b0015616f0cbfemr35623819pls.152.1654717774882;
        Wed, 08 Jun 2022 12:49:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t6-20020a1709028c8600b001636c0b98a7sm15084461plo.226.2022.06.08.12.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 12:49:34 -0700 (PDT)
Date:   Wed, 8 Jun 2022 19:49:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 038/144] KVM: selftests: Push
 vm_adjust_num_guest_pages() into "w/o vCPUs" helper
Message-ID: <YqD9SshYPF9ZV+Hc@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-39-seanjc@google.com>
 <20220608143828.b7ggvuptlngmnqvp@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608143828.b7ggvuptlngmnqvp@gator>
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

On Wed, Jun 08, 2022, Andrew Jones wrote:
> On Fri, Jun 03, 2022 at 12:41:45AM +0000, Sean Christopherson wrote:
> > Move the call to vm_adjust_num_guest_pages() from vm_create_with_vcpus()
> > down into vm_create_without_vcpus().  This will allow a future patch to
> > make the "w/o vCPUs" variant the common inner helper, e.g. so that the
> > "with_vcpus" helper calls the "without_vcpus" helper, instead of having
> > them be separate paths.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 1c5caf2ddca4..6b0b65c26d4d 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -282,6 +282,8 @@ struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
> >  {
> >  	struct kvm_vm *vm;
> >  
> > +	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
> 
> Hi Sean,
> 
> We should pass 'mode' here.

Ouch.  Very nice catch!  Lucky for me, the resulting conflicts later in the series
are obvious and straightfoward.

Thanks much!
