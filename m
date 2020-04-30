Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9678F1C0915
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 23:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD3VWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 17:22:43 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:12249 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgD3VWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 17:22:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588281761; x=1619817761;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=R85mSEOiDPExipXCKiyyxcZ8wk8+srWzK1sdW3PJo6s=;
  b=DZ/JgdA8Lq4uZg4Agw9UAShBP5aWUj9gAtfxG/k14R9MP+7JezMjYCLY
   OTdXOS1jh4GtCspET/xm3D/CWcGYADGB0nfNDcKNj/rr4ucxNzUd+Oy3M
   J/8mIPidGBEwl6yc5zWCOapDDFncKz5MGVF9+wQWeKv5bTo1/YDyGUI9C
   k=;
IronPort-SDR: oEHK2ToZkriP1eT0iPQFIJPcanP/8PpJfffNtBqFZlp7Ja3lYP3wmtKAwkLxcsZCbpez6jesAN
 7+8OeRGoqTIQ==
X-IronPort-AV: E=Sophos;i="5.73,337,1583193600"; 
   d="scan'208";a="28079140"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 30 Apr 2020 21:22:28 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 3F30BA212E;
        Thu, 30 Apr 2020 21:22:27 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 21:22:26 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.100) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 21:22:24 +0000
Subject: Re: [PATCH] KVM: nVMX: Skip IBPB when switching between vmcs01 and
 vmcs02
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        KarimAllah Raslan <karahmed@amazon.de>
References: <20200430204123.2608-1-sean.j.christopherson@intel.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <853bea8c-41b8-ba3e-0a7c-c5df3b5dac9e@amazon.com>
Date:   Thu, 30 Apr 2020 23:22:20 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430204123.2608-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D13UWB002.ant.amazon.com (10.43.161.21) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30.04.20 22:41, Sean Christopherson wrote:
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

I can confirm that with kvm-unit-test's vmcall benchmark, the patch does =

make a big difference:

   BEFORE: vmcall 33488
   AFTER:  vmcall 14898

So we're at least getting a good chunk of performance back :)

> ---
>   arch/x86/kvm/vmx/nested.c |  2 +-
>   arch/x86/kvm/vmx/vmx.c    | 12 ++++++++----
>   arch/x86/kvm/vmx/vmx.h    |  3 ++-
>   3 files changed, 11 insertions(+), 6 deletions(-)
> =

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2c36f3f53108..1a02bdfeeb2b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -303,7 +303,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, st=
ruct loaded_vmcs *vmcs)
>          cpu =3D get_cpu();
>          prev =3D vmx->loaded_vmcs;
>          vmx->loaded_vmcs =3D vmcs;
> -       vmx_vcpu_load_vmcs(vcpu, cpu);
> +       vmx_vcpu_load_vmcs(vcpu, cpu, prev);
>          vmx_sync_vmcs_host_state(vmx, prev);
>          put_cpu();
> =

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ab6ca6062ce..818dd8ba5e9f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1311,10 +1311,12 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcp=
u, int cpu)
>                  pi_set_on(pi_desc);
>   }
> =

> -void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
> +void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
> +                       struct loaded_vmcs *buddy)
>   {
>          struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>          bool already_loaded =3D vmx->loaded_vmcs->cpu =3D=3D cpu;
> +       struct vmcs *prev;
> =

>          if (!already_loaded) {
>                  loaded_vmcs_clear(vmx->loaded_vmcs);
> @@ -1333,10 +1335,12 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, in=
t cpu)
>                  local_irq_enable();
>          }
> =

> -       if (per_cpu(current_vmcs, cpu) !=3D vmx->loaded_vmcs->vmcs) {
> +       prev =3D per_cpu(current_vmcs, cpu);
> +       if (prev !=3D vmx->loaded_vmcs->vmcs) {
>                  per_cpu(current_vmcs, cpu) =3D vmx->loaded_vmcs->vmcs;
>                  vmcs_load(vmx->loaded_vmcs->vmcs);
> -               indirect_branch_prediction_barrier();
> +               if (!buddy || buddy->vmcs !=3D prev)
> +                       indirect_branch_prediction_barrier();

I fail to understand the logic here though. What exactly are you trying =

to catch? We only do the barrier when the current_vmcs as loaded by =

vmx_vcpu_load_vmcs is different from the vmcs of the context that was =

issuing the vmcs load.

Isn't this a really complicated way to say "Don't flush for nested"? Why =

not just make it explicit and pass in a bool that says "nested =3D true" =

from vmx_switch_vmcs()? Is there any case I'm missing where that would =

be unsafe?


Thanks,

Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



