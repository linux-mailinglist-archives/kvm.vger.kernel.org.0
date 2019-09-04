Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87DA8936
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbfIDPFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:05:20 -0400
Received: from foss.arm.com ([217.140.110.172]:56944 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbfIDPFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:05:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65F2C28;
        Wed,  4 Sep 2019 08:05:19 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 230793F59C;
        Wed,  4 Sep 2019 08:05:13 -0700 (PDT)
Subject: Re: [PATCH v4 02/10] KVM: arm/arm64: Factor out hypercall handling
 from PSCI code
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?unknown-8bit?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>
References: <20190830084255.55113-3-steven.price@arm.com>
 <201909021437.rO6o0mHc%lkp@intel.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <78c2cce6-19ae-302c-6e5a-3798f658c8e2@arm.com>
Date:   Wed, 4 Sep 2019 16:05:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <201909021437.rO6o0mHc%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2019 08:06, kbuild test robot wrote:
> Hi Steven,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [cannot apply to v5.3-rc6 next-20190830]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Steven-Price/arm64-Stolen-time-support/20190901-185152
> config: i386-randconfig-a002-201935 (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-11) 7.4.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from include/kvm/arm_hypercalls.h:7:0,
>                     from <command-line>:0:
>>> arch/x86/include/asm/kvm_emulate.h:349:22: error: 'NR_VCPU_REGS' undeclared here (not in a function)
>      unsigned long _regs[NR_VCPU_REGS];
>                          ^~~~~~~~~~~~

This is because x86's asm/kvm_emulate.h can't be included by itself (and
doesn't even exist on other architectures). This new header file doesn't
make sense to include on x86, so I'll squash in the following to prevent
building the header file except on arm/arm64.

Steve

----8<----
diff --git a/include/Kbuild b/include/Kbuild
index c38f0d46b267..f775ea28716e 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -67,6 +67,8 @@ header-test-			+= keys/big_key-type.h
 header-test-			+= keys/request_key_auth-type.h
 header-test-			+= keys/trusted.h
 header-test-			+= kvm/arm_arch_timer.h
+header-test-$(CONFIG_ARM)	+= kvm/arm_hypercalls.h
+header-test-$(CONFIG_ARM64)	+= kvm/arm_hypercalls.h
 header-test-			+= kvm/arm_pmu.h
 header-test-$(CONFIG_ARM)	+= kvm/arm_psci.h
 header-test-$(CONFIG_ARM64)	+= kvm/arm_psci.h
