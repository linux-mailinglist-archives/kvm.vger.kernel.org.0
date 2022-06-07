Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04CB53F6D1
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 09:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiFGHFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 03:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiFGHFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 03:05:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FE87E1FD;
        Tue,  7 Jun 2022 00:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654585536; x=1686121536;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VBaWGyNbM6l8jy8MTHxWHNPh1OQlXdGd2FB0zZJMcNU=;
  b=XBgOodGuuv4UlzQIGltJSXpA+eTkXAc56rz+NILiGU1+Gh7E5WoxC+I1
   svdenC6aO6nNlaGM4qFkadB5B2UXxZnp0/3yXxbamxh4e+9fOadfYG8BT
   3kq0viEXOL2OHUzTreMuJZHV+7xRBl6eB6Mq6Je8kJEbSl77RlgRBAAxA
   OFZWK9PDll33xE/LV+cDJWz3tcr3DwtxWTEubI/eOPPNRyT0k7w0kPj8q
   i+p2OP1H0kmdWoc1SYCpj3i+OiT0u9gyv/nsDQoZhyl1yaQfUmkQX6nzp
   4CoLvBDyb1vX+RCOEAxEWVIR3pYTOTDK2lw8sPDVJf7KiBJbyCEdWmbWh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="275485321"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="275485321"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:05:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="635984407"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:05:32 -0700
Date:   Tue, 7 Jun 2022 15:05:20 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/7] KVM: x86: inhibit APICv/AVIC when the guest and/or
 host changes either apic id or the apic base from their default values.
Message-ID: <20220607070515.GA26909@gao-cwp>
References: <20220606180829.102503-1-mlevitsk@redhat.com>
 <20220606180829.102503-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606180829.102503-3-mlevitsk@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 09:08:24PM +0300, Maxim Levitsky wrote:
>+	/*
>+	 * For simplicity, the APIC acceleration is inhibited
>+	 * first time either APIC ID or APIC base are changed by the guest
>+	 * from their reset values.
>+	 */
>+	APICV_INHIBIT_REASON_APIC_ID_MODIFIED,
>+	APICV_INHIBIT_REASON_APIC_BASE_MODIFIED,
>+
>+

Remove one newline.

> void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
>@@ -2666,6 +2683,8 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
> 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
> 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
> 		}
>+	} else {
>+		kvm_lapic_xapic_id_updated(vcpu->arch.apic);

Strictly speaking, this is needed only for "set" cases.
