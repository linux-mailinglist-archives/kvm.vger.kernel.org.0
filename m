Return-Path: <kvm+bounces-41541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA26FA69F6A
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 06:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70BC13B9FF3
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 05:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614771DE3A8;
	Thu, 20 Mar 2025 05:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TX3QX7Kc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7ED2AEE2;
	Thu, 20 Mar 2025 05:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742449142; cv=none; b=EnnkWk6B8JOKT6dXakX7cgz6IWmv1gaEz2xWAfRwlFdLuMS9oyMlvS/lGSIaDb81Bt08Tv05sXXxnKBxnZHMzKigGveP7+Cc+ewtE3qwR5WimeyGg3+rPobBNlX5qUHAJjz7FZcuNcr5od5TU/MzRf+LxHsxzN8EDazy+W3vvMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742449142; c=relaxed/simple;
	bh=aqAfScZNafJ2YuAEWLsGSFTZyifN7Y4Ioe0h1fXDprQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:Cc:To:Content-Type; b=DM0ZVRP2Nx4gkt8aXEVo1tZ+86MxdJnS4YuCX7q/E90Y6dk8C00WBT/e1e+7Vh8e5rQTxSaS+OattzSBkf/nMauE1dO3pypFE6T0ib22OpHhNKuYVpoXxB9ig1orb9exNANetaD8+5SaiRgZhaBaAcFppu//pLuHnw6Em5D0Puw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TX3QX7Kc; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4769f3e19a9so2705631cf.0;
        Wed, 19 Mar 2025 22:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742449137; x=1743053937; darn=vger.kernel.org;
        h=content-transfer-encoding:to:cc:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XnnCAk1bM3a/Ji5x3FEZTFGouGduUgtZCKxXqfSHDBM=;
        b=TX3QX7KcqqWnJMTAjo0AJ3veGNW9iPROuBDqC6vrEV0Zv7+4PaccyTjG6zrpUHXp1q
         lBE6MJ4FTvjboh1d+XKdB37VDSh7RXu1jdBhA64GNuWq/dEibIzNo3idq1hIyhmrC0/t
         uNwX9KLoozE7pG3wUqfUN2kDiWAGtkjd/3fLDhaaSSzTzSUt8q2IrwgfPs4hc3ShqZ9g
         d6+PV21frcJpbS7ebQmG3LNH05vi5UvPnH/Ul7ILgn4txCC8ny3r+X2KOPucIhHUF/3f
         uf2ZvNMTzwb88a9EgP+Ns89bPETbzyPz+RPKLVDShDpVFsSsISLF/5og45nanj5yh+3q
         Kt0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742449137; x=1743053937;
        h=content-transfer-encoding:to:cc:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XnnCAk1bM3a/Ji5x3FEZTFGouGduUgtZCKxXqfSHDBM=;
        b=Ai2Xfps5FT9qI6qfgMWaMJ9Vdjrml2JLUS2Cyway/TXGvTkbtEI0bl44iow2w7xN4w
         qLtsyU9w2fJo3joeMEiU4wAGfmkSr+MqAE817u60Vg3phHiAO7ZgX+VluDKZZcFoc2Hg
         VADlMli6tIO5Eh2uRGthi7m8fnLa88fmZ4qNQVdSNNMrA2DMoyzDDjq6bU9jS7nkysQW
         QlaZqBvdnzomaey8BEjfrPDsuTItxGKtD0cch+foexVfhdxVJVripmcdFiq7F+CD1inH
         5lvHjSezg5iKF0slK8tP9dnGVDoRh3YZx+l1DehicywMS7/j+ew8DGwdzvHIUK71j7rx
         DkAg==
X-Gm-Message-State: AOJu0YywbMAn48YdhXxjUOcgs/E+nLKOhzjXXSNozeqiSwC6tXnfnmtH
	GYvJZPNTIGHUSjKRdloh9IH7mpIph2gjgoZAC/nECPKPF0RMC+XPoO9y9g==
