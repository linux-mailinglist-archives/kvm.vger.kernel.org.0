Return-Path: <kvm+bounces-68914-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BXaI+lccmn5iwAAu9opvQ
	(envelope-from <kvm+bounces-68914-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:22:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 840C86B296
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E8EAC301C683
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F103DD772;
	Thu, 22 Jan 2026 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dfc6529b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9953DCE3C
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100289; cv=pass; b=i9wizdgxlhzmhpVzN+kz3afrVADF5EhsO5KUI3af/uTd0OLgYe0ITr/Ya0FX4WmLdbm+16rOXHtyYGMZge7Q4mDX+wiKABP54S0m3M9+33BRjgDQ30JzIBa5s5/SC9ZyrTdxO7jyX119HqptzG2QA8N4dyNNLZu8S7FJgeEcdH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100289; c=relaxed/simple;
	bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X8nX0MScmy1k38H5i+7QNJl3kEfxBvrV7CdVZjQRuD/QGc6RqtwTF16E+haqGlPcJ2ZXwjHt5PuUOHi1LgMK+Rn9f+AmVy+JND+JOJzIFg+P/bm0QWEckRerSAME+VWBiZUSxExhGPGZKZxk3hpipRk9EwD1kI3t3So9P21ZB2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dfc6529b; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5ed065f1007so720686137.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 08:44:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769100280; cv=none;
        d=google.com; s=arc-20240605;
        b=RD3dK6oAFKOe3mtWTTegpLYZSLaCnkLDUBffphC7ii7gDb+UFwdTEwHMsjRQoizmCc
         +0rqlKItLnEbg0pTdxnuZfi72MArXr/sYOgBy0pUiNKhXoMO1zzVqUX/hDyhrPzEu/LN
         4pWstIZqKH3Ire3Jt2P8HBLQEDoFnK44cesuCNBuiyo/+ornz5lcj4yKTfYKu+xzZ73D
         +PvlzlN+f0v3Mt/jrAtVnmMDileLTOrbohI7xjcgAJp76qcxXbOkkBZNPsqTZV7oMge6
         PRxO0ANKgA7aGi23deL//mFpe8ks0GoNq/DG0LblP2Psuxh4pxgVcl0dGg2nIplxsqKu
         g7MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        fh=6lVyzHH9IAqjQZhjuwFIybILxDLBB5ew+kjRRdo02Eo=;
        b=UCWc/oauTzLNVRq3SOyNZAvJxV8aIyEyzSJnUV6fnU/EUG6tZ9N0AZBIxMaKdzKrNJ
         FZSuBMuS+F5rKAlBSawezqTpt0Ax029WRIqCKevUtcIMHTE+4zNzfuGJZgKRXDW1TgKl
         wQQi01xOHmjnGrvjHPq2Cc14ykfhLYKiTlHGI8nu+Ov2H+VYCYbReHz6O2p1tuI6zcNo
         P/6wmDIoGTAx3o4X2lF5t1RAv83Z5daUM/dWD4Qj3GRqssvN5JMrHTML0vHZIUiSDhDs
         X3I21BJ1U1hlcRJrQSDxFDNAfbfJOY89jThNLXdzTikmJUGNfCrMNnk1eHvpl++3adDQ
         Ey3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769100280; x=1769705080; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        b=Dfc6529bhrwVaUn3YFXZCSUY5JhwdcykntEWmJBOZ5d1M1fQelFtle5XRVrvvcf3f8
         0IdAa02rZxfIuB2X5MTdy4mrRK9HIYUbxP3SVo83JD00f03CrF2HsaRXrLc0lzcAxMmh
         lKJ9tI/YJPfUZf+Lb62z41OJ5CzOXE/zHlooZNpwRkJReZPTPYydzS39pI2u+3RpEEM6
         dlz4xHl1+zCZs8zcO+Wr6j2pPs3Nr6pHtVrUfkvGgGO4jl4qF0Llg3tbd1WXVSVU1ZDX
         9FbtTHTHMcAocczb+axesPiHB/rnQaU5gbmb9JZfdhU3EZ4LWRwMkNmRJIQRlqJyoiyv
         P60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100280; x=1769705080;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        b=Ga021uQEJKB0mW3i9R5j0rhQrybtruM1CiKjpcxGXsdN5YaiE4SMsTFk6zHEvLutLs
         WQFaDCLUIT77TsF8dyIARN/9slEwy5CSf6r5xbL9qbk9EULy6gpvShERQnb2eHQDgbb8
         SMBFS1pvCc4TcCoA6tqYXsl9r0Io378lHrmPDd3ekxZFJXq97ov1KO/wkkYJzeinAB7k
         UWx+jNiHyKeeb75/Nrb9+RWbqkbK9fhZTwddnDjDoqKtbmy8ngTAT25DbDVJSmmy4OU+
         8HO+qtbcv1a4ksAwjuPnQQHESPbASOkoRjxVV9uUkejJo98J5AZlt8UoyVxGmMV5/q/y
         IE0A==
X-Forwarded-Encrypted: i=1; AJvYcCXIKF4QF4XYsuFs/jZvkvJutLjH2U1FW+N0Jm4XaxqZiblK3c7n41xeldbbeutA4bL1Gjc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCWa4yBGtLXwFt/8C3OrXdRswF1rudyhbNBP7CeVFxE5sbsJE5
	1+bnghHIHYxzNmnFPfzDIoHujxk+fY60dwNK4ACxI5bZ21LYKvhxGm0xq6uvL4ljIG1x/LoZAn+
	YvfrnDt9E+zXk2vRkBLCp023S5Wrm72tzWllUYvcI
X-Gm-Gg: AZuq6aI8TW7U9W5nIzK8a+Ht8W6vByR8oyaLeHxkYdAM/k8dQYu1DjFH3Mz9oHQs0ur
	I6LH+0zBieC+IJo0Xjtkbg/uiVwFlXS3rpLKTa+uTzi7IGe84bGfADU8KVilFhLZt/ZJzdWZ2U2
	VlmHLDDzPyijGMabmFPjN9ffhWBey+uwWPLx753bnoOHI/TIsbfbx6QlHvpFodIo7DGWVcgz0ID
	Xh1cR57elSDQ4xXqh8lwprH4Jx7scRbhWxQaGxDl8lpqtoVlD3rf5ob352ueNRRE3t55A==
X-Received: by 2002:a05:6102:d89:b0:5ec:c528:4df8 with SMTP id
 ada2fe7eead31-5f54bc628cbmr124387137.28.1769100279450; Thu, 22 Jan 2026
 08:44:39 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:44:38 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:44:38 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <CAGtprH_qGGRvk3uT74-wWXDiQyY1N1ua+_P2i-0UMmGWovaZuw@mail.gmail.com> <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 08:44:38 -0800
X-Gm-Features: AZwV_QjFiVCL1GgMB61exuGngD3MnDbAOiFUMFZ1rYdJZrzTGdTea8E5DMfoinE
Message-ID: <CAEvNRgEbG-RhCTsX1D8a3MgEKN2dfMuKj0tY0MZZioEzjw=4Xw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Cc: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"jgross@suse.com" <jgross@suse.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, "peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "ast@kernel.org" <ast@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"luto@kernel.org" <luto@kernel.org>, "haoluo@google.com" <haoluo@google.com>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "song@kernel.org" <song@kernel.org>, 
	"oupton@kernel.org" <oupton@kernel.org>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"kernel@xen0n.name" <kernel@xen0n.name>, "hpa@zytor.com" <hpa@zytor.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"jthoughton@google.com" <jthoughton@google.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"derekmn@amazon.com" <derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "will@kernel.org" <will@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,arm.com,dabbelt.com,suse.com,google.com,surriel.com,suse.de,redhat.com,linux.ibm.com,suse.cz,ghiti.fr,linux.intel.com,linutronix.de,infradead.org,os.amperecomputing.com,linux.dev,linux-foundation.org,ziepe.ca,lists.linux.dev,nvidia.com,xen0n.name,zytor.com,oracle.com,intel.com,loongson.cn,huawei.com,gmail.com,amd.com,amazon.co.uk,iogearbox.net,lists.infradead.org,eecs.berkeley.edu,amazon.com,fomichev.me,alien8.de,lwn.net,kvack.org];
	TAGGED_FROM(0.00)[bounces-68914-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[96];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.984];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 840C86B296
