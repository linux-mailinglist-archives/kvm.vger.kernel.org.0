Return-Path: <kvm+bounces-27371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7C79845E1
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 14:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9164EB217AA
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 12:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E76F1A706C;
	Tue, 24 Sep 2024 12:26:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C184B3F9D5;
	Tue, 24 Sep 2024 12:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727180785; cv=none; b=PWC9MVGRrVjSwSL1gAfFMl7GdUtqeGboSoSyAHzuTjBWi5NkGPRGcTBA5Ue7LhXxac0F7+unw4B/a7UgBCCSFzXL4C8SHRLPb9F6D1BeFtRWuSNRD0VHefXAR9OH4PwL2oP7Ugaza/ORMLXvep7yx+QszFcSvOJ2abaySHxqAmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727180785; c=relaxed/simple;
	bh=ZvJfiEwfNuvwZtXC2ii8kT4EZLzx/AHELisWsC/69po=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m0KgSxY7fVBrH2mZOLWWu/jY1ZIVo6qNadtow9lIAakXHEPelDTfk/JrCwBF/Y5ioHeA+yEnSUn3ooV/Ap+XUlxnPEW1CP51qx7euUG4hXfqKFAKbmiv+SR+YIA3fhAHe/vGNvQc4khViSHLX2Xv6D7RVnyn8lOtKuyS5kYVBj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BDC4DA7;
	Tue, 24 Sep 2024 05:26:52 -0700 (PDT)
Received: from [10.1.32.221] (R90XJLFY.arm.com [10.1.32.221])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 658753F64C;
	Tue, 24 Sep 2024 05:26:21 -0700 (PDT)
Message-ID: <b9367e1c-f339-46e1-8c44-d20f112a857a@arm.com>
Date: Tue, 24 Sep 2024 13:26:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] KVM: selftests: Allow slot modification stress
 test with quirk disabled
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 isaku.yamahata@intel.com, dmatlack@google.com, sagis@google.com,
 erdemaktas@google.com, graf@amazon.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
 Mark Brown <broonie@kernel.org>, Naresh Kamboju <naresh.kamboju@linaro.org>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
 <20240703021206.13923-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Aishwarya TCV <aishwarya.tcv@arm.com>
In-Reply-To: <20240703021206.13923-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 03/07/2024 03:12, Yan Zhao wrote:
> Add a new user option to memslot_modification_stress_test to allow testing
> with slot zap quirk KVM_X86_QUIRK_SLOT_ZAP_ALL disabled.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  .../kvm/memslot_modification_stress_test.c    | 19 +++++++++++++++++--
Hi Yan,

When building kselftest-kvm config against next-20240924 kernel with
Arm64 an error "'KVM_X86_QUIRK_SLOT_ZAP_ALL' undeclared" is observed.

A bisect identified 218f6415004a881d116e254eeb837358aced55ab as the
first bad commit. Bisected it on the tag "next-20240923" at repo
"https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git".
Reverting the change seems to fix it.

This works fine on Linux version 6.11

Failure log
------------
https://storage.kernelci.org/next/master/next-20240924/arm64/defconfig+kselftest/gcc-12/logs/kselftest.log

In file included from include/kvm_util.h:8,
                 from include/memstress.h:13,
                 from memslot_modification_stress_test.c:21:
memslot_modification_stress_test.c: In function ‘main’:
memslot_modification_stress_test.c:176:38: error:
‘KVM_X86_QUIRK_SLOT_ZAP_ALL’ undeclared (first use in this function)
  176 |                                      KVM_X86_QUIRK_SLOT_ZAP_ALL);
      |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
include/test_util.h:41:15: note: in definition of macro ‘__TEST_REQUIRE’
   41 |         if (!(f))                                               \
      |               ^
memslot_modification_stress_test.c:175:25: note: in expansion of macro
‘TEST_REQUIRE’
  175 |
TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
      |                         ^~~~~~~~~~~~
memslot_modification_stress_test.c:176:38: note: each undeclared
identifier is reported only once for each function it appears in
  176 |                                      KVM_X86_QUIRK_SLOT_ZAP_ALL);
      |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
include/test_util.h:41:15: note: in definition of macro ‘__TEST_REQUIRE’
   41 |         if (!(f))                                               \
      |               ^
