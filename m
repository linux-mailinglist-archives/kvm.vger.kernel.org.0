Return-Path: <kvm+bounces-11642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A099878EEA
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 07:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF2D728227F
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 06:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB3A86994D;
	Tue, 12 Mar 2024 06:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DBvf4xGe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CB74438E
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 06:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710225950; cv=none; b=OXDIVZTJ0bj8Vn6sC3FVx9TqvSi2FXYqdEUyO0qF2VEfEi/nbxXPnn2Jn0ErjBEwBsKWNHgL28IEVTIILF8ptqEXncgsxGntOkdHjw7eQ0wON6pjBUyDRk6E02T0LUZ0794brXst92B99pyuadFWcPR9ID32DJcZ2ka0JoSvIXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710225950; c=relaxed/simple;
	bh=q3qqK7M8lRs2XnHgynxzZIzxNIKV4TMfCEVrCXTxxUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CCbItnmOCr7T/c2xpAQdrLa+dQsvfxN5QDIxcCVGO5tunMMujYSjdlgFEKOirsUXbp5Qdr3EhwRmaViGvkI61sxejEdNNlq6M4xLtnXL2LRjHv0uoGXIy+EWn/mvr8aewUpBWHlzHd3eBUy4OX6ocYS8Q114FnpftB/eGTA935A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DBvf4xGe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710225946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cAyR2wffVwGsBPNJimSA8gIGWWDlVfzkxPaVQEX67yA=;
	b=DBvf4xGep/3INVD/WkJuJeWyqHa6hgINVNE02lhRfS/Mmd/LGqiH0IdQoAursJ0WPFdXxQ
	CGfVbESbwBcCc4ENE/yzmFGMlA+8K6s+O/rPEg4vVMJ+sY2WxC8PaGA9UZUeJeZnX9spvC
	DjHOP7GshZYuutdHKKQVAfBMmH1sRAY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-UdG1BO--Pvm22Z-VUUstRg-1; Tue, 12 Mar 2024 02:45:44 -0400
X-MC-Unique: UdG1BO--Pvm22Z-VUUstRg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7882536af06so523004285a.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 23:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710225944; x=1710830744;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cAyR2wffVwGsBPNJimSA8gIGWWDlVfzkxPaVQEX67yA=;
        b=Zbgd5UjyQp2INXBSSmAKR+Oq0IQEI/Tzz0B4Aq8pIJcBPhuV5eewGhbqfNId452aUZ
         zWU7ujgiBZFfTP4ZYPFNibXI5gqbIW0cGKxpAuQRLg9uyJPKm9CEaTZwD0vmUmhYjfG9
         uPo7wufdjVJnIDMqYIBJ3SOYI4dzW4b/gp1OldIjZarbcppejnlhWUOu3MdVbBBzN8ka
         fI3nAjey1tKmcuDqs3RwteqGEORnUkcmqaf4Hvn5VDlpkZM5277oqzbYliHF4uGfbkVV
         lz9nqaZ+BZeVwLa5ceE5JONuBYxXNgSOdJUyf/xkPR5I8YujUInW5HckY8fnJYL2KCJs
         1k1A==
X-Gm-Message-State: AOJu0YwF1G9R+RrxRRCl+rCfkkoW2dUx86TmOUvTCFWMKSEyyiQutS24
	q8vqjAqvGegHKoOTuJJYX/A4b8Hpoge8m7kyMCVpbtPCLslEQV88giwspysBJ2NFfLWWwAFDMTE
	1jNFmAQ3hfQOAZBAKWBqpTnjhA+s0lRNBwTB+RGwCmI4YrNX5tEXf1V4xMw==
X-Received: by 2002:a05:620a:3729:b0:788:471c:5f56 with SMTP id de41-20020a05620a372900b00788471c5f56mr11406521qkb.59.1710225944018;
        Mon, 11 Mar 2024 23:45:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnOuR7HIbvQXjsvykfSP/TX+b+pv/rlTbtoGt2NKZVL5WZR9MBj2CBnoFAyZ/jzoSpCYxgDA==
X-Received: by 2002:a05:620a:3729:b0:788:471c:5f56 with SMTP id de41-20020a05620a372900b00788471c5f56mr11406514qkb.59.1710225943789;
        Mon, 11 Mar 2024 23:45:43 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-177-86.web.vodafone.de. [109.43.177.86])
        by smtp.gmail.com with ESMTPSA id d22-20020a05620a241600b007883744ded4sm3436085qkn.16.2024.03.11.23.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 23:45:43 -0700 (PDT)
Message-ID: <4a2354b7-df7b-4371-a4fa-d1da29ae4dd3@redhat.com>
Date: Tue, 12 Mar 2024 07:45:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v1] arch-run: Wait for incoming socket
 being removed
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>, Nico Boehr <nrb@linux.ibm.com>,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20240305141214.707046-1-nrb@linux.ibm.com>
 <CZRKBTZFFB9Y.38GVXEXZPOVK5@wheely>
From: Thomas Huth <thuth@redhat.com>
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
In-Reply-To: <CZRKBTZFFB9Y.38GVXEXZPOVK5@wheely>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/03/2024 07.37, Nicholas Piggin wrote:
> On Wed Mar 6, 2024 at 12:11 AM AEST, Nico Boehr wrote:
>> Sometimes, QEMU needs a bit longer to remove the incoming migration
>> socket. This happens in some environments on s390x for the
>> migration-skey-sequential test.
>>
>> Instead of directly erroring out, wait for the removal of the socket.
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> 
> It's interesting that the incoming socket is not removed after
> QMP says migration complete. I guess that's by design, but have
> you checked the QEMU code whether it's intentional?
> 
> I guess it's code like this - in migration/migration.c
> 
>      /*
>       * This must happen after any state changes since as soon as an external
>       * observer sees this event they might start to prod at the VM assuming
>       * it's ready to use.
>       */
>      migrate_set_state(&mis->state, MIGRATION_STATUS_ACTIVE,
>                        MIGRATION_STATUS_COMPLETED);
>      migration_incoming_state_destroy();
> 
> So, it looks like a good fix. And probably not just s390x specific
> it might be just unlucky timing.
> 
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

All right, I pushed this as a fix now to the repository.

  Thomas



