Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912B9608230
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 01:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJUXsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 19:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJUXsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 19:48:23 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D194D24E402
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 16:48:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso4185681pjc.5
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 16:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bief6n2KJvPdjYY33jpAwU4FAk9kTl6ZJ/dHDzSqnN4=;
        b=Yjpn3oeOaIAH47+IOvfOeU0jRd8BaPvu7wwEL2pMd13h+cVXfmEaixLurg40U2+klp
         Uj2Ky/2o883ODq1xtibPnjbDkcDT2ZfDLVO/UeW+x4epQRtAKY3bnziZ7eFHXUF6Wi+6
         buKbVuJ3t31AnagOmcsttdoZkf85MCwxmJCFBg2dr4WH2L1jsf/9YVBIINy/+QUnKp4t
         fiEBNo/lZ0CLVRUKwQTe2YvhleBL9gOwctEiJszR8UY73iipOBm3wm4S3lAYsRWWSSxp
         VRLSxmsavFHczKvfI4KQNuRB+ARncl5LMr0e03cp6mL8Ff4pKGzZuM+kNmDBskwI0XQC
         Rrkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bief6n2KJvPdjYY33jpAwU4FAk9kTl6ZJ/dHDzSqnN4=;
        b=PZzAdnOIseNauNW/Y0QVScXt5biWxlNgmmTCNa5Nn8Aow/+8tZMnaGqwppMRGr1/9X
         PpkrBe68GpMA3UCopjkh+crzGrfg30yMlLHzo1buILoIrU20zm+kyPMSImyLiXdwJJ6V
         K0QRoSXzIy/4aoPBoo49AJ0SZ0vG+vpFfVYXPB9zUMxFwk1CXE99NgtgjRHZI6gwBvmn
         YnQ40z7gfhQZogLD36pOxuluMzAVnNFe0VwIaZ8n8Ua1xZItKzTdSTDhI2LEZLDcxTbZ
         VVL7q4AOBhTPEWIKjzSRZA2KiYLv9BslkIJqIgfDJ7tBnU0gf7vrddTTbFjxTXD8AEz+
         Iasg==
X-Gm-Message-State: ACrzQf0TT4uABpy2n2wXofyhZ4KSzK+e0MmQyeNxg1Lk934CLFatAxSm
        XmoK3MaJkgLCHAazY42MkwzDxg==
X-Google-Smtp-Source: AMsMyM7noZbvnVAq4AOTxjObtKJ7KW8KLfOredevk9btt7ajna0zmmAFT3KLuQYUZheRmxNn23w1SA==
X-Received: by 2002:a17:90a:8c8e:b0:202:883b:2644 with SMTP id b14-20020a17090a8c8e00b00202883b2644mr60087896pjo.89.1666396102217;
        Fri, 21 Oct 2022 16:48:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o8-20020a63f148000000b0041ae78c3493sm13648691pgk.52.2022.10.21.16.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 16:48:21 -0700 (PDT)
Date:   Fri, 21 Oct 2022 23:48:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, shan.gavin@gmail.com
Subject: Re: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <Y1Mvwq5PJ0gxC+47@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-2-gshan@redhat.com>
 <Y1HO46UCyhc9M6nM@google.com>
 <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
 <Y1K5/MN9o7tEvYu5@google.com>
 <85d15a4a-bbae-c5e6-f6dc-1d972d07dafb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85d15a4a-bbae-c5e6-f6dc-1d972d07dafb@redhat.com>
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

On Sat, Oct 22, 2022, Gavin Shan wrote:
> > > When dirty ring becomes full, the VCPU can't handle any operations, which will
> > > bring more dirty pages.
> > 
> > Right, but there's a buffer of 64 entries on top of what the CPU can buffer (VMX's
> > PML can buffer 512 entries).  Hence the "soft full".  If x86 is already on the
> > edge of exhausting that buffer, i.e. can fill 64 entries while handling requests,
> > than we need to increase the buffer provided by the soft limit because sooner or
> > later KVM will be able to fill 65 entries, at which point errors will occur
> > regardless of when the "soft full" request is processed.
> > 
> > In other words, we can take advantage of the fact that the soft-limit buffer needs
> > to be quite conservative.
> > 
> 
> Right, there are extra 64 entries in the ring between soft full and hard full.
> Another 512 entries are reserved when PML is enabled. However, the other requests,
> who produce dirty pages, are producers to the ring. We can't just have the assumption
> that those producers will need less than 64 entries.

But we're already assuming those producers will need less than 65 entries.  My point
is that if one (or even five) extra entries pushes KVM over the limit, then the
buffer provided by the soft limit needs to be jacked up regardless of when the
request is processed.

Hmm, but I suppose it's possible there's a pathological emulator path that can push
double digit entries, and servicing the request right away ensures that requests
have the full 64 entry buffer to play with.

So yeah, I agree, move it below the DEAD check, but keep it above most everything
else.

> > > > Would it make sense to clear the request in kvm_dirty_ring_reset()?  I don't care
> > > > about the overhead of having to re-check the request, the goal would be to help
> > > > document what causes the request to go away.
> > > > 
> > > > E.g. modify kvm_dirty_ring_reset() to take @vcpu and then do:
> > > > 
> > > > 	if (!kvm_dirty_ring_soft_full(ring))
> > > > 		kvm_clear_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> > > > 
> > > 
> > > It's reasonable to clear KVM_REQ_DIRTY_RING_SOFT_FULL when the ring is reseted.
> > > @vcpu can be achieved by container_of(..., ring).
> > 
> > Using container_of() is silly, there's literally one caller that does:
> > 
> > 	kvm_for_each_vcpu(i, vcpu, kvm)
> > 		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
> > 
> 
> May I ask why it's silly by using container_of()?

Because container_of() is inherently dangerous, e.g. if it's used on a pointer that
isn't contained by the expected type, the code will compile cleanly but explode
at runtime.  That's unlikely to happen in this case, e.g. doesn't look like we'll
be adding a ring to "struct kvm", but if someone wanted to add a per-VM ring,
taking the vCPU makes it very obvious that pushing to a ring _requires_ a vCPU,
and enforces that requirement at compile time.

In other words, it's preferable to avoid container_of() unless using it solves a
real problem that doesn't have a better alternative.

In these cases, passing in the vCPU is most definitely a better alternative as
each of the functions in question has a sole caller that has easy access to the
container (vCPU), i.e. it's a trivial change.

> In order to avoid using container_of(), kvm_dirty_ring_push() also need
> @vcpu.

Yep, that one should be changed too.

> So lets change those two functions to something like below. Please
> double-check if they looks good to you?
> 
>   void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset);
>   int kvm_dirty_ring_reset(struct kvm_vcpu *vcpu);

Yep, looks good.
