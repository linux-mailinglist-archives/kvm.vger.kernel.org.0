Return-Path: <kvm+bounces-41448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79DB4A67E1E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 21:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E97E188EF6E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23BD20FAAB;
	Tue, 18 Mar 2025 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AMKMaZ1n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B34F1F4164
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 20:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742330558; cv=none; b=EgaxDjC2QVhkfqpvCecH8PBbHH6VF7aoplK2RfEOnDdc3qxoxQng25QeLol4/C/QO/lYwZwVHIDyoTv9QxoLOf3PRGp4DPaFJ73QrWQl3i73/CmLMIXUxtuVBDk2nQ6MU1W58ubB+hKuqtbbHutMW1cV7zwAF5AaRgM/v5vHnrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742330558; c=relaxed/simple;
	bh=g4zIBicEBvmQhmElYtlURMqJTf8XGl3Ae3JajhhX4oU=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=CCPzMUTrORN+MWlycDBkhIUeF3XZ4vwRTvWv5LHGhZXKa3G3pqnSldKJQeVuJEk6jWdJtJ/zn9FWPH1t2vP+gAJHYje9lTGPapS6z1dHd2pYaaKLS7Q5QpN+w73LBK06NJLuoJNvGAgF5N+ZPpl1cbXW3RBcFirIYSiH9Y/6yRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AMKMaZ1n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742330555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=o9YlOwrXpln0/4LD9YCWECBS2F4ckTvvvJ0vz4vE47I=;
	b=AMKMaZ1noPUDVABDoxZNCnpJ/p7ByZ9mY8NZ4u2fKLp6bsmkSREpBwcnSie49C9cY+E447
	ggD6Cjf/ktHfx86RjbbvyrjriDPCfr7Lm6BREcgp5chcJ++pX1rMELNXdPPrY2t+RMVGbL
	f/tZY8FcaCrqVsyVW/4CztQ3QlpNgHc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-HLYkoAnzPnylYqCnoJTCog-1; Tue, 18 Mar 2025 16:42:33 -0400
X-MC-Unique: HLYkoAnzPnylYqCnoJTCog-1
X-Mimecast-MFC-AGG-ID: HLYkoAnzPnylYqCnoJTCog_1742330553
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4394c747c72so19148025e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 13:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742330552; x=1742935352;
        h=content-transfer-encoding:organization:autocrypt:subject:to
         :content-language:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o9YlOwrXpln0/4LD9YCWECBS2F4ckTvvvJ0vz4vE47I=;
        b=Vzw2jTuBxyiH7x1yrg2VWAg8W72bpsgXaLKrZQ9xo5K55pgdiDBzQne8jbY1L9xToJ
         dBKvCitdMXSZvAeHwqi9iyp5EwdZ2Ev359WZzLHXGlTomB1gaYswVf/dKJe0/EnqIdm7
         4ALo65vMrT5Ud/7Y3XVLhsUq8p0uTvWJecEZep394tHau1c3EdjyiYdd9zDEHGNbm1xq
         tbq4j5XplD28P58SzFC2FIP8TMH7Yjhb8LPS436a3sjCNSvNuSVP2nmJCvbU9xOuLYGJ
         +Itoy5miVxjTeROJSlZrM/c/UTfPlBP3s9d9kUk8Z02J/4WfUvl4BJ7iNqt0tI0uUjwx
         yeTg==
X-Forwarded-Encrypted: i=1; AJvYcCVwa69h3zhD6luDus7zK9ffWgxvo26rdFt4UWIpkvaZ7MLU5h9dQu77zW7MeAjMGyyThqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyFo3SYIx15CT2UFbNipQsZeDWQu5YvT6pbhwvIFzfm0NGMBSa
	qdp0w1R2ec7KZexdjAe9etkGGhcUZ0Og1nBIkwUzyLq+kHoO0OV+1PQ1+SbzMHJmnHUfL8KPOL9
	eIrsOve1uagKZsr+kCQ5JTMLd2lxAAxtfo2mCU9nJJYt020Vx8g==
X-Gm-Gg: ASbGncuimeIgZizVMVbIymUdMR5GjbeOzi9rVJibwJNvd9b7VyFWtpXNTogka2Zw9bj
	WEiMyDKB1xv0dTAlijuPWj2+x9rUva9GZ2ZiHLSCcGQuKimJ1PsV7vX/4ygNkkrgvvJa/nS3ezc
	N9ykemnoUqWUW8ufm4kZPjPbJYFf8aHoOwzDXwJNxyQbOdBUxjMdn7W1n0XZHXxqrlgGMMWEjbI
	dqGOMiCSDWb29yoRRuK5wyLg/hK097GB3Ti9AIWtMC43dVg361xCTLP7TvQIS9/zfuVEB9q7eVW
	vgKncyQbxFXBUt1r6zqW9GLHg1Opk+lolhIpZsj5b82N7iACYdxwl/4PSyQHM197CTS+lralo4O
	KhYnfn82df8xQnmo+JBz4MNk+Vhq0H4QgUWp9mabZAuo=
X-Received: by 2002:a05:600c:1c1d:b0:43c:f81d:34 with SMTP id 5b1f17b1804b1-43d4378b363mr238295e9.9.1742330552354;
        Tue, 18 Mar 2025 13:42:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJAxUUxC6RXnZ65/9Qj+t7rXeghX0fpG2CZ6cO6Lo/guoZhSWIagnR9QB8RSqwSRbLBdAB2Q==
X-Received: by 2002:a05:600c:1c1d:b0:43c:f81d:34 with SMTP id 5b1f17b1804b1-43d4378b363mr238145e9.9.1742330551817;
        Tue, 18 Mar 2025 13:42:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72d:2500:94b5:4b7d:ad4a:fd0b? (p200300cbc72d250094b54b7dad4afd0b.dip0.t-ipconnect.de. [2003:cb:c72d:2500:94b5:4b7d:ad4a:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fdda15dsm145861195e9.3.2025.03.18.13.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 13:42:31 -0700 (PDT)
Message-ID: <fcb3f8dd-e66e-491d-a475-adf698fb2da0@redhat.com>
Date: Tue, 18 Mar 2025 21:42:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-03-20
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

LSF/MM/BPF 2025 is just around the corner. For those of you that will 
not attend, is there anything specific I should raise regarding guest_memfd?

Our next guest_memfd upstream call is scheduled for Thursday,
2025-03-20 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, I hope we can talk about some of the latest upstream 
proposals, and what is required to take them over the finishing line 
(i.e., blockers, open issues), in particular
* Restricted mmap support
* guest_memfd for backing software-protected VMs
* NUMA support (and interaction with frozen refcounts etc.)

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David / dhildenb


