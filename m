Return-Path: <kvm+bounces-37587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3DDA2C412
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:48:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1396169641
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFB21F4169;
	Fri,  7 Feb 2025 13:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/TBsGn6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E772E64A
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 13:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738936106; cv=none; b=G31Xn2SIQmmZ9nPE+BDfI3eTv4gfSh72UDKXL2uA9YOSz7aTl5H49AU71eQtCsx5U0JZTuA8LZvwuGd3TZOzxZIKl4gBxf4vgbWmZgykbO5ZqRAdEGH1d/1WQ6tnp14kKCKPUgd2HfaoLGUwdp4/7Qg3GDNSuaNbN21PMd3I6G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738936106; c=relaxed/simple;
	bh=wu/4MbgT4uMiDTGeao9f1ajDVjdN3QB4LwV5OuUMvpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2/X7NIKd097jBhgo4lvSaHYm0+xz/AbnVSkvEia4Su1r50Zz1TUefpl56ytxSSUL+8tO2YEq90hxuTzP6nuwC6TdlaO2C4TCpjba66GQZ0oUPndviJhRLNJJ+qVxuG2fi42Q//d0ZRuCYZ8jUnFDh3lrekCZC7i+gWCC/gbye0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/TBsGn6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738936103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oocHq1tE0J56Z1msQqpJpwEdwC4XO8/Z1+ZEBp+1m44=;
	b=Y/TBsGn64hu/2ALf4cF6v3oN00bCNCFNrDDIorXNZK+0zWstgp/q+ygaWExQ2E4JA2YWvZ
	EylrJKIOA64fUuKQP8l5uwvOXbaTYM+mPWuuGRtONJYsD/4c/VNnTRTc6nSdy5DR6YbSNQ
	egtzwMMK5BCurNYI+Vh3/YWwY/fDu3E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-ow4PexG8ODS7l615c9BmIg-1; Fri, 07 Feb 2025 08:48:22 -0500
X-MC-Unique: ow4PexG8ODS7l615c9BmIg-1
X-Mimecast-MFC-AGG-ID: ow4PexG8ODS7l615c9BmIg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361fc2b2d6so12869995e9.3
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 05:48:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738936101; x=1739540901;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oocHq1tE0J56Z1msQqpJpwEdwC4XO8/Z1+ZEBp+1m44=;
        b=nGp+wzWPKse3SAgT2Rj1qVzRK/wS++6CW/yVpEH2sczbRgYOnW4rTVHGjLv/K/oxI7
         gBtwqjAXvLkILb1IP6FAjPOio2B9xA/j//U/EjyeMas6/AcGr5Us83s2WVIBJ8/SS7oZ
         feNs/9umrExvvyboQCMTd12JJtW4Z7PPZ92gLSMbx3fX7mHcsXkF4OIfKbhFi4waOvm2
         FN+CQBy7/sehTwzQJ79VHv2XJalS5WTtoXoEZzv9DI+BVcONfhlOAzS0fvzsnEHzh+5s
         e7E4yrJf8r3fFbuTJNvAQ5vmsPkuSR/UK9jVFwY5qQ+m5CeuElr61LOVEG4b9qVhgx9N
         Ijdw==
X-Forwarded-Encrypted: i=1; AJvYcCV7sG58j8kZeAgC2JRJnrJWvvlZCvanGrLZiC43zOQb6PAY42IyDna+C3q/plIHX89P5z8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzls+IVGfL8HHbnlhqk9uLTAf/8CAYqP0xN3JNYVbL+NC0z4PZu
	T0gmGB1muDG3s3pStqF9ftno72ibtapyrddqNMGXt2D3ZxSQC3i9kOCJVE39Vx4EormZHvp8rux
	Ce9VedJKTniC50QnCo+d8iMqZGagfUplf7DBzZXQUf8fSxNIEPw==
X-Gm-Gg: ASbGncuM4mcL0GqDH6z+RVYmYkFz3wvhnJJhA8tp+oNKFswtbr2Nx7x7lLhVQZeVqeu
	ACgG/ogIDvcm/PKlynfUDpZWynGHDvJpv+o3mLAfkTOzLdbLbI4pPWxtnsYhAxsERd6azxd5XIV
	ZSUTCYAhbIBGINiT0R2Q1CeUF3rk26zYW1fkWFZ9+Fd5q2ru8uGq6Vh9NrcqSchd88GonugP3fK
	fJTMvZU3Ch1497yGaRSN0zHHiLFQnvWHz1yF33OuerQ5GM3/gt45x7X3LxtifSg02jKGrGQON3A
	h7mRBQTrEioTCoESIRjU1cxi6mG2YoAHDs2J4w3kUkRINotdI/tiWsMYv8iSPK/2fjRPA+Ra+ZT
	UZDJvGyWBtMPXQniErjL6aH/RHmKCO7mmtg==
X-Received: by 2002:a05:600c:a45:b0:434:a923:9310 with SMTP id 5b1f17b1804b1-439249913a5mr31390765e9.15.1738936100952;
        Fri, 07 Feb 2025 05:48:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJvxNkuaO/bd8Xm6z7ZexWgm5qQX4iRxNntYdl99g/Musovi08+5k5In8E3W8HxV1v/oX3qw==
X-Received: by 2002:a05:600c:a45:b0:434:a923:9310 with SMTP id 5b1f17b1804b1-439249913a5mr31390345e9.15.1738936100510;
        Fri, 07 Feb 2025 05:48:20 -0800 (PST)
