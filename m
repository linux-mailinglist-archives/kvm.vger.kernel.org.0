Return-Path: <kvm+bounces-59779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8767BBCE2BB
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 19:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 568CD4256E4
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 17:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924BB29BD82;
	Fri, 10 Oct 2025 17:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x/xeE8yg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D39224249
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760118967; cv=none; b=OKIlV2Cs2L6c5eWZV2wkHGV2qXtId8NwOZc7fJU18NeioSh55jcyqiv2H6W+maKAlevcHgXNm4+XWIfHOxPF/EmyH52/09Fiv/xjl81wzlFe1LGlq+KjibomK5W9GvQf5aQWuQ2SwIF7tuK7rC/kVxPxiRXLDJnwN9e4cv100Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760118967; c=relaxed/simple;
	bh=4WCXyfTTCLJOyLXrUdyX+y0+hs9jTJ7a5FhgD26A9JM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DsyEENKMisozJBjJn6c5XgDIdTRmScEoRw8f07hsBi+05xU6HKNpg9PvifnQFQYR7d2jCUqFMKLqxDrQxAJ3fQKxJ/RKmw/ur9cptJG2EcMoxeHnAip61En15zDz7K645KT5iiaam/39Q47yK46fLoqZrV9hhBy/ZLgb3pTdmps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x/xeE8yg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28c58e009d1so78767495ad.3
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 10:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760118965; x=1760723765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r+fNeysjSBqXJo83LMvpOWAm6fUtr/rW8XiVtt3RPUw=;
        b=x/xeE8yg5d1JoPSxDsj/raHLY1e6kOa/qsvwlfM5/NiBmexMmUqSwZ1QQnV8CTeBey
         fa85u+8FXQiOCbJ0I04Vm1P6oLKVrQo+cYplDc5ElXXsqY9yGQn3Ri49t2Lg16D+m9xb
         II6lOrAp9UxS978ZhsB9NDSCYcBYas1vkpAfmGYpznUhqQu+8s5n/ERaITkmYbAZHnmf
         PytoeuF/L7G8MYu7GB5NfO4k7IDLG//K+zkZ6+vpls2hAec2e2NGIGtT9toQ/hZfL/Jl
         mpZGNxVx0Pqo4XFtxG4lNu52xTtYXuiMK9aSOn0H4MCPn0uAMXC5tIdX7BA3sZOOn3SX
         vQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760118965; x=1760723765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r+fNeysjSBqXJo83LMvpOWAm6fUtr/rW8XiVtt3RPUw=;
        b=V9AFJNuKk3QhBHSdOSA20tl3MbY1lOiY3cp04zHXVXqCyyucIJcop45IoIckOh+c2g
         b3qX8hmBGhBPOm5S2G4y0fdi+3bc8xMH8eX1H/Nd4EuTP3XLKyrBa1Km2XA3LxRmBNJu
         vWQ/6SeRsrsv0Y6oN1lBpnsZeHMA+RLFGE2Xb/f/qI3nufBG7Q9XXszedclP6HvCsszG
         TxQwiGqc508/I8zHB+/DxMGGGLSRCEDjvH6oTEXvcHgG0PN97BIzDZgeMAsQ4KixCeb8
         Ddl0FDJpRR+LaYsv/ZlBvmpiqqxU4yBYLj8JYaXaAgc78h72psLtkPcjrHOKMrUn7JET
         6kqA==
X-Forwarded-Encrypted: i=1; AJvYcCUVBPQdHLVHgKgK7wtkBZ+G2LR2kw1/wM0E965h+QtsA4bID2i5hfkfbuiJHAPbjFKyCQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUCb1mKmotcb9pBqGRCtkSbYyi+O0mexyULXceJ53Yd45sAX4d
	zrBuO/xVthpALxWK4jRecwApsR0pL3MArffI1/WjEvXSkX2S0l4rtqcibGkKr7Fc5kdWcA6nyGb
	U7RanGDYXfHOjJqcKe9BDP1VtsQ==
X-Google-Smtp-Source: AGHT+IGjclZ91N97ptCXAmoIKfA3u2zw8eqXw1SihXP/pw9xAZDrc7Put3tnbaSd6Ang0fIk2Ogt4e6D4jCqFIGlKA==
X-Received: from pjbsk7.prod.google.com ([2002:a17:90b:2dc7:b0:339:dc19:ae60])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2a8d:b0:24e:e5c9:ecfd with SMTP id d9443c01a7336-290273ffc74mr153940805ad.42.1760118965545;
 Fri, 10 Oct 2025 10:56:05 -0700 (PDT)
Date: Fri, 10 Oct 2025 10:56:04 -0700
In-Reply-To: <46f31ad5-be3b-4945-87d1-c280f76fba76@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <diqz5xcniyhb.fsf@google.com>
 <46f31ad5-be3b-4945-87d1-c280f76fba76@amd.com>
Message-ID: <diqz347qhc97.fsf@google.com>
Subject: Re: [PATCH v12 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Ackerley Tng <ackerleytng@google.com>
To: "Garg, Shivank" <shivankg@amd.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

"Garg, Shivank" <shivankg@amd.com> writes:

> On 10/10/2025 2:28 AM, Ackerley Tng wrote:
>> For future reference, these are the three specific patches:
>> 
>> [1] https://lore.kernel.org/all/20250827175247.83322-4-shivankg@amd.com/
>> [2] https://lore.kernel.org/all/20250827175247.83322-5-shivankg@amd.com/
>> [3] https://lore.kernel.org/all/20250827175247.83322-6-shivankg@amd.com/
>> 
>> Might have missed this, did we discuss how these 3 would get merged? I
>> noticed this patch was withdrawn, not sure what that means: [4]
>> 
>
> Andrew confirmed he's fine with these MM changes going through the KVM tree.
>
>> [4] https://lore.kernel.org/all/20250625000155.62D08C4CEE3@smtp.kernel.org/
>

Thanks Shivank and Andrew!

> Regarding [4]:
> https://lore.kernel.org/linux-mm/aFlHIjLBwn3LQFMC@casper.infradead.org/

