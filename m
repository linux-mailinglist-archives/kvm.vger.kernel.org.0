Return-Path: <kvm+bounces-51811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1AEAAFD864
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 22:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43AC317635E
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 20:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2BF23AE9A;
	Tue,  8 Jul 2025 20:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PXyEA8Io"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F029F14A60D
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 20:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752006744; cv=none; b=PUu5qYZPUshTEq+FfG6Ag45gphZUoI4CLloh3Gsp3vB5iLRMl1ISmoz3g8GoHTeoqlZzjG9CC5WUzHXSA3sFPJJmlL7sb+UZWJbvx2dpzLizk/PPpnpYhw2RNkZBeQ30a1chCHeYntkW0iWUX2+VV4HmSoyI+ZFCXFfYpKQIcag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752006744; c=relaxed/simple;
	bh=MxGXajIRbMndTP6Y7jkVKKVwgRoh5XnkmqHEkrXJAQc=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=hwwHN3fJoRUT06X6rh1HSGmOym1GmQFwR1sokynzd4zN95Ow0ucTkGretlONnmE0a2vLar+EEVwCV17QEYm2byQnELyXIDdszmyMsfOH8wV54xmB07YIxOT4VgVeTA1ziKZhdZC+zWH0PWZhvRULuXIY5D3nDkph9JoyEM/6xqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PXyEA8Io; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752006741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=fZ18WZFpEezwzDghyjVN7O2vbGP067o5/z+6fSH4cdI=;
	b=PXyEA8IoGYI+uglsdUhOPAuBZHATMnsh4cs660NXlDrAPSsDutwlFg4sB3PLrUu3vD+8Wg
	X3ZnmVgSdTVb72RsBjZ3d3+SAPlloomistmOXHadU3EXC4yyRqDX62r37SLWZqkgD28iZn
	vE9RIJcVuyT1k601YJ1J16W5SFVQq8s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-8Jhbf7cgNf-UW72IYhKQ_g-1; Tue, 08 Jul 2025 16:32:20 -0400
X-MC-Unique: 8Jhbf7cgNf-UW72IYhKQ_g-1
X-Mimecast-MFC-AGG-ID: 8Jhbf7cgNf-UW72IYhKQ_g_1752006739
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a6d1394b07so3014860f8f.3
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 13:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752006739; x=1752611539;
        h=content-transfer-encoding:organization:autocrypt:subject:to
         :content-language:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZ18WZFpEezwzDghyjVN7O2vbGP067o5/z+6fSH4cdI=;
        b=DmjtdoowtaGN2yVA2RgMOP8Fp1mmW4zgHGAB3KY1cMLPSzLPjWcOFe3l/oSBjIYVZy
         RJCYpTQjV3FSOKgbJsn0vOcz0z9MKc2GYHy5ETHAnc62eYLBmoAfZAYNxRQL0xBNmVpE
         emjrWM3RrzKUiG6ksIqtfNNGJYJtr4MBSDqgOpUo0ZlCy2zgio5Qqn4fEcoIKvcvVhYh
         sDyvringtBAV/3exu2FVoB93r6JJOGpByQnoTo2wxR9NgD0q8TImIVpHKRn9Zfi6yrjs
         Smh285NeXzoCBrOvV9bZb77PWuGuVWO73lS19ZeZdPVKDGjETI7WTA9zAFSjdQWfRK6O
         1n8w==
X-Forwarded-Encrypted: i=1; AJvYcCV8hbHpiN6dId1NvEC92+qygAU8+z3nftYYJwmY+WDbBAsg6QDD/RtQUzJSzbKO7/Y4zN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKz3iX/YRF1wTB2bXrRN+TbaaJt6uePJgpwYCN9K0ZYPkSS2LJ
	vtw30kBv+oECk788e7kWVw1QuhfsKUqqDi4zOYBDkTWCtwqvQd0QgyZg/kD5fQYND/8hGO4nkCb
	aVznTiLiJJm4iQkNjQULyNUdH2FOm3/CpZPseKqaAfxzC6yTUCZijfw==
X-Gm-Gg: ASbGncs51PFGZjj9xmEVP4YMDCxux5lc18b7onVl08aIZlK3DG137gxsIyGtkk153tN
	KAw+j6E+uHj0ALahe8fsNTYh0ks1xxPc2rL5akaZItcHz0qqYLy5yAJ1/8qho+z7vc6mdkFgl1W
	R6yVWj5ZcTpsc4htP13ILEFchdnAV/nQadmp1/H5QiOXMWA/k57y5OUlbvo+gUjXeolmugRFyfm
	+MpBSNjlI6B2HdkoJbAzq7T0OogIyRrV+XEt2ryivNp4yCjU2j2DeIbHDp9DUVj3L44/GueOtV/
	PDPFNgz7eA592E5FlpWRLJc89Yeixiq3DDvf+hzwIn0JF5ZqB1t54bE0aG6zh1ahl01dkm0VVec
	cY/Nbcj1PK813IF3nITyj09tL9ztji3Eccw0kIijlvXaTWtZI1A==
X-Received: by 2002:a05:6000:2709:b0:3a4:eeb5:58c0 with SMTP id ffacd0b85a97d-3b5e2fec716mr510102f8f.20.1752006739163;
        Tue, 08 Jul 2025 13:32:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnJABxlTXixFupmtv5X6j7MccF5K1JtEQNdIDPVmGE+/olUcE1tUKL/Yi1nQz41qQUDyEHsA==
X-Received: by 2002:a05:6000:2709:b0:3a4:eeb5:58c0 with SMTP id ffacd0b85a97d-3b5e2fec716mr510064f8f.20.1752006738511;
        Tue, 08 Jul 2025 13:32:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:f500:4346:f17c:2bde:808c? (p200300d82f1af5004346f17c2bde808c.dip0.t-ipconnect.de. [2003:d8:2f1a:f500:4346:f17c:2bde:808c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b470d9e470sm13681312f8f.41.2025.07.08.13.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 13:32:18 -0700 (PDT)
Message-ID: <044a8f63-32d9-4c6f-ae3f-79072062d076@redhat.com>
Date: Tue, 8 Jul 2025 22:32:15 +0200
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
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-07-17
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

I had to move the meeting by one week -- I'll be out the next two days 
-- and decided to send the invite out already to highlight that :)

So, our next guest_memfd upstream call is scheduled for next week, 
Thursday, 2025-07-17 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll talk about memory failure handling, and continue 
our discussion on polishing up mmap support ("stage-1") to finally get 
it merged ... and whatever else comes up around that.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

Cheers,

David

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing


