Return-Path: <kvm+bounces-37581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C3FA2C2CA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52869188D7CD
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 12:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFFF1E47A5;
	Fri,  7 Feb 2025 12:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hq1pCO32"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295BD1E1A33
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738931740; cv=none; b=QkpZcdNfmeIDCHV29BZEjaEnNPkcxH3CMw+3/rWx0gPmGkYswoF8dS8ZD1+Iv3UcR4j7gCnlaoyTF2tF/Aa11AYzmyuT396+SektxvqatIr9pN67zApB/17SXnj9oUdGucnl2klCmHtL4zyKs+J0YtiDQCkSxjpU/sYes8wr8JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738931740; c=relaxed/simple;
	bh=v+flGDnJs5ydAC51ycHpWPTrVu1kQtWmSWihCrY9hns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=stTZT1dKclyWynBf6o7LIT4C0jIkI+prOZNKBMnF/wiDJIgVO2HGygkO21V+uNCPgj+U7uJti5AqewYN5WwfyHZGCTwIz3zGfXwLP1WjQHB7GSlCJGPIgDQxQ/E95KqG/YuKAPyNkSoTfbokkAtVaw+qt5Jw7dmMjM+DkreprHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hq1pCO32; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738931737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vtS6MUQYBAgP5mlpzHtkqXazAG0CUcPyExaUVdCXkoM=;
	b=hq1pCO329sxXwQRhiaZI837sRuSlCPbJnBSNz6z3RPSePrBOiKN66aCYW92q5HjDUVgmiB
	fvoQnk+ddSEUiI0KSPmIjvM3d0UxPPeJHWRBsp0g434szJqKXtuDcnYvGwBCytrBvueiyp
	ULef9KuuLAzQmc05ruP6yCgCaJzOTnU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-Fm1aVyTBMMaJi8wYZXPoFg-1; Fri, 07 Feb 2025 07:35:33 -0500
X-MC-Unique: Fm1aVyTBMMaJi8wYZXPoFg-1
X-Mimecast-MFC-AGG-ID: Fm1aVyTBMMaJi8wYZXPoFg
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38dc56ef418so593533f8f.1
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 04:35:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738931732; x=1739536532;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vtS6MUQYBAgP5mlpzHtkqXazAG0CUcPyExaUVdCXkoM=;
        b=pEgLavh/HqW9BbluK7gFi94JCLZPYx88y2QvmJmxs85Q7p9PT5BItsIiRWv4DffGg0
         2eWn3mYy0vMvqRIgt1UWGEd/jlQZXvHWmIA+NGgmC55uq5TTHpNAcVK3h2XXVAyOkvR3
         DnyUcrymsukm00N80zcC9bcb1PjtY/417vJYoLxb8qtZaxTjQUIxlOE4t3YY5jQUrcgL
         o91rDVTVvEL+5Bi94MjJLk/ecEWyuDQ2S0EdeqZnYKfoyEtDTffJ78eLQJc8ttw3nGQ4
         BioywXCtZiDNra0/41AwIb1QpaqXKTt9DQ1eamV+ZnzE74rQpRH+3HjPnrqwTo3zSyQO
         u/UQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlH0xu7cWYMYaI8ayy5S1VtbElzIjkbISpgv8kPLYIBIJqMJZXaSUgIrS+QcQqLni+TDo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaYGExU2B8PKKxp0HWo4mBQhlrKBpOJ4ILZcnoFID60TUZP6T2
	2jlV8VAXWWeD9Yqi7mwkcRQhRqknoRxQlYtEYm6ADUCxCWcaFEHbXkZItczOQw5M9umpCmbfZBi
	RxyLg+gjVoRZct2GKflT1pRR7nmGCWT6xy/3yAREweiKQDdhswQ==
X-Gm-Gg: ASbGncuUEeApMmNuhYqn22ELPw2ennYgLs5zhiYrcSWQhI6/G9b69OlfQ2egl71J3by
	100qVfiSpzCTTPjN4DNB513Vn1wxEJ6tSnzpBlfZarJSmCIBbv74gnKwptXv9GeQrwYD7P9WxvL
	7m9pccKrUh9IlM3hFzWzrf0IyvEnNsAZHCi73l8NT1YAGpUo+G/lG8RwOLfaL4CHYq0bKhcUPzt
	jGMleU6xHoBzwBVlk6r6KYCMS9EkbjChoQco2F/RFEewlGQDvt8M/tTSM2pZocK04xvV7uWqB5M
	Gmo7TvvQM0YuYN7lk48/JnGsussSZgsSfrt1gxzf0VDpl4hIK33H9QLC1ftzTcTyCI+aj3bLz2V
	UGHo8WZ6+l6maUmfXLYgOun4xS6/ZPXHG+Q==
