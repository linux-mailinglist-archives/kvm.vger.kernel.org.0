Return-Path: <kvm+bounces-10847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 853FA87135B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1698FB24F27
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB2018041;
	Tue,  5 Mar 2024 02:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9WeJ8Hq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33C718036
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 02:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709604547; cv=none; b=GsAwDKwpFlrILuqWNm/8wfN0lJoaIwPSovOM2z/YXQhoSrmN28lsIG2qpPPNNacT6ZB3e7qC1bWDTfkxRZaXBqDGKPqR+MR2AIdKv81p3ZjL0isrsH84DiUh23eUDaQCIofnHyd4Fi1UiJtHGyeWCI8DL5FgMg3MqWMFZLWA+Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709604547; c=relaxed/simple;
	bh=Gb/s+EbPr52ZFvc8KNwg6PBWDcyap/fx9BaAcLDTpTY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=YtZXrNpSZIi+qT0XmyY8Y3I3d/5oEoDpIBwxx5ppBq+Vcm7/DObiq/fkCg0N5vjmoNaTR2F5e9EAplgvdRmmMqDgDDKo6rHuYXMTLvvbmug7yPUW/n1A8Aa16JoWgsNPDbI06ConSNdRRr1kXqzA8dkKvrnHNVIWzZknGxfIv/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9WeJ8Hq; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dd10a37d68so14554655ad.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 18:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709604545; x=1710209345; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gb/s+EbPr52ZFvc8KNwg6PBWDcyap/fx9BaAcLDTpTY=;
        b=a9WeJ8HqNGbU5Ui0gyOuVRrixXYt117ZOCdJnRg8Xly1mg9Semd/vbTYQM3i6vRCt5
         lEEP40Uiq4cC92A9xN2RzRHQ3nxweCenPD/zGHTh300rbjUxrS+X/tPXKhlPKMguqp9e
         HIBOll+fGtcJ+dS6QKinqFh2001VZBvZaT5gJmzQoEZy6eabK76oAYrZCgAkFp0ig/Ug
         fPvXatU7KQtgeU6chXJvLylpt73SeNVqLEH0N9iVEdpm/5gOP5p4IfrMR/qA9dyDe0LV
         2cuwkmksg7WN8CHo8s9kzpVGeQnbniOMvw2Jmhr91nGcBBrZtDOf34cjZnzSUJMfOVNW
         /dNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709604545; x=1710209345;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gb/s+EbPr52ZFvc8KNwg6PBWDcyap/fx9BaAcLDTpTY=;
        b=G22elkzwpcpSKdDn/satwZECbocdKpQGiBGhWLFmpBh8fcdFdXIMsZ+yDTSEoJz4HH
         DMyNXPULGd38PYxLIYyhdLu24IxKtTYNDHQ7OVRUJHuVzJmcZ3NTIVnzR1PuBIVCazOq
         suMpkm90q39p7EnxksJKA9QQdxhyh2l6J5vpBj0yMqOky619kT1b4NLpdvmN4OMVJTM0
         fO8F3+AT9aWd49Q2buFA//Z8siswySwy2Bn7M4bOpydM03SNOkNQxgq8U4P7btWFb3EA
         5+p0EP19veOa3/tdfogVeoJGkrwPp1gWC7SUe3KrrUfP0k4YYre0wsantREpaosqeyym
         V37w==
X-Forwarded-Encrypted: i=1; AJvYcCUPBw6+lKyXtEuoan94amGrAJMNWoVfa30qUNSleFSO644BVsSuMOE2qcf45YZmzlxkBNPanhnES57psgdqadYJJG9t
X-Gm-Message-State: AOJu0YwgcTwe1BJW0PTN8g/Q8gh4qBJXuT1tFOWOcQyjOX1WtbFvnZJ7
	qEvhglHAoVzaR7pN8OBNjjW7qkiiAGBShTjgEucnqe1CBMhuCGBH
