Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD871D0E11
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 11:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388510AbgEMJ5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 05:57:55 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:43170 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388125AbgEMJ5v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 05:57:51 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 55C282E151D;
        Wed, 13 May 2020 12:57:43 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id kN8kAefgPz-veo4SIEZ;
        Wed, 13 May 2020 12:57:43 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589363863; bh=1cfd8xH0vbi0M0l1vMU5nxBWKuNZbw2VIldBqExvEII=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=ux9v5JTkhS3cSa1C8MiFtelG7aQhgkqLK5WaRam+3dIYTimWNkpWX4mpiT8B+jFpj
         zia8aDFIPt7ra0+cILIpv9/Ea4AY4p9voJ8yFln/No1mShuO5z0zYy+hAakCEE0JYf
         uMR0v16w/DKBIBOSlVNF5ELYdqVdnCXaOfvuzSFE=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-iva.dhcp.yndx.net (dynamic-iva.dhcp.yndx.net [2a02:6b8:b080:9009::1:1])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 9KzguSDiVz-veXa3aGK;
        Wed, 13 May 2020 12:57:40 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Wed, 13 May 2020 12:57:38 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH v11 5/7] x86/kvm/hyper-v: enable hypercalls without
 hypercall page with syndbg
Message-ID: <20200513095738.GC29650@rvkaganb.lan>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-6-arilou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424113746.3473563-6-arilou@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:37:44PM +0300, Jon Doron wrote:
> Microsoft's kdvm.dll dbgtransport module does not respect the hypercall
> page and simply identifies the CPU being used (AMD/Intel) and according
> to it simply makes hypercalls with the relevant instruction
> (vmmcall/vmcall respectively).
> 
> The relevant function in kdvm is KdHvConnectHypervisor which first checks
> if the hypercall page has been enabled via HV_X64_MSR_HYPERCALL_ENABLE,
> and in case it was not it simply sets the HV_X64_MSR_GUEST_OS_ID to
> 0x1000101010001 which means:
> build_number = 0x0001
> service_version = 0x01
> minor_version = 0x01
> major_version = 0x01
> os_id = 0x00 (Undefined)
> vendor_id = 1 (Microsoft)
> os_type = 0 (A value of 0 indicates a proprietary, closed source OS)
> 
> and starts issuing the hypercall without setting the hypercall page.

I guess this is to avoid interfering with the OS being debugged
requesting its own hypercall page at a different address.

> To resolve this issue simply enable hypercalls also if the guest_os_id
> is not 0 and the syndbg feature is enabled.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 435516595090..524b5466a515 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1650,7 +1650,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
>  
>  bool kvm_hv_hypercall_enabled(struct kvm *kvm)
>  {
> -	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
> +	struct kvm_hv *hv = &kvm->arch.hyperv;
> +
> +	return READ_ONCE(hv->hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE ||
> +	       (hv->hv_syndbg.active && READ_ONCE(hv->hv_guest_os_id) != 0);

This function is meant to tell if the hypercall should be interpreted as
following KVM or HyperV conventions.  Quoting from the spec

  3.5 Legal Hypercall Environments

  ...
  All hypercalls should be invoked through the architecturally-defined
  hypercall interface. (See the following sections for instructions on
  discovering and establishing this interface.) An attempt to invoke a
  hypercall by any other means (for example, copying the code from the
  hypercall code page to an alternate location and executing it from
  there) might result in an undefined operation (#UD) exception.  The
  hypervisor is not guaranteed to deliver this exception.

so I think we can simply test for hv_guest_os_id != 0 and ignore
HV_X64_MSR_HYPERCALL_ENABLE (it's about hypercall page being enabled,
not the hypercalls per se).

Thanks,
Roman.

>  }
>  
>  static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
> -- 
> 2.24.1
> 
