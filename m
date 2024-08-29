Return-Path: <kvm+bounces-25370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E2496494D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84A62284932
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C7E1B1505;
	Thu, 29 Aug 2024 14:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nF1eT+mU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B805C1AED49;
	Thu, 29 Aug 2024 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724943572; cv=none; b=otxPM6qrL77cVeDxVceoUPPeGsVqvIn6zmZW2ebL2kdSyoaEy3y658G307VsMpx3oPY3pSaSmoTOxQ/exvU64oFUOoVYDZaC0Si9n2JdnNrCXOwzh2JEDnZtIysryDrymfl/+r7oIoOp8Fp5kQxiMLOVzG8vWBdu1yuHqw/RWy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724943572; c=relaxed/simple;
	bh=LuHSMRJORq3jqFFNMteS+Q2synOJkKn5xhtJHp7x/CE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFP/TpUX9VmKUZ9YqAvb0jGF1U1MXV6qhoJKOEaVtKPz5ssyVVSt6Ij8Nbja866a6zb6IOipFvElkHVNlabjlNMPvgv1GObex83Gr4CROjqep25NxpyykwRz0DWyMEtjBLvulzQMDBMHtkKjYyKPTQxfnhk2HW5JDw2ywTiKhvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nF1eT+mU; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724943570; x=1756479570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LuHSMRJORq3jqFFNMteS+Q2synOJkKn5xhtJHp7x/CE=;
  b=nF1eT+mUGdinYsuZZah9hgRKE+dTh/+3MPA5S7jxSOzWsyLg26l18tc2
   kSNnFDSMBmuZeZfudKd0EKSqtjEAcuIam+O7Uxy5Um4kSjn8rubF7T7LK
   qS0LdtiSDefrIioqdAKS8wmWKHmBF1vHM4fUro3lRBpOB9w1gC9qnC+pc
   DOByV5GXXjZzpJlWm+lOcO608jJFs/7tRk/4mi3OtuMU3nnmuQUjJHQDD
   eLsIeSUF+X5asdAulE1Fu7EXxaq9qpSsokKfiv9p1AhVO5YnBaqCwf6ZX
   7qjK4iS5c4lHIN/6mxZwXjr8v1Fc2WiqZD/jbE9zbaL/aXr64chR648oX
   w==;
X-CSE-ConnectionGUID: DHzMc847S0eQ6arDD2iGbw==
X-CSE-MsgGUID: bD0fruy6RDm/LRQN+ZoVuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="13282283"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="13282283"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 07:59:29 -0700
X-CSE-ConnectionGUID: 8/mRw1n+QH6bo8TAogLHzw==
X-CSE-MsgGUID: LVpn394rTTyiayzAEy+ASw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="63229167"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 Aug 2024 07:59:26 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sjgcN-0000Ny-1N;
	Thu, 29 Aug 2024 14:59:23 +0000
Date: Thu, 29 Aug 2024 22:58:47 +0800
From: kernel test robot <lkp@intel.com>
To: Vegard Nossum <vegard.nossum@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-um@lists.infradead.org,
	bpf@vger.kernel.org, llvm@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] kbuild: use objcopy to generate asm-offsets
Message-ID: <202408292215.pEJKHLfT-lkp@intel.com>
References: <20240828083605.3093701-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828083605.3093701-1-vegard.nossum@oracle.com>

Hi Vegard,

kernel test robot noticed the following build errors:

