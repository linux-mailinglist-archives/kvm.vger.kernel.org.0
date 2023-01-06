Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5721E660A05
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 00:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjAFXCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 18:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFXCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 18:02:00 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD842738
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 15:01:58 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 17so3300162pll.0
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 15:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VYXtBX/du996tJvdynzJ32ntkaPrtSq1hOW6/2PswpM=;
        b=TT4zT9wcuVbyBdPgC4xbhu3DT3qqLGzRLyTxKSOdADEnvyIHIs6oYWy3D4LBeYWsD3
         kYo2EvofmVDElte4bPA8UQDZXKuJ06Cxs9KKOyIGZmn8lrpQroScoRdKoqdsUimQQnXw
         qnANLXEBnglXDzALVgXKxyBupzS+/S0avbrG22jKhKsCjXQLlYaqbaram2AYYU1B4WdH
         Kp2C+JZSPa/X2X0ByhxQkCc6wUiJJ+A/aiFlOny9Lvi11N09C7qLyoTxtlG+itAyy5C/
         Dn4JxEqAOOJc84Ya/GtyzyqYOz1qqHkVA97yAsZL9VvaR1zXMQi5Fv/8gKkVp8mxoWuK
         sN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VYXtBX/du996tJvdynzJ32ntkaPrtSq1hOW6/2PswpM=;
        b=bSs9yN1L3zcS/WX5HM/XmNPqqaAZ5t1a4/Pwz79mWlFOTls/yIYCnqI0zpzKDWdXd1
         K7QdZD4EfKoJh98JyB4BHh7G+rqcc7i+9YY3RT/Id8wEbzrpNAP/iUjtNxgR+h8etbe8
         pHTHDZ+rPa2odwuCcpY+X3/vRbYuS6RW5Bb9m/HzZn1mS1RFf9Th6/lhonN6E6Wgw43/
         jWNALu1VcOUVtNrvmckFENJnk1j4Voy3Ms+iab3ZUaQbM5WnZeCknbLOrKmj8gi0BwAh
         RxQFsdBzeAtQLviYNc9LiJ2Pp8+4jSrxSBHjOUED1DivWyhBR1xK8jac7YHkboTOEy9S
         BFDQ==
X-Gm-Message-State: AFqh2kp4Bkiy3STBpzqiAaMzwZPChQMQRkXf+YtZ84aRpNWvVMnQmLqJ
        92j+fYl7SRxNuaK8e7DDWZ51cQ==
X-Google-Smtp-Source: AMrXdXu5U4s/yFXeuvjVG6HixVW2S0SFuyuS/IfsjeRrGpQFHCGuzy/cTld+cIpOiV3Uxsy2tNHU8w==
X-Received: by 2002:a05:6a20:9f03:b0:a4:efde:2ed8 with SMTP id mk3-20020a056a209f0300b000a4efde2ed8mr45164pzb.0.1673046117468;
        Fri, 06 Jan 2023 15:01:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m124-20020a632682000000b0045dc85c4a5fsm1352548pgm.44.2023.01.06.15.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 15:01:56 -0800 (PST)
Date:   Fri, 6 Jan 2023 23:01:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y7ioYegkgKIH8uJL@google.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-4-seanjc@google.com>
 <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
 <Y7SaklDQD0EoIs8l@google.com>
 <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
 <Y7cLkLUMCy+XLRwm@google.com>
 <Y7e3fT8/V2NoXAUP@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7e3fT8/V2NoXAUP@yzhao56-desk.sh.intel.com>
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

On Fri, Jan 06, 2023, Yan Zhao wrote:
> On Thu, Jan 05, 2023 at 05:40:32PM +0000, Sean Christopherson wrote:
> > On Thu, Jan 05, 2023, Yan Zhao wrote:
> > I'm totally fine if KVMGT's ABI is that VFIO is the source of truth for mappings
> > and permissions, and that the only requirement for KVM memslots is that GTT page
> > tables need to be visible in KVM's memslots.  But if that's the ABI, then
> > intel_gvt_is_valid_gfn() should be probing VFIO, not KVM (commit cc753fbe1ac4
> > ("drm/i915/gvt: validate gfn before set shadow page entry").
> > 
> > In other words, pick either VFIO or KVM.  Checking that X is valid according to
> > KVM and then mapping X through VFIO is confusing and makes assumptions about how
> > userspace configures KVM and VFIO.  It works because QEMU always configures KVM
> > and VFIO as expected, but IMO it's unnecessarily fragile and again confusing for
> > unaware readers because the code is technically flawed.
> >
> Agreed. 
> Then after some further thought, I think maybe we can just remove
> intel_gvt_is_valid_gfn() in KVMGT, because
> 
> (1) both intel_gvt_is_valid_gfn() in emulate_ggtt_mmio_write() and
> ppgtt_populate_spt() are not for page track purpose, but to validate bogus
> GFN.
> (2) gvt_pin_guest_page() with gfn and size can do the validity checking,
> which is called in intel_gvt_dma_map_guest_page(). So, we can move the
> mapping of scratch page to the error path after intel_gvt_dma_map_guest_page().

IIUC, that will re-introduce the problem commit cc753fbe1ac4 ("drm/i915/gvt: validate
gfn before set shadow page entry") solved by poking into KVM.  Lack of pre-validation
means that bogus GFNs will trigger error messages, e.g.

			gvt_vgpu_err("vfio_pin_pages failed for iova %pad, ret %d\n",
				     &cur_iova, ret);

and

			gvt_vgpu_err("fail to populate guest ggtt entry\n");

One thought would be to turn those printks into tracepoints to eliminate unwanted
noise, and to prevent the guest from spamming the host kernel log by programming
garbage into the GTT (gvt_vgpu_err() isn't ratelimited).

> > On a related topic, ppgtt_populate_shadow_entry() should check the validity of the
> > gfn.  If I'm reading the code correctly, checking only in ppgtt_populate_spt() fails
> > to handle the case where the guest creates a bogus mapping when writing an existing
> > GTT PT.
> Don't get it here. Could you elaborate more?

AFAICT, KVMGT only pre-validates the GFN on the initial setup, not when the guest
modifies a write-tracked entry.  I believe this is a moot point if the pre-validation
is removed entirely.

> > 	gfn = pte_ops->get_pfn(ge);
> > 	if (!intel_gvt_is_valid_gfn(vgpu, gfn, ge->type))
> > 		goto set_shadow_entry;
> As KVMGT only tracks PPGTT page table pages, this check here is not for page
> track purpose, but to check bogus GFN.
> So, Just leave the bogus GFN check to intel_gvt_dma_map_guest_page() through
> VFIO is all right.
> 
> On the other hand, for the GFN validity for page track purpose, we can
> leave it to kvm_write_track_add_gfn().
> 
> Do you think it's ok?

Yep, the only hiccup is the gvt_vgpu_err() calls that are guest-triggerable, and
converting those to a tracepoint seems like the right answer.
