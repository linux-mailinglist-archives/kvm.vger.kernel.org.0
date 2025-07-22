Return-Path: <kvm+bounces-53165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0E6B0E31B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 19:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7874B3A4F2B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1FB281369;
	Tue, 22 Jul 2025 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9gmYeR3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851A827F4D9
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753206925; cv=none; b=XUWUzlom/5GeTcuHQV/Et1bWcqKBQFGnDGPUCVyXEyiO2rmhZ6GBKrm0+h35YeR6ly5wPj8o8oSZOt11UT+ns1Yd6ch1uTOgmdofupd6rhkENFQsDqWwW+UaTGJ7F9OxmppQYP9Z43U9NtEbbkWXDmOPO6q6zcOM3nt+YFLwrik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753206925; c=relaxed/simple;
	bh=iapMhQwsFNjzaVvGUH8EMPUkVK053gLxhxy3z7USMcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I0gBQXwCnrpQb5rfBJu2OErzhFr+d2KF4Iab5RYM1wY55VE291DWN6YbRhkmalNkMbBzLpS/LBycEJ90sHMvumGMiG3+1RVQLsS/pj8dt688NA07+Di3KgD8wvSI/4O2GIUcJPjNVxL1NL96+0qfoM+rai2YBvLJVF1UlitYXrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9gmYeR3; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fcbd76b61so6695185a12.3
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 10:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753206923; x=1753811723; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3mt3yYglHDnSBdSmPZ1zrcnzwFHve4g2+M6+Jdcn59w=;
        b=w9gmYeR3OAju33bJ+gdfvERks8vfRW+n9KpV2bD1BmECq2v9o1VfGmhiVBUm9D/BsT
         Qs+X+ZdlRhXIk83tJx67OPgxqyof3G/iB7QKZ+ESf0ebP4B+0G5R7n0HUZwkelFgaDgc
         dC+HNpsoJQkzn6QQrMJ2SvKg9R9nLtEYO5dljA1EGmPkYGIzrhwUhefm76jroRcPd5bS
         2dsoej2FEd62F3oPAZeQmgIBIUf2I7TUR8SXEma2SdxTcsNQ91ZvFfClDadahLvC397N
         sWi8NWwxTbcZufzZWqHH/VGSMKz+uvumUBf071551CJsCzwtIdsW93ob8AVG2F2g2wPn
         f2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753206923; x=1753811723;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3mt3yYglHDnSBdSmPZ1zrcnzwFHve4g2+M6+Jdcn59w=;
        b=nzpwKU6S0sO3uGNPO/5YZyLmAWqy0/0OzTV/UhQYLGCR2d2GqK111agcIa3bszotzS
         88fxSzKZG8ePJQT7zXWPCisxQ//tK9qjiiLsPnF2bhnz2BAXeUfc8gLRcOCWUd9uO8f2
         dVBnA0HB/qiRdmQBaOuLOgIV94ucKc0bOQ5Zt/uODxY8YgenBw2fewosVBi6fA4marI/
         ni+F7KD2CG2uDtxlk/FW0dl6TeNpgkr6Ya4vsLAfqZdYGnH1AESoRzxTTX53RdI7qLMd
         ZFdTL6eU2ajhF02ylWkxyx5AoU6CCuUfJE8U2yvR/uLgD+hti+cpGjaSoATrq4cSwS/b
         BNqg==
X-Forwarded-Encrypted: i=1; AJvYcCWt8bPzfS4T3p8ZXabwkFfzwlzbXNEk+baPEQdVdDoN8TeTNor3UhSSj8jWIJppT6lfvvw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE0VDH7jKzhoXsXRMFMBWQpJLnioy7Udxxmr8qHNz6uRiTML1T
	yuI8x5CzuGlRSUPe+BVZrQ8cPlivpUaTLLiQOrEIfPvzAnwxHBg+UqBVEEbwV2CdRPopD6VFg4m
	Cq94iRMzlS3kurugVDd/yqJHbKQ==
X-Google-Smtp-Source: AGHT+IGlFgyTRPkZWoQjbmY7T310OJ1BlWGpJ3/Q2IhMntxDiBOom0S5N+SghsjZY8MWMZqXf+k2KOAttfWZj9n3EQ==
X-Received: from pfbmc33.prod.google.com ([2002:a05:6a00:76a1:b0:73e:665:360])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:13a0:b0:748:f750:14c6 with SMTP id d2e1a72fcca58-760353db8bbmr218966b3a.14.1753206922841;
 Tue, 22 Jul 2025 10:55:22 -0700 (PDT)
Date: Tue, 22 Jul 2025 10:55:21 -0700
In-Reply-To: <aH8xkkArWBrjzYfk@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com> <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
 <aHb/ETOMSQRm1bMO@yzhao56-desk> <diqzfrevhmzw.fsf@ackerleytng-ctop.c.googlers.com>
 <aHnghFAH5N7eiCXo@yzhao56-desk.sh.intel.com> <diqz8qkg6b8l.fsf@ackerleytng-ctop.c.googlers.com>
 <aH8xkkArWBrjzYfk@yzhao56-desk.sh.intel.com>
