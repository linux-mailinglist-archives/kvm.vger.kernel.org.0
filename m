Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3673437363B
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEEIZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:25:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231774AbhEEIZj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620203083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8wZ6XP6OkIUA9lJMeKzZLCGEWjnWoB/ZPPsPtnXehl4=;
        b=Y4/DGgoIcia1zEBe2jGVyAJSDqGwzozaXv7fRGO7wDXUl6+DygQq471R7LXJy8EdWImQ2+
        PolMqYMZpeMJmp4B7PcNTwosXJZM5Ap6xoa6CWQ89FJ6HRpgUrvEp3ns6YW83qdhZLNSUm
        SkjrvHIR3m01MFNpJ4ZC+NvGf2F95CU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-JEfIPDrIMYmwsIlNDiiB0g-1; Wed, 05 May 2021 04:24:39 -0400
X-MC-Unique: JEfIPDrIMYmwsIlNDiiB0g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FCF584A5E7;
        Wed,  5 May 2021 08:24:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CEFE60C17;
        Wed,  5 May 2021 08:24:36 +0000 (UTC)
Message-ID: <634edad3ff66e3a63bbfd0b1728a29010d3dbff8.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: nVMX: Introduce
 __nested_vmx_handle_enlightened_vmptrld()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Wed, 05 May 2021 11:24:35 +0300
In-Reply-To: <20210503150854.1144255-4-vkuznets@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
         <20210503150854.1144255-4-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-03 at 17:08 +0200, Vitaly Kuznetsov wrote:
> As a preparation to mapping eVMCS from vmx_set_nested_state() split
> the actual eVMCS mappign from aquiring eVMCS GPA.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2febb1dd68e8..37fdc34f7afc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1972,18 +1972,11 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>   * This is an equivalent of the nested hypervisor executing the vmptrld
>   * instruction.
>   */
> -static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
> -	struct kvm_vcpu *vcpu, bool from_launch)
> +static enum nested_evmptrld_status __nested_vmx_handle_enlightened_vmptrld(
> +	struct kvm_vcpu *vcpu, u64 evmcs_gpa, bool from_launch)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	bool evmcs_gpa_changed = false;
> -	u64 evmcs_gpa;
> -
> -	if (likely(!vmx->nested.enlightened_vmcs_enabled))
> -		return EVMPTRLD_DISABLED;
> -
> -	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
> -		return EVMPTRLD_DISABLED;
>  
>  	if (unlikely(!vmx->nested.hv_evmcs ||
>  		     evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
> @@ -2055,6 +2048,21 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  	return EVMPTRLD_SUCCEEDED;
>  }
>  
> +static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
> +	struct kvm_vcpu *vcpu, bool from_launch)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u64 evmcs_gpa;
> +
> +	if (likely(!vmx->nested.enlightened_vmcs_enabled))
> +		return EVMPTRLD_DISABLED;
> +
> +	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
> +		return EVMPTRLD_DISABLED;
> +
> +	return __nested_vmx_handle_enlightened_vmptrld(vcpu, evmcs_gpa, from_launch);
> +}
> +
>  void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

