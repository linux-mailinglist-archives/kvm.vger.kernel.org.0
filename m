Return-Path: <kvm+bounces-45435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BADC3AA9A2A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC5DF3BA101
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 17:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC0E2690FB;
	Mon,  5 May 2025 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PU3ThmPf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF683265CD8
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746465021; cv=none; b=jguk7OHQPFpEz7tc1Zr8bXW8IYR4vXoQBhO5YKbbamvxpNULBHnG/I+ZRBRrnWbo8Ek6v5PioJ6PudNRSsTJiZ2Hy53ns/vL8lec6x+819ZFOEtmOLa/XSPpcsGAXply/yrnWoHc0E3vxsXXhS0gr8A7JegrMgBnYccXCs4+QmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746465021; c=relaxed/simple;
	bh=vX6Dl1p+qMaOTz1HKIMlsbs6Fj1fToknMDW1CzyqgJw=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=rultSfsfH3MWdsAXTpVT9v8NCYr6LiosIxhb1VlR4O/hYXH38j1ApRKzJClUhKqDfqjT1NuaBLrs9hUjXBDK7sPp7uXPJQiMchzzFD/6PBU8Uowm/JhVuVTGA+bjlFrPzBFA9a3GlqQYesUS6u46yAy+ICx+FMgmmtgUMko9Q4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gnu.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PU3ThmPf; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gnu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cf628cb14so40016365e9.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 10:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746465018; x=1747069818; darn=vger.kernel.org;
        h=content-transfer-encoding:autocrypt:subject:to:from
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jiy8rp/gjFDm5EhiG8J/Rynj80YzBCJAZWrtqRiR6R0=;
        b=PU3ThmPfZd80JywLMPr1vfoW8UFxOFsQMfe4EFB8iPtZDNzDF1pgfJPTv4XfJsohu2
         1tujJnd3MT/1Og9SO0eoD8ILSjvmSGojxIMatN2QYftLgz1CH/fUFfuB4lAX4UZAH7yc
         3C0tIGmc30Q9nWpkmaLuYnVstacnsYdoRov6Wa5Fu9LRtUu3c6wH5/mQsmV+akaXV9eA
         qDSG6l4Yy9+5qtyMXdC4olqGg4unIqioq2np9YRDik5NmuZCceojm4dYDN7poB0z3j4N
         1wvp13HTrWIfE+5fXLmm1QywvTpVT+KIGc88m9BpixoyR6z2RjulbaaIYW5XKCMerT7Z
         +3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746465018; x=1747069818;
        h=content-transfer-encoding:autocrypt:subject:to:from
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jiy8rp/gjFDm5EhiG8J/Rynj80YzBCJAZWrtqRiR6R0=;
        b=SqBtzbdA/MqrB/uQbQ6JkHs8Y+Ug218hof/MqqlyQIlaV0VYmKuhaPsyJRng2qeSg9
         O/6OL1QeM61TR1l6qLudLIYMZb8grPeR+g7UaG8y487zuYrJinocTBX/CPNjsrwUvoW6
         ciYOsGGZDpQATpFQbnJfX8j275Vcs9VYnuWqipbuBLvElio6iEnI6rrN4KznXkokWPlj
         R0yMva2f/fvvM3KzX9IkhaK/me/R772vzcvBllQaPJbkeUCocUPnjE2lIqsvfGINNERk
         k8sUSoQ/oVpA67a2g1ZV6fgBC8MYixxEYsCwow0U7wLDo0+fEx1PhPJkshXV/azwKOg2
         /ZwA==
X-Forwarded-Encrypted: i=1; AJvYcCUL3gKPqhr2JKKb1VkFkPu4B+INcWYrLdY6TYbmwXMHSbiCFG1QhWea/LYsUAw+AxKf7O8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVQLK4Nt2JanqGYf8sWlZ9DGchLjsGn8q+6TC/+Nqh89VN5Kob
	px1PxBMIfUjz05AS3kJDnXiR4U/VIrNuAZugwW3Coe6voVyXP82k
X-Gm-Gg: ASbGncsY3b5KJcoztDkkoeNPhBfLHyhkduouIYcnFE7oevUEPIhk7V9fyL/jdZdT94u
	I1AeRwGouGr1xnlzRonLHKofkakfDsKip9z2kTD1h7VwjaA6+b01ypnhXJhMW3dEUZvj15Sh4SI
	vrc/ZdNBqrxrd9fS9GdjdP/JL2fQbgcJGEutKqslUv+0llVlm/CtZrUlOF+2A0qL80OV/nO2xsT
	6AMn5eBpxFfMmqdKSwQ4jKaQG6XEij9TxXj3Fka33K18Qvenleuar8Wg/3MTGuUiUAnvRodBlbB
	Md0pr3gOMKy/WmZ0+w/pVFR325i+DGxPtid/jrsp0w==
