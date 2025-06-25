Return-Path: <kvm+bounces-50697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4555AE85EE
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 383661784F8
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3AA262FD8;
	Wed, 25 Jun 2025 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zn9iRuC5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84048615A;
	Wed, 25 Jun 2025 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860966; cv=none; b=atmpQS10Uvs4TUDZxjPs23Ey70jw2RBOALcpX/gsuXY6NIsq5uRITpkEudy30UX4ZZ8bNVzi+xM/3recJcG/T7EJKzjGXoVfSH+yHbtK6zA15X/H7zs2Ks3QaECS/q/f4bZxzFUzgnF3ZMN94dkZ/lwobpksf+gGJfNM2LcHPPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860966; c=relaxed/simple;
	bh=q5l8N7mNoykdeb46JX3+RuM69RfL20fvFf4iNZvpLRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPY6cZO4/CjnkGsPvA9IX6fcIk6eg4tUvut1Rw5vkjZeTmwQa/dPFnFqwFmftvOHGQdcM49/wK/hFd8poxWDFdEPqFzM9rirCJ2m6nnmicbSWu5i4ND4JrxQrsek8ALmIQ9bT6Wr/9sRSLHL77T4cgAjNBx1Bhy/a7SlPa3DkDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zn9iRuC5; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-234fcadde3eso93880625ad.0;
        Wed, 25 Jun 2025 07:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750860964; x=1751465764; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IATOgKBnU0rqMJpw/Pp6SRkvAhMjr6+YJ8sC6/2yZO0=;
        b=Zn9iRuC5/+q756ugMDpGE6DVo00Gjr2drp+E2Nplo9cQcEbwEtT2za7cWRaaPb43sb
         slLOoC/SrSBBkUE/7QN07jBa5fMkN2kVu8ovyk/GnRoZP7lWklKzGbHCvJDG0Lazplik
         lg1LCHEdJ3ZgN4eQT8ztYQ7C/ZuFcrZcF9y/94QjKhcG3gC7/FhkvTsgF0E66vGci8+2
         +ablljhC9c0OtGzHSCmUSXCVlzt2xqyzKsnyiDMBF08qhzbiQj4O639kPEeJWIFh3r58
         +jpwZTjXFK5KEhVTiJfmJlDgUB2YSM89PNwDzp3ZzLGlnFhsCFPeebIcz6QhYNvHx8EJ
         Neyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750860964; x=1751465764;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IATOgKBnU0rqMJpw/Pp6SRkvAhMjr6+YJ8sC6/2yZO0=;
        b=FAowX3aBXh6YRfeLkEtTicxeyUCYB7AuqtVDDh3mUDJWpFfPnPhrH08dptOqsSf23a
         zngiH7Z3DmNRG8RZNxjo/6m1FwDk/gkk5OJnmn7rWSsw0J4o/gZXLDlqgmujHGVUas7K
         H+CwPLE0e3XqvwXLEYRhwB8QcWAkEbmGcZ7GiO7dcRT2cmj3Am9TUsjuVMX3v5na82uf
         iE7tAkTBwfEEnXzMVYfG+TH3Begas3EDbfHj4aV4v663k/jCZAJWZdY0gzXunmwTMUZB
         dxVmZljAZGoaUpQOGQjTA+wG7pYK8LcUbyxZGEfWpu98riEzUfBRGBdhBpBpDsl1LmxP
         xBww==
X-Forwarded-Encrypted: i=1; AJvYcCUIz2sVyQ0yrNiEKzR7W6nCJaj6LmBAFE8oU5cbJxGRB1WVW+ntUExhy2yND4zZUekKh6E=@vger.kernel.org, AJvYcCUhxzXHcHKRawTwJimMaRbviOeBb13wuOXaR4Nvj4M0AcBaWfvxnYIg3LWaQeIvB8lDZypPDbl1lTaY@vger.kernel.org
X-Gm-Message-State: AOJu0YyPgFwGRg0vFDsm1APgTF1egvZ21XqbDUVB39hlTWFe0dSc/cPP
	2Jhm6apfjjPng31S4oKKvPjg0vOIvzgc/rF3hlvcJy5ZI2EVAnYi8tVyysY98A==
X-Gm-Gg: ASbGncuAsNfmqfDk2OA7lpfOcbsM1d8zeH/UBeXeCfkvw7WUk/I/XTRoKfJYoxJkUnq
	tCX2XGz7Cmy4KYHDdWEseMMs3dxZvr4svnRdPiralloG2YCXz7MhPHfGQRHMPwJl93KyCLZR4ic
	0gtIsScz+9l7yOeNQooAVX2mtElDxUOSU5KeswzFEXSxrsF6JPIXLlTm2NCTh3Y8PZhpA3s4xlD
	CZoA26wHcp0++MSqmi5fO5k5F1CqmLrex29RI03jYKiZG+W/s1oc2dKHNo8f9ouMFA7Pn01tZi5
	38RsEvkNyUtGKPZfcYp9Q/5+nKxD+frEr7SW7wRYJ1HqF3qGHv3DCELlGgaAnPYYsXCxuQ==
X-Google-Smtp-Source: AGHT+IF01k5X3tfD6ac+31sVKKfqdSwqu8UG8v9p3+32QVuls+7tDiWMOiI+DOT3TgOZ8agA0i6O3A==
X-Received: by 2002:a17:903:2352:b0:235:c781:c305 with SMTP id d9443c01a7336-2382404eb53mr66919025ad.24.1750860963561;
        Wed, 25 Jun 2025 07:16:03 -0700 (PDT)
Received: from [192.168.0.150] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8676123sm132988735ad.173.2025.06.25.07.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 07:16:02 -0700 (PDT)
Message-ID: <832d69ce-d409-4ea4-a4d6-89cc9222e1d1@gmail.com>
Date: Wed, 25 Jun 2025 21:15:58 +0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] Documentation: KVM: fix reference for
 kvm_ppc_resize_hpt and various typos
To: ALOK TIWARI <alok.a.tiwari@oracle.com>, pbonzini@redhat.com,
 corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20250623191152.44118-1-alok.a.tiwari@oracle.com>
 <aFniQYHCyi4BKVcs@archie.me>
 <18e6c0d1-0ee5-40fb-b445-504751df10de@oracle.com>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <18e6c0d1-0ee5-40fb-b445-504751df10de@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/25/25 21:00, ALOK TIWARI wrote:
> 
> 
> On 6/24/2025 4:54 AM, Bagas Sanjaya wrote:
>>> -This capability indicates that KVM supports that accesses to user 
>>> defined MSRs
>>> +This capability indicates that KVM supports accesses to user defined 
>>> MSRs
>>>   may be rejected. With this capability exposed, KVM exports new VM 
>>> ioctl
>>>   KVM_X86_SET_MSR_FILTER which user space can call to specify bitmaps 
>>> of MSR
>>>   ranges that KVM should deny access to.
>> Do you mean accesses to user defined MSRs*that* may be rejected?
> 
> Do you want me to undo this change and go back to the earlier one?
> 

Nope but I need clarification.

>>
>> Thanks.
> 
> Do I need to send a new patch?
> 

Maybe.

-- 
An old man doll... just what I always wanted! - Clara

