Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DF31C38CB
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 14:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgEDMCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 08:02:08 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:59234 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgEDMCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 08:02:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588593728; x=1620129728;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=oz/2ALb5OVTxQnVg7IfzEFgf/Uw6IfZKqeh0udnmnjg=;
  b=qQf6XSk7brf4LID4dKCKcDk+kHXJIZXiHuSFWXO4Y1Qfsa4VWLR2ggDI
   xHUgUObj6ZXLkHNHvNMAxOPOUg+L8n/jt/pDwGbzsMNrz7rCpExvl5Gak
   R5QocMILYFWIP1jumHP4gzS1/xZGNYtPFyHMlUa22Z6JQfDTgUgidxkMA
   I=;
IronPort-SDR: D9MG6OUrNRO3shhHXPKjuNCQd3zrfkdDTNWVXm3w7W8GpmmWJb7x2Ghr4OsPW6akkDY0+i5its
 089G92bYV8cw==
X-IronPort-AV: E=Sophos;i="5.73,351,1583193600"; 
   d="scan'208";a="29930547"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 May 2020 12:01:54 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 021E3A450F;
        Mon,  4 May 2020 12:01:51 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 4 May 2020 12:01:51 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.247) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 4 May 2020 12:01:48 +0000
Subject: Re: [PATCH v2] KVM: nVMX: Skip IBPB when switching between vmcs01 and
 vmcs02
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        KarimAllah Raslan <karahmed@amazon.de>
References: <20200501163117.4655-1-sean.j.christopherson@intel.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <1de7b016-8bc9-23d4-7f8b-145c30d7e58a@amazon.com>
Date:   Mon, 4 May 2020 14:01:46 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501163117.4655-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.247]
X-ClientProxiedBy: EX13D07UWB004.ant.amazon.com (10.43.161.196) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01.05.20 18:31, Sean Christopherson wrote:
> =

> Skip the Indirect Branch Prediction Barrier that is triggered on a VMCS
> switch when running with spectre_v2_user=3Don/auto if the switch is
> between two VMCSes in the same guest, i.e. between vmcs01 and vmcs02.
> The IBPB is intended to prevent one guest from attacking another, which
> is unnecessary in the nested case as it's the same guest from KVM's
> perspective.
> =

> This all but eliminates the overhead observed for nested VMX transitions
> when running with CONFIG_RETPOLINE=3Dy and spectre_v2_user=3Don/auto, whi=
ch
> can be significant, e.g. roughly 3x on current systems.
> =

> Reported-by: Alexander Graf <graf@amazon.com>
> Cc: KarimAllah Raslan <karahmed@amazon.de>
> Cc: stable@vger.kernel.org
> Fixes: 15d45071523d ("KVM/x86: Add IBPB support")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> =

> v2: Pass a boolean to indicate a nested VMCS switch and instead WARN if
>      the buddy VMCS is not already loaded.  [Alex]
> =

> Paolo, feel free to drop the WARN_ON_ONCE() if you think it's overkill.
> I'm 50/50 as to whether it's useful or just a waste of cycles.  Figured
> it'd be easier for you to delete a line of code while applying than to add
> and test a new WARN.

I like the WARN_ON :). It should be almost free during execution, but =

helps us catch problems early.

> =

>   arch/x86/kvm/vmx/nested.c | 3 ++-
>   arch/x86/kvm/vmx/vmx.c    | 7 ++++---
>   arch/x86/kvm/vmx/vmx.h    | 2 +-
>   3 files changed, 7 insertions(+), 5 deletions(-)
> =

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2c36f3f53108..b57420f3dd8f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -302,8 +302,9 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, st=
ruct loaded_vmcs *vmcs)
> =

>          cpu =3D get_cpu();
>          prev =3D vmx->loaded_vmcs;
> +       WARN_ON_ONCE(prev->cpu !=3D cpu || prev->vmcs !=3D per_cpu(curren=
t_vmcs, cpu));
>          vmx->loaded_vmcs =3D vmcs;
> -       vmx_vcpu_load_vmcs(vcpu, cpu);
> +       vmx_vcpu_load_vmcs(vcpu, cpu, true);
>          vmx_sync_vmcs_host_state(vmx, prev);
>          put_cpu();
> =

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ab6ca6062ce..d3d57b7a67bd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1311,7 +1311,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu,=
 int cpu)
>                  pi_set_on(pi_desc);
>   }
> =

> -void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
> +void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool nested_swit=
ch)
>   {
>          struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>          bool already_loaded =3D vmx->loaded_vmcs->cpu =3D=3D cpu;
> @@ -1336,7 +1336,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int =
cpu)
>          if (per_cpu(current_vmcs, cpu) !=3D vmx->loaded_vmcs->vmcs) {
>                  per_cpu(current_vmcs, cpu) =3D vmx->loaded_vmcs->vmcs;
>                  vmcs_load(vmx->loaded_vmcs->vmcs);
> -               indirect_branch_prediction_barrier();

... however, this really needs an in-code comment to explain why it's =

safe not to flush the branch predictor cache here.


Alex

> +               if (!nested_switch)
> +                       indirect_branch_prediction_barrier();
>          }
> =

>          if (!already_loaded) {
> @@ -1377,7 +1378,7 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
>          struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> =

> -       vmx_vcpu_load_vmcs(vcpu, cpu);
> +       vmx_vcpu_load_vmcs(vcpu, cpu, false);
> =

>          vmx_vcpu_pi_load(vcpu, cpu);
> =

> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index b5e773267abe..fa61dc802183 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -320,7 +320,7 @@ struct kvm_vmx {
>   };
> =

>   bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
> -void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
> +void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool nested_swit=
ch);
>   void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   int allocate_vpid(void);
>   void free_vpid(int vpid);
> --
> 2.26.0
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



