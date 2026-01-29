Return-Path: <kvm+bounces-69528-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8DUFB+cwe2kVCQIAu9opvQ
	(envelope-from <kvm+bounces-69528-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:05:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CDEE6AE61C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 46F9B3030EF4
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB442273D6D;
	Thu, 29 Jan 2026 10:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mQfCqmwO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A343E37C0E5;
	Thu, 29 Jan 2026 10:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769681102; cv=none; b=DtFeswGMFe1itt0l9tu88K+DLWQwf65x2eghxlHPFpQU6JJhrxvlxZ2IyZAVvPScCbYv+zNti/vz4noTbr1vO0i25kZPzz1oy7uqFJsoJnVkcu0KCCorzMsnr8kn3l40FsuyQsc6SzDxS9xU3/fH5tUrO+rqLH3a3r3b0/9z354=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769681102; c=relaxed/simple;
	bh=pYCQVA/12d4uhxT7aRwlkFoYf2mKBsD++2vXc6f0iJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIr5vJo8bSbUATksddKvAD9SBASj1dBiDK1e8ZceJGi2qZ5bR/8P1tMjwS6ior3Ks/Hz40vFY4AWx3kk/gfRdVkXXbYwndAfqZ0t6oopHCe7tW6udYh4pwXEvpDrX125NDzRDVNAADaUdJv9w+Azye4wj8HDmqWLwKOjHDb/Ig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mQfCqmwO; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769681102; x=1801217102;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pYCQVA/12d4uhxT7aRwlkFoYf2mKBsD++2vXc6f0iJA=;
  b=mQfCqmwO5dts/Rpi+hG1jfWIvZCghXNk6/qPf2M+loHfe5SWuIXlyiap
   fHJgcNsG6Lguksmb1zkocAXiD0ev016PuPnApyYvRIAS5QL5VSeRWCERV
   tvFnuqnYg5NS+dFIZnlygixiupabzo24twyc3Sbor0IQJOwl+I/ewmKWh
   JVaWp7+jZMGKt2M6zlI5nSGX2Lhc/vkQU+w0MyPbqp+wJOi3zoxekJP7R
   Fou5AM4y0q1dBLsj4Oqs6Yag0Jwk5K+v9h31zk1E+IQ5nnkdDVBop0h53
   9EoXtSSm28z+V/TersBrsbgIiViYbd9GV3oKzaSMtJRTfymwd81cm3ds4
   Q==;
X-CSE-ConnectionGUID: NAlNbb/6Qk64DGl2Fan8uw==
X-CSE-MsgGUID: En2ajNeqTY68v2enmtRJZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="82282576"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="82282576"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 02:05:01 -0800
X-CSE-ConnectionGUID: A24kz5kLRGaKNMcs7f3zdg==
X-CSE-MsgGUID: 5x7Dk9HqT/+JgUAG2DpWwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="208637324"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa007.jf.intel.com with ESMTP; 29 Jan 2026 02:04:54 -0800
Date: Thu, 29 Jan 2026 17:46:40 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	reinette.chatre@intel.com, ira.weiny@intel.com, kai.huang@intel.com,
	dan.j.williams@intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 06/26] x86/virt/tdx: Prepare to support P-SEAMLDR
 SEAMCALLs
Message-ID: <aXssgOZJteoaJUOz@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-7-chao.gao@intel.com>
 <e2245231-ee39-40aa-bfdc-e43419fa30f4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2245231-ee39-40aa-bfdc-e43419fa30f4@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69528-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:dkim]
X-Rspamd-Queue-Id: CDEE6AE61C
X-Rspamd-Action: no action

> >  static __always_inline int sc_retry_prerr(sc_func_t func,
> >  					  sc_err_func_t err_func,
> >  					  u64 fn, struct tdx_module_args *args)
> > @@ -96,4 +119,7 @@ static __always_inline int sc_retry_prerr(sc_func_t func,
> >  #define seamcall_prerr_ret(__fn, __args)					\
> >  	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
> >  
> > +#define seamldr_prerr(__fn, __args)						\
> > +	sc_retry_prerr(__seamcall, seamldr_err, (__fn), (__args))
> > +
> >  #endif
> 
> So, honestly, for me, it's a NAK for this whole patch.
> 
> Go change the P-SEAMLDR to use the same error code as the TDX module,
> and fix the documentation. No kernel changes, please.

I'm thinking of ways to avoid a new pseamldr version.

Could we just ask for a unified error code space for both SEAMCALL &
SEAMLDR CALL, eliminating overlaps. There is no overlap now, so this is
just another documentation fix.

Then with all the doc fixes, we only need minor code change:


@@ -127,7 +127,8 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
                preempt_disable();
                ret = __seamcall_dirty_cache(func, fn, args);
                preempt_enable();
-       } while (ret == TDX_RND_NO_ENTROPY && --retry);
+       } while ((ret == TDX_RND_NO_ENTROPY ||
+                 ret == SEAMLDR_RND_NO_ENTROPY) && --retry);


I think this is a balance. The existing error code philosophy for SEAM
is as informative as possible, e.g. all kinds of xxx_INVALID,
SEAMLDR_RND_NO_ENTROPY is not that evil among 200+ other error codes.

