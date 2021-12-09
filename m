Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB1146EC12
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240192AbhLIPtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240158AbhLIPtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:49:03 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFEEC061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 07:45:29 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id m24so5404970pgn.7
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 07:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DMB6spvibGxVU/+VTs+sCniEDJa7q1WtFQnSMx4TKv0=;
        b=JL3ywlMl+rqRWktZIQaSKNPRmDzI/JO3XCKiJ8r7GZIJxKRbuMrdFvJsbWt1pYioh9
         josJ5RJh5Y7Gyd5B1O4mVdtBWDNnScai+DDi5wWJSYT2NFXcDASTnNem11dZihnx5dgI
         5O8EEPZhSK8bche/ll7QO96eeHWRqH3SaozruBdVk6+2nMJ2qDDNNWWvIU2HLyMU70UE
         6L9viCV8FiEWMQtB4VxXBEyefmhmBVeEERG/AfMc+wu+/rM/NbrrxDKgd2fzbiUODYOc
         HFj2lkeeIM06mojzvzfu3yDjvsVAmtVLVsuaIdYN2RrouQl4LdB+8G8WqMk/sFE1rF9C
         6C2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DMB6spvibGxVU/+VTs+sCniEDJa7q1WtFQnSMx4TKv0=;
        b=B9cqKQQ7QHmwYPXuG1Q+tm22sVIvoDSKyq0T9d4PrNu0zaJi1c5U/6MqMw+S2jWgbH
         tgm9J53JuRWSseGgoqcL3ykJk29ZhS6uI4YIGTcbJqkeZ/nI3YmD8kA3Bp9tjqmorORP
         4w57RyOtHFgdx1Gg1FP87wo+kdYcUAR3Yr3F+DpNZfmjFB0CJvNmKHOClDbVDruF9ZHk
         cPsZPPlJk7VHAUFqGYb2+/XnTcpbPWKp3J51LtWjRute8mD+oOd0uhs4ynvs4qJn1vhi
         XdlBTYFTlkwF0MZxt2NWuFWJ9QgZBeYQxdHtIiUue7Jq08G5LceRBoI5mTsWApIGqpbU
         6wbg==
X-Gm-Message-State: AOAM531Al3y4/uhBxZPEmz47UcdcQalPhM4js2p71fPF7VjfWeLlMBXS
        4p8PsQcu6zgW7gdrnPmkfSzn1g==
X-Google-Smtp-Source: ABdhPJzfr6ZOaNUFGkDN7LvTK2YY1tb9EksA+oA91YEVzv4A177yuuGRAMZuUgWC4VV06/F+8PoQbw==
X-Received: by 2002:a05:6a00:2349:b0:4a8:d87:e8ad with SMTP id j9-20020a056a00234900b004a80d87e8admr12456531pfj.15.1639064728692;
        Thu, 09 Dec 2021 07:45:28 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ip5sm131157pjb.5.2021.12.09.07.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 07:45:28 -0800 (PST)
Date:   Thu, 9 Dec 2021 15:45:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
Message-ID: <YbIklNHIFnREGFAp@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
 <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
 <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
 <YbFHsYJ5ua3J286o@google.com>
 <3bf8d500-0c1e-92dd-20c8-c3c231d2cbed@redhat.com>
 <346f5a5e93077ba20188a9b0e67bb3a44e2cad48.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <346f5a5e93077ba20188a9b0e67bb3a44e2cad48.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Maxim Levitsky wrote:
> On Thu, 2021-12-09 at 15:29 +0100, Paolo Bonzini wrote:
> > On 12/9/21 01:02, Sean Christopherson wrote:
> > > RDX, a.k.a. ir_data is NULL.  This check in svm_ir_list_add()
> > > 
> > > 	if (pi->ir_data && (pi->prev_ga_tag != 0)) {
> > > 
> > > implies pi->ir_data can be NULL, but neither avic_update_iommu_vcpu_affinity()
> > > nor amd_iommu_update_ga() check ir->data for NULL.
> > > 
> > > amd_ir_set_vcpu_affinity() returns "success" without clearing pi.is_guest_mode
> > > 
> > > 	/* Note:
> > > 	 * This device has never been set up for guest mode.
> > > 	 * we should not modify the IRTE
> > > 	 */
> > > 	if (!dev_data || !dev_data->use_vapic)
> > > 		return 0;
> > > 
> > > so it's plausible svm_ir_list_add() could add to the list with a NULL pi->ir_data.
> > > 
> > > But none of the relevant code has seen any meaningful changes since 5.15, so odds
> > > are good I broke something :-/
> 
> Doesn't reproduce here yet even with my iommu changes :-(
> Oh well.

Hmm, which suggests it could be an existing corner case.

Based on the above, this seems prudent and correct:

@@ -747,7 +754,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
         * so we need to check here if it's already been * added
         * to the ir_list.
         */
-       if (pi->ir_data && (pi->prev_ga_tag != 0)) {
+       if (pi->prev_ga_tag != 0) {
                struct kvm *kvm = svm->vcpu.kvm;
                u32 vcpu_id = AVIC_GATAG_TO_VCPUID(pi->prev_ga_tag);
                struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
@@ -877,7 +884,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
                         * we can reference to them directly when we update vcpu
                         * scheduling information in IOMMU irte.
                         */
-                       if (!ret && pi.is_guest_mode)
+                       if (!ret && pi.is_guest_mode && pi.ir_data)
                                svm_ir_list_add(svm, &pi);
                } else {
                        /* Use legacy mode in IRTE */
@@ -898,7 +905,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
                         * was cached. If so, we need to clean up the per-vcpu
                         * ir_list.
                         */
-                       if (!ret && pi.prev_ga_tag) {
+                       if (!ret && pi.prev_ga_tag && !WARN_ON(!pi.ir_data)) {
                                int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
                                struct kvm_vcpu *vcpu;


