Return-Path: <kvm+bounces-42865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 586D2A7E8D7
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 19:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DF8D3BC2E1
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 17:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1BF2101BD;
	Mon,  7 Apr 2025 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bokn3DaP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5628321770D
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744047584; cv=none; b=fqRO/8GukBjooheLapFcWUg60I36ndsFGhNBQOUab3K8wWCse1I7SyKjdJavJTWbO2Xg412d5+FNhYcyYb6MCjEgOQRJnG88hNhRuDXM1znYM2Ml5LDBx1U6lux4vwvG1IDBkMxuhJtOTIED8ANET8xDMA5iwwfJFChFG8kk3Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744047584; c=relaxed/simple;
	bh=gk7Pms5ggU4Mz+jBefE6aQUbZOdAXgc3uKZ/o8JLcRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y6xbZ0qrboKLZDuEXvZDjsbGcwvLBoshAdMfbrrK2Z4Du228Ao7wrQCqwgYiVqnbWGxTiXazKGlJUkDaa2x5ULoYaUPWOsh8FLlHu8WBBQaH7LCEIKvf12GIwafzar6vzw+uAAYfjafCpo3w6iYrKa1r/cM4yYRetQd/w588Y9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bokn3DaP; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2240b4de10eso8837445ad.1
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1744047581; x=1744652381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDFKuqPeswYIIkk2eM8stbEtqZO/k06yxbdJkpWX+KA=;
        b=bokn3DaPFVsvsfbqw29TvH/CT81hG8/ft1va6APxQ2x+bPYxr6shlKypVHWJRb4ri4
         IMk9giv55sOfq2QD2cuexvIuI9MfVPDF8ddbnZjtTnAVV3ueGA3kLrT052tBF9R6muFv
         qKFlTdDKdRI6gLdokPe31Lk6PcvkPgfMGzpNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744047581; x=1744652381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDFKuqPeswYIIkk2eM8stbEtqZO/k06yxbdJkpWX+KA=;
        b=QphXFQVcx29S/scBHFA7PKLJ600qU+lAuRs+IW5eKn614y4+iGedTdRBYpSSVq/wy4
         51Jcrm8SNufAPeznXtihLHGwRP5jji6/99sB5LyOOqlqVS02KsXSgecTH//2XrmKIDo9
         M0ctewAMhtcxBTrn1IGaPzZISLKx88oWF2ODYuwRAJxkE/rQsFqhrJuPR7d2U2YusBJ1
         IQ9L3LZSuaN0SHWYdULkA4dhP3HPoKrj1AdYy3xKeUyxA903Xz3FRFUg7/u1x51+eY88
         mbmgdNJJVSym+82e9PTsL9lYAa/x7/pRi3103RgxZmFuP90qU3eCbyAFBqfq68GTRrOV
         i78A==
X-Forwarded-Encrypted: i=1; AJvYcCXW9NbwpzLwyutBk2K2xXGKMi0xW0oYwyjliJZKrkO4scWMOAelL1z9lul7xA8Ym0u/oss=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSsd19B+5+GZEBZcR/Q1VGFjeTZc7zjRe1RBEE8qgK3jFj5xHR
	9GvQ2aTT4fLRIii7T+A5fjkNQWoiY3sYuDQetEpKhtLtQeU/rwlVT0huKw2gLz9nG1g0tL3C6DC
	+2g==
X-Gm-Gg: ASbGncuuKBUCLzSPRQp+83KBai4OSEiSd9BdG5SaL4fsev4cxdf9Vj9RoXvYHKiFy5V
	iiPqaJYowMUSInPzb9MyoZ7SY8EaYKShjndMVjKG26rjijnh4CBOcEG350lplSugEcsBDVjmRRJ
	JLWgOszzXN0QHMqUXXwzWr5wHIPThbGRx38LQUdkQuECnqGWatAcogm9JM6MtLG9YAK4UEmLfjp
	00N/y4ZYWb2AcFNT3CpD9ruMvCBJVJQoaxcPaAkUE8wb/2XGYKmXArUUtFIPO0vnp6iKy7bCCyq
	lYdDOsA/iBrvnbJKB6FmXX5YQxxZk8iepY2TXR6UP53NZW+nCso3Jgk5LDe1UmysQa9c/Y467Td
	QVMPA1wNMxqHY
