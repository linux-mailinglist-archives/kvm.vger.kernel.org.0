Return-Path: <kvm+bounces-20172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C4B91143E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 064B9B2187B
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF81977119;
	Thu, 20 Jun 2024 21:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKvG/XTf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976AB4778C
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918286; cv=none; b=SCxiFgJqaV8R4S99uiclNsn8Gd7C0asGuyheo9UVdifOfEcZWGy8FDNQVQDLk1fENKo8XzAX7NM6rL0hl1WjHXkNQtZXlstzk2E/ZLBEo6pNqovwwTWrq/6f/6xamy+jSlAtu4c7V7RRQ/FtM1dXVCNyY8gT+dLKOO0k0GohWnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918286; c=relaxed/simple;
	bh=aqMJYuRKRhwOwpKdDy+zCFLnsS3ZxHbcjVfA1b4He7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MSDnUjxiDN2usM5MkxZ9PAuDrVZNJ6M4dOB7lr5NLwpD5/6VHyaF1bXnlGxIdGHiQc2y3FAD9gLorluU6mjQ1AgoBAlYufEviBeFVZ7Ud7C3Zx4YuhVC8w9xQX0M290wXdA6A4RoVxH7KZKXpO8mM9RePuvEdwoNQpdzN24fq8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKvG/XTf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718918283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RSXrjWzW3gVvVNp1m2KmnwPUIOWOjjIbSVU9Qc45xpQ=;
	b=PKvG/XTfs8Q6u+IfWOgs9SFusgN4foUII2cSnIsKb3fJFmSq1eu3C7IuqxbFgYYX8jvyEZ
	UTnMRbmQCql4HJMXAYnNDHvYSHKfZMmI52jscyZEm1zPZpQy7h+M6V8KPAdfuAaUYuojBp
	n6lVluBtO9mZJwx/3wELD04YBDKwRbk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-PzTlrF0cO0ex643CameCjw-1; Thu, 20 Jun 2024 17:18:02 -0400
X-MC-Unique: PzTlrF0cO0ex643CameCjw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-57ceb0e6a06so582116a12.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 14:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718918280; x=1719523080;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSXrjWzW3gVvVNp1m2KmnwPUIOWOjjIbSVU9Qc45xpQ=;
        b=f8rVml009MHLyp8Pc07uzwcNrlNYYVm1quuZSBSccXEiLrGBOdkfn8FCCeqyOCL/kf
         V0w8fcw3Tf/VH1loph0buyRnlmR4woXq1iirgA/InKjBeNcaTHuNYe3hs9K4cgDKzdvQ
         NxaREJC2Qm4Y3JZ5zi4ilX/1dHY59x02PbsJ4YwttgO9a0yrC/4GfLMoBg1yRpksVJPI
         J3HnXeSjIoE9N7Jhj1cmVWSfJDyW6jJ6h1d5G/9n0Kjko4yY5HcbgDlmx+GHLwNNwlZf
         XU1KG7wjOM86t/8tHMDp1WVvjn8D1TPswWMUkh2U1ud6ZzGgfIW+K0piCIadU2Hiuvk2
         ihHw==
X-Gm-Message-State: AOJu0Yx8Z38wLntTJrHBvtzrpZM7P0bgqSmCEemzUOI/VLH1ZinUG1ki
	liolx7BumNu/bbRv4hmFfkaO2VvDmsOb66or8FaoM0iVfgrbI1o7b3zIkw0UmWVZxXd64umYe/Z
	kuNkTrwOP3y9gwTRa6Hj3TaiF0ClrYZr7QwMnq0FyiS0k0Cxle8Royj6e+g==
X-Received: by 2002:a17:907:c088:b0:a6f:fbc:b3f3 with SMTP id a640c23a62f3a-a6fab779addmr366570466b.47.1718918280555;
        Thu, 20 Jun 2024 14:18:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqybkFobBPot124+7bNKhMErELwzAtFobjqhKi4Uh6LFD3fi31huAdSQejQmd5Cxr2SwAxmQ==
X-Received: by 2002:a17:907:c088:b0:a6f:fbc:b3f3 with SMTP id a640c23a62f3a-a6fab779addmr366569766b.47.1718918280139;
        Thu, 20 Jun 2024 14:18:00 -0700 (PDT)
Received: from [192.168.10.81] ([151.62.196.71])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a6fcf42a650sm10970666b.43.2024.06.20.14.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 14:17:59 -0700 (PDT)
Message-ID: <5a2b21ce-2554-4ee8-bff1-76231ea77703@redhat.com>
Date: Thu, 20 Jun 2024 23:17:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Remove duplicated zero clear with dirty_bitmap
 buffer
To: maobibo <maobibo@loongson.cn>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240613125407.1126587-1-maobibo@loongson.cn>
 <115973a9-caa6-4d53-a477-dea2d2291598@wanadoo.fr>
 <fb2da53e-791d-aef7-4dbb-dcf054675f9b@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <fb2da53e-791d-aef7-4dbb-dcf054675f9b@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/24 04:45, maobibo wrote:
> I do not know whether KVM_DIRTY_LOG_INITIALLY_SET should be enabled on 
> LoongArch. If it is set, write protection for second MMU will start one 
> by one in function kvm_arch_mmu_enable_log_dirty_pt_masked() when dirty 
> log is cleared if it is set, else write protection will start in 
> function kvm_arch_commit_memory_region() when flag of memslot is changed.
> 
> I do not see the obvious benefits between these two write protect 
> stages. Can anyone give me any hints?

The advantage is that you get (a lot) fewer vmexits to set the dirty 
bitmap, and that write protection is not done in a single expensive 
step.  Instead it is done at the time that userspace first clears the 
bits in the dirty bitmap.  It provides much better performance.

Paolo


