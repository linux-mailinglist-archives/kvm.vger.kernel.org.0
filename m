Return-Path: <kvm+bounces-52437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33078B05323
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85B2917BFF1
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4925A276030;
	Tue, 15 Jul 2025 07:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="W0oL2jEs"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4D126D4EB
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 07:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752564274; cv=none; b=hdYCEJgQpDBilJ593f7N4Vzmz+qo8bmtIb1CZ2BBlRNEcdanyQp5MATfmQi18edYMIrkMuCvyIF14ysHRxKxckKJiFjM0YLAh8K7w3JE4gPluxQieN67KSUrudh+15ljKWG7nQ7XUw9/BzLSfcYTFwh+6Ef5JMq5fc6k3nXmG4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752564274; c=relaxed/simple;
	bh=DPj2LrfmaMz8q+KZG62tM0GbljQTnoGJ/EdbIAhgCdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kn0rC1SM2qhhcw2w/SjI+iLRpM0SGf++eleJF8OnPI9owske82yNfhI9vrhK+oMMSB8DTGm24fdE5SYDC4yBlEqNnbsc7sNgHVv3RkWWty86gAVJQ0CVXTvafANXjyXXlx2WhC+m8GW/gOzGznhk14ckqHYFdzaq3FK5VQ4g6no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=W0oL2jEs reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [10.105.8.218] ([192.51.222.130])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56F7OTRR015997
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 15 Jul 2025 16:24:29 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=9nCJnifq9BE533TzaKfZRThu+mQoxlYg9DpJVBSqeF8=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752564270; v=1;
        b=W0oL2jEsaD1blnThVd4Hbp/LS+l1GFFqY4U4jvfCsiKMIq37UBoosu4DPavEgS24
         jxam+COoG9BUE6qw3Rab4XOrXcB5zCRYm/7bYA4T8k8TSwYma/RnBEj/jamYjjrG
         9JSibfdcwXtY0wIs7gxU/HmPTi4x4vtcYvs3iooCcTF4/1r7xMZeWghrnYu6Xi2G
         7dL6dG7lb47XPknC7OnLzIihA2FZYNUooA7GPiOiQWUde+qkiv+mdbZ13EQ6HOmC
         +p9ayzDv6EcyzrpkG5pLaRGHUdUZ7CbKOrx5bedkx7Gr3zHGxqjMdX8azNa4MIDU
         C0lIzWicPkinhqf+i+ruPg==
