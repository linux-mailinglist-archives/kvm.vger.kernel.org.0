Return-Path: <kvm+bounces-39624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1A3A4886B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8AE4188AD57
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A33126BD95;
	Thu, 27 Feb 2025 18:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZCn1dGK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8E424BBE5;
	Thu, 27 Feb 2025 18:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740682684; cv=none; b=INW358sdLw1jZNbmoIJPRiPA1qbk9Y8jqbt/8GgxXH7BBFp/WbAV2WVrROXg7aP3SbAs+9U7SQh2wC4rd1m2mRNjXEdOJW0OsOQsPhP2/7sDGjxdCUUok5tuA4LUGC5TIDKPgTRdazKdLfVgBWgeyPOX7ZmTSf70z15vEqGJ0ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740682684; c=relaxed/simple;
	bh=/PkVj0ceTKDTROCPvPV7DORzicIvexQCwDB8iAsixKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QjbbQAsX2BhTUGDowbYLqX2M8JBbgnv0H7DVgBYPD7Ud5SZueL9VzQKw6OzJ6NgR9tT4sQMc8UR8agcUhwjVFanRAW+fcpFWNS5sm+UEc/ijBdQ++/1bE1kL7WXPc66z8mfvG2TRWB4BOmmkEFvs6Beu3rhdjG7lKMhMzQHKWnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZCn1dGK; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740682682; x=1772218682;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/PkVj0ceTKDTROCPvPV7DORzicIvexQCwDB8iAsixKY=;
  b=IZCn1dGKSPE8tJ83084QoSZ59LTEA2JpJfIHuc+9C+WFnGN57kk9L7EP
   6kiqzTb99jBw5U81B43QsrVI+yLeqOyDttxUrT+Lb0ncRJ10jmTfRpXZZ
   8HHuSHVMbxM+5xlwKAAtttjDA2SRqBKiSj5ZI6AaTfMc8UN34plxorHBC
   HIBgihUDNXIPrFMjr3fewA+lw129g/9iMcgxv8/evt/B1jfup9yAgH5jG
   DxDCqzpSQ3TfNBhc3oF+4DAt4EzW//xKJmDxpjLiOf/bWasR2uA0Xexpk
   K727gF73d2fsY7WnwnZyw6xXT1thMWjyqxL5dJ4gR3XdxQwwe3gW+FiOA
   w==;
X-CSE-ConnectionGUID: nO76mtunSn+LVr8Uh5hGSw==
X-CSE-MsgGUID: r2MTpi9rSJeHoUd7cC49/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="52987595"
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="52987595"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 10:58:01 -0800
X-CSE-ConnectionGUID: TsdJW2h6T/6mdefeT5gX8g==
X-CSE-MsgGUID: sAGAas69QI+7PkmlN3cBvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="121706706"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 27 Feb 2025 10:57:56 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tnj50-000Du2-0s;
	Thu, 27 Feb 2025 18:57:54 +0000
Date: Fri, 28 Feb 2025 02:57:18 +0800
From: kernel test robot <lkp@intel.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
	herbert@gondor.apana.org.au
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
	ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
	aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v5 2/7] crypto: ccp: Ensure implicit SEV/SNP init and
 shutdown in ioctls
Message-ID: <202502280243.uLlWONet-lkp@intel.com>
References: <1d7b31af0eb36d860907c1e89e553e642f3882e0.1740512583.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d7b31af0eb36d860907c1e89e553e642f3882e0.1740512583.git.ashish.kalra@amd.com>

Hi Ashish,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on kvm/queue kvm/next linus/master v6.14-rc4 next-20250227]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashish-Kalra/crypto-ccp-Move-dev_info-err-messages-for-SEV-SNP-init-and-shutdown/20250226-050640
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/1d7b31af0eb36d860907c1e89e553e642f3882e0.1740512583.git.ashish.kalra%40amd.com
patch subject: [PATCH v5 2/7] crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20250228/202502280243.uLlWONet-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250228/202502280243.uLlWONet-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502280243.uLlWONet-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/crypto/ccp/sev-dev.c:22:
   In file included from include/linux/ccp.h:14:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2224:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/crypto/ccp/sev-dev.c:1970:7: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    1970 |                 if (!writable)
         |                     ^~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:2012:9: note: uninitialized use occurs here
    2012 |         return ret;
         |                ^~~
   drivers/crypto/ccp/sev-dev.c:1970:3: note: remove the 'if' if its condition is always false
    1970 |                 if (!writable)
         |                 ^~~~~~~~~~~~~~
    1971 |                         goto e_free_cert;
         |                         ~~~~~~~~~~~~~~~~
   drivers/crypto/ccp/sev-dev.c:1927:9: note: initialize the variable 'ret' to silence this warning
    1927 |         int ret, error;
         |                ^
         |                 = 0
   4 warnings generated.


