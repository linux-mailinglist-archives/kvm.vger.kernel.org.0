Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C1F38F28C
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhEXRwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:52:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233671AbhEXRwl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:52:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621878672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wqUU2UG3tfGEg8npPTduyrKCAL53e83arj05iaYp1GE=;
        b=PQWRxmnSfYTLMd4o48dHNwTr14xtvG7L8LpjS66jEG/l4YeMcIkxG/hOjLLiwH+/Y7DYbw
        4E4Pi1MeVdXCYz70UKPorbxTVf4CTKbw9wysE8tTeBmUnNQt6x78XDHjKmiUQN3JawV8Ph
        vPiON+fdmL7bHxrmH9/ycuxIe9A/BdM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-20CH4WNaOsCmUv_xmCeFSA-1; Mon, 24 May 2021 13:51:11 -0400
X-MC-Unique: 20CH4WNaOsCmUv_xmCeFSA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 815241060BB7;
        Mon, 24 May 2021 17:50:45 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32DF42AE89;
        Mon, 24 May 2021 17:50:41 +0000 (UTC)
Message-ID: <f266a026b803f1f130cedf06d12e784956888156.camel@redhat.com>
Subject: Re: [PATCH v3 04/12] KVM: X86: Add a ratio parameter to
 kvm_scale_tsc()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 24 May 2021 20:50:41 +0300
In-Reply-To: <cba90aa4-0665-a2d5-29e0-133e0aa45ad2@redhat.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-5-ilstam@amazon.com>
         <cba90aa4-0665-a2d5-29e0-133e0aa45ad2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-24 at 16:23 +0200, Paolo Bonzini wrote:
> On 21/05/21 12:24, Ilias Stamatis wrote:
> > @@ -3537,10 +3539,14 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >   		 * return L1's TSC value to ensure backwards-compatible
> >   		 * behavior for migration.
> >   		 */
> > -		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
> > -							    vcpu->arch.tsc_offset;
> > -
> > -		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
> > +		if (msr_info->host_initiated)
> > +			msr_info->data = kvm_scale_tsc(
> > +				vcpu, rdtsc(), vcpu->arch.l1_tsc_scaling_ratio
> > +				) + vcpu->arch.l1_tsc_offset;
> 
> Better indentation:
> 
> 	msr_info->data = vcpu->arch.l1_tsc_offset +
> 		kvm_scale_tsc(vcpu, rdtsc(),
> 			      vcpu->arch.tsc_scaling_ratio);

Good idea IMHO.
Other than that:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



> 
> Same below.
> 
> Paolo
> 
> > +		else
> > +			msr_info->data = kvm_scale_tsc(
> > +				vcpu, rdtsc(), vcpu->arch.tsc_scaling_ratio
> > +				) + vcpu->arch.tsc_offset;
> >   		break;
> >   	}
> >   	case MSR_MTRRcap:
> > 


