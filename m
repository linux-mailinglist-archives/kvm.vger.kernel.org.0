Return-Path: <kvm+bounces-18147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F798CEA6A
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 21:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E88B01C20A7E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 19:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4165EE97;
	Fri, 24 May 2024 19:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OVQMwWJz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FC15BACF
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 19:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716579482; cv=none; b=R7XrX13Mqa7Ms8hjrGRIhMwPQ9eq6nYyxbEaZLZQm+xF4Mp0/SS8mpuoAFnzKM+ymWDpACHSpOol5+jv6v99p8QW7CMfVoOcGfW+/JzcWqg9N0cQC5WcPG9gwJ0jNZhWDamfJAuAc4VNWQqR2Qy3KGjazHTw+wPDORWFO9yXBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716579482; c=relaxed/simple;
	bh=Nje5AUtd9IY2WJYMza26m2MExgUp6NbXLoSEMw2ry7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7xFBrg6eUY9FeYZwoboLKBqfZt9tJiuFey4g89j+va7mAqWRBrYz7Chb7SGArBYUyfS95wPGU1O0bvuo+sCuG1FcAonOMAq0sIpcQGBs1BbPgAFcJtpmnEqzVBLxXQ3v4gR+5GRmx2y8Bt7S2YX71eCj79I3omuYVprGxrpxsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OVQMwWJz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716579477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pumjuenvowhyna00Y5Js10n3w6sXpvoIPeOENPSQN/w=;
	b=OVQMwWJzB5ihaDMp0veOYE9ceANISHvy6myteNQT84vIFwkFKOAlwrgbc43w7gGdzCO7fN
	kiN11EohYbTb73IAJYYoMhSksRoT7gfxEbLqvz+Erx6zqlEUtvR9bQnDKzBNwdkx8xYgZd
	7x+7Fmz7kAIkxfJ51HthCfvYtQ04AvI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-PhZSMxhoPSCkj9UUkiZiGw-1; Fri, 24 May 2024 15:37:56 -0400
X-MC-Unique: PhZSMxhoPSCkj9UUkiZiGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAB3885A58C;
	Fri, 24 May 2024 19:37:55 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2495C2026D33;
	Fri, 24 May 2024 19:37:55 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id EE221400DE5FF; Thu, 23 May 2024 17:19:03 -0300 (-03)
Date: Thu, 23 May 2024 17:19:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuling Zhou <zhoushuling@huawei.com>
Subject: Re: [PATCH] KVM: x86: Drop support for hand tuning APIC timer
 advancement from userspace
Message-ID: <Zk+kt8TExnuz/2Se@tpad>
References: <20240522010304.1650603-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522010304.1650603-1-seanjc@google.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, May 21, 2024 at 06:03:04PM -0700, Sean Christopherson wrote:
> Remove support for specifying a static local APIC timer advancement value,
> and instead present a read-only boolean parameter to let userspace enable
> or disable KVM's dynamic APIC timer advancement.  Realistically, it's all
> but impossible for userspace to specify an advancement that is more
> precise than what KVM's adaptive tuning can provide.  E.g. a static value
> needs to be tuned for the exact hardware and kernel, and if KVM is using
> hrtimers, likely requires additional tuning for the exact configuration of
> the entire system.

Hi Sean,

LAPIC timer advancement was dropped from tuned due to the improvement
being minimal, and the measurement causing problems in some scenarios
(those could be fixed, though).

Therefore, OK with the removal of this interface.

commit 51c50a3a1885d13026cb0ad9ea72aca845c342d2
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Tue Jul 21 14:20:48 2020 -0300

    realtime-virtual-host profile: remove lapic advancement calculation

    The LAPIC advancement improvement is minimal (3 or 4 us) and its
    calculation has shown to be problematic under certain
    scenarios (for example if qemu-kvm is not installed).

    Remove it.

    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>



