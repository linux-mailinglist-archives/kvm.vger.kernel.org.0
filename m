Return-Path: <kvm+bounces-19645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD657908072
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 03:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5CDF1C21211
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 01:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1B82107;
	Fri, 14 Jun 2024 01:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J3eE0NDj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086B7163
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 01:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718326968; cv=none; b=i5YiH4UAJGKaSpgnFdxv1B7OEFmhEVIt2FWsyuITJoKqKhhW3ilAkIM+Ue5TsrjRqSxjMDo95YFT9fCIunRj6N9ROocf4mh5YYzUcpAoah0NCDKuIvnPz26cyaS4xjPhk1SeeC7WwunXwmtH0Okfi9aQ6906FvfPSLHqJKw1Egw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718326968; c=relaxed/simple;
	bh=tFRlYn2K3HB7GCAI89e1+dbTZ6mOUkfUgxVIHYjH+XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TYayKCqB3HiiDOX1FfBPUQ1gso5SaVl5eBLuL26IcLlxlxUPty2GvUAg87gL3DDJyaNJUEaR3VicslwVGd5SKHaRIgyBtXigAwWVcnd9sI1VVO9/9/5HibQ3mo31xdJ85emZaRRuuWINpkNdZoOc2s0nSvqiEvEwhvfFO/Pj7z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J3eE0NDj; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718326967; x=1749862967;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tFRlYn2K3HB7GCAI89e1+dbTZ6mOUkfUgxVIHYjH+XU=;
  b=J3eE0NDjZE7ZKst9TSwxZBOyUnwRp9M0t+iIR+VSSlEvcS+uBXY/l5KS
   R58daeAnlhfU+gvmoZf1t2U6flIT188kwuZX0eEt672jKfaXXI7/L7V1a
   KhGkNwib/+z7Vuef3krjCF+QvLr2wbAbaiEojoW6oAth2zDlpV54ImOQE
   40S85MdgS85TUykOpiPGavkW7u6MnLsavw4f3/H45C8sSopYnh2fJvicR
   w90YwoJF1YCz7fUGi5YXUU3nzDCoSssEZ1gm7hAL1SaMPPaj39gkmiIaW
   Osuhv9cLH1vIz7g40lmKr/Valo+hm9etEi8eXHeVDOsJtD1/yVbm/xhxz
   g==;
X-CSE-ConnectionGUID: QCo6o32iRwaXXt1if/sFag==
X-CSE-MsgGUID: Ydo9u3saSuaLmNzasn6btQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="15031202"
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="15031202"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 18:02:47 -0700
X-CSE-ConnectionGUID: JQOMG1KcRJCFrkc821OyIw==
X-CSE-MsgGUID: ZL1yDBfUSwSK4I0y1Idc5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="40446982"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 18:02:39 -0700
Message-ID: <df0a17b0-16a8-44bf-8862-551b81d93cac@intel.com>
Date: Fri, 14 Jun 2024 09:02:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/65] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
To: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, "Qiang, Chenyi" <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-18-xiaoyao.li@intel.com>
 <511a147e-bc01-7fab-24d7-4ae66a6d1c44@intel.com>
 <04932fb5-1ab4-4f8e-90dc-4f1a71feefb6@intel.com>
 <SJ0PR11MB67447DFF37D0F1A0EF25F6A192C12@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <SJ0PR11MB67447DFF37D0F1A0EF25F6A192C12@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/13/2024 4:26 PM, Duan, Zhenzhong wrote:
>>>> +     *
>>>> +     * It also has side effect to enable unsupported bits, e.g., the
>>>> +     * bits of "fixed0" type while present natively. It's safe because
>>>> +     * the unsupported bits will be masked off by .fixed0 later.
>>>> +     */
>>>> +    *ret |= host_cpuid_reg(function, index, reg);
>>> Looks KVM capabilities are merged with native bits, is this intentional?
>> yes, if we change the order, it would be more clear for you I guess.
>>
>> 	host_cpuid_reg() | kvm_capabilities
>>
>> The base is host's native value, while any bit that absent from native
>> but KVM can emulate is also added to base.
> Imagine there is a 'type native' bit that's absent from native but KVM emulated,
> With above code we pass 1 to tdx module but it wants native 0, is it an issue?

yes, it will have issue but it's not "we pass 1 to tdx_module".

"Native" bit is not configurable in the view of TDX module, and QEMU/KVM 
cannot configure it. But it does causes mismatch in above case that QEMU 
sees the bit is supported while in the TD the bit is not supported.

This is one of the reason why we are going to drop the solution that 
QEMU maintains the CPUID configurability in this series.