[auto build test ERROR on masahiroy-kbuild/for-next]
[also build test ERROR on masahiroy-kbuild/fixes soc/for-next kvmarm/next kvm/queue uml/next krzk-mem-ctrl/for-next bpf-next/master bpf/master linus/master v6.11-rc5 next-20240829]
[cannot apply to tmlind-omap/for-next kvm/linux-next uml/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vegard-Nossum/kbuild-use-objcopy-to-generate-asm-offsets/20240828-163854
base:   https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git for-next
patch link:    https://lore.kernel.org/r/20240828083605.3093701-1-vegard.nossum%40oracle.com
patch subject: [PATCH] kbuild: use objcopy to generate asm-offsets
config: sh-randconfig-r072-20240829 (https://download.01.org/0day-ci/archive/20240829/202408292215.pEJKHLfT-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240829/202408292215.pEJKHLfT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408292215.pEJKHLfT-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from scripts/mod/file2alias.c:13:
   scripts/mod/file2alias.c: In function 'do_usb_entry':
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:66:55: note: in definition of macro 'TO_NATIVE'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                       ^
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:57:31: note: in definition of macro 'bswap'
      57 |         _Static_assert(sizeof(x) == 1 || sizeof(x) == 2 || \
         |                               ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:57:49: note: in definition of macro 'bswap'
      57 |         _Static_assert(sizeof(x) == 1 || sizeof(x) == 2 || \
         |                                                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:58:31: note: in definition of macro 'bswap'
      58 |                        sizeof(x) == 4 || sizeof(x) == 8, "bug"); \
         |                               ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:58:49: note: in definition of macro 'bswap'
      58 |                        sizeof(x) == 4 || sizeof(x) == 8, "bug"); \
         |                                                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:59:17: note: in definition of macro 'bswap'
      59 |         (typeof(x))(sizeof(x) == 2 ? bswap_16(x) : \
         |                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:59:28: note: in definition of macro 'bswap'
      59 |         (typeof(x))(sizeof(x) == 2 ? bswap_16(x) : \
         |                            ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
   In file included from scripts/mod/modpost.h:2:
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:60:28: note: in definition of macro 'bswap'
      60 |                     sizeof(x) == 4 ? bswap_32(x) : \
         |                            ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:61:28: note: in definition of macro 'bswap'
      61 |                     sizeof(x) == 8 ? bswap_64(x) : \
         |                            ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:62:21: note: in definition of macro 'bswap'
      62 |                     x); \
         |                     ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:175:9: note: in expansion of macro 'DEF_FIELD'
     175 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:11:36: error: stray '#' in program
      11 | #define OFF_usb_device_id_idVendor #2 /* offsetof(struct usb_device_id, idVendor) */
         |                                    ^
   scripts/mod/modpost.h:66:55: note: in definition of macro 'TO_NATIVE'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                       ^
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_idVendor'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:176:9: note: in expansion of macro 'DEF_FIELD'
     176 |         DEF_FIELD(symval, usb_device_id, idVendor);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:11:36: error: stray '#' in program
      11 | #define OFF_usb_device_id_idVendor #2 /* offsetof(struct usb_device_id, idVendor) */
         |                                    ^
   scripts/mod/modpost.h:57:31: note: in definition of macro 'bswap'
      57 |         _Static_assert(sizeof(x) == 1 || sizeof(x) == 2 || \
         |                               ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_idVendor'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:176:9: note: in expansion of macro 'DEF_FIELD'
     176 |         DEF_FIELD(symval, usb_device_id, idVendor);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:11:36: error: stray '#' in program
      11 | #define OFF_usb_device_id_idVendor #2 /* offsetof(struct usb_device_id, idVendor) */
         |                                    ^
   scripts/mod/modpost.h:57:49: note: in definition of macro 'bswap'
      57 |         _Static_assert(sizeof(x) == 1 || sizeof(x) == 2 || \
         |                                                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_idVendor'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:176:9: note: in expansion of macro 'DEF_FIELD'
     176 |         DEF_FIELD(symval, usb_device_id, idVendor);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:11:36: error: stray '#' in program
      11 | #define OFF_usb_device_id_idVendor #2 /* offsetof(struct usb_device_id, idVendor) */
         |                                    ^
   scripts/mod/modpost.h:58:31: note: in definition of macro 'bswap'
      58 |                        sizeof(x) == 4 || sizeof(x) == 8, "bug"); \
         |                               ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_idVendor'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:176:9: note: in expansion of macro 'DEF_FIELD'
     176 |         DEF_FIELD(symval, usb_device_id, idVendor);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:11:36: error: stray '#' in program
      11 | #define OFF_usb_device_id_idVendor #2 /* offsetof(struct usb_device_id, idVendor) */
         |                                    ^
   scripts/mod/modpost.h:58:49: note: in definition of macro 'bswap'
      58 |                        sizeof(x) == 4 || sizeof(x) == 8, "bug"); \
         |                                                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_idVendor'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:176:9: note: in expansion of macro 'DEF_FIELD'
     176 |         DEF_FIELD(symval, usb_device_id, idVendor);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:11:36: error: stray '#' in program
      11 | #define OFF_usb_device_id_idVendor #2 /* offsetof(struct usb_device_id, idVendor) */
         |                                    ^
   scripts/mod/modpost.h:59:17: note: in definition of macro 'bswap'
      59 |         (typeof(x))(sizeof(x) == 2 ? bswap_16(x) : \
         |                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_idVendor'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:176:9: note: in expansion of macro 'DEF_FIELD'
     176 |         DEF_FIELD(symval, usb_device_id, idVendor);
--
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_bInterfaceNumber'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:185:9: note: in expansion of macro 'DEF_FIELD'
     185 |         DEF_FIELD(symval, usb_device_id, bInterfaceNumber);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:21:44: error: stray '#' in program
      21 | #define OFF_usb_device_id_bInterfaceNumber #16 /* offsetof(struct usb_device_id, bInterfaceNumber) */
         |                                            ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_bInterfaceNumber'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:185:9: note: in expansion of macro 'DEF_FIELD'
     185 |         DEF_FIELD(symval, usb_device_id, bInterfaceNumber);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:21:44: error: stray '#' in program
      21 | #define OFF_usb_device_id_bInterfaceNumber #16 /* offsetof(struct usb_device_id, bInterfaceNumber) */
         |                                            ^
   scripts/mod/modpost.h:60:28: note: in definition of macro 'bswap'
      60 |                     sizeof(x) == 4 ? bswap_32(x) : \
         |                            ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_bInterfaceNumber'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:185:9: note: in expansion of macro 'DEF_FIELD'
     185 |         DEF_FIELD(symval, usb_device_id, bInterfaceNumber);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:21:44: error: stray '#' in program
      21 | #define OFF_usb_device_id_bInterfaceNumber #16 /* offsetof(struct usb_device_id, bInterfaceNumber) */
         |                                            ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_bInterfaceNumber'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:185:9: note: in expansion of macro 'DEF_FIELD'
     185 |         DEF_FIELD(symval, usb_device_id, bInterfaceNumber);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:21:44: error: stray '#' in program
      21 | #define OFF_usb_device_id_bInterfaceNumber #16 /* offsetof(struct usb_device_id, bInterfaceNumber) */
         |                                            ^
   scripts/mod/modpost.h:61:28: note: in definition of macro 'bswap'
      61 |                     sizeof(x) == 8 ? bswap_64(x) : \
         |                            ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_bInterfaceNumber'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:185:9: note: in expansion of macro 'DEF_FIELD'
     185 |         DEF_FIELD(symval, usb_device_id, bInterfaceNumber);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:21:44: error: stray '#' in program
      21 | #define OFF_usb_device_id_bInterfaceNumber #16 /* offsetof(struct usb_device_id, bInterfaceNumber) */
         |                                            ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_bInterfaceNumber'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:185:9: note: in expansion of macro 'DEF_FIELD'
     185 |         DEF_FIELD(symval, usb_device_id, bInterfaceNumber);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:21:44: error: stray '#' in program
      21 | #define OFF_usb_device_id_bInterfaceNumber #16 /* offsetof(struct usb_device_id, bInterfaceNumber) */
         |                                            ^
   scripts/mod/modpost.h:62:21: note: in definition of macro 'bswap'
      62 |                     x); \
         |                     ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_bInterfaceNumber'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:185:9: note: in expansion of macro 'DEF_FIELD'
     185 |         DEF_FIELD(symval, usb_device_id, bInterfaceNumber);
         |         ^~~~~~~~~
   scripts/mod/file2alias.c: In function 'do_usb_entry_multi':
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:66:55: note: in definition of macro 'TO_NATIVE'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                       ^
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:57:31: note: in definition of macro 'bswap'
      57 |         _Static_assert(sizeof(x) == 1 || sizeof(x) == 2 || \
         |                               ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:57:49: note: in definition of macro 'bswap'
      57 |         _Static_assert(sizeof(x) == 1 || sizeof(x) == 2 || \
         |                                                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:58:31: note: in definition of macro 'bswap'
      58 |                        sizeof(x) == 4 || sizeof(x) == 8, "bug"); \
         |                               ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:58:49: note: in definition of macro 'bswap'
      58 |                        sizeof(x) == 4 || sizeof(x) == 8, "bug"); \
         |                                                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:59:17: note: in definition of macro 'bswap'
      59 |         (typeof(x))(sizeof(x) == 2 ? bswap_16(x) : \
         |                 ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
>> ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:59:28: note: in definition of macro 'bswap'
      59 |         (typeof(x))(sizeof(x) == 2 ? bswap_16(x) : \
         |                            ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:60:28: note: in definition of macro 'bswap'
      60 |                     sizeof(x) == 4 ? bswap_32(x) : \
         |                            ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:61:28: note: in definition of macro 'bswap'
      61 |                     sizeof(x) == 8 ? bswap_64(x) : \
         |                            ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:66:59: note: in expansion of macro 'bswap'
      66 |         (target_is_big_endian == host_is_big_endian ? x : bswap(x))
         |                                                           ^~~~~
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                                                           ^~~~
   scripts/mod/file2alias.c:282:9: note: in expansion of macro 'DEF_FIELD'
     282 |         DEF_FIELD(symval, usb_device_id, match_flags);
         |         ^~~~~~~~~
   ./scripts/mod/devicetable-offsets.h:10:39: error: stray '#' in program
      10 | #define OFF_usb_device_id_match_flags #0 /* offsetof(struct usb_device_id, match_flags) */
         |                                       ^
   scripts/mod/modpost.h:62:21: note: in definition of macro 'bswap'
      62 |                     x); \
         |                     ^
   scripts/mod/file2alias.c:73:44: note: in expansion of macro 'TO_NATIVE'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
         |                                            ^~~~~~~~~
   scripts/mod/file2alias.c:73:75: note: in expansion of macro 'OFF_usb_device_id_match_flags'
      73 |         typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

