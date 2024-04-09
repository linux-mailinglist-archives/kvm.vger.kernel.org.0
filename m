Return-Path: <kvm+bounces-13970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8271F89D1F2
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 07:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A64F31C21E68
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 05:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4B564A9F;
	Tue,  9 Apr 2024 05:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DMMwsDc/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2102D5B1EA
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 05:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712640840; cv=none; b=DZHE/9BPRyyBGbeObkSLmqciaX1SD/Nv7N7zq9LdpCpk0kwZ6wEj8ajlWtjpqB4BVYyIZjE9pVCFEjrcfZ4Ss2mT8pL5DNV9NTd4cOd33S0aORBhjhzHTYfgBkANlHaU/1W7Hg33bqnpC2g1yw+HPDLqMS7WzWLSNTzooKwn930=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712640840; c=relaxed/simple;
	bh=nn4os5w+ULhXvxVkupj+9zJVvAVyQPKM58KO48di6Mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pjNhm1K17wOSB8UUhfzfDWCRtI2KaUd3uam3kzhc5tdJtacdbO2Fe2n4DV9rmcOSpQ+oLzHHD7pukYrafAT8jkEp4YWoWEoJYd50OYioq5HkHQswk5O2gGX1MBn9BW+SoKqICNy/jiKowNS6HJ9BjRF954QcRkuKUNEvm1f9cVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DMMwsDc/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712640837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VTlJmUcuqdqbb2DO2oWh5P5iMAR2b68dffZSl9tVCb4=;
	b=DMMwsDc/LMXeUZoCJPBez9Xoj9XNU50hBDzg4LipvirKcXBgSZFoBujiTSl6mB/KhmNaq1
	uIIE2cxMWE1+smA39zrSUt63pbDehggzrjHBrYvXpwL1JklnJdr/uxYFs9+kQ65l0ygdNS
	1qwI0bu06S2d7RmczdpnkVl8Yv3Dd6I=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-roAN7C8FNN2CmGdooVpggA-1; Tue, 09 Apr 2024 01:33:55 -0400
X-MC-Unique: roAN7C8FNN2CmGdooVpggA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d87257c610so30016471fa.2
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 22:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712640834; x=1713245634;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VTlJmUcuqdqbb2DO2oWh5P5iMAR2b68dffZSl9tVCb4=;
        b=H+q/szpKMCa96u7+Uk1GNuLloUssoIPxdFsdzTN6SlM2mXblwwnR37uccxDL1zvz9d
         v/cF5R3DUJlUQf6UR64/cjd9RSyBK6Wxxrxm2jV+u9dIPuD+h1roWFGQHvKjxcFQLVQS
         8xUgmE7CZaCDyjd6GKaLJuS2vmpiojZDCEl0NY5+0/vsxpQqESgVpaXzM1Um8Bkmisyn
         sTDuDbOXlo+8L++tr1WGDXiKnECC95Mbb585Ty+gEqw+DCPjFP2/sN1hVeX9ZVur3dTD
         OYs+8VNnrdEmzrWBJKDFacqykT0oapHqFKal0BUk0J+NcJQoqe45WK82Jht8RASHyYOY
         ov5g==
X-Forwarded-Encrypted: i=1; AJvYcCXuGC0s4QgTn7W2LgcVlP2RLBhDLui0p37+MFHBY9XFBDYRbyuhsV7Ly2yWD1+TZblzRuKdnSHIYZVDwRue2e0HYdEA
X-Gm-Message-State: AOJu0Yzjm5uJxE61g9G0OzssYMDgS7ECH8GeC+IRz9qfx8UkkQvBOGa8
	4N/ohiSEFP7b4GfTGDPieGeB7ganR02XHEoL5k113cDs8ycZKsOfi6P1vOjYPAqGykzByjtBDIF
	QkisZi0ItzRSihuJJavpso2GVZ80Mzcke2MLdfGmriPZZbg8dWQ==
X-Received: by 2002:a05:651c:221a:b0:2d8:5a4b:17b1 with SMTP id y26-20020a05651c221a00b002d85a4b17b1mr11808248ljq.15.1712640833906;
        Mon, 08 Apr 2024 22:33:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAxaCTzyuY3GaUSfgrkqOszSLbyR62j6M7S2OrrIF2XXyRpNoKxywANM8iF4TlA7Re22BJSg==