X-Gm-Gg: ASbGncttgwumld8Ysjy4fNCfvNwbwqLe4c4rOd1p8P6swttzle4E6MnG9+1HqQaecs4
	0etUSgsJKkmgsKQSZTXmRsAHg1ZpD9JXHZ7Yk4UoH4Ng9iauONor4TR1M/hftHl3eMNy1FRV4ms
	1auc9FQ1qdNAbsvlLtn/jyk98ZoIqXAJWTg3TGhSlYr+/YE1kW5/Ms0spnLRI4HJwHbWDdWcuQJ
	jTu7Hr+z/AW52fpTBkKYd0dEgz+YKomY/0tHjlM0dMdTrep23XnAQBXX5seFZVMmzI75D0yD2Sb
	Ub7QoCcCMMeYo1S4FEaAH1WgobwPyFN/eFDHyCnCbORfKTcXbTJJBugZsHR26gx1HHSI7XHtI+M
	qxl8kYIGFiCknsvwvVD+/
X-Google-Smtp-Source: AGHT+IG5yOPynP8w8g7NbFtS3J7WPKjna9g/bpevYlYkOKoeZeoUE1nlkhW7DrLsklnNmt94yImQUA==
X-Received: by 2002:a05:620a:2990:b0:7c5:5e5b:2fdb with SMTP id af79cd13be357-7c5b0d06e96mr217664685a.41.1742449137486;
        Wed, 19 Mar 2025 22:38:57 -0700 (PDT)
Received: from [10.139.221.89] (c-174-160-16-133.hsd1.ca.comcast.net. [174.160.16.133])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573c714c0sm958440285a.40.2025.03.19.22.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 22:38:56 -0700 (PDT)
Message-ID: <facda6e2-3655-4f2c-9013-ebb18d0e6972@gmail.com>
Date: Wed, 19 Mar 2025 22:38:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Ming Lin <minggr@gmail.com>
Subject: pvclock time drifting backward
Cc: linux-kernel@vger.kernel.org, minggr@gmail.com
To: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

After performing a live migration on a QEMU guest OS that had been running for over 30 days,
we noticed that the guest OS time was more than 2 seconds behind the actual time.

After extensive debugging, we found that this issue is related to master_kernel_ns and master_cycle_now.

When the guest OS starts, the host initializes a pair of master_kernel_ns and master_cycle_now values.
After live migration, the host updates these values.

Our debugging showed that if the host does not update master_kernel_ns/master_cycle_now,
the guest OS time remains correct.

To illustrate how updating master_kernel_ns/master_cycle_now leads to the guest OS time drifting backward,
we applied the following debug patch:

The patch adds a KVM debugfs entry to trigger time calculations and print the results.
The patch runs on the host side, but we use __pvclock_read_cycles() to simulate the guest OS updating its time.

Example Output:

# cat /sys/kernel/debug/kvm/946-13/pvclock
old: master_kernel_ns: 15119778316
old: master_cycle_now: 37225912658
old: ns: 1893199569691
new: master_kernel_ns: 1908210098649
new: master_cycle_now: 4391329912268
new: ns: 1893199548401

tsc 4391329912368
kvmclock_offset -15010550291
diff: ns: 21290

Explanation of Parameters:

Input:
"old: master_kernel_ns:" The master_kernel_ns value recorded when the guest OS started (remains unchanged during testing).
"old: master_cycle_now:" The master_cycle_now value recorded when the guest OS started (remains unchanged during testing).
"new: master_kernel_ns:" The latest master_kernel_ns value at the time of reading.
"new: master_cycle_now:" The latest master_cycle_now value at the time of reading.
tsc: The rdtsc() value at the time of reading.
kvmclock_offset: The offset recorded by KVM_SET_CLOCK when the guest OS started (remains unchanged during testing).

Output:
"old: ns:" Time in nanoseconds calculated using the old master_kernel_ns/master_cycle_now.
"new: ns:" Time in nanoseconds calculated using the new master_kernel_ns/master_cycle_now.
"diff: ns:" (old ns - new ns), representing the time drift relative to the guest OS start time.

Test Script:
#!/bin/bash

qemu_pid=$(pidof qemu-system-x86_64)

