Return-Path: <kvm+bounces-70773-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GL6uKtNti2lhUQAAu9opvQ
	(envelope-from <kvm+bounces-70773-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:41:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B437411E07A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C024C300463C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B2938A9CE;
	Tue, 10 Feb 2026 17:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfpfvw66";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFnz1K7b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396D938A9AA
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770745282; cv=none; b=H7JLIEgWLCMD3c2Br8ce+vnnO+5PvWLstXj8aT15OTfs+qk+Pz68HjuteCHPsWf12h8Z55+4DIvECFKE75b3oJiFKgzyaKrb7OP8vDSVh5QmdYqdRHL1zo4dNbzBAdGcOI854Ej40f+y1xLkMWsWRwrL+MYs1tb9E5z95JtkJBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770745282; c=relaxed/simple;
	bh=ZQsoWUT9FMX4cjjVwzRilFpIIYG2IX61f548cWJWlBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BfgmyFEDGxu+VxBG+zwLtxWpN4Eh3fZPzxfaJwW0sqtEoVVxluPENKkQXEBYj8nmpd94Zv9wDhRK1d5pp7mTMq6fzBf3q9J/Fe8HKsWem/0UKo23e6s7bD2vVDkZeEXMFW6+jvAOyKRLFA+49Hx9pmW6e7kkZ2xWVucgyo8OLSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gfpfvw66; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HFnz1K7b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770745279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yo5EtKyXczJYQnTQtXSt9wnj+YOsv5TNLYHtToa8jgw=;
	b=gfpfvw6688JmPJAUuYYxpJ0IXzVadilbmN+bfR0uvM3SVc5C2Dg6kjlVxBKtM48oExizTX
	NygrjtqebAfwDvg2iI8yWv7Rdgx1bS7KiPAWDU+TOSB381YVyMmrMbj2YM+nCRKwOd7ojE
	jmWP/AyBLWVpBgSy1xxL+WzwSJtst/Y=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-hRPCjIcEOYuMauF1OaQ2qg-1; Tue, 10 Feb 2026 12:41:17 -0500
X-MC-Unique: hRPCjIcEOYuMauF1OaQ2qg-1
X-Mimecast-MFC-AGG-ID: hRPCjIcEOYuMauF1OaQ2qg_1770745277
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b8749dd495dso606100766b.1
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 09:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770745277; x=1771350077; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yo5EtKyXczJYQnTQtXSt9wnj+YOsv5TNLYHtToa8jgw=;
        b=HFnz1K7bXyTuJPRiX3vDerl/cTLm3gIIllp4NB8l3OQP3rz5bocRiY+ZfVTu8JvYSy
         xDZoQuOUqvRK5k6thQp/VFejj3DTrPPesGaDaQDDoKpPd8btIn8IUpFZVoeZZgTxuBGl
         uE/BgLFB/+4HUXVUTKThmKbTlCBXpzlNTAz8KTuhbKcIbB5d5LoThwFMRilW5I+UbSSw
         Ep+77S1n7h7CEY9DK0NMc2I/UxBP3m8FhdUDStLCKcO9jggL62+KSPNPN32hhKr14uSE
         2hBsq70kVEsNGdTNeg/PxB+Hr966RAwE/JZT5RSNMC/++reKSPXmbYKpYullu8dz8Yy/
         LQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770745277; x=1771350077;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yo5EtKyXczJYQnTQtXSt9wnj+YOsv5TNLYHtToa8jgw=;
        b=wn1hg+7Lqrdn5O2zaL0Khiy2NkJa7QfSYQh6jrI0mj0JJU4U+tPVOYr79v+xzgX1NY
         hoUheFAeZWOrTszexyADhea/c+mcMVETnPOUSKkVLfVzuo4OYRGAoyRe4D+tBpvxNSko
         BB0TzKIwQYAhaU1qY5WvjazkivVvxLZY02FxwqPvCF/Hy/UBX7hvpFc8JAmy9DUp3UJA
         jfcVXApobUNYl67QZRURZ44QAlGlSwKQzh8xWahzm++DoWuYa1X36j1cMCLZiNPXdYIR
         OyVzlabc72zetaIGuSov14wQuhfLzCkI21A5RQ9dAbpc9GssTHfibjomP7MX5Uh9MRMs
         n2HA==
X-Forwarded-Encrypted: i=1; AJvYcCX6GjE8lEKVCCm0ljWSycuOWiqsSHOpTxWDoWNi6PDki/IxxQzjHNAIIKwBn6Q2FG4hlNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWBYG4bh8MblkkYHIL4QnUxWq1QJ+J2VQdGez0em3Eow7sX/Mt
	VmWZD+4I0cZXRr3XCJiADXG9U9+7HwKae/DlyV04zbCro+sg/49+L1MQVhbxnLGSJ9HyPE2GeVU
	jkeW6LXg4oizhbCherrzHXM+3tFu3gOOELlokm8txvoW0Lt9Qz4DaWA==
X-Gm-Gg: AZuq6aKSyEy5b3+fuYirylzMqMYNFtMxsufOzoNoFv6pv08E3Q/V7gwFaKn+MIBWPpm
	6P9QmMn3vW+IMnoa8wMwx+mryIQegZqxRbcWnwA4k2z4NCuzcT97waC9t7N0KnL2VI11ZzcX30j
	Qw7gVJ4vPbpFmqrBQWaarCC9Q7cpSOLewGwVQ7R0FVCt2qQl+qNDA9R+6a/rdgl/RRAwa62xwQ1
	i4XRRpmVSEtLyOpeWc9VRMMLZywEak6DBzF8tMMTZX4VTtDjRkGWq0qrhU9H8IvMHRTAKVrUxrQ
	c3HatoeNMVwCcIouWsBBNGHYPMfAtIrYjeBuzkvbEW9MpKnyVpoZ527/HRz4E9ZH/0isnW/nITT
	BWqLxcmsSgmzhdMfzI1duNqoG5HgzyAwW+IPtYlp3zeSiCFdWSAQuZR9+XiO8XxJb1cHNMt3khi
	doAT9rfFqBd7FsM6M8LxJkZA5+zg==
X-Received: by 2002:a17:907:da9:b0:b8e:b366:58c1 with SMTP id a640c23a62f3a-b8f546a8f99mr160656366b.49.1770745276636;
        Tue, 10 Feb 2026 09:41:16 -0800 (PST)
X-Received: by 2002:a17:907:da9:b0:b8e:b366:58c1 with SMTP id a640c23a62f3a-b8f546a8f99mr160654766b.49.1770745276183;
        Tue, 10 Feb 2026 09:41:16 -0800 (PST)
Received: from [192.168.10.81] ([151.61.26.160])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b8edae6f106sm540183566b.65.2026.02.10.09.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 09:41:15 -0800 (PST)
Message-ID: <32cbecce-5635-42b1-9095-b5ae6443384e@redhat.com>
Date: Tue, 10 Feb 2026 18:41:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found by
 KASAN/Syzkaller fuzz test (v5.10.0)
To: Sean Christopherson <seanjc@google.com>
Cc: Zhangjiaji <zhangjiaji1@huawei.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Wangqinxiao (Tom)" <wangqinxiao@huawei.com>,
 zhangyashu <zhangyashu2@h-partners.com>,
 "wangyanan (Y)" <wangyanan55@huawei.com>
References: <369eaaa2b3c1425c85e8477066391bc7@huawei.com>
 <5f3e0ca5-cf60-4f07-bbc6-663b04192c49@redhat.com>
 <aYtCMAPK4xVnE_FS@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
In-Reply-To: <aYtCMAPK4xVnE_FS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-70773-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: B437411E07A
X-Rspamd-Action: no action

On 2/10/26 15:35, Sean Christopherson wrote:
> On Tue, Feb 10, 2026, Paolo Bonzini wrote:
>>
>>> I've analyzed the Syzkaller output and the complete_emulated_mmio() code path.
>>> The buggy address is created in em_enter(), where it passes its local variable `ulong rbp` to emulate_push(), finally ends in emulator_read_write_onepage() putting the address into vcpu->mmio_fragments[].data .
>>> The bug happens when kvm guest executes an "enter" instruction, and top of the stack crosses the mem page.
>>> In that case, the em_enter() function cannot complete the instruction within itself, but leave the rest data (which is in the other page) to complete_emulated_mmio().
>>> When complete_emulated_mmio() starts, em_enter() has exited, so local variable `ulong rbp` is also released.
>>> Now complete_emulated_mmio() trys to access vcpu->mmio_fragments[].data , and the bug happened.
>>>
>>> any idea?
>>
>> Ouch, the bug is certainly legit.  The easiest way to fix it is something
>> like this:
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index c8e292e9a24d..1c8698139dd5 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -1905,7 +1905,7 @@ static int em_enter(struct x86_emulate_ctxt *ctxt)
>>   	rbp = reg_read(ctxt, VCPU_REGS_RBP);
>>   	rc = emulate_push(ctxt, &rbp, stack_size(ctxt));
>>   	if (rc != X86EMUL_CONTINUE)
>> -		return rc;
>> +		return X86EMUL_UNHANDLEABLE;
> 
> This won't do anything, rc == X86EMUL_CONTINUE when MMIO is needed.

Yeah, I was thinking of X86EMUL_IO_NEEDED but that's only for reads.

Paolo