X-Received: by 2002:a05:651c:221a:b0:2d8:5a4b:17b1 with SMTP id y26-20020a05651c221a00b002d85a4b17b1mr11808232ljq.15.1712640833446;
        Mon, 08 Apr 2024 22:33:53 -0700 (PDT)
Received: from [192.168.42.203] (tmo-067-118.customers.d1-online.com. [80.187.67.118])
        by smtp.gmail.com with ESMTPSA id x1-20020a170906134100b00a519ec0a965sm5188559ejb.49.2024.04.08.22.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 22:33:52 -0700 (PDT)
Message-ID: <d1a76e23-e361-46a9-9baf-6ab51db5d7ba@redhat.com>
Date: Tue, 9 Apr 2024 07:33:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org
Cc: Eric Auger <eauger@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240409024940.180107-1-shahuang@redhat.com>
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
In-Reply-To: <20240409024940.180107-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/04/2024 04.49, Shaoqin Huang wrote:
> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
> which PMU events are provided to the guest. Add a new option
> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
> Without the filter, all PMU events are exposed from host to guest by
> default. The usage of the new sub-option can be found from the updated
> document (docs/system/arm/cpu-features.rst).
> 
> Here is an example which shows how to use the PMU Event Filtering, when
> we launch a guest by use kvm, add such command line:
> 
>    # qemu-system-aarch64 \
>          -accel kvm \
>          -cpu host,kvm-pmu-filter="D:0x11-0x11"
> 
> Since the first action is deny, we have a global allow policy. This
> filters out the cycle counter (event 0x11 being CPU_CYCLES).
> 
> And then in guest, use the perf to count the cycle:
> 
>    # perf stat sleep 1
> 
>     Performance counter stats for 'sleep 1':
> 
>                1.22 msec task-clock                       #    0.001 CPUs utilized
>                   1      context-switches                 #  820.695 /sec
>                   0      cpu-migrations                   #    0.000 /sec
>                  55      page-faults                      #   45.138 K/sec
>     <not supported>      cycles
>             1128954      instructions
>              227031      branches                         #  186.323 M/sec
>                8686      branch-misses                    #    3.83% of all branches
> 
>         1.002492480 seconds time elapsed
> 
>         0.001752000 seconds user
>         0.000000000 seconds sys
> 
> As we can see, the cycle counter has been disabled in the guest, but
> other pmu events do still work.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> v8->v9:
>    - Replace the warn_report to error_setg in some places.
>    - Merge the check condition to make code more clean.
>    - Try to use the QAPI format for the PMU Filter property but failed to use it
>    since the -cpu option doesn't support json format yet.
> 
> v7->v8:
>    - Add qtest for kvm-pmu-filter.
>    - Do the kvm-pmu-filter syntax checking up-front in the kvm_pmu_filter_set()
>    function. And store the filter information at there. When kvm_pmu_filter_get()
>    reconstitute it.
> 
> v6->v7:
>    - Check return value of sscanf.
>    - Improve the check condition.
> 
> v5->v6:
>    - Commit message improvement.
>    - Remove some unused code.
>    - Collect Reviewed-by, thanks Sebastian.
>    - Use g_auto(Gstrv) to replace the gchar **.          [Eric]
> 
> v4->v5:
>    - Change the kvm-pmu-filter as a -cpu sub-option.     [Eric]
>    - Comment tweak.                                      [Gavin]
>    - Rebase to the latest branch.
> 
> v3->v4:
>    - Fix the wrong check for pmu_filter_init.            [Sebastian]
>    - Fix multiple alignment issue.                       [Gavin]
>    - Report error by warn_report() instead of error_report(), and don't use
>    abort() since the PMU Event Filter is an add-on and best-effort feature.
>                                                          [Gavin]
>    - Add several missing {  } for single line of code.   [Gavin]
>    - Use the g_strsplit() to replace strtok().           [Gavin]
> 
> v2->v3:
>    - Improve commits message, use kernel doc wording, add more explaination on
>      filter example, fix some typo error.                [Eric]
>    - Add g_free() in kvm_arch_set_pmu_filter() to prevent memory leak. [Eric]
>    - Add more precise error message report.              [Eric]
>    - In options doc, add pmu-filter rely on KVM_ARM_VCPU_PMU_V3_FILTER support in
>      KVM.                                                [Eric]
> 
> v1->v2:
>    - Add more description for allow and deny meaning in
>      commit message.                                     [Sebastian]
>    - Small improvement.                                  [Sebastian]
> ---
>   docs/system/arm/cpu-features.rst |  23 +++++++
>   target/arm/arm-qmp-cmds.c        |   2 +-
>   target/arm/cpu.h                 |   3 +
>   target/arm/kvm.c                 | 112 +++++++++++++++++++++++++++++++
>   tests/qtest/arm-cpu-features.c   |  51 ++++++++++++++
>   5 files changed, 190 insertions(+), 1 deletion(-)
> 
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index a5fb929243..f3930f34b3 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,29 @@ the list of KVM VCPU features and their descriptions.
>     the guest scheduler behavior and/or be exposed to the guest
>     userspace.
>   
> +``kvm-pmu-filter``
> +  By default kvm-pmu-filter is disabled. This means that by default all PMU
> +  events will be exposed to guest.
> +
> +  KVM implements PMU Event Filtering to prevent a guest from being able to
> +  sample certain events. It depends on the KVM_ARM_VCPU_PMU_V3_FILTER
> +  attribute supported in KVM. It has the following format:
> +
> +  kvm-pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
> +
> +  The A means "allow" and D means "deny", start is the first event of the
> +  range and the end is the last one. The first registered range defines
> +  the global policy (global ALLOW if the first action is DENY, global DENY
> +  if the first action is ALLOW). The start and end only support hexadecimal
> +  format. For example:
> +
> +  kvm-pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
> +
> +  Since the first action is allow, we have a global deny policy. It
> +  will allow event 0x11 (the cycle counter), events 0x23 to 0x3a are
> +  also allowed except the event 0x30 which is denied, and all the other
> +  events are denied.
> +
>   TCG VCPU Features
>   =================
>   
> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> index 3cc8cc738b..6ec1d3ea3c 100644
> --- a/target/arm/arm-qmp-cmds.c
> +++ b/target/arm/arm-qmp-cmds.c
> @@ -93,7 +93,7 @@ static const char *cpu_model_advertised_features[] = {
>       "sve128", "sve256", "sve384", "sve512",
>       "sve640", "sve768", "sve896", "sve1024", "sve1152", "sve1280",
>       "sve1408", "sve1536", "sve1664", "sve1792", "sve1920", "sve2048",
> -    "kvm-no-adjvtime", "kvm-steal-time",
> +    "kvm-no-adjvtime", "kvm-steal-time", "kvm-pmu-filter",
>       "pauth", "pauth-impdef", "pauth-qarma3",
>       NULL
>   };
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index bc0c84873f..996754a9a7 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -943,6 +943,9 @@ struct ArchCPU {
>   
>       /* KVM steal time */
>       OnOffAuto kvm_steal_time;
> +
> +    /* KVM PMU Filter */
> +    GArray *kvm_pmu_filter;
>   #endif /* CONFIG_KVM */
>   
>       /* Uniprocessor system with MP extensions */
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index ab85d628a8..7a363131fe 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -496,6 +496,68 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>       ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>   }
>   
> +static char *kvm_pmu_filter_get(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    g_autoptr(GString) pmu_filter = g_string_new(NULL);
> +    struct kvm_pmu_event_filter *filter;
> +    char action;
> +    int i;
> +
> +    if (!cpu->kvm_pmu_filter) {
> +        return NULL;
> +    }
> +
> +    for (i = 0; i < cpu->kvm_pmu_filter->len; i++) {
> +        filter = &g_array_index(cpu->kvm_pmu_filter,
> +                                struct kvm_pmu_event_filter, i);
> +        if (i) {
> +            g_string_append_c(pmu_filter, ';');
> +        }
> +        action = filter->action == KVM_PMU_EVENT_ALLOW ? 'A' : 'D';
> +        g_string_append_printf(pmu_filter, "%c:0x%hx-0x%hx", action,
> +                               filter->base_event,
> +                               filter->base_event + filter->nevents - 1);
> +    }
> +
> +    return g_strdup(pmu_filter->str);
> +}
> +
> +static void kvm_pmu_filter_set(Object *obj, const char *pmu_filter,
> +                               Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    struct kvm_pmu_event_filter filter;
> +    g_auto(GStrv) event_filters;
> +    int i;
> +
> +    if (cpu->kvm_pmu_filter) {
> +        g_array_free(cpu->kvm_pmu_filter, true);
> +    }
> +
> +    cpu->kvm_pmu_filter = g_array_new(false, false,
> +                                      sizeof(struct kvm_pmu_event_filter));
> +
> +    event_filters = g_strsplit(pmu_filter, ";", -1);
> +    for (i = 0; event_filters[i]; i++) {
> +        unsigned short start = 0, end = 0;
> +        char act;
> +
> +        if (sscanf(event_filters[i], "%c:%hx-%hx", &act, &start, &end) != 3 ||
> +            (act != 'A' && act != 'D') || start > end) {
> +            error_setg(errp, "Invalid PMU filter %s", event_filters[i]);
> +            return;
> +        }
> +
> +        filter.base_event = start;
> +        filter.nevents = end - start + 1;
> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
> +                                       KVM_PMU_EVENT_DENY;
> +
> +        g_array_append_vals(cpu->kvm_pmu_filter, &filter, 1);
> +    }
> +}
> +
>   /* KVM VCPU properties should be prefixed with "kvm-". */
>   void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>   {
> @@ -517,6 +579,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>                                kvm_steal_time_set);
>       object_property_set_description(obj, "kvm-steal-time",
>                                       "Set off to disable KVM steal time.");
> +
> +    object_property_add_str(obj, "kvm-pmu-filter", kvm_pmu_filter_get,
> +                            kvm_pmu_filter_set);
> +    object_property_set_description(obj, "kvm-pmu-filter",
> +                                    "PMU Event Filtering description for "
> +                                    "guest PMU. (default: NULL, disabled)");
>   }
>   
>   bool kvm_arm_pmu_supported(void)
> @@ -1706,6 +1774,48 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
>       return true;
>   }
>   
> +static void kvm_arm_pmu_filter_init(ARMCPU *cpu)
> +{
> +    static bool pmu_filter_init;
> +    struct kvm_device_attr attr = {
> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
> +    };
> +    int i;
> +
> +    /*
> +     * The filter only needs to be initialized through one vcpu ioctl and it
> +     * will affect all other vcpu in the vm.
> +     * It can be referred from kernel commit d7eec2360e3 ("KVM: arm64: Add PMU
> +     * event filtering infrastructure"):
> +     * Although the ioctl is per-vcpu,  the map of allowed events is global to
> +     * the VM (and can be setup from any vcpu until the vcpu PMU is
> +     * initialized).
> +     */
> +    if (pmu_filter_init) {
> +        return;
> +    } else {
> +        pmu_filter_init = true;
> +    }
> +
> +    if (!cpu->kvm_pmu_filter) {
> +        return;
> +    }
> +    if (kvm_vcpu_ioctl(CPU(cpu), KVM_HAS_DEVICE_ATTR, &attr)) {
> +        error_report("KVM doesn't support the PMU Event Filter!");
> +        return;
> +    }
> +
> +    for (i = 0; i < cpu->kvm_pmu_filter->len; i++) {
> +        attr.addr = (uint64_t)&g_array_index(cpu->kvm_pmu_filter,
> +                                             struct kvm_pmu_event_filter, i);
> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU_V3_FILTER")) {
> +            error_report("KVM set the PMU Event Filter failed!");
> +            break;
> +        }
> +    }
> +}
> +
>   void kvm_arm_pmu_init(ARMCPU *cpu)
>   {
>       struct kvm_device_attr attr = {
> @@ -1716,6 +1826,8 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
>       if (!cpu->has_pmu) {
>           return;
>       }
> +
> +    kvm_arm_pmu_filter_init(cpu);
>       if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
>           error_report("failed to init PMU");
>           abort();
> diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
> index 9d6e6190d5..0b99939af3 100644
> --- a/tests/qtest/arm-cpu-features.c
> +++ b/tests/qtest/arm-cpu-features.c
> @@ -127,6 +127,17 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>       return qdict_get_bool(props, feature);
>   }
>   
> +static const char *resp_get_feature_str(QDict *resp, const char *feature)
> +{
> +    QDict *props;
> +
> +    g_assert(resp);
> +    g_assert(resp_has_props(resp));
> +    props = resp_get_props(resp);
> +    g_assert(qdict_get(props, feature));
> +    return qdict_get_str(props, feature);
> +}
> +
>   #define assert_has_feature(qts, cpu_type, feature)                     \
>   ({                                                                     \
>       QDict *_resp = do_query_no_props(qts, cpu_type);                   \
> @@ -156,6 +167,18 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>       g_assert(qdict_get_bool(_props, feature) == (expected_value));     \
>   })
>   
> +#define resp_assert_feature_str(resp, feature, expected_value)         \
> +({                                                                     \
> +    QDict *_props;                                                     \
> +                                                                       \
> +    g_assert(_resp);                                                   \
> +    g_assert(resp_has_props(_resp));                                   \
> +    _props = resp_get_props(_resp);                                    \
> +    g_assert(qdict_get(_props, feature));                              \
> +    g_assert_cmpstr(qdict_get_str(_props, feature),                    \
> +                    ==, (expected_value));                             \
> +})
> +
>   #define assert_feature(qts, cpu_type, feature, expected_value)         \
>   ({                                                                     \
>       QDict *_resp;                                                      \
> @@ -177,6 +200,17 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>       qobject_unref(_resp);                                              \
>   })
>   
> +#define assert_set_feature_str(qts, cpu_type, feature, value)          \
> +({                                                                     \
> +    const char *_fmt = "{ %s: %s }";                                   \
> +    QDict *_resp;                                                      \
> +                                                                       \
> +    _resp = do_query(qts, cpu_type, _fmt, feature, value);             \
> +    g_assert(_resp);                                                   \
> +    resp_assert_feature_str(_resp, feature, value);                    \
> +    qobject_unref(_resp);                                              \
> +})
> +
>   #define assert_has_feature_enabled(qts, cpu_type, feature)             \
>       assert_feature(qts, cpu_type, feature, true)
>   
> @@ -462,6 +496,7 @@ static void test_query_cpu_model_expansion(const void *data)
>   
>       assert_has_not_feature(qts, "max", "kvm-no-adjvtime");
>       assert_has_not_feature(qts, "max", "kvm-steal-time");
> +    assert_has_not_feature(qts, "max", "kvm-pmu-filter");
>   
>       if (g_str_equal(qtest_get_arch(), "aarch64")) {
>           assert_has_feature_enabled(qts, "max", "aarch64");
> @@ -509,6 +544,7 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>       assert_set_feature(qts, "host", "kvm-no-adjvtime", false);
>   
>       if (g_str_equal(qtest_get_arch(), "aarch64")) {
> +        const char *kvm_supports_pmu_filter;
>           bool kvm_supports_steal_time;
>           bool kvm_supports_sve;
>           char max_name[8], name[8];
> @@ -547,15 +583,29 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>            * because this instance of KVM doesn't support them. Test that the
>            * features are present, and, when enabled, issue further tests.
>            */
> +        assert_has_feature(qts, "host", "kvm-pmu-filter");

So you assert here that the feature is available ...

>           assert_has_feature(qts, "host", "kvm-steal-time");
>           assert_has_feature(qts, "host", "sve");
>   
>           resp = do_query_no_props(qts, "host");
> +        kvm_supports_pmu_filter = resp_get_feature_str(resp, "kvm-pmu-filter");
>           kvm_supports_steal_time = resp_get_feature(resp, "kvm-steal-time");
>           kvm_supports_sve = resp_get_feature(resp, "sve");
>           vls = resp_get_sve_vls(resp);
>           qobject_unref(resp);
>   
> +        if (kvm_supports_pmu_filter) {

... why do you then need to check for its availability here again?
I either don't understand this part of the code, or you could drop the 
kvm_supports_pmu_filter variable and simply always execute the code below.

  Thomas


> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter", "");
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter",
> +                                   "A:0x11-0x11");
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter",
> +                                   "D:0x11-0x11");
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter",
> +                                   "A:0x11-0x11;A:0x12-0x20");
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter",
> +                                   "D:0x11-0x11;A:0x12-0x20;D:0x12-0x15");
> +        }
> +
>           if (kvm_supports_steal_time) {
>               /* If we have steal-time then we should be able to toggle it. */
>               assert_set_feature(qts, "host", "kvm-steal-time", false);
> @@ -623,6 +673,7 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>           assert_has_not_feature(qts, "host", "pmu");
>           assert_has_not_feature(qts, "host", "sve");
>           assert_has_not_feature(qts, "host", "kvm-steal-time");
> +        assert_has_not_feature(qts, "host", "kvm-pmu-filter");
>       }
>   
>       qtest_quit(qts);


