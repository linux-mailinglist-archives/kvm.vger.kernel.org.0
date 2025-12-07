Return-Path: <kvm+bounces-65467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F43CAB0C9
	for <lists+kvm@lfdr.de>; Sun, 07 Dec 2025 04:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3AD930D523C
	for <lists+kvm@lfdr.de>; Sun,  7 Dec 2025 03:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24C1275AF0;
	Sun,  7 Dec 2025 03:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CyJazLfR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ED31B3923
	for <kvm@vger.kernel.org>; Sun,  7 Dec 2025 03:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765077173; cv=none; b=dfn6rwVb8iiIyYO0rRMCnMx2HDh5OpSkjg9AkzJyXuFnBWfCdox/LOFm2PRWJEXd7+53PaGCfyeJSuc8bHlZjeE/IjTwcyRpgvhNjh7CzVwUHDLC40ZGZ1HJyey8SnzCAdMDGD6vk77NaLDMNe4bBMOlo70mtu7vVQEKvaFCatI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765077173; c=relaxed/simple;
	bh=WotXdY2S46V6EWUmhoIs7cQiM+SwpVn3irRrTAXhRds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dO18W8/Wj2W+eYHvWQGz38cUXHeg0avmrqkJ98/OojVN9kcQAc/G4DRuBK09/WPWIH4uMPlah0q3pJSCUT8Qioer61WP5c6hbo4O+VgoStXZlxjPcqiYKDlyayssoRQ1MvMOW9utpD3ltfSFdedi9PbuFVUvtpQGMzHIVzk4NMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CyJazLfR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so25342235e9.1
        for <kvm@vger.kernel.org>; Sat, 06 Dec 2025 19:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765077170; x=1765681970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVjvCRDiLMRUoN6KdVSryCZbii8x/leb+gzOibV+bP8=;
        b=CyJazLfR33vLpx1QvgWpp0kujmUc7uFU7Knrs9fQEqox4CHdX74Ez0M2bvdq/Z7Ucn
         Cnl6mLTIaNo/iQ3CSqnQ0rQDbNB4iNU6N1CWZn2U8xsnXRBoPGSyOHKrjIgsHalZwscb
         fMyykBLLGMvVhG21rCHuofO7ApYh0IgPD/iRg8Hq5Pjwz82lCFr69SUUnltmVhOVDYrM
         /swqNIBLD3C46HzMukHg3METDaC3VF8AvUyUDu6ZdMHkcTit4u1lVXHtV8Fr2Rp2xKxb
         yk2uOZYgbKnCd/O6FImcZsmpy+09yiKjm8rW18QnMKtOqus20tMDOuEDCtvUXxedDj7F
         fv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765077170; x=1765681970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVjvCRDiLMRUoN6KdVSryCZbii8x/leb+gzOibV+bP8=;
        b=u1/pxeYygLuT/FAMJ4UNKfrH53etqR1CaE1xzjSIhCzbrZWMhXNYBa1JACB9z+c0rF
         HmiDG30cVwjU3AVc7qniEt9Y4HY5mad2k4XSNl4gnFWEMMsG9nvkpC/bwoBO2hUnUWZi
         nGe0xevxTsfsTAH8ArpSL0GTFCs5awJN9IGKd5HBOGSqin96Pxp3e70zhDlLHsTjbtCl
         VjdV1ZnYibGXtKlkt1kaaB3vH128afsZFL4jNsSC3mu27J1Kq1Fl+YoSV0BnJkwUAWK+
         ccKeuQGopBYlPgzKUh6Fx+RBUOVpPWsvGEe/2thdT1mT4gRs5R0Q9fZwX52+6yObD3TE
         j0rg==
X-Forwarded-Encrypted: i=1; AJvYcCUxtXjXcaVadYtIlw/MEh/wngWwxrPH7cW10pCczqIqBrZkA6bmrYvpEuVPf/alXxSneww=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEJ4PWqV4oeL+QcIHNcis3YzhX9kgyggOEuKB8rqXdd+GMhLxo
	+MahAiDvLtuQSECKaSjGFa550ifKUMBpZhAZABCQo0sG9MW8ha9RSVYVScR+xE0QUNQsVSNbf+6
	fypC6ZiegJmB03Q==
X-Google-Smtp-Source: AGHT+IEmoIr1XRdh2jEsRUDswYZqXhX3eoQiIFPX3VP+DLGDPoq40SIlYagZTuIw1RSOFbCoujpa5asPuE2+JQ==
X-Received: from wmbgz9-n1.prod.google.com ([2002:a05:600c:8889:10b0:471:1414:8fd1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:37c3:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-47939e37b60mr41129515e9.27.1765077169581;
 Sat, 06 Dec 2025 19:12:49 -0800 (PST)
Date: Sun, 07 Dec 2025 03:12:48 +0000
In-Reply-To: <20251205165743.9341-1-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205165743.9341-1-kalyazin@amazon.com>
X-Mailer: aerc 0.21.0
Message-ID: <DERNMX91W3P4.AHN53QLCCIH5@google.com>
Subject: Re: [PATCH v8 00/13] Direct Map Removal Support for guest_memfd
From: Brendan Jackman <jackmanb@google.com>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, 
	"jmattson@google.com" <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>, <owner-linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Fri Dec 5, 2025 at 4:57 PM UTC, Nikita Kalyazin wrote:
> Changes since v7:
>  - David: separate patches for adding x86 and ARM support
>  - Dave/Will: drop support for disabling TLB flushes

In case anyone was following along at home - it looks like
kvm_arch_gmem_supports_no_direct_map() has been refactored which also
fixes the can_set_direct_map() issue from [0].

[0] https://lore.kernel.org/kvm/DDWOP8GKHESP.2EOY2HGM9RXHU@google.com/#t

