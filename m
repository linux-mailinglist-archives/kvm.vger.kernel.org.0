Return-Path: <kvm+bounces-8127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 491EF84BCE1
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00442281873
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 480A212E68;
	Tue,  6 Feb 2024 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="p1+u/+MH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2A9BA50
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707243901; cv=none; b=rDJYw0zW5eEy84UuVtHYgTHM8fhrZ1U5pV/l2Hiztbe0MavNdFz3UQKUUUQKYFWz+PG3cqzflYQlpoy16Kj9kV3UCmKGA6OwglVVdN1YBVGWyUHkRI7i1hfj48yzI0LwvkJ41tOOwhNZOApZ7fiY1vUE/5TtUfPNi9eqYxSW+dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707243901; c=relaxed/simple;
	bh=5g6zGk4/HgxgtZVwh8sjjIQyM9VipH8e2P55Ro/0jqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKPLBPjNOJBxVmLWyMGq8iPc4EYZX5R5e+hdkB4pT3uPeO7EDiEIIpZJDTiJrlzGUhED7eiLhWQoWY+bXBMRTUm5PLbQhMlEdvG/IWd/dLeBGnErZxJVnWGa5B3qblgIl14MsJZh4CrGOp+RdnyqSWdEr79ZYP4iWrkwjbFRzVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=p1+u/+MH; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a3832a61a79so99966166b.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707243898; x=1707848698; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ycBTxyrWdOEj3GiikcflPpq5rbuDb9mpBtug4LQWDRM=;
        b=p1+u/+MHhIP0ePQX1yvpyJCAbUmle+KdxX0Agj8SNFvBJ4JuMsLrrw+P8xFlrSih1C
         XiOvllaxnDBMUo75bkOP6PcUuHKJE56Jh27o+qFYi9nO0/xcsNahNPrTs+I1XRG9I5CV
         A7EkyWOFRmcO2RYZca4v3y1pcipvc8JwkC2NnurTOl8Xj2pqmlSXk0YL2DcEfAREcAk1
         mNbhKAmAPJ60mCPdl95bshp1MFkqTomgtymX4g6Xu7gHyyOwU1WXkOD/FedSDxyT4bVz
         xjthk8EsSeiqK4AxAAiYXX38Ba0k0hjppURrIEvotKeuEzlvuJ2pguhe7MQzNlqqZkdL
         y5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707243898; x=1707848698;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycBTxyrWdOEj3GiikcflPpq5rbuDb9mpBtug4LQWDRM=;
        b=c+YeWlk9W0xrcdMe62cvRLayZcuiF4Z/2iHoG5nniGJ6EqkeoNPi2JFgWx3aCbU9+1
         LqXG5H+48mDfk48vxOzlk1r38fE/nHdZvz53VNoShT+YhZ7NqMBaeB/0IrytzjtMu02i
         2/0SUEw1Dnl5vM9OpUCKKji45GKIbZokxq47l5RhAF3sAXlcZSap2hqWSbFsRUHCp0Ge
         593EmsG4IHE5AXjEJ9NJRlGC2wHzwhSN+1uSWeF9MCSh5psbrxBd0hBgEIR9r3gJg7ox
         LujPwz4BOg6EpHajgJuVntJIeduYLbGJiyIhleDjeYSaFx+cYqnhMDIv6aMM+xAV6+i+
         u5Nw==
X-Gm-Message-State: AOJu0YyGA9xfMqE6XCAyvEDJPPYX0YlAMvQODe4t4M3e+Pb3GNSA/Ej5
	BNt5GoG/uYonfXTTB6pSXFbcahGTMXaJTsx/rPAgVMpHwZt6SC9OcBx4NuxS/WPWHI62YbRrQNu
	r
X-Google-Smtp-Source: AGHT+IGnxKUrZtUtAfDBNfI/w9t0vj8FWjcP+paaM3RBhYeTXDF7KQo24w/Po4O5zUNnqei1vf14uQ==
X-Received: by 2002:a17:907:6d04:b0:a37:90a7:f846 with SMTP id sa4-20020a1709076d0400b00a3790a7f846mr3829869ejc.18.1707243898034;
        Tue, 06 Feb 2024 10:24:58 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWwZsckDlbvR+MDJnQ3HLWiasTyLXItZl+9hNSrcW/WIwsfIY+YVkr7lG93deW3fwJjvGVHrVePWFGF1HLJxyoJBWa4
Received: from ?IPV6:2003:f6:af18:9900:571f:d8fb:277e:99a5? (p200300f6af189900571fd8fb277e99a5.dip0.t-ipconnect.de. [2003:f6:af18:9900:571f:d8fb:277e:99a5])
        by smtp.gmail.com with ESMTPSA id qo4-20020a170907874400b00a35cd148c7esm1400396ejc.212.2024.02.06.10.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 10:24:57 -0800 (PST)
Message-ID: <22b353d7-d973-4ccc-abd9-815d3be31ff7@grsecurity.net>
Date: Tue, 6 Feb 2024 19:24:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86 - misc fixes
Content-Language: en-US, de-DE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <ZcE9dyQ3SOuUZ8Kv@google.com>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZcE9dyQ3SOuUZ8Kv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05.02.24 20:56, Sean Christopherson wrote:
> On Sat, Feb 03, 2024, Mathias Krause wrote:
>> This is v2 of an old patch which gained an info leak fix to make it a
>> series.
>>
>> v1 -> v2:
>> - drop the stable cc, shorten commit log
>> - split out dr6 change
>> - add KVM_GET_MSRS stack info leak fix
> 
> In the future, please post unrelated patches separately.  Bundling things into a
> "misc fixes" series might seem like it's less work for maintainers, but for me at
> least, it ends up being more work, e.g. to route patches into different branches.
> It often ends up being more work for the contributor too, e.g. if only one patch
> needs a new version.

That was a little sloppy, agreed. Will do better next time.

Thanks,
Mathias

