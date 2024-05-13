Return-Path: <kvm+bounces-17339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 903FF8C45B9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44C132829D7
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27341CF92;
	Mon, 13 May 2024 17:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nwg3FU0Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8721CAAF
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715620202; cv=none; b=pFMUJKM3f4+NgguDHLoersvfIajQY+TED4fWPlJokyT+xZeUWR0yTfQ2lz+WSWjAjCDZEfjqvwXSi00RTlZMJwo9x1+x6Hue+J28Fmvfeq1pWZFoSZxfdgiE+iBLlhWb4MEF1NxE9XUX07Lqx0H+cHr6n/OjNE5Gc2Fu5+14OSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715620202; c=relaxed/simple;
	bh=vntz1T6lSeN+0vUm9L7SvFCiGb+zPgUS4AJcZyT09Eg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MMWd8JnbXGRlijzaHDSqyNKY6viT1Kr+Hh44aPlCEy7DOMeDRHIH7Qvn/msEQBKwiIpE8QE8aYHNKcleSBxt8U07bssP//jb/Yh1DzFRsWLihjyNX0tKM31jbw8VhR0tdpv4agkUZDFnvWj8z+SjVdyQ2sw5jz81J+OyAKNlnqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nwg3FU0Y; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ec6de5fff5so47068585ad.2
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 10:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715620201; x=1716225001; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eqAMYyJARP70lQweb95UizBZYpowafIc/1BTiL7HAHE=;
        b=nwg3FU0YvFzGYEctJD2ZOknC0UhBAScrvlanq/fgb8Ig8UlwfYAKbfbiWRF1/lAuRY
         gZHLwLT+1mm4jUuKr6T0PGAbDSDU9bNbwMwxJPI1dd/25neOBwxvclQsjPs60DUo8R3w
         3HyH/EbPBxbIGQUrUY7V/d9Iw0RtHCmue8wFdqf+j2YZ8Xd2gWO4u95ZxBj3TrDC8PhU
         ZNP9TBmphqoSJhFcaiLQe9XsVNcE/MitimOx/WaqiguChcfXDVMSBkGNrGonGbvDulvn
         G4BLqOLBd5b4WaufNq93hs4RaxjZNaloUPlosvUFoc7Gkk1cY+P12m+8eueyS2ChodU2
         nGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715620201; x=1716225001;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eqAMYyJARP70lQweb95UizBZYpowafIc/1BTiL7HAHE=;
        b=iYBzX1QbclPA1xojlwSzHW0QUEO+cdNzWEpAxXZeUCGHxCiBeTxf1RM5vkS9PD20DV
         J26W7orrl31ys+zABAlBo2sY6qX58IR5q7P38mGh4OdDE+3EVDgDRIvq5wXX28ahvjjM
         Hyf028Ni72wBb+qj77dL0R/Zx7piXRmoSy9yvEwtqMa6JWOnYQB5ISmqtF8KnYX4A+k+
         O5HWv/HFeMU5233kuHIrATncUxm34vNy5HwB83bckl7bMrs1cCXk+81n6wNGya2JzKyg
         cpYMS3QDRJorAfqF2hEGpW5CqxqMU0jZhpoNjYdJbhOuN9SGA51frLbaZys6J1SQ2OyE
         yPSA==
X-Forwarded-Encrypted: i=1; AJvYcCVkZ809/3pTn+QDQkBK8S3vyX9uEP7x/FprFdDEKFS/YdRg0ifsVj+cYH7soHdJOSB5mYPy2srAVHinQk2E0eU9mSG5
X-Gm-Message-State: AOJu0YzO4FZJ+nMiexEXaRagL/sg3ZCzocmN/LqHZWzn5iMNZelNSZMf
	y4q8m0/egAdC1cwhqSuPMZ6NnUrVVy2lh3iXyZh0tBniuatO47jCh3RtFezt+xiHgR064y7rO9X
	tbw==
X-Google-Smtp-Source: AGHT+IFe9bUcF2cKcIAR1X9HznQBXdRthmRbSGERQIgzvsrvwXGdt51Pjnpg13XPQnNPLlENosr3rjbDm/4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e752:b0:1e5:62:7aa6 with SMTP id
 d9443c01a7336-1ef43c0fe5emr540015ad.2.1715620200915; Mon, 13 May 2024
 10:10:00 -0700 (PDT)
Date: Mon, 13 May 2024 10:09:59 -0700
In-Reply-To: <aaf684b5eb3a3fe9cfbb6205c16f0973c6f8bb07.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <ZeudRmZz7M6fWPVM@google.com> <ZexEkGkNe_7UY7w6@kernel.org>
 <58f39f23-0314-4e34-a8c7-30c3a1ae4777@amazon.co.uk> <ZkI0SCMARCB9bAfc@google.com>
 <aaf684b5eb3a3fe9cfbb6205c16f0973c6f8bb07.camel@amazon.com>
Message-ID: <ZkJFIpEHIQvfuzx1@google.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
From: Sean Christopherson <seanjc@google.com>
To: James Gowans <jgowans@amazon.com>
Cc: Patrick Roy <roypat@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Nikita Kalyazin <kalyazin@amazon.co.uk>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"somlo@cmu.edu" <somlo@cmu.edu>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Alexander Graf <graf@amazon.de>, Derek Manwaring <derekmn@amazon.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "lstoakes@gmail.com" <lstoakes@gmail.com>, 
	"mst@redhat.com" <mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024, James Gowans wrote:
> On Mon, 2024-05-13 at 08:39 -0700, Sean Christopherson wrote:
> > > Sean, you mentioned that you envision guest_memfd also supporting non=
-CoCo VMs.
> > > Do you have some thoughts about how to make the above cases work in t=
he
> > > guest_memfd context?
> >=20
> > Yes.=C2=A0 The hand-wavy plan is to allow selectively mmap()ing guest_m=
emfd().=C2=A0 There
> > is a long thread[*] discussing how exactly we want to do that.=C2=A0 Th=
e TL;DR is that
> > the basic functionality is also straightforward; the bulk of the discus=
sion is
> > around gup(), reclaim, page migration, etc.
>=20
> I still need to read this long thread, but just a thought on the word
> "restricted" here: for MMIO the instruction can be anywhere and
> similarly the load/store MMIO data can be anywhere. Does this mean that
> for running unmodified non-CoCo VMs with guest_memfd backend that we'll
> always need to have the whole of guest memory mmapped?

Not necessarily, e.g. KVM could re-establish the direct map or mremap() on-=
demand.
There are variation on that, e.g. if ASI[*] were to ever make it's way upst=
ream,
which is a huge if, then we could have guest_memfd mapped into a KVM-only C=
R3.

> I guess the idea is that this use case will still be subject to the
> normal restriction rules, but for a non-CoCo non-pKVM VM there will be=20
> no restriction in practice, and userspace will need to mmap everything
> always?
>=20
> It really seems yucky to need to have all of guest RAM mmapped all the
> time just for MMIO to work... But I suppose there is no way around that
> for Intel x86.

It's not just MMIO.  Nested virtualization, and more specifically shadowing=
 nested
TDP, is also problematic (probably more so than MMIO).  And there are more =
cases,
i.e. we'll need a generic solution for this.  As above, there are a variety=
 of
options, it's largely just a matter of doing the work.  I'm not saying it's=
 a
trivial amount of work/effort, but it's far from an unsolvable problem.

