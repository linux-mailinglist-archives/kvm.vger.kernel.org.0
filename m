Return-Path: <kvm+bounces-8390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE83784EFB8
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 06:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75371288AD1
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 05:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FC65647F;
	Fri,  9 Feb 2024 05:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NlY+deG+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D16256B65;
	Fri,  9 Feb 2024 05:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707454930; cv=none; b=DZ+Tq2bd+Bl+KjbTPUIsb4wzgL47iNl9vikQY6BPIhEy64UgAXcSHZbh/Nhz2df1AnnXyRoY/g1nhRZq8Q88+j2rwAk3SL3eA8GF19CahLVjFygm4j83v6Np2dDTJQWYMuAadJu9aJ68DhTn4aXg58TK52VfckaL6kNR2VVFJfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707454930; c=relaxed/simple;
	bh=QHzDgfDMbhuy63JYBLnHTpA2kSqsUXdONURKUAyBw/Y=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=cQpGsi8CZxTKfhdT9/LE7CWIGUDPMea7UqL7ab/luZiHdjASmFpgzhGLx9k1MKbQcR4E36NfgSRKRQ4wdl7uH7/WB3A749agG45HGvWXmPtdWsLxO8SRCPbFgeJJKWK52xx8lvr98WlOc8IOSZ/c6eRzNw3nJ4A6iQc2TkNmRpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NlY+deG+; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5d8ddbac4fbso463755a12.0;
        Thu, 08 Feb 2024 21:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707454927; x=1708059727; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wqz7Y/TcTN7smUZ/N4fhNV46jTItRF0U++Hxc5pAtk=;
        b=NlY+deG+PRMkyWxfM1tmL1mvaYKwnRZfQb5GLs0HsS0nE141XBzeS/lNT7hKbQeT+/
         mZPocaOzOJPadLdAcyoWGp+nvJRFb4GrCwGJIQSnRzlNUeIY0bT4BTQzO13S7cw03mY3
         pGJwIamH8Vaucbnj+ldCoTYZGecItQst3q2Sduz7G1j2RlHE8maxgL2WUbo8Z8ruapbM
         JJfpeeMFnRAhxL4AkFzmuodPcx8vrSuqEVbvgTsL6oMPqQYLI8SYvkmkNVmgGjntFLHi
         lqa5ulXObyweqgnLHnYNg6puqajmO1RwcGSDrNs1P9QXA66QbgyIgKRNEC1c0HNwNY7a
         ipzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707454927; x=1708059727;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0wqz7Y/TcTN7smUZ/N4fhNV46jTItRF0U++Hxc5pAtk=;
        b=SvDAsIC/JYhoqorMbsoSFF+Sf7oo4lMa0L1HDepXU4inLIg7hc0euYdgOoOqEO9VFl
         0r6ZBevciBFs2mp+aXnoUagaydQMNiJ7Z9Nq2cCVfmZs6IqRKic+v8AQ6+58C+BLa7Qr
         EzgNpYnIGGdDQ/lN066yWMGcMLX5V0TH3U3hujY8383fquiBTXYDiH0iOvwPFKEbUHIG
         inevQMCKRSbU2C7uJwXlb9zOc04I3MHWCaEtBUydHN5AMiA5l819cZJDLqa60ntG8v2M
         nBs60GQi1r6mc90BoEwYCIP6SD+115uoNGDHzU/QvrXatktwNgYQwRQp3jWHuVWEKmgc
         tsIA==
X-Gm-Message-State: AOJu0Yx1ANarvrBLbNa+to3cSmVgJQc5kAaWsMQ6kP1STifrQZDmtiSO
	pO3ERCmy5jyeS3kTT2LaHjVet43Ks6wwmfIo1PzP9Fh6u1DGgJ0o
