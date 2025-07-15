Return-Path: <kvm+bounces-52518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1043AB0632F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 171034E699F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85292309B3;
	Tue, 15 Jul 2025 15:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEgjhxPt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5319C18DF80
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 15:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752594016; cv=none; b=C1lqIwIG85RpJIoyRFwVYRpmg7E8MQ8Fta/ExlVmDDbE8yR32kySCwBXfB2wRlgMAy7f0l2v5FxnppPiGGLkC2J3zmXvPoeIg23kfXsTwNugCYfaY3eSlGF9Qk/4o0F6m/r9eCV/xQm8gXA7y/fnrweZzj/YSsfkM7hZtCuAqIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752594016; c=relaxed/simple;
	bh=M/rABkmdhlxiGYMWbA4aNOloRqnti9HG/ZEw2946Kw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HdOD9C4fKxpUQdywsUnHY0C06+yd7UrBm2vg9ppiuGFjh7yapkMmsMhi++EclaP7hQOoH1cCh4DTXM3SQLIbqIB9gWn6YLeePzqATAEI0prbvJoWAP1GtmgwgIUgcgX3XES3MrHNasxxz1L3oOl/diavyy5UHOYHCfwakk3j4SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dEgjhxPt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752594014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4x2jlzMGApIh8vYUvg0aTLjZqP/Wbam/+YquAKpgluc=;
	b=dEgjhxPtrGnVAsTHLL5JkUp2Ejz+vp8EAKEl2X9rvuzSK/yHgTZv3cAqVkiGo9u7lA7PN0
	oFKVLaJ1eJjEtE6Tre5IJcAfK6iwl5xeBdTfZOpf8D3TzyxI0pr61j1dBMzx6O7XjZ+s3b
	UFphpSLwIHBOp33hSvqr+eABB6Q4iQw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-FV59YrbsMhW8v5ftUo8lzg-1; Tue, 15 Jul 2025 11:40:13 -0400
X-MC-Unique: FV59YrbsMhW8v5ftUo8lzg-1
X-Mimecast-MFC-AGG-ID: FV59YrbsMhW8v5ftUo8lzg_1752594012
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a5281ba3a4so2085727f8f.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 08:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752594011; x=1753198811;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4x2jlzMGApIh8vYUvg0aTLjZqP/Wbam/+YquAKpgluc=;
        b=U9uPRRerBqGqTyjA5G3lcxm/Ofu6pycq9Kcn5Hs26pzfVFFRXXzfet59P7+2GQ5769
         fxMdVMwxZM+zgsZSg1KdYIDNpsc3cJ6gzySIYyAk3PzfvnSKWx2FGeWtOsC1VBSJy87M
         NNek1jX0yD2AXlt2A3BKZF1Ry+/Dw07jPlGP/3+VUl4hYz/PZQkAndEUjkE5mawcJJ6t
         nBw8A3YBouWNWyotJmpWipe+24KcLnGZeSbmfLfvt+dJF1E+dKHd6QTwqV8tU7JFgw7G
         TjV7W9RPMuJob2dhAj1FgA4CCeH0Vho5ngsh+q6YRvhKNGabM2gTEqqadXDkJmsDNksB
         dJCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhcnM/QFKV4GHBwBPWO5NzOW6c+6QvmPoFts/Tz+PTd/9gyPcDKfW/zoT3nBDZRKj/Pdo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnSpxlZ7ffmn+HzVElyMUOYE7i3ofKLNnMeUnAV1X20WPVDI17
	3CUO14jddoXWm8ydBxZNDbZ9Ahe3sAQi9G+YIA20VyKDP9gEjoYV6NqobWXj0GQoNSRK4pmYFX/
	ha1q9dWr8ONz9lcggS4dJ8BkTWPTevEoIykklaPdd5BbrxW9rBxT0yA==
X-Gm-Gg: ASbGncvQrSB2EXRkMwEMFqGBzb+S/z/2gGScJ1xJERJe2T3oZ/iQawNBTdWIAyiLtbP
	FS+g8n+1Lxd5x2XjuTnmEu8yemHUl3frnVFPybcFX0auTV4tS0lpalR2WpXH5RQZg2ByJksd4ow
	jI5UgR8ShCLYgNpgdjLLsG6WER1qzB9EUeWvMru3xTlFgwsNAwofr3RgSurob04tjjKJHUOS4JX
	YHgjWqqfuKmfzCiq5lemJM4i6TudQIorXVK7HFiOtl6A/pHwmZmsMSSzmzttTV+JEKZsoZ1J+rb
	NWOQ+aczn1S15ha9qwg+lPJlwcXRBBz3SvH2RCGyEvS6pJExsQQ+PUl/so7eWZNeu0hKRKy16WR
	cTsAeCAKvdlY=
X-Received: by 2002:a05:600c:4695:b0:450:d4a6:799e with SMTP id 5b1f17b1804b1-454f4259c7cmr145301425e9.20.1752594011263;
        Tue, 15 Jul 2025 08:40:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFj/GOomg8/tuMfFm6+QQtZ8zHD+1Mr4bMdEvTBuHrv4Wc3OP8vgETy0L8oGZp1WPdBtBd1RA==
X-Received: by 2002:a05:600c:4695:b0:450:d4a6:799e with SMTP id 5b1f17b1804b1-454f4259c7cmr145301085e9.20.1752594010805;
        Tue, 15 Jul 2025 08:40:10 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4560f844c2dsm93287775e9.0.2025.07.15.08.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 08:40:10 -0700 (PDT)
Message-ID: <efd96b88-284c-4853-93ea-9e1b81b1ffe7@redhat.com>
Date: Tue, 15 Jul 2025 17:40:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 04/13] virtio: serialize extended features state
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
 <d0f97a8157c718dcb0799353394e1469153c6b22.1752229731.git.pabeni@redhat.com>
 <08285c9c-f522-4c64-ba3b-4fa533e42962@rsg.ci.i.u-tokyo.ac.jp>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <08285c9c-f522-4c64-ba3b-4fa533e42962@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 9:24 AM, Akihiko Odaki wrote:
> On 2025/07/11 22:02, Paolo Abeni wrote:
>> +     */
>> +    QEMU_BUILD_BUG_ON(VIRTIO_FEATURES_DWORDS != 2);
>> +    if (virtio_128bit_features_needed(vdev)) {
> 
> There is no need to distinguish virtio_128bit_features_needed() and 
> virtio_64bit_features_needed() here.

Double checking I'm reading the above correctly. Are you suggesting to
replace this chunk with something alike:

    if (virtio_64bit_features_needed(vdev)) {
        /* The 64 highest bit has been cleared by the previous
         *  virtio_features_from_u64() and ev.
         * initialized as needed when loading
         * "virtio/128bit_features"*/
        uint64_t *val = vdev->guest_features_array;

        if (virtio_set_128bit_features_nocheck_maybe_co(vdev, val) < 0)
// ...

> For the 32-bit case, it will be simpler to have an array here and use 
> virtio_set_128bit_features_nocheck_maybe_co() instead of having 
> virtio_set_features_nocheck_maybe_co().

Again double checking I'm parsing the above correctly. You are
suggesting to dismiss the  virtio_set_features_nocheck_maybe_co() helper
entirely and use virtio_set_128bit_features_nocheck_maybe_co() even when
only 32bit features are loaded. Am I correct?

Thanks,

Paolo


