Return-Path: <kvm+bounces-52627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F46B0750A
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:53:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17A56505896
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2CE62F3C1A;
	Wed, 16 Jul 2025 11:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="hprgm3Pp"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8483D2E36F4
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752666783; cv=none; b=snxvLYL2gnSjXxt85/UqyCDm9ylD3bWpxX4w9aIMLi5YorFUcUnqPsaLWZCishsSWi3d9r33RZzN+p/HwO4GGn3fs/wgerYrODvJqnjUhmN3oYX1aHR7SemTL7fhmIhXnb1EmqIq+JRmHqBGAxyaQVHul1cXv3ZO1iiXIn2eFm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752666783; c=relaxed/simple;
	bh=V3fUpNVYdkJFh7Pr/lhbmkE4E8ZUWYS96aUk50UpAqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=enwcSxPTFoDyHWlWpbtcj635x/7gqGQOWkMLfd8DCfUJwagv7UHujjIbl4h4JoNSMhCipjfresElKiWgHcMQpzUTydRr9FmvoIzH3vGFa6/r8fTPWgwuhBeA1WIjBBy0iHErvSSnX4aDhPfQ8qbNmD4PCa0DHq8JH+95CkZZ5Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=hprgm3Pp reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [157.82.206.39] ([157.82.206.39])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56GBqwpA031686
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 16 Jul 2025 20:52:58 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=GjmQy1NDdPTuVHZ8/I+mITVpluhpLhXagsPnL+0J/Xg=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752666778; v=1;
        b=hprgm3PpWQDIea4b3TZFFZvlQqyxDueU0KfvU7e+sDbGB4v/APBXZ8awCFsydQS6
         xGqDrWRfZ/t0cH2KfAIkEs7Hu/ebwYwRKyGbAsxln4h+Do2LMKnrvhoZ446q/Q/f
         MtuXsvEJNrM2JX/QWpNQ4bp89CtBsZs/YhDYYoM3IkT0tuXu+pMNJP58qLQajhsf
         TpbmW2gSNcf40QPPXgIzRVi+gp0q6ldMdi7vY67j8WLB2JrbsvwNzJHWeJRdh2pU
         nGmxBD+PrtlwpIHV4UvMfFB7LrIGk0F4Y5uzolNouSm4ZwGi2UV6899jQQFSkNlV
         7ppPd8PMrkGmHUEYT5BM3g==
Message-ID: <07b09740-9e20-43df-a128-83e62e7a34a2@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 16 Jul 2025 20:52:58 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 04/13] virtio: serialize extended features state
To: Paolo Abeni <pabeni@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Luigi Rizzo <lrizzo@google.com>,
        Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>,
        Vincenzo Maffione <v.maffione@gmail.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <d0f97a8157c718dcb0799353394e1469153c6b22.1752229731.git.pabeni@redhat.com>
 <08285c9c-f522-4c64-ba3b-4fa533e42962@rsg.ci.i.u-tokyo.ac.jp>
 <efd96b88-284c-4853-93ea-9e1b81b1ffe7@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <efd96b88-284c-4853-93ea-9e1b81b1ffe7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/16 0:40, Paolo Abeni wrote:
> On 7/15/25 9:24 AM, Akihiko Odaki wrote:
>> On 2025/07/11 22:02, Paolo Abeni wrote:
>>> +     */
>>> +    QEMU_BUILD_BUG_ON(VIRTIO_FEATURES_DWORDS != 2);
>>> +    if (virtio_128bit_features_needed(vdev)) {
>>
>> There is no need to distinguish virtio_128bit_features_needed() and
>> virtio_64bit_features_needed() here.
> 
> Double checking I'm reading the above correctly. Are you suggesting to
> replace this chunk with something alike:
> 
>      if (virtio_64bit_features_needed(vdev)) {

This condition is not right as virtio_64bit_features_needed() doesn't 
return true when the some of bits [64, 128) is set while bits [32, 64) 
are cleared. I see two options to fix:

- Check: virtio_64bit_features_needed(vdev) ||
          virtio_128bit_features_needed(vdev)

- Ensure that virtio_64bit_features_needed(vdev) returns true when a bit 
more significant than bit 31 is set.

>          /* The 64 highest bit has been cleared by the previous
>           *  virtio_features_from_u64() and ev.
>           * initialized as needed when loading
>           * "virtio/128bit_features"*/
>          uint64_t *val = vdev->guest_features_array;
> 
>          if (virtio_set_128bit_features_nocheck_maybe_co(vdev, val) < 0)
> // ...> >> For the 32-bit case, it will be simpler to have an array here and use
>> virtio_set_128bit_features_nocheck_maybe_co() instead of having
>> virtio_set_features_nocheck_maybe_co().
> 
> Again double checking I'm parsing the above correctly. You are
> suggesting to dismiss the  virtio_set_features_nocheck_maybe_co() helper
> entirely and use virtio_set_128bit_features_nocheck_maybe_co() even when
> only 32bit features are loaded. Am I correct?

Yes, but now I found it is unnecessary to special-case even the 32-bit case.

Commit 019a3edbb25f ("virtio: make features 64bit wide") had to add a 
conditional to distinguish the 64-bit and 32-bit cases because 
vdev->guest_features was not set before executing this part of code.

However, commit 62cee1a28aad ("virtio: set low features early on load") 
later added preceding code to set vdev->guest_features. In summary, this 
part of code can be simply replaced with:

     if (virtio_set_128bit_features_nocheck_maybe_co(vdev, 
vdev->guest_features_array) < 0) {
         error_report("Features 0x" VIRTIO_FEATURES_FMT " unsupported. "
                         "Allowed features: 0x" VIRTIO_FEATURES_FMT,
                         VIRTIO_FEATURES_PR(val),
                         VIRTIO_FEATURES_PR(vdev->host_features_array));
         return -1;
     }

There is no need of virtio_64bit_features_needed(vdev) or 
virtio_128bit_features_needed(vdev) at all.

I have another finding by the way; there are three phrases that refers 
to the new extension: array (e.g., guest_features_array), _ex (e.g., 
virtio_add_feature_ex), 128bit (e.g., virtio_128bit_features_needed).

It makes sense to make "128bit" an exception in the migration code 
because the migration format is fixed and will require e.g., "192bit" 
for a future extension. But two suffixes, _ex and _array, can be unified.

Regards,
Akihiko Odaki

