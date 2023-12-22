Return-Path: <kvm+bounces-5108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD0481C34C
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 04:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F29F285E7A
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 03:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0149817C7;
	Fri, 22 Dec 2023 03:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhDqtbTW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A54ECA
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 03:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703214862; x=1734750862;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d2EjJbX4nUgOeAWakANi9riMAhtsVG2bAgGIXFasRSk=;
  b=nhDqtbTWs8QUiUKaSi+LAy+lZX1A3p3jueNGuW0jlb5zSmNVqaeI1kYG
   mstCNjXQt7KDxz5ayR7lcCwjBCFSMdN5Aj19cgHLlwOLrlcIEIZMEq8qX
   naxnbciw+zV8F3+bwdaWqz8pLKMpeAlMrZpq8Ckbfkc2pqy2LcAuxqTUI
   TLMT2q1arlCfr/wozEFV+SiiXm1hkvjK1lwmAS+NDoy3TTuFvpS3bHyRT
   tpirotlhNFuodXiMHPeOYHrjQbgwr+MQHwBMGBst307d4qnbbTSEpXRXn
   oX9JgluzR5tHBA31GfelAMTZQPENIYtBC5/wT5GlbTS2leDilLjVksc5F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10931"; a="3156962"
X-IronPort-AV: E=Sophos;i="6.04,294,1695711600"; 
   d="scan'208";a="3156962"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 19:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,294,1695711600"; 
   d="scan'208";a="18572185"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 19:14:15 -0800
Message-ID: <5314df8a-4173-46cb-bc7e-984c6b543555@intel.com>
Date: Fri, 22 Dec 2023 11:14:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 52/70] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
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
 <20231115071519.2864957-53-xiaoyao.li@intel.com>
 <ZYQb_P6eHokUz9Hh@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZYQb_P6eHokUz9Hh@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/21/2023 7:05 PM, Daniel P. Berrangé wrote:
> On Wed, Nov 15, 2023 at 02:15:01AM -0500, Xiaoyao Li wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> For GetQuote, delegate a request to Quote Generation Service.
>> Add property "quote-generation-socket" to tdx-guest, whihc is a property
>> of type SocketAddress to specify Quote Generation Service(QGS).
>>
>> On request, connect to the QGS, read request buffer from shared guest
>> memory, send the request buffer to the server and store the response
>> into shared guest memory and notify TD guest by interrupt.
>>
>> command line example:
>>    qemu-system-x86_64 \
>>      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
> 
> Here you're illustrating a VSOCK address.  IIUC, both the 'qgs'
> daemon and QEMU will be running in the host. Why would they need
> to be using VSOCK, as opposed to a regular UNIX socket connection ?
> 

We use vsock here because the QGS server we used for testing exposes the 
vsock socket.

I will add more examples in next version to show that any socket type is 
supported.