X-Google-Smtp-Source: AGHT+IGEvObQ1Gomd+yjF54O0+xhuq8EogX7oef9sIO4PZ3+DkxHxmupTF1OM/q7NbOMFh01N0yA/w==
X-Received: by 2002:a17:903:8c8:b0:224:88c:9253 with SMTP id d9443c01a7336-22a8a06b36dmr66195955ad.6.1744047581289;
        Mon, 07 Apr 2025 10:39:41 -0700 (PDT)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com. [209.85.215.173])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2297865e03esm83983585ad.146.2025.04.07.10.39.39
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 10:39:39 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-af5cdf4a2f8so3395953a12.3
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 10:39:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWaTR63oiAl4bKHhF5J8o5YsZD2/yYHYzOEjcAbRl87lhPVWxA84sPUyOknZnHkVzckqJU=@vger.kernel.org
X-Received: by 2002:a17:90a:f945:b0:2f6:dcc9:38e0 with SMTP id
 98e67ed59e1d1-306a4758cf3mr22729577a91.0.1744047578869; Mon, 07 Apr 2025
 10:39:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com> <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com> <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com> <20250407042058-mutt-send-email-mst@kernel.org>
 <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com> <20250407044743-mutt-send-email-mst@kernel.org>
 <b331a780-a9db-4d76-af7c-e9e8e7d1cc10@redhat.com> <20250407045456-mutt-send-email-mst@kernel.org>
 <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com> <33def1b0-d9d5-46f1-9b61-b0269753ecce@redhat.com>
 <88d8f2d2-7b8a-458f-8fc4-c31964996817@redhat.com>
In-Reply-To: <88d8f2d2-7b8a-458f-8fc4-c31964996817@redhat.com>
From: Daniel Verkamp <dverkamp@chromium.org>
Date: Mon, 7 Apr 2025 10:39:09 -0700
X-Gmail-Original-Message-ID: <CABVzXAmMEsw70Tftg4ZNi0G4d8j9pGTyrNqOFMjzHwEpy0JqyA@mail.gmail.com>
X-Gm-Features: ATxdqUEz43TGWrMKYfRndFlXjP-cvulXZBTkkQ4WcXYsTky_PROiRhjDfo9dcJs
Message-ID: <CABVzXAmMEsw70Tftg4ZNi0G4d8j9pGTyrNqOFMjzHwEpy0JqyA@mail.gmail.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: David Hildenbrand <david@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>, Stable@vger.kernel.org, 
	Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Wei Wang <wei.w.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 7, 2025 at 6:13=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 07.04.25 11:13, David Hildenbrand wrote:
> > On 07.04.25 11:11, David Hildenbrand wrote:
> >> On 07.04.25 10:58, Michael S. Tsirkin wrote:
> >>> On Mon, Apr 07, 2025 at 10:54:00AM +0200, David Hildenbrand wrote:
> >>>> On 07.04.25 10:49, Michael S. Tsirkin wrote:
> >>>>> On Mon, Apr 07, 2025 at 10:44:21AM +0200, David Hildenbrand wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>>> Whoever adds new feat_X *must be aware* about all previous featu=
res,
> >>>>>>>> otherwise we'd be reusing feature bits and everything falls to p=
ieces.
> >>>>>>>
> >>>>>>>
> >>>>>>> The knowledge is supposed be limited to which feature bit to use.
> >>>>>>
> >>>>>> I think we also have to know which virtqueue bits can be used, rig=
ht?
> >>>>>>
> >>>>>
> >>>>> what are virtqueue bits? vq number?
> >>>>
> >>>> Yes, sorry.
> >>>
> >>> I got confused myself, it's vq index actually now, we made the spec
> >>> consistent with that terminology. used to be number/index
> >>> interchangeably.
> >>>
> >>>> Assume cross-vm as an example. It would make use of virtqueue indexe=
s 5+6
> >>>> with their VIRTIO_BALLOON_F_WS_REPORTING.
> >>>
> >>>
> >>> crossvm guys really should have reserved the feature bit even if they
> >>> did not bother specifying it. Let's reserve it now at least?
> >>
> >> Along with the virtqueue indices, right?
> >>
> >> Note that there was
> >>
> >> https://lists.gnu.org/archive/html/qemu-devel/2023-05/msg02503.html
> >>
> >> and
> >>
> >> https://groups.oasis-open.org/communities/community-home/digestviewer/=
viewthread?GroupId=3D3973&MessageKey=3Dafb07613-f56c-4d40-8981-2fad1c723998=
&CommunityKey=3D2f26be99-3aa1-48f6-93a5-018dce262226&hlmlt=3DVT
> >>
> >> But it only was RFC, and as the QEMU implementation didn't materialize=
,
> >> nobody seemed to care ...
> >
> > Heh, but that one said:
> >
> > +\item[ VIRTIO_BALLOON_F_WS_REPORTING(6) ] The device has support for
> > Working Set
> >
> > Which does not seem to reflect reality ...

