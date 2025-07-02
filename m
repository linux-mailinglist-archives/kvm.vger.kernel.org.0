Return-Path: <kvm+bounces-51259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEEEBAF0B8F
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDBEF4A39CF
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 06:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1F222257B;
	Wed,  2 Jul 2025 06:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OQoAh2OM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415621F4179
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 06:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751437273; cv=none; b=hdG0/0/xh2/XfOAZDy7+sgpNuYUAcsHIyrcW0F6M7ezicNOSqCOINr29NCWcpJ3lpQCa3x7oo6mxS0X5bT/wmSvuXr+MVqKEgItWEgChioGnnp4jcN2c6qL2nXWQ2fU2G2Wy4pf8zl4xFJUwwpYzRjtVcf1i6NRfPVeNDLinqjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751437273; c=relaxed/simple;
	bh=KDE7bcX47aDBLE8+1wi3xHJx7irP5QBRBP1cPyNpGEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYOlV5f3MRCHdBepHMBn/eu1b1FirBJIbThieT1DiuC0dZYtKV3lFUi+AOZHZbuJGmrBPGGKF6mtDPoyFChFfYnGehB+FvZhkniOP5WMZba3zqjVqoSUcYfwcPyf6uKHeqO51rW24rp3hPppcOavC71ysQ+YoJRMj8zT60eDfos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OQoAh2OM; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751437271; x=1782973271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KDE7bcX47aDBLE8+1wi3xHJx7irP5QBRBP1cPyNpGEo=;
  b=OQoAh2OMmM5B6JV/P/lnbQOICqmETVP66OM/2GLGncypQ9n20T/AFpFx
   Qcj2Zyyrxb/voaVPA1/kBu4lHd3Onk5/6ZHshxvUxNi21UTdMDGXorK60
   r89hsNsMdeX+mut//rJ4Q5QL6FPeKu1gYLCd10wAt6EwYUKKAUpoe0hjm
   ZnM3WPUk4uoSo699NfahHzwGwe586u9u7Fg7aXOlT9G3pvNJE/QMnWvzN
   EHkRrHNbG4GK2OA/q2qMlTDV/LcNglYZnjjh2dUpogutUwDOhdHea7W4Z
   39k2/v+T2HwyetSWLhKnPr+CE7E+Wt9OjPw8epz05Q392b0F/WTOBeulw
   A==;
X-CSE-ConnectionGUID: fMVjpHgUTv+EG9+T2X+qSw==
X-CSE-MsgGUID: 6o1fPV04QeeiiXwir5Yehg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="65069879"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="65069879"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 23:21:10 -0700
X-CSE-ConnectionGUID: 2DOTjRfKRXCZODe51K6jvQ==
X-CSE-MsgGUID: hIXI8E1kSa2EoaubLjUqNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="191160559"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 01 Jul 2025 23:21:09 -0700
Date: Wed, 2 Jul 2025 14:42:33 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-stable@nongnu.org,
	qemu-trivial@nongnu.org
Subject: Re: [PATCH] accel/kvm: Adjust the note about the minimum required
 kernel version
Message-ID: <aGTU2enBBQj7lu3E@intel.com>
References: <20250702060319.13091-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250702060319.13091-1-thuth@redhat.com>

On Wed, Jul 02, 2025 at 08:03:19AM +0200, Thomas Huth wrote:
> Date: Wed,  2 Jul 2025 08:03:19 +0200
> From: Thomas Huth <thuth@redhat.com>
> Subject: [PATCH] accel/kvm: Adjust the note about the minimum required
>  kernel version
> 
> From: Thomas Huth <thuth@redhat.com>
> 
> Since commit 126e7f78036 ("kvm: require KVM_CAP_IOEVENTFD and
> KVM_CAP_IOEVENTFD_ANY_LENGTH") we require at least kernel 4.4 to
> be able to use KVM. Adjust the upgrade_note accordingly.
> While we're at it, remove the text about kvm-kmod and the
> SourceForge URL since this is not actively maintained anymore.
> 
> Fixes: 126e7f78036 ("kvm: require KVM_CAP_IOEVENTFD and KVM_CAP_IOEVENTFD_ANY_LENGTH")
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

I just mentioned the kernel version in another patch thread. I found
x86 doc said it requires v4.5 or newer ("OS requirements" section in
docs/system/target-i386.rst).

> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index d095d1b98f8..e3302b087f4 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2571,8 +2571,7 @@ static int kvm_init(MachineState *ms)
>  {
>      MachineClass *mc = MACHINE_GET_CLASS(ms);
>      static const char upgrade_note[] =
> -        "Please upgrade to at least kernel 2.6.29 or recent kvm-kmod\n"
> -        "(see http://sourceforge.net/projects/kvm).\n";
> +        "Please upgrade to at least kernel 4.4.\n";
>      const struct {
>          const char *name;
>          int num;
> -- 
> 2.50.0
> 
> 

