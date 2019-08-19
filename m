Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D3692142
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 12:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfHSK24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 06:28:56 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:9228 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHSK24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 06:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566210535; x=1597746535;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8juN2PxBVL4hGx4Tvz2bwcRiT1/klSy3N6m9IOSrqq4=;
  b=EHPiHwVgaIK9dvyzHmG4wENMwswWH+kt9EFyegp3ZMfYKmGQxd0FQJiw
   FyI6zsx5nfVejqGNONn39J233ETuamciIN5916Rz2nzPfJcoyR93QN+CH
   FdKJwQ3nMfT2MdLBDskB7/nWToSuwmstKKw7MW/EO2PzryxoO5W0GxD6M
   I=;
X-IronPort-AV: E=Sophos;i="5.64,403,1559520000"; 
   d="scan'208";a="821165563"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Aug 2019 10:28:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 5CD89A1C35;
        Mon, 19 Aug 2019 10:28:35 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 10:28:34 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.100) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 10:28:31 +0000
Subject: Re: [PATCH v2 09/15] svm: Add support for activate/deactivate AVIC at
 runtime
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-10-git-send-email-suravee.suthikulpanit@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <bb769da2-0e38-ff1b-bd40-9cfed1c84b88@amazon.com>
Date:   Mon, 19 Aug 2019 12:28:29 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565886293-115836-10-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
> Add necessary logics for supporting activate/deactivate AVIC at runtime.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/svm.c | 27 +++++++++++++++++++++++++--
>   1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 47f2439..cfa4b13 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -385,6 +385,7 @@ struct amd_svm_iommu_ir {
>   static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
>   static void svm_complete_interrupts(struct vcpu_svm *svm);
>   static bool svm_get_enable_apicv(struct kvm *kvm);
> +static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
>   
>   static int nested_svm_exit_handled(struct vcpu_svm *svm);
>   static int nested_svm_intercept(struct vcpu_svm *svm);
> @@ -2343,6 +2344,10 @@ static void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
>   
>   static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   {
> +	if (kvm_check_request(KVM_REQ_APICV_ACTIVATE, vcpu))
> +		kvm_vcpu_activate_apicv(vcpu);
> +	if (kvm_check_request(KVM_REQ_APICV_DEACTIVATE, vcpu))
> +		kvm_vcpu_deactivate_apicv(vcpu);
>   	avic_set_running(vcpu, true);
>   }
>   
> @@ -5182,10 +5187,19 @@ static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	struct vmcb *vmcb = svm->vmcb;
>   
> -	if (kvm_vcpu_apicv_active(vcpu))
> +	if (kvm_vcpu_apicv_active(vcpu)) {
> +		/**
> +		 * During AVIC temporary deactivation, guest could update
> +		 * APIC ID, DFR and LDR registers, which would not be trapped
> +		 * by avic_unaccelerated_ccess_interception(). In this case,

typo

Alex
