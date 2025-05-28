Return-Path: <kvm+bounces-47884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 138F6AC6C45
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8D843A7A82
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 14:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8722F28B50C;
	Wed, 28 May 2025 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJ5eHxn7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4611E193077;
	Wed, 28 May 2025 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443886; cv=none; b=LsG43MGZA32eJ7/bvDAueQES8+gpj5vLsMweDhu5VmNBSqtBBSMnb1vYwq+qrumi78WAzmRB0DEozfoAFlhOyAPi1szy2il6r6KRE5E4e4vUUglLqkCXLAPRta0KHwWtc5bYE25qDhDZwPAiQQFUzdGKwjMqbAUxZTRfSNhr/SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443886; c=relaxed/simple;
	bh=CaNlGgqQCzHq8F3U49dwDdVi1yyeghj6F8AwiQKBM94=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U77Unxwy8PihXRfERVjD/JNyaF+95Xi+2iZl9q6c1nAaQ0PCMJDRr2bpJYfae9dd9EEfDqPoNLAfk4TjXh8wdw47FQa0zLwucA4nB1RC/9uqs5CD31wWaDPiT5MCphpAUkG6A6JLbd89H+80IXaZyxcA1H600mxz34y2W4MDTGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJ5eHxn7; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7c54a9d3fcaso418773785a.2;
        Wed, 28 May 2025 07:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748443884; x=1749048684; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:feedback-id
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=m4HPI+uUoKdBGuZtoY9CPzya8qdmq+5VMevK83oBeE8=;
        b=kJ5eHxn7ZqojhY0EYtsJP38TYQ6YXNrGJSFsZl8c8elXeRFHElYWDrKVPDwIgDXPyf
         ub/R+iElEkVVkrYsGLowqes07rfTZGmGrBBd+yewScjusA355GsXtdCJOYdzBhYFrG9w
         Ni15rl26i0aZ1ejq73Vy/BMd3lMXcA61VNr+5FxXz/UZzYWHqetg1xZOBN3UTo02hrXe
         Icr22qjCLhj+jiyuWTsGXblmJsTnPLhn2/w6BgHXgPOcmT1bA6T/w6q7g3q8A54zyHaC
         BTUpcAAcAXiy66I6GdESKC+ZWbpXjAt3AYKe12cR8vEHOiqCYF9u9uMT+vlrmg/6AW6f
         ULkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748443884; x=1749048684;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:feedback-id
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m4HPI+uUoKdBGuZtoY9CPzya8qdmq+5VMevK83oBeE8=;
        b=h+y9Dwm8S+wtSUHWgp1tnOigsEoHJt1yyaJKXaEBRE/Giw0mkLkWz1na9huD19hXEt
         l+/1kM54fputPH6f+P/exm3l0hlkvztX+QIEu5IVZrRPhl3q3vNSyky5/XpGcc4hGTkl
         I1eCKMiR4bnJWfXOctszvdhqQn7dH97NIi3mrOyWfJXMTGxX3tX2Dpgj07Woow4uTmsR
         Il1t2xfs74BOH+KLyXR15kS/tu8q8U8xZLIXSg2eEvZwZBkSD+Sy0KqyAD9XsrWRbWi4
         pA5PoOmcUFrU7ZfM72ZEsy6jtAw0wKPsPPBPbpkauuYOyTovMdmXhLwHWGY6r85T+8Xo
         Jr+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJH7S//i4/4dnk/G/8jkboBf5tqHVUw55jSNCTFhyaBHHyrA1waDDJ1D04tyRfoPSoVWbsjpJxJ9QreymC@vger.kernel.org, AJvYcCUUBV6E9apM5iLfm2lrh7Dn/sssDWbaWG+84xYV+LUEoREVll+kgLMz4Elv1oEdxIMZ21I=@vger.kernel.org, AJvYcCVkzj+G5UNnP26zUGbJZ7TdA3yBeQbZXsM9k+lTFBF4qPPvHKcqrpwQqPx/Q/38HgIuj/7p/Qd8VQRf04l+uug=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZrAw4MB1aCqBzkrYjqoO/9v26MKCZNQ7mgNdKiaLv7YOduSLd
	Bkwxo5UMBeduEPZe0u9Lq7m0PY2GvH9IZyNbX6E6i9IcoGFzd72zFKVx
X-Gm-Gg: ASbGncuKnkqdxtgt2KaIpT/G3NafiKTz2ScHcbeYEUNEU5mF6Ct/m7IdPCk0K3zK20U
	6QcCKLfaNLNGMGaFq22Vbai0WtNSyFogOQenebXyIAfZmMQgC74So/APG+BUcAiuRUKmC+nYyta
	kgKgruoTabcAHa9UeFAJhwqinHHpSIKi6zcx57GTo3nA1SEaQSe+uq7HQ1XGKCqAksLjWv9b+3F
	awPVTsxdhUDmL4sWM1Y5A8D66Ayn//9Uy8IacBRLB3saakOL7g5ifn1U1QamM80fDHzuWzJE7+o
	QrA2tWaKHsZ1o3eQS4vXwlPuZhtQR/k1r4Sb8z67b8INMkoSJB0VFrP81qAM12owyMz89QKOwCg
	Vq1On23YloRcnCLRCHwy+yx4DeBY7+YabNe+/7jNHTzodj8gXxEjq
