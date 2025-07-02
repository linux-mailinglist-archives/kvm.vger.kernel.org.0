Return-Path: <kvm+bounces-51252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE71AF09FE
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 06:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B81D7480F94
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 04:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68DBF1EC006;
	Wed,  2 Jul 2025 04:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwLBYMdi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB45132122
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 04:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751431189; cv=none; b=I3pIk+z1IcotyRJavGaFpM7slfIqraMUZPsh38AIupiLiD5qJ/JAY7b4l7rkr+t0VjhF/cIEU0y9iJlfQI5Ov/CSM4bW8wQtbgeF0MgRSiSA9ot6sSGo+IyNlAzSaKvHdyK/mq9yEQSHam2fOi6P9r9DJV4VYzn+zug12thIjJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751431189; c=relaxed/simple;
	bh=mVbk9MTm+7mpEitDYW3vFzEIYpyFC9akWhxShjigfCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhTr1VtLM+7gppC+vUfU4n9/ayujy7sHuQCH+tqJP+ztDHZ6IUKXRuqOGGO3VMo77F2B89JBXZuIgdJiGPeL/YqeuwXP0mlxHlA/oMcDLdT/a9QjcWtXmA/3Hw8DtEJTeim+5bS+9tIWxX3xvy/Ilm9/TYSNzyTCebXVH/BDOfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwLBYMdi; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751431187; x=1782967187;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=mVbk9MTm+7mpEitDYW3vFzEIYpyFC9akWhxShjigfCs=;
  b=OwLBYMdiU2X/l+fhjK/vyuKuJ1EVDH7o0u3TtWWLdo7ThTEYrQGVVWCj
   Rhd364+TuxD9da9YFVH3U9msvdQYKSi0R/dpoGPwJtWjEzD1bUH3JKMLs
   lD3JrWEv2poAhZSO1M2n0Wp8XtMJ87Y2SIO5te0Mkgm4F11Jpc3AczGK0
   mH+z47Tu7EQV/apDkusAjTI+zM0POxiKCSdnQ7oGvG2xYRulyWJNmIRwY
   ME/TJvoL95hIpHYWMd2FIPX3VIj9XkBqMjZOEfGstyss1oyY/JiOXjNxf
   Ud/wEsqshIZiFtcl2UfQ7x5XnWbkBG0+89J780/zPt5Ddc+Svs28d/Eiv
   g==;
X-CSE-ConnectionGUID: N12SV5oJSZ6Dmrq2PxD8PQ==
X-CSE-MsgGUID: N91IYj6aS9e6AetEWIPQEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="53855350"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="53855350"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 21:39:45 -0700
X-CSE-ConnectionGUID: vjheMQSOQNWBXS/RLTR7hA==
X-CSE-MsgGUID: +09q9AlLRo+Ke7ggPa8vWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="159668321"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 01 Jul 2025 21:39:43 -0700
Date: Wed, 2 Jul 2025 13:01:07 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Igor Mammedov <imammedo@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org,
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aGS9E6pT0I57gn+e@intel.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
 <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com>
 <20250701150500.3a4001e9@fedora>
 <aGQ-ke-pZhzLnr8t@char.us.oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aGQ-ke-pZhzLnr8t@char.us.oracle.com>

Thanks Igor for looking here and thanks Konrad's explanation.

> > > > On 7/1/2025 6:26 PM, Zhao Liu wrote:  
> > > > > > unless it was explicitly requested by the user.  
> > > > > But this could still break Windows, just like issue #3001, which enables
> > > > > arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
> > > > > turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
> > > > > value would even break something.
> > > > > 
> > > > > So even for named CPUs, arch-capabilities=on doesn't reflect the fact
> > > > > that it is purely emulated, and is (maybe?) harmful.  
> > > > 
> > > > It is because Windows adds wrong code. So it breaks itself and it's just the
> > > > regression of Windows.  
> > > 
> > > Could you please tell me what the Windows's wrong code is? And what's
> > > wrong when someone is following the hardware spec?
> > 
> > the reason is that it's reserved on AMD hence software shouldn't even try
> > to use it or make any decisions based on that.
> > 
> > 
> > PS:
> > on contrary, doing such ad-hoc 'cleanups' for the sake of misbehaving
> > guest would actually complicate QEMU for no big reason.
> 
> The guest is not misbehaving. It is following the spec.