vim +1970 drivers/crypto/ccp/sev-dev.c

  1917	
  1918	static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
  1919	{
  1920		struct sev_device *sev = psp_master->sev_data;
  1921		struct sev_user_data_pdh_cert_export input;
  1922		void *pdh_blob = NULL, *cert_blob = NULL;
  1923		struct sev_data_pdh_cert_export data;
  1924		void __user *input_cert_chain_address;
  1925		void __user *input_pdh_cert_address;
  1926		bool shutdown_required = false;
  1927		int ret, error;
  1928	
  1929		if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
  1930			return -EFAULT;
  1931	
  1932		memset(&data, 0, sizeof(data));
  1933	
  1934		/* Userspace wants to query the certificate length. */
  1935		if (!input.pdh_cert_address ||
  1936		    !input.pdh_cert_len ||
  1937		    !input.cert_chain_address)
  1938			goto cmd;
  1939	
  1940		input_pdh_cert_address = (void __user *)input.pdh_cert_address;
  1941		input_cert_chain_address = (void __user *)input.cert_chain_address;
  1942	
  1943		/* Allocate a physically contiguous buffer to store the PDH blob. */
  1944		if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
  1945			return -EFAULT;
  1946	
  1947		/* Allocate a physically contiguous buffer to store the cert chain blob. */
  1948		if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
  1949			return -EFAULT;
  1950	
  1951		pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
  1952		if (!pdh_blob)
  1953			return -ENOMEM;
  1954	
  1955		data.pdh_cert_address = __psp_pa(pdh_blob);
  1956		data.pdh_cert_len = input.pdh_cert_len;
  1957	
  1958		cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
  1959		if (!cert_blob) {
  1960			ret = -ENOMEM;
  1961			goto e_free_pdh;
  1962		}
  1963	
  1964		data.cert_chain_address = __psp_pa(cert_blob);
  1965		data.cert_chain_len = input.cert_chain_len;
  1966	
  1967	cmd:
  1968		/* If platform is not in INIT state then transition it to INIT. */
  1969		if (sev->state != SEV_STATE_INIT) {
> 1970			if (!writable)
  1971				goto e_free_cert;
  1972			ret = __sev_platform_init_locked(&error);
  1973			if (ret) {
  1974				argp->error = SEV_RET_INVALID_PLATFORM_STATE;
  1975				goto e_free_cert;
  1976			}
  1977			shutdown_required = true;
  1978		}
  1979	
  1980		ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
  1981	
  1982		/* If we query the length, FW responded with expected data. */
  1983		input.cert_chain_len = data.cert_chain_len;
  1984		input.pdh_cert_len = data.pdh_cert_len;
  1985	
  1986		if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
  1987			ret = -EFAULT;
  1988			goto e_free_cert;
  1989		}
  1990	
  1991		if (pdh_blob) {
  1992			if (copy_to_user(input_pdh_cert_address,
  1993					 pdh_blob, input.pdh_cert_len)) {
  1994				ret = -EFAULT;
  1995				goto e_free_cert;
  1996			}
  1997		}
  1998	
  1999		if (cert_blob) {
  2000			if (copy_to_user(input_cert_chain_address,
  2001					 cert_blob, input.cert_chain_len))
  2002				ret = -EFAULT;
  2003		}
  2004	
  2005	e_free_cert:
  2006		if (shutdown_required)
  2007			__sev_platform_shutdown_locked(&error);
  2008	
  2009		kfree(cert_blob);
  2010	e_free_pdh:
  2011		kfree(pdh_blob);
  2012		return ret;
  2013	}
  2014	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

