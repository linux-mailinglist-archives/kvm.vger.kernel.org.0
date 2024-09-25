Return-Path: <kvm+bounces-27406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22ED7985431
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 09:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA8FC284B78
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 07:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9755155335;
	Wed, 25 Sep 2024 07:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ceKfZZjj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4806D1B85D5
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 07:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727249515; cv=none; b=hrpiyiDwJrJ8H2J1kCVv2vTSKqTEmhbW5W8IggTxBv3NzcVs9LsO9E0+9Ed1UDR2DJkB8nBmXSCEp5EobNLAMY+eCQgxrgafRs4q82l+RrBEffK1YbYeKxm1CdWdWJ3qv/LavVVzu+yhSQS8Kqy7x86HpbBODtLwacDYclYhUaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727249515; c=relaxed/simple;
	bh=OcL41Y77SFLZrfjdLpw5kFSO6voQ/BL8OaXVYT9oRcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hv8DpAp3Lts5WZqIbCMjaBxNJ9xSFQxqq+G4PtLkID93AJB1NB+bKwXksYfAqJ9N1crGD2Q/j4qiXPWhe3IRJwqZcYpD1QTolPY41tR1uXN60QE+LDOQhPqvqtw9tu80qbtb5jmbbx4u8jodZ/M7O3UGzuTb6bPTTmE6KKFdj/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ceKfZZjj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727249512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=775ElXofw3u85XCdpZxWTDnsgjCZPpsIz/thUyanx1M=;
	b=ceKfZZjjSAaWIWfnu9yroE46ImbdN51SPx17Ch9mzwvhtn4PijZtsNLiCWSMmi6ZIqa1XM
	Or0hKEE3dUzcrb8wH/O9neXphWzthqFTD+fK/oK0uGvHiUf/BOTJBoykDhMPNuSFud0nNe
	jN9+YWXhFcvLI20hpAwQK89jWq5ZSKw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-vqSWCvTdORCaS-yVQPJOkw-1; Wed, 25 Sep 2024 03:31:50 -0400
X-MC-Unique: vqSWCvTdORCaS-yVQPJOkw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374c90d24e3so4495986f8f.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 00:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727249509; x=1727854309;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=775ElXofw3u85XCdpZxWTDnsgjCZPpsIz/thUyanx1M=;
        b=BhHxn2EVrLbNkiYmUaDyMcb8z1d9quW5SeiOolN7aRZ5McYOF0oSQ+VOV1Z84Lo032
         5RdH7cHyLEG5pHWriMF1GsESBVclz4DcJSbKcFaYM7QHv22FvY35H7J2ptOPuxbjfWKi
         i0Z/GuHxaZva0wHf+GN60b8TIaKNFeEm6TYFNe2845OW76tXXO8qBCPKoxeOVexWjbzM
         vp4dkXKZpnETCe4FdLjvCTTFZdGDFNfU5Y02DCx/KG9MElkvmWcRxX2w4AoqYrW9yCsY
         Rn5ZapTTloLQvw7L2+YEWf6DskLZkkoGa8PWP7X+t+ce/sJly6gVcWapGmu/pjXF7Hsm
         uZyA==
X-Forwarded-Encrypted: i=1; AJvYcCXZ9lAVbPsAesXmTi1K5EB8cbE//gW/6seokuA1WOqtgINqps4dxGWTTw1S41uYcGoKPIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhI2JuUXKyUWRMetibZZBgAJj6BeHhsG3hgw5bu9uQBnllHgcZ
	CInYQckwiVaNdf80HVBBlNfo/IHSqgGiShCP+EPGxZ9junK6edV4xj0Z3WhRRmAMT/NXyEZoogL
	EMAR5rpuiRMMpFiIJ24Jf34YPzKBoSuiAu8mHNBrNnNARMqgpaw==
X-Received: by 2002:a05:6000:1206:b0:374:c6b8:50b5 with SMTP id ffacd0b85a97d-37cc24690e8mr1624800f8f.17.1727249509403;
        Wed, 25 Sep 2024 00:31:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmJDTJHxsX9hvmBigbPA1lcDhl5Oa4rKww6Gu4r+PzqF2ZKut90CGn2oQdvi+Bke2h53P8oA==
X-Received: by 2002:a05:6000:1206:b0:374:c6b8:50b5 with SMTP id ffacd0b85a97d-37cc24690e8mr1624777f8f.17.1727249508981;
        Wed, 25 Sep 2024 00:31:48 -0700 (PDT)
Received: from [192.168.0.7] (ip-109-42-48-176.web.vodafone.de. [109.42.48.176])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2c1f80sm3222762f8f.44.2024.09.25.00.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2024 00:31:48 -0700 (PDT)
Message-ID: <efe97f3d-2cbe-4fc3-98cf-17ed2c65a09d@redhat.com>
Date: Wed, 25 Sep 2024 09:31:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] build qemu with gcc and tsan
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-s390x@nongnu.org, Beraldo Leal <bleal@redhat.com>
References: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
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
In-Reply-To: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/09/2024 19.40, Pierrick Bouvier wrote:
> While working on a concurrency bug, I gave a try to tsan builds for QEMU. I
> noticed it didn't build out of the box with recent gcc, so I fixed compilation.
> In more, updated documentation to explain how to build a sanitized glib to avoid
> false positives related to glib synchronisation primitives.
> 
> v3
> - rebased on top of master
> - previous conversation shifted on why clang does not implement some warnings
> - hopefully we can review the content of patches this time
> 
> v2
> - forgot to signoff commits
> 
> Pierrick Bouvier (3):
>    meson: hide tsan related warnings
>    target/i386: fix build warning (gcc-12 -fsanitize=thread)
>    docs/devel: update tsan build documentation
> 
>   docs/devel/testing/main.rst | 26 ++++++++++++++++++++++----
>   meson.build                 | 10 +++++++++-
>   target/i386/kvm/kvm.c       |  4 ++--
>   3 files changed, 33 insertions(+), 7 deletions(-)
> 

Series
Reviewed-by: Thomas Huth <thuth@redhat.com>


