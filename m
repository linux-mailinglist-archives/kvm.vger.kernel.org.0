Return-Path: <kvm+bounces-21957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CCC3937B89
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 270E8281A11
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 17:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BB22BB0D;
	Fri, 19 Jul 2024 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1eMF8bA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA72146000;
	Fri, 19 Jul 2024 17:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721409814; cv=none; b=Dt/FNtWm0VxRtOqKgCPW3IoL2qGjUImX7dX5g3+dalrhNmfEKLdTA/8jLoVJ/TUvFgt378QFB9sDZ3eS9/oLX4dxWwGUDFd1XM4FEHZoj7+dxcZcczlHqjTVvXl2fLNjGoO06PMYtcoZQzmc065iOmMs+rKga6YMqxEthumxtU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721409814; c=relaxed/simple;
	bh=UXCKipdFlwMdRUwucvJL8Bya4SjYc+dZ3uARKiGiV8A=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=ifFZzVepl5HY7qA1rkkwNexg/xW6T4EwFGT1Yp1hqzln2hQs6i2yFHdvEoqFDcicJQA8vWvKNPzw8gDv2LaxJcH/JXD1OrRNxc/y2UYwwvOqFNy/BxJg1i/8eUr9LEIvZIxK/OTqjokpYYktVwt33mCPPRmlQpcM9QxIpOPP6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q1eMF8bA; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3683f56b9bdso821167f8f.1;
        Fri, 19 Jul 2024 10:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721409811; x=1722014611; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3D7gCYvX5ilEs+y7to+huBD1nfxBILfrqUmhg1XR50Y=;
        b=Q1eMF8bAzcPWrYenUoV/zLRw1sMmnheelx8qpRpFP1O8+TrRX1VV8Irieiec24THCz
         ah1FEYcxAxUhp7rmJMiOVQV+JLbvTTWGpSRtGLVcmHfYsMsQr3sgfm2ACTLFiJWqj3RC
         TEsjAtGIZ4dodkRaVO5D2F7m7LKYr7oOMv/ncKr77ZKurKIfb+ITCETVGOZ1yvwkneTY
         GVHiGkbhkVng5W7+UtbtxnYCAGTO3xHnMprrudojcVa1RQZgJ7EPyf37vvpOWgQXTbSE
         MfdxxxAOLN7DBiurNcO/7PbT49LBAeoozOpl2m4ZEEFf3tzSZvGCAnqd2xWgcYBAzmZk
         g2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721409811; x=1722014611;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3D7gCYvX5ilEs+y7to+huBD1nfxBILfrqUmhg1XR50Y=;
        b=JEV5JHcWJO0w0fElmMYvMCpbGY/6rZbNjp0RsdX5SgBaxkRoMMajJiObqYiWtJoKfK
         1pZisyX1AJC8ywiIaKRCP9dbWfRBo1rfbq32vGXv6FRE7HhdEcOtaHj+q6+Cbi22u4K5
         HvQUr+a8kgFGuKX9G5UqluqAjXtT85hJpmqglSb/k8xDCENai/bDXsA09BHNwA+QLFPN
         RbJkXEf27GGAjCDtNLcF4meGVQL4WzLkFiD2iWxKgj6xR/rxD2toLboizuxaN4dGluCr
         cA3DFSSjL8dlRBTTCsjDW/OIPq398KeXoapCTa8aGZdrS0d6+qgx4i/4114I4Uwoh+cf
         2bCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWj0NZ+o12vIR89hRwnkPbM8LlPQQIYCLBEU2YTqNyS1mq3X/94fnCYIjNQSiX/YkWGQn1cSTV55YxEf/OxhTKl0jH8dpmf+TL8RCgV
X-Gm-Message-State: AOJu0YwnXPAyWQ0rlF1DCXBRritkj9kh53JWUv4Xfdm+lmxwVVmzNpX2
	0/7KYjYj6AqXQsUgGUWa5DpGFeMnrpjSpAc9ofzrHmuvHj1L5WoyHLziBWVk
X-Google-Smtp-Source: AGHT+IEFy047yyAQYFdhs0ROo/KVifb7T3OSL82wgg7ujUQXuC676ePxxqXah0xuOS40HgN9/6lL8A==
X-Received: by 2002:a05:6000:e4d:b0:367:99fd:d7bb with SMTP id ffacd0b85a97d-368317bca52mr5516011f8f.63.1721409810777;
        Fri, 19 Jul 2024 10:23:30 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427d6937e81sm31736055e9.47.2024.07.19.10.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 10:23:30 -0700 (PDT)
Message-ID: <7b47f4b7-eda8-40e2-883c-6d6c539a4649@gmail.com>
Date: Fri, 19 Jul 2024 19:23:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
Subject: =?UTF-8?Q?=5BBUG=5D_6=2E10_stable=3A_arch/x86/kvm/xen=2Ec=3A1486=3A?=
 =?UTF-8?Q?44=3A_error=3A_use_of_uninitialized_value_=E2=80=98port=E2=80=99_?=
 =?UTF-8?B?W0NXRS00NTdd?=
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, all,

