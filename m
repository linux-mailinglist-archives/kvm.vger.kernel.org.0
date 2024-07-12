Return-Path: <kvm+bounces-21527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C11A892FDFF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:57:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A932281A28
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1F8174EFA;
	Fri, 12 Jul 2024 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WDN5wQ57"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D84174EE4
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720799838; cv=none; b=Kau7Od/NmvnHxK3FW9J66GhoMC5fVEFH1u2kaw0pUVsW0cma/+zaU15Gct0ml8P8bg/tYA0uUBHx9yC4oInHkcqKlFEXuGEM3sfYmvnYJuy314c4zm5gZO+XZfUGZj+vTzbnU+T6ktbmIxalJQIWxpz9uVJHzj5Eb/AIxUlDVdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720799838; c=relaxed/simple;
	bh=92LbG9az5ZEmo10Huxxe9QhBwRq7LYH80MayzdsZijw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kOnXqmPKJ2Bjuss7tfGmQsIYN07DV2oS4t4oacRnaNtv+9MG6Z3HDAwUjqjXgSCuS4gyhPIBAs2w+pRZWauP6y7cvkBfkssZeU8/khwCCM7Ty4EFs/Vz9c1Jw0YicjKzHuaSp+IiG/LCfghDWlj8tHw37nVYFx1HQw6QaZL3l3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WDN5wQ57; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720799836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=unIhgmQoVncSJ3ToST2Rwgc1eOZuFM/cCjT8vffTDPA=;
	b=WDN5wQ57QkrzoRc0TMmssXZNtDHVN+I4KcOODNciog+K93M1z9Wq6CgMZx+TYGP1VL0XvC
	H1INBfsxek7hIRr1e1yXY0BpcdNw4ARaXIo+n4lcVZufRaBLWteZMVdcqDvknmQc6XF0/d
	88zQYLSQfl5XHMy3eDSMSk+Sqm7tslM=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-Aq-kdAsmPm2sK-OT68mUVA-1; Fri, 12 Jul 2024 11:57:15 -0400
X-MC-Unique: Aq-kdAsmPm2sK-OT68mUVA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-52ebdb0ef28so3042889e87.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:57:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720799833; x=1721404633;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=unIhgmQoVncSJ3ToST2Rwgc1eOZuFM/cCjT8vffTDPA=;
        b=N0mckuxKl1mbs1ktYlTPMKh+qNT9kXhKJ8xEl6X+BYMAQUCcwjPhlG4apoYPWYov1G
         NOD1v1veMQsikjEr2eHq6a5qdPWgI3KCkmm9HncRpdW5u69MtTpky5EKWIGUeMIsYGcg
         lKJQ38a968oGkAPDCTExvoHVb6CdryNebeycculSB/8BNX00J+l9rLBdiLUpKSqUVzys
         qh0cmNT+ymOYgXkDLintTMLaDAf6eh1XowKYmQAOLZC+kNT5UjEJ8V2tRTcasYXXoI10
         yPyud2A45I3C7zxrZfOGsV9CIAYfCZojXNGHZT09QK9ezzgYvzPQUdvbvjWQeGWhc9or
         30oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVo8EBLXPDdPqt54qlBv2euH67acFLV2PJGnxdWt6cLGQAm0YZIpUOznnH2PQvxvry1o46U1SFSONtsAB73mejA3MDA
X-Gm-Message-State: AOJu0YwdjJ9TqI8mDS8l66p6UKprfbYFJAz+FOQ5kpOokf2ESPtbvNZR
	gAKwcz1hOzguYz4LOdCHWfokqi77qRwgXklVTJBwQT/Kf4839eOA9ZexoYUKs2N4fCs8hO+Vrwq
	BRvvLPapl/EiWhZ7K0Q+hom5CXfohneZz9yIGXBcV9RgLSJlmSA==
X-Received: by 2002:a05:6512:3d87:b0:52c:df77:6507 with SMTP id 2adb3069b0e04-52eb99a1482mr10843652e87.37.1720799833508;
        Fri, 12 Jul 2024 08:57:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHblt6jVYY/WnfcCaSWSerVrk0LdnPIVMWY7Mr9poNBoiIc9yN4ioDL526CLoIo6o3GqO2tDg==
X-Received: by 2002:a05:6512:3d87:b0:52c:df77:6507 with SMTP id 2adb3069b0e04-52eb99a1482mr10843635e87.37.1720799833133;
        Fri, 12 Jul 2024 08:57:13 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4279f2c254dsm27493245e9.46.2024.07.12.08.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 08:57:12 -0700 (PDT)
Message-ID: <f06ef91d-7f8c-4f69-8535-fee372766a7f@redhat.com>
Date: Fri, 12 Jul 2024 17:57:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
To: Leonardo Bras <leobras@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
 Leonardo Bras <leobras.c@gmail.com>, Sean Christopherson
 <seanjc@google.com>, Frederic Weisbecker <frederic@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240511020557.1198200-1-leobras@redhat.com>
 <ZkJsvTH3Nye-TGVa@google.com>
 <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com>
 <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop>
 <ZkQ97QcEw34aYOB1@LeoBras>
 <17ebd54d-a058-4bc8-bd65-a175d73b6d1a@paulmck-laptop>
 <ZnPUTGSdF7t0DCwR@LeoBras>
 <ec8088fa-0312-4e98-9e0e-ba9a60106d58@paulmck-laptop>
 <ZnosF0tqZF72XARQ@LeoBras> <ZnosnIHh3b2vbXgX@LeoBras>
 <Zo8WuwOBSeAcHMp9@LeoBras>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zo8WuwOBSeAcHMp9@LeoBras>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/24 01:18, Leonardo Bras wrote:
> What are your thoughts on above results?
> Anything you would suggest changing?

Can you run the test with a conditional on "!tick_nohz_full_cpu(vcpu->cpu)"?

If your hunch is correct that nohz-full CPUs already avoid 
invoke_rcu_core() you might get the best of both worlds.

tick_nohz_full_cpu() is very fast when there is no nohz-full CPU, 
because then it shortcuts on context_tracking_enabled() (which is just a 
static key).

Paolo


