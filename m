Return-Path: <kvm+bounces-11163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3183A873CA6
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54AEB1C20E0A
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBE4137931;
	Wed,  6 Mar 2024 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b0HLmXZv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C2AD534
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709743995; cv=none; b=jRScOt6xNp8Cs1+hJQqumH3Echp8mV1FMGsWyMC0J+LRBGHTgNsaEZbleI503ZlAdFSdqXrS238rYlXWzxYltdMou5TcnBfEoW9vSsvkwMwt1rov/bzTH3viN4nnjIOLQIsrt8y/ULblCdGQSJwmPDanUzQ4I/6KfZVRrMm57gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709743995; c=relaxed/simple;
	bh=6SB+uyvwTQXeMGEdssSTknSpAo9HcAwnJO/vLjPujX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhSjpyxcLCsHomxdIOG2fe5VzMmrxcGBWC+KUvI1EMhVLbSWvzHD8mO2Wri9sGysQURrFtj8LB0yXJT4SOicXSzr7/Ws7tsIrLtIYLhpJyj8kxeCTQkCG2t4RSg3V5sEHpLp5FG12zYntw0FPVSTrBwwr89v7FZp482pZTxvAZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b0HLmXZv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709743992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WutCinmYz1M7S4R9mNKtvtvrjQFirF94DXtp/OLsS34=;
	b=b0HLmXZvNwsZ0DicIn7WLJ7eURO1z092wdeIln3Zyf5JMHXI/7ospasl2erGds9r6tPDe4
	DBafk7kuV7+4ykE2SCqvzxapPTcd0NfIUnr2hv+fAUP+vah5JBUVxuSsfd6aMJ/aL+Nsri
	p4AOk5RwtWwESqRj4e30Uy9SrZJ1N20=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-nzcKgQPzPMyJmab4Iv0b5w-1; Wed, 06 Mar 2024 11:53:10 -0500
X-MC-Unique: nzcKgQPzPMyJmab4Iv0b5w-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-56484d05dcaso3546054a12.0
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:53:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709743989; x=1710348789;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WutCinmYz1M7S4R9mNKtvtvrjQFirF94DXtp/OLsS34=;
        b=eGo0/Gg2hA1ecTyuklyoQo3wLVmlYUfTMsO5ywFlR5lkVERM3SPay0Qs1bFFkDgQ1C
         UQNg0M3KCaYyeYqmMqkki/X75aenLzph6Bp3Se5IOJFo5vZCTya6W40fzdHAJjt4eGJJ
         m9bs9jlrT4uwgQkunHQf/nrv6aBzEiEPya2UIjnDIwcGsZ5PcQziIQjr5oMKoefRC6MT
         5AqrLJ9wHsgUW99nH9RdQkhIKfD05TxHDXjbK5mccxSGIVj4E0afZDLkofz3mRCY4UUG
         gO7rOSUx02x02cweStmotjpc8b5yqdtgCQjJz7x6/ehPXa6ma545ljP0pBCgwjHu6pNz
         PQwg==
X-Forwarded-Encrypted: i=1; AJvYcCXr+Qd5XOgcMBTucQEvNOaFlA526wI/MJAZY2WjEz0V2qh4xQ9b2ltWnXRWOaLdqBhcIoTNrn2Dm5RKN9hML/d6ZMUs
X-Gm-Message-State: AOJu0Yxbjf/4aiJqAddt+f79Q+3zNACe3wa5cgBQf+9Ikls2KSpNQ+x7
	UwIXeGYWc09XqCFp3Qq7vq0g/8mwXyLqtfgTv2e1XJ3XoI2dGX3KwZKW1YRzoMT9FXjKCLWVJwZ
	BI2qz5FcC2xTC0DkKMqysy+WhB7c4zfAM3pwFTT+md2fiHRONmg==
X-Received: by 2002:a05:6402:b6e:b0:567:6a67:664e with SMTP id cb14-20020a0564020b6e00b005676a67664emr5496809edb.34.1709743989703;
        Wed, 06 Mar 2024 08:53:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0ZAwykGq5coisNisdkWKGr0v1zQ1r5R2rU52uz15Lq6vXH1hNu1l+xgRAW+1GduwlQVwt6w==
X-Received: by 2002:a05:6402:b6e:b0:567:6a67:664e with SMTP id cb14-20020a0564020b6e00b005676a67664emr5496787edb.34.1709743989182;
        Wed, 06 Mar 2024 08:53:09 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id fe3-20020a056402390300b00567c34d8a82sm1335445edb.85.2024.03.06.08.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:53:08 -0800 (PST)
Message-ID: <8bfad1f4-8fcb-42ad-ad43-80a72a448959@redhat.com>
Date: Wed, 6 Mar 2024 17:53:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 07/18] target/i386/kvm: Remove
 x86_cpu_change_kvm_default() and 'kvm-cpu.h'
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-8-philmd@linaro.org>
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
In-Reply-To: <20240305134221.30924-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> x86_cpu_change_kvm_default() was only used out of kvm-cpu.c by
> the pc-i440fx-2.1 machine, which got removed. Inline it, and

s/Inline/Make it static/ ?
(since it is not a real inlining here)

> remove its declaration. "kvm-cpu.h" is now empty, remove it too.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/kvm/kvm-cpu.h | 41 ---------------------------------------
>   target/i386/kvm/kvm-cpu.c |  3 +--
>   2 files changed, 1 insertion(+), 43 deletions(-)
>   delete mode 100644 target/i386/kvm/kvm-cpu.h

Reviewed-by: Thomas Huth <thuth@redhat.com>