While building stable tree version of 6.10, the following error occurred:

In line 1421 defines:

1421        evtchn_port_t port, *ports;

The ports becomes &port in line 1470, but neither port nor *ports is assigned a value
until line 1486 where port is used:

1485         if (sched_poll.nr_ports == 1)
1486 →               vcpu->arch.xen.poll_evtchn = port;

The visual inspection proves that the compiler is again right (GCC 12.3.0).

The linux-next and kvm trees contained the same error.

In line 1507 this error is rectified by setting vcpu->arch.xen.poll_evtchn = 0,
but compiler still prevents build with -Werror.

I don't have familiarity with this section of code.

"arch/x86/kvm/xen.c"
--------------------
1417 static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
1418                                  u64 param, u64 *r)
1419 {
1420         struct sched_poll sched_poll;
1421 →       evtchn_port_t port, *ports;
1422         struct x86_exception e;
1423         int i;
1424 
1425         if (!lapic_in_kernel(vcpu) ||
1426             !(vcpu->kvm->arch.xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_EVTCHN_SEND))
1427                 return false;
1428 
1429         if (IS_ENABLED(CONFIG_64BIT) && !longmode) {
1430                 struct compat_sched_poll sp32;
1431 
1432                 /* Sanity check that the compat struct definition is correct */
1433                 BUILD_BUG_ON(sizeof(sp32) != 16);
1434 
1435                 if (kvm_read_guest_virt(vcpu, param, &sp32, sizeof(sp32), &e)) {
1436                         *r = -EFAULT;
1437                         return true;
1438                 }
1439 
1440                 /*
1441                  * This is a 32-bit pointer to an array of evtchn_port_t which
1442                  * are uint32_t, so once it's converted no further compat
1443                  * handling is needed.
1444                  */
1445                 sched_poll.ports = (void *)(unsigned long)(sp32.ports);
1446                 sched_poll.nr_ports = sp32.nr_ports;
1447                 sched_poll.timeout = sp32.timeout;
1448         } else {
1449                 if (kvm_read_guest_virt(vcpu, param, &sched_poll,
1450                                         sizeof(sched_poll), &e)) {
1451                         *r = -EFAULT;
1452                         return true;
1453                 }
1454         }
1455 
1456         if (unlikely(sched_poll.nr_ports > 1)) {
1457                 /* Xen (unofficially) limits number of pollers to 128 */
1458                 if (sched_poll.nr_ports > 128) {
1459                         *r = -EINVAL;
1460                         return true;
1461                 }
1462 
1463                 ports = kmalloc_array(sched_poll.nr_ports,
1464                                       sizeof(*ports), GFP_KERNEL);
1465                 if (!ports) {
1466                         *r = -ENOMEM;
1467                         return true;
1468                 }
1469         } else
1470 →                ports = &port;
1471 
1472         if (kvm_read_guest_virt(vcpu, (gva_t)sched_poll.ports, ports,
1473                                 sched_poll.nr_ports * sizeof(*ports), &e)) {
1474                 *r = -EFAULT;
1475                 return true;
1476         }
1477 
1478         for (i = 0; i < sched_poll.nr_ports; i++) {
1479                 if (ports[i] >= max_evtchn_port(vcpu->kvm)) {
1480                         *r = -EINVAL;
1481                         goto out;
1482                 }
1483         }
1484 
1485         if (sched_poll.nr_ports == 1)
1486 →               vcpu->arch.xen.poll_evtchn = port;
1487         else
1488                 vcpu->arch.xen.poll_evtchn = -1;
1489 
1490         set_bit(vcpu->vcpu_idx, vcpu->kvm->arch.xen.poll_mask);
1491 
1492         if (!wait_pending_event(vcpu, sched_poll.nr_ports, ports)) {
1493                 vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
1494 
1495                 if (sched_poll.timeout)
1496                         mod_timer(&vcpu->arch.xen.poll_timer,
1497                                   jiffies + nsecs_to_jiffies(sched_poll.timeout));
1498 
1499                 kvm_vcpu_halt(vcpu);
1500 
1501                 if (sched_poll.timeout)
1502                         del_timer(&vcpu->arch.xen.poll_timer);
1503 
1504                 vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
1505         }
1506 
1507 →       vcpu->arch.xen.poll_evtchn = 0;
1508         *r = 0;
1509 out:
1510         /* Really, this is only needed in case of timeout */
1511         clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.xen.poll_mask);
1512 
1513         if (unlikely(sched_poll.nr_ports > 1))
1514                 kfree(ports);
1515         return true;
1516 }
--------------------

Hope this helps.

Best regards,
Mirsad Todorovac

