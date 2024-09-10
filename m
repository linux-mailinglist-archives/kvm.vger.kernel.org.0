Return-Path: <kvm+bounces-26299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 080FB973D22
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C68CE2876EF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FED71A0B05;
	Tue, 10 Sep 2024 16:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IB3g/WQm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964631A072B
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985380; cv=none; b=rtgf8ZgXB5oK3lILGbFqJtIn+hHaHuyag0G6w0oZbHj3bml2AX5fdcgGr0pNKhHtthbjgZGle7zUaDUoq1tszRfuw+X/8aV7tq0ibD+ynCorfoxuRS1xH3Kg1MbgKmq/0mQhhuQYTCVP+86xSVrvhijDEcVKegahjr7xUyWu4mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985380; c=relaxed/simple;
	bh=VyhzGV1sQaHyOjQ2G9n2qIE79UdyyC4r/EAK5SpwpRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sqnngqNtGgBBaf6bve2w1H6goV+dUB0KBjlMATcrQXSvuW3WK46oGWMNEgz9ctz8B9pCEMmunb8RD7cSiQQoSF1dnFB+b1TTBOJv7H7yhbpILwYC7WlAR7ZKhpjYCDeNz+5jX8EL6E509Ar6TixA4YUUbhvWma4E96dzAgmOl6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IB3g/WQm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725985377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VyhzGV1sQaHyOjQ2G9n2qIE79UdyyC4r/EAK5SpwpRM=;
	b=IB3g/WQme2+s4E80sbBinf7hzZK+Q2sbS3Dan29tjdswRIA4RyV7xJaJ46K6bYKDv7T6cc
	iz4uXcZ74v8smRSjABPQT06sB2TmWV13BYGUQsHDkzsg13qc18DmTe9mmzewvF3yZF1o/e
	KCZVdCkzyBMhLhEQ4DuiNwNBA3xVzgs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-bTCHyZOKNhqa_xDhHO1JSw-1; Tue, 10 Sep 2024 12:22:56 -0400
X-MC-Unique: bTCHyZOKNhqa_xDhHO1JSw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a870f3a65a0so418071566b.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 09:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725985375; x=1726590175;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VyhzGV1sQaHyOjQ2G9n2qIE79UdyyC4r/EAK5SpwpRM=;
        b=NyFrxgzaI1zjQWSX5rL1wN0O6UhQ6ome2i4eeEUKzSdrL44n3t0nciki9T/BTYfZ0j
         P18KeYVeh8zrzEiYXLKbcGIeqNm817RO1/yJV04hRf/qxnKGtjnffsAU5bQGur7wCB5V
         4/K5ihNpJXs+MT7TxeLLj+ZCY4NyWU2rbolyWrb+uMazeauvULvvJVfUy4KDKMIwtlnW
         0VVBDFUd/sOnTxs5XyRIa7CJKaxaLWW7ifQWfkKuzlP5HxPxSZsPuXYgrUD+xtD1dskS
         slI8VvCWKwKIiE3KuYLKYrLcpHUvM4vZ6aGVNSv+GHVCZKeolDDwt8u4YPfthYhUhwYY
         hRNg==
X-Forwarded-Encrypted: i=1; AJvYcCUYIsTL5+qbevb/XbYgKwNrG2cQM01UbnwepDWJXSR7jtX8GaF5MOCzzXwsD3Z/ix5ZBpw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfQjvOnXSc/30Dz9ZtVLi0jmK9isWByWhysNAoHWx2QWAGrOfd
	k9mV9eZ8YVRW3E7m2b2kmYve+GaAAk8UwT+ozy2ciFmNq2IIwyNG8jG1p2fT0QlsOv8yp0KQfh4
	i+m7V3UxYjitjfKgEADbIxyMd/BGXilC5NjgPx9CVPQUt506+Fg==
X-Received: by 2002:a17:906:c149:b0:a8a:6e20:761e with SMTP id a640c23a62f3a-a8ffad9da07mr112602266b.48.1725985375275;
        Tue, 10 Sep 2024 09:22:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHh9V1jXDlEA0qwiOHbYbfwl85y4fon/92AWyHTy1jPDAqssMBmnygb8vMNloILF3asBRWpFw==
X-Received: by 2002:a17:906:c149:b0:a8a:6e20:761e with SMTP id a640c23a62f3a-a8ffad9da07mr112599566b.48.1725985374729;
        Tue, 10 Sep 2024 09:22:54 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a8d25951020sm500923266b.66.2024.09.10.09.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 09:22:54 -0700 (PDT)
Message-ID: <80a3a5a1-59cb-4ca9-8107-b7552fa35b6b@redhat.com>
Date: Tue, 10 Sep 2024 18:22:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/25] KVM: TDX: Add TDX "architectural" error codes
To: Tony Lindgren <tony.lindgren@linux.intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
 xiaoyao.li@intel.com, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Yuan Yao <yuan.yao@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-4-rick.p.edgecombe@intel.com>
 <45cecaa1-d118-4465-98ae-8f63eb166c84@linux.intel.com>
 <ZtAGCSslkH3XhM7a@tlindgre-MOBL1> <ZtFeO3hq6dpnXvmf@tlindgre-MOBL1>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZtFeO3hq6dpnXvmf@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/30/24 07:52, Tony Lindgren wrote:
>>> +#define TDVMCALL_STATUS_SUCCESS 0x0000000000000000ULL
>>> -#define TDVMCALL_STATUS_RETRY                  1
>>> +#define TDVMCALL_STATUS_RETRY 0x0000000000000001ULL
>>> +#define TDVMCALL_STATUS_INVALID_OPERAND 0x8000000000000000ULL
>> Makes sense as they are the hardware status codes.
> I'll do a patch against the CoCo queue for the TDVMCALL_STATUS prefix FYI.

Just squash it in the next version of this series.

Paolo


