Return-Path: <kvm+bounces-53070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E630FB0D143
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D7C616D6B5
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227E428C030;
	Tue, 22 Jul 2025 05:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZjQ4HiPO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9BC80034
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 05:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753162398; cv=none; b=eEA4GA5R4K3GP7i2eeNgQEvDRb6fWG+JU+Ka9PrJ6ao8UHQaaSgPdI2GtAEhWVQsIzpMHlEDni6OUk/YFHzfiwI/g21osldPqvgYk8PYpr/rikeSEx9ZdtCUvN0JN0Asc47LwxCYIBSot/Rrhz3cDNzUxPmgLBMoYnAju0llJdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753162398; c=relaxed/simple;
	bh=NMYrp9I25pgs6dO2IoDFOrcobW68ch4i4PlFONZcQsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DY6mUvdqqTDWV7EmYaZAs0Gw3e0QkE9zxXpBsrdbtQ9405gDw5SbJHdizHWvhragd4AThkR4F1vawRuTl013fm3hwPt0oL90gL1TM/j06kJdjMpNsAHIgZrBc+y6tPSoAVr/u+MGU2mc0WjX2BA2Bjv7Dxd5oFZDUcJDcwvYPH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZjQ4HiPO; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31df10dfadso3367286a12.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 22:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753162396; x=1753767196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xPj88w6ady/nM2I6WDm4TG40baETLNNTUVFgpBvJDcs=;
        b=ZjQ4HiPO/dDbDUKNKqDg5790WnWVzhLhXoJliFSQ43JvD/NHaNn6yGoiHQXJ6bCw8K
         433HZXBzIaT4LvcVDcXaeCf/zOx5wci5u2EWV4LC7bWQIG4zrmMXo0eJgNoEO+3Hr9t8
         ugpEGYiKQDI0Ikcku2ERvbhtMGLo9XhqyFZ/hs3XWXTc/SI5sGoVIJdM6jIG2WshQ8O7
         wFNSFlExDkhG2cRaJ1vPJpWjitLROnq+RWpaZPpKNAAngZmSx03wbJ/VpnUtBHepmQt7
         4CU6pF8bfVV8KjlbS+FCYui0LFl7zJFfOnsqnvA/RoAGTAthcywgEJ2928lHkN0vwyvt
         2uSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753162396; x=1753767196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xPj88w6ady/nM2I6WDm4TG40baETLNNTUVFgpBvJDcs=;
        b=BcyaYZIGrGKD9vrg/1F41sHUuLZJ4uXx8O15NtjZmLGgBl5X/WTr8F/q/pncqLkCC8
         UKwJE2bf/QJRrunhroLaSDx6mcVpm1Eg64K0Jfink1HpZjU+M16c47iTR+hR1kLG8BVX
         gmx4ei3aRr1IOT+Ovy91MhN+jQp9LUiw9LpZ2JQUWSL1/YfuqMmklzbmP/cDPdmJOO96
         r7EE6E2J4FTD59x+EbMq7WB1O87lK+6LizsggFA9LC0FL9clWrxWgRm+anqHu5sLcxRa
         5azAfj8d6bBZuYQ8g+HGGdWco1J0TgDAcl9rG+gaZ5peR1xBULTZBFs03SE9dFE2oL9w
         WgcA==
X-Forwarded-Encrypted: i=1; AJvYcCUpcq2rRhOgkwtmfOVGsSSGZ4JOLaBbvstM06YKGXJNGkXFE/sYLrRElrgkV1BpZTilImQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWLQzo1N/tH0SSsZsKSGUr+Uxjdgxuhg256tXzJb85yCjueoga
	VAKX6UggtqUE8mmfxiFUK3GSecglkt5mxW5T6zYdCDQtKnKR7yiIk3Fe33clw50FfHqQQHW4kSJ
	YnbfLmwUnG4pdXpseYvLNOmg9sw==
X-Google-Smtp-Source: AGHT+IFQ2SAw0hDtIESI7vzaJhyvigjRCvznAqejuU6pjHqqd0yH4zM3U3q9gTWkQMiKOQul0SPkED/N9CfT1F4sYA==
X-Received: from pjbeu7.prod.google.com ([2002:a17:90a:f947:b0:2ef:d283:5089])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:6ce:b0:311:b5ac:6f6b with SMTP id 98e67ed59e1d1-31cc253d5c7mr21696038a91.9.1753162396140;
 Mon, 21 Jul 2025 22:33:16 -0700 (PDT)