diff --git a/profiles/realtime-virtual-host/find-lapictscdeadline-optimal.sh b/profiles/realtime-virtual-host/find-lapictscdeadline-optimal.sh
deleted file mode 100755
index 539c47e..0000000
--- a/profiles/realtime-virtual-host/find-lapictscdeadline-optimal.sh
+++ /dev/null
@@ -1,30 +0,0 @@
-#!/bin/bash
-
-: ${1?"Usage: $0 latency-file"}
-
-lines=`wc -l $1 | cut -f 1 -d " "`
-in_range=0
-prev_value=1
-for i in `seq 1 $lines`; do
-       a=`awk "NR==$i" $1 | cut -f 2 -d ":"`
-       value=$(($a*100/$prev_value))
-       if [ $value -ge 98 -a $value -le 102 ]; then
-               in_range=$(($in_range + 1))
-       else
-               in_range=0
-       fi
-       if [ $in_range -ge 2 ]; then
-               echo -n "optimal value for lapic_timer_advance_ns is: "
-               awk "NR==$(($i - 1))" $1 | cut -f 1 -d ":"
-               exit 0
-       fi
-       prev_value=$a
-done
-# if still decreasing, then use highest ns value
-if [ $value -le 99 ]; then
-       echo -n "optimal value for lapic_timer_advance_ns is: "
-       awk "NR==$(($i - 1))" $1 | cut -f 1 -d ":"
-       exit 0
-fi
-echo optimal not found
-exit 1
diff --git a/profiles/realtime-virtual-host/script.sh b/profiles/realtime-virtual-host/script.sh
index edae6c5..a11dac7 100755
--- a/profiles/realtime-virtual-host/script.sh
+++ b/profiles/realtime-virtual-host/script.sh
@@ -2,102 +2,13 @@

 . /usr/lib/tuned/functions

-CACHE_VALUE_FILE=./lapic_timer_adv_ns
-CACHE_CPU_FILE=./lapic_timer_adv_ns.cpumodel
-KVM_LAPIC_FILE=/sys/module/kvm/parameters/lapic_timer_advance_ns
 KTIMER_LOCKLESS_FILE=/sys/kernel/ktimer_lockless_check