Message-ID: <diqz1pq85cvq.fsf@ackerleytng-ctop.c.googlers.com>
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

> On Mon, Jul 21, 2025 at 10:33:14PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>> 
>> > On Wed, Jul 16, 2025 at 01:57:55PM -0700, Ackerley Tng wrote:
>> >> Yan Zhao <yan.y.zhao@intel.com> writes:
>> >> 
>> >> > On Thu, Jun 05, 2025 at 03:35:50PM -0700, Ackerley Tng wrote:
>> >> >> Yan Zhao <yan.y.zhao@intel.com> writes:
>> >> >> 
>> >> >> > On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
>> >> >> >> Hi Yan,
>> >> >> >> 
>> >> >> >> While working on the 1G (aka HugeTLB) page support for guest_memfd
>> >> >> >> series [1], we took into account conversion failures too. The steps are
>> >> >> >> in kvm_gmem_convert_range(). (It might be easier to pull the entire
>> >> >> >> series from GitHub [2] because the steps for conversion changed in two
>> >> >> >> separate patches.)
>> >> >> > ...
>> >> >> >> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
>> >> >> >
>> >> >> > Hi Ackerley,
>> >> >> > Thanks for providing this branch.
>> >> >> 
>> >> >> Here's the WIP branch [1], which I initially wasn't intending to make
>> >> >> super public since it's not even RFC standard yet and I didn't want to
>> >> >> add to the many guest_memfd in-flight series, but since you referred to
>> >> >> it, [2] is a v2 of the WIP branch :)
>> >> >> 
>> >> >> [1] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept
>> >> >> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
>> >> > Hi Ackerley,
>> >> >
>> >> > I'm working on preparing TDX huge page v2 based on [2] from you. The current
>> >> > decision is that the code base of TDX huge page v2 needs to include DPAMT
>> >> > and VM shutdown optimization as well.
>> >> >
>> >> > So, we think kvm-x86/next is a good candidate for us.
>> >> > (It is in repo https://github.com/kvm-x86/linux.git
>> >> >  commit 87198fb0208a (tag: kvm-x86-next-2025.07.15, kvm-x86/next) Merge branch 'vmx',
>> >> >  which already includes code for VM shutdown optimization).
>> >> > I still need to port DPAMT + gmem 1G + TDX huge page v2 on top it.
>> >> >
>> >> > Therefore, I'm wondering if the rebase of [2] onto kvm-x86/next can be done
>> >> > from your side. A straightforward rebase is sufficient, with no need for
>> >> > any code modification. And it's better to be completed by the end of next
>> >> > week.
>> >> >
>> >> > We thought it might be easier for you to do that (but depending on your
>> >> > bandwidth), allowing me to work on the DPAMT part for TDX huge page v2 in
>> >> > parallel.
>> >> >
>> >> 
>> >> I'm a little tied up with some internal work, is it okay if, for the
>> > No problem.
>> >
>> >> next RFC, you base the changes that you need to make for TDX huge page
>> >> v2 and DPAMT on the base of [2]?
>> >
>> >> That will save both of us the rebasing. [2] was also based on (some
>> >> other version of) kvm/next.
>> >> 
>> >> I think it's okay since the main goal is to show that it works. I'll
>> >> let you know when I can get to a guest_memfd_HugeTLB v3 (and all the
>> >> other patches that go into [2]).
>> > Hmm, the upstream practice is to post code based on latest version, and
>> > there're lots TDX relates fixes in latest kvm-x86/next.
>> >
>> 
>> Yup I understand.
>> 
>> For guest_memfd//HugeTLB I'm still waiting for guest_memfd//mmap
>> (managed by Fuad) to settle, and there are plenty of comments for the
>> guest_memfd//conversion component to iron out still, so the full update
>> to v3 will take longer than I think you want to wait.
>> 
>> I'd say for RFCs it's okay to post patch series based on some snapshot,
>> since there are so many series in flight?
>> 
>> To unblock you, if posting based on a snapshot is really not okay, here
>> are some other options I can think of:
>> 
>> a. Use [2] and posting a link to a WIP tree, similar to how [2] was
>>    done
>> b. Use some placeholder patches, assuming some interfaces to
>>    guest_memfd//HugeTLB, like how the first few patches in this series
>>    assumes some interfaces of guest_memfd with THP support, and post a
>>    series based on assumed interfaces
>> 
>> Please let me know if one of those options allow you to proceed, thanks!
> Do you see any issues with directly rebasing [2] onto 6.16.0-rc6?
>

Nope I think that should be fine. Thanks for checking!

> We currently prefer this approach. We have tested [2] for some time, and TDX
> huge page series doesn't rely on the implementation details of guest_memfd.
>
> It's ok if you are currently occupied by Google's internal tasks. No worries.
>
>> >> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
>> >> 
>> >> > However, if it's difficult for you, please feel free to let us know.
>> >> >
>> >> > Thanks
>> >> > Yan

