Return-Path: <kvm+bounces-10141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1533286A0CE
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 21:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38BBD1C23725
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FD414C582;
	Tue, 27 Feb 2024 20:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NXbY5Gvt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4CA1D6A8
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 20:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709065564; cv=none; b=h4xj83abE0axWSxbKS6w6s060/vDY0yKJKZll3jajX7k7lC9ff3Fu0DWvtAHfh+llRAEzU2rR3ynDsggIFC91RSoUwWQdQTOvfAw8reKBWcDJV1SxZAzSd+4RdWGOIZHCBU026CJMrPdfPsNEdMBoW0mzhbquJZFlm5swGIo9tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709065564; c=relaxed/simple;
	bh=7S/l7jZJ21iUwVevZ8cOQI+LxMEGntYoU5b/Yq5y9hc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIQoLEimDlUxGeMbgijBXWFPhpom1LMX+gx92Z91QQYO7RAGilRqBSRil8qXzfUH1D2PDmBSd/VkZRb/nD5LmjOpV9tvCDMBwA7DHSu6uMpQOfIUp201QV0Ef0tEIWhvOGjzabv3WMevpNGOFVIuoUSTORFo3dRgNAHrko5aXVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NXbY5Gvt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709065561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+h7qK8aFxtDvDR5hE75ZYRCW8UfQrEkELzJmQTxV4sw=;
	b=NXbY5GvtT/L1STk4vhIcD0rQE0SId+/zNF/u1cPhITuSikAstp+v3upZsddRZxeqauhGTz
	XbGg/0Umu2ilqfX/AH5uhWKLFtiXjOfcskJYOHir5wX0Q8N4byoUuYNaBy9uZLWC7Fnmw3
	UESE0K7/GC3y2lMzzBefWPKKrhvvpqg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-7SzUt8__PaeUERDs29e7_g-1; Tue, 27 Feb 2024 15:25:59 -0500
X-MC-Unique: 7SzUt8__PaeUERDs29e7_g-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7bfe777fe22so346041339f.3
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 12:25:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709065558; x=1709670358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+h7qK8aFxtDvDR5hE75ZYRCW8UfQrEkELzJmQTxV4sw=;
        b=J4Zhi67hWLyBIf78Z+LFrw6f+7BM37pTXCsiAh1kIe9eMVpthv69ZIBC3rHKJihfaQ
         h0wrd67PTOsA2IlXJSsMjeyy/etiKarVCR2J5YVWoO7QNCmIlZMikIg9o50txuT1knti
         Y1HVv1MOWmY4BuxUdfnK5bL9YFTEhyAGYE0FTrFrd/kurJHO9cmF26YV7LQdml6uhxZW
         4YQVdtkcW6ADDKm0F0smipSIpA9DE4M3stPA5hFjr8rPE+wJyMwQ/l5ik1KQRdp7XlK6
         CeABuTHZF6hfi46WyrJ0fMXxvp8bA9svz+uqf0yND02YJquz1ENdG/pN94KrwZGIAbEm
         E8Aw==
X-Forwarded-Encrypted: i=1; AJvYcCWe2IT5OvDEaqUp8hvWOjOuxqXEPYuTOX1QxSAWn+b4Lligxko0ukN9XIsoRejnzKRJCMs4tUgghJy5ZYWOoQoiX7q2
X-Gm-Message-State: AOJu0YydmJslXHTdD1Z1LGWXntoWMGRtYhExPWSrIPhN1Qsbd767Y1WG
	RamXln0nopZHUD4YnG9/+V297++GIoWcpJt1J6WvnY3fj/jOEiSYhd97zECmfHD7bG9C6dDR9Ns
	LE7BOyt07lDfK1Zd39hCft4XFiFOZeBalHWqEQZQ3m5Uuk3bhD+ogPWNRJg==
X-Received: by 2002:a5d:87c3:0:b0:7c7:f47b:79f8 with SMTP id q3-20020a5d87c3000000b007c7f47b79f8mr897092ios.11.1709065558448;
        Tue, 27 Feb 2024 12:25:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHci+23CQB98NMLlChr+k6ZWKSdNDJpBGejQs+zKcJAxWU9Z7kPda1p4il3PKo54WX87BWJQ==
