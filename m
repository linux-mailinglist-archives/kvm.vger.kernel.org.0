Return-Path: <kvm+bounces-52519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 086C5B06353
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E56F580D33
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0C5246BA7;
	Tue, 15 Jul 2025 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zry0ZiIl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97117233148
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752594226; cv=none; b=EtClJGgzLtdeZnozB5hB3El/sONDxMbqVGZzECTIZSn5e0mkQbrOOvQSBj38+n5puKwycKoD1WDDCKIdvlbZf2RVoB+7Gp5efY7mJl10pa0V19dKjeiFeDOqTdijM67PtIfnX5mQED9nderYLpD1Kf8FLNrN1AUSt+1GEdTERXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752594226; c=relaxed/simple;
	bh=9u4rXL9f2+7dBf3c7Jm9K1/Cr4gxItdrmBJVUBTQ6Zw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fi8Ka98w+3+y/rumWSVX7NaAtIzc6aVcXmwIKOW+aTe8fuznNh1pqk0rN6QHWj3cCBjYaBxYpZk0L3LKiUVUU4CEOGQ3M59OzxACb6E3OXThiJB61zmdayJOjxh32j1AxjOltmy5ZIJKnq3YfIBeVXY7jYuUqJhhV/g7BGY40c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zry0ZiIl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752594223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVVEV06Cr3MWb3YGwMKwm90D771RfLGEYdYgZysRI0c=;
	b=Zry0ZiIliyJXPKVMcK97kE35C5qhR/WOqfVy1a5554M5Y8dy/12+6Ks7fq3v5jltYDqBTT
	h6ZkCCLuD+MwiMo8oYH62zHur8D2JMIe6hUM0n1PD2uFMVFmAb07ROpm9rXVsNk2c/SU6n
	7I+pNQ1kN9muHiUdVLtAPRf0EF/kN+c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-y-OMMpAAOo-CyucOfYQiPA-1; Tue, 15 Jul 2025 11:43:41 -0400
X-MC-Unique: y-OMMpAAOo-CyucOfYQiPA-1
X-Mimecast-MFC-AGG-ID: y-OMMpAAOo-CyucOfYQiPA_1752594220
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a52bfda108so2757564f8f.3
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 08:43:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752594220; x=1753199020;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EVVEV06Cr3MWb3YGwMKwm90D771RfLGEYdYgZysRI0c=;
        b=r4JNs7VZdDDV9pKd/RMINa9puFyEzi+G+8D6SyWxIXTNRuxt5sYYRW+DtiOCEHMLBh
         6FTmrTA7Nw2gdkNMMDw7IYkcCHef5RcUHUuxnQBAx2Ee80MpDHvCYcCx9sOkVGoKFJrB
         d8O654pL/SjgcewJw+MibUGjq5Mtt5frK7Yhz/X2Q62H/bt1HbHoBDEccmFDRYgcRsZT
         lP4SAJ/ajhjYRV9jYzPL/k+YaEg0K9gSW9KMVy9/zWUzOPVNxxmplb8a4gY3cH2VhV8e
         gC9e6MuLwuteeW0SgYMZT5wbAkQx1pf4n4LyXu4gPcH3pc+B8HHhHMzS6gI0zAeYuUVl
         tBlw==
X-Forwarded-Encrypted: i=1; AJvYcCXAyFALm+SHYpK2Qn7D4aikE9ImdpIBB2qWYTy8fjWXmCtWStTbvJskJMn52GIiPLGU1hE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEa/cpVbrAyHch2WlSbzdrQ78R5CDefPgIpKvRk4Tn4Il2rLfH
	I0SBsfqUjfpF+9eIlvnEXcAB0C3P6275D4WjkfNHYpwOaphYihxfOIoktAV4GU+gGEOZep0FQZj
	4Vr0SmG18f/c4It22qq9Tj2duY5wdRR3dKkxvH+8lys2RRx90ZG8OBA==
X-Gm-Gg: ASbGncsY4U/jCRqg06jOwSosrWX2QZR1Hl8cf9bp7M02hJFyf/YkntcEK3324VvU8yL
	IQawqmjNaJpu6TnApxsIdkT52tLbqVxlLCZJ0bm07F+pHjUoIXtgQNIeum2+HFtSiSMLV2kEDOx
	9eIethSLa2ZZ/wEL9kZr7lLPjWh6M9/8nyrs8lyWOkr+iKWufdbva/bCyQeXCAhWIh7SD1mps6w
	5v5/bnKOyOLfmT+NiZ8SZNLXj5E/rfOjSRyNywfhdFO4G5gi7561NFZyl3viv0vrp3jXh+lXfFw
	Iq3YOH7LV6jIwD2BU3hZZr5ZpVB+0YjVrpq2KOzXIw4zD6RGG2tqA4zP1FsbNOmajNIxzSTFavN
	2CazuuBAi9WA=