X-Received: by 2002:a5d:638d:0:b0:386:5b2:a9d9 with SMTP id ffacd0b85a97d-38dc9497d11mr1330969f8f.53.1738931732522;
        Fri, 07 Feb 2025 04:35:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzlYHsLZVY/Yw4cQDwMbMt6y2d8TLcRrPFXM0BvcWOfIWrbMFNkzdlXAGp79CG+cvVsjsBBw==
X-Received: by 2002:a5d:638d:0:b0:386:5b2:a9d9 with SMTP id ffacd0b85a97d-38dc9497d11mr1330899f8f.53.1738931730737;
        Fri, 07 Feb 2025 04:35:30 -0800 (PST)
Received: from ?IPV6:2003:cf:d712:44fb:19ca:1c3d:6b27:934a? (p200300cfd71244fb19ca1c3d6b27934a.dip0.t-ipconnect.de. [2003:cf:d712:44fb:19ca:1c3d:6b27:934a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcf35b15bsm668676f8f.64.2025.02.07.04.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 04:35:29 -0800 (PST)
Message-ID: <f3639df5-05cf-4aef-adfc-8a39ed7767ce@redhat.com>
Date: Fri, 7 Feb 2025 13:35:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Call for GSoC internship project ideas
To: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel <qemu-devel@nongnu.org>,
 kvm <kvm@vger.kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
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
Content-Language: en-US
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 28.01.25 17:16, Stefan Hajnoczi wrote:
> Dear QEMU and KVM communities,
> QEMU will apply for the Google Summer of Code internship
> program again this year. Regular contributors can submit project
> ideas that they'd like to mentor by replying to this email by
> February 7th.
>
> About Google Summer of Code
> -----------------------------------------
> GSoC (https://summerofcode.withgoogle.com/) offers paid open
> source remote work internships to eligible people wishing to participate
> in open source development. QEMU has been doing internship for
> many years. Our mentors have enjoyed helping talented interns make
> their first open source contributions and some former interns continue
> to participate today.
>
> Who can mentor
> ----------------------
> Regular contributors to QEMU and KVM can participate as mentors.
> Mentorship involves about 5 hours of time commitment per week to
> communicate with the intern, review their patches, etc. Time is also
> required during the intern selection phase to communicate with
> applicants. Being a mentor is an opportunity to help someone get
> started in open source development, will give you experience with
> managing a project in a low-stakes environment, and a chance to
> explore interesting technical ideas that you may not have time to
> develop yourself.
>
> How to propose your idea
> ------------------------------
> Reply to this email with the following project idea template filled in:
>
> === TITLE ===
>
> '''Summary:''' Short description of the project
>
> Detailed description of the project that explains the general idea,
> including a list of high-level tasks that will be completed by the
> project, and provides enough background for someone unfamiliar with
> the code base to research the idea. Typically 2 or 3 paragraphs.
>
> '''Links:'''
> * Links to mailing lists threads, git repos, or web sites
>
> '''Details:'''
> * Skill level: beginner or intermediate or advanced
> * Language: C/Python/Rust/etc

=== Asynchronous request handling for virtiofsd ===

'''Summary:''' Make virtiofsd’s request handling asynchronous, allowing 
single-threaded parallel request processing.

virtiofsd is a virtio-fs device implementation, i.e. grants VM guests 
access to host directories. In its current state, it processes guest 
requests one by one, which means operations of long duration will block 
processing of others that could be processed more quickly.

With asynchronous request processing, longer-lasting operations could 
continue in the background while other requests with lower latency are 
fetched and processed in parallel. This should improve performance 
especially for mixed workloads, i.e. one guest process executing 
longer-lasting filesystem operations, while another runs random small 
read requests on a single file.

Your task is to:
* Get familiar with a Linux AIO interface, preferably io_uring
* Have virtiofsd make use of that interface for its operations
* Make the virtiofsd request loop process requests asynchronously, so 
requests can be fetched and processed while others are continuing in the 
background
* Evaluate the resulting performance with different workloads

'''Links:'''
* virtiofsd repository: https://gitlab.com/virtio-fs/virtiofsd
* virtiofsd’s filesystem operations: 
https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/passthrough/mod.rs#L1490
* virtiofsd’s request processing loop: 
https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/vhost_user.rs#L244

'''Details:'''
* Skill level: intermediate
* Language: Rust
* Mentors: Hanna Czenczek (hreitz@redhat.com), German Maglione 
(gmaglione@redhat.com)


