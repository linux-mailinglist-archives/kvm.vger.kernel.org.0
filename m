Return-Path: <kvm+bounces-27683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 772D198A701
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11BA7B2436A
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 14:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DD81917F6;
	Mon, 30 Sep 2024 14:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="lgC6ek+6"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D27C1917FB;
	Mon, 30 Sep 2024 14:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727706563; cv=none; b=dFihD3RqjY/G6qhEbYW74SccixVgd4hvztngFyOO6fGt1/km1TmTP6vU6wE4fOu7oViZYdNTk74gyC/oYYqtE8hp9Y8C3sZ4bZzLRQLsCBGQ9paEhkaQlUQwKPU5xuC/xL31IU/skNl3kLPVolM8SmMIa8KOB1JpX5kIWAmky2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727706563; c=relaxed/simple;
	bh=R5L9S9frLH6sSiuqcL0wGsybfRpXvblEOYptLdh7ICY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o/DdtuCHFp8h00G1ywvvDl3mRSe3zIaJfDeHihPkIRLZbOUTH8Yk1vtEuSJtlUp3QEBvEekirKKvT8gD+eJanuQhbY+ujoTWrORoweLR9z1dfiyNY+BoLyRQC6czkZ0Vaictod4o0AweKW9tvp6bB1CpMFCIzeLeaF12Hzup2vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=lgC6ek+6; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1301:0:640:a2b5:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 8EA5B60CD7;
	Mon, 30 Sep 2024 17:29:12 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b681::1:3a] (unknown [2a02:6b8:b081:b681::1:3a])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ATa4BH1If8c0-dq2UN1qQ;
	Mon, 30 Sep 2024 17:29:11 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1727706551;
	bh=oCgmpzamdx7GORW8uZNl4MlQuA5crMiiqpwwxrd9CA0=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=lgC6ek+6G7Vp6sgdVn8ox5NS84NpD3d3G317xmyNLAZQdIMK0dNXrZgtNr1XgCbGR
	 hEtpGxsj/DyI7eN4xUScD9IkUyC57XjLieOTumjHWx75Bs6gLMQqKkGbS8XMmUq/2z
	 8rn5AbuDWv8wiY/CchY6Za4XpDtXJOnW68iilGlU=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <942ec747-04f6-4fd6-abcd-eea60c3ba041@yandex-team.ru>
Date: Mon, 30 Sep 2024 17:29:10 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm/debugfs: add file to get vcpu steal time statistics
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, yc-core@yandex-team.ru,
 linux-kernel@vger.kernel.org
References: <20240917112028.278005-1-den-plotnikov@yandex-team.ru>
 <Zu_Pl4QiBsA_yK1g@google.com>
 <0288f7f5-4ae8-4097-b00c-f1b747f80183@yandex-team.ru>
 <ZvFVFulBrzHqj2SE@google.com>
Content-Language: en-US
From: Denis Plotnikov <den-plotnikov@yandex-team.ru>
In-Reply-To: <ZvFVFulBrzHqj2SE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Yandex-Filter: 1



On 9/23/24 14:46, Sean Christopherson wrote:
> On Mon, Sep 23, 2024, Denis Plotnikov wrote:
>> On 9/22/24 11:04, Sean Christopherson wrote:
>>> On Tue, Sep 17, 2024, Denis Plotnikov wrote:
>>>> It's helpful to know whether some other host activity affects a virtual
>>>> machine to estimate virtual machine quality of sevice.
>>>> The fact of virtual machine affection from the host side can be obtained
>>>> by reading "preemption_reported" counter via kvm entries of sysfs, but
>>>> the exact vcpu waiting time isn't reported to the host.
>>>> This patch adds this reporting.
>>>>
>>>> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
>>>> ---
>>>>    arch/x86/include/asm/kvm_host.h |  1 +
>>>>    arch/x86/kvm/debugfs.c          | 17 +++++++++++++++++
>>>
>>> Using debugfs is undesirable, as it's (a) not ABI and (b) not guaranteed to be
>>> present as KVM (correctly) ignores debugfs setup errors.
>>>
>>> Using debugfs is also unnecessary.  The total steal time is available in guest
>>> memory, and by definition that memory is shared with the host.  To query total
>>> steal time from userspace, use MSR filtering to trap writes (and reflect writes
>>> back into KVM) so that the GPA of the steal time structure is known, and then
>>> simply read the actual steal time from guest memory as needed.
>> Thanks for the reply!
>> Just to clarify, by reading the actual steal time from guest memory do you
>> mean by using some kind of new vcpu ioctl?
> 
> No, I mean by using the host userspace VMA to read the memory.

Oh, I think I got your idea. You mean
using KVM_CAP_X86_MSR_FILTER which...

"In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space 
to trap and emulate MSRs ..."

And then having guest's steal time struct valid address read the value 
from userspace VMM like qemu directly.

Thanks for the answers!

Best,
Denis

