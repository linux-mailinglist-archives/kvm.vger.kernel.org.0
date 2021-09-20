Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6EB4117B1
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 16:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbhITO6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 10:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbhITO6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 10:58:49 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1514C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:57:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k23-20020a17090a591700b001976d2db364so157213pji.2
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YPFvkcJ03ZkdfGpA8JCa3mFatKaCYINMtSZaZf+KaKI=;
        b=Dz69VcFJ2dPo27VjmmzU0Ak2MknLb1cotIoH4WC74jS3MKZ6XB8lFGi7mXMCqkt2V+
         6t18CD7JVYj85b0TzdcCxp09VXVeEExFNLbUgp1to/8ctlnU3XGEUmkJVIpAx2ZdpV5K
         6Q2ZOxqIBgBm0POzYkxcmdqs5haGlBIeMhEjKo4RCdphxyk0NqXD0L2k850WI0joJBBB
         cGH9w0D2uZWdVPA067kPy39uwscNJNHWRTObCTCmLkDlTb6VymBC/VotWXja3UQ6N57y
         Tvf8SfyHJ2/uMoiniUUKEQIGaVPxh/qSdX2lcOYLAoP8m2mFqzz+k9rZUNl+vJjRkmsp
         W+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YPFvkcJ03ZkdfGpA8JCa3mFatKaCYINMtSZaZf+KaKI=;
        b=uSlva+wO1TsPGaErPr5fW9aaTF35b8pCU17+3OfgwVZ/0RgH6fgTpvr+oX49p6IPjA
         9sPEjMhdu6HhM2lY7zk1loILhbVWd9Lahlh64bH1Avf5p+bAYDWsEzcCDU9Y2vlwNlcH
         h/syzcWw1WKJq7fYNg/hMVT257/Q029J/6TJuirCWfP4qB3QW4oM5I5Ph0HbqVaaYllg
         2I8cFD2Qoor8aflZ6Nycx3J+bGq1cgH3uC24DEOY2PNBdJ+Yfwap03IFOhHjVtSPMz0f
         2l4PF58HVORhxoOF0wICsL7pZ7MSTiglYyHE2EtMhJO+qDsXQWRFNz+EPYYaW3RgkKuG
         WLsg==
X-Gm-Message-State: AOAM530UrTNufP5KKyaznpzT6c9U+YLF0QxDOoa/xCd9k1Rxhyc+NMbG
        Zpo29IpQccEN4pZ/DacnqTnXHA==
X-Google-Smtp-Source: ABdhPJw4if6cbIHHe84v5c9oqaVlsHq/xuFSxdoTzdIX3cin4HpBoHlPMiaXYx7+NZIN0WzU03Lfug==
X-Received: by 2002:a17:902:9a06:b0:13c:86d8:ce0b with SMTP id v6-20020a1709029a0600b0013c86d8ce0bmr23100015plp.51.1632149840313;
        Mon, 20 Sep 2021 07:57:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g14sm2659581pjk.20.2021.09.20.07.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:57:19 -0700 (PDT)
Date:   Mon, 20 Sep 2021 14:57:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Identify vCPU0 by its vcpu_idx instead of
 walking vCPUs array
Message-ID: <YUihS9CcTh9m53J6@google.com>
References: <20210910183220.2397812-1-seanjc@google.com>
 <20210910183220.2397812-3-seanjc@google.com>
 <87czpd2bsi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czpd2bsi.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Use vcpu_idx to identify vCPU0 when updating HyperV's TSC page, which is
> > shared by all vCPUs and "owned" by vCPU0 (because vCPU0 is the only vCPU
> > that's guaranteed to exist).  Using kvm_get_vcpu() to find vCPU works,
> > but it's a rather odd and suboptimal method to check the index of a given
> > vCPU.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 86539c1686fa..6ab851df08d1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >  				       offsetof(struct compat_vcpu_info, time));
> >  	if (vcpu->xen.vcpu_time_info_set)
> >  		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> > -	if (v == kvm_get_vcpu(v->kvm, 0))
> > +	if (!v->vcpu_idx)
> >  		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> >  	return 0;
> >  }
> 
> " ... instead of walking vCPUs array" in the Subject line is a bit
> confusing because kvm_get_vcpu() doesn't actually walk anything, it just
> returns 'kvm->vcpus[i]' after checking that we actually have that many
> vCPUs. The patch itself is OK, so

Argh, yes, I have a feeling I wrote the changelog after digging into the history
of kvm_get_vcpu().

Paolo, can you tweak the shortlog to:

  KVM: x86: Identify vCPU0 by its vcpu_idx instead of its vCPUs array entry