X-Received: by 2002:a5d:87c3:0:b0:7c7:f47b:79f8 with SMTP id q3-20020a5d87c3000000b007c7f47b79f8mr897080ios.11.1709065558190;
        Tue, 27 Feb 2024 12:25:58 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id r25-20020a056602235900b007c7de4a670esm684477iot.6.2024.02.27.12.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 12:25:57 -0800 (PST)
Date: Tue, 27 Feb 2024 13:25:56 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Yisheng Xie <ethan.xys@linux.alibaba.com>, akpm@linux-foundation.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] vfio/type1: unpin PageReserved page
Message-ID: <20240227132556.17e87767.alex.williamson@redhat.com>
In-Reply-To: <abb00aef-378c-481a-a885-327a99aa7b09@redhat.com>
References: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
	<20240226091438.1fc37957.alex.williamson@redhat.com>
	<e10ace3f-78d3-4843-8028-a0e1cd107c15@linux.alibaba.com>
	<20240226103238.75ad4b24.alex.williamson@redhat.com>
	<abb00aef-378c-481a-a885-327a99aa7b09@redhat.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2024 11:27:08 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 26.02.24 18:32, Alex Williamson wrote:
> > On Tue, 27 Feb 2024 01:14:54 +0800
> > Yisheng Xie <ethan.xys@linux.alibaba.com> wrote:
> >  =20
> >> =E5=9C=A8 2024/2/27 00:14, Alex Williamson =E5=86=99=E9=81=93: =20
> >>> On Tue, 27 Feb 2024 00:01:06 +0800
> >>> Yisheng Xie<ethan.xys@linux.alibaba.com>  wrote:
> >>>    =20
> >>>> We meet a warning as following:
> >>>>    WARNING: CPU: 99 PID: 1766859 at mm/gup.c:209 try_grab_page.part.=
0+0xe8/0x1b0
> >>>>    CPU: 99 PID: 1766859 Comm: qemu-kvm Kdump: loaded Tainted: GOE  5=
.10.134-008.2.x86_64 #1 =20
> >>>                                                                      =
^^^^^^^^
> >>>
> >>> Does this issue reproduce on mainline?  Thanks, =20
> >>
> >> I have check the code of mainline, the logical seems the same as my
> >> version.
> >>
> >> so I think it can reproduce if i understand correctly. =20
> >=20
> > I obviously can't speak to what's in your 5.10.134-008.2 kernel, but I
> > do know there's a very similar issue resolved in v6.0 mainline and
> > included in v5.10.146 of the stable tree.  Please test.  Thanks, =20
>=20
> This commit, to be precise:
>=20
> commit 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4
> Author: Alex Williamson <alex.williamson@redhat.com>
> Date:   Mon Aug 29 21:05:40 2022 -0600
>=20
>      vfio/type1: Unpin zero pages
>     =20
>      There's currently a reference count leak on the zero page.  We incre=
ment
>      the reference via pin_user_pages_remote(), but the page is later han=
dled
>      as an invalid/reserved page, therefore it's not accounted against the
>      user and not unpinned by our put_pfn().
>     =20
>      Introducing special zero page handling in put_pfn() would resolve the
>      leak, but without accounting of the zero page, a single user could
>      still create enough mappings to generate a reference count overflow.
>     =20
>      The zero page is always resident, so for our purposes there's no rea=
son
>      to keep it pinned.  Therefore, add a loop to walk pages returned from
>      pin_user_pages_remote() and unpin any zero pages.
>=20
>=20
> BUT
>=20
> in the meantime, we also have
>=20
> commit c8070b78751955e59b42457b974bea4a4fe00187
> Author: David Howells <dhowells@redhat.com>
> Date:   Fri May 26 22:41:40 2023 +0100
>=20
>      mm: Don't pin ZERO_PAGE in pin_user_pages()
>     =20
>      Make pin_user_pages*() leave a ZERO_PAGE unpinned if it extracts a p=
ointer
>      to it from the page tables and make unpin_user_page*() corresponding=
ly
>      ignore a ZERO_PAGE when unpinning.  We don't want to risk overrunnin=
g a
>      zero page's refcount as we're only allowed ~2 million pins on it -
>      something that userspace can conceivably trigger.
>     =20
>      Add a pair of functions to test whether a page or a folio is a ZERO_=
PAGE.
>=20
>=20
> So the unpin_user_page_* won't do anything with the shared zeropage.
>=20
> (likely, we could revert 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4)


Yes, according to the commit log it seems like the unpin is now just
wasted work since v6.5.  Thanks!

Alex


