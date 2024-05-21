Return-Path: <kvm+bounces-17836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 019C28CAE5F
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 14:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F731B23C3B
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 12:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6382770E2;
	Tue, 21 May 2024 12:34:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137E5524C9;
	Tue, 21 May 2024 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716294850; cv=none; b=T+nrhqGQ+lLgz5LrtJnoieISOzwFkv5LsykhqiUMB6C1o9QWLUcAU6/BPMMZiCRsdCPk0wxh2B125IaF8Ax9k5jpmWJueOCVSUeahWPUhB1PG5l7oUIfwZx4ASlSnIQeJP3PbDtU+qsvKz5FIWeyNe4Lz8aaixJ9umO8L/3fkoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716294850; c=relaxed/simple;
	bh=klFMtCXpziUaCzMqighpqCF4wxWpzZvtLato+DYem2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GdE7plAtsfYt3jsiXiCU1h/X6vxoCFTxRWKiq7HVymtkJ4NcfClC4LddQj/PxutoMQJ5Cz5kMYhN5nT982OrUzA8oJ+JPiTuMpwnwzQcEuB7u0zCDUVRgA/miaI7KuVr8/863iCXmZoRv7JF4jUMYfPxII/i2Jk2sVDI0DIXmMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VkDKq6Nt7zwPGn;
	Tue, 21 May 2024 20:30:23 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (unknown [7.185.36.236])
	by mail.maildlp.com (Postfix) with ESMTPS id E3BC214011D;
	Tue, 21 May 2024 20:34:00 +0800 (CST)
Received: from [10.173.134.152] (10.173.134.152) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 21 May 2024 20:34:00 +0800
Message-ID: <36b8df1d-593e-44c0-b34d-eb158e5ebabe@huawei.com>
Date: Tue, 21 May 2024 20:33:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: LAPIC: Fix an inversion error when a negative value
 assigned to lapic_timer.timer_advance_ns
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <weiqi4@huawei.com>, <wanpengli@tencent.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240520115334.852510-1-zhoushuling@huawei.com>
 <Zktd8QHU84_EdaNb@google.com>
From: zhoushuling <zhoushuling@huawei.com>
In-Reply-To: <Zktd8QHU84_EdaNb@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)


> On Mon, May 20, 2024, zhoushuling@huawei.com wrote:
>> From: Shuling Zhou <zhoushuling@huawei.com>
>>
>> After 'commit 0e6edceb8f18 ("KVM: LAPIC: Fix lapic_timer_advance_ns
>> parameter overflow")',a negative value can be assigned to
>> lapic_timer_advance_ns, when it is '-1', the kvm_create_lapic()
>> will judge it and turns on adaptive tuning of timer advancement.
>> However, when lapic_timer_advance_ns=-2, it will be assigned to
>> an uint variable apic->lapic_timer.timer_advance_ns, the
>> apic->lapic_timer.timer_advance_ns of each vCPU will become a huge
>> value. When a VM is started, the VM is stuck in the
>> "
>> [    2.669717] ACPI: Core revision 20130517
>> [    2.672378] ACPI: All ACPI Tables successfully acquired
>> [    2.673309] ftrace: allocating 29651 entries in 116 pages
>> [    2.698797] Enabling x2apic
>> [    2.699431] Enabled x2apic
>> [    2.700160] Switched APIC routing to physical x2apic.
>> [    2.701644] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    2.702575] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8378A CPU @ 3.00GHz (fam: 06, model: 6a, stepping: 06)
>> ..........
>> "
>>
>> 'Fixes: 0e6edceb8f18 ("KVM: LAPIC: Fix lapic_timer_advance_ns
>> parameter overflow")'
>   Fixes: 0e6edceb8f18 ("KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow")
>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Cc: Wanpeng Li <wanpengli@tencent.com>
>> Signed-off-by: Shuling Zhou<zhoushuling@huawei.com>
> There should be whitespace between your name and email.
>
>> ---
>>   arch/x86/kvm/lapic.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index ebf41023be38..5feeb889ddb6 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2848,7 +2848,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>>   	if (timer_advance_ns == -1) {
>>   		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
>>   		lapic_timer_advance_dynamic = true;
>> -	} else {
>> +	} else if (timer_advance_ns >= 0) {
>>   		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>>   		lapic_timer_advance_dynamic = false;
>>   	}
> Wouldn't it be more appropriate to treat any negative value as "dynamic"?  The
> comment above the module param also needs to be updated.


Thank for your suggestions.

I agree with "treat any negative value as dynamic".


