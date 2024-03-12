Return-Path: <kvm+bounces-11646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37121878F24
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 08:44:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6593282BCB
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 07:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5533A69962;
	Tue, 12 Mar 2024 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BKHyf9J3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722663236
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 07:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710229483; cv=none; b=aTgvHmsyBrcs4ke6c8QK7YNSro4qwxZ1QcX8jo+ZX8TyQD2IQMH7VknDekS+HbPAmEgYYyIzrIzuZ4vGyTKt+OHLsmPcGz3oMeCHVOVn3dFPmPmKZ96NfCUf8ZzDVCBsAwCCHQglHZD7/xcLAwry2f6jh/jKb6ySMqseOp/uTYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710229483; c=relaxed/simple;
	bh=ITHHng38MZjgwsFAiVPoxSwyDU+9QQOdTagp+LPjzog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mnKI4GCOJWRhqp0vgHh9A800XbNvgVgupvpFF49U9PSiOzHBQnmMk8SeCZ3hIuqSigGUWTDh8QVE9/1VNrX/cVe8PdQaBOqfkFzTEoNOHgORS4jKLYHDNQnu93jGJ1cAHjGN4Fq226fY1OelMgz+p/N1MdkGhDk7bZI3aXrV1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BKHyf9J3; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710229481; x=1741765481;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ITHHng38MZjgwsFAiVPoxSwyDU+9QQOdTagp+LPjzog=;
  b=BKHyf9J3VcrrlaAxVEd5UTXxXO7i9lqciPN8BJ4MM8jEZPF8WwW/yS8q
   dbyovMU8VpTjePrDRvTnKkH6+TNfJ44wA4Qni24D1k6Yv8dGgL2oNLqtS
   hOhvRKIE/wfOOCj7N2BoAjNBtA1bAk9BPi83irRfgpKvqCv124GCCFbIj
   a3VacN9zJehVS+fu7DXPdLJYQRORja4tlTactfLAWju5TlMr3ObBABxzv
   pthfd9a+Vha13uKairc4jNbyli0EnUP3Lo5E9Eb6X2PYMQcRXocIG2g4Y
   Jo+BPCX8fX8/k50JgGK+4wSKp7buY9gja6ham6LuNLQQDPP2+AsTUcnTi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5059745"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="5059745"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 00:44:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="16139002"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 00:44:36 -0700
Message-ID: <0f5e1559-bd65-4f3b-bd7a-b166f53dce38@intel.com>
Date: Tue, 12 Mar 2024 15:44:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com> <Ze7Ojzty99AbShE3@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Ze7Ojzty99AbShE3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/11/2024 5:27 PM, Daniel P. Berrangé wrote:
> On Thu, Feb 29, 2024 at 01:37:10AM -0500, Xiaoyao Li wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Add property "quote-generation-socket" to tdx-guest, which is a property
>> of type SocketAddress to specify Quote Generation Service(QGS).
>>
>> On request of GetQuote, it connects to the QGS socket, read request
>> data from shared guest memory, send the request data to the QGS,
>> and store the response into shared guest memory, at last notify
>> TD guest by interrupt.
>>
>> command line example:
>>    qemu-system-x86_64 \
>>      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
> 
> Can you illustrate this with 'unix' sockets, not 'vsock'.

Are you suggesting only updating the commit message to an example of 
unix socket? Or you want the code to test with some unix socket QGS?

(It seems the QGS I got for testing, only supports vsock socket. Because 
at the time when it got developed, it was supposed to communicate with 
drivers inside TD guest directly not via VMM (KVM+QEMU). Anyway, I will 
talk to internal folks to see if any plan to support unix socket.)

> It makes no conceptual sense to be using vsock for two
> processes on the host to be using vsock to talk to
> each other. vsock is only needed for the guest to talk
> to the host.
> 
>>      -machine confidential-guest-support=tdx0
>>
>> Note, above example uses vsock type socket because the QGS we used
>> implements the vsock socket. It can be other types, like UNIX socket,
>> which depends on the implementation of QGS.
>>
>> To avoid no response from QGS server, setup a timer for the transaction.
>> If timeout, make it an error and interrupt guest. Define the threshold of
>> time to 30s at present, maybe change to other value if not appropriate.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v5:
>> - add more decription of quote-generation-socket property;
>>
>> Changes in v4:
>> - merge next patch "i386/tdx: setup a timer for the qio channel";
>>
>> Changes in v3:
>> - rename property "quote-generation-service" to "quote-generation-socket";
>> - change the type of "quote-generation-socket" from str to
>>    SocketAddress;
>> - squash next patch into this one;
>> ---
>>   qapi/qom.json                         |   8 +-
>>   target/i386/kvm/meson.build           |   2 +-
>>   target/i386/kvm/tdx-quote-generator.c | 170 ++++++++++++++++++++
>>   target/i386/kvm/tdx-quote-generator.h |  95 +++++++++++
>>   target/i386/kvm/tdx.c                 | 216 ++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h                 |   6 +
>>   6 files changed, 495 insertions(+), 2 deletions(-)
>>   create mode 100644 target/i386/kvm/tdx-quote-generator.c
>>   create mode 100644 target/i386/kvm/tdx-quote-generator.h
> 
> 
> With regards,
> Daniel


