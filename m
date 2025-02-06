Return-Path: <kvm+bounces-37461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F51A2A4B2
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01E9818878A1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A0A0226885;
	Thu,  6 Feb 2025 09:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R/19TF05"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C556E226162
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834470; cv=none; b=FW0KAsjrCxxUPt5Wd9qCU6z0UV7Xyi3dzAjxCyBwErXgOjLwcbUfr9AiDdfj/2nL/VSm2jKBhHiiLKTDGP8pNJEF3xuYSl9ns2csU0XyQ9i7G3QmGoU+dBtDNgZLpuQBCaPs9NBgB3l7pJdr/s/W9XcVSEm13+PDomldDqDizV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834470; c=relaxed/simple;
	bh=S7FouMpLbdA1WPWAEV72WH62xBGMgP+Ss8VtnLymgFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aB0uwFYhozBMt5/pp7aIiHaHWmhomp5zbiT6lM1xBMSpebCpWtBgjkLc3at2AO6FcESAxp99gJuk/LPW3d8u0R2RNowjYFA00J5RD7uk/UckPTyWNQoqs25xM9TkB4fAj43olqOxbzq6+xX5/YX1m+tF+17v/Cz4Jp6UQprIkSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R/19TF05; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738834467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P4ZHJjPRFMKV2LyTsMjVC9uMgqNHhpd5qSqQo6h6SPo=;
	b=R/19TF0548Rpnah57RXP7UQCPLlWYrR2L7f/4fdZLIQsSH0K+Pj7lhK484oyeIe9fHHF/y
	89hzbuLVXbwCO9OMsIqklFN3NWH286mnYBjN4YbYi0fkSQ4l0Ryy5PvY+CVKWHuGUgz7/E
	1P0l11OMuP+J7Dd4J71NiISjdM0sDOQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-ka-uPLNMPc2boqlw4zI8sg-1; Thu, 06 Feb 2025 04:34:25 -0500
X-MC-Unique: ka-uPLNMPc2boqlw4zI8sg-1
X-Mimecast-MFC-AGG-ID: ka-uPLNMPc2boqlw4zI8sg
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4361ac8b25fso4001765e9.2
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 01:34:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738834459; x=1739439259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4ZHJjPRFMKV2LyTsMjVC9uMgqNHhpd5qSqQo6h6SPo=;
        b=JNoThprDtmmAUe6YZjAsAXvGa2TOq+hMji8ocCJbZGY92UTSWTDUE1FjXqMID0bbs7
         6D0Yo5zrrABdxjsxs5zbXuMN5DKXt2JoZ3Tro/Hc4OTG4+TSxXUr5nXSTjB9Hw84nYD6
         YdSem7GjZU655/wpwn8Ql7VGuYDEmKviKlD36YCgKbK3bfAy1nBf4JDkpvgoBU1TBErw
         yhHsYuW7nE+ILqOrOkmkA/Mma8xJ4B5hcWBHQpEdxUUyA6JOMqYNJJgOMZtOO/kmi6ly
         PXAHl0GLJ6mBhMUEo4OnZBmm7/ZA+i2gK9f6Ke4KrY/K8faIfI7Jo6kjTMLJ8fvIWtUV
         naOg==
X-Forwarded-Encrypted: i=1; AJvYcCWIhi1FHLLHvKMRmwtBdQHRwMpejKAYHZ3iRwFuD43W9PGH5qBs1aS2wZW2Jrm6xJiVVz8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmPKWuvlF5HO0jXEtefmWbcB81tASJFWUnjj0cTzg9bWctaq1k
	c7FCstf9U7q3gdUmhnG8jtXIJkue0KEj7fJ+sDIrRkv8v0qCS9Pb0Tc8bA7uO9IWdQMz/XR0Sdt
	LQ/+MbYX8PXqj2Zcc51Kf2ByBzF0gsN/lig3R98yl4FlDjlls2A==
X-Gm-Gg: ASbGncuaBrPW7/US8IJxeI1e1hk6Oqt9MhAljkP9+QWT+s/HgOAd1GDb0tgRKn+HLPo
	jiRgYkrdPiGOTGvsNyoYt0ziqmsYveJQZWiEwUbf2qBdYJfSgJCdTB5CH43JfDeEOLAIzKmvFpb
	4039KCOA+vTH42X4Sad9W6wX4MCrayImJpp3JkLjFT2hmykzOIRzqBhe4zqiQt05VPcrgoYtJUa
	I7iRYqM5oJQZDS4or63QFFgS/GKJQTjaTauORuVX4PtDbVUKajHD/iXjAFMkRUKqEPIqdhYy4o=
