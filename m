Return-Path: <kvm+bounces-8520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 240B3850B5E
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 21:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD2E02828F5
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 20:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE1B5E3D8;
	Sun, 11 Feb 2024 20:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBexHuTI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4583DBBB
	for <kvm@vger.kernel.org>; Sun, 11 Feb 2024 20:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707682354; cv=none; b=EGuBXaKj7c0NNJ6TQw9E4choRmE7/nCoe1pZo3q+G81ZRDvMdrk/pSaeAnTOP5Js0MXOMTf5jSSdc6Hbbgujryh4mToiiTu0GgTmeirLDLfim074IIhOdAxd73CrPEjP9XJ7vxfxjI85q+z12UI9FkskvPc30cASh2y8xyTMC60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707682354; c=relaxed/simple;
	bh=YYwPh8j53W7qUnrBVOP5NKtGe7v63JZ0Yw4CbC2lklk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tz2437+PJoxF/reTrp0ze0xSwr6RnMDh+ONyYS+2ArV7ygvYgiXYQOhOsIqjxHXV07O4h+qzhUJI2mXt4lIiJ+eYuYsiOWpuYX6Enuiuk+ddSa1GOZe9Hw1ZRL0rWofPpMEstazjHB0JreVfjEt7Sdwlj9/cxBc2jViKXypBbP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBexHuTI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707682351;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=tVk8cPuhz061cwPkhFCtcFN9DX+JLnuTuyQ18930v7c=;
	b=bBexHuTIoAaPEcjwulWcgC9g9Z4g9w2CMB8yqcFGgGLZYo/vqFE1MRV7Em6HbLyWDyhHEV
	hhGOjVcvbQUZz5N7n2wk6k2Qg3s4otal6p+Nr222lzN+HDpIQX8FMFsZoKXLaIm28T9nSs
	R7uebEUJFDuTRTC0JXI8lSLYbqV4sw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-ysM-Lo5kOC66J4IFroP-MQ-1; Sun, 11 Feb 2024 15:12:27 -0500
X-MC-Unique: ysM-Lo5kOC66J4IFroP-MQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FB4E83B826;
	Sun, 11 Feb 2024 20:12:27 +0000 (UTC)
Received: from tucnak.zalov.cz (unknown [10.39.192.8])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB8E440C9444;
	Sun, 11 Feb 2024 20:12:26 +0000 (UTC)
Received: from tucnak.zalov.cz (localhost [127.0.0.1])
	by tucnak.zalov.cz (8.17.1/8.17.1) with ESMTPS id 41BKCN1r4049961
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 11 Feb 2024 21:12:23 +0100
Received: (from jakub@localhost)
	by tucnak.zalov.cz (8.17.1/8.17.1/Submit) id 41BKCKpr4049960;
	Sun, 11 Feb 2024 21:12:20 +0100
Date: Sun, 11 Feb 2024 21:12:20 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on
 gcc-11 (and earlier)
Message-ID: <ZckqI3Sg5pKXLzE7@tucnak>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20240208220604.140859-1-seanjc@google.com>
 <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com>
 <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
 <CAHk-=wiKq0bNqGDsh2dmYOeKub9dm8HaMHEJj-0XDvG-9m4JQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiKq0bNqGDsh2dmYOeKub9dm8HaMHEJj-0XDvG-9m4JQQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Sun, Feb 11, 2024 at 11:59:49AM -0800, Linus Torvalds wrote:
> On Sun, 11 Feb 2024 at 03:12, Uros Bizjak <ubizjak@gmail.com> wrote:
> >
> > I'd suggest the original poster to file a bug report in the GCC
> > bugzilla. This way, the bug can be properly analysed and eventually
> > fixed. The detailed instructions are available at
> > https://gcc.gnu.org/bugs/
> 
> Yes, please. Sean?
> 
> In order to *not* confuse it with the "asm goto with output doesn't
> imply volatile" bugs, could you make a bug report that talks purely
> about the code generation issue that happens even with a manually
> added volatile (your third code sequence in your original email)?

Preferably for all the different cases where you suspect a compiler bug.
At minimum preprocessed source + compiler options + detailed description
where do you think the bug is (or small runtime testcase but that is
harder for issues derived from the kernel obviously).
GCC 11 is still supported upstream, so bugs reproduceable even with just
that should be filed in gcc.gnu.org/bugzilla/, if something is only
reproduceable with older compilers, guess it belongs in some distribution's
bugtrackers if those still support those compilers.
Once filed we can bisect, analyze them, fix.
ICE bugs are even easier to file, all we need is preprocessed source,
command line options and gcc version/architecture.  gcc -freport-bug
in most cases should be able to create everything in one file for the
bugreport.

As for the workarounds in the kernel, I'd also like to see only workarounds
for specific compiler versions (once filed, bisected and analyzed,
workaround could be either based on affected compiler versions, or
kernel could try to check for the compiler bug in question and only add
workaround if that bug reproduces on a short testcase.  Sure, this would
be easier in autoconf style checks, but could be done even in kernel's
makefiles.

	Jakub