X-Google-Smtp-Source: AGHT+IGtVH3C6XEmCAuXFZreOomHmPwzJNc+4m/N8MK2LRW/2wo9MW75JVmHSiMeyG9EK7hOOoRQ0w==
X-Received: by 2002:a05:6000:2586:b0:3a0:8a19:db31 with SMTP id ffacd0b85a97d-3a0ab57024dmr248742f8f.9.1746465017836;
        Mon, 05 May 2025 10:10:17 -0700 (PDT)
Received: from [192.168.169.123] ([151.95.54.106])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a099b16ea2sm10758915f8f.85.2025.05.05.10.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 10:10:17 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <905e09ae-df13-458e-9eb2-90ff455d1ee4@gnu.org>
Date: Mon, 5 May 2025 19:10:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Paolo Bonzini <bonzini@gnu.org>
To: qemu-devel <qemu-devel@nongnu.org>, devel@lists.libvirt.org,
 KVM list <kvm@vger.kernel.org>
Subject: KVM Forum 2025 Call for Presentations
Autocrypt: addr=bonzini@gnu.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

###########################
KVM Forum 2025
September 4-5, 2025
Milan, Italy
https://kvm-forum.qemu.org/
###########################

KVM Forum is an annual event that brings together developers and users,
discussing the state of Linux virtualization technology and planning for
the challenges ahead.  Sessions include updates on the KVM virtualization
stack, ideas for the future, and collaborative "birds of a feather"
(BoF) sessions to plan for the year ahead.  KVM Forum provides a unique
platform to contribute to the growth of the open source virtualization
ecosystem.

This year's event will be held in Milan, Italy on September 4-5, 2025,
at the Politecnico di Milano university.


CALL FOR PRESENTATIONS
======================

We encourage you to submit presentations via Pretalx at
https://kvm-forum.qemu.org/2025/cfp/. Suggested topics include:

* Scalability and Optimization

* Hardening and security

* Confidential computing

* KVM and the Linux Kernel:
     * New Features and Ports
     * Device Passthrough: VFIO, mdev, vDPA
     * Network Virtualization
     * Virtio and vhost

* Virtual Machine Monitors and Management:
     * VMM Implementation: APIs, Live Migration, Performance Tuning, etc.
     * Multi-process VMMs: vhost-user, vfio-user, QEMU Storage Daemon
     * QEMU without KVM: Hypervisor.framework and other hypervisors
     * Managing KVM: Libvirt, KubeVirt, Kata Containers

* Emulation:
     * New Devices, Boards and Architectures
     * CPU Emulation and Binary Translation

* Developer-focused content:
   * Tooling improvements
   * Enabling Rust
   * Testing frameworks and strategies

All presentation slots will be 25 minutes + 5 minutes for questions.


IMPORTANT DATES
===============

The deadline for submitting presentations is June 8, 2025 - 11:59 PM CEST.

Accepted speakers will be notified on July 5, 2025.


ATTENDING KVM FORUM
===================

Admission to KVM Forum costs $75. You can get your ticket at

      https://kvm-forum.qemu.org/2025/register/

Admission is free for accepted speakers.

The conference will be held at the Politecnico di Milano university.

The venue is a 5 minutes walk from the Piola stop of the "green" M2
subway line. Downtown Milan can be reached by subway in about 10
minutes.

Special hotel room prices will be available for attendees
of KVM Forum. More information will be available soon at
https://kvm-forum.qemu.org/location/.

We are committed to fostering an open and welcoming environment at our
conference. Participants are expected to abide by our code of conduct
and media policy:

      https://kvm-forum.qemu.org/coc/
      https://kvm-forum.qemu.org/media-policy/


GETTING TO MILAN
================

The main airport in Milan is Milano Malpensa (MXP). It is well
connected by trains to the city center and to the subway lines. Milano
Linate (LIN) is a city airport with a fast connection to downtown via
the "blue" M4 subway line.

Flights are available between the Milan area and most European
countries, as well as from America and Asia to Malpensa.

Another airport, Bergamo (BGY), hosts low-cost airlines and is
connected to the city center by buses.

Milan is also accessible by rail, including high-speed and international
routes.

If you need a visa invitation letter, please reach out to the organizers
at kvm-forum-pc@redhat.com.


CONTACTS
========

Reach out to us should you have any questions. The program committee may
be contacted as a group via email: kvm-forum-pc@redhat.com.

