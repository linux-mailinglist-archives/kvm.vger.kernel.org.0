Return-Path: <kvm+bounces-52665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3529BB07F32
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67A895861FF
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 20:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB3728FA85;
	Wed, 16 Jul 2025 20:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VpJUmjMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BB51DB95E
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 20:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699479; cv=none; b=fOH05EiC387NJZo+K+RLbNiqD4+EuR2hgIWQiKZ8qh2Izkr5I3pQRCRXuvpRtqnKE5lmqfywBfTiimmiMHt2LzBET1PwkZUixGuVko+0GCoZYQzhCZ5tVhfl/v+WyPbqqYyWxvuAJkNWnKiMRSf9KFf7OfUC6WCTkeb+uLcsUhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699479; c=relaxed/simple;
	bh=pJ/4DafB/4w+xjMztWYcyBoqegyacdCJgns1Yhv4hgM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mEI4BToQy8KD2yXlHaI2PpxYPV3pRxPWU7+3uSondILN3fUkj8DC1bmeo87GKvKCvsHS6ZOFYQcNjpBDuJbcdLFXBDhMOqTBo/myhHN9FW824TqXTmyrWEqb25orykjP8qyJ7DyYzl9MqDxO3mRBSS6LCgOjSxh2s1taJGVvc1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VpJUmjMQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fcbd76b61so191793a12.3
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 13:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752699477; x=1753304277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X9lenlLaUjBwFPsSQEFgMT5DWXk0MgfTQE/56EK1w/o=;
        b=VpJUmjMQwWFY+CmUT7BrOWNoAEKFv+dTCJXpHWgMsl082XgG1WsJe7s++iotc7Qkak
         E+XsJA9FguaK5vJEGsrf6OQRSZAV96SvDt1KbZmTC4OyN27NUIvV39DV+RQEYKUiDkOC
         SlsYDKyV5qL2IeoC2apvSx/CXYMwN84HeoFonCG4srlT0H9odjFTNf2gDJfbyhZeLrV2
         gC6MA2xGXJH3Eb8UTtzBjp9LIYqCZqrupj751ngKA/oajXbqMMsQY8B8d3VXUQh5O59R
         zf0vmtBzX2N1Gep16ie0zolYbn5ArUjyW7kV4YH6e68chihYvM0BkPene6F75Vx/e738
         RnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752699477; x=1753304277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X9lenlLaUjBwFPsSQEFgMT5DWXk0MgfTQE/56EK1w/o=;
        b=cr6RDcDYzfCIy2lB0ZYP/pz1WJ83h9AajD0EYEgZJVoOm9hj3+NqZXMJsGyUdZqxAd
         WAZFkfcVQcBUzOZtkc8nOTCl/jguxFafS3JcJBj+TY2IDxmc0qBhAAKppEV3fozbnub8
         49IbgodRVVK4g7HIdnRy0gi7mJyTUAHkKNXsnHNwX5IazQJN+pwiUxh/qoYkHiUq/qZ1
         0rLSy17B+DrjUALlAurpeQX0OgzEzKPvytnYjbLCd/sCP8Hxitbk0tlQZrLZkDIQZ5jl
         cPjHNwAKSUL2yRsQALcbsAitW7y7GSjppNAnD1+F78kiwqCmDWB1qed8OzCKG7usVRGG
         bDxg==
X-Forwarded-Encrypted: i=1; AJvYcCXLa/daYc6aDJ/4fEhCwxJt1CoDTh6kaI141anNBQnWCorkUOdBk7Ozp4D1hx0vDBkD4xM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsY8EEtgJcr4r9Oy00qq6AGJIGx8c25lPAKvGcnQLgtDcA8kvP
	ob9foBECpsxL4dBJjmoSWi/5LYK7tB8IBWwN5eyxbEP3iRvV4auoWY2XD6eUaF9MEXwBfEZMibn
	LZqdbJP+SeHnNXYNtPmqN2Hs6HA==
X-Google-Smtp-Source: AGHT+IGNf5oVY5kma+CCr/p05OELE5VhNVLq7ohNlp+ZzdSjlbph404RAAhFoA50xb0uihspcKXEHnrZLqgj7v9bog==
X-Received: from pfx8.prod.google.com ([2002:a05:6a00:a448:b0:742:a99a:ec52])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:6713:b0:218:59b:b2f4 with SMTP id adf61e73a8af0-2381395fed6mr6120657637.42.1752699477363;
 Wed, 16 Jul 2025 13:57:57 -0700 (PDT)
Date: Wed, 16 Jul 2025 13:57:55 -0700
In-Reply-To: <aHb/ETOMSQRm1bMO@yzhao56-desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com> <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
 <aHb/ETOMSQRm1bMO@yzhao56-desk>
Message-ID: <diqzfrevhmzw.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: vannapurve@google.com, pbonzini@redhat.com, seanjc@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kirill.shutemov@intel.com, 
	tabba@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Thu, Jun 05, 2025 at 03:35:50PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>> 
>> > On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
>> >> Hi Yan,
>> >> 
>> >> While working on the 1G (aka HugeTLB) page support for guest_memfd
>> >> series [1], we took into account conversion failures too. The steps are
>> >> in kvm_gmem_convert_range(). (It might be easier to pull the entire
>> >> series from GitHub [2] because the steps for conversion changed in two
>> >> separate patches.)
>> > ...
>> >> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
>> >
>> > Hi Ackerley,
>> > Thanks for providing this branch.
>> 
>> Here's the WIP branch [1], which I initially wasn't intending to make
>> super public since it's not even RFC standard yet and I didn't want to
>> add to the many guest_memfd in-flight series, but since you referred to
>> it, [2] is a v2 of the WIP branch :)
>> 
>> [1] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept
>> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
> Hi Ackerley,
>
> I'm working on preparing TDX huge page v2 based on [2] from you. The current
> decision is that the code base of TDX huge page v2 needs to include DPAMT
> and VM shutdown optimization as well.
>
> So, we think kvm-x86/next is a good candidate for us.
> (It is in repo https://github.com/kvm-x86/linux.git
>  commit 87198fb0208a (tag: kvm-x86-next-2025.07.15, kvm-x86/next) Merge branch 'vmx',
>  which already includes code for VM shutdown optimization).
> I still need to port DPAMT + gmem 1G + TDX huge page v2 on top it.
>
> Therefore, I'm wondering if the rebase of [2] onto kvm-x86/next can be done
> from your side. A straightforward rebase is sufficient, with no need for
> any code modification. And it's better to be completed by the end of next
> week.
>
> We thought it might be easier for you to do that (but depending on your
> bandwidth), allowing me to work on the DPAMT part for TDX huge page v2 in
> parallel.
>

I'm a little tied up with some internal work, is it okay if, for the
next RFC, you base the changes that you need to make for TDX huge page
v2 and DPAMT on the base of [2]?

That will save both of us the rebasing. [2] was also based on (some
other version of) kvm/next.

I think it's okay since the main goal is to show that it works. I'll
let you know when I can get to a guest_memfd_HugeTLB v3 (and all the
other patches that go into [2]).

[2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2

> However, if it's difficult for you, please feel free to let us know.
>
> Thanks
> Yan