X-Received: by 2002:a05:600c:1c9d:b0:434:9e1d:7626 with SMTP id 5b1f17b1804b1-4390d5a2e06mr40199445e9.25.1738834459516;
        Thu, 06 Feb 2025 01:34:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHy2fOO/MU56iUKzPnZlhBwxpOevv3LvEJRLHdAajpCbdN4rFxi6UgPiA9NlUPEvJo9+svERA==
X-Received: by 2002:a05:600c:1c9d:b0:434:9e1d:7626 with SMTP id 5b1f17b1804b1-4390d5a2e06mr40199075e9.25.1738834459019;
        Thu, 06 Feb 2025 01:34:19 -0800 (PST)
Received: from fedora ([2a01:e0a:257:8c60:80f1:cdf8:48d0:b0a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390db11750sm49963365e9.40.2025.02.06.01.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 01:34:18 -0800 (PST)
Date: Thu, 6 Feb 2025 10:34:16 +0100
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Bennee <alex.bennee@linaro.org>,
	Akihiko Odaki <akihiko.odaki@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>, Bibo Mao <maobibo@loongson.cn>,
	Jamin Lin <jamin_lin@aspeedtech.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>, felisous@amazon.com,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <Z6SCGN+rW2tJYATh@fedora>
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>

On Tue, Jan 28, 2025 at 11:16:43AM -0500, Stefan Hajnoczi wrote:
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
> 
> More information
> ----------------------
> You can find out about the process we follow here:
> Video: https://www.youtube.com/watch?v=xNVCX7YMUL8
> Slides (PDF): https://vmsplice.net/~stefan/stefanha-kvm-forum-2016.pdf
> 
> The QEMU wiki page for GSoC 2024 is now available:
> https://wiki.qemu.org/Google_Summer_of_Code_2025
> 
> What about Outreachy?
> -------------------------------
> We have struggled to find sponsors for the Outreachy internship
> program (https://www.outreachy.org/) in recent years. If you or your
> organization would like to sponsor an Outreachy internship, please get
> in touch.
> 
> Thanks,
> Stefan

=== Adding Kani proofs for Virtqueues in Rust-vmm ===

'''Summary:''' Verify conformance of the virtqueue implementation in
rust-vmm to the VirtIO specification.

In the rust-vmm project, devices rely on the virtqueue implementation
provided by the `vm-virtio` crate. This implementation is based on the
VirtIO specification, which defines the behavior and requirements for
virtqueues. To ensure that the implementation meets these
specifications, we have been relying on unit tests that check the output
of the code given specific inputs.

However, writing unit tests can be incomplete, as it's challenging to
cover all possible scenarios and edge cases. During this internship, we
propose a more comprehensive approach: using Kani proofs to verify that
the virtqueue implementation conforms to the VirtIO specification.

Kani allows us to write exhaustive checks for all possible values, going
beyond what unit tests can achieve. By writing Kani proofs, we can
confirm that our implementation meets the requirements of the VirtIO
specification. If a proof passes, it provides strong evidence that the
virtqueue implementation is correct and conformant.

During the internship, we propose the following tasks:
- Get familiar with Kani proofs written for Firecraker
- Finish current PR that adds a proof for the notification suppression
  mechanism (see [2])
- Port add_used() proof (see [5])
- Port verify_prepare_kick() proof (see [6])

'''Links:'''
  * [1] Kani source code - https://github.com/model-checking/kani/
  * [2] Notification suppression mechanism PR -
    https://github.com/rust-vmm/vm-virtio/pull/324
  * [3] LPC Talk about how we may check conformance in the VirtIO
    specification - https://www.youtube.com/watch?v=w7BAR228344
  * [4] FOSDEM'25 talk current effort to use Kani -
    https://fosdem.org/2025/schedule/event/fosdem-2025-5930-hunting-virtio-specification-violations/
  * [5] https://github.com/firecracker-microvm/firecracker/blob/4bbbec06ee0d529add07807f75d923cc3d3cd210/src/vmm/src/devices/virtio/queue.rs#L1006
  * [6] https://github.com/firecracker-microvm/firecracker/blob/4bbbec06ee0d529add07807f75d923cc3d3cd210/src/vmm/src/devices/virtio/queue.rs#L966
 
'''Details:'''
  * Skill level: intermediate
  * Language: Rust 


