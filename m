Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA01A2CF403
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgLDS1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:27:40 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:49206 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbgLDS1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:27:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607106459; x=1638642459;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nNaTTuE8NTspyyTWE4916CrB2EeUC04oHAOOEtolxQE=;
  b=JuG+gJ6xa7y8Vhk68mjVjeRWpoomXOIvYjzcR6EnFgThw1xY+V5+EPNk
   HXcl7yXwizs6WRGla8t6hXRwUMvBYCH0fbGfkhsk3VeO3RXUnZejtzF3p
   5FHfa1lWzuILHPhyPsP1pWAGaNDIaJ3yXY2eExv9AR9gCZZLctRkUkrL5
   o=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="93586557"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 04 Dec 2020 18:26:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id A19A7A1D76;
        Fri,  4 Dec 2020 18:26:41 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:26:40 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.21) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:26:38 +0000
Subject: Re: [PATCH 02/15] KVM: x86/xen: fix Xen hypercall page msr handling
To:     David Woodhouse <dwmw2@infradead.org>, <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
 <20201204011848.2967588-3-dwmw2@infradead.org>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <a7eff397-4b2b-6644-8425-88bc33b3a050@amazon.com>
Date:   Fri, 4 Dec 2020 19:26:36 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204011848.2967588-3-dwmw2@infradead.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D20UWA004.ant.amazon.com (10.43.160.62) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.12.20 02:18, David Woodhouse wrote:
> From: Joao Martins <joao.m.martins@oracle.com>
> =

> Xen usually places its MSR at 0x40000000 or 0x40000200 depending on
> whether it is running in viridian mode or not. Note that this is not
> ABI guaranteed, so it is possible for Xen to advertise the MSR some
> place else.
> =

> Given the way xen_hvm_config() is handled, if the former address is
> selected, this will conflict with Hyper-V's MSR
> (HV_X64_MSR_GUEST_OS_ID) which unconditionally uses the same address.
> =

> Given that the MSR location is arbitrary, move the xen_hvm_config()
> handling to the top of kvm_set_msr_common() before falling through.
> =

> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> =

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c7f1ba21212e..13ba4a64f748 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3001,6 +3001,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
>   	u32 msr =3D msr_info->index;
>   	u64 data =3D msr_info->data;
>   =

> +	if (msr && (msr =3D=3D vcpu->kvm->arch.xen_hvm_config.msr))
> +		return xen_hvm_config(vcpu, data);

How much of this can we handle with the MSR allow listing and MSR =

trapping in user space?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



