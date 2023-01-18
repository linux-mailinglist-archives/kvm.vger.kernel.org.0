Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557716722F4
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjARQX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjARQXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:23:33 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A99253E53
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:21:57 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so2906350pjm.1
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=96onnRMfNwCGefmryXDgBGIqeU2EbYigY6Cf6nLd5Os=;
        b=TPa77qDbMKs1jOi/NjHOv3Z5G1yMko3K2DBfOBoyDqDTg4wPSaPNTIMzoNozIajr00
         ISjPpT/dS4UKZt1V2+7RDRmttjFg1iDtBIK56bw5sEWMRUfyh81T8c4BpdVw0tcTxFfG
         zEpVx5xaSPhHb3QWm9d7QNvhjuMbJKsez6MTLWb8KtFRvn4JaupZq/DjGxTIkH2vYK83
         hnUvluCT3oyvClvI5z/tIWkCNRZzm2gyRgg9MKAAi0yAwdJl+OP0ZhX8xOnmTGMb3HgK
         8a5Tu3KXmd8eNw9a81mwXYe0yOgYZ0zYT7MURAvAMZwDNjhrs0tpCPEejIEpsePd4ptK
         JnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=96onnRMfNwCGefmryXDgBGIqeU2EbYigY6Cf6nLd5Os=;
        b=PlYC4VielK5m+5wbsSDNOUfsyJddJgDo1F8sCK6a6aSQDYxffD0VRqZJ4zjFJfU3qL
         Qy/li7JEjAZpxq+Mr9C4ZmANf0kH5j/D+VJOqG/npQmflqL9kWciqg06NMiPA7zuv+AB
         Q/myjGdJ9xK1bv8G7CEN+YIXPonK51GgDyjOzXBm2bCgqTylDQLT2t72Rn+H7jv9Z5XL
         zwOTjn846W0YrAKA1e0GyHGvx8/cJByC5bI9RtxHInGPD1nE31WZfIDA4tN4Qs4nI31D
         8bimirFbX7k6g4O4vh6F73Mmtv6rVmUazZqCnynOxO4MZgl5ukSF8Fal5qdgYJ/2jylO
         sIzg==
X-Gm-Message-State: AFqh2koZRqElMXpt0bNvqSacj7U/hzK319YGgF8E3wrlOqZosDVFGDet
        Bnl/Grse4pTieNsCV1RntsTUrp6djNqn5/JS
X-Google-Smtp-Source: AMrXdXvTWC3IlJDKVvE3/zk7/oO1j9I/5Scc+jXSAGEa/rsErLecG8Zt5Y6jHwkVgqvSqQTmTtagfA==
X-Received: by 2002:a05:6a20:a883:b0:a4:efde:2ed8 with SMTP id ca3-20020a056a20a88300b000a4efde2ed8mr2797128pzb.0.1674058916349;
        Wed, 18 Jan 2023 08:21:56 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q145-20020a632a97000000b004a4f24fbce9sm19095664pgq.5.2023.01.18.08.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:21:55 -0800 (PST)
Date:   Wed, 18 Jan 2023 16:21:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs
Message-ID: <Y8gclHES8KXiXHV2@google.com>
References: <20230118141348.828-1-alexandru.matei@uipath.com>
 <Y8gT/DNwUvaDjfeW@google.com>
 <87bkmves2d.fsf@ovpn-194-7.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkmves2d.fsf@ovpn-194-7.brq.redhat.com>
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

On Wed, Jan 18, 2023, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Jan 18, 2023, Alexandru Matei wrote:
> >> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
> >> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
> >> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
> >> that the msr bitmap was changed.
> >> 
> >> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
> >> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
> >> function checks for current_vmcs if it is null but the check is
> >> insufficient because current_vmcs is not initialized. Because of this, the
> >> code might incorrectly write to the structure pointed by current_vmcs value
> >> left by another task. Preemption is not disabled so the current task can
> >> also be preempted and moved to another CPU while current_vmcs is accessed
> >> multiple times from evmcs_touch_msr_bitmap() which leads to crash.
> >> 
> >> To fix this problem, this patch moves vmx_disable_intercept_for_msr calls
> >> before init_vmcs call in __vmx_vcpu_reset(), as ->vcpu_reset() is invoked
> >> after the vCPU is properly loaded via ->vcpu_load() and current_vmcs is
> >> initialized.
> >
> > IMO, moving the calls is a band-aid and doesn't address the underlying bug.  I
> > don't see any reason why the Hyper-V code should use a per-cpu pointer in this
> > case.  It makes sense when replacing VMX sequences that operate on the VMCS, e.g.
> > VMREAD, VMWRITE, etc., but for operations that aren't direct replacements for VMX
> > instructions I think we should have a rule that Hyper-V isn't allowed to touch the
> > per-cpu pointer.
> >
> > E.g. in this case it's trivial to pass down the target (completely untested).
> >
> > Vitaly?
> 
> Mid-air collision detected) I've just suggested a very similar approach
> but instead of 'vmx->vmcs01.vmcs' I've suggested using
> 'vmx->loaded_vmcs->vmcs': in case we're running L2 and loaded VMCS is
> 'vmcs02', I think we still need to touch the clean field indicating that
> MSR-Bitmap has changed. Equally untested :-)

Three reasons to use vmcs01 directly:

  1. I don't want to require loaded_vmcs to be set.  E.g. in the problematic
     flows, this 

	vmx->loaded_vmcs = &vmx->vmcs01;

     comes after the calls to vmx_disable_intercept_for_msr().

  2. KVM on Hyper-V doesn't use the bitmaps for L2 (evmcs02):

	/*
	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
	 * nested (L1) hypervisor and Hyper-V in L0 supports it. Enable the
	 * feature only for vmcs01, KVM currently isn't equipped to realize any
	 * performance benefits from enabling it for vmcs02.
	 */
	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;

		evmcs->hv_enlightenments_control.msr_bitmap = 1;
	}

  3. KVM's manipulation of MSR bitmaps typically happens _only_ for vmcs01,
     e.g. the caller is vmx_msr_bitmap_l01_changed().  The nested case is a 
     special snowflake.
