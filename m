Return-Path: <kvm+bounces-46172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E37AB3959
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 15:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E811518860E1
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 13:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C7F2949FC;
	Mon, 12 May 2025 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bK3Zssgc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C815674E
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 13:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056799; cv=none; b=E/BGggOkYnabRfAlv3SPHYoxddTre/zuMG3rsxnsnan1jCDdus1Am0NVw/xPvHWnufi6ER0KPPKjj89H60aF3DdcNUlCkg5BudUuT+x0AlLFSSYOcU5OFgiBztfcTbXb1FdE2TWhAEuplGxUwBbt/9WO0rEN2kMbADsp0rzPLdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056799; c=relaxed/simple;
	bh=F7j3cep47puNwkdI95QJzzsEY4MpzPeMA6iUkercExs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SyP/C+1onJbPX6BSedKyfjT3CJ3PWZkUVl30taJjjxT4tdohCx2qlYr04WVqlihUA4WNbNlXYF5BUOInWXq9nzey2hBK2QZCIcFREtg8rgoBe9NJUxgECydW+7LxE62Q+WVJSkxLKgGvjYSp57QhPzl79AI4wR+FGAbsWxVKekg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bK3Zssgc; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747056798; x=1778592798;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F7j3cep47puNwkdI95QJzzsEY4MpzPeMA6iUkercExs=;
  b=bK3Zssgc8WQxXhhFAFnh/xeAjzQGldHBH+/xhMISnk6ai2quRCGgoo1X
   c6Z3il0ahMADTlz0DJQrQHGT/dUtPrEMm9vTHqp6LdDODzMVKPdnM4JqB
   tYFfh4+K7Ad7DbaMU/TJ3ROYgKooOzjPSC1pNU2CC3I89AIByq7Zehv7Q
   Tqqso0/02s90HM2IRRk0Iok23Vjl/HzyeV+HwDXIoFC7LYctbM/PnUFJK
   zxF1OvPC0j5quUYR7l2x2hk7C3yQcEHQw1wz3Hqaq9IKgq6bsX6rWOeei
   GiNMOVBrcuOOsluTAxDHdVlveBhpTmDWIU437CnD6vCZkkVdJuGuivWJy
   g==;
X-CSE-ConnectionGUID: XRLwSzvTS6O4NveA5shidg==
X-CSE-MsgGUID: JKwYrNWdTGGlpxaW1l5naA==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="47960751"
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="47960751"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 06:33:17 -0700
X-CSE-ConnectionGUID: 8a8HyKboSVah4ASvPQPnYQ==
X-CSE-MsgGUID: zzCrsy+8RXOjD7uwBo8uaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="137081420"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 06:33:10 -0700
Message-ID: <e5a305cc-4c8b-48df-99fe-539ebd9b72f9@intel.com>
Date: Mon, 12 May 2025 21:33:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to mark internal properties
To: Markus Armbruster <armbru@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Yi Liu <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
 Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
 Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
 Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Jason Wang <jasowang@redhat.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-13-philmd@linaro.org>
 <23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com> <aB2vjuT07EuO6JSQ@intel.com>
 <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
 <CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com>
 <aCG6MuDLrQpoTqpg@redhat.com> <87jz6mqeu5.fsf@pond.sub.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87jz6mqeu5.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/12/2025 6:54 PM, Markus Armbruster wrote:
> Daniel P. Berrangé<berrange@redhat.com> writes:
> 
>> On Mon, May 12, 2025 at 09:46:30AM +0100, Peter Maydell wrote:
>>> On Fri, 9 May 2025 at 11:04, Thomas Huth<thuth@redhat.com> wrote:
>>>> Thanks for your clarifications, Zhao! But I think this shows again the
>>>> problem that we have hit a couple of times in the past already: Properties
>>>> are currently used for both, config knobs for the users and internal
>>>> switches for configuration of the machine. We lack a proper way to say "this
>>>> property is usable for the user" and "this property is meant for internal
>>>> configuration only".
>>>>
>>>> I wonder whether we could maybe come up with a naming scheme to better
>>>> distinguish the two sets, e.g. by using a prefix similar to the "x-" prefix
>>>> for experimental properties? We could e.g. say that all properties starting
>>>> with a "q-" are meant for QEMU-internal configuration only or something
>>>> similar (and maybe even hide those from the default help output when running
>>>> "-device xyz,help" ?)? Anybody any opinions or better ideas on this?
>>> I think a q-prefix is potentially a bit clunky unless we also have
>>> infrastructure to say eg DEFINE_INTERNAL_PROP_BOOL("foo", ...)
>>> and have it auto-add the prefix, and to have the C APIs for
>>> setting properties search for both "foo" and "q-foo" so you
>>> don't have to write qdev_prop_set_bit(dev, "q-foo", ...).

> If we make intent explicit with DEFINE_INTERNAL_PROP_FOO(), is repeating
> intent in the name useful?

+1 for DEFINE_INTERNAL_PROP_FOO(). I have the same thought.

We need something in code to restrict the *internal* property really 
internal, i.e., not user settable. What the name of the property is 
doesn't matter.

