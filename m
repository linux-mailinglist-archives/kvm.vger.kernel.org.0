Return-Path: <kvm+bounces-33761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D8B49F1555
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 19:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49ADF284016
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 18:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332A61EB9F4;
	Fri, 13 Dec 2024 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lop/zUVh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E250C19CD08
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734116341; cv=none; b=OPabLrPOa1pqVJ8ZURmqF1tlIflOv5mU9snK9Y+fGvBKuZCG/XFs3UnklmuYXYfBHulq194F8GJVRZHVUSuZzPmf9BlFfSX9zHeO7yDPTyBOJTvFSfB6TOBsi6KtEP25pUkRNlF9zGXYqxHvi8w06/XJxkkHWMpLBls7ivNXNbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734116341; c=relaxed/simple;
	bh=t7Np4Aa+tgtujgWBmCLmpiOGbTdtLucpjvWi7GEHhkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E+0PjT3HIG1gOAgsfXd8n1lrniP7dbgqLbi9l0jV+TwzgTtEbnXE7BikbqtHRThMQJm8OKfDYC0G5/QOxXG9pxxdB7OkQmPB+2pibi3flpHq9OaEGnfq7D5zpbgrUVwKas5Mt5S1fGMvWHvO22UDNuGG5wSb7XfnuYmEPbiFBUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lop/zUVh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734116338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mI1mOtjG4nC/az8D+B88vVhaoQDxbNllCYmgLL5S3Ec=;
	b=Lop/zUVhKwcCBwhc3+mGaKy6iTjNlfwwQlN0JRePiLfj9clSxXltzjGac1K/HSKT+53uUE
	xnEl7K3vKpBdFGg/o7GW5VlzCM8U0/l2qjY9bjXhWmRrdyVnXOtVOFF2rhf/6konNrCxG2
	mJoRfyPvc/BXxhsYa6uvNMsDQxILga0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-lraLPcoWPFG3tpZ3Vktdyg-1; Fri, 13 Dec 2024 13:58:57 -0500
X-MC-Unique: lraLPcoWPFG3tpZ3Vktdyg-1
X-Mimecast-MFC-AGG-ID: lraLPcoWPFG3tpZ3Vktdyg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so16758265e9.2
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 10:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734116336; x=1734721136;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mI1mOtjG4nC/az8D+B88vVhaoQDxbNllCYmgLL5S3Ec=;
        b=k19NTRtiGAC0UVeU+oc9tp6Vc0jR5wKPnsxObNIAZZvEdjeu13Ya5jGAdW0BPbZhMB
         HdJbQtmLw8vGvZNYIErpOGpMgWS3AegGFfmq5iVjSuPFH3Fk9JqhzTGYWKZBZjPhya5X
         LQR+wmnviTeGi8BnoM8BbF79cdkAf+gkOzpU062jAPRdGP311hAVXqdSuGrvESyZIkTC
         Phdx2RL3iTeRPOCRKazBwNvx0tUGTtzkUFP7S2YQNUiksk/MR57PS8HqqSKjtD2v78VG
         B9rboIPBXDE+YdaTrUMBw6MK94pGFoVZVOTGp2baAGFmtYqOn+h2w9xHCCu25mQPk4ZI
         0JwQ==
X-Gm-Message-State: AOJu0YwNpHeXcgJslgA/XyXE5XlkJSLDIPjkWBwYn+IQOsoLLWZFgRuJ
	ds8tzwZ8jrs1tbMjmybcZ3ZzKjjqHgi16eNtC1yoMdaVahR0Ye1M2WCue4JKo8DCxiwCL3SXQCA
	9Ts++tHxUrOUIc1tR9NF56W7DBv2p4byWb3UVrzHiRWKhDQwg8asc0n9ybg==
X-Gm-Gg: ASbGncsSM5SYe7uZrEpWMDIzw1kDxzIp1mkwXIDVeVYZZFGTf5jaToYgr9q7VfKR3C5
	03UEq0qgi4ER2moS0wdjBCMIxPxwyKFIF2sOz+lAKkO1cuj52ypdkbERbk944ML4dM4zhtsBlNn
	6h7drh6nSWsyUeywpf3wnLQUYi87eh1hG0wFdyOJYYHlNxCwEW7Q8CuCNKHhIA4m4XxmrG8ofoI
	xUqcPq3JYZmhdZbjj4LZCnNuzim8FeP1/5oQYJp25/7jkhfsy8VzS9bIsY=
X-Received: by 2002:a05:600c:190c:b0:42c:c28c:e477 with SMTP id 5b1f17b1804b1-4362aa9d675mr34183085e9.23.1734116335989;
        Fri, 13 Dec 2024 10:58:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCocN09lwrJ18yznQg6RRv3t1XmTAkjMEIYeGuE67QjSo4SyJA5WAXCajyTNxHaPEkuz0Z7A==
X-Received: by 2002:a05:600c:190c:b0:42c:c28c:e477 with SMTP id 5b1f17b1804b1-4362aa9d675mr34182965e9.23.1734116335622;
        Fri, 13 Dec 2024 10:58:55 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-388c80602a1sm251014f8f.97.2024.12.13.10.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 10:58:55 -0800 (PST)
Message-ID: <257491b6-f70a-4347-b97d-cc7fa22aac85@redhat.com>
Date: Fri, 13 Dec 2024 19:58:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] KVM: x86: Address xstate_required_size() perf
 regression
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>
References: <20241211013302.1347853-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/24 02:32, Sean Christopherson wrote:
> Fix a hilarious/revolting performance regression (relative to older CPU
> generations) in xstate_required_size() that pops up due to CPUID _in the
> host_ taking 3x-4x longer on Emerald Rapids than Skylake.
> 
> The issue rears its head on nested virtualization transitions, as KVM
> (unnecessarily) performs runtime CPUID updates, including XSAVE sizes,
> multiple times per transition.  And calculating XSAVE sizes, especially
> for vCPUs with a decent number of supported XSAVE features and compacted
> format support, can add up to thousands of cycles.
> 
> To fix the immediate issue, cache the CPUID output at kvm.ko load.  The
> information is static for a given CPU, i.e. doesn't need to be re-read
> from hardware every time.  That's patch 1, and eliminates pretty much all
> of the meaningful overhead.

Queued this one, thanks!

Paolo


