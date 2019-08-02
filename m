Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6C37EF50
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 10:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404206AbfHBIaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 04:30:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44064 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404200AbfHBIaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 04:30:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so76247261wrf.11;
        Fri, 02 Aug 2019 01:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:references:user-agent:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=mfmWYxXmISm2SzEPyTKOCPMMxxIYkBzLdw5KHd5IvKs=;
        b=P60KY2IoLhMeA0gUqbbe9lbAwoI+hx21aQf12e+sIm/+hrfQNH82NaL35EZx1SOcsJ
         sLRVsy1sFMS++fF/tjERdnDFy1/JuW+tXccHREfdLgFulsz9OI4lPfCzJpz86mDisEqJ
         DBx2dFlh5aVeorRHZnKe1BeVQJfTy1vQ3AlFX87gYm83sR4En49DlPWyM+BKcTOeAYtI
         EpoXrQHxH6yj4pzY7O5j3B8okR8/3dxdEYCiQQpO2h89QEsKfKq3Ydh5pD9gr0LqKnQp
         1RYpqz3IrNV5IvJrGSPARjgewB6NUE3O9ATiFwqeSR2N/q3DtSBohbRbXb0HRyc+6P9p
         hDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:user-agent:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=mfmWYxXmISm2SzEPyTKOCPMMxxIYkBzLdw5KHd5IvKs=;
        b=nGwH7mfEIb7kMrdVGMrX1ukiIMmb+/xz7iD+ucHej6fadWrnRJznfRqK6zXTY7bprf
         DNyhcg1G/BhLVDAJqCQu+mtnabQdXcO76DeSLOUvdA/7funmYZWBh9M9qpggBZPSTupa
         F91A0mtcWqYiUVobZCJ8dhQCO8gVEdnWHnG7HI8EhUqmNBfJYra0xvw5zjoL2nd7wwjn
         xVLwKt1Ke5TC8rA2224G4rSTtqf8RnhIgNzLCuIu/HHwEIoh4v3aptBqPD7Qc5BPTat0
         /8OoES0jtcu7V2YUJo/9dfN/AeOl4WNGpNJgRIYFY0vnd8fH2L/mHL0VlmEtoHaw0mZt
         QDYg==
X-Gm-Message-State: APjAAAUf+1KWmqIUUkbr0tXD1fKwLUfg3lj+v87XfzFbEOnqvWzxr2C5
        WMskdwsjc8rIXyjFasfuKwk=
X-Google-Smtp-Source: APXvYqwL5rjpBjAEAaBUBmoJ9tvEgwf3fBPbdtTM1oOqr46Jgpp71NhD/XYVJhRLzxJrZaIueeKe2Q==
X-Received: by 2002:adf:8bc2:: with SMTP id w2mr62660881wra.7.1564734620724;
        Fri, 02 Aug 2019 01:30:20 -0700 (PDT)
Received: from crazypad.dinechin.lan ([2a01:e35:8b6a:1220:f3dc:ccbc:638a:c410])
        by smtp.gmail.com with ESMTPSA id f10sm62284117wrs.22.2019.08.02.01.30.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:30:19 -0700 (PDT)
From:   Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
References: <1564479235-25074-1-git-send-email-wanpengli@tencent.com> <04700afaf68114b5ab329f5a5182e21578c15795.camel@suse.com>
User-agent: mu4e 1.3.2; emacs 26.2
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: Disable wake-affine vCPU process to mitigate lock holder preemption
In-reply-to: <04700afaf68114b5ab329f5a5182e21578c15795.camel@suse.com>
Date:   Fri, 02 Aug 2019 10:30:11 +0200
Message-ID: <7h7e7wkm0c.fsf@crazypad.dinechin.lan>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Dario Faggioli writes:

> On Tue, 2019-07-30 at 17:33 +0800, Wanpeng Li wrote:
>> However, in multiple VMs over-subscribe virtualization scenario, it
>> increases 
>> the probability to incur vCPU stacking which means that the sibling
>> vCPUs from 
>> the same VM will be stacked on one pCPU. I test three 80 vCPUs VMs
>> running on 
>> one 80 pCPUs Skylake server(PLE is supported), the ebizzy score can
>> increase 17% 
>> after disabling wake-affine for vCPU process. 
>> 
> Can't we achieve this by removing SD_WAKE_AFFINE from the relevant
> scheduling domains? By acting on
> /proc/sys/kernel/sched_domain/cpuX/domainY/flags, I mean?
>
> Of course this will impact all tasks, not only KVM vcpus. But if the
> host does KVM only anyway...

Even a host dedicated to KVM has many non-KVM processes. I suspect an
increasing number of hosts will be split between VMs and containers.

>
> Regards


-- 
Cheers,
Christophe de Dinechin
