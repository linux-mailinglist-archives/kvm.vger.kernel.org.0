Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9073C66E498
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 18:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbjAQROv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 12:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbjAQRO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 12:14:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1A74995D
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673975521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/xT2F+gCG0Rjzumy1UFOyArPW6tPSIn20KE3KJxQnIc=;
        b=MsKFReBYvmYOXxN5rn9F4U6ud2w2UDLGCsvuBMA5ehaXZexmxe6PInHgSUh6WvQLEHg3cx
        dKS7l/PQAxNI4MEpXFRjlggNd9PLjUEiiKdg6G/nvx7Vnu3xfrUgc7iTggLBoIba/aoxd8
        trr3Ixm9ourTHpSlEC0EDCsVzhFGpgM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-74-f2Aei5z9PvCFeGet1C6aXA-1; Tue, 17 Jan 2023 12:11:56 -0500
X-MC-Unique: f2Aei5z9PvCFeGet1C6aXA-1
Received: by mail-wm1-f70.google.com with SMTP id 9-20020a05600c228900b003daf72fc827so3793918wmf.9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:11:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xT2F+gCG0Rjzumy1UFOyArPW6tPSIn20KE3KJxQnIc=;
        b=kLZQbzYlZY0+gb2/fZwcR+Aew3ztFOK5oUTL1f1hbrABpWRDBdHm4i82f+g65dd/8V
         grPw7Vx7kKJs+/YYBLkNXHYcFNEvWjR8q7sFMAvcSmcLLw4Z1LuWNy7+naLMPsBdyKKZ
         CYUrXUC4AxlfSUoDK1dgyi7pJBnLixWT7dCUJ2r0NtgE9O0M/EOTaawZQhcWR4ScyDhP
         +e5FAXezH/uZUqMCkFKRV7Wp0JnrLBebjSDpervuH86U96RP9JVsLsyPi/9Kty5lBxcL
         pQVvWQmRAj+jxr99eCQ2Q6s/2r8zGkfrfIGT+LrvWNEmv1+lrkKhnZxnwFdWyaHTLC+g
         d7rQ==
X-Gm-Message-State: AFqh2koDg4p44570LjDx5fi6ADafJkSZ7po/D4ffvmiK00UoY0y1jeU7
        dVf1wzlm6eeROHWOGBowKwQ1IK3rOAdEDkCt2WkQvdS3naeFAFqkI22oHfZ3TsqTJdRquuBwfXB
        ZSa/141wVbSRn
X-Received: by 2002:a05:600c:3d86:b0:3d2:3761:b717 with SMTP id bi6-20020a05600c3d8600b003d23761b717mr3645133wmb.37.1673975503939;
        Tue, 17 Jan 2023 09:11:43 -0800 (PST)
X-Google-Smtp-Source: AMrXdXthCy8QSeEC7iz78+ZXE8290P6Tj/9R6eydiQpw7t1RDUTcjH8HczS8uO0wFNDFTf0uUkN27Q==
X-Received: by 2002:a05:600c:3d86:b0:3d2:3761:b717 with SMTP id bi6-20020a05600c3d8600b003d23761b717mr3645117wmb.37.1673975503770;
        Tue, 17 Jan 2023 09:11:43 -0800 (PST)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600c4fc200b003da2932bde0sm15811861wmq.23.2023.01.17.09.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 09:11:43 -0800 (PST)
Date:   Tue, 17 Jan 2023 17:11:41 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] arm/kvm: add support for MTE
Message-ID: <Y8bWzZe4svHOmdvd@work-vm>
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-2-cohuck@redhat.com>
 <CAFEAcA9BKX+fSEZZbziwTNq5wsshDajuxGZ_oByVZ=gDSYOn9g@mail.gmail.com>
 <Y8bR7xrsCMr5z6xI@work-vm>
 <877cxl85cb.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877cxl85cb.fsf@redhat.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Cornelia Huck (cohuck@redhat.com) wrote:
> On Tue, Jan 17 2023, "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
> > * Peter Maydell (peter.maydell@linaro.org) wrote:
> >> On Wed, 11 Jan 2023 at 16:13, Cornelia Huck <cohuck@redhat.com> wrote:
> >> >
> >> > Introduce a new cpu feature flag to control MTE support. To preserve
> >> > backwards compatibility for tcg, MTE will continue to be enabled as
> >> > long as tag memory has been provided.
> >> >
> >> > If MTE has been enabled, we need to disable migration, as we do not
> >> > yet have a way to migrate the tags as well. Therefore, MTE will stay
> >> > off with KVM unless requested explicitly.
> >> >
> >> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >> > ---
> >> >  docs/system/arm/cpu-features.rst |  21 +++++
> >> >  hw/arm/virt.c                    |   2 +-
> >> >  target/arm/cpu.c                 |  18 ++---
> >> >  target/arm/cpu.h                 |   1 +
> >> >  target/arm/cpu64.c               | 133 +++++++++++++++++++++++++++++++
> >> >  target/arm/internals.h           |   1 +
> >> >  target/arm/kvm64.c               |   5 ++
> >> >  target/arm/kvm_arm.h             |  12 +++
> >> >  target/arm/monitor.c             |   1 +
> >> >  9 files changed, 181 insertions(+), 13 deletions(-)
> >> >
> >> > diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> >> > index 00c444042ff5..e278650c837e 100644
> >> > --- a/docs/system/arm/cpu-features.rst
> >> > +++ b/docs/system/arm/cpu-features.rst
> >> > @@ -443,3 +443,24 @@ As with ``sve-default-vector-length``, if the default length is larger
> >> >  than the maximum vector length enabled, the actual vector length will
> >> >  be reduced.  If this property is set to ``-1`` then the default vector
> >> >  length is set to the maximum possible length.
> >> > +
> >> > +MTE CPU Property
> >> > +================
> >> > +
> >> > +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
> >> > +presence of tag memory (which can be turned on for the ``virt`` machine via
> >> > +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
> >> > +proper migration support is implemented, enabling MTE will install a migration
> >> > +blocker.
> >> > +
> >> > +If not specified explicitly via ``on`` or ``off``, MTE will be available
> >> > +according to the following rules:
> >> > +
> >> > +* When TCG is used, MTE will be available iff tag memory is available; i.e. it
> >> > +  preserves the behaviour prior to introduction of the feature.
> >> > +
> >> > +* When KVM is used, MTE will default to off, so that migration will not
> >> > +  unintentionally be blocked.
> >> > +
> >> > +* Other accelerators currently don't support MTE.
> >> 
> >> Minor nits for the documentation:
> >> we should expand out "if and only if" -- not everybody recognizes
> >> "iff", especially if they're not native English speakers or not
> >> mathematicians.
> >> 
> >> Should we write specifically that in a future QEMU version KVM
> >> might change to defaulting to "on if available" when migration
> >> support is implemented?
> >
> > Please make sure if you do something like that, that the failure
> > is obious; 'on if available' gets messy for things like libvirt
> > and higher level tools detecting features that are available and
> > machines they can migrate to.
> 
> I guess we can just keep the door open but decline walking through it if
> we fail to come up with a good solution...

Yeh; at least make sure that any migration failure gives an obvious
message in the log.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