while [ 1 ] ; do
     echo "====================================="
     echo "Guest OS running time: $(ps -p $qemu_pid -o etime= | awk '{print $1}')"
     cat /sys/kernel/debug/kvm/*/pvclock
     echo
     sleep 10
done

Test Results:
Below are the first and last parts of a >2-hour test run.
As time progresses, the time drift calculated using the latest master_kernel_ns/master_cycle_now increases monotonically.

After 2 hours and 18 minutes, the guest OS time drifted by approximately 93 milliseconds.

I have uploaded an image for a more intuitive visualization of the time drift:
https://postimg.cc/crCDWtD7

Is this a real problem?

If there is any fix patch, I’d be happy to test it. Thanks!


     1 =====================================
     2 guest os running time: 00:50
     3 old: master_kernel_ns: 15119778316
     4 old: master_cycle_now: 37225912658
     5 old: ns: 48092694964
     6 new: master_kernel_ns: 63103244699
     7 new: master_cycle_now: 147587790614
     8 new: ns: 48092694425
     9
    10 tsc 147587790654
    11 kvmclock_offset -15010550291
    12 diff: ns: 539
    13
    14 =====================================
    15 guest os running time: 01:00
    16 old: master_kernel_ns: 15119778316
    17 old: master_cycle_now: 37225912658
    18 old: ns: 58139026532
    19 new: master_kernel_ns: 73149576143
    20 new: master_cycle_now: 170694333104
    21 new: ns: 58139025879
    22
    23 tsc 170694333168
    24 kvmclock_offset -15010550291
    25 diff: ns: 653
    26
    27 =====================================
    28 guest os running time: 01:10
    29 old: master_kernel_ns: 15119778316
    30 old: master_cycle_now: 37225912658
    31 old: ns: 68183772122
    32 new: master_kernel_ns: 83194321616
    33 new: master_cycle_now: 193797227862
    34 new: ns: 68183771357
    35
    36 tsc 193797227936
    37 kvmclock_offset -15010550291
    38 diff: ns: 765
    39
    40 =====================================
    41 guest os running time: 01:20
    42 old: master_kernel_ns: 15119778316
    43 old: master_cycle_now: 37225912658
    44 old: ns: 78225289157
    45 new: master_kernel_ns: 93235838545
    46 new: master_cycle_now: 216892696976
    47 new: ns: 78225288279
    48
    49 tsc 216892697034
    50 kvmclock_offset -15010550291
    51 diff: ns: 878
    52
    53 =====================================
    54 guest os running time: 01:30
    55 old: master_kernel_ns: 15119778316
    56 old: master_cycle_now: 37225912658
    57 old: ns: 88268955340
    58 new: master_kernel_ns: 103279504612
    59 new: master_cycle_now: 239993109102
    60 new: ns: 88268954349
    61
    62 tsc 239993109168
    63 kvmclock_offset -15010550291
    64 diff: ns: 991
    65
    66 =====================================
    67 guest os running time: 01:40
    68 old: master_kernel_ns: 15119778316
    69 old: master_cycle_now: 37225912658
    70 old: ns: 98313212581
    71 new: master_kernel_ns: 113323761740
    72 new: master_cycle_now: 263094880668
    73 new: ns: 98313211476
    74
    75 tsc 263094880732
    76 kvmclock_offset -15010550291
    77 diff: ns: 1105
.....
.....
10160 =====================================
10161 guest os running time: 02:17:11
10162 old: master_kernel_ns: 15119778316
10163 old: master_cycle_now: 37225912658
10164 old: ns: 8229817213297
10165 new: master_kernel_ns: 8244827670997
10166 new: master_cycle_now: 18965537819524
10167 new: ns: 8229817120748
10168
10169 tsc 18965537819622
10170 kvmclock_offset -15010550291
10171 diff: ns: 92549
10172 =====================================
10173 guest os running time: 02:17:21
10174 old: master_kernel_ns: 15119778316
10175 old: master_cycle_now: 37225912658
10176 old: ns: 8239861074959
10177 new: master_kernel_ns: 8254871532564
10178 new: master_cycle_now: 18988638681302
10179 new: ns: 8239860982297
10180
10181 tsc 18988638681358
10182 kvmclock_offset -15010550291
10183 diff: ns: 92662
10184 =====================================
10185 guest os running time: 02:17:31
10186 old: master_kernel_ns: 15119778316
10187 old: master_cycle_now: 37225912658
10188 old: ns: 8249904622988
10189 new: master_kernel_ns: 8264915080459
10190 new: master_cycle_now: 19011738821632
10191 new: ns: 8249904530213
10192
10193 tsc 19011738821736
10194 kvmclock_offset -15010550291
10195 diff: ns: 92775^@
10196 =====================================
10197 guest os running time: 02:17:41
10198 old: master_kernel_ns: 15119778316
10199 old: master_cycle_now: 37225912658
10200 old: ns: 8259949369203
10201 new: master_kernel_ns: 8274959826576
10202 new: master_cycle_now: 19034841717872
10203 new: ns: 8259949276315
10204
10205 tsc 19034841717942
10206 kvmclock_offset -15010550291
10207 diff: ns: 92888
10208 =====================================
10209 guest os running time: 02:17:51
10210 old: master_kernel_ns: 15119778316
10211 old: master_cycle_now: 37225912658
10212 old: ns: 8269996849598
10213 new: master_kernel_ns: 8285007306846
10214 new: master_cycle_now: 19057950902658
10215 new: ns: 8269996756597
10216
10217 tsc 19057950902756
10218 kvmclock_offset -15010550291
10219 diff: ns: 93001^@
10220 =====================================
10221 guest os running time: 02:18:02
10222 old: master_kernel_ns: 15119778316
10223 old: master_cycle_now: 37225912658
10224 old: ns: 8280039094317
10225 new: master_kernel_ns: 8295049551453
10226 new: master_cycle_now: 19081048045430
10227 new: ns: 8280039001203
10228
10229 tsc 19081048045526
10230 kvmclock_offset -15010550291
10231 diff: ns: 93114^@



     pvclock debugfs patch
---
  arch/x86/include/asm/kvm_host.h |  4 +++
  arch/x86/kvm/x86.c              | 29 +++++++++++++++-
  b.sh                            |  1 +
  virt/kvm/kvm_main.c             | 75 +++++++++++++++++++++++++++++++++++++++++
  4 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ae3aa50c7e..5a82a69bfe7a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1411,6 +1411,10 @@ struct kvm_arch {
      struct delayed_work kvmclock_update_work;
      struct delayed_work kvmclock_sync_work;
  
+    u64 old_master_kernel_ns;
+    u64 old_master_cycle_now;
+    s64 old_kvmclock_offset;
+
      struct kvm_xen_hvm_config xen_hvm_config;
  
      /* reads protected by irq_srcu, writes by irq_lock */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b64ab350bcd..a56511ed8c5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2819,7 +2819,7 @@ static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
   * As with get_kvmclock_base_ns(), this counts from boot time, at the
   * frequency of CLOCK_MONOTONIC_RAW (hence adding gtos->offs_boot).
   */
