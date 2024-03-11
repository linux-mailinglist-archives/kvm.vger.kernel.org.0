Return-Path: <kvm+bounces-11522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC14F877CBA
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:30:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E000F1C20F6B
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F8C18C01;
	Mon, 11 Mar 2024 09:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P4BNYJiv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6371F17578
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710149400; cv=none; b=QrTdMa6jQem+q+x+Mc+TfCaylEUoESbKc0w2DujH03rbq8xJWungtRnPXQoZlI7xpNVZ+6A9sYfPq+yrR9Hc04plysd4AjzebMHHPaSAk6gTMHV2/TfsYDT//KgFmcEgNvN5wmPRDfyOnfsUlo/MHHHxPkwLG6CBff85UwD+2SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710149400; c=relaxed/simple;
	bh=yYwZNAyl9eI8xnn6G8iPccTROZ3bREOUqaEgbZaMdn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F+Sjo8OMrnuvkF0fCep+Sk1raoaPB4hCJlONQ5xAq1ds+3KzNlf85v0RHe6+Ev4EypUvwRSXOaLddg8a3QAH2+N/OmTriMdNGf+Uhi3D3NUDacAE4T/I3Q6cPFi7y+v0Y5xthFx3U/cZUPtS9BwgJAa9uDbDmA1OlB8hGuCUCpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P4BNYJiv; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33e8e9a4edaso1702050f8f.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 02:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710149397; x=1710754197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYwZNAyl9eI8xnn6G8iPccTROZ3bREOUqaEgbZaMdn4=;
        b=P4BNYJivuG5PbNhdnW4aADF/w7+PswJsl2etROUMM7rooz/OYZhAM0MZJ9SnT/PtAb
         g0McASLyaP1EcEbfI7jnx8gdLfB1GFflZ1uKSw2j6MLe1TvI12a/CFBPD/7VFD+8dKRM
         kwRGns9hawuSko/MMuFU+oyXb88knf0W73gAlXqIUoEUvdCC9rO3HBUNw85nvJ3fOF3w
         MIKvsIJHSqAQMU5dUh6ha9/DONapOAbRiq72UjUg8iP4IKw5PVvnDceRbhIof0oLCU+b
         4fi9nZs2Bbkmza0LTdMyQdWWBM4rK6cy0bBd/NeKQ8rQL9ZgHXf0gXJybhYxUsP/iUpl
         oKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710149397; x=1710754197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yYwZNAyl9eI8xnn6G8iPccTROZ3bREOUqaEgbZaMdn4=;
        b=bp1kYX6Y5Lv3bZ1kBaKAtfaXWcf1NepLEx3XCdUfI9SrU4G4ptQpNAiybYl+oQ22lJ
         LjElePGCkp8X1DxjhRxLVt4nZRWWOiG+sc3d1N4ce0CKHhv0BKALuBAb+0wWbj1FenFe
         BHvRnZJ18jtQ3tV7goZ1FLSw+KjrMlIkvWPVDx7x5mHL7XMEDTfqNslRIRYRuWfujYXk
         J3filrP0IPTyN48xGp3t7AuMD+QBP514Jke7R0u5Mw/xYHIm8D4kDuEprA2SVOBf1Fah
         1JcmfqhGjI94DxSV+jGHo5M+TJEBJKJIJDv+iX/LVLF4+9QFp3+hRRtPSlRXIUOqPib9
         e20A==
X-Forwarded-Encrypted: i=1; AJvYcCX7CMdOhxMiFgoN/N/eTxjbfCMEv/SG0gbrZIs4F/Y+jQa61H5rnFa0oQRN4oKPvt0WJsdIOIZkS4POwlwlFnuXVFrP
X-Gm-Message-State: AOJu0YxDCYZCBXmAjv7RvOtJxXDK6H3XTe9B7WdCq0R6Q29G5G9eH5ov
	ZQq0wL4i5rOPWIA3naoCV9pSLTx5Hsf3IRF79MQBRsvTgTTFzh3aPKbNeBJZT8LACAmOWrWOrfC
	iQA+eAHXmzHlqMugwVr+uh4qTj7BkXy8cMNvj
X-Google-Smtp-Source: AGHT+IHSfs26GHVI09JkKNk9HoDRqOW4oeQ0rJHE/UNYx/wsSmfgrD7ev79myOziiYJpopiGSTSS0pKlBEG+6nVcKtI=
X-Received: by 2002:a5d:5188:0:b0:33d:e1d2:2694 with SMTP id
 k8-20020a5d5188000000b0033de1d22694mr3718979wrv.63.1710149396551; Mon, 11 Mar
 2024 02:29:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <335E21FA-7F1E-4540-8A70-01A63D8C72FA@amazon.com> <CA+EHjTxpBM6LyqGfE_y--Uy1oR4oP7Ozcp3mBwFvAijOZe0i+Q@mail.gmail.com>
In-Reply-To: <CA+EHjTxpBM6LyqGfE_y--Uy1oR4oP7Ozcp3mBwFvAijOZe0i+Q@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 11 Mar 2024 09:29:11 +0000
Message-ID: <CA+EHjTyqjTHN+b42THuppBwabbbPTE7+s3+4gzELN=SVddVtDg@mail.gmail.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: "Manwaring, Derek" <derekmn@amazon.com>
Cc: David Woodhouse <dwmw2@infradead.org>, David Matlack <dmatlack@google.com>, 
	Brendan Jackman <jackmanb@google.com>, "qperret@google.com" <qperret@google.com>, 
	"jason.cj.chen@intel.com" <jason.cj.chen@intel.com>, "Gowans, James" <jgowans@amazon.com>, 
	"seanjc@google.com" <seanjc@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Roy, Patrick" <roypat@amazon.co.uk>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2024 at 9:26=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> Hi,
>
> On Fri, Mar 8, 2024 at 9:05=E2=80=AFPM Manwaring, Derek <derekmn@amazon.c=
om> wrote:
> >
> > On 2024-03-08 at 10:46-0700, David Woodhouse wrote:
> > > On Fri, 2024-03-08 at 09:35 -0800, David Matlack wrote:
> > > > I think what James is looking for (and what we are also interested
> > > > in), is _eliminating_ the ability to access guest memory from the
> > > > direct map entirely. And in general, eliminate the ability to acces=
s
> > > > guest memory in as many ways as possible.
> > >
> > > Well, pKVM does that...
> >
> > Yes we've been looking at pKVM and it accomplishes a lot of what we're =
trying
> > to do. Our initial inclination is that we want to stick with VHE for th=
e lower
> > overhead. We also want flexibility across server parts, so we would nee=
d to
> > get pKVM working on Intel & AMD if we went this route.
> >
> > Certainly there are advantages of pKVM on the perf side like the in-pla=
ce
> > memory sharing rather than copying as well as on the security side by s=
imply
> > reducing the TCB. I'd be interested to hear others' thoughts on pKVM vs
> > memfd_secret or general ASI.
>
> The work we've done for pKVM is still an RFC [*], but there is nothing
> in it that limits it to nVHE (at least not intentionally). It should
> work with VHE and hVHE as well. On respinning the patch series [*], we
> plan on adding support for normal VMs to use guest_memfd() as well in
> arm64, mainly for testing, and to make it easier for others to base
> their work on it.

Just to clarify, I am referring specifically to the work we did in
porting guest_memfd() to pKVM/arm64. pKVM itself works only in nVHE
mode.
>
> Cheers,
> /fuad
>
> [*] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
> >
> > Derek
> >