Date: Mon, 21 Jul 2025 22:33:14 -0700
In-Reply-To: <aHnghFAH5N7eiCXo@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com> <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
 <aHb/ETOMSQRm1bMO@yzhao56-desk> <diqzfrevhmzw.fsf@ackerleytng-ctop.c.googlers.com>
 <aHnghFAH5N7eiCXo@yzhao56-desk.sh.intel.com>
Message-ID: <diqz8qkg6b8l.fsf@ackerleytng-ctop.c.googlers.com>
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

> On Wed, Jul 16, 2025 at 01:57:55PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>> 
>> > On Thu, Jun 05, 2025 at 03:35:50PM -0700, Ackerley Tng wrote:
>> >> Yan Zhao <yan.y.zhao@intel.com> writes:
>> >> 
>> >> > On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
>> >> >> Hi Yan,
>> >> >> 
>> >> >> While working on the 1G (aka HugeTLB) page support for guest_memfd
>> >> >> series [1], we took into account conversion failures too. The steps are
>> >> >> in kvm_gmem_convert_range(). (It might be easier to pull the entire
>> >> >> series from GitHub [2] because the steps for conversion changed in two
>> >> >> separate patches.)
>> >> > ...
>> >> >> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
>> >> >
>> >> > Hi Ackerley,
>> >> > Thanks for providing this branch.
>> >> 
>> >> Here's the WIP branch [1], which I initially wasn't intending to make
>> >> super public since it's not even RFC standard yet and I didn't want to
>> >> add to the many guest_memfd in-flight series, but since you referred to
>> >> it, [2] is a v2 of the WIP branch :)
>> >> 
>> >> [1] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept
>> >> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
>> > Hi Ackerley,
>> >
>> > I'm working on preparing TDX huge page v2 based on [2] from you. The current
>> > decision is that the code base of TDX huge page v2 needs to include DPAMT
>> > and VM shutdown optimization as well.
>> >
>> > So, we think kvm-x86/next is a good candidate for us.
>> > (It is in repo https://github.com/kvm-x86/linux.git
>> >  commit 87198fb0208a (tag: kvm-x86-next-2025.07.15, kvm-x86/next) Merge branch 'vmx',
>> >  which already includes code for VM shutdown optimization).
>> > I still need to port DPAMT + gmem 1G + TDX huge page v2 on top it.
>> >
>> > Therefore, I'm wondering if the rebase of [2] onto kvm-x86/next can be done
>> > from your side. A straightforward rebase is sufficient, with no need for
>> > any code modification. And it's better to be completed by the end of next
>> > week.
>> >
>> > We thought it might be easier for you to do that (but depending on your
>> > bandwidth), allowing me to work on the DPAMT part for TDX huge page v2 in
>> > parallel.
>> >
>> 
>> I'm a little tied up with some internal work, is it okay if, for the
> No problem.
>
>> next RFC, you base the changes that you need to make for TDX huge page
>> v2 and DPAMT on the base of [2]?
>
>> That will save both of us the rebasing. [2] was also based on (some
>> other version of) kvm/next.
>> 
>> I think it's okay since the main goal is to show that it works. I'll
>> let you know when I can get to a guest_memfd_HugeTLB v3 (and all the
>> other patches that go into [2]).
> Hmm, the upstream practice is to post code based on latest version, and
> there're lots TDX relates fixes in latest kvm-x86/next.
>

Yup I understand.

For guest_memfd//HugeTLB I'm still waiting for guest_memfd//mmap
(managed by Fuad) to settle, and there are plenty of comments for the
guest_memfd//conversion component to iron out still, so the full update
to v3 will take longer than I think you want to wait.

I'd say for RFCs it's okay to post patch series based on some snapshot,
since there are so many series in flight?

To unblock you, if posting based on a snapshot is really not okay, here
are some other options I can think of:

a. Use [2] and posting a link to a WIP tree, similar to how [2] was
   done
b. Use some placeholder patches, assuming some interfaces to
   guest_memfd//HugeTLB, like how the first few patches in this series
   assumes some interfaces of guest_memfd with THP support, and post a
   series based on assumed interfaces

Please let me know if one of those options allow you to proceed, thanks!

>> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
>> 
>> > However, if it's difficult for you, please feel free to let us know.
>> >
>> > Thanks
>> > Yan

