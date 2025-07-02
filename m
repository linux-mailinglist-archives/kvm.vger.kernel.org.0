Return-Path: <kvm+bounces-51262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC5B9AF0CC3
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FD283A8743
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 07:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FB722F384;
	Wed,  2 Jul 2025 07:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMTP1zEk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE0923B0
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 07:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751441959; cv=none; b=l5p7Qm3bPW1neJGLkHsZwS/3XqwM5oSZSUiaqc8+sqTm33OCv7Q6re5nZwXoaVRNX7AImw5ka2R9FebXVK13jjO073U+TQM990bVfRWGO5GACSeUGrPs/mvS0qGOiMIWlLSi9RoT4LbycMyUGtFh1nva0vxdZ0VFQOD9G/HL+t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751441959; c=relaxed/simple;
	bh=ovtVplPQhAY0UifFyl3N1omOoVf+qenfZrucfQTIzmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PfjWmnn6nYW47qLs4WIEe34rgoHG2E2CYTSHxu0qy+ReGLkmIuht5ydlB7Kt6oUwzhlwxSD/O30QA/eOJCYtNsuJQfTvxJGjzNzgZtY1O4B1r/lr4v9C7tyxiPNhNgT/yiJa0y+f9xlrRkawKKX4cAYnMymYPo/P96vIGj9D7To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMTP1zEk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751441955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MFFC24a42677G3+CnjlHRqWhcJLJq82C9B9KVkAooNM=;
	b=FMTP1zEkg76CWoXIxoc9S6cGlnG7ZQ4xd6/azu55VmAvrw+uqeW3R5hdKo8piUTDSVIuyC
	JfVthAWbmCahNwx6MZ+8fw3nFE3ZEEUGncv2WdRCEaMOi2Zr1fF0A12rJO7cLS8J1Ja/qD
	tLuiJdo8SBWdzdBAkYig2dq4sm3vGMk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-kcJ_dXIxN5OdwRDPpoI2iQ-1; Wed, 02 Jul 2025 03:39:14 -0400
X-MC-Unique: kcJ_dXIxN5OdwRDPpoI2iQ-1
X-Mimecast-MFC-AGG-ID: kcJ_dXIxN5OdwRDPpoI2iQ_1751441953
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so32260195e9.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 00:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751441953; x=1752046753;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MFFC24a42677G3+CnjlHRqWhcJLJq82C9B9KVkAooNM=;
        b=gX1cZTdmmN+SJ8VivteCv+R4HgPFlHv9Ug5PwwaUd3tBeH0xmSYE9JlB3kTEvGrwA9
         e0scaw9+nQc/bA9Vyp80Vgv9tACB0WAa5Oxb9jMPwyO/C2rJ7k6SfwtWAchA8gtp8KpH
         mtAEAJwj+uP5FIH2yQmx0rqfX6vhgb3s3Mqe6ryYqWmqqHgxHIg31RVFvkRNSC7H9EQh
         w4Tie421tipscCEHQvwacza1SXEeZSh6xo1cA/hPFZdZW0QtKGqKrAPYatfHGLyxJZcN
         mhwEis+0a/7xGr0iMW09ng+npUDINnLKO0sgqC/TZALnbvDIOZFxIWlMWOzjoGqo7uuR
         ARfA==
X-Forwarded-Encrypted: i=1; AJvYcCUXIjoNDYeeTI/3l/iWoH9yRf0JXf+wn2PGUzH+4jp/nLNdYCrbRYiKwWXCCCH7MxpX854=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy53tydlS0NKiO5MhggyELrklARKTb8qj/Wcp5tzkwe4LQ3H4FH
	78lv+FCJI2BWTaf8mv2j0qzrakFmNJn0jqSv3Trf1HN3hXB8T1Wr9bYlAUtzbdxrMRAkns+oezP
	LyPsP8mgUXM1Czy0jn/5e4gBkxnTgd+bAteoj3mpRTdRcxNRwSN40v50o9c1QKQ==
