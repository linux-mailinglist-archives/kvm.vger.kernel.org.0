Return-Path: <kvm+bounces-70593-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wFSAHya5iWlDBQUAu9opvQ
	(envelope-from <kvm+bounces-70593-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:38:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id ED98810E343
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 974F33003BDF
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 10:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44B436826C;
	Mon,  9 Feb 2026 10:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzEuNcQs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28072238159;
	Mon,  9 Feb 2026 10:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770633500; cv=none; b=deBSbbE3IODptQnhpK3SWXh2zc/AvxWztP7Fub7Sp5rYh0tP0n8WUv71ldbnl2BJUdxvi0h4g/N4kk2f4A1+e+2N3IGK+rtbNP7y++N1mb+rxDmdBNxAFKmZznIYI0/xvumOhW7Lov4c3z56RknNicjdRTU1nRlf2rO/czutmL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770633500; c=relaxed/simple;
	bh=PjFOZ2Yz7mO0UhUahvefnGZNcIR2YokkeQiLOGg5Z1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ryFHoXaQifp0+bu0cvyoS49SaSF3htN6yOgPHdju1R7+hEU1PMii9UEJEVDrnz09pdRriFXLc3C9DLgo/yiO5asb6xv3BEs0rNPUIULkqLMVLQ2IzrzTnxxRf+djccLoxfecha1NjB6XcuMqJGnlnLLLnLl46yjzOlTu0h2WCEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzEuNcQs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87AAC116C6;
	Mon,  9 Feb 2026 10:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770633499;
	bh=PjFOZ2Yz7mO0UhUahvefnGZNcIR2YokkeQiLOGg5Z1U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KzEuNcQs6j1nIvhTqD8J3QP5/G4Gdiz3j0txOgLx3WD3ac+GI2STE3v6Ge0i/iZ/D
	 TcSFzdsrpG9NC6J0nar6uC5O3xaUvWKYkPM0IiLeJDR7HKusRzzbHsDO7S+XS/BmHb
	 fFhTlzngjvzhpM5UG2DJx4hYhEvHl6VhoPGMYJvqGP8AAf682eoDvB5xPhzPU8evfA
	 aBkWDC5TWwHlucC5IXs0XZgd0nTYgw005QVosp/l05dVnmg0nGscMB7LD787VSLYlb
	 4yQRU6kfgOR2JGParxz8Hm+GXmE6L/NS7VT2y0sUmFjZFCGmxIT2S9SS02mko6dMNR
	 ob1HzUObjWFfw==
Message-ID: <442d7ce8-0de3-4f5a-95ed-3be9bdaa7e47@kernel.org>
Date: Mon, 9 Feb 2026 11:38:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: guest_memfd: Disable VMA merging with VM_DONTEXPAND
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 syzkaller-bugs@googlegroups.com, michael.roth@amd.com,
 vannapurve@google.com, kartikey406@gmail.com
References: <697d115a.050a0220.1d61ec.0004.GAE@google.com>
 <20260204170144.2904483-1-ackerleytng@google.com>
 <CAEvNRgF75EsHL8idLzFzbk0K9uhE70AMj5Vitp4cKNg_5WqQKw@mail.gmail.com>
 <aYO8DLCWw8FEQUAU@google.com>
 <16e5a36e-fff0-4a54-9c5c-a8e411659108@kernel.org>
 <CAEvNRgHX7MPSBX7pMeSWEtzc0-bJhAZ=pv+WF0VtOv9Tx0Jpxw@mail.gmail.com>
 <CAEvNRgEO3gB6Oee2C-+8Pu=+3KY0C98yrmesKO2SMVSvs3anfA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgEO3gB6Oee2C-+8Pu=+3KY0C98yrmesKO2SMVSvs3anfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,vger.kernel.org,redhat.com,googlegroups.com,amd.com,google.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-70593-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: ED98810E343
X-Rspamd-Action: no action

On 2/8/26 18:34, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
>>
>> [...snip...]
>>
>>> !thp_vma_allowable_order() must take care of that somehow down in
>>> __thp_vma_allowable_orders(), by checking the file).
>>>
>>> Likely the file_thp_enabled() check is the culprit with
>>> CONFIG_READ_ONLY_THP_FOR_FS?
>>>
>>> Maybe we need a flag to say "even not CONFIG_READ_ONLY_THP_FOR_FS".
>>>
>>> I wonder how we handle that for secretmem. Too late for me, going to bed :)
>>>
>>
>> Let me look deeper into this. Thanks!
>>
> 
> I trimmed the repro to this:
> 
> static void test_guest_memfd_repro(void)
> {
> 	struct kvm_vcpu *vcpu;
> 	uint8_t *unaligned_mem;
> 	struct kvm_vm *vm;
> 	uint8_t *mem;
> 	int fd;
> 
> 	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
> 
> 	fd = vm_create_guest_memfd(vm, SZ_2M * 2, GUEST_MEMFD_FLAG_MMAP |
> GUEST_MEMFD_FLAG_INIT_SHARED);
> 
> 	unaligned_mem = mmap(NULL, SZ_2M + SZ_2M, PROT_READ | PROT_WRITE,
> MAP_FIXED | MAP_SHARED, fd, 0);
> 	mem = align_ptr_up(unaligned_mem, SZ_2M);
> 	TEST_ASSERT(((unsigned long)mem & (SZ_2M - 1)) == 0, "returned
> address must be aligned to SZ_2M");
> 
> 	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_HUGEPAGE), 0);
> 
> 	for (int i = 0; i < SZ_2M; i += SZ_4K)
> 		READ_ONCE(mem[i]);
> 
> 	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_COLLAPSE), 0);
> 
> 	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_DONTNEED), 0);
> 
> 	/* This triggers the WARNing. */
> 	READ_ONCE(mem[0]);
> 
> 	munmap(unaligned_mem, SZ_2M * 2);
> 
> 	close(fd);
> 	kvm_vm_free(vm);
> }
> 
> And tried to replace the fd creation the secretmem equivalent
> 
> 	fd = syscall(__NR_memfd_secret, 0);
> 	TEST_ASSERT(fd >= 0, "Couldn't create secretmem fd.");
> 	TEST_ASSERT_EQ(ftruncate(fd, SZ_2M * 2), 0);
> 
> Should a guest_memfd selftest be added to cover this?
> 
> MADV_COLLAPSE fails with EINVAL, but it does go through to
> hpage_collapse_scan_file() -> collapse_file(), before failing because
> when collapsing the page, copy_mc_highpage() returns > 0.

Just what I suspected. :)

Thanks for digging into the details!

-- 
Cheers,

David