X-Rspamd-Action: no action

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Fri, 2026-01-16 at 09:30 -0800, Vishal Annapurve wrote:
>> > TDX does some clearing at the direct map mapping for pages that
>> > comes from gmem, using a special instruction. It also does some
>> > clflushing at the direct map address for these pages. So I think we
>> > need to make sure TDs don't pull from gmem fds with this flag.
>>
>> Disabling this feature for TDX VMs for now seems ok. I assume TDX
>> code can establish temporary mappings to the physical memory and
>> therefore doesn't necessarily have to rely on direct map.
>
> Can, as in, can be changed to? It doesn't now, because the direct map
> is reliable today.
>
>>
>> Is it safe to say that we can remove direct map for guest memory for
>> TDX VMs (and ideally other CC VMs as well) in future as needed?
>
> Linux code doesn't need to read the cipher text of course, but it does
> need to help with memory cleaning on the errata systems. Doing a new
> mapping for each page getting reclaimed would add cost to the shutdown
> path.
>

Can we disable direct map removal for errata systems using TDX only,
instead of all TDX?

If it's complicated to figure that out, we can disable direct map
removal for TDX for now and figure that out later.

> Then there is the clfush. It is not actually required for the most
> part. There is a TDX flag to check to see if you need to do it, so we
> could probably remove the direct map accesses for some systems and
> avoid temporary mappings.
>
> So long term, I don't see a problem. For the old systems it would have
> extra cost of temporary mappings at shutdown, but I would have imagined
> direct map removal would have been costly too.

Is there a way to check if the code is running on the errata system and
set up the temporary mappings only for those?

