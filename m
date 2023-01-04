Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271AE65D640
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 15:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239486AbjADOnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 09:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbjADOms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 09:42:48 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFDA1B9DD
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 06:42:45 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id n4so36087206plp.1
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 06:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XqrtrKRhDtPaDDzxdLxDCGFf7RuTdmXM7ZNOkYasJp0=;
        b=annFklxy87JJ3NRbnht+zPMvo+BAwdt75U4NiJoQVnyUOKlpPtp/cRuA2vofqUcQCi
         P0vuJl1DIw3GMfw5OTu1tZiv2Vj3qPg+WnN/Jx7K9J6RdGVZSi9zs+Zlp1gP2aqAhVjL
         AqzsIO9GT4hQEORUz+CRmEUeKbk0I42JGplO2YoztwiDlYiMb+TO9BJa/n3E5GXZhbuL
         GhjKblEIvWoseorJLshQnlvMK+QxSrk5smdrSblQmZ7FyzYfHXRZfElfeDV+lX1tb3YX
         bS2etoCnGfiK5NAvxGZ+DWDbLoy2IBD1CMYXN4G6CS+r9yhOO0i7f3uaOMNTgYA4dxv9
         aDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqrtrKRhDtPaDDzxdLxDCGFf7RuTdmXM7ZNOkYasJp0=;
        b=NLypy3rrn9x/1pyMGBr55gNKwtWm9aRo2keEBUPauXQEAHAuoHt5bwJZS1Tu6AQzT7
         E4oJwdSzAbv8hAPj/QUhXfjT0NxHjoBHb1GWlmSklCbsWb9/N/PKdeSJ1VtlY8wf76E7
         LotNlFD8n002jR1kR32EMMDpZMphcRiMjpMzpLo5V5SXMr6ds8PsA5B6lpmcjmwoYkXB
         +iCAw58PKbaAMr/OdRmWxiIfsIshMuYNk4DCCrRLfGdRnCkL7QV9R6RD2O6TTRpWSB86
         1UCvjuPCg83jq4Xf6pVq/n53KrqXxu2sIvG9dJVCH+dCsxVSf2Zg66s1aW/jWHCi/aQf
         G3Lw==
X-Gm-Message-State: AFqh2kq2wMT800Gmjr7TpuT8kPSUftREiieHoU/p79KxfUWz3Z67TnAb
        NiR6Nc+cHpDmd3iW+V82rpHMPfoDdMYqX7G6
X-Google-Smtp-Source: AMrXdXtZlSUzwJzX/CvX/YPyt/O1AXFajoGSeAYuzp0beESFSo5sq4QF1exhZz+z45WMIHfXVDWBFg==
X-Received: by 2002:a05:6a20:7f59:b0:ac:af5c:2970 with SMTP id e25-20020a056a207f5900b000acaf5c2970mr3145986pzk.3.1672843364859;
        Wed, 04 Jan 2023 06:42:44 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z15-20020a63190f000000b0046ffe3fea77sm20377445pgl.76.2023.01.04.06.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:42:44 -0800 (PST)
Date:   Wed, 4 Jan 2023 14:42:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [PATCH v2 3/4] KVM: nVMX: Don't muck with allowed sec exec
 controls on CPUID changes
Message-ID: <Y7WQYLO4Ou8M8ElV@google.com>
References: <20221213062306.667649-1-seanjc@google.com>
 <20221213062306.667649-4-seanjc@google.com>
 <70872206-7a75-0a19-3df5-a97207e710fa@redhat.com>
 <Y7WNrZ9NaDHOxwuG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7WNrZ9NaDHOxwuG@google.com>
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

On Wed, Jan 04, 2023, Sean Christopherson wrote:
> On Fri, Dec 23, 2022, Paolo Bonzini wrote:
> > On 12/13/22 07:23, Sean Christopherson wrote:
> > > Don't modify the set of allowed secondary execution controls, i.e. the
> > > virtual MSR_IA32_VMX_PROCBASED_CTLS2, in response to guest CPUID changes.
> > > To avoid breaking old userspace that never sets the VMX MSRs, i.e. relies
> > > on KVM to provide a consistent vCPU model, keep the existing behavior if
> > > userspace has never written MSR_IA32_VMX_PROCBASED_CTLS2.
> > > 
> > > KVM should not modify the VMX capabilities presented to L1 based on CPUID
> > > as doing so may discard explicit settings provided by userspace.  E.g. if
> > > userspace does KVM_SET_MSRS => KVM_SET_CPUID and disables a feature in
> > > the VMX MSRs but not CPUID (to prevent exposing the feature to L2), then
> > > stuffing the VMX MSRs during KVM_SET_CPUID will expose the feature to L2
> > > against userspace's wishes.
> > 
> > The commit message doesn't explain *why* KVM_SET_CPUID would be done before
> > KVM_SET_MSRS.
> 
> I assume you mean why KVM_SET_MSRS would be done before KVM_SET_CPUID2?
> 
> This patch is mostly paranoia, AFAIK there is no userspace that is negatively
> affected by KVM's manipulations.  The only case I can think of is if userspace
> wanted to emulate dynamic CPUID updates, e.g. set an MSR filter to intercept writes
> to MISC_ENABLES to update MONITOR/MWAIT support, but that behavior isn't allowed
> since commit feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN").
> 
> There are scenarios where userspace might do KVM_SET_MSRS before KVM_SET_CPUID,
> e.g. QEMU's reuse of a vCPU for CPU hotplug, but in those cases I would expect
> userspace to follow up with another KVM_SET_MSRS.

An argument for taking this patch is that it might be necessary to disallow
KVM_SET_MSRS after KVM_RUN[*].  If KVM manipulates VMX MSRs during KVM_SET_CPUID2,
reusing a vCPU with sequence:

  SET_CPUID2 => SET_MSRS => RUN => unplug => hotplug => SET_CPUID2 => SET_MSRS

sequence will cause the second SET_MSRS to fail due to userspace "changing" the
MSR value.

[*] https://lore.kernel.org/all/20220805172945.35412-4-seanjc@google.com
