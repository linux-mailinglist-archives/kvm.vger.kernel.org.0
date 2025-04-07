Return-Path: <kvm+bounces-42844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A518A7DF42
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 15:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7D213A9FF8
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 13:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB50253B7D;
	Mon,  7 Apr 2025 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFOsvz1D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B68117BD3
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744032504; cv=none; b=L5ZmY2WCMYmGjflhT4q7ZicUCi8F7u9g5pR+727phFGtBEISL1XUDuOheQSxQBjGCZIt33KRb8LePg32YJdh4hSOLGxskIyutedkm1P9aq2WkkaxOctuBRL5i1q4yrhXZYuUxBC0W7w1is5KCBaE7KycFhIa9U1MeZyb1w/MaIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744032504; c=relaxed/simple;
	bh=WBhV0P50uEemvYkCTcchjpLIuIOu7LWYOWRI3TWiHow=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=V1Ehzx90e4IUdOnWGPMc5kPh6GgJoB6R4uP9hMpwNQrXuUJaLjMD7d1zIdPPSGEV15CCsv1yyspmy/J1r/MK06NIHamOaDQrKNhUT6dBRYvlm9uapzWGo4QnvT5zCERvmfYgIrT9kl57iDLw5ng2nqJi2iBK4G62KiyxceOmYIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFOsvz1D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744032501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jFoPwO5vUc8+rAcXR9YnRFfcZSPIuCpPg3z/cEeH+VA=;
	b=QFOsvz1DtQk6dSj7I3TFcBtaH/jyegfUzcty4wZsBXOPFrmuOVAGL0GPcaO3LOM8dWqdhl
	1kL3Z8R7cW2mhip5V0jFy3S3WYEz23WWXdjD/gNUqaxgh674JBSj3oKOAFXO2SqlD7K8YE
	Zu/OubdKPc/EmpI9jizW8K3TP+7gLf4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-9rJso_2iP4mEcPXsMMgHMg-1; Mon,
 07 Apr 2025 09:28:19 -0400
X-MC-Unique: 9rJso_2iP4mEcPXsMMgHMg-1
X-Mimecast-MFC-AGG-ID: 9rJso_2iP4mEcPXsMMgHMg_1744032497
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBAE0195608A;
	Mon,  7 Apr 2025 13:28:16 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C48FF1809B6A;
	Mon,  7 Apr 2025 13:28:15 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org, Chandra Merla
 <cmerla@redhat.com>, Stable@vger.kernel.org, Thomas Huth
 <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Wei Wang
 <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
In-Reply-To: <9126bfbf-9461-4959-bd38-1d7bc36d7701@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250404063619.0fa60a41.pasic@linux.ibm.com>
 <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
 <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <20250407042058-mutt-send-email-mst@kernel.org>
 <20250407151249.7fe1e418.pasic@linux.ibm.com>
 <9126bfbf-9461-4959-bd38-1d7bc36d7701@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 07 Apr 2025 15:28:13 +0200
Message-ID: <87h6309k42.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Apr 07 2025, David Hildenbrand <david@redhat.com> wrote:

> On 07.04.25 15:12, Halil Pasic wrote:
>> On Mon, 7 Apr 2025 04:34:29 -0400
>> "Michael S. Tsirkin" <mst@redhat.com> wrote:
>> 
>>> On Mon, Apr 07, 2025 at 10:17:10AM +0200, David Hildenbrand wrote:
>>>> On 07.04.25 09:52, Michael S. Tsirkin wrote:
>>>>> On Fri, Apr 04, 2025 at 05:39:10PM +0200, Halil Pasic wrote:
>>>>>>>
>>>>>>> Not perfect, but AFAIKS, not horrible.
>>>>>>
>>>>>> It is like it is. QEMU does queue exist if the corresponding feature
>>>>>> is offered by the device, and that is what we have to live with.
>>>>>
>>>>> I don't think we can live with this properly though.
>>>>> It means a guest that does not know about some features
>>>>> does not know where to find things.
>>>>
>>>> Please describe a real scenario, I'm missing the point.
>>>
>>>
>>> OK so.
>>>
>>> Device has VIRTIO_BALLOON_F_FREE_PAGE_HINT and VIRTIO_BALLOON_F_REPORTING
>>> Driver only knows about VIRTIO_BALLOON_F_REPORTING so
>>> it does not know what does VIRTIO_BALLOON_F_FREE_PAGE_HINT do.
>>> How does it know which vq to use for reporting?
>>> It will try to use the free page hint one.
>> 
>> First, sorry for not catching up again with the discussion earlier.
>> 
>> I think David's point is based on the assumption that by the time feature
>> with the feature bit N+1 is specified and allocates a queue Q, all
>> queues with indexes smaller than Q are allocated and possibly associated
>> with features that were previously specified (and probably have feature
>> bits smaller than N+1).
>> 
>> I.e. that we can mandate, even if you don't want to care about other
>> optional features, you have to, because we say so, for the matter of
>> virtqueue existence. And anything in the future, you don't have to care
>> about because the queue index associated with future features is larger
>> than Q, so it does not affect our position.
>> 
>> I think that argument can fall a part if:
>> * future features reference optional queues defined in the past
>> * somebody managed to introduce a limbo where a feature is reserved, and
>>    they can not decide if they want a queue or not, or make the existence
>>    of the queue depend on something else than a feature bit.
>
> Staring at the cross-vmm, including the adding+removing of features and 
> queues that are not in the spec, I am wondering if (in a world with 
> fixed virtqueues)
>
> 1) Feature bits must be reserved before used.
>
> 2) Queue indices must be reserved before used.
>
> It all smells like a problem similar to device IDs ...

Indeed, we need a rule "reserve a feature bit/queue index before using
it, even if you do not plan to spec it properly".


