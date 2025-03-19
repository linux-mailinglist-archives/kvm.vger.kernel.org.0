Return-Path: <kvm+bounces-41471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47842A682B0
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 02:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B34E421F10
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 01:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 200C6136351;
	Wed, 19 Mar 2025 01:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aSVuygri"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209A88C0B;
	Wed, 19 Mar 2025 01:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742347243; cv=none; b=aXiZZGHpxTRcY+kJyut6V6VpSIkfCkby5Va2mVABt89UrjYLSwqWVU6y/Xsj0JwAcUUmkOubl6nwrjebGwo29vB2F7nBUWfj/iIoQbV9x5J43LF9Q+wBNJRXYOBD94jR08LSsM5DmPImuIs4/rlDcJlOCRdEGEYD91Fn5D5zNTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742347243; c=relaxed/simple;
	bh=klZl2FDzvcAMGPLd+IJeim3liy8ZCnwgQ+RoV7uAEfc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qj/KqjyM7ICVV5kTCsoppYwKvPApgkqYL0sYm5IqCITGKGvdA9AZZBRSa8E9xHPsaZBzbUDvAgeQ/1gSo09c0OKk3tfpRT9i9HQwQ/b3YeYdlX2TJ6uO68qkm2G4c1S+Rli3gpRdxXV+LwHGpFvgk0WJA8v+gMlR31v2FBYbSQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aSVuygri; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742347241; x=1773883241;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=klZl2FDzvcAMGPLd+IJeim3liy8ZCnwgQ+RoV7uAEfc=;
  b=aSVuygrigaKBGVZcxlp1uLPmci+kktzUj0/6GDi9/HMltq7eG5iR6XcO
   /mRE3vvKkXpYeHUeSMQYQ1cZGRKmaUK9tmlNnmsyqGSpctL3slOaaTMid
   TN5xX9+sheJjzODqizBH3H3z2Vmosw3mbiVDM6HRiCP0flFpRzDYm5lw+
   IGvzjjUsNTHwKl/3SLCkDnAI4Wa7z5hE9iFCBo+4HZFt7QCFwyTbWlYWa
   j7/HwoArGo0tQ5yxJjQf8/B0d78cbBe3r2Uwfa2UFd6GBoEDA0YdYlop2
   qFIu1RbsXfKpaF2LiUHh/Mj5PvIqc04ycNFoY01PRDNwv33REIHBr0lzI
   g==;
X-CSE-ConnectionGUID: kIvUauRKQl2/B+DyaGXgvg==
X-CSE-MsgGUID: FwNZX0MVSkyBLRuP3PoCCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="43704905"
X-IronPort-AV: E=Sophos;i="6.14,258,1736841600"; 
   d="scan'208";a="43704905"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 18:20:40 -0700
X-CSE-ConnectionGUID: r/qHRv9HQ0u0AJ/V19Wd0A==
X-CSE-MsgGUID: EleE8tzCTWabczYH9kA37A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,258,1736841600"; 
   d="scan'208";a="123358567"
Received: from unknown (HELO [10.238.1.131]) ([10.238.1.131])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 18:20:38 -0700
Message-ID: <bc22ff85-4caa-410e-b8b0-ea35975aad65@linux.intel.com>
Date: Wed, 19 Mar 2025 09:20:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] KVM: x86: do not allow re-enabling quirks
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
 seanjc@google.com, yan.y.zhao@intel.com
References: <20250304060647.2903469-1-pbonzini@redhat.com>
 <20250304060647.2903469-2-pbonzini@redhat.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250304060647.2903469-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/4/2025 2:06 PM, Paolo Bonzini wrote:
> Allowing arbitrary re-enabling of quirks puts a limit on what the
> quirks themselves can do, since you cannot assume that the quirk
> prevents a particular state.  More important, it also prevents
> KVM from disabling a quirk at VM creation time, because userspace
> can always go back and re-enable that.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 856ceeb4fb35..35d03fcdb8e9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6525,7 +6525,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   			break;
>   		fallthrough;
>   	case KVM_CAP_DISABLE_QUIRKS:
> -		kvm->arch.disabled_quirks = cap->args[0];
> +		kvm->arch.disabled_quirks |= cap->args[0];
>   		r = 0;
>   		break;
>   	case KVM_CAP_SPLIT_IRQCHIP: {
This  change requires changes in KVM selftests for monitor_mwait_test.

I cooked a patch to pass the test case.

 From 29b22d0a5cb14b418d289d78e2e290f7e0fc1749 Mon Sep 17 00:00:00 2001
From: Binbin Wu <binbin.wu@linux.intel.com>
Date: Tue, 18 Mar 2025 17:31:51 +0800
Subject: [PATCH] KVM: selftests: Test monitor/mwait cases in separate VMs

Test different cases of disabling quirk combinations for monitor/mwait in
separate VMs after KVM does not allow re-enabling quirks.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
  .../selftests/kvm/x86/monitor_mwait_test.c    | 44 ++++++++++++-------
  1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
index 2b550eff35f1..b583e0523575 100644
--- a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
@@ -16,6 +16,8 @@ enum monitor_mwait_testcases {
         MWAIT_DISABLED = BIT(2),
  };

+static int testcase;
+
  /*
   * If both MWAIT and its quirk are disabled, MONITOR/MWAIT should #UD, in all
   * other scenarios KVM should emulate them as nops.
@@ -35,7 +37,7 @@ do {                                                                  \
                                testcase, vector);                       \
  } while (0)

-static void guest_monitor_wait(int testcase)
+static void guest_monitor_wait(void)
  {
         u8 vector;

@@ -54,31 +56,22 @@ static void guest_monitor_wait(int testcase)

  static void guest_code(void)
  {
-       guest_monitor_wait(MWAIT_DISABLED);
-
-       guest_monitor_wait(MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
-
-       guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_DISABLED);
-       guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED);
-
-       guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
-       guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED);
-
+       guest_monitor_wait();
         GUEST_DONE();
  }

-int main(int argc, char *argv[])
+static void vm_test_case(int test_case)
  {
         uint64_t disabled_quirks;
         struct kvm_vcpu *vcpu;
         struct kvm_vm *vm;
         struct ucall uc;
-       int testcase;
-
-       TEST_REQUIRE(this_cpu_has(X86_FEATURE_MWAIT));
-       TEST_REQUIRE(kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2));

         vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+       testcase = test_case;
+       sync_global_to_guest(vm, testcase);
+
         vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);

         while (1) {
@@ -87,7 +80,7 @@ int main(int argc, char *argv[])

                 switch (get_ucall(vcpu, &uc)) {
                 case UCALL_SYNC:
-                       testcase = uc.args[1];
+                       TEST_ASSERT_EQ(testcase, uc.args[1]);
                         break;
                 case UCALL_ABORT:
                         REPORT_GUEST_ASSERT(uc);
@@ -125,5 +118,22 @@ int main(int argc, char *argv[])

  done:
         kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+       TEST_REQUIRE(this_cpu_has(X86_FEATURE_MWAIT));
+       TEST_REQUIRE(kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2));
+
+       vm_test_case(MWAIT_DISABLED);
+
+       vm_test_case(MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
+
+       vm_test_case(MISC_ENABLES_QUIRK_DISABLED | MWAIT_DISABLED);
+       vm_test_case(MISC_ENABLES_QUIRK_DISABLED);
+
+       vm_test_case(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
+       vm_test_case(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED);
+
         return 0;
  }
-- 
2.46.0



