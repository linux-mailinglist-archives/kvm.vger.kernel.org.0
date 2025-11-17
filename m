Return-Path: <kvm+bounces-63425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF69C66377
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 22:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 955C34EE3DF
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 21:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70FBD34D396;
	Mon, 17 Nov 2025 21:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qanSjEG0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED27B30CD94
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 21:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763413752; cv=none; b=iTxUR9vpPBN9JIIDuqJDA6oheh4HzXcNI3boOZPsneAw7ZKDX1Enf8aM/d3epsqIaW7/r00LEMpKa8QOma77HxEhY1XHhrwPHYahFq8b3MWUd2oLjszz5l2OwXGuMBECKv48Tx9HoZzoQtFnON7l+d1OnSVlhZ2GC1ed4lCxoZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763413752; c=relaxed/simple;
	bh=dA/5NYPyaR3SpUDS42goPQsXtjt42GFHqrfiFziwDXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j9z9jI0MjIdZNlNZ/irnBhv8XeL9Mh5vxkgSd8/+VbD2B8xXq+7m7xqW36rK8QRRmopSGVqCqfFTNYSQufdGx5lCwqy6t44nL2zuK43oauAy7Fqiqzm3xNxoqo9rwgKNGsIyEx913N6/hvh/mhQRspBpi3MstjfJUTDwRcxunzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qanSjEG0; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5957c929a5eso5479848e87.1
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 13:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763413746; x=1764018546; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RjoWhLUfJbKg+2stbKiQ55r0rLOxAAjJs86wMbbOnY8=;
        b=qanSjEG02A3Y2Oq23LtXhCxrONeIzu+2dN7Za4S1Aj4O8PHIU9ghmAeWBLxyE24UIC
         +1mlKC8jHhruCYxQeoRoeQ2HC5iBqFdUDvLd34S5eDfgMqzVXEHhYVt51a8y0K9c9TW5
         QDnn5lZmGE9sVgBkBhVvc0C65XKnlG8QWcNIFoNwL07FvmwVlOS928UhReX2UhyjBBlH
         F5zm2x6Nioz8JMJOsO6yfs1xnMVzKVLMpicytqzO7PudiEcVkWJxmdz3kEv/owd2oXQR
         2Jd5bUFcMqq1wBTp35OfjCTviMN5oosMjT/qbwGFvZHtRnv8hMHDtGjwToeVRWWIbt4o
         qkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763413746; x=1764018546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RjoWhLUfJbKg+2stbKiQ55r0rLOxAAjJs86wMbbOnY8=;
        b=IAVxHEf0tJbWWsiUSOyWKL0cxl/7oXnAnjF7Px0n+JIBO793FeVrnj92hXwfC/9cJn
         rXHdRGtU1Tnn98Sc5zv4l3r5lVFD5naypGJ65FFLhbiqpuhatsc4YJGh3RsbMY0ebmKd
         rWu/HGyh2trpr44LVuadAgRje7MrlVl6skGYiKcAvijpUd50sb03LfGfWJNMHtt23jym
         hFP6pQDuqeEP9/Kjtepyj9NzbPkfK+2RsWlcEPUonr/4FWUFZnh6sBRFSNdfnsZTb3PF
         RAIPR7Tx8imS4V3tRksrbcQuYTBEBDfX0Pb61Na9OzAq4Y+y4zaQq/I4EMjdmPtMANu+
         g/yw==
X-Forwarded-Encrypted: i=1; AJvYcCW4vpRRt1eeT/KlZYjhjNo3t4A5cEcaRdl6AWd1fMweEGVqGp2jWB4+lVC0pOQqmQuPDug=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLYyGnmGVswzuyKaR2b8fXNRh8kdKzrOE0bBh7Oq7WkPcZpX2o
	JVHaxMv6jl9dHBlZaCokR/H/uZ1xY9wliS7PZWLsg1+WXWihoNJ+ViiYuxS02H50Sac738mgNa6
	NyuBG94+iIEdnsAj2MWYwoDCwgIvEfkD8taP6jxh+
X-Gm-Gg: ASbGnctc5jLXmriytsJe/R5KYEAJNySGi4XShDpR7m7zkcqf3CohOBCjXLC+jescqmA
	Mja77JAhZUWvz+Bjb5nJlaDNVI7lsgXV0qMaqg95OMsuA0Pu38Z3gX6clXvFL9lsSk8drIFwfd8
	1Rt58aW39T6/Xzr+y0QTqxNF9GqeXZ+g4Te71/TKoj8DuAwSNyBiN3t6bCenhzMs5NN77qVaVa/
	I8IF3dCMrWoZtuuofGXElvJbLI/KY7PqU6iNbo19gDqPmX0HjcX+Ed/L3ZNNDRmMuoEa0bibAKs
	pxtNmA==
X-Google-Smtp-Source: AGHT+IFni1VNjv0z/eeugp/jXAsBHzPTprbSdMefmczevXx19k/vvMv478Xc/gXsOfk0JBX+x3U9Hk/lS2aJOagt9H8=
X-Received: by 2002:a05:6512:b05:b0:592:f441:928a with SMTP id
 2adb3069b0e04-595841eec54mr5006421e87.3.1763413745951; Mon, 17 Nov 2025
 13:09:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112192232.442761-1-dmatlack@google.com> <20251112192232.442761-3-dmatlack@google.com>
 <aRt+XHgbKFq5k3ns@devgpu015.cco6.facebook.com>
In-Reply-To: <aRt+XHgbKFq5k3ns@devgpu015.cco6.facebook.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 17 Nov 2025 13:08:38 -0800
X-Gm-Features: AWmQ_bnjy6Qk7n2t_yD_IVUwtIQduWDCtYPxvyttcjPXfMzUdeQiOxzgfIPrCtA
Message-ID: <CALzav=fN5CAn8C0x0SnsB7Fpq6o-CHspPvvL3ctk1U5i5FE40A@mail.gmail.com>
Subject: Re: [PATCH v2 02/18] vfio: selftests: Split run.sh into separate scripts
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 11:58=E2=80=AFAM Alex Mastro <amastro@fb.com> wrote=
:
>
> On Wed, Nov 12, 2025 at 07:22:16PM +0000, David Matlack wrote:
> > diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/self=
tests/vfio/Makefile
> > index 155b5ecca6a9..e9e5c6dc63b6 100644
> > --- a/tools/testing/selftests/vfio/Makefile
> > +++ b/tools/testing/selftests/vfio/Makefile
> > @@ -3,7 +3,11 @@ TEST_GEN_PROGS +=3D vfio_dma_mapping_test
> >  TEST_GEN_PROGS +=3D vfio_iommufd_setup_test
> >  TEST_GEN_PROGS +=3D vfio_pci_device_test
> >  TEST_GEN_PROGS +=3D vfio_pci_driver_test
> > +
> > +TEST_PROGS_EXTENDED :=3D scripts/cleanup.sh
> > +TEST_PROGS_EXTENDED :=3D scripts/lib.sh
> >  TEST_PROGS_EXTENDED :=3D scripts/run.sh
> > +TEST_PROGS_EXTENDED :=3D scripts/setup.sh
>
> I think these assignments will discard prior assignments. Was +=3D intend=
ed?

Yes, thanks for catching that!