X-Google-Smtp-Source: AGHT+IHTIQNIkLXInj+5GmudtJWsuuyfm9Ahv96PQZFdTUkLMLlqcwSGFsIPfxt0y8vWKbogHL4PuA==
X-Received: by 2002:a17:90b:282:b0:29b:1f71:957c with SMTP id az2-20020a17090b028200b0029b1f71957cmr8333068pjb.14.1709604544979;
        Mon, 04 Mar 2024 18:09:04 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id mf12-20020a17090b184c00b002904cba0ffbsm10666321pjb.32.2024.03.04.18.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:09:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:08:58 +1000
Message-Id: <CZLG8AT5RBK6.3G95C3Q1URS9V@wheely>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>, "Joel
 Stanley" <joel@jms.id.au>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 03/32] powerpc: Fix stack backtrace
 termination
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-4-npiggin@gmail.com>
 <94491aab-b252-4590-b2a7-7a581297606f@redhat.com>
 <f659964b-da95-4339-9d4f-c7b6a72fbac0@redhat.com>
In-Reply-To: <f659964b-da95-4339-9d4f-c7b6a72fbac0@redhat.com>

On Fri Mar 1, 2024 at 7:45 PM AEST, Thomas Huth wrote:
> On 27/02/2024 09.50, Thomas Huth wrote:
> > On 26/02/2024 11.11, Nicholas Piggin wrote:
> >> The backtrace handler terminates when it sees a NULL caller address,
> >> but the powerpc stack setup does not keep such a NULL caller frame
> >> at the start of the stack.
> >>
> >> This happens to work on pseries because the memory at 0 is mapped and
> >> it contains 0 at the location of the return address pointer if it
> >> were a stack frame. But this is fragile, and does not work with powern=
v
> >> where address 0 contains firmware instructions.
> >>
> >> Use the existing dummy frame on stack as the NULL caller, and create a
> >> new frame on stack for the entry code.
> >>
> >> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> >> ---
> >> =C2=A0 powerpc/cstart64.S | 12 ++++++++++--
> >> =C2=A0 1 file changed, 10 insertions(+), 2 deletions(-)
> >=20
> > Thanks for tackling this! ... however, not doing powerpc work since yea=
rs=20
> > anymore, I have some ignorant questions below...
> >=20
> >> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> >> index e18ae9a22..14ab0c6c8 100644
> >> --- a/powerpc/cstart64.S
> >> +++ b/powerpc/cstart64.S
> >> @@ -46,8 +46,16 @@ start:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add=C2=A0=C2=A0=C2=A0 r1, r1, r31
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add=C2=A0=C2=A0=C2=A0 r2, r2, r31
> >> +=C2=A0=C2=A0=C2=A0 /* Zero backpointers in initial stack frame so bac=
ktrace() stops */
> >> +=C2=A0=C2=A0=C2=A0 li=C2=A0=C2=A0=C2=A0 r0,0
> >> +=C2=A0=C2=A0=C2=A0 std=C2=A0=C2=A0=C2=A0 r0,0(r1)
> >=20
> > 0(r1) is the back chain pointer ...
> >=20
> >> +=C2=A0=C2=A0=C2=A0 std=C2=A0=C2=A0=C2=A0 r0,16(r1)
> >=20
> > ... but what is 16(r1) ? I suppose that should be the "LR save word" ? =
But=20
> > isn't that at 8(r1) instead?? (not sure whether I'm looking at the righ=
t ELF=20
> > abi spec right now...)
>
> Ok, I was looking at the wrong ELF spec, indeed (it was an ancient 32-bit=
=20
> spec, not the 64-bit ABI). Sorry for the confusion. Having a proper #defi=
ne=20
> or a comment for the 16 here would still be helpful, though.

Thanks for the deailed reviews as always. I've been a little busy with
QEMU so may not get another series out for a bit. I'll probably wait for
Andrew's stack backtrace changes to land too before resend.

But, yes a comment makes sense. I'll add.

Thanks,
Nick

