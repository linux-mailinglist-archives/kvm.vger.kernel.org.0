Return-Path: <kvm+bounces-49676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1712ADC26B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 08:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5C683A6387
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C7028B7CC;
	Tue, 17 Jun 2025 06:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XrlaU6EX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A712116E9
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 06:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750142012; cv=none; b=ieT1LpVQsIierjdba/IZW3uuG0h0cyQ7Mv6qPtGN8DAh1/7EByPndN/zSlCCaoJ+QhJ6tQi5ixQPpUoCHa0f1VXZdNJA291gK/vqOLb/1dr0RjYoiyZAIPCzheKAMJKf063SGXlurY1HDBwq1CjCCuazt0M6HhHBfAtZjWONueE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750142012; c=relaxed/simple;
	bh=3fsG34tLQanptNPLfPigyxtSfCfes2V7D21oxBXw+0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cAZn4Zk7kHgV1SpSHbBuPk3daq0mmwk9M3gGInNM21JtjkcVLBrRAoW6BT9rEEtNp9Y5T0AWO49WqhIy2NiMHvZYbPJVo6wzU8PggJZjoaP8pK4ogc8x618NObPdN8JpKbjz7xDxnqXouansItsw2z3Q+I6G3QKdjzx9z/W37YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XrlaU6EX; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750142011; x=1781678011;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3fsG34tLQanptNPLfPigyxtSfCfes2V7D21oxBXw+0k=;
  b=XrlaU6EXEZIL9i4pUbXmLN9VafCtHWenF2DWZU5ChY3v/Nej1jbJmbym
   UYgmuQVmOY3UeF0ZNljL/I0wNKZBrWLyKt7T2blZcvxulPHDLWjCVlJsR
   YgTmgfc5B4FKFENetRNtBfL4ATU++cbRl56mSu/izC/9YJHABpxYO5VDB
   EZkueHI+Oh1pPQs0loyg+IAT9cx2XlaOBWf/slP214/H/7hGrFMN6w6WQ
   w0VCWd9zrPkAAl1wd/yvWEA8YFz+ZS9V3g4ZPWueVkPYjEpaTnWy9hyce
   iqpp4L9CuI+7v3rRC4mQ4t1DNomZ2tzssQcr0UlEFRJWgx11DvMiryKts
   A==;
X-CSE-ConnectionGUID: ILhMVszPTcSoqZtbNSOkvA==
X-CSE-MsgGUID: 4hS9tuiaTcyvwyGPd+AfZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="51526299"
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="51526299"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 23:33:30 -0700
X-CSE-ConnectionGUID: 2lQFbpAMRk2pBvQc6CJIOQ==
X-CSE-MsgGUID: zIK50yEnTCyvAK5VdqNidg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="148673904"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 16 Jun 2025 23:33:22 -0700
Date: Tue, 17 Jun 2025 14:54:40 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Peter Krempa <pkrempa@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	qemu-devel@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?utf-8?B?Q2zvv71tZW50?= Mathieu --Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?utf-8?B?TWFyYy1BbmRy77+9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>, devel@lists.libvirt.org
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Message-ID: <aFERMEuJsTTJ4tuY@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250513132338.4089736b@imammedo.users.ipa.redhat.com>
 <20250530073524-mutt-send-email-mst@kernel.org>
 <aDmfuVLXmfvJB0tX@angien.pipo.sk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDmfuVLXmfvJB0tX@angien.pipo.sk>

Hi Peter,

> Finally there's
> 
>  DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
> 
> which is exposed to the users via cache mode setting of cpu:
> 
> https://www.libvirt.org/formatdomain.html#cpu-model-and-topology
> 
> look for 'cache'.

I found this link doesn't mention "l3-cache", but it appears in
libvirt's src/qemu/qemu_command.c.

> Thus from libvirt's side 'page-per-vq' and 'l3-cache' will likely require
> deprecation period. The rest except for CPU is fine to remove without
> anything at least from our PoV.

So I understand that the file qemu_command.c contains all the QEMU
commands/properties/options used by libvirt, thereby in the future if
one wants to remove other properties, he can just check that file,
right?

Thanks,
Zhao