X-Google-Smtp-Source: AGHT+IEKRg+nU8BWUu6QYFnkof43Ezzita86bZjmYmWTU2CUj7lvOVVnWbVZiYrOWORfbM//Bd/KAg==
X-Received: by 2002:a17:90a:bf02:b0:296:fe8d:248b with SMTP id c2-20020a17090abf0200b00296fe8d248bmr460936pjs.4.1707454926617;
        Thu, 08 Feb 2024 21:02:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX1gF5gyLodB9BkGeJgen+1IIQ898R25d9CxVUmwkcouUztyRgoFsqK6P/mdgxB8x2pFV63YnmUNoLXFz2tkj7tHB7BvZmMZtYCvmDYODZMgL6nAqi89JPL5OaMfN5wM7G+P/WEybND0q6L4npV2znOQTSXmjEfIM3vzWJGupZpCgApmK4Zp8537Kqb71pvvVCTG4IRXg/Ead8zsQkmaEGQf9EjyTNySMaIRyfi1UrqBNkWWzvE9Mhh27Hmr9u1j4fsYKdHqpt4KVsAm1byPRjBNTsC8PB9+4mz3BIeaSJVBX7hsxQcI5cAI85egsiwkEykDe++XJtbcn2LYw+BzjhlXrdMumIdXRIoqGb97NvoBlhgTavF03Nb47HVUU08eovz6ZBIHWxmMFKsWAYJXTsTuAivdoz+c7ew7L3p2ykLTjmmfwbQzEcokGzQvK9bHlV2pddrFIOsFhaMzkqe//FxH4GakiPArNdISfUQb6O4BNCeNdQ=
Received: from localhost ([1.146.65.44])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090301c500b001d7610fdb7csm608163plh.226.2024.02.08.21.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Feb 2024 21:02:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Feb 2024 15:01:56 +1000
Message-Id: <CZ0A93T119VP.1LQ0MR1O0PYJE@wheely>
Subject: Re: [kvm-unit-tests PATCH v2 2/9] arch-run: Clean up temporary
 files properly
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>
X-Mailer: aerc 0.15.2
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-3-npiggin@gmail.com>
 <c9039fc4-9809-43d9-8a99-88da1446d67f@redhat.com>
In-Reply-To: <c9039fc4-9809-43d9-8a99-88da1446d67f@redhat.com>

On Wed Feb 7, 2024 at 5:58 PM AEST, Thomas Huth wrote:
> On 02/02/2024 07.57, Nicholas Piggin wrote:
> > Migration files weren't being removed when tests were interrupted.
> > This improves the situation.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   scripts/arch-run.bash | 12 +++++++-----
> >   1 file changed, 7 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index d0864360..f22ead6f 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -134,12 +134,14 @@ run_migration ()
> >   	qmp1=3D$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
> >   	qmp2=3D$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
> >   	fifo=3D$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
> > +
> > +	# race here between file creation and trap
> > +	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
> > +	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXI=
T
> > +
> >   	qmpout1=3D/dev/null
> >   	qmpout2=3D/dev/null
> >  =20
> > -	trap 'kill 0; exit 2' INT TERM
> > -	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXI=
T
> > -
> >   	eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp1},server=3Don,wait=
=3Doff \
> >   		-mon chardev=3Dmon1,mode=3Dcontrol | tee ${migout1} &
> >   	live_pid=3D`jobs -l %+ | grep "eval" | awk '{print$2}'`
> > @@ -211,8 +213,8 @@ run_panic ()
> >  =20
> >   	qmp=3D$(mktemp -u -t panic-qmp.XXXXXXXXXX)
> >  =20
> > -	trap 'kill 0; exit 2' INT TERM
> > -	trap 'rm -f ${qmp}' RETURN EXIT
> > +	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
> > +	trap "rm -f ${qmp}" RETURN EXIT
> >  =20
> >   	# start VM stopped so we don't miss any events
> >   	eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp},server=3Don,wait=
=3Doff \
>
> So the point is that the "EXIT" trap wasn't executed without the "trap -=
=20
> TERM" in the other trap? ... ok, then your patch certainly makes sense.

Iff you don't remove the TERM handler then the kill will recursively
invoke it until some crash. This did solve some cases of dangling temp
files for me, although now I test with a simple script:

  #!/bin/bash

  trap 'echo "INT" ; kill 0 ; exit 2' INT
  trap 'trap - TERM ; echo "TERM" ; kill 0 ; exit 2' TERM
  trap 'echo "RETURN"' RETURN
  trap 'echo "EXIT"' EXIT

  sleep 10
  echo "done"

If you ^C it then it still doesn't get to the EXIT or RETURN handlers.
It looks like 'kill -INT $$' might be the way to do it instad of kill 0.

Not sure if that means my observation was incorrect, or if the real
script is behaving differently. In any case, I will dig into it and
try to explain more precisely in the changelog what it is fixing. And
possibly do another patch for the 'kill -INT $$' if that is needed.

Thanks,
Nick

