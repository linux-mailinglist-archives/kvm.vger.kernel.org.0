Return-Path: <kvm+bounces-36169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D75A182E6
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:30:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 222463A388A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908AF1F5423;
	Tue, 21 Jan 2025 17:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mnhDlCiy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B851B4F3E;
	Tue, 21 Jan 2025 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737480622; cv=none; b=TpIWsXX5JxTWPX7c5A5STRzfICpe+cZqPzQqyIwxIl97/dCtrYm+TdenC+t5tnbGjvB8SM04mS35wmbgpvqQZrU55FswU/NunckDkbWv3/jIVxvefT5LUpaTHGlOXayJW3X+dAqKWkYX0lMpF8XrfoB0hmGdD8DMaNi5CyRJhTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737480622; c=relaxed/simple;
	bh=u9ahfzQjAWQ9A8s8dAHpSOBLTYEDEdvo67RBllq2i7o=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=UHYS0kFpn6vzxHik7cHbiItGGIQEJcjBw6oarSkGvi4GVyWVUxBM6GgrULjzXPo0QUfUUSFvH9bfHfoLcyaztkUc2LwtD7MNfqBknK7c35HSIVXQzynwOvCpAtl/LzJp7iIcPQMkc5CRGER//INGSUN3zpW6ZYErr9So1AA4in4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mnhDlCiy; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-385deda28b3so3756103f8f.0;
        Tue, 21 Jan 2025 09:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737480616; x=1738085416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ACTeJb+Bue5O35d+xgl3L7SU4BfYA0FRCcm27lTzJ8w=;
        b=mnhDlCiyBB+wqTvGoNNXxVb/9ZQk00Bz5f6G2mzcGWPXOV1UCpgA4uvq0WXt4wuINH
         tM6vWyxxctkS2gxOPH6bKuM2POhy7/YdnMZwExiJjRbPz7EG2Zzp1SpkzJ/dtQmf+Xfl
         1FtHp0MiV5dCpUn1tVfDUN5EWej6EerPI46RxHrDDqAU2vGQuCS22k4fONGrf4XBvvZ9
         2wdDXlTGgGhzBVq79KPNJ1AlVPoZNn77fn3L6v3PGrbtZ1Z6YE8y72hTRJFeRVlMx1Ft
         ics7dBxSUztQR+MvykR37HDEzMKBabp06UJgW+NfPq6ts7T2OnNtDMB/mzxbz9ASAbLl
         8hhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737480616; x=1738085416;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACTeJb+Bue5O35d+xgl3L7SU4BfYA0FRCcm27lTzJ8w=;
        b=H2xwhU3gVo8yWKJ7NENdZhzs6T2ROoDHQCSvknyx1oxZytWIwk9yR0BkT3WJfyS0jk
         YayHKlbT8Y+roqR5FECtjje6LGh6Xr16pNQN5mHaaIK79G6Qyj3GwSXm8WTJbfpnyHUV
         I7ATuFaW/LIf4uYEO+7L0ArIy553w6kiK5HylvJVfZjj5G/jD0AoNqPagAi0LV6fQ9P5
         OyR4oxp4PNBQPrEpj6Sov8PBlfaHzSXN24KWp582hhHI5OtbYyqXOUO+YNXzgw75uLkL
         VUxyo5UIW6Or/gPCJEsCfeBKT8cA9aDuP4+/NlCMa6FX0YtjnyWIAqzHLNwc2x6Ti6aj
         Dt2w==
X-Forwarded-Encrypted: i=1; AJvYcCV5uAYFPl2YLzP6Hmg5f9iB06w3Dr8aOP4RSnUM+Bh3R+co8TOlcZWvYHIzkPpnL5MCTGo=@vger.kernel.org, AJvYcCWh63Iz7nuJ6ccg2L31RqPvdqw57WFonHwQPV+oxicVl0vCS6r/K8HBRTDzHB0AMYkJT+88EItMFJp9MucO@vger.kernel.org
X-Gm-Message-State: AOJu0YxI0Hrk2F+v6W20fGva7N37grf0iVrwf/1sScFS1zrvDJQJLVbG
	oQ8o3jYmgJ4cwn4ivRilUzE7QqvxqCP4bnb/7gHXwCQDr1g5O2aO
X-Gm-Gg: ASbGncsNq9KWOYRf9wRvO9Qy3Tw8plJcXwX8VL8xe8zsMsWrtvw2ILVlM60HHb4MvXq
	PeCElFsyAAyafAjX0mI8BmaKYVzJ012Xql9dY6GmlGGVxm4/NJm0J1vTfFsGXSRE7kF2vrJXt+l
	OP3MZajKih9kTJnBFUy3veM1+3vAXWovdeV78cw65SCVCbgmdhQzheYM/H/NEs9muqX22vtmUpc
	i8+MatKpZqNCelO+8IkRgLBoEbJ2I6T/RjfBrlFFd67MPhgb1DXbAVoXJjPc1N+F2ztMnJRpcTM
	OOpAU6VP2BxQ2lMpacmX+E7vNg==
X-Google-Smtp-Source: AGHT+IHzIBJAm2VxZKXjWIIs4Z5rSL8z4B47z7PIwZJJj6Wp3x8fwzH3JpRj/Kp9smK7dxuO2SO6sg==
X-Received: by 2002:a5d:64ed:0:b0:385:f72a:a3b0 with SMTP id ffacd0b85a97d-38bf57dc942mr16571185f8f.55.1737480616093;
        Tue, 21 Jan 2025 09:30:16 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438a1f07e1bsm140780635e9.7.2025.01.21.09.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 09:30:15 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8a9460aa-7ac7-4e6f-91d5-f1170a1963f3@xen.org>
Date: Tue, 21 Jan 2025 17:30:14 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 09/10] KVM: x86: Setup Hyper-V TSC page before Xen PV
 clocks (during clock update)
To: David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-10-seanjc@google.com> <8734hd8rrx.fsf@redhat.com>
 <Z4_AwrFFsKg2VgYW@google.com> <eb45ff29-f551-483e-9930-1fa545fb83aa@xen.org>
 <a71d0215ebc34e132081e856f116ca5fcbda41b4.camel@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <a71d0215ebc34e132081e856f116ca5fcbda41b4.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/01/2025 17:16, David Woodhouse wrote:
> On Tue, 2025-01-21 at 15:59 +0000, Paul Durrant wrote:
>> On 21/01/2025 15:44, Sean Christopherson wrote:
>> [snip]
>>>
>>> I think it's ok to keep the Hyper-V TSC page in this case.  It's not that the Xen
>>> PV clock is truly unstable, it's that some guests get tripped up by the STABLE
>>> flag.  A guest that can't handle the STABLE flag has bigger problems than the
>>> existence of a completely unrelated clock that is implied to be stable.
>>>
>>
>> Agreed.
>>
>>>> I don't know if anyone combines Xen and Hyper-V emulation capabilities for
>>>> the same guest on KVM though.)
>>>
>>> That someone would have to be quite "brave" :-D
>>
>> Maybe :-)
> 
> Xen itself does offer some Hyper-V enlightenments, and we might
> reasonably expect KVM-based hypervisors to offer the same. We
> explicitly do account for the KVM CPUID leaves moving up to let the
> Hyper-V ones exist.
> 
> I don't recall if Xen's Hyper-V support includes the TSC page though.

It does :-)

