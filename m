Return-Path: <kvm+bounces-17271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F53C8C3579
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 10:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 915481C209C2
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 08:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C861C697;
	Sun, 12 May 2024 08:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfvCRwIm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E4E1C68C
	for <kvm@vger.kernel.org>; Sun, 12 May 2024 08:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715501845; cv=none; b=Am4CGmUnFRvFG6Ej/TUann9H51Rnozxy1ZrDg0LDUx/Z7NArqR0IKNakj/0axtj0ZsgcLgzYsJSF5JHGia2rA96R29YMCM4d9U93r388XEE0ZtX/73yyaTVohp44h10IlQHkFt5qZJ4Lc1QI3oUiZp7CGCMJkRVf7hjvHe3T09Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715501845; c=relaxed/simple;
	bh=gy1fqqrNliFvIEA/4j3QrSKFmukTGVMtOxoq+znsGwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bGzAOk8C+MF0WIDPd9QXbddfBXqvzsFWtv6FZsIe303sZtq/Dc5rPu9yMakJwsK/I9hjhReo0PwKVOtQGOJO9mPZicUCwvC2xuxNerX5NtnlAVJt6UrwvhZle5zPC7xu+8YEBZG7JJEw4GUHRADvx7hPCxlaEgd5e3vQStkrgDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfvCRwIm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715501843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QUSDVa+t4AWwqTmRuepudvFoykXU2aaVqb2V4N5FOvo=;
	b=dfvCRwImAQgTq4WNl0vgteq+U3DRSHPK9CJg2tlWvdmyX5aBEQmeRDz7dcUgr0W9N5ev5S
	vGNe01x8e2F6sK+ULuqN/PAyV3Ig9X8hAmWXVXfllh40iEcBpnXyeUwVdfPF9l6q+T4gwW
	5LU4Dap6+YvTNgxmFyEYofsZvLoqPF4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-oPIIM7hKPCyADqlz5aPKzQ-1; Sun, 12 May 2024 04:17:20 -0400
X-MC-Unique: oPIIM7hKPCyADqlz5aPKzQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-34eb54c888cso2692272f8f.3
        for <kvm@vger.kernel.org>; Sun, 12 May 2024 01:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715501839; x=1716106639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QUSDVa+t4AWwqTmRuepudvFoykXU2aaVqb2V4N5FOvo=;
        b=tpk00jfUxMRNJVlVqdeuKTYPfuwgnN0SDsaqmEGBQk3gmWxXINh+n1X5zxhD7wUcW9
         zBilz+x0CDht+hCWvnqIW5+trSaRQTrb+I2Unzvuvg+p1t11ixY+lJm1oGUs40UBN2hT
         33drCjw+yIl7jwlkIp4OnYSVLZknjg1Bqq/LfilPcNG9stIf/n1ibYPWszr4g4AuxbER
         h86qXrMicd5R+ZEdepn14r+5uo4/PYvCOnGjWc4rFFb7bE0blJoICFIyPGwhNzNYmSJ4
         efU4bcfPsyAxL/7GnFnBsDZRA3QpeRERKTu065Bp8cIdS6dYyUXUmtwv1WuotrfhUuKP
         N5FQ==
X-Gm-Message-State: AOJu0Yy4cE6pmMQcfMlYzBtaN9/pwpvJaAu8LAmTcAZ50tyfTvbiNW2G
	xuf0Q7ctVqqpu/kyHiQvpK/xSuXWmjqW82tTRlxPF9IfWYRGb4s6oT+nByFTxFibm1+Z4UtcCj2
	bSXyt08rDbDZ2O4D8bZeHHNrbzzsCn1Fp/w02999in84GuVKhD1Kyd5osJSc8VMLjRnRf6f+GNO
	ix/QkCNdoJoBZXoam0NdJpq5BZ
X-Received: by 2002:a05:6000:a88:b0:34c:e62a:db70 with SMTP id ffacd0b85a97d-3504aa63447mr6802434f8f.67.1715501839247;
        Sun, 12 May 2024 01:17:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKCS7P8m0E2FzwUMTNi7Ql+HIEI6NbkihSJrrDNgDeVBjsAxZChtVoPCY2m8yJvJpjjb/lbmUnz6gptq1HRKA=
X-Received: by 2002:a05:6000:a88:b0:34c:e62a:db70 with SMTP id
 ffacd0b85a97d-3504aa63447mr6802413f8f.67.1715501838935; Sun, 12 May 2024
 01:17:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240510211024.556136-1-michael.roth@amd.com> <CABgObfZxeqfNB4tETpH4PqPTnTi0C4pGmCST73a5cTdRWLO9Yw@mail.gmail.com>
In-Reply-To: <CABgObfZxeqfNB4tETpH4PqPTnTi0C4pGmCST73a5cTdRWLO9Yw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 12 May 2024 10:17:06 +0200
Message-ID: <CABgObfZ=FcDdX=2kT-JZTq=5aYeEAkRQaS4A8Wew44ytQPCS7Q@mail.gmail.com>
Subject: Re: [PULL 00/19] KVM: Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, linux-coco@lists.linux.dev, jroedel@suse.de, 
	thomas.lendacky@amd.com, vkuznets@redhat.com, pgonda@google.com, 
	rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, 
	alpergun@google.com, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 12, 2024 at 9:14=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Fri, May 10, 2024 at 11:17=E2=80=AFPM Michael Roth <michael.roth@amd.c=
om> wrote:
> >
> > Hi Paolo,
> >
> > This pull request contains v15 of the KVM SNP support patchset[1] along
> > with fixes and feedback from you and Sean regarding PSC request process=
ing,
> > fast_page_fault() handling for SNP/TDX, and avoiding uncessary
> > PSMASH/zapping for KVM_EXIT_MEMORY_FAULT events. It's also been rebased
> > on top of kvm/queue (commit 1451476151e0), and re-tested with/without
> > 2MB gmem pages enabled.
>
> Pulled into kvm-coco-queue, thanks (and sorry for the sev_complete_psc
> mess up - it seemed too good to be true that the PSC changes were all
> fine...).

... and there was a missing signoff in "KVM: SVM: Add module parameter
to enable SEV-SNP" so I ended up not using the pull request. But it
was still good to have it because it made it simpler to double check
what you tested vs. what I applied.

Also I have already received the full set of pull requests for
submaintainers, so I put it in kvm/next.  It's not impossible that it
ends up in the 6.10 merge window, so I might as well give it a week or
two in linux-next.

Paolo


Paolo