>
> Oof, and lapic_timer_advance_dynamic is a global, which yields behavior that is
> nearly impossible to document.  So I think we want this, over two patches?
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ebf41023be38..3a1bcfbe3e93 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -59,7 +59,6 @@
>   #define MAX_APIC_VECTOR                        256
>   #define APIC_VECTORS_PER_REG           32
>   
> -static bool lapic_timer_advance_dynamic __read_mostly;
>   #define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100     /* clock cycles */
>   #define LAPIC_TIMER_ADVANCE_ADJUST_MAX 10000   /* clock cycles */
>   #define LAPIC_TIMER_ADVANCE_NS_INIT    1000
> @@ -1854,7 +1853,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>          guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>          trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
>   
> -       if (lapic_timer_advance_dynamic) {
> +       if (apic->lapic_timer.timer_advance_dynamic) {
>                  adjust_lapic_timer_advance(vcpu, guest_tsc - tsc_deadline);
>                  /*
>                   * If the timer fired early, reread the TSC to account for the
> @@ -2845,12 +2844,12 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>          hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
>                       HRTIMER_MODE_ABS_HARD);
>          apic->lapic_timer.timer.function = apic_timer_fn;
> -       if (timer_advance_ns == -1) {
> +       if (timer_advance_ns < 0) {
>                  apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
> -               lapic_timer_advance_dynamic = true;
> +               apic->lapic_timer.timer_advance_dynamic = true;
>          } else {
>                  apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> -               lapic_timer_advance_dynamic = false;
> +               apic->lapic_timer.timer_advance_dynamic = false;
>          }
>   
>          /*
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 0a0ea4b5dd8c..6fb3b16a2754 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -54,6 +54,7 @@ struct kvm_timer {
>          u32 timer_advance_ns;
>          atomic_t pending;                       /* accumulated triggered timers */
>          bool hv_timer_in_use;
> +       bool timer_advance_dynamic;
>   };


However，I do not understand why the global function switch 
'lapic_timer_advance_dynamic'

is changed to a local variable in the 'struct kvm_timer'.On a host, the 
adaptive tuning

of timer advancement is global function, and 
each vcpu->apic->lapic_timer.timer_advance_dynamic

of each VM is the same, different VMs cannot be configured with 
different switches.

Is it better to keep the current implementation of the global variable 
'lapic_timer_advance_dynamic'?

and just modify like this:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ebf41023be38..75469e329b23 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2845,7 +2845,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int 
timer_advance_ns)
     hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
              HRTIMER_MODE_ABS_HARD);
     apic->lapic_timer.timer.function = apic_timer_fn;
-   if (timer_advance_ns == -1) {
+   if (timer_advance_ns < 0) {
         apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
         lapic_timer_advance_dynamic = true;
     } else {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 082ac6d95a3a..071342d56ba8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -165,10 +165,11 @@ static u32 __read_mostly tsc_tolerance_ppm = 250;
  module_param(tsc_tolerance_ppm, uint, 0644);

  /*
- * lapic timer advance (tscdeadline mode only) in nanoseconds. '-1' enables
- * adaptive tuning starting from default advancement of 1000ns.  '0' 
disables
- * advancement entirely.  Any other value is used as-is and disables 
adaptive
- * tuning, i.e. allows privileged userspace to set an exact advancement 
time.
+ * lapic timer advance (tscdeadline mode only) in nanoseconds. Any negative
+ * value enable adaptive tuning starting from default advancement of 
1000ns.
+ * '0' disables advancement entirely.  Any postive value is used as-is and
+ * disables adaptive tuning, i.e. allows privileged userspace to set an 
exact
+ * advancement time.
   */
  static int __read_mostly lapic_timer_advance_ns = -1;
  module_param(lapic_timer_advance_ns, int, 0644);

Thanks.


>   
>   struct kvm_lapic {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a2b62169e09a..60e86607056e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -165,10 +165,11 @@ static u32 __read_mostly tsc_tolerance_ppm = 250;
>   module_param(tsc_tolerance_ppm, uint, 0644);
>   
>   /*
> - * lapic timer advance (tscdeadline mode only) in nanoseconds.  '-1' enables
> - * adaptive tuning starting from default advancement of 1000ns.  '0' disables
> - * advancement entirely.  Any other value is used as-is and disables adaptive
> - * tuning, i.e. allows privileged userspace to set an exact advancement time.
> + * lapic timer advance (tscdeadline mode only) in nanoseconds.  Any negative
> + * value enable adaptive tuning starting from default advancement of 1000ns.
> + * '0' disables advancement entirely.  Any postive value is used as-is and
> + * disables adaptive tuning, i.e. allows privileged userspace to set an exact
> + * advancement time.
>    */
>   static int __read_mostly lapic_timer_advance_ns = -1;
>   module_param(lapic_timer_advance_ns, int, 0644);
>

