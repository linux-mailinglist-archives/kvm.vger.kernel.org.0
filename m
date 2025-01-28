Return-Path: <kvm+bounces-36787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A7AA20E41
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 17:17:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65481164010
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 16:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F1C1D63CE;
	Tue, 28 Jan 2025 16:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YcwUmuM6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DC71917D9
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738081019; cv=none; b=FI7Nrk/9JrexarJes/vQOdk1GdxlkBuvUT4bJpeUt+wuFEj2YLo8YkJkR0pa5ur6cWyei+U+dP+tgSj3xcFa4+bMTBx4tsejdnpCIqS/CGOsVlMSHTPdrKRSFbxx7r2UbZWOl2F1zW2o6qmVwP5Gt/NOFjix2xO/oSzdVaYD6iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738081019; c=relaxed/simple;
	bh=3LQ/ClTRLQHNt4BKzJFSQ1S6KMu6e4COGZ7nkXwwF2I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=YCsUUmHE+1qVMUlncvrLU1f81v7Qt2FYju5H0tefbxXyNMa5vV883XtpL1FUSFEytYpEW5azHcuGlPV5hC5wbAMEGgGRLlD3iulf0QINfX614GSGgth8S1ZUfCjgPYGWIWHQ4ZvEgDcpvOPd/H0S9IAmb8ev8wFrzTgYJLA36GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YcwUmuM6; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5db6890b64eso11773538a12.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 08:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738081016; x=1738685816; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3LQ/ClTRLQHNt4BKzJFSQ1S6KMu6e4COGZ7nkXwwF2I=;
        b=YcwUmuM6WfMpJzQHbZbHhmyYjdVhpFy6/OQQV+/iGJvQAO2E88EQCShW+vFh4+7ib1
         BELEJjLc+6tOvI4yLYHoy0M91uVq05842oPHX5OAQ/2tQykM9Yxeo3cafIbtx3weN/PZ
         +ique24TM9+H+NlBCo/tX2NolES/YRKuFIJVntV/gaPwYNwZF/DWr77AN8gPKpg1brC8
         AnFn83xaqPe5V6Bf+C9Ayp2epBIrTimMj2Ri2tZfTtl/wlkdW/LYyNaoDaswzJ/opOue
         pzRjSZulf0B7A5LjO/RSF7dzTi7N8eAX6wQnIc3LWjxWhhSWD929/lMowBOcwBlE3Ta0
         I+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738081016; x=1738685816;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3LQ/ClTRLQHNt4BKzJFSQ1S6KMu6e4COGZ7nkXwwF2I=;
        b=Y4Yd+hS9NruFIp65YakD/W9qBmmGSsDcU2kOplimIxbYZt1Y/ZSWjMlUMn3SNFLWOm
         HJWzllVbTLkojaKsNcFvZc8VkWbGR/QuPh1M1U6u5Lm4A9ta41Iaop/cLvkD8KbanLYm
         dXU54C/5nLSJTUBUv4K2xL2n2aYAfN6VB/sDD4AfmGjKL8Z4f9y8EnL0SXkT+FGBU7yF
         f+iiignQJz1hgfKfR/eRGqtWatfPg27DyevlRwGg2QMkXhNU8TbLMq0ZxqB4zcJWHFhC
         ZIsARLSzv5rxEZhMackZ4ysRe+BnSqUvfzu8K50stf+1jmIsKeqsmN9Z1kAyDN1bV5bj
         FnVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1b7I6c8xqRRbOKWq46R4eylFoImmecEreximuywyxE8A3S7lz+I4KXI4zwQ//owUL/Lg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvcjme8GWaW+VWiEpXJMPPqw7koMONr4GSESh1AehMm5gzg1dn
	61FBuaGfu98bbNNWXmB1JbzbVaugwyOyplN7D6v4jis+WCkcfqSsjDDcv8p00akEvF3/HbWyAa1
	A5nOmg+9dGbHSE/e4mvm3L+6qbZo=
X-Gm-Gg: ASbGncuey07YgCkBlKgCwQ/t/Tr1A130Z3AFswb8sShorgYU3E2CDFayctbKB0AQDHL
	Err4Y84CWGs4mmww3yY1R3VMu1sTUCwOHOqyt/PjNa0xNbffedDp9FAdeT09A9j59YnMioLI=
X-Google-Smtp-Source: AGHT+IGngLilCkICpFdFa6Vm437XBCWWwcasw+Elf7wFv6/VQJdMbOLWzcjCVg/H+uh/2YDurB3D04hfy2p3poSvAJE=
X-Received: by 2002:a05:6402:51d3:b0:5d1:22c2:6c56 with SMTP id
 4fb4d7f45d1cf-5db7d318a90mr41206988a12.17.1738081016306; Tue, 28 Jan 2025
 08:16:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 28 Jan 2025 11:16:43 -0500
X-Gm-Features: AWEUYZkrZf4SPzQFoSAMMjj0I90DjwDlrKYXqyZ3YgDtCPyHRXPw_rrlon-LEvY
Message-ID: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
Subject: Call for GSoC internship project ideas
To: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Alex Bennee <alex.bennee@linaro.org>, 
	Akihiko Odaki <akihiko.odaki@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Bibo Mao <maobibo@loongson.cn>, Jamin Lin <jamin_lin@aspeedtech.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	Fabiano Rosas <farosas@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Hanna Reitz <hreitz@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Dear QEMU and KVM communities,
QEMU will apply for the Google Summer of Code internship
program again this year. Regular contributors can submit project
ideas that they'd like to mentor by replying to this email by
February 7th.

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

The QEMU wiki page for GSoC 2024 is now available:
https://wiki.qemu.org/Google_Summer_of_Code_2025

What about Outreachy?
-------------------------------
We have struggled to find sponsors for the Outreachy internship
program (https://www.outreachy.org/) in recent years. If you or your
organization would like to sponsor an Outreachy internship, please get
in touch.

Thanks,
Stefan

