Return-Path: <kvm+bounces-27299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F7897E8D0
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 11:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D82CE281E18
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 09:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62D2194A6F;
	Mon, 23 Sep 2024 09:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="GuRhMFUE"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D72B49643;
	Mon, 23 Sep 2024 09:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727084032; cv=none; b=ViS55i/Gk5i0yLVXBSINu5XqyUW1tNaTEmyYQXuaGimQk49TrXjQ1jeQqk9B1FxT17hMvbmWn195GE8TmffEJzLh2uuz+f3KHJlBSw93lahYH94QsZ4RMzhTIh55OJ5kfXVWCj1K9Tn8cwKiQQwaLktIH6GSu+wUgrZKi6hrsNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727084032; c=relaxed/simple;
	bh=BoY4e8Jwexn+YHzxLNQ5q98ETWxzZyvkdjZLXb/msPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsKBvUVmytGICEOyc++aG4d7BEMMKhA1MG6lcC0oM6XJ67CFGBcis9pVWqWe259vVZCm7uiZ7KorMEd7sWGrcafv4kQtqB8u/1B1i0m+i1eMxUZg9fFMngaFJ1bA8DuQ5kWWwNg1aBXaZlPZ5x4i48skv5hHUZd545lICQG7p+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=GuRhMFUE; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1301:0:640:a2b5:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 2DFA2610E1;
	Mon, 23 Sep 2024 12:32:18 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b50b::1:11] (unknown [2a02:6b8:b081:b50b::1:11])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id FWOoge0cv4Y0-rqTSyTtC;
	Mon, 23 Sep 2024 12:32:16 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1727083936;
	bh=pJKGjkrYpQdX8rE7FgMSOSMSRbqBr0OoC7JcmvQ4qp8=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=GuRhMFUEJBilplYRdV/3yietVZle5wWq83f+EcUrG4NJxXz73QpjKQLnddDmvKUcW
	 JA+V0oSQOhI56ippsX1kVhaU8+rAyINzE2N18GKmc3uyUd3LHSjcWnVM2oRIO/80JP
	 goA9mCLbapvpZvVy1mr3XdRgE7TKRthUxUgD3RdY=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <0288f7f5-4ae8-4097-b00c-f1b747f80183@yandex-team.ru>
Date: Mon, 23 Sep 2024 12:32:15 +0300
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
Content-Language: en-US
From: Denis Plotnikov <den-plotnikov@yandex-team.ru>
In-Reply-To: <Zu_Pl4QiBsA_yK1g@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/24 11:04, Sean Christopherson wrote:
> On Tue, Sep 17, 2024, Denis Plotnikov wrote:
>> It's helpful to know whether some other host activity affects a virtual
>> machine to estimate virtual machine quality of sevice.
>> The fact of virtual machine affection from the host side can be obtained
>> by reading "preemption_reported" counter via kvm entries of sysfs, but
>> the exact vcpu waiting time isn't reported to the host.
>> This patch adds this reporting.
>>
>> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/debugfs.c          | 17 +++++++++++++++++
> 
> Using debugfs is undesirable, as it's (a) not ABI and (b) not guaranteed to be
> present as KVM (correctly) ignores debugfs setup errors.
> 
> Using debugfs is also unnecessary.  The total steal time is available in guest
> memory, and by definition that memory is shared with the host.  To query total
> steal time from userspace, use MSR filtering to trap writes (and reflect writes
> back into KVM) so that the GPA of the steal time structure is known, and then
> simply read the actual steal time from guest memory as needed.
Thanks for the reply!
Just to clarify, by reading the actual steal time from guest memory do 
you mean by using some kind of new vcpu ioctl?


Best,
Denis