X-Received: by 2002:a05:6000:178c:b0:3a6:d92f:b7a0 with SMTP id ffacd0b85a97d-3b5f359d05fmr12157630f8f.58.1752594220237;
        Tue, 15 Jul 2025 08:43:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQdixTkib7IKderVRJRpNZBQyOcCCqBywj9UR7izGUcjMQdWUcilMbnriF7fEvi4gh/vD27w==
X-Received: by 2002:a05:6000:178c:b0:3a6:d92f:b7a0 with SMTP id ffacd0b85a97d-3b5f359d05fmr12157605f8f.58.1752594219735;
        Tue, 15 Jul 2025 08:43:39 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e26daasm15773872f8f.91.2025.07.15.08.43.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 08:43:39 -0700 (PDT)
Message-ID: <b0ff2033-b8ab-4cee-833c-83e70951a9d9@redhat.com>
Date: Tue, 15 Jul 2025 17:43:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 08/13] qmp: update virtio features map to support
 extended features
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
 <5f5a6718fa5ae82d5cd3b73523deea41089ffeb5.1752229731.git.pabeni@redhat.com>
 <aab8c434-364e-4305-9d8b-943eb0c98406@rsg.ci.i.u-tokyo.ac.jp>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <aab8c434-364e-4305-9d8b-943eb0c98406@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 9:59 AM, Akihiko Odaki wrote:
> On 2025/07/11 22:02, Paolo Abeni wrote:
>> @@ -785,11 +821,12 @@ VirtioStatus *qmp_x_query_virtio_status(const char *path, Error **errp)
>>           status->vhost_dev->nvqs = hdev->nvqs;
>>           status->vhost_dev->vq_index = hdev->vq_index;
>>           status->vhost_dev->features =
>> -            qmp_decode_features(vdev->device_id, hdev->features);
>> +            qmp_decode_features(vdev->device_id, hdev->features_array);
>>           status->vhost_dev->acked_features =
>> -            qmp_decode_features(vdev->device_id, hdev->acked_features);
>> +            qmp_decode_features(vdev->device_id, hdev->acked_features_array);
>>           status->vhost_dev->backend_features =
>> -            qmp_decode_features(vdev->device_id, hdev->backend_features);
>> +            qmp_decode_features(vdev->device_id, hdev->backend_features_array);
>> +
>>           status->vhost_dev->protocol_features =
>>               qmp_decode_protocols(hdev->protocol_features);
>>           status->vhost_dev->max_queues = hdev->max_queues;
>> diff --git a/hw/virtio/virtio-qmp.h b/hw/virtio/virtio-qmp.h
>> index 245a446a56..e0a1e49035 100644
>> --- a/hw/virtio/virtio-qmp.h
>> +++ b/hw/virtio/virtio-qmp.h
>> @@ -18,6 +18,7 @@
>>   VirtIODevice *qmp_find_virtio_device(const char *path);
>>   VirtioDeviceStatus *qmp_decode_status(uint8_t bitmap);
>>   VhostDeviceProtocols *qmp_decode_protocols(uint64_t bitmap);
>> -VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id, uint64_t bitmap);
>> +VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id,
>> +                                          const uint64_t *bitmap);
>>   
>>   #endif
>> diff --git a/qapi/virtio.json b/qapi/virtio.json
>> index 73df718a26..f0442e144b 100644
>> --- a/qapi/virtio.json
>> +++ b/qapi/virtio.json
>> @@ -488,14 +488,18 @@
>>   #     unique features)
>>   #
>>   # @unknown-dev-features: Virtio device features bitmap that have not
>> -#     been decoded
>> +#     been decoded (lower 64 bit)
>> +#
>> +# @unknown-dev-features-dword2: Virtio device features bitmap that have not
>> +#     been decoded (bits 65-128)
>>   #
>>   # Since: 7.2
>>   ##
>>   { 'struct': 'VirtioDeviceFeatures',
>>     'data': { 'transports': [ 'str' ],
>>               '*dev-features': [ 'str' ],
>> -            '*unknown-dev-features': 'uint64' } }
>> +            '*unknown-dev-features': 'uint64',
>> +            '*unknown-dev-features-dword2': 'uint64' } }
> 
> Let's omit "dword" for consistency with unknown-dev-features, which is 
> also uint64 but don't have the keyword.

Ok. Can I infer that is actually legit to update a qapi struct
definition? It's not clear to me it such change violates any qemu
assumptions.

/P


