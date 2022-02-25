Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B2B4C47DC
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbiBYOrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241849AbiBYOrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:47:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69C593465B
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 06:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645800409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/G2knps6pP6nDHsHgQtsmWXR7eCwuWR+Id4H5oECinA=;
        b=Cg539A0VOlSlT/XTF5IQE8gtv3ZwYnEQDqeRSkq5l+YEsgH3m+WFzjxFSo2LD+kDN0/EcW
        AokSbcFSmosjCe6xeRnWoUEfHKInYuHabCV/Iw9jP6mkSx6xKsw7PSpObFRYSbwHlT9cck
        HYQf0CeN+cR9wmGHDoGUT0RQq2VGpZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-HWh4DxhzPqmmq-gT1KWONw-1; Fri, 25 Feb 2022 09:46:46 -0500
X-MC-Unique: HWh4DxhzPqmmq-gT1KWONw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC05B800425;
        Fri, 25 Feb 2022 14:46:43 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3B841037F2B;
        Fri, 25 Feb 2022 14:46:32 +0000 (UTC)
Message-ID: <79f5ce60c65280f4fb7cba0ceedaca0ff5595c48.camel@redhat.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>
Date:   Fri, 25 Feb 2022 16:46:31 +0200
In-Reply-To: <20220225082223.18288-7-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-7-guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> No normal guest has any reason to change physical APIC IDs, and
> allowing this introduces bugs into APIC acceleration code.
> 
> And Intel recent hardware just ignores writes to APIC_ID in
> xAPIC mode. More background can be found at:
> https://lore.kernel.org/lkml/Yfw5ddGNOnDqxMLs@google.com/
> 
> Looks there is no much value to support writable xAPIC ID in
> guest except supporting some old and crazy use cases which
> probably would fail on real hardware. So, make xAPIC ID
> read-only for KVM guests.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>

Assuming that this is approved and accepted upstream,
that is even better that my proposal of doing this
when APICv is enabled.

Since now apic id is always read only, now we should not 
forget to clean up some parts of kvm like kvm_recalculate_apic_map,
which are not needed anymore.

Best regards,
	Maxim Levitsky

> ---
>  arch/x86/kvm/lapic.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e4bcdab1fac0..b38288c8a94f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2044,10 +2044,17 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  
>  	switch (reg) {
>  	case APIC_ID:		/* Local APIC ID */
> -		if (!apic_x2apic_mode(apic))
> -			kvm_apic_set_xapic_id(apic, val >> 24);
> -		else
> +		if (apic_x2apic_mode(apic)) {
>  			ret = 1;
> +			break;
> +		}
> +		/* Don't allow changing APIC ID to avoid unexpected issues */
> +		if ((val >> 24) != apic->vcpu->vcpu_id) {
> +			kvm_vm_bugged(apic->vcpu->kvm);
> +			break;
> +		}
> +
> +		kvm_apic_set_xapic_id(apic, val >> 24);
>  		break;
>  
>  	case APIC_TASKPRI:
> @@ -2631,11 +2638,15 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
>  static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>  		struct kvm_lapic_state *s, bool set)
>  {
> -	if (apic_x2apic_mode(vcpu->arch.apic)) {
> -		u32 *id = (u32 *)(s->regs + APIC_ID);
> -		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
> -		u64 icr;
> +	u32 *id = (u32 *)(s->regs + APIC_ID);
> +	u32 *ldr = (u32 *)(s->regs + APIC_LDR);
> +	u64 icr;
>  
> +	if (!apic_x2apic_mode(vcpu->arch.apic)) {
> +		/* Don't allow changing APIC ID to avoid unexpected issues */
> +		if ((*id >> 24) != vcpu->vcpu_id)
> +			return -EINVAL;
> +	} else {
>  		if (vcpu->kvm->arch.x2apic_format) {
>  			if (*id != vcpu->vcpu_id)
>  				return -EINVAL;