Received: from ?IPV6:2003:cf:d712:44fb:19ca:1c3d:6b27:934a? (p200300cfd71244fb19ca1c3d6b27934a.dip0.t-ipconnect.de. [2003:cf:d712:44fb:19ca:1c3d:6b27:934a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dbdd36967sm4620439f8f.37.2025.02.07.05.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 05:48:19 -0800 (PST)
Message-ID: <0a85b381-35c4-424f-9052-7b321b1afe02@redhat.com>
Date: Fri, 7 Feb 2025 14:48:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Call for GSoC internship project ideas
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 "Daniel P. Berrange" <berrange@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Bennee <alex.bennee@linaro.org>, Akihiko Odaki
 <akihiko.odaki@gmail.com>, Zhao Liu <zhao1.liu@intel.com>,
 Bibo Mao <maobibo@loongson.cn>, Jamin Lin <jamin_lin@aspeedtech.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 German Maglione <gmaglione@redhat.com>
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <f3639df5-05cf-4aef-adfc-8a39ed7767ce@redhat.com>
 <CAJSP0QUOzyqE16HL+QfXqQA3oZQ=4b=nt4_8JkoSSx5U_b7MsQ@mail.gmail.com>
Content-Language: en-US
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJSP0QUOzyqE16HL+QfXqQA3oZQ=4b=nt4_8JkoSSx5U_b7MsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 07.02.25 14:41, Stefan Hajnoczi wrote:
> On Fri, Feb 7, 2025 at 7:35 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>> On 28.01.25 17:16, Stefan Hajnoczi wrote:
>>> Dear QEMU and KVM communities,
>>> QEMU will apply for the Google Summer of Code internship
>>> program again this year. Regular contributors can submit project
>>> ideas that they'd like to mentor by replying to this email by
>>> February 7th.
>>>
>>> About Google Summer of Code
>>> -----------------------------------------
>>> GSoC (https://summerofcode.withgoogle.com/) offers paid open
>>> source remote work internships to eligible people wishing to participate
>>> in open source development. QEMU has been doing internship for
>>> many years. Our mentors have enjoyed helping talented interns make
>>> their first open source contributions and some former interns continue
>>> to participate today.
>>>
>>> Who can mentor
>>> ----------------------
>>> Regular contributors to QEMU and KVM can participate as mentors.
>>> Mentorship involves about 5 hours of time commitment per week to
>>> communicate with the intern, review their patches, etc. Time is also
>>> required during the intern selection phase to communicate with
>>> applicants. Being a mentor is an opportunity to help someone get
>>> started in open source development, will give you experience with
>>> managing a project in a low-stakes environment, and a chance to
>>> explore interesting technical ideas that you may not have time to
>>> develop yourself.
>>>
>>> How to propose your idea
>>> ------------------------------
>>> Reply to this email with the following project idea template filled in:
>>>
>>> === TITLE ===
>>>
>>> '''Summary:''' Short description of the project
>>>
>>> Detailed description of the project that explains the general idea,
>>> including a list of high-level tasks that will be completed by the
>>> project, and provides enough background for someone unfamiliar with
>>> the code base to research the idea. Typically 2 or 3 paragraphs.
>>>
>>> '''Links:'''
>>> * Links to mailing lists threads, git repos, or web sites
>>>
>>> '''Details:'''
>>> * Skill level: beginner or intermediate or advanced
>>> * Language: C/Python/Rust/etc
>> === Asynchronous request handling for virtiofsd ===
>>
>> '''Summary:''' Make virtiofsd’s request handling asynchronous, allowing
>> single-threaded parallel request processing.
>>
>> virtiofsd is a virtio-fs device implementation, i.e. grants VM guests
>> access to host directories. In its current state, it processes guest
>> requests one by one, which means operations of long duration will block
>> processing of others that could be processed more quickly.
>>
>> With asynchronous request processing, longer-lasting operations could
>> continue in the background while other requests with lower latency are
>> fetched and processed in parallel. This should improve performance
>> especially for mixed workloads, i.e. one guest process executing
>> longer-lasting filesystem operations, while another runs random small
>> read requests on a single file.
>>
>> Your task is to:
>> * Get familiar with a Linux AIO interface, preferably io_uring
>> * Have virtiofsd make use of that interface for its operations
>> * Make the virtiofsd request loop process requests asynchronously, so
>> requests can be fetched and processed while others are continuing in the
>> background
>> * Evaluate the resulting performance with different workloads
>>
>> '''Links:'''
>> * virtiofsd repository: https://gitlab.com/virtio-fs/virtiofsd
>> * virtiofsd’s filesystem operations:
>> https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/passthrough/mod.rs#L1490
>> * virtiofsd’s request processing loop:
>> https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/vhost_user.rs#L244
>>
>> '''Details:'''
>> * Skill level: intermediate
>> * Language: Rust
>> * Mentors: Hanna Czenczek (hreitz@redhat.com), German Maglione
>> (gmaglione@redhat.com)
> Thanks, I have added your project idea to the list:
> https://wiki.qemu.org/Google_Summer_of_Code_2025#Asynchronous_request_handling_for_virtiofsd

Thanks!

> Do you want to give any guidance on which crate to use for
> asynchronous I/O? Do you want async Rust (e.g. tokio) or not?

That would depend entirely on the student.  I’m open for async Rust 
(tokio or even homegrown), but they could also decide they’d rather do 
it in some different manner (e.g. with callbacks that would return 
descriptors to the guest).  I’ll add that info, if that’s OK.

Hanna