Message-ID: <08285c9c-f522-4c64-ba3b-4fa533e42962@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 15 Jul 2025 16:24:29 +0900
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
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <d0f97a8157c718dcb0799353394e1469153c6b22.1752229731.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/11 22:02, Paolo Abeni wrote:
> If the driver uses any of the extended features (i.e. above 64),
> serialize the full features range (128 bits).
> 
> This is one of the few spots that need explicitly to know and set
> in stone the extended features array size; add a build bug to prevent
> breaking the migration should such size change again in the future:
> more serialization plumbing will be needed.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v1 -> v2:
>   - uint128_t -> u64[2]
> ---
>   hw/virtio/virtio.c | 97 ++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 86 insertions(+), 11 deletions(-)
> 
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index 82a285a31d..6a313313dd 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -2954,6 +2954,24 @@ static const VMStateDescription vmstate_virtio_disabled = {
>       }
>   };
>   
> +static bool virtio_128bit_features_needed(void *opaque)
> +{
> +    VirtIODevice *vdev = opaque;
> +
> +    return virtio_features_use_extended(vdev->host_features_array);
> +}
> +
> +static const VMStateDescription vmstate_virtio_128bit_features = {
> +    .name = "virtio/128bit_features",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = &virtio_128bit_features_needed,
> +    .fields = (const VMStateField[]) {
> +        VMSTATE_UINT64_ARRAY(guest_features_array, VirtIODevice, 2),

We only need to save the second element so it can be reduced to:
VMSTATE_UINT64(guest_features_array[1], VirtIODevice)

> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>   static const VMStateDescription vmstate_virtio = {
>       .name = "virtio",
>       .version_id = 1,
> @@ -2963,6 +2981,7 @@ static const VMStateDescription vmstate_virtio = {
>       },
>       .subsections = (const VMStateDescription * const []) {
>           &vmstate_virtio_device_endian,
> +        &vmstate_virtio_128bit_features,
>           &vmstate_virtio_64bit_features,
>           &vmstate_virtio_virtqueues,
>           &vmstate_virtio_ringsize,
> @@ -3059,23 +3078,30 @@ const VMStateInfo  virtio_vmstate_info = {
>       .put = virtio_device_put,
>   };
>   
> -static int virtio_set_features_nocheck(VirtIODevice *vdev, uint64_t val)
> +static int virtio_set_features_nocheck(VirtIODevice *vdev, const uint64_t *val)
>   {
>       VirtioDeviceClass *k = VIRTIO_DEVICE_GET_CLASS(vdev);
> -    bool bad = (val & ~(vdev->host_features)) != 0;
> +    uint64_t tmp[VIRTIO_FEATURES_DWORDS];
> +    bool bad;
> +
> +    virtio_features_andnot(tmp, val, vdev->host_features_array);
> +    bad = !virtio_features_is_empty(tmp);

bitmap_andnot() returns a value representing if some bit in the 
resulting bitmap is set. We can remove the virtio_features_is_empty() 
call if virtio_features_andnot() does the same.

> +
> +    virtio_features_and(tmp, val, vdev->host_features_array);
>   
> -    val &= vdev->host_features;
>       if (k->set_features) {
> -        k->set_features(vdev, val);
> +        bad = bad || virtio_features_use_extended(tmp);
> +        k->set_features(vdev, tmp[0]);
>       }
> -    vdev->guest_features = val;
> +
> +    virtio_features_copy(vdev->guest_features_array, tmp);
>       return bad ? -1 : 0;
>   }
>   
>   typedef struct VirtioSetFeaturesNocheckData {
>       Coroutine *co;
>       VirtIODevice *vdev;
> -    uint64_t val;
> +    uint64_t val[VIRTIO_FEATURES_DWORDS];
>       int ret;
>   } VirtioSetFeaturesNocheckData;
>   
> @@ -3094,12 +3120,41 @@ virtio_set_features_nocheck_maybe_co(VirtIODevice *vdev, uint64_t val)
>           VirtioSetFeaturesNocheckData data = {
>               .co = qemu_coroutine_self(),
>               .vdev = vdev,
> -            .val = val,
>           };
> +        virtio_features_from_u64(data.val, val);
>           aio_bh_schedule_oneshot(qemu_get_current_aio_context(),
>                                   virtio_set_features_nocheck_bh, &data);
>           qemu_coroutine_yield();
>           return data.ret;
> +    } else {
> +        uint64_t features[VIRTIO_FEATURES_DWORDS];
> +        virtio_features_from_u64(features, val);
> +        return virtio_set_features_nocheck(vdev, features);
> +    }
> +}
> +
> +static void virtio_set_128bit_features_nocheck_bh(void *opaque)

"128bit" should be omitted for consistency with 
virtio_set_features_nocheck() and for extensibility.

> +{
> +    VirtioSetFeaturesNocheckData *data = opaque;
> +
> +    data->ret = virtio_set_features_nocheck(data->vdev, data->val);
> +    aio_co_wake(data->co);
> +}
> +
> +static int coroutine_mixed_fn
> +virtio_set_128bit_features_nocheck_maybe_co(VirtIODevice *vdev,
> +                                            const uint64_t *val)
> +{
> +    if (qemu_in_coroutine()) {
> +        VirtioSetFeaturesNocheckData data = {
> +            .co = qemu_coroutine_self(),
> +            .vdev = vdev,
> +        };
> +        virtio_features_copy(data.val, val);
> +        aio_bh_schedule_oneshot(qemu_get_current_aio_context(),
> +                                virtio_set_128bit_features_nocheck_bh, &data);
> +        qemu_coroutine_yield();
> +        return data.ret;
>       } else {
>           return virtio_set_features_nocheck(vdev, val);
>       }
> @@ -3107,6 +3162,7 @@ virtio_set_features_nocheck_maybe_co(VirtIODevice *vdev, uint64_t val)
>   
>   int virtio_set_features(VirtIODevice *vdev, uint64_t val)
>   {
> +    uint64_t features[VIRTIO_FEATURES_DWORDS];
>       int ret;
>       /*
>        * The driver must not attempt to set features after feature negotiation
> @@ -3122,7 +3178,8 @@ int virtio_set_features(VirtIODevice *vdev, uint64_t val)
>                         __func__, vdev->name);
>       }
>   
> -    ret = virtio_set_features_nocheck(vdev, val);
> +    virtio_features_from_u64(features, val);
> +    ret = virtio_set_features_nocheck(vdev, features);
>       if (virtio_vdev_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX)) {
>           /* VIRTIO_RING_F_EVENT_IDX changes the size of the caches.  */
>           int i;
> @@ -3145,6 +3202,7 @@ void virtio_reset(void *opaque)
>   {
>       VirtIODevice *vdev = opaque;
>       VirtioDeviceClass *k = VIRTIO_DEVICE_GET_CLASS(vdev);
> +    uint64_t features[VIRTIO_FEATURES_DWORDS];
>       int i;
>   
>       virtio_set_status(vdev, 0);
> @@ -3171,7 +3229,8 @@ void virtio_reset(void *opaque)
>       vdev->start_on_kick = false;
>       vdev->started = false;
>       vdev->broken = false;
> -    virtio_set_features_nocheck(vdev, 0);
> +    virtio_features_clear(features);
> +    virtio_set_features_nocheck(vdev, features);
>       vdev->queue_sel = 0;
>       vdev->status = 0;
>       vdev->disabled = false;
> @@ -3254,7 +3313,7 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
>        * Note: devices should always test host features in future - don't create
>        * new dependencies like this.
>        */
> -    vdev->guest_features = features;
> +    virtio_features_from_u64(vdev->guest_features_array, features);
>   
>       config_len = qemu_get_be32(f);
>   
> @@ -3333,7 +3392,23 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
>           vdev->device_endian = virtio_default_endian();
>       }
>   
> -    if (virtio_64bit_features_needed(vdev)) {
> +    /*
> +     * Serialization needs constant size features array. Avoid
> +     * silently breaking migration should the feature space increase
> +     * even more in the (far away) future

Serialization is not done here and irrlevant.

> +     */
> +    QEMU_BUILD_BUG_ON(VIRTIO_FEATURES_DWORDS != 2);
> +    if (virtio_128bit_features_needed(vdev)) {

There is no need to distinguish virtio_128bit_features_needed() and 
virtio_64bit_features_needed() here.

For the 32-bit case, it will be simpler to have an array here and use 
virtio_set_128bit_features_nocheck_maybe_co() instead of having 
virtio_set_features_nocheck_maybe_co().

> +        uint64_t *val = vdev->guest_features_array;
> +
> +        if (virtio_set_128bit_features_nocheck_maybe_co(vdev, val) < 0) {
> +            error_report("Features 0x" VIRTIO_FEATURES_FMT " unsupported. "
> +                         "Allowed features: 0x" VIRTIO_FEATURES_FMT,
> +                         VIRTIO_FEATURES_PR(val),
> +                         VIRTIO_FEATURES_PR(vdev->host_features_array));
> +            return -1;
> +        }
> +    } else if (virtio_64bit_features_needed(vdev)) {
>           /*
>            * Subsection load filled vdev->guest_features.  Run them
>            * through virtio_set_features to sanity-check them against