X-Google-Smtp-Source: AGHT+IFiFNSqe6X/cs8W0Ae+kpNzm5s01ff7TiY9jBksJfOfSzABXvHKKUK9dRrwKFB8WycQwR+gKA==
X-Received: by 2002:a05:620a:a901:b0:7cf:15a:7fb1 with SMTP id af79cd13be357-7cf015a8019mr815186385a.10.1748443883994;
        Wed, 28 May 2025 07:51:23 -0700 (PDT)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cfb82002c8sm79166185a.5.2025.05.28.07.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 07:51:23 -0700 (PDT)
Message-ID: <683722eb.050a0220.3d9475.2b4a@mx.google.com>
X-Google-Original-Message-ID: <aDci6Dz7u6gEUnwr@winterfell.>
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 049FB1200043;
	Wed, 28 May 2025 10:51:23 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 28 May 2025 10:51:23 -0400
X-ME-Sender: <xms:6iI3aCvUg_433TA6Z04ZQJ5CUJlEID6pYkGhaiZFjC0QpN5B1yx_Ng>
    <xme:6iI3aHcUWvjkUQ1Lkxo14ldf_hl1UClxv-D4cuWjZahIkEQ8WjXtDT2SL7HoMVGsm
    fdx2hl3SUTcY2d5NQ>
X-ME-Received: <xmr:6iI3aNz40bMwHYPOXQQ-cY0ChGjuyYw3-BQk1dee1EvJd7wISfsJ_kMfAMJ5Ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgddvfeehheculddtuddrgeefvddrtd
    dtmdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggft
    fghnshhusghstghrihgsvgdpuffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftd
    dtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhf
    gggtugfgjgesthekredttddtjeenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqh
    hunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeejhfeikeek
    ffejgeegueevffdtgeefudetleegjeelvdffteeihfelfeehvdegkeenucffohhmrghinh
    epkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthi
    dqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghi
    lhdrtghomhesfhhigihmvgdrnhgrmhgvpdhnsggprhgtphhtthhopeekpdhmohguvgepsh
    hmthhpohhuthdprhgtphhtthhopehmihhguhgvlhdrohhjvggurgdrshgrnhguohhnihhs
    sehgmhgrihhlrdgtohhmpdhrtghpthhtohepphgsohhniihinhhisehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheprhhushhtqdhfohhrqdhlihhnuhigsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhfrhestg
    grnhgsrdgruhhughdrohhrghdrrghupdhrtghpthhtohepsghoqhhunhesfhhigihmvgdr
    nhgrmhgv
X-ME-Proxy: <xmx:6iI3aNMJsK1ql7yT3mKpSUP7SZOLDBeDnenZ4yWk60LWDJaa7_fwwg>
    <xmx:6iI3aC-Fj2Fq2ptvcevwPq6UtT0nI53Kr5JR-hY4-3nVoY36s5SfPA>
    <xmx:6iI3aFWL_oXdb9C6pAs-4YUR3OrOpkiFqKhfDVQE_hZDd2Rs8KIjOA>
    <xmx:6iI3aLdCiVmesyv198D8wTu7kzypEbLsnMeWqV_d8LP6NMdEI5caDw>
    <xmx:6iI3aMeexqz7gsyEaSa2P4lke1avl9wWdzzB33eO-RIV_OSt2l9DW3HC>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 May 2025 10:51:22 -0400 (EDT)
Date: Wed, 28 May 2025 07:51:20 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, rust-for-linux@vger.kernel.org,
	ojeda@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] rust: add helper for mutex_trylock
References: <20250528083431.1875345-1-pbonzini@redhat.com>
 <CANiq72nwM79eGSAt8FjKgoYCJd-bLeTojaQAtg3SECE28uByQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nwM79eGSAt8FjKgoYCJd-bLeTojaQAtg3SECE28uByQQ@mail.gmail.com>

On Wed, May 28, 2025 at 11:39:12AM +0200, Miguel Ojeda wrote:
> On Wed, May 28, 2025 at 10:34 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> >         Ok to apply to the KVM tree?
> 
> Yeah, looks good to me, thanks!
> 
> Acked-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Cc'ing Boqun just in case and so that he is aware. Boqun: this fixes a
> Rust build error on the kvm branch which failed on merging into -next:
> 
>     https://lore.kernel.org/linux-next/20250528152832.3ce43330@canb.auug.org.au/
> 

Thank you both!

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> Cheers,
> Miguel

