Return-Path: <kvm+bounces-13721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0971A899EFB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B41DB22988
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5C516E88C;
	Fri,  5 Apr 2024 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IrR1w9As"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F97516EC03
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712325999; cv=none; b=tHb/l4WaGsE/wXlaRKjc+C63RM3Wf3bEAI8sRJ5btOkOPgI849rN4zLXK7/GWGC9m9zRSMdzkZcSDapRRyWby+dvHOA2TZkNa23q+I9qQ3zLEM1wjIhwVfvEI3wgH40dSd7wmOY+sv4nTvr+qzHbxNSx1UabsEC7aZJnPQdtJZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712325999; c=relaxed/simple;
	bh=8bNZZbosP9nAr/p1BaujGsP+IEWWjkMbLPJGStBuzdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FIxvSZ7xOnvSNXgES+v7Z3szraUh3e4sKqdtZ+8/j+6DiQ6Va0ew13jmlxuk7UKQgLu7bczJ5O/qc6TEpX+oqxI6Dn6OrquhLRylRp5NgshDm7XIwEyYza1/OJ8bfaI8vdcx+uQBwR5MHLC7udDabcK2h//RmOfYnXsnQuLGTeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IrR1w9As; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712325997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pZM32KWNBf41XAm+XkCzgsgc2L/8l0YPydyhKwL1alc=;
	b=IrR1w9As1eA9xwf6t7znBaE3aVzxvRf69iUHSll27393JoBWXZyq1sPhA5d9SQ62+79rtc
	AP9VfjtjRTUPv88L4K4TWir+pVvGVoA+lJTZS03Wl4cJCo88BdhwLS7zlZ0URAhiPH1T6L
	vjpUn3ImqQvsDORUWzlu9/D1s7FWXbQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-MiSHEAQYMNqHhV3Hne245A-1; Fri, 05 Apr 2024 10:06:35 -0400
X-MC-Unique: MiSHEAQYMNqHhV3Hne245A-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34368c5cadfso1310450f8f.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 07:06:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712325995; x=1712930795;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pZM32KWNBf41XAm+XkCzgsgc2L/8l0YPydyhKwL1alc=;
        b=lagBKHRzcXiUfOx6t9AltSL+GtHyiP16QwlNCgRsdMqw15QrtC83JLZONEG8/YPpz/
         RB+IDsZYLdLhP8TiSo0G1RJhyvjVQ9LZRLbTmUm9t/V4WxIrk4jKxfEekn1TAfDlDfgm
         HPWXe+d7UhDnhNXSBkYo7sz5Wh1MkwCwLtJ5bMjX0CBvivXuUU33pU4MTaaQTkT5x7bH
         +Z1QQ1AK0LtCYqAby/syGK0QmlFY5ibQyshYzDGGGTgc0YypHn8GOaYm+1kSQ0ilJTvw
         bB2IAY5RqLc0h3ZAEsnY0uKA7Eu/8wdNYYmDzw20UN5am7XE1l7jJlkRy7XrpUqxiVD4
         lhwA==
X-Forwarded-Encrypted: i=1; AJvYcCW0Wyfb66lleUt0tlSdX5R+JXJ2GJ2t2M3v008VCqDJihdQsMwUVioY5N4HPYar1yDFMflC511ZR6SNrNF48Eh5C5YG
X-Gm-Message-State: AOJu0YwCIZXjF4Hwp0HFrk51tSbNQjOY0/oAXyd1jXT+ZM50nJ2wORc5
	oSdE0vnXAgikIs1VuiejkqM4qoGO4YNiYGpEebQlNSgkYjJ7u5C6H9hxG3eAdfIGrVC9YsTHhql
	OX5RKvIdUaoqg3zeA/BY8sKENka2U8gI7V4Kq9FqbvA9dKEfeUQ==
X-Received: by 2002:a5d:6048:0:b0:33e:a5e1:eccc with SMTP id j8-20020a5d6048000000b0033ea5e1ecccmr1339474wrt.68.1712325994805;
        Fri, 05 Apr 2024 07:06:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFx+IdIxcYQPbf0YzTFAP85RpJtNMGuDVFuf+aF2FhGBeMHURu946693W10VS3f7a4DjM/EwA==
X-Received: by 2002:a5d:6048:0:b0:33e:a5e1:eccc with SMTP id j8-20020a5d6048000000b0033ea5e1ecccmr1339451wrt.68.1712325994331;
        Fri, 05 Apr 2024 07:06:34 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id t7-20020a0560001a4700b0033ec94c6277sm2086679wry.115.2024.04.05.07.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 07:06:33 -0700 (PDT)
Message-ID: <9b0f5285-bbce-41a1-9c74-74051ca3f9b1@redhat.com>
Date: Fri, 5 Apr 2024 16:06:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios
 dirty/accessed
To: Sean Christopherson <seanjc@google.com>,
 David Hildenbrand <david@redhat.com>
Cc: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>,
 Matthew Wilcox <willy@infradead.org>
References: <ZgygGmaEuddZGKyX@google.com>
 <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com>
 <Zg3V-M3iospVUEDU@google.com>
 <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com>
 <Zg7j2D6WFqcPaXFB@google.com>
 <b3ea925f-bd47-4f54-bede-3f0d7471e3d7@redhat.com>
 <Zg8jip0QIBbOCgpz@google.com>
 <36e1592a-e590-48a0-9a79-eeac6b41314b@redhat.com>
 <CABgObfbykeRXv2r2tULe6_SwD7DkWPaMTdc6PkAUb3JmTodf4w@mail.gmail.com>
 <7a1c58d7-ddd9-40fc-a4ef-81c548de2b07@redhat.com>
 <ZhAD3hQwI0ltYnFp@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZhAD3hQwI0ltYnFp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/5/24 15:59, Sean Christopherson wrote:
> Ya, from commit c13fda237f08 ("KVM: Assert that notifier count is elevated in
> .change_pte()"):
> 
>      x86 and MIPS are clearcut nops if the old SPTE is not-present, and that
>      is guaranteed due to the prior invalidation.  PPC simply unmaps the SPTE,
>      which again should be a nop due to the invalidation.  arm64 is a bit
>      murky, but it's also likely a nop because kvm_pgtable_stage2_map() is
>      called without a cache pointer, which means it will map an entry if and
>      only if an existing PTE was found.
> 
> I'm 100% in favor of removing .change_pte().  As I've said multiple times, the
> only reason I haven't sent a patch is because I didn't want it to prompt someone
> into resurrecting the original behavior. 🙂

Ah, this indeed reminded me of discussions we had in the past.  Patches 
sent now:

https://lore.kernel.org/kvm/20240405115815.3226315-1-pbonzini@redhat.com/

and I don't think anyone would try to resurrect the original behavior. 
It made some sense when there was an .invalidate_page() callback as 
well, but the whole thing started to crumble when .invalidate_page() was 
made sleepable, plus as David noticed it's very poorly documented where 
to use set_pte_at_notify() vs. set_pte_at().

As I wrote in the cover letter above, the only reason why it has never 
caused a bug is because it was doing nothing...

Paolo


