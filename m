Return-Path: <kvm+bounces-28875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7326499E4AF
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:56:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A300282364
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9851E7653;
	Tue, 15 Oct 2024 10:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlT67y/+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F991E04BD
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 10:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728989709; cv=none; b=FNZfJzyejb+QPUDQ8kCRxVuij9GOhEZaBaJOFZw2NpIsQU5vd8fLDEjO0Tp0qTOegA8nLWTe3F/JDX0QjUVC/MmTkyqjJkBSXhIcHvLrQ91tWKmhVhxcpJU2WnN1U/+3cht1os301VGjxsRlvIJtFTj7LoNXS69he/9Rtt61A1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728989709; c=relaxed/simple;
	bh=gosB6q5sWMaM3u9ajSUaawR8eqhlu7jLBWeM/2NeAFo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=g5p4hgkFCYdhJ2SDZ13QcvFPo0KsydpmiDrgMlCOw5ugm5jkviX48JjSPYbNaTbWxHekrQrH1lem0x6eEQoj2LvArCXGk5m2CofWr2s8x+8KLK+XUi1vHIlgGt8mtwM3oQEDIvhLIr4l8WJHdBJjL9xDAGL1aFvsAzCwj9L4qlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HlT67y/+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728989706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=jN1OJwkAaGQtDrGUKrfe0W75Miaqbm3zRcU4TMBZuwE=;
	b=HlT67y/+Osf3X8ziSeAfzu8gicTeidsMPVFGDkvlOZwHKweZyyUlSGQ3cClqsqdiGFYLnA
	ZHXKMMFTtDhciEL1bQMYM4k1I81mz4Cam7oWfRGm0MEtdurX4JyPNbxdzfkKwoG3tj+mGD
	w7jv2kO4Z0VdfmhZA1qT/Gk7R2LeaUA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-IQngwOwjODCe21CBG_cmOw-1; Tue, 15 Oct 2024 06:55:05 -0400
X-MC-Unique: IQngwOwjODCe21CBG_cmOw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d603515cfso1258958f8f.1
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 03:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728989704; x=1729594504;
        h=content-transfer-encoding:to:organization:autocrypt:subject:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jN1OJwkAaGQtDrGUKrfe0W75Miaqbm3zRcU4TMBZuwE=;
        b=cNdnOAO6mF9RTOr7gt6AuK9zghCOHlBAO1XNILepHwS8Rk1TBsOYuGZuPTenxvU2q7
         H6FCjl4p8WGk0LSQFU/EozKeIJXUzUYOThYtVRAU7+bB03K5DAPCVsM4B8H2LDtPJy1r
         cs7SDe64l3rlaLCCm+sG6Z8sp+DQhrwmF5JxbefFqvfu+b507XTR6X/BeCl3gTKgPoye
         CixsqQCLUqyu9p4TPfyaHYXTd9VKfBUzhmwGk4ycYi8tT8iSZE9P1YWd80bTItIlH7Dr
         ISEEJq4vffQwzTkGxzKxK0DsS0lvOnJRIOeiCzEQ++RG0PV8I2Wl+LpVAOFiWwu0NgAX
         Yhzw==
X-Forwarded-Encrypted: i=1; AJvYcCU6y9Ik1Ivk0UeIhXjR1lJfVyN0idzsLTa2rJEH09CiT+lu5BZLrDrAA5JY2WLCbf87ykQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrXlorTeA2/4++9Hf5qDjw4iptK3xxbj8GiQOQsF81/qs1v0T5
	wLCjPtEZTqEey/GDKBK039739ZBpApZ0w2141xA3OlIc3cc6KP6SH3Mp+QMru/NIAzOmE0zBk2N
	f7aubFTksILZ49SbEEh/aeD5YlgihR1iGromndvhkIt0KtStgTg==
X-Received: by 2002:a5d:420f:0:b0:37d:446b:7dfb with SMTP id ffacd0b85a97d-37d5ff8d7e6mr6627863f8f.45.1728989704124;
        Tue, 15 Oct 2024 03:55:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+FpmtwsFeYVZ4qyxXjmj/bglI2Z/vCGwWlSce0jMhKU0kNC4AXcelBOe/4Li5vu4xNs79+g==
X-Received: by 2002:a5d:420f:0:b0:37d:446b:7dfb with SMTP id ffacd0b85a97d-37d5ff8d7e6mr6627842f8f.45.1728989703672;
        Tue, 15 Oct 2024 03:55:03 -0700 (PDT)
Received: from ?IPV6:2003:cb:c730:9700:d653:fb19:75e5:ab5c? (p200300cbc7309700d653fb1975e5ab5c.dip0.t-ipconnect.de. [2003:cb:c730:9700:d653:fb19:75e5:ab5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fa7a1c8sm1255957f8f.21.2024.10.15.03.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 03:55:03 -0700 (PDT)
Message-ID: <df619e65-e65e-4856-b4ca-9938e8e08f18@redhat.com>
Date: Tue, 15 Oct 2024 12:55:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2024-10-17
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
To: linux-coco@lists.linux.dev, KVM <kvm@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

as discussed [1], we'll get started with a bi-weekly guest_memfd
upstream call this Thursday, 2024-10-17 at 9:00 - 10:00am (GMT-07:00)
Pacific Time - Vancouver.

We'll be using the following Google meet: http://meet.google.com/wxp-wtju-jzw


Current upstream proposals that we'll likely discuss to some degree (and that
might be reasonable to look at) are:

* mmap support + shared vs. private [2]
* preparations [3] for huge/gigantic page support [4]
* guest_memfd as a "library" to make it independent of KVM [5]

There is a public calender entry [6] for the meeting, but Google might
only show it as "busy" although it is properly marked as "public". If
you want to a proper google calendar invitation that also covers all
future meetings, just write me a mail.

Cheers,

David


[1] https://lkml.kernel.org/r/4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com
[2] https://lkml.kernel.org/r/20241010085930.1546800-1-tabba@google.com
[3] https://lkml.kernel.org/r/cover.1728684491.git.ackerleytng@google.com
[4] https://lkml.kernel.org/r/cover.1728684491.git.ackerleytng@google.com
[5] https://lkml.kernel.org/r/20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com
[6] https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=YmNqb292ajc4b2gxbXZhdmdwODRob3E3MG9fMjAyNDEwMTdUMTYwMDAwWiBjXzcyMTNiN2RiYjY0OTc2YTgxZGNjODljYzIzYzZhZGY4MzExZjRjZWI5MTM0NWI2NTY1YzI2MTUwYzZiNGVjOWVAZw&tmsrc=c_7213b7dbb64976a81dcc89cc23c6adf8311f4ceb91345b6565c26150c6b4ec9e%40group.calendar.google.com&scp=ALL

-- 
Cheers,

David / dhildenb


