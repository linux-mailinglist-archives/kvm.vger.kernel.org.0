Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2242218D
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhJEJC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:02:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:7352 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232478AbhJEJC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 05:02:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="311900605"
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="311900605"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 02:01:07 -0700
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="477590236"
Received: from gionascu-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.40.237])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 02:01:02 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kernel test robot <lkp@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "llvm\@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all\@lists.01.org" <kbuild-all@lists.01.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [vfio:next 33/38] drivers/gpu/drm/i915/i915_pci.c:975:2: warning: missing field 'override_only' initializer
In-Reply-To: <20211001115137.GJ964074@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210827153409.GV1721383@nvidia.com> <878rzdt3a3.fsf@intel.com> <20211001115137.GJ964074@nvidia.com>
Date:   Tue, 05 Oct 2021 12:00:59 +0300
Message-ID: <87fstf26d0.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 01 Oct 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> On Fri, Oct 01, 2021 at 02:04:04PM +0300, Jani Nikula wrote:
>> On Fri, 27 Aug 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
>> > On Fri, Aug 27, 2021 at 03:12:36PM +0000, kernel test robot wrote:
>> >> tree:   https://github.com/awilliam/linux-vfio.git next
>> >> head:   ea870730d83fc13a5fa2bd0e175176d7ac8a400a
>> >> commit: 343b7258687ecfbb363bfda8833a7cf641aac524 [33/38] PCI: Add 'override_only' field to struct pci_device_id
>> >> config: i386-randconfig-a004-20210827 (attached as .config)
>> >> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 1076082a0d97bd5c16a25ee7cf3dbb6ee4b5a9fe)
>> >> reproduce (this is a W=1 build):
>> >>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>> >>         chmod +x ~/bin/make.cross
>> >>         # https://github.com/awilliam/linux-vfio/commit/343b7258687ecfbb363bfda8833a7cf641aac524
>> >>         git remote add vfio https://github.com/awilliam/linux-vfio.git
>> >>         git fetch --no-tags vfio next
>> >>         git checkout 343b7258687ecfbb363bfda8833a7cf641aac524
>> >>         # save the attached .config to linux build tree
>> >>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=i386 
>> >> 
>> >> If you fix the issue, kindly add following tag as appropriate
>> >> Reported-by: kernel test robot <lkp@intel.com>
>> >
>> > Ugh, this is due to this code:
>> >
>> > #define INTEL_VGA_DEVICE(id, info) {		\
>> > 	0x8086,	id,				\
>> > 	~0, ~0,					\
>> > 	0x030000, 0xff0000,			\
>> > 	(unsigned long) info }
>> >
>> > #define INTEL_QUANTA_VGA_DEVICE(info) {		\
>> > 	0x8086,	0x16a,				\
>> > 	0x152d,	0x8990,				\
>> > 	0x030000, 0xff0000,			\
>> > 	(unsigned long) info }
>> >
>> >
>> > Which really should be using the normal pattern for defining these
>> > structs:
>> >
>> > #define PCI_DEVICE_CLASS(dev_class,dev_class_mask) \
>> >         .class = (dev_class), .class_mask = (dev_class_mask), \
>> >         .vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
>> >         .subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
>> >
>> > The warning is also not a real issue, just clang being overzealous.
>> 
>> Stumbled upon this old report, sorry for the delayed response.
>> 
>> The reason it's not using designated initializers is that the same file
>> gets synced to some userspace projects (at least libdrm and
>> igt-gpu-tools) which use the macros to initialize slightly different
>> structs. For example, igt uses struct pci_id_match from libpciaccess-dev
>> (/usr/include/pciaccess.h) and can't easily adapt to different member
>> names.
>
> Do it like this:
>
>
> #ifdef __KERNEL__
> #define INTEL_VGA_DEVICE(..)
> #endif
>
>
> And userspace does
>
> #define INTEL_VGA_DEVICE(..)
> #include <foo.h>

Sure.

>> Anyway, we've got
>> 
>> subdir-ccflags-y += $(call cc-disable-warning, missing-field-initializers)
>> subdir-ccflags-y += $(call cc-disable-warning, initializer-overrides)
>> 
>> in drivers/gpu/drm/i915/Makefile, so I wonder why they're not respected.
>
> Disabling kernel warnings because some userspace wants to copy a
> kernel header is horrific, don't do that.

We've disabled some warnings because those lines are preceded by

subdir-ccflags-y := -Wall -Wextra

enabling more warnings than the kernel build generally does.


BR,
Jani.



-- 
Jani Nikula, Intel Open Source Graphics Center
