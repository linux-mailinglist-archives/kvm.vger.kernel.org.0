Return-Path: <kvm+bounces-26208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCAC7972AEA
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 09:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BD381F24E47
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 07:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F9617F4F7;
	Tue, 10 Sep 2024 07:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+pRn0/q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1A0172773
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 07:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725953795; cv=none; b=AkfAiQb/YvEXTOlC0+jVYnGpBvSFZhweM16TMW1Ga+iyjGomm47KUAXqUH1bUGFMFh7ouey74RTIeJYQ2ZZfET98vWtcR8bIHKfKZLYWrTiTXRFWuJT95LRzDNwYrEiQFbL7rYbDwSwad+SUDk3aSY0mGrjXBoWTcVJ509yDZr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725953795; c=relaxed/simple;
	bh=vqDoUCzJjSbqrkM+d9vMmu26ILSQB+jjKg96vinHDbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KhR9AWki91cjLwOOAh5Vjk4mFs5TgJY0ywBBiKkWApTtwVrhXe8Y1XXNkdUhl8T5EfgFNwnIIbdtoB2jltc+fzMfm45X+oydzfJFhIGUiQTux/l+gmPu9tBcx2VmpMlABnieIsHwfhtLWAUlpuE2OH3306HN8Rw4IzR2itWtQC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+pRn0/q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725953792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bukCso29aKam+9maewuaC/NZhaRQP9BCYwY472MO8DI=;
	b=G+pRn0/qkqF/YoPwCmKQdKweLuvN/kzOdq3nkClaDcfmCjFXCjhk7HI/d0avi7LiSUVtKh
	lB82lV/ZQ7ARJ7vEC5ejkr06rKEBXwryCBbbdrp7ZzRu8nzB//5nDn2hwYw+HxcxRXfd+6
	nKU4DVnMd8SglA6jEiwcwcpmgGkqOXA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-30Q4abccPNSUqkgsrZ-JdA-1; Tue, 10 Sep 2024 03:36:31 -0400
X-MC-Unique: 30Q4abccPNSUqkgsrZ-JdA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-374c54e188dso3246789f8f.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 00:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725953790; x=1726558590;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bukCso29aKam+9maewuaC/NZhaRQP9BCYwY472MO8DI=;
        b=ntWNxeHBuJKoZY1JiblX6yT5KvnlJIomW+J8eWDRYLZxPaTAYvO6Th+bFmtrl3zCWu
         3s7Ls3vTApzZIKAwv3BQ0FFxmEQRQaaSUpbAVaycZTJdPTo6WDMxzfc++QAhmVXmOInh
         0MX5WvVf5h6Sgt0wn86V7pUP8guN4x6RPReR0GWuBAA1bJw6iCe8csvTXlN7iCuJJrKE
         8oRBTQ/+D/aHLW/ERG79US8fU0mC8CYVS92AXDBZvR0Kgk/HcjeGm3QfmOwwn4PLn8Um
         JxeJtaodPgxuS/gYP5sS/OHxjo+Y9AR6caljNwKL2EDaqNxkKnfbKdnr8vtjAeMDfA3Q
         nqwA==
X-Gm-Message-State: AOJu0Ywh/NqazAZzgeVuetOQQ8mBhNxsQ520NXn8YF/Qs7WBcAUHpy/f
	87TQ4FmIPGJFdp4oFhOzE31yFo8f8XSTEmHrH7Z+R1nxXS8OXzcIG/EMIDsMXKgRA62EC0fy+0p
	wlI2ZRh6w/05yLIhV3Hw7GqRSNpNlwNGoLzjqhvuwnFiIUur7kQ==
X-Received: by 2002:a5d:4b4b:0:b0:377:94b:4f51 with SMTP id ffacd0b85a97d-378a8a3f05amr1121318f8f.22.1725953790025;
        Tue, 10 Sep 2024 00:36:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHCCkfOb4EqRM6UgsN4gnFTzX3BY9gFEsVBg4YPpdXui53Uv6lrFYm9BHJW9I8Y4rjNzAtJg==
X-Received: by 2002:a5d:4b4b:0:b0:377:94b:4f51 with SMTP id ffacd0b85a97d-378a8a3f05amr1121298f8f.22.1725953789490;
        Tue, 10 Sep 2024 00:36:29 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37895665babsm8098993f8f.47.2024.09.10.00.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 00:36:28 -0700 (PDT)
Message-ID: <c22f38df-0cf7-4eeb-8632-94b9b8b4a55e@redhat.com>
Date: Tue, 10 Sep 2024 09:36:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/21] KVM: VMX: Split out guts of EPT violation to
 common/exposed function
To: Sean Christopherson <seanjc@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org, kai.huang@intel.com, dmatlack@google.com,
 isaku.yamahata@gmail.com, yan.y.zhao@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@linux.intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-5-rick.p.edgecombe@intel.com>
 <Zt8dRVdkT2rU31jq@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zt8dRVdkT2rU31jq@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/24 18:07, Sean Christopherson wrote:
> Paolo, are you planning on queueing these for 6.12, or for a later kernel?  I ask
> because this will conflict with a bug fix[*] that I am planning on taking through
> kvm-x86/mmu.  If you anticipate merging these in 6.12, then it'd probably be best
> for you to grab that one patch directly, as I don't think it has semantic conflicts
> with anything else in that series.
> 
> [*]https://lore.kernel.org/all/20240831001538.336683-2-seanjc@google.com

No, this one is independent of TDX but the patches need not be rushed 
into 6.12.

Paolo


