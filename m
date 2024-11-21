Return-Path: <kvm+bounces-32285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F189D525B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9CE5B25829
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C21F1BD4EB;
	Thu, 21 Nov 2024 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="UNXpu6BJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D9219E97E;
	Thu, 21 Nov 2024 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732212617; cv=none; b=SVtbNAJLB+fstgrQ4VSTkpo1xQx+aJZyYJfoC4M4x8vjUyOf/4RCJDml66p+pBdoAjnQun5FrSYjoltUpaEEVLRRLnBkSrrxibDqu7jXwlJbCUugzM6La7aUnUok/oKLDZqctzwFU27epmzLHAlFiJD7rrfkZMMpJGusSQFj7Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732212617; c=relaxed/simple;
	bh=/QrK9DcsN5FlFdjIm0jrLNUb5NSLxodNCY1SNAtQRis=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RpJjY8xE7Vr5TjSAcfhNghwXwx2xtUu3wvA8poMc12TPJ6/yEhJRDt1S30zQrcHEk0T5dA3Ypk8KC9K2wj7GxAYYrDhlsxesLwtFC9PvNF8YWmaygmnynQM4FUh+jbGpMULfTH8wnhpp25HWEVqvy3VpvVG4JMsyWkyY1GWeO00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=UNXpu6BJ; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732212616; x=1763748616;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=Jedw0RuD934xWRc76uUvfNLom3KleitLn5e/Kk6VcZc=;
  b=UNXpu6BJ7UjJa6FE7S4kPsHZlkNYgCYMMc5cZmLOCWtL366NOGLL6vA+
   MscePqBCTuMKBwgRpOwahpIL3fLHN3pwytoqJMRFyDNnGRyoMEK/4awwo
   +SDB/HDb4ZyR8LskEa487YOJZ24qlDsm17eAfSOj0Q+71GMm6JiEIKjgt
   E=;
X-IronPort-AV: E=Sophos;i="6.12,173,1728950400"; 
   d="scan'208";a="675607877"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 18:10:13 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:18256]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.207:2525] with esmtp (Farcaster)
 id 39959816-ee15-428d-81ae-64f7364106b7; Thu, 21 Nov 2024 18:10:12 +0000 (UTC)
X-Farcaster-Flow-ID: 39959816-ee15-428d-81ae-64f7364106b7
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 21 Nov 2024 18:10:09 +0000
Received: from [192.168.3.109] (10.106.83.32) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Thu, 21 Nov 2024
 18:10:08 +0000
Message-ID: <f8faa85e-24e6-4105-ab83-87b1b8c4bd56@amazon.com>
Date: Thu, 21 Nov 2024 18:10:07 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<david@redhat.com>, <peterx@redhat.com>, <oleg@redhat.com>,
	<gshan@redhat.com>, <graf@amazon.de>, <jgowans@amazon.com>,
	<roypat@amazon.co.uk>, <derekmn@amazon.com>, <nsaenz@amazon.es>,
	<xmarcalx@amazon.com>
References: <20241118130403.23184-1-kalyazin@amazon.com>
 <87h684ctlg.fsf@redhat.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJj5ki9BQkDwmcAAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOR1wD/UTcn4GbLC39QIwJuWXW0DeLoikxFBYkbhYyZ5CbtrtAA/2/rnR/zKZmyXqJ6
 ULlSE8eWA3ywAIOH8jIETF2fCaUCzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmPmSL0FCQPCZwACGwwACgkQr5LKIKmaZPNCxAEAxwnrmyqSC63nf6hoCFCfJYQapghC
 abLV0+PWemntlwEA/RYx8qCWD6zOEn4eYhQAucEwtg6h1PBbeGK94khVMooF
In-Reply-To: <87h684ctlg.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D013EUB001.ant.amazon.com (10.252.51.116) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 18/11/2024 17:58, Vitaly Kuznetsov wrote:
> Nikita Kalyazin <kalyazin@amazon.com> writes:
> 
>> On x86, async pagefault events can only be delivered if the page fault
>> was triggered by guest userspace, not kernel.  This is because
>> the guest may be in non-sleepable context and will not be able
>> to reschedule.
> 
> We used to set KVM_ASYNC_PF_SEND_ALWAYS for Linux guests before
> 
> commit 3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Apr 24 09:57:56 2020 +0200
> 
>      x86/kvm: Restrict ASYNC_PF to user space
> 
> but KVM side of the feature is kind of still there, namely
> 
> kvm_pv_enable_async_pf() sets
> 
>      vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
> 
> and then we check it in
> 
> kvm_can_deliver_async_pf():
> 
>       if (vcpu->arch.apf.send_user_only &&
>           kvm_x86_call(get_cpl)(vcpu) == 0)
>               return false;
> 
> and this can still be used by some legacy guests I suppose. How about
> we start with removing this completely? It does not matter if some
> legacy guest wants to get an APF for CPL0, we are never obliged to
> actually use the mechanism.

If I understand you correctly, the change you propose is rather 
orthogonal to the original one as the check is performed after the work 
has been already allocated (in kvm_setup_async_pf).  Would you expect 
tangible savings from omitting the send_user_only check?

> 
> --
> Vitaly



