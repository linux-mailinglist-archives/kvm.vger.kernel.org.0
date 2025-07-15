Return-Path: <kvm+bounces-52520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0EDB0636F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E62CA7B32E3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E9624337B;
	Tue, 15 Jul 2025 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gUZqcrDX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3526613AA2D
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752594574; cv=none; b=hMrVhtR1eEHoKUkbzQlBJv6Mz7Vy7SD27WUneVQ8v8PKubNb9cL4eob2hEbeANSHihM/YalVTaIQJx73NphOavOEJ5ngL381gBFdiqZTlilt3QjAjNZMT06m2zN/9RJngmeOXlVgyj6X3dk+t01K8OSKDHgwOQHMFld/Tx2G0ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752594574; c=relaxed/simple;
	bh=veMFIWHdLmA4/F9ZMKI+D1ofItmipjfFlTW6juyeL4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ote71I+JhBgdY+p7quoKshDuHVv0qgMaBJ3bh+ZpLmirMFQjiApr32TropWKeLPxzx+jQC7XGxdPtKUjLQFTnRBRq8H5oLMt8GEt5lLLFaJRAT6X+zk4pSN3rEhnxzMA0WdjBwtE3zlfTBBVlpjUIW00SgXDCTSuYfYGuDTnS+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gUZqcrDX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752594572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EaaynNbXAbeJEzd/3fYvfFQk34QQXdyB/l9XIDKEMdY=;
	b=gUZqcrDXrSmZ4qwUnksNXe/4LyEwsvuvpCFkOoSyxNqSBQ4PCzYIaJT00OhUtXO0m4opC7
	FEPe/wKm7m1cD19odka7LZBMQeLCR0wXJlxNBn/5jRm3JKz2TYyczm8/hzcUnZKsZ7OEeS
	uJk5JGfWO2EMI+Kx9xcsz8mAGKyZJag=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-qf1hp2ovNXGq5tjm497xpQ-1; Tue, 15 Jul 2025 11:49:28 -0400
X-MC-Unique: qf1hp2ovNXGq5tjm497xpQ-1
X-Mimecast-MFC-AGG-ID: qf1hp2ovNXGq5tjm497xpQ_1752594568
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso4300507f8f.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 08:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752594567; x=1753199367;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EaaynNbXAbeJEzd/3fYvfFQk34QQXdyB/l9XIDKEMdY=;
        b=Ub3Ftb6kmPK+2fCy17ffch+9MCoGYHX3TL8xnn9Rli/tnMLYDan9Wo0z9azmQcD6k8
         cuGBrJZXqZAemJI3SYhMHuSd10NDWaC+MzPTzMcoe8F5qFSPHwc/Amq1fWtRJKA+gPdx
         ILfoS+ELbtFH4ttBWIcTvwHDdoA1vQHIClnO1g8psr0NwyhfLkUkmG1BQvYfwxjWCD/F
         lApaJzbFCyRB0K09VvcDlmF70TCCvhA5wdSncfhACiQOhdVPo2okOU6kl2JBnjV5z9Vf
         OOSYNPuPVWIsYmJGProP0hNJ8tjCUjOnPqgeWR1X4ufTCJIJ8Y4gfdoCkIQJ6GjILcBW
         vclg==
X-Forwarded-Encrypted: i=1; AJvYcCXtMTInXd3hAdikIJeOaCGiYAv4HauXX3tNzmdml04BNd6aXysnu0urod+VD9LDBImP2mI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzrUwQbCT9e8TxCkzhokmmZXGlcwiyVXyvVxT7X6BU+v1n4S2M
	NvAqIKIcouddtAmiPpi486jZcULRqxhi/eSwJys9js419XmVH1552xnvyD0RJTdnMKN/4c43F/u
	Xl7GQsvIrukWJR4m9UVPuGvENfJ5UocyVGoTkq1JvIU09eXWHXvEyjQ==
X-Gm-Gg: ASbGncvvNhIEJLq7WgoWFC3EpBwdDgjgRnWzmfgWKUFD4+zWkMlY/XfLdtBJ7s8vESb
	e7HVDyZCeiGxlvVIjJdEQapAJydSm7n1xWclh05y9UXO+Ql6dWDQylZV3c8J+NixiKV30asxBTD
	jkQv2lbW3Oj7Z+mcIg3QhTM94cdHOJ2jScwQSB5R5iRTP9PByb3qAMRa68u7Em/gpwAVhaDM7w7
	hEOiSrSXminzOvew8E3HOxBXUcJ984lOY3n2UWdolqnEljLv38tMmonlD+hcIJlkG1DP7IsLQQs
	BIuToRsOogH6gkHVq2lORyxs7ZMbxA8wB6uK/RI/et/TAk5uETUOy88q40IcqEirb8siY9mBg7B
	KylZtLG50mjE=
X-Received: by 2002:a05:6000:230e:b0:3b5:e6f2:9117 with SMTP id ffacd0b85a97d-3b5f2e3083dmr14052945f8f.39.1752594567542;
        Tue, 15 Jul 2025 08:49:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF98qDkBB2TTtzIKKvxQc3djL0N5JfUyVilZbHF8FYISQjuvrvFyi7KXBenNz4gs7duy977fg==
X-Received: by 2002:a05:6000:230e:b0:3b5:e6f2:9117 with SMTP id ffacd0b85a97d-3b5f2e3083dmr14052923f8f.39.1752594567106;
        Tue, 15 Jul 2025 08:49:27 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e0d758sm15119598f8f.49.2025.07.15.08.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 08:49:26 -0700 (PDT)
Message-ID: <e6626fe6-c66c-4b16-93e4-447e43379424@redhat.com>
Date: Tue, 15 Jul 2025 17:49:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 12/13] net: implement tunnel probing
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Dmitry Fleytman <dmitry.fleytman@gmail.com>, Jason Wang
 <jasowang@redhat.com>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Luigi Rizzo <lrizzo@google.com>, Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>, Vincenzo Maffione <v.maffione@gmail.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <94ffdec876d61f22a90e63d6a79ff5517d1c727c.1752229731.git.pabeni@redhat.com>
 <93de161a-3867-46aa-bfc0-2da951981bcf@rsg.ci.i.u-tokyo.ac.jp>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <93de161a-3867-46aa-bfc0-2da951981bcf@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 10:05 AM, Akihiko Odaki wrote:
> On 2025/07/11 22:02, Paolo Abeni wrote:
>> diff --git a/net/tap-bsd.c b/net/tap-bsd.c
>> index 86b6edee94..e7de0672f4 100644
>> --- a/net/tap-bsd.c
>> +++ b/net/tap-bsd.c
>> @@ -217,6 +217,11 @@ int tap_probe_has_uso(int fd)
>>       return 0;
>>   }
>>   
>> +int tap_probe_has_tunnel(int fd)
> 
> This should return bool for consistency.

Some inconsistency will persist, as others bsd helpers supposed to
return a bool currently return an int. I tried to be consistent with the
surrounding code, but no strong objections.

/P


