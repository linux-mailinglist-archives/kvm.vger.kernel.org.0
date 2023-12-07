Return-Path: <kvm+bounces-3816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E4768081B9
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52FE0282FE8
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16034171C6;
	Thu,  7 Dec 2023 07:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="amT1WL5B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4906A1AD
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 23:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701933507; x=1733469507;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f+yxBhPM4CtYSl3dlXRi4+On6xfe/pMPniP+d87c89Q=;
  b=amT1WL5BoyX5uRPF8VfwfoXkJgakZ/01LMaJ9FZ1YT7wkHjkQ5XlWx+C
   zmWVdZkuNVuTNi6DPHFv2j3LzadqvCz6JzauN856W6lcfbBxXRcb7tEVO
   Hb/Q76B0GOZx9QZOBinyZ3PVeV6lkljLOhMo+Qwyif6saBviwFJ0KS8dr
   grz94yZ+ytYVfmegsLlfB/OK8qKAoaJ3corgDobgDbefGGUUqv0cp72zB
   z6MA38JZDvWuWEiBmXIZ05NTkBPA+CyAaHZoUdNnqCXL0IDyZAaeKhM7u
   g2nE8wpkCBV74V7KCYgGUTuVNdXx4mXcfbdo3tpgO4czijvuc7Iw2ZxP+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="393059198"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="393059198"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:18:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="944933801"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="944933801"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:18:19 -0800
Message-ID: <f1848765-0247-4f58-8dd6-e69a99a0644c@intel.com>
Date: Thu, 7 Dec 2023 15:18:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/70] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
 Sean Christopherson <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-19-xiaoyao.li@intel.com>
 <ZVSjWxI6c1qt3X9M@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZVSjWxI6c1qt3X9M@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/15/2023 6:54 PM, Daniel P. Berrangé wrote:
>> +static int tdx_ioctl_internal(void *state, enum tdx_ioctl_level level, int cmd_id,
>> +                        __u32 flags, void *data)
>> +{
>> +    struct kvm_tdx_cmd tdx_cmd;
> Add   ' = {}'  to initialize to all-zeros, avoiding the explicit
> memset call

thanks for the suggestion. Will do it in the next version.

