Return-Path: <kvm+bounces-7186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0CC83E0F1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A51B4B22461
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1141B2033A;
	Fri, 26 Jan 2024 17:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i2pjUe+D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B96A208B2
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706291866; cv=none; b=f2rW7b8Shyyk1IR/Evyr8O0wQOgYPgUBLlBAILpV9NGmqLWkPmUi83KYph6fIqxLVtq2wrNJolKObUpOlnFBBpEURB3AtndK/izEjB/n0gkqODZuiAhDdklZwXyfqhdAc71ECRRgR7YtF0ezrXe0RsQhw1/5XEapV5y7cdIV8vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706291866; c=relaxed/simple;
	bh=Q7oZu/1YHI4BPg81Y1ep2zij9N2PEYAo66F5LlRnWfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q4hnEDtsrH6CvNpQPitQJof5/CwagaewjZgrNLwAlfKGIY/kxRPqdtdrgiQlY5I3K016WEt++JBnrmynOHfHMGeiBWWiZSHKaOTQzYJpPJVHMZTHiQfu5pt6hBW+yN9zLx6TEjqaZl9XpX13qrRXsnLX+rKXVkgtnWKrauPCsvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i2pjUe+D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706291862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zdliqqq6y8vi1zExRryLtToJDjJljYRysBrFuRmBXOE=;
	b=i2pjUe+D6v4ZotlXzZTx8cOix6ZOcUKNKFeBLTTSS08RU8edVChbcPvR14DY+qvdiKZmIj
	LE1de5naPAcHdauSoq7sljQ0ammzA5QJwVAOYppJ4exC209FXggOcCKBKXuf2wSZZ+TC7S
	XDiDmhwbE3KmQqWEUBFPO6qxvcMSNUA=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-3_vlBUzgO6GnYfwQnFtNMg-1; Fri, 26 Jan 2024 12:57:40 -0500
X-MC-Unique: 3_vlBUzgO6GnYfwQnFtNMg-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-46b15d4c6bcso147814137.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 09:57:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706291860; x=1706896660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdliqqq6y8vi1zExRryLtToJDjJljYRysBrFuRmBXOE=;
        b=OdFtBUry9+HPlMy+59BJ/hsmxnCwCMEd/C4EXDav9aeQaK87i9Tu1SytUoUXkgq5RC
         L6u1J2tR18QVQ2sY8FG56yO9dn/CZxin0LUXYAVqWxAeQ60EnHqxlLLMDGDhI+WKBDXm
         0Wk/QfZ7FMlShU97QGbnFOSEa9YWuOZbQd/fmgHA6Iu71HTx5OlM64MTv8qydunkv1LL
         frOeZP4Tq4dwzRqohxLZmJM4k4J7sNhZ7c87AwNh9+6+srlLbQTPDp/GxexAFbtcUKDe
         kpVeq2u4B9D9jxO35zcAaGbNhk4n+EXD/5DLWB3tV3bPXe7g6HalPYnlAiOk/cIOK8ke
         iqSA==
X-Gm-Message-State: AOJu0YzEfnO3pZOjYEaG3yL2wHnqqzx/2wh2Qem3v49wsZR+DPRC6tnb
	J4OcSRBKAUwCiwF9fG3UCbcZkU19H25ehvxUB0sUqo45EZUl3/b02U08oW3cbqljYY2B9Xnwfy2
	wBEVAaMhBrsuV4o71j98JlQBsQZjeO66cm6VzaarLt/4tpnEpu/yxT/XFajhuy48JBBqEFz/Zpz
	YcF0nk8UHJMI1sRDG9ijnQl9TC
X-Received: by 2002:a67:ed8e:0:b0:469:a7f6:7e14 with SMTP id d14-20020a67ed8e000000b00469a7f67e14mr105512vsp.24.1706291860323;
        Fri, 26 Jan 2024 09:57:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4U69LLHM9eQG2kEV3etn1B4gahOwPpnU+IMnWvmuFC5o+U20i9fIcxh4YhMQSs8aBMR8LXo3uuszuWRJ15Xo=
X-Received: by 2002:a67:ed8e:0:b0:469:a7f6:7e14 with SMTP id
 d14-20020a67ed8e000000b00469a7f67e14mr105504vsp.24.1706291860078; Fri, 26 Jan
 2024 09:57:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122162445.107260-1-frankja@linux.ibm.com>
In-Reply-To: <20240122162445.107260-1-frankja@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jan 2024 18:57:28 +0100
Message-ID: <CABgObfZjJ5sADB0+aq4LTtKsmV0fBKCi-umOqQppC0=mgUMegw@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] KVM: s390: Fixes for 6.8
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com, 
	cohuck@redhat.com, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 5:25=E2=80=AFPM Janosch Frank <frankja@linux.ibm.co=
m> wrote:
>
> Paolo,
>
> please pull the fixes for the following two problems:
>  - The PQAP instruction did not set the CC in all occasions
>  - We observed crashes with nested guests because a pointer to struct
>    kvm was accessed before being valid (resulting in NULL pointers).
>
> You'll see that the fixes are still based on 6.7-rc4 since they've
> lived on our master for quite a while. But I've re-based them on
> Linus' master and your queue and next branches without an issue.
>
> The following changes since commit 4cdf351d3630a640ab6a05721ef055b9df6227=
7f:
>
>   KVM: SVM: Update EFER software model on CR0 trap for SEV-ES (2023-12-08=
 13:37:05 -0500)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-master-6.8-1
>
> for you to fetch changes up to 83303a4c776ce1032d88df59e811183479acea77:
>
>   KVM: s390: fix cc for successful PQAP (2024-01-08 18:05:44 +0100)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> pqap instruction missing cc fix
> vsie shadow creation race fix
> ----------------------------------------------------------------
>
> Christian Borntraeger (1):
>   KVM: s390: vsie: fix race during shadow creation
>
> Eric Farman (1):
>   KVM: s390: fix cc for successful PQAP
>
>  arch/s390/kvm/priv.c | 8 ++++++--
>  arch/s390/kvm/vsie.c | 1 -
>  arch/s390/mm/gmap.c  | 1 +
>  3 files changed, 7 insertions(+), 3 deletions(-)
>
> --
> 2.43.0
>


