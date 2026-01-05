Return-Path: <kvm+bounces-67082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E578CF5B70
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 22:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DCAAD30BCA8F
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 21:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672E23115BC;
	Mon,  5 Jan 2026 21:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EutnPbj3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EB81A9F85
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 21:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767649662; cv=none; b=SSWg6yxJD4PTCSZVrcE4wpTsJERSZhnWavIQH3m8jWv5NDjOjEGljb4JwCZGzGj075hqQ6SkidDJPPUXiWMQGPC64+NcWYKYZayq9JiHqgteR8bY14V0VSEcKZwnjcw3G5lVSqCqdJ2B7/PtnNs0wFXRiD8LbaDk+nJGQVRVLSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767649662; c=relaxed/simple;
	bh=xwq/+u1snyOM2qlXuEWFVd7bVZejAJMruGaE8Htw3t4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=bQrp9Mqf2pgoyCUSAaTH2o1csZQ6ecWg+70raSICWySx3jpRUhWPu9yHnrhWjJ4mez3404ddIfpV3V41MYdRYhk1lVYgPkG6n0p0ySbvD71f8FR3zyvxlpo/GNxuUpymll4gWnXj6MvApqtGmC+g2UCselSgxuKOOZby4lNcfyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EutnPbj3; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso669533a12.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 13:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767649659; x=1768254459; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xwq/+u1snyOM2qlXuEWFVd7bVZejAJMruGaE8Htw3t4=;
        b=EutnPbj3lhvvPlDUKuGa6N0JpnjOpovmb9PfQtrIbjTUOdMfi8zQnf9Y0zZDKCYwvP
         9uSaRwKLy89FtcSKS98aIWE8UwaQU+h8aNISkXYqLYmctnVbhdcHjzrY8LpG384xqUU7
         zgFPsBMTK9AQWu6eU9V/CU69NzVJSRwcbW0UVv030wq8WFLTCPP4h50APAYJBIAu+Xf+
         uGdaddlQPMETO5HbdwysNFeqGtvuCjADzuY2IWxbYnPehERH7juZVUjVtEOPkxuhU6pf
         tAhFu73bj2YOSuDbpNUxVKPxEHV8Lcfg/XnzF9YgmpLxhuQCGQtvuwF3lWaeEyi1ANeu
         9GBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767649659; x=1768254459;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwq/+u1snyOM2qlXuEWFVd7bVZejAJMruGaE8Htw3t4=;
        b=s3AR+/7H59byN9sAaH8kLHsxHzjxQ/Q+jWZfQ/9ik2AWz27mVRx+Jpyhb3pg/KoISM
         DjLQYRBn1JvDEsUl3lmfsEqjGhIAbFG4UHXoM6At0KjQxMKmy9zo8FjPlA0NOpPq349r
         ZjEl3h13Fujez3RWdblK430B8a+ju6QoyocKyUy3ZriTPpDPXzmr2oNBYhg4sBG+3bth
         40WqIM1TgsE4hiR0lBfgmFqEr/+KNtzWdtOVzrg+AWD8iu8Vq5mKzqr766Aui7UMhlIb
         3CwDiM+pwFs9khLG7q4rmiJtbUP+UyWaEuctx0gBEEmRg99e+2kk71nHkn0xftdp/XxL
         FRSg==
X-Forwarded-Encrypted: i=1; AJvYcCWqQrQjwjS5i0jK5Tb++YayFQuyD1L1SxBY4KzcGLVDIbcc77nYFW/ma7YXyJqOEfPbCak=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZSKg4SOFg/dRKKD5boNFCctlSFVHYWoJYe4NKXfE1M4OjWCNT
	gIS7OuLPyZX6mqlPJq+TL1LwwqJ8zwUeXBeTYWbA7t5IiIbcDoE9NqXI404nm3hj01KH9gCX5BN
	q5Q002W2TiqQanxGvmFby0Wr5n1ruPZ0=
X-Gm-Gg: AY/fxX5Ma8UrR9EZS4p+qanDV3wyQ5TOVB2A1ZF80F+TLtlt0uXxhNtuGfR4wDK+jsa
	JRK+eqS5T7bY5mfgEzIzy+ZTDsJEEsIny5KZQ8tPQ5wtpp2gYrYVLE8FykjSnK10FHQuuRrqeSC
	ux4JGHoCffh+DNhDTWQg/hVw5UkFa40fkbPXgNduNfuuGxQWbW8HHEd4qqt1NxmZGm98a9Doia4
	hqTEZ+5BaI1QU2HJKOKCB9pf0I1FxKIg6X17piGPj1ntDc/SgxbJudO2bJ+Ra6AuZ+PRg==
X-Google-Smtp-Source: AGHT+IGzqMPIvjpm/BPRALlmRdcbNGNJ9j3aeCDnc9DqBiLhI9CAlWRiqsR+98pXwIxsqy5E6mdSnJ1nvl71RajfhBE=
X-Received: by 2002:a05:6402:2792:b0:641:2cf3:ec3e with SMTP id
 4fb4d7f45d1cf-6507931fd53mr740163a12.11.1767649654614; Mon, 05 Jan 2026
 13:47:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 5 Jan 2026 16:47:22 -0500
X-Gm-Features: AQt7F2rKVguptLS0_HGBM_cWisOO9Z59HcS_ZCk33hJtwl63lB_QQNWyrYq4Wfo
Message-ID: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
Subject: Call for GSoC internship project ideas
To: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Cc: Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Dear QEMU and KVM communities,
QEMU will apply for the Google Summer of Code internship
program again this year. Regular contributors can submit project
ideas that they'd like to mentor by replying to this email by
January 30th.

About Google Summer of Code
-----------------------------------------
GSoC (https://summerofcode.withgoogle.com/) offers paid open
source remote work internships to eligible people wishing to participate
in open source development. QEMU has been doing internship for
many years. Our mentors have enjoyed helping talented interns make
their first open source contributions and some former interns continue
to participate today.

Who can mentor
----------------------
Regular contributors to QEMU and KVM can participate as mentors.
Mentorship involves about 5 hours of time commitment per week to
communicate with the intern, review their patches, etc. Time is also
required during the intern selection phase to communicate with
applicants. Being a mentor is an opportunity to help someone get
started in open source development, will give you experience with
managing a project in a low-stakes environment, and a chance to
explore interesting technical ideas that you may not have time to
develop yourself.

How to propose your idea
------------------------------
Reply to this email with the following project idea template filled in:

=== TITLE ===

'''Summary:''' Short description of the project

Detailed description of the project that explains the general idea,
including a list of high-level tasks that will be completed by the
project, and provides enough background for someone unfamiliar with
the code base to research the idea. Typically 2 or 3 paragraphs.

'''Links:'''
* Links to mailing lists threads, git repos, or web sites

'''Details:'''
* Skill level: beginner or intermediate or advanced
* Language: C/Python/Rust/etc

More information
----------------------
You can find out about the process we follow here:
Video: https://www.youtube.com/watch?v=xNVCX7YMUL8
Slides (PDF): https://vmsplice.net/~stefan/stefanha-kvm-forum-2016.pdf

The QEMU wiki page for GSoC 2026 is now available:
https://wiki.qemu.org/Google_Summer_of_Code_2026

Thanks,
Stefan