(That's my thinking, and please feel free to correct me.)

I had the same thought. Windows guys could also say they didn't access
the reserved MSR unconditionally, and they followed the CPUID feature
bit to access that MSR. When CPUID is set, it indicates that feature is
implemented.

At least I think it makes sense to rely on the CPUID to access the MSR.
Just as an example, it's unlikely that after the software finds a CPUID
of 1, it still need to download the latest spec version to confirm
whether the feature is actually implemented or reserved.

Based on the above point, this CPUID feature bit is set to 1 in KVM and
KVM also adds emulation (as a fix) specifically for this MSR. This means
that Guest is considered to have valid access to this feature MSR,
except that if Guest doesn't get what it wants, then it is reasonable
for Guest to assume that the current (v)CPU lacks hardware support and
mark it as "unsupported processor".

As Konrad's mentioned, there's the previous explanation about why KVM
sets this feature bit (it started with a little accident):

https://lore.kernel.org/kvm/CALMp9eRjDczhSirSismObZnzimxq4m+3s6Ka7OxwPj5Qj6X=BA@mail.gmail.com/#t

So I think the question is where this fix should be applied (KVM or
QEMU) or if it should be applied at all, rather than whether Windows has
the bug.

But I do agree, such "cleanups" would complicate QEMU, as I listed
Eduardo as having done similar workaround six years ago:

https://lore.kernel.org/qemu-devel/20190125220606.4864-1-ehabkost@redhat.com/

Complexity and technical debt is an important consideration, and another
consideration is the impact of this issue. Luckily, newer versions of
Windows are actively compatible with KVM + QEMU:

https://blogs.windows.com/windows-insider/2025/06/23/announcing-windows-11-insider-preview-build-26120-4452-beta-channel/

But it's also hard to say if such a problem will happen again.
Especially if the software works fine on real hardware but fails in
"-host cpu" (which is supposed synchronized with host as much as
possible).

> > Also
> > KVM does do have plenty of such code, and it's not actively preventing guests from using it.
> > Given that KVM is not welcoming such change, I think QEMU shouldn't do that either.
> 
> Because KVM maintainer does not want to touch the guest ABI. He agrees
> this is a bug.

If we agree on this fix should be applied on Linux virtualization stack,
then the question of whether the fix should land in KVM or QEMU is a bit
like the chicken and egg dilemma.

I personally think it might be better to roll it out in QEMU first — it
feels like the safer bet:

 * Currently, the -cpu host option enables this feature by default, and
   it's hard to say if anyone is actually relying on this emulated
   feature (though issue #3001 suggests it causes trouble for Windows).
   So only when the ABI changes, it's uncertain if anything will break.

 * Similarly, if only the ABI is changed, I'm a bit unsure if there's
   any migration based on "-cpu host" and between different versions of
   kernel. And, based on my analysis at the beginning reply, named CPUs
   also have the effect if user actively sets "arch-capbilities=on". But
   the key here point is the migration happens between different kernel
   versions.

 * Additionally, handling different versions of ABI can sometimes be
   quite complex. After changing the ABI, there might be differences
   between the new kernel and the old stable kernels (and according to
   doc, the oldest supported kernel is v4.5 - docs/system/target-i386.rst).
   It's similar to what Ewan previously complained about:

   https://lore.kernel.org/qemu-devel/53119b66-3528-41d6-ac44-df166699500a@zhaoxin.com/

So, if anyone is relying on the current emulated feature, changing the
ABI will inevitably break existing things, and QEMU might have to bear
the cost of maintaining compatibility with the old ABI. :-(

Personally, I think the safer approach is to first handle potential old
dependencies in QEMU through a compat option. Once the use case is
eliminated in user space, it can clearly demonstrate that the ABI change
won't disrupt user space.

The workaround change I proposed to Alexandre isn't meant to be
permanent. If we upgrade the supported kernel version to >6.17 (assuming
the ABI can be changed in 6.17), then the workaround can be removed —
though I admit that day might never come...

Thanks for your patience.
Zhao