memslot_modification_stress_test.c:175:25: note: in expansion of macro
‘TEST_REQUIRE’
  175 |
TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
      |                         ^~~~~~~~~~~~
At top level:
cc1: note: unrecognized command-line option
‘-Wno-gnu-variable-sized-type-not-at-end’ may have been intended to
silence earlier diagnostics
make[4]: *** [Makefile:300:
/tmp/kci/linux/build/kselftest/kvm/memslot_modification_stress_test.o]
Error 1
make[4]: Leaving directory '/tmp/kci/linux/tools/testing/selftests/kvm'


Bisect log:
----------

git bisect start
# good: [98f7e32f20d28ec452afb208f9cffc08448a2652] Linux 6.11
git bisect good 98f7e32f20d28ec452afb208f9cffc08448a2652
# bad: [ef545bc03a65438cabe87beb1b9a15b0ffcb6ace] Add linux-next
specific files for 20240923
git bisect bad ef545bc03a65438cabe87beb1b9a15b0ffcb6ace
# good: [176000734ee2978121fde22a954eb1eabb204329] Merge tag
'ata-6.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/libata/linux
git bisect good 176000734ee2978121fde22a954eb1eabb204329
# good: [f55bf3fb11d7fe32a37b8d625744d22891c02e5e] Merge branch
'at91-next' of git://git.kernel.org/pub/scm/linux/kernel/git/at91/linux.git
git bisect good f55bf3fb11d7fe32a37b8d625744d22891c02e5e
# good: [1340ff0aa9e6dcb9c8ac5f86472eb78ba524b14a] Merge branch
'for-next' of git://git.kernel.dk/linux-block.git
git bisect good 1340ff0aa9e6dcb9c8ac5f86472eb78ba524b14a
# bad: [51d98f15885e036a06fef35c396c987e80c47a27] Merge branch
'char-misc-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
git bisect bad 51d98f15885e036a06fef35c396c987e80c47a27
# bad: [4f216a17ef0dc3bf99c28902abbc6c70fb7798a0] Merge branch
'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
git bisect bad 4f216a17ef0dc3bf99c28902abbc6c70fb7798a0
# bad: [b11ba58b0ef5c932303dac5ce96e17d96c127870] Merge branch 'next' of
git://git.kernel.org/pub/scm/virt/kvm/kvm.git
git bisect bad b11ba58b0ef5c932303dac5ce96e17d96c127870
# good: [b7ba28772e5709196e3efffb9341c7fd698b2497] Merge branch
'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace.git
git bisect good b7ba28772e5709196e3efffb9341c7fd698b2497
# bad: [c345344e8317176944be33f46e18812c0343dc63] Merge tag
'kvm-x86-selftests-6.12' of https://github.com/kvm-x86/linux into HEAD
git bisect bad c345344e8317176944be33f46e18812c0343dc63
# bad: [7056c4e2a13a61f4e8a9e8ce27cd499f27e0e63b] Merge tag
'kvm-x86-generic-6.12' of https://github.com/kvm-x86/linux into HEAD
git bisect bad 7056c4e2a13a61f4e8a9e8ce27cd499f27e0e63b
# bad: [590b09b1d88e18ae57f89930a6f7b89795d2e9f3] KVM: x86: Register
"emergency disable" callbacks when virt is enabled
git bisect bad 590b09b1d88e18ae57f89930a6f7b89795d2e9f3
# bad: [70c0194337d38dd29533e63e3cb07620f8c5eae1] KVM: Rename symbols
related to enabling virtualization hardware
git bisect bad 70c0194337d38dd29533e63e3cb07620f8c5eae1
# bad: [218f6415004a881d116e254eeb837358aced55ab] KVM: selftests: Allow
slot modification stress test with quirk disabled
git bisect bad 218f6415004a881d116e254eeb837358aced55ab
# good: [b4ed2c67d275b85b2ab07d54f88bebd5998d61d8] KVM: selftests: Test
slot move/delete with slot zap quirk enabled/disabled
git bisect good b4ed2c67d275b85b2ab07d54f88bebd5998d61d8
# first bad commit: [218f6415004a881d116e254eeb837358aced55ab] KVM:
selftests: Allow slot modification stress test with quirk disabled

Thanks,
Aishwarya