Please feel free to disregard these features and reuse their bits and
queue indexes; as far as I know, they are not actually enabled
anywhere currently and the corresponding guest patches were only
applied to some (no-longer-used) ChromeOS kernel trees, so the
compatibility impact should be minimal. I will also try to clean up
the leftover bits on the crosvm side just to clear things up.

> I dug a bit more into cross-vm, because that one seems to be the only
> one out there that does not behave like everybody else I found (maybe goo=
d,
> maybe bad :) ).
>
>
> 1) There was temporarily even another feature (VIRTIO_BALLOON_F_EVENTS_VQ=
)
> and another queue.
>
> It got removed from cross-vm in:
>
> commit 9ba634b82b55ba762dc8724676b2cf9419460145
> Author: Daniel Verkamp <dverkamp@chromium.org>
> Date:   Thu Jul 11 11:29:52 2024 -0700
>
>      devices: virtio-balloon: remove event queue support
>
>      VIRTIO_BALLOON_F_EVENTS_VQ was part of a proposed virtio spec change=
.
>
>      It is not currently supported by upstream Linux, so removing this sh=
ould
>      have no effect except for guest kernels that had CHROMIUM patches
>      applied.
>
>      The virtqueue indexes for the ws-related queues are decremented to f=
ill
>      the hole left by the removal of the event VQ; these are non-standard=
 as
>      well, so they do not have virtqueue indexes assigned in the virtio s=
pec,
>      but the proposed spec extension did actually use vq indexes 5 and 6.
>
>      BUG=3Db:214864326
>
>
> 2) cross-vm is aware of the upstream Linux driver
>
> They thought your fix would go upstream; it didn't.
>
> commit a2fa119e759d0238a42ff15a9aff0dfd122afebd
> Author: Daniel Verkamp <dverkamp@chromium.org>
> Date:   Wed Jul 10 16:16:28 2024 -0700
>
>      devices: virtio-balloon: warn about queue index mismatches
>
>      The Linux kernel virtio-balloon driver spec non-compliance related t=
o
>      queue numbering is being fixed; add some diagnostics to our device t=
hat
>      help to check if everything is working as expected.
>
>      <https://lore.kernel.org/virtualization/CACGkMEsg0+vpav1Fo8JF1isq4Ef=
8t4_CFN1scyztDO8bXzRLBQ@mail.gmail.com/T/>
>
>      Additionally, replace the num_expected_queues() function with per-qu=
eue
>      checking to avoid the need for the duplicate feature checks and queu=
e
>      count calculation; each pop_queue() call will be checked using the `=
?`
>      operator and return a more useful error message if a particular queu=
e is
>      missing.
>
>      BUG=3DNone
>      TEST=3Dcrosvm run --balloon-page-reporting ...
>
>
> IIRC, in that commit they switched to the "spec" behavior.
>
> That's when they started hard-coding the queue indexes.
>
> CCing Daniel. All Linux versions should be incompatible with cross-vmm re=
garding free page reporting.
> How is that handled?

In practice, it only works because nobody calls crosvm with
--balloon-page-reporting (it's off by default), so the balloon device
does not advertise the VIRTIO_BALLOON_F_PAGE_REPORTING feature.

(I just went searching now, and it does seem like there is actually
one user in Android that does try to enable page reporting[1], which
I'll have to look into...)

In my opinion, it makes the most sense to keep the spec as it is and
change QEMU and the kernel to match, but obviously that's not trivial
to do in a way that doesn't break existing devices and drivers.

[1]: https://cs.android.com/android/platform/superproject/main/+/main:packa=
ges/modules/Virtualization/android/virtmgr/src/crosvm.rs;l=3D1079;drc=3Dcaf=
f2827914c0918260ff76cd55f6e3dc6323d51