-static int do_kvmclock_base(s64 *t, u64 *tsc_timestamp)
+int do_kvmclock_base(s64 *t, u64 *tsc_timestamp)
  {
      struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
      unsigned long seq;
@@ -2861,6 +2861,27 @@ static int do_monotonic(s64 *t, u64 *tsc_timestamp)
      return mode;
  }
  
+u64 mydebug_get_kvmclock_ns(u64 master_kernel_ns, u64 master_cycle_now, s64 kvmclock_offset, u64 tsc)
+{
+        struct pvclock_vcpu_time_info hv_clock;
+        u64 ret;
+
+        hv_clock.tsc_timestamp = master_cycle_now;
+        hv_clock.system_time = master_kernel_ns + kvmclock_offset;
+
+        /* both __this_cpu_read() and rdtsc() should be on the same cpu */
+        get_cpu();
+
+        kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
+                                   &hv_clock.tsc_shift,
+                                   &hv_clock.tsc_to_system_mul);
+        ret = __pvclock_read_cycles(&hv_clock, tsc);
+
+        put_cpu();
+
+        return ret;
+}
+
  static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
  {
      struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
@@ -2988,6 +3009,10 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
      host_tsc_clocksource = kvm_get_time_and_clockread(
                      &ka->master_kernel_ns,
                      &ka->master_cycle_now);
+    ka->old_master_kernel_ns = ka->master_kernel_ns;
+    ka->old_master_cycle_now = ka->master_cycle_now;
+    printk("MYDEBUG: old_master_kernel_ns = %llu, old_master_cycle_now = %llu\n",
+            ka->old_master_kernel_ns, ka->old_master_cycle_now);
  
      ka->use_master_clock = host_tsc_clocksource && vcpus_matched
                  && !ka->backwards_tsc_observed
@@ -6989,6 +7014,8 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
      else
          now_raw_ns = get_kvmclock_base_ns();
      ka->kvmclock_offset = data.clock - now_raw_ns;
+    ka->old_kvmclock_offset = ka->kvmclock_offset;
+    printk("MYDEBUG: old_kvmclock_offset = %lld\n", ka->old_kvmclock_offset);
      kvm_end_pvclock_update(kvm);
      return 0;
  }
