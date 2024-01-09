Return-Path: <kvm+bounces-5864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D35827E61
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 06:38:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D63AA1F246CE
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 05:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB2D6D6FA;
	Tue,  9 Jan 2024 05:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TSxz0WXb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A6BEB8
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 05:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704778709; x=1736314709;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XrUn2EeNuhQURB9JbWxsm1XG8XAZDv9HlyO2tI0QvME=;
  b=TSxz0WXbwincbhrx0wZpdg6o1XvrLkF4o4drNVHNXIT0DCXF0q89SOub
   U45HgdMsYlcq7yzgn2YZ6EnKvGKaybKN81+8ufzykj5WGlsFBiBcE8uh0
   8FA13j94wLWYSMu6DPoxDy6KScK3Yd0RK6Fg+bvvGFBOs4RZPNHu+Boi4
   m/CbcV1L5aAkghBE7MICZRCT48a+lobDtTA+oXiJOkOA9E9lEd3Ebkl8P
   v8+SE+kkSKamOQ0AchgAs+94LGRCvlLzgCAhmYxWTH9QLO4uQRVxLLeR1
   jUELomyx/3cCdJII9Mhsewxn8knicrFGIpPoYIOlOqis98ty8nbtgs/3/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="4848052"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="4848052"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 21:38:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="781664636"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="781664636"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 21:38:22 -0800
Message-ID: <62b421de-33d2-4c2f-81a3-4b5a0abb64c5@intel.com>
Date: Tue, 9 Jan 2024 13:38:19 +0800
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
 <ZVUGtpZDTW27F8Um@redhat.com>
 <db4330cf-d25a-48d3-b681-cf2326c16912@intel.com>
 <ZZwKPH3fVHo9EyBy@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZZwKPH3fVHo9EyBy@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/8/2024 10:44 PM, Daniel P. Berrangé wrote:
> On Fri, Dec 29, 2023 at 10:30:15AM +0800, Xiaoyao Li wrote:
>> On 11/16/2023 1:58 AM, Daniel P. Berrangé wrote:
>>> On Wed, Nov 15, 2023 at 02:15:01AM -0500, Xiaoyao Li wrote:
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> For GetQuote, delegate a request to Quote Generation Service.
>>>> Add property "quote-generation-socket" to tdx-guest, whihc is a property
>>>> of type SocketAddress to specify Quote Generation Service(QGS).
>>>>
>>>> On request, connect to the QGS, read request buffer from shared guest
>>>> memory, send the request buffer to the server and store the response
>>>> into shared guest memory and notify TD guest by interrupt.
>>>>
>>>> command line example:
>>>>     qemu-system-x86_64 \
>>>>       -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
>>>>       -machine confidential-guest-support=tdx0
>>>>
>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>> Changes in v3:
>>>> - rename property "quote-generation-service" to "quote-generation-socket";
>>>> - change the type of "quote-generation-socket" from str to
>>>>     SocketAddress;
>>>> - squash next patch into this one;
>>>> ---
>>>>    qapi/qom.json         |   5 +-
>>>>    target/i386/kvm/tdx.c | 430 ++++++++++++++++++++++++++++++++++++++++++
>>>>    target/i386/kvm/tdx.h |   6 +
>>>>    3 files changed, 440 insertions(+), 1 deletion(-)
>>>>
>>>> +static void tdx_handle_get_quote_connected(QIOTask *task, gpointer opaque)
>>>> +{
>>>> +    struct tdx_get_quote_task *t = opaque;
>>>> +    Error *err = NULL;
>>>> +    char *in_data = NULL;
>>>> +    MachineState *ms;
>>>> +    TdxGuest *tdx;
>>>> +
>>>> +    t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
>>>> +    if (qio_task_propagate_error(task, NULL)) {
>>>> +        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
>>>> +        goto error;
>>>> +    }
>>>> +
>>>> +    in_data = g_malloc(le32_to_cpu(t->hdr.in_len));
>>>> +    if (!in_data) {
>>>> +        goto error;
>>>> +    }
>>>> +
>>>> +    if (address_space_read(&address_space_memory, t->gpa + sizeof(t->hdr),
>>>> +                           MEMTXATTRS_UNSPECIFIED, in_data,
>>>> +                           le32_to_cpu(t->hdr.in_len)) != MEMTX_OK) {
>>>> +        goto error;
>>>> +    }
>>>> +
>>>> +    qio_channel_set_blocking(QIO_CHANNEL(t->ioc), false, NULL);
>>>
>>> You've set the channel to non-blocking, but....
>>>
>>>> +
>>>> +    if (qio_channel_write_all(QIO_CHANNEL(t->ioc), in_data,
>>>> +                              le32_to_cpu(t->hdr.in_len), &err) ||
>>>> +        err) {
>>>
>>> ...this method will block execution of this thread, by either
>>> sleeping in poll() or doing a coroutine yield.
>>>
>>> I don't think this is in coroutine context, so presumably this
>>> is just blocking.  So what was the point in marking the channel
>>> non-blocking ?
>>
>> Hi Dainel,
>>
>> First of all, I'm not good at socket or qio channel thing. Please correct me
>> and teach me when I'm wrong.
>>
>> I'm not the author of this patch. My understanding is that, set it to
>> non-blocking is for the qio_channel_write_all() to proceed immediately?
> 
> The '_all' suffixed methods are implemented such that they will
> sleep in poll(), or a coroutine yield when seeing EAGAIN.
> 
>> If set non-blocking is not needed, I can remove it.
>>
>>> You are setting up a background watch to wait for the reply
>>> so we don't block this thread, so you seem to want non-blocking
>>> behaviour.
>>
>> Both sending and receiving are in a new thread created by
>> qio_channel_socket_connect_async(). So I think both of then can be blocking
>> and don't need to be in another background thread.
>>
>> what's your suggestion on it? Make both sending and receiving blocking or
>> non-blocking?
> 
> I think the code /should/ be non-blocking, which would mean
> using   qio_channel_write, instead of qio_channel_write_all,
> and using a .

I see. will implement in the next version.

> With regards,
> Daniel


