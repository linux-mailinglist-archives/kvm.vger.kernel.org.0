Return-Path: <kvm+bounces-47319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4800AC0088
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 01:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F12F81BA362B
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 23:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F7F23C51A;
	Wed, 21 May 2025 23:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="WJBv9E4h"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F3A22F77F
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 23:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747869464; cv=none; b=t+ecdd2TRIv4h0vxAjgyRnAm2A9xFG9pghgNWH35qfjz00+DJesd8vgfPGJl0yD7T2vd+nt7JBD8SCNGOJWBbjXq5xJc0dsRc4P86xQ+w+GJXThKDGsCYiBxicqKdnpywEcnPFcr3GaFCD3ivmjTeSMJ7z/YhWZBaGRNeXoWsS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747869464; c=relaxed/simple;
	bh=XD4kuLxj1fx4ZHbQefTh9vvwweTOThXfuO8z55u63YM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=XlioZDGp621epf/U+iz5Hjw9JHtGuG2PEr5bIUq55T6Xt53Sp9bPEbRyxsG433neGMdOPXlmHoTMJlPW4TAGSwKAlL8UWZSi/fPrIojc25sZrzJCQc4HcMCFhwOT5jHasCigeTqLJKYUgaW2OtGe07OGOT/xDqw+j6wgg79Cw8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=WJBv9E4h; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHsgn-004IhV-Ne; Thu, 22 May 2025 01:17:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=9nCmsaQp2owCm1/M2mf/Yw6FBV7gBVkunZx8ik/qseA=; b=WJBv9E4hKmylS07aHF/YU+FbuP
	8ehnptW1MXqqeUfL87/y/krTUGmwoTEgALVRs41FreeuoePdkBy/9XVeiiBUE21Hpsozl9wrMRh2+
	tsYsrQPF+05JkesmYLwTo+S/NtupSL/BfIYw89hINZ3hs4Zsgd4tVO28lDMbcKHIcCucZWC0q5IEE
	MXXaATM8nIfce8kjNrT8evopyeMiMT51s3iJ6/9t1n6S23xMdhk/qM0IJh1iuQQ+7htADC64IiSXu
	AvKKOWeVCdtaynQhkajR+MZ9P/CI95KH0lwIYOSdRd8SSDTjDMGcnTro0ioEnImCTbYbBY2DNypdO
	ji8AHLZQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHsgm-0006E7-Hp; Thu, 22 May 2025 01:17:32 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHsgl-000gSv-IM; Thu, 22 May 2025 01:17:31 +0200
Message-ID: <5dc16a14-e66c-4e1d-896f-a8483cdf0f04@rbox.co>
Date: Thu, 22 May 2025 01:17:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH net-next v5 5/5] vsock/test: Add test for an unexpectedly
 lingering close()
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
 <20250521-vsock-linger-v5-5-94827860d1d6@rbox.co>
 <edtepfqev6exbkfdnyzgkdkczif5wnn4oz4t5sxkl6sz64kcaf@f6yztxryvmlq>
Content-Language: pl-PL, en-GB
In-Reply-To: <edtepfqev6exbkfdnyzgkdkczif5wnn4oz4t5sxkl6sz64kcaf@f6yztxryvmlq>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/25 16:56, Stefano Garzarella wrote:
> On Wed, May 21, 2025 at 12:55:23AM +0200, Michal Luczaj wrote:
>> There was an issue with SO_LINGER: instead of blocking until all queued
>> messages for the socket have been successfully sent (or the linger timeout
>> has been reached), close() would block until packets were handled by the
>> peer.
>>
>> Add a test to alert on close() lingering when it should not.
>>
>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>> ---
>> tools/testing/vsock/vsock_test.c | 49 ++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 49 insertions(+)
>>
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index f401c6a79495bc7fda97012e5bfeabec7dbfb60a..1040503333cf315e52592c876f2c1809b36fdfdb 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -1839,6 +1839,50 @@ static void test_stream_linger_server(const struct test_opts *opts)
>> 	close(fd);
>> }
>>
>> +static void test_stream_nolinger_client(const struct test_opts *opts)
>> +{
>> +	bool nowait;
>> +	time_t ns;
>> +	int fd;
>> +
>> +	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
>> +	if (fd < 0) {
>> +		perror("connect");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +
>> +	enable_so_linger(fd);
> 
> If we use a parameter for the linger timeout, IMO will be easy to 
> understand this test, defining the timeout in this test, set it and 
> check the value, without defining LINGER_TIMEOUT in util.h.

Yes, you're right. I'll fix that.

>> +	send_byte(fd, 1, 0); /* Left unread to expose incorrect behaviour. */
>> +	nowait = vsock_wait_sent(fd);
>> +
>> +	ns = current_nsec();
>> +	close(fd);
>> +	ns = current_nsec() - ns;
>> +
>> +	if (nowait) {
>> +		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
>> +	} else if ((ns + NSEC_PER_SEC - 1) / NSEC_PER_SEC >= LINGER_TIMEOUT) {
> 
> Should we define a macro for this conversion?
> 
> Or just use DIV_ROUND_UP:

Arrgh, I was looking for that. If you don't care much for a new macro, I'll
explicitly use DIV_ROUND_UP for now.

Thanks!
Michal