diff --git a/b.sh b/b.sh
new file mode 120000
index 000000000000..0ff9a93fd53f
--- /dev/null
+++ b/b.sh
@@ -0,0 +1 @@
+/home/mlin/build.upstream/b.sh
\ No newline at end of file
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba0327e2d0d3..d6b9a6e7275e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -399,6 +399,7 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
              return mc->nobjs >= min ? 0 : -ENOMEM;
          mc->objects[mc->nobjs++] = obj;
      }
+
      return 0;
  }
  
@@ -998,6 +999,78 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
      }
  }
  
+extern int do_kvmclock_base(s64 *t, u64 *tsc_timestamp);
+extern u64 mydebug_get_kvmclock_ns(u64 master_kernel_ns, u64 master_cycle_now, s64 kvmclock_offset, u64 tsc);
+
+static ssize_t kvm_mydebug_pvclock_read(struct file *file, char __user *buf,
+                                size_t len, loff_t *ppos)
+{
+    struct kvm *kvm = file->private_data;
+    struct kvm_arch *ka;
+    char buffer[256];
+    ssize_t ret, copied;
+    u64 new_master_kernel_ns;
+    u64 new_master_cycle_now;
+    u64 old_ns, new_ns;
+    u64 tsc;
+
+    if (!kvm) {
+        pr_err("file->private_data is NULL\n");
+        return -EINVAL;
+    }
+
+    ka = &kvm->arch;
+
+    do_kvmclock_base(&new_master_kernel_ns, &new_master_cycle_now);
+
+    tsc = rdtsc();
+
+    old_ns = mydebug_get_kvmclock_ns(ka->old_master_kernel_ns, ka->old_master_cycle_now, ka->old_kvmclock_offset, tsc);
+    new_ns = mydebug_get_kvmclock_ns(new_master_kernel_ns, new_master_cycle_now, ka->old_kvmclock_offset, tsc);
+
+    ret = snprintf(buffer, sizeof(buffer),
+                   "old: master_kernel_ns: %llu\n"
+                   "old: master_cycle_now: %llu\n"
+                   "old: ns: %llu\n"
+                   "new: master_kernel_ns: %llu\n"
+                   "new: master_cycle_now: %llu\n"
+                   "new: ns: %llu\n\n"
+                   "tsc %llu\n"
+                   "kvmclock_offset %lld\n"
+                   "diff: ns: %lld\n",
+                   ka->old_master_kernel_ns, ka->old_master_cycle_now, old_ns,
+                   new_master_kernel_ns, new_master_cycle_now, new_ns,
+                   tsc, ka->old_kvmclock_offset,
+                  old_ns - new_ns
+                  );
+
+    if (ret < 0)
+        return ret;
+
+    if ((size_t)ret > sizeof(buffer))
+        ret = sizeof(buffer);
+
+    if (*ppos >= ret)
+        return 0; /* EOF */
+
+    copied = min(len, (size_t)(ret - *ppos));
+
+    if (copy_to_user(buf, buffer + *ppos, copied)) {
+        pr_err("copy_to_user failed\n");
+        return -EFAULT;
+    }
+
+    *ppos += copied;
+
+    return copied;
+}
+
+static const struct file_operations kvm_pvclock_fops = {
+    .owner = THIS_MODULE,
+    .read = kvm_mydebug_pvclock_read,
+    .open = simple_open,
+};
+
  static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
  {
      static DEFINE_MUTEX(kvm_debugfs_lock);
@@ -1063,6 +1136,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
                      &stat_fops_per_vm);
      }
  
+    debugfs_create_file("pvclock", 0444, kvm->debugfs_dentry, kvm, &kvm_pvclock_fops);
+
      kvm_arch_create_vm_debugfs(kvm);
      return 0;
  out_err:


