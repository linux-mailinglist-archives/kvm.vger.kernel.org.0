Return-Path: <kvm+bounces-32504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CE69D9505
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5484B255B4
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 09:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CA21BDAA1;
	Tue, 26 Nov 2024 09:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="gNtA26NJ"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0803D299;
	Tue, 26 Nov 2024 09:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732614879; cv=none; b=LjTUilq7Ka3K8aNsiQxssRHs1LG2ygP0zvHesfrEp9DjGYy5uDR5t6hnmPZ5Euo9RMzfFjZgI5IDpWl+uNZD48otUR9gpv2iAJj7I2TrhlxfGGVwpjhCRbGL5doPoQDz3uZ5ekEcZplXCO0hlqFMvopYoNpsCCwCHmnQ5pdToLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732614879; c=relaxed/simple;
	bh=JowNcjHUmN7bzLp4aw7lrmiL5fe+SUhvM8eKDtmfILw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=t8YA7M6sgf7N7d5DAxc54sab3hMymuLNPgLnwwhigkZNlODV4nPjw9GB+b1W0lehWUfSlnlhZY4xvLbbWOS0vCzZoFajCW/MQNaXvCGEXcBdU0j3ExDaQoJbEmorUA8LyIgm7tIo7TTuDDCcUiGN/ynWPZYBtt0hWZpA1w8CN2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=gNtA26NJ; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:4fa4:0:640:dbe3:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 438156175F;
	Tue, 26 Nov 2024 12:54:34 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:1227::1:d] (unknown [2a02:6b8:b081:1227::1:d])
	by mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id CsUiiq2IlGk0-flfZqWHM;
	Tue, 26 Nov 2024 12:54:32 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1732614872;
	bh=FvvbD0MF6L6LHLyJkBm1yP1MntwWYgmpGyuL4Uy71s0=;
	h=In-Reply-To:Cc:Date:References:To:From:Subject:Message-ID;
	b=gNtA26NJAVDpuft2hTMutcj6uRt/O7wbkemR2VHq1DQRwz/nZttqI+8Rje+H4Ajfb
	 vZRnzvWYNIxPcb0L4zd0KqrmKbvq+Iopsinga6oRh9S3tmNAfNxHMvTnRvlglL1VGJ
	 DRuBLfLXfIz51fZmmwtHfmNJwIF9F179f1G4cGe0=
Authentication-Results: mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <bf9914b8-9b3b-413c-b8a2-db8c4486752e@yandex-team.ru>
Date: Tue, 26 Nov 2024 12:54:12 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm/debugfs: add file to get vcpu steal time statistics
From: Denis Plotnikov <den-plotnikov@yandex-team.ru>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, yc-core@yandex-team.ru,
 linux-kernel@vger.kernel.org
References: <20240917112028.278005-1-den-plotnikov@yandex-team.ru>
 <Zu_Pl4QiBsA_yK1g@google.com>
 <0288f7f5-4ae8-4097-b00c-f1b747f80183@yandex-team.ru>
 <ZvFVFulBrzHqj2SE@google.com>
 <942ec747-04f6-4fd6-abcd-eea60c3ba041@yandex-team.ru>
 <ZvrHYoAuu2AntQYb@google.com>
 <bf5c35ab-d858-477c-9b72-95161ad72f1d@yandex-team.ru>
Content-Language: en-US
In-Reply-To: <bf5c35ab-d858-477c-9b72-95161ad72f1d@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Ping!
In the last message I suggested another approach to get steal time 
statistics. It would be nice to get some opinion according to that!
Thanks!

On 11/5/24 15:43, Denis Plotnikov wrote:
> 
>  > On 9/30/24 18:44, Sean Christopherson wrote:
>>>> No, I mean by using the host userspace VMA to read the memory.
>>>
>>> Oh, I think I got your idea. You mean
>>> using KVM_CAP_X86_MSR_FILTER which...
>>>
>>> "In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user 
>>> space to
>>> trap and emulate MSRs ..."
>>>
>>> And then having guest's steal time struct valid address read the 
>>> value from
>>> userspace VMM like qemu directly.
>>
>> Yep, exactly!
> 
> By the way, what if we add "steal time" as a kvm statistics item?
> 
> Why I think it's a good idea?
> * it is available via standard KVM_GET_STATS_FD
> * it doesn't introduce any overhead
> * it is quite easy to add with just three lines of code
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1596,6 +1596,7 @@ struct kvm_vcpu_stat {
>          u64 preemption_other;
>          u64 guest_mode;
>          u64 notify_window_exits;
> +       u64 steal_time;
>   };
> 
>   struct x86_instruction_info;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83fe0a78146fc..cd771aef1558a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -291,6 +291,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>          STATS_DESC_COUNTER(VCPU, preemption_other),
>          STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>          STATS_DESC_COUNTER(VCPU, notify_window_exits),
> +       STATS_DESC_TIME_NSEC(VCPU, steal_time),
>   };
> 
>   const struct kvm_stats_header kvm_vcpu_stats_header = {
> @@ -3763,6 +3764,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>          version += 1;
>          unsafe_put_user(version, &st->version, out);
> 
> +       vcpu->stat.steal_time = steal;
> 
> The disadvantage of this approach is that it adds some kind of data 
> duplication but it doesn't seem to be a problem - using shadowing and 
> caching are common practices.
> 
> My concern about intercepting steal time MSR in user space is 
> overcomplication - we need to add significant amount of userspace code 
> to achieve what we can get in much easier and, in my opinion, cleaner 
> way. I think it's a cleaner way because every userspace app (like QEMU) 
> will get steal time without any modification via means provided by kvm. 
> For example, QEMU will be able to get steal time via qmp with 
> "query-stats" command which returns every statistics item provided by 
> KVM_GET_STATS_FD.