-QEMU=$(type -P qemu-kvm || echo /usr/libexec/qemu-kvm)
-TSCDEADLINE_LATENCY="/usr/share/qemu-kvm/tscdeadline_latency.flat"
-[ -f "$TSCDEADLINE_LATENCY" ] || TSCDEADLINE_LATENCY="/usr/share/tuned-profiles-nfv-host-bin/tscdeadline_latency.flat"
-[ -f "$TSCDEADLINE_LATENCY" ] || TSCDEADLINE_LATENCY="/usr/share/tuned/tscdeadline_latency.flat"
-
-run_tsc_deadline_latency()
-{
-    dir=`mktemp -d`
-
-    for i in `seq 1000 500 7000`; do
-        echo $i > $KVM_LAPIC_FILE
-
-        unixpath=`mktemp`
-
-        chrt -f 1 $QEMU -S -enable-kvm -device pc-testdev \
-            -device isa-debug-exit,iobase=0xf4,iosize=0x4 \
-            -display none -serial stdio -device pci-testdev \
-            -kernel "$TSCDEADLINE_LATENCY"  \
-            -cpu host,tsc-deadline=on \
-            -mon chardev=char0,mode=readline \
-            -chardev socket,id=char0,nowait,path=$unixpath,server | grep latency | cut -f 2 -d ":" > $dir/out &
-
-        sleep 1s
-        pidofvcpu=`echo "info cpus" | ncat -U $unixpath | grep thread_id | cut -f 3 -d "=" | tr -d "\r"`
-        taskset -p -c $1 $pidofvcpu >/dev/null
-        echo "cont" | ncat -U $unixpath >/dev/null
-        wait
-
-        if [ ! -f $dir/out ]; then
-             die running $TSCDEADLINE_LATENCY failed
-        fi
-
-        tmp=$(wc -l $dir/out | awk '{ print $1 }')
-        if [ $tmp -eq 0 ]; then
-            die running $TSCDEADLINE_LATENCY failed
-        fi
-
-        A=0
-        while read l; do
-            A=$(($A+$l))
-        done < $dir/out
-
-        lines=`wc -l $dir/out | cut -f 1 -d " "`
-        ans=$(($A/$lines))
-        echo $i: $ans
-    done
-}

 start() {
     setup_kvm_mod_low_latency

     disable_ksm

-    # If CPU model has changed, clean the cache
-    if [ -f $CACHE_CPU_FILE ]; then
-        curmodel=`cat /proc/cpuinfo | grep "model name" | cut -f 2 -d ":" | uniq`
-        if [ -z "$curmodel" ]; then
-            die failed to read CPU model
-        fi
-
-        genmodel=`cat $CACHE_CPU_FILE`
-
-        if [ "$curmodel" != "$genmodel" ]; then
-            rm -f $CACHE_VALUE_FILE
-            rm -f $CACHE_CPU_FILE
-        fi
-    fi
-
-    # If the cache is empty, find the best lapic_timer_advance_ns value
-    # and cache it
-
-    if [ ! -f $KVM_LAPIC_FILE ]; then
-        die $KVM_LAPIC_FILE not found
-    fi
-
-    if [ ! -f $CACHE_VALUE_FILE ]; then
-        if [ -f "$TSCDEADLINE_LATENCY" ]; then
-             tempdir=`mktemp -d`
-             isolatedcpu=`echo "$TUNED_isolated_cores_expanded" | cut -f 1 -d ","`
-             run_tsc_deadline_latency $isolatedcpu > $tempdir/lat.out
-             if ! ./find-lapictscdeadline-optimal.sh $tempdir/lat.out > $tempdir/opt.out; then
-                die could not find optimal latency
-             fi
-             echo `cat $tempdir/opt.out | cut -f 2 -d ":"` > $CACHE_VALUE_FILE
-             curmodel=`cat /proc/cpuinfo | grep "model name" | cut -f 2 -d ":" | uniq`
-             echo "$curmodel" > $CACHE_CPU_FILE
-        fi
-    fi
-
-    if [ -f $CACHE_VALUE_FILE ]; then
-        echo `cat $CACHE_VALUE_FILE` > $KVM_LAPIC_FILE
-    fi
     systemctl start rt-entsk

     if [ -f $KTIMER_LOCKLESS_FILE ]; then


> 
> Dropping support for a userspace provided value also fixes several flaws
> in the interface.  E.g. KVM interprets a negative value other than -1 as a
> large advancement, toggling between a negative and positive value yields
> unpredictable behavior as vCPUs will switch from dynamic to static
> advancement, changing the advancement in the middle of VM creation can
> result in different values for vCPUs within a VM, etc.  Those flaws are
> mostly fixable, but there's almost no justification for taking on yet more
> complexity (it's minimal complexity, but still non-zero).
> 
> The only arguments against using KVM's adaptive tuning is if a setup needs
> a higher maximum, or if the adjustments are too reactive, but those are
> arguments for letting userspace control the absolute max advancement and
> the granularity of each adjustment, e.g. similar to how KVM provides knobs
> for halt polling.
> 
> Link: https://lore.kernel.org/all/20240520115334.852510-1-zhoushuling@huawei.com
> Cc: Shuling Zhou <zhoushuling@huawei.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 39 +++++++++++++++++++++------------------
>  arch/x86/kvm/lapic.h |  2 +-
>  arch/x86/kvm/x86.c   | 11 +----------
>  3 files changed, 23 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ebf41023be38..acd7d48100a1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -59,7 +59,17 @@
>  #define MAX_APIC_VECTOR			256
>  #define APIC_VECTORS_PER_REG		32
>  
> -static bool lapic_timer_advance_dynamic __read_mostly;
> +/*
> + * Enable local APIC timer advancement (tscdeadline mode only) with adaptive
> + * tuning.  When enabled, KVM programs the host timer event to fire early, i.e.
> + * before the deadline expires, to account for the delay between taking the
> + * VM-Exit (to inject the guest event) and the subsequent VM-Enter to resume
> + * the guest, i.e. so that the interrupt arrives in the guest with minimal
> + * latency relative to the deadline programmed by the guest.
> + */
> +static bool lapic_timer_advance __read_mostly = true;
> +module_param(lapic_timer_advance, bool, 0444);
> +
>  #define LAPIC_TIMER_ADVANCE_ADJUST_MIN	100	/* clock cycles */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_MAX	10000	/* clock cycles */
>  #define LAPIC_TIMER_ADVANCE_NS_INIT	1000
> @@ -1854,16 +1864,14 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>  	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
>  
> -	if (lapic_timer_advance_dynamic) {
> -		adjust_lapic_timer_advance(vcpu, guest_tsc - tsc_deadline);
> -		/*
> -		 * If the timer fired early, reread the TSC to account for the
> -		 * overhead of the above adjustment to avoid waiting longer
> -		 * than is necessary.
> -		 */
> -		if (guest_tsc < tsc_deadline)
> -			guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> -	}
> +	adjust_lapic_timer_advance(vcpu, guest_tsc - tsc_deadline);
> +
> +	/*
> +	 * If the timer fired early, reread the TSC to account for the overhead
> +	 * of the above adjustment to avoid waiting longer than is necessary.
> +	 */
> +	if (guest_tsc < tsc_deadline)
> +		guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>  
>  	if (guest_tsc < tsc_deadline)
>  		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> @@ -2812,7 +2820,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
>  		return HRTIMER_NORESTART;
>  }
>  
> -int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
> +int kvm_create_lapic(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic;
>  
> @@ -2845,13 +2853,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
>  		     HRTIMER_MODE_ABS_HARD);
>  	apic->lapic_timer.timer.function = apic_timer_fn;
> -	if (timer_advance_ns == -1) {
> +	if (lapic_timer_advance)
>  		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
> -		lapic_timer_advance_dynamic = true;
> -	} else {
> -		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> -		lapic_timer_advance_dynamic = false;
> -	}
>  
>  	/*
>  	 * Stuff the APIC ENABLE bit in lieu of temporarily incrementing
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 0a0ea4b5dd8c..a69e706b9080 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -85,7 +85,7 @@ struct kvm_lapic {
>  
>  struct dest_map;
>  
> -int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns);
> +int kvm_create_lapic(struct kvm_vcpu *vcpu);
>  void kvm_free_lapic(struct kvm_vcpu *vcpu);
>  
>  int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d750546ec934..fa064864ad2c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -164,15 +164,6 @@ module_param(kvmclock_periodic_sync, bool, 0444);
>  static u32 __read_mostly tsc_tolerance_ppm = 250;
>  module_param(tsc_tolerance_ppm, uint, 0644);
>  
> -/*
> - * lapic timer advance (tscdeadline mode only) in nanoseconds.  '-1' enables
> - * adaptive tuning starting from default advancement of 1000ns.  '0' disables
> - * advancement entirely.  Any other value is used as-is and disables adaptive
> - * tuning, i.e. allows privileged userspace to set an exact advancement time.
> - */
> -static int __read_mostly lapic_timer_advance_ns = -1;
> -module_param(lapic_timer_advance_ns, int, 0644);
> -
>  static bool __read_mostly vector_hashing = true;
>  module_param(vector_hashing, bool, 0444);
>  
> @@ -12177,7 +12168,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (r < 0)
>  		return r;
>  
> -	r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
> +	r = kvm_create_lapic(vcpu);
>  	if (r < 0)
>  		goto fail_mmu_destroy;
>  
> 
> base-commit: 4aad0b1893a141f114ba40ed509066f3c9bc24b0
> -- 
> 2.45.0.215.g3402c0e53f-goog
> 
> 


