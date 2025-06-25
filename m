Return-Path: <kvm+bounces-50686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4714BAE851F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF89E189B5D7
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 13:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446472641D8;
	Wed, 25 Jun 2025 13:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4v3nLrua"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878B745945
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 13:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750859277; cv=none; b=JgUPFwEYzRTTFCp0FIl2m+eGhiRNzLe35KMro/0SG+GSL3gBCiFdakPNfYrBIXwDs3R+OINv44Cj4ZxFb5fmk5IFVO3Q1mZmggoks89PXEIINy/4I8WV0wJJoltf8t5D8GkYFz+WKZI4SKvZiuG3frakQ1XMFisdDO2Ih4wPPDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750859277; c=relaxed/simple;
	bh=VGtVJi5CoDux4I3VQLDQbQlUaY8C6zsXK6vGNWYjQe4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OLf1ejtbwevxQCfdV3/mAosyBgHHaWZwJKr6qn6/DQ85T6CU/Xy8n6NBmetN4ecXGkZzHJD8NIIj5WAflOApBEveLo6g44Wm5TY/4fqo1ao2pNyeqrCNDMjgcly0nFpZVTs2hT8JC2gl10pCDf2c7tcpA0jEkj4o8VcKdufahEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4v3nLrua; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-237f270513bso139005ad.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 06:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750859274; x=1751464074; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGtVJi5CoDux4I3VQLDQbQlUaY8C6zsXK6vGNWYjQe4=;
        b=4v3nLruaC3KrZnxUtYbX68lg1BDHdpHLRZWwCvM7GmHPFpfvwuEIDSRPCJLWNIQCwF
         zIcS9jnwC/OqOWZEbM5lzpPYaA79nHHoZ6CvYpDrToSzC5W5JcpaJBK0FzLGd52+onUx
         KYALv0U+M03ywnETuK6rR8tGm0LcURnZ7PGZqzBufduebbQ6bRqNbNzJVvXWBQAwUVwx
         aP5ICcNCW7I5ATTrJXe/T/ega/UDkqqrw7hL0/orgx6L33tyfh6EDf/3j7d+E50w9xMO
         fy0lAHZuulHeTZ3FwSEBX5192ThzJbZWrUr9A2zQAWqD+aXDRVNNZYTzAf4kI5ng18Tw
         wylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750859274; x=1751464074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VGtVJi5CoDux4I3VQLDQbQlUaY8C6zsXK6vGNWYjQe4=;
        b=eYpheY4bi9apKXnRthrr6n7lCwluPYxduAg0iejWJZ78aaaXN9TPcVWKej6fiKhCY0
         26GqW8PDYik2J2Nn9g8dTjcmX3sKrpQX5XDenA5k7SEM5gY0p0qSUYzvb0u5qNCD0sBO
         DgNyxEaQusvH10viO9nSoIp7LaZKlRx+M/HwFGUdG6lar932ykvrpux11Q9vVhl6yMk3
         xQ6uOdm3IPAGeVZ6ULv7j+iwYhf+1QqptdGaZmMi/cmRXxFfszrn6TXXrbNAbLDQcet9
         Pw3rFQvZe/QTVC1ZJV6wgR0WwACSoN1jj8hWOmQZIogfmt5+Y0jjf5cWrwv9LSrLnIsC
         J3dg==
X-Forwarded-Encrypted: i=1; AJvYcCXjDNKcDAhmvegtjK1Cyhr3fstXu6b36avf56fZtm8v/j2E36AxN4Uh4Z8BMS8xIi8tdB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfYt8rcbcqt5VMwflj9p8ia3sxfXWJMbjTFDq8gBn7UFXWAklB
	4Za6PCyzyFojfmR0+DfYuJX2gTrU5fwEdZ7W44CNMuVB+1ViIazFlqf/E+f0+PgA7X5bhcQlpvS
	zhvSNc5o1MY4tjBf3Kv62Dk/9HWtYN4qAn5IVOEQY
X-Gm-Gg: ASbGnctOG6780j/7X+riSVsE6lycbqaz0SxCE6d5T3Q7zzaJNQ+yA+gOAOp5rHqLdsc
	O0zOZtMp/7RttzYfS5QoPn+VDuGQtx/6mW/V55ujf4H69MmMmtfgqYV64HQvkPHXUdqUs3ahpKI
	Ld9q5vVLmiYXtfjgfaDdzh+vl8jBRdXq/q8ZJ09xTBEkWzfweyD/KIefuBc1XGdskUS5GaZgktm
	joy
X-Google-Smtp-Source: AGHT+IFih6i6FHqdKlHiTqYQtuxauWYxR8hxnuVmkAsDP91INYFX6UC1hP2vKvdQJGH9NxCC36goGVBUnX4d54Og02g=
X-Received: by 2002:a17:902:ffc7:b0:231:e069:6195 with SMTP id
 d9443c01a7336-23828dd6ba0mr1711135ad.23.1750859273323; Wed, 25 Jun 2025
 06:47:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com> <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com> <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com> <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com> <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com>
 <aFWM5P03NtP1FWsD@google.com> <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com> <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
In-Reply-To: <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 25 Jun 2025 06:47:40 -0700
X-Gm-Features: AX0GCFu06PURghEvWwSxtC_cBelfR-tPSLcItrLKKSKf9WyCjshcXbUMHj0Z9IE
Message-ID: <CAGtprH_1nMC_z+ut3H6Hjjjb9J=sg=h-H10L9PVK+x=Vw2SM0w@mail.gmail.com>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is RUNNABLE
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"tabba@google.com" <tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 11:36=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> ...
> For leaving the option open to promote the GFNs in the future, a GHCI int=
erface
> or similar could be defined for the guest to say "I don't care about page=
 size
> anymore for this gfn". So it won't close it off forever.
>

I think it's in the host's interest to get the pages mapped at large
page granularity whenever possible. Even if guest doesn't buy-in into
the "future" GHCI interface, there should be some ABI between TDX
module and host VMM to allow promotion probably as soon as all the
ranges within a hugepage get accepted but are still mapped at 4K
granularity.

