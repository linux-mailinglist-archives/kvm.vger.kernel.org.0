Return-Path: <kvm+bounces-63255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8DDC5F45C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B02394E23CB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 375932FB62A;
	Fri, 14 Nov 2025 20:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EawYMjN1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573A32DC78E
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153356; cv=none; b=YqO7ZKoWDtdBQGkWV+0zyjyrc0h7Lz1WjphmD/RtqvR3sLo3ON3nDTs4p67rk2TNpFmkQGgPOfDuy3t6PN2iYh0GmeJEczxE4c0/Tdj1l+82wycIqVgRFwYTC5alcr1cP4RTtH2WSisB3h0oLBLk7hKuwg+EeDicT1pp8/MP4ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153356; c=relaxed/simple;
	bh=tE7fP22dB2vlNTuE6sh0FMu1Pi5aw/zDuijOpLixHCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f3S1KZbmh7xzgVAWicpO8gvyBoPWQEhkEaGTRjpL97pQiny25Tcj8ABaxEprByeUwqk+gCFKdw8kJoDMUJY/AjKrJOnLYwZvi0AFxKR9TOuvmcaufQ+itTg7i7zav2qN8Wl3QmC8jnPpNfZwpM1EL+Ib1jmw4eIZskbscV2pX/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EawYMjN1; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso3798799a12.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763153351; x=1763758151; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nIotG2TBVJHtLyVkQ1nV/V4Ve4TP77XPvYjhlVaFGps=;
        b=EawYMjN1tyDS/sH3KBfMS2QrjL+iPq2YIPIuV/xy3foDL/9YEs/IkauzagIAkeLnDb
         O4QO6xWiAHMyqd1rYDl2K1JVDIJjB52wzdwzIrcdRdc5mPKkZcEASR2TqyQH388r3XwA
         QEXiKM4G8fgoNwMCsvm2oTZWJ6Mw66I419Swk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153351; x=1763758151;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIotG2TBVJHtLyVkQ1nV/V4Ve4TP77XPvYjhlVaFGps=;
        b=olXIR+wNjswoHXGQuEwgfb7VMWOOpXe8GY5KKDhUhE+IKN9gj/cBO8UlHpvqV+qnKA
         xI7kJJqnzLNiFf2AnqewKBzxltRZ6I1z1kI9k0hixBqZNmkHNeFHJUjePZSXDLniPLso
         7p1q+un64UZCoh670knne0hSmdp4dT5Y143JD72jDHGIOeyjpZJgNSjI3jyz1hODkQIc
         nuaY3MXp6s5BhJ3aisXNf9JNyR6u9+6KMLp8MOWE26ikvj4chG/bDXUUbT+G76WllAEG
         7xdW10mVXqjRjTB3QyfrZhvGB7taRodqFIKYe2/kt+ObjCfkmZx6YYOKYtTeIk0u7Z+K
         AA2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUdb3t2l5sUocViyrBTrqse273qO4oEa0HlSbxg3bFql0KNfA0ZhkG8EHHtcqTM8yXT57I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4zpSEjRRBEmwrJM0n4MKyZDpPPtw3JysiuNuNt0+E5VTiG/vq
	m2FoKDxxFbMhBo6pADK84f96o+hUhkhxb8x7FAg0zuVBkERucO8nHJmnhNBTYd/FDcaD8wr8JVc
	tBEFC/ZU=
X-Gm-Gg: ASbGncuUIwjo/UodhsIJBq3pmntvPiDY8WW7JD5mLUtKCkjbW3umctCM8+ast9w6qcL
	gBrwUbjQ5y+pRNm2CaPheEPs3lvjnKlHS8LI6BXHtrX8HWEQkCToFGh1IsJXq3px9+IVNTY10i1
	doMuseJeLw5GJEYagmyszpbPB7kJ6y9vtYc0xBg9s685egz4H6QPdjkigcNUbeS/GPs6wUCJZMq
	oX5EQ+jx5xm2/IWTbdHHb02h1m/vevZdh9RN8bH+vHCdeKzeji7H+VZh1NNt8Lq2Kjy+Yk/XCkP
	DbouY+XbtpyhKv2qh7erO1Z8WeRxkuZ9WL3cz79UTHpvZ6I7n17x9gG3gi2DLckQj4d9Q/PtQrs
	cdtPh1q+I97sods8Y5klL6txEe7Sba/6rvvkUQBVZ4f6Lu9PmRd17bGM7UYockEij1yEz2+Wx3B
	NVoUDbRmSUdSgPsHXUbqgntYpACdAFK/uZG0e1S9w8zzOUUe5LoQ==
X-Google-Smtp-Source: AGHT+IHyXRbfp1gmRwDh5z6KjUn1CozBUgo3wnM5UrKURuyn3Ggor4E0hi64a82VISwfvjy050xL2g==
X-Received: by 2002:a05:6402:848:b0:640:b814:bb81 with SMTP id 4fb4d7f45d1cf-64350ebd23dmr4382312a12.32.1763153351531;
        Fri, 14 Nov 2025 12:49:11 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a3d87e3sm4285285a12.7.2025.11.14.12.49.09
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 12:49:11 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so372128466b.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:49:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWinTgqFPzUHhDQLwptne89ebrO+4IqykXpLptKcM4Di36KkhXEubhVVQtdaSw3pGLapRY=@vger.kernel.org
X-Received: by 2002:a17:907:1b27:b0:b70:bc2e:a6f0 with SMTP id
 a640c23a62f3a-b73677edbcemr485389666b.5.1763153349232; Fri, 14 Nov 2025
 12:49:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113005529.2494066-1-jon@nutanix.com> <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com> <CAHk-=whkVPGpfNFLnBv7YG__P4uGYWtG6AXLS5xGpjXGn8=orA@mail.gmail.com>
 <20251114190856.7e438d9d@pumpkin>
In-Reply-To: <20251114190856.7e438d9d@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Nov 2025 12:48:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=whJ0T_0SMegsbssgtWgO85+nJPapn6B893JQkJ7x6K0Kw@mail.gmail.com>
X-Gm-Features: AWmQ_bkW5f2iQA-30H7SfZ-1SPQdVwpCHIQwF379qtfjWrYcgYHuVtfQQYOnQPg
Message-ID: <CAHk-=whJ0T_0SMegsbssgtWgO85+nJPapn6B893JQkJ7x6K0Kw@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and put_user()
To: David Laight <david.laight.linux@gmail.com>
Cc: Jon Kohler <jon@nutanix.com>, Jason Wang <jasowang@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Nov 2025 at 11:09, David Laight <david.laight.linux@gmail.com> wrote:
>
> I think that is currently only x86-64?
> There are patches in the pipeline for ppc.
> I don't think I've seen anything for arm32 or arm64.

Honestly, the fact that it's mainly true on x86-64 is simply because
that's the only architecture that has cared enough.

Pretty much everybody else is affected by the exact same speculation
bugs. Sometimes the speculation window might be so small that it
doesn't matter, but in most cases it's just that the architecture is
so irrelevant that it doesn't matter.

So no, this is not a "x86 only" issue. It might be a "only a couple of
architectures have cared enough for it to have any practical impact".

End result: if some other architecture still has a __get_user() that
is noticeably faster than get_user(), it's not an argument for keeping
__get_user() - it's an argument that that architecture likely isn't
very important.

           Linus

