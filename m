Return-Path: <kvm+bounces-30735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68DA19BCCFC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 13:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B53D1C2185C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F901D5ADD;
	Tue,  5 Nov 2024 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="cj2dZD7a"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985BB1D5174;
	Tue,  5 Nov 2024 12:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730810771; cv=none; b=qvINr3fCd6r7TXAZsqaXUujPdb184B54dI+DLljjl2U5oVNPRacxFuhD7o7yGvqSbWpch6Zp/LyCHm0muPd/oAgETCo+UnmUZuRBMRp2rGEyXGDSXVX4g6uY+eCDFnjoRayN2pgxaOfUe1HhyOiNefQvIwd2nop2BrsC29oI8G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730810771; c=relaxed/simple;
	bh=EviLA6r7ivOj5G7sHesAoWUgGm3TeiXj4xbdv3/l9T8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Km+qxM4Gs5XvKnUWQBDjg1Px4Ak2rWD2jVFhUEU+7WIpLI/jtkdvY2A1xF20w5Ow3AnNzpORkDE2HyL8X/eIj7uF10mdJ5+ONFDU5okcaCf8SFft42QLAfCzg16LCPd1g32Wm2SKfhWVDgDRlz8+yRUgBgzkLiZkeswV4B5XNs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=cj2dZD7a; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2e8b:0:640:9795:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id C000A609D6;
	Tue,  5 Nov 2024 15:43:59 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b595::1:3] (unknown [2a02:6b8:b081:b595::1:3])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id whfOXa4IYmI0-T18QDvxm;
	Tue, 05 Nov 2024 15:43:58 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1730810638;
	bh=avirElLOzaMUKalli+jz2f0s3o4CEd5BCEpEpr62OVU=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=cj2dZD7a7IV3gcHpHlM6S2pjp1Zmjr16Krj9MDIzbnU0SDskUN+13tV+aadzK5RRi
	 PqboN3GjfBxdtOMEsI3PG405iMiZXlCOcoO6WMZEvBQVDi/tfG6LCEacqf5tzS3JQP
	 QLsiLuqttBCnBKL46Jk7oJUCofRCLN2A5MWRkQAU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <bf5c35ab-d858-477c-9b72-95161ad72f1d@yandex-team.ru>
Date: Tue, 5 Nov 2024 15:43:58 +0300
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
 <942ec747-04f6-4fd6-abcd-eea60c3ba041@yandex-team.ru>
 <ZvrHYoAuu2AntQYb@google.com>
Content-Language: en-US
From: Denis Plotnikov <den-plotnikov@yandex-team.ru>
In-Reply-To: <ZvrHYoAuu2AntQYb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


 > On 9/30/24 18:44, Sean Christopherson wrote:
>>> No, I mean by using the host userspace VMA to read the memory.
>>
>> Oh, I think I got your idea. You mean
>> using KVM_CAP_X86_MSR_FILTER which...
>>
>> "In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
>> trap and emulate MSRs ..."
>>
>> And then having guest's steal time struct valid address read the value from
>> userspace VMM like qemu directly.
> 
> Yep, exactly!

By the way, what if we add "steal time" as a kvm statistics item?

Why I think it's a good idea?
* it is available via standard KVM_GET_STATS_FD
* it doesn't introduce any overhead
* it is quite easy to add with just three lines of code
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1596,6 +1596,7 @@ struct kvm_vcpu_stat {
         u64 preemption_other;
         u64 guest_mode;
         u64 notify_window_exits;
+       u64 steal_time;
  };

  struct x86_instruction_info;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146fc..cd771aef1558a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -291,6 +291,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
         STATS_DESC_COUNTER(VCPU, preemption_other),
         STATS_DESC_IBOOLEAN(VCPU, guest_mode),
         STATS_DESC_COUNTER(VCPU, notify_window_exits),
+       STATS_DESC_TIME_NSEC(VCPU, steal_time),
  };

  const struct kvm_stats_header kvm_vcpu_stats_header = {
@@ -3763,6 +3764,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
         version += 1;
         unsafe_put_user(version, &st->version, out);

+       vcpu->stat.steal_time = steal;

The disadvantage of this approach is that it adds some kind of data 
duplication but it doesn't seem to be a problem - using shadowing and 
caching are common practices.

My concern about intercepting steal time MSR in user space is 
overcomplication - we need to add significant amount of userspace code 
to achieve what we can get in much easier and, in my opinion, cleaner 
way. I think it's a cleaner way because every userspace app (like QEMU) 
will get steal time without any modification via means provided by kvm. 
For example, QEMU will be able to get steal time via qmp with 
"query-stats" command which returns every statistics item provided by 
KVM_GET_STATS_FD.