X-Gm-Gg: ASbGnctqHeo6iGvNI8Oe7rkcteulyxuzqEs7FlD6ctC0AVN/2q34wJYvmKbZPEOsXnM
	o4DespT1ry0RBfz46rJj+O5nzV8+qcAxQ3hdKLtfc7oMk5fzgskx2B5q7cNRxQDlGAYl8py9JFn
	E5rum2WZeUGkrq6SD/yWSlpTym2MucxR354ZtLb3Lv+lgpIH0EygZirJSI4sEDMAvEfZIGWDjGu
	CM6UzE3mOB3DB9t7+JZI209vpErB4pSSGM6osNoJYv+ZO9aMvyavDRF91AxNPWILsxyYI9wFQ1/
	VYAceZ5PosfdvYUzytwnj5ldJJGBmJzvMtV3XSpNTh32dndlJoA9N4CmU+UlEQ==
X-Received: by 2002:a05:600c:8212:b0:43c:fe15:41dd with SMTP id 5b1f17b1804b1-454a36ddc52mr19288785e9.6.1751441952679;
        Wed, 02 Jul 2025 00:39:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHC2bP1Kz4XeukoshoBgagEE4nuhX+ShqgPuG/7LrCtZT9jr/5GuwsYa/a2qr65eIrItc54dg==
X-Received: by 2002:a05:600c:8212:b0:43c:fe15:41dd with SMTP id 5b1f17b1804b1-454a36ddc52mr19288445e9.6.1751441952232;
        Wed, 02 Jul 2025 00:39:12 -0700 (PDT)
Received: from [192.168.0.6] (ltea-047-064-114-041.pools.arcor-ip.net. [47.64.114.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538a406489sm192948635e9.27.2025.07.02.00.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 00:39:11 -0700 (PDT)
Message-ID: <3b98464f-54f8-4977-9e87-a144277da264@redhat.com>
Date: Wed, 2 Jul 2025 09:39:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] accel/kvm: Adjust the note about the minimum required
 kernel version
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-stable@nongnu.org,
 qemu-trivial@nongnu.org
References: <20250702060319.13091-1-thuth@redhat.com>
 <aGTU2enBBQj7lu3E@intel.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 xsFNBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABzR5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT7CwXgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDzsFN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABwsFfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
In-Reply-To: <aGTU2enBBQj7lu3E@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/07/2025 08.42, Zhao Liu wrote:
> On Wed, Jul 02, 2025 at 08:03:19AM +0200, Thomas Huth wrote:
>> Date: Wed,  2 Jul 2025 08:03:19 +0200
>> From: Thomas Huth <thuth@redhat.com>
>> Subject: [PATCH] accel/kvm: Adjust the note about the minimum required
>>   kernel version
>>
>> From: Thomas Huth <thuth@redhat.com>
>>
>> Since commit 126e7f78036 ("kvm: require KVM_CAP_IOEVENTFD and
>> KVM_CAP_IOEVENTFD_ANY_LENGTH") we require at least kernel 4.4 to
>> be able to use KVM. Adjust the upgrade_note accordingly.
>> While we're at it, remove the text about kvm-kmod and the
>> SourceForge URL since this is not actively maintained anymore.
>>
>> Fixes: 126e7f78036 ("kvm: require KVM_CAP_IOEVENTFD and KVM_CAP_IOEVENTFD_ANY_LENGTH")
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   accel/kvm/kvm-all.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> I just mentioned the kernel version in another patch thread. I found
> x86 doc said it requires v4.5 or newer ("OS requirements" section in
> docs/system/target-i386.rst).

Looking at the original commit that introduced this message (commit 
483c6ad426db), this seems to apply to x86 only ... I guess there's a chance 
that KVM still works with kernel 4.4 on other architectures.
But I don't mind too much - we can also say 4.5 here to have a unified 
value. Paolo, any preferences?

  Thomas


