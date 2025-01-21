Return-Path: <kvm+bounces-36139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A1BA181A9
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E8C43A1E0E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBAD51F428E;
	Tue, 21 Jan 2025 16:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CwCvnvP6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7E61C36;
	Tue, 21 Jan 2025 16:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737475517; cv=none; b=fCSB6yq6fZxaKurKqwjwjR74spVSX9S/i3kJAT6M7sWA1cuziWkGIHTSVOCjtV0dwLamYuQl5QGxjzeS4yWWzjjjJ0Xswzfp1th+eonuynU7ZthOjA4B6ghAQVMXVTDl93RhyklYMB2AJg3+4e+eSVrZHHyWFlHtq+VpO8sDXMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737475517; c=relaxed/simple;
	bh=DxTB7orBUqdSlHxkei0NIU/4zEvOY2IG3d1K4rypfpc=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=sAmvnVa0Vlrm+en9JO8xzNmsFW4mEICNGMVZKBtG6/7lKZCxgb1/OMwAoVTu5DjnMovxHPAP5gCEc/j04bZRuTrk+an93yWNyeeuBJbEJ3YPlRJrL0jaxTgv4SVAX5hwvBFMk6jM6lwwsoCWGICj5yTVuUP3clbXh+FSFiNisHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CwCvnvP6; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-385deda28b3so3695234f8f.0;
        Tue, 21 Jan 2025 08:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737475514; x=1738080314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vc+pPc6fyuH9pniT5NkMbap4X85IXpE9Tcaxxgvn1yU=;
        b=CwCvnvP6zwjfm1D7qKrsadnYbLcUo1CxVEoqB9vTDotRKA+gBPUsabhkH4v12HivA1
         FWMsng/dVzzQVyjJI9l22xhuE/xf3mjkYQmWx0jTpy7IGBbV46cbHz0LRDhf3t6rv24u
         nJhD4sRNJRhqpCkpRHw4kLDh9uyvLTkTQi82hhyanq3tEd4FVCbhcnFrgXoHwZujFs0o
         aNmxat4dLF3Mf4VxVn4pwnxHgsy2kayrsrNYqhVx26WfIUaq9/qW2Yqk8/2tLedIqGwh
         BqtZ++eyzQr1jOhzapT8OnpsQIXbobUn6zsNG6EDFW/FAWoVPnuAym16qCg+8JCLDqgG
         p/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737475514; x=1738080314;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vc+pPc6fyuH9pniT5NkMbap4X85IXpE9Tcaxxgvn1yU=;
        b=tO44xzOQ/6lfNUipSDEEtfaOf4V3dF3WUffWv7o38tcQNxhskFDglcU059Uico1py1
         QZ+24xZHNWY/j1tz6OdHyj8t9u9kquA6tcKc1Szuv22n/aZTVcg+5D10vsccsKsyaf6S
         d3SxV9l3x5RCESWUhMa9+oOUcX4gH83dxFCFvz1rSxxHFRmWPvhqAnANmkkXt7mZBRgm
         ZTc6orLHIh7jCooieDLOoeIsDCbaLNn+Z8WCnI6t+d+zEahLKBrwzUh95iQsbUvXiodL
         9PBHQicOeH+xF97bY1Wie0jmqMdSIo09LCWmcizx6jpjR6nPd/I2f38b6MaC1/vGUKmW
         T3Fw==
X-Forwarded-Encrypted: i=1; AJvYcCWyAALvii6wutUbvr/JxKWySV28iGpru0WTYhX5gwcdqfafWuQHmc7qpPQfoziQAReYlklJUOyCNv0IzW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLmCVNRlztrjoL3zxi3mr58dtOL8BrNDX0ZUKRlRnFgUu+mNT/
	SLxfJF7nqNYVYkmiwhGrh+J0aQaE/Wh8oHMDHGO6v+js5Mrl6u8m
X-Gm-Gg: ASbGncu/NVjl9fMq6NYjV+e1a4JIfGNQ8gquUss9/s5t1vJiEfRBpw3qqDVb41RlAHj
	gdcG2N8a6lBLLvEzReKW/381EHOMaLImLF1SOnrgLe3UN3fGP8YYYHj+SJDMv8IXJBNwGZGoe5v
	KG/nFim+1ss989x4cSJx2Epo+Dj5bqQUQVVuwJfyUqYp6KLDhKO+56We5+veU2S8HL0sIcWd0dC
	HsBZRCl1naIFFQa7aiirbsY43LepIMAwuuXwuGXDb+Yva1KlFMDF+BCdWOMp31RiQnEDatdHd7L
	6LJ9nGvTTHz7o4Jfbv6SoqodVQ==
X-Google-Smtp-Source: AGHT+IGKVUEKD4iXc/CQhvVfL3T7uxyF+e3yxkEo8JuFruV77t3grGXv8j/u3ezCnE4V4GfEoSBJRQ==
X-Received: by 2002:adf:e105:0:b0:385:fd07:85f4 with SMTP id ffacd0b85a97d-38bf5678c42mr12572364f8f.31.1737475511943;
        Tue, 21 Jan 2025 08:05:11 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890469ba8sm182044045e9.37.2025.01.21.08.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 08:05:11 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <f5294177-26d4-41e7-aa9c-29e9b7e3bd3f@xen.org>
Date: Tue, 21 Jan 2025 16:05:10 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 03/10] KVM: x86: Drop local pvclock_flags variable in
 kvm_guest_time_update()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-4-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> Drop the local pvclock_flags in kvm_guest_time_update(), the local variable
> is immediately shoved into the per-vCPU "cache", i.e. the local variable
> serves no purpose.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

