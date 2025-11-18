Return-Path: <kvm+bounces-63524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 133DBC68435
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:45:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C3A2F4E2ED4
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E106124C676;
	Tue, 18 Nov 2025 08:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSZ3mD3s";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ntLfOd4Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1792A49620
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 08:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763455541; cv=none; b=pKuKaCOXIbpMhInm7P7abAkBzbC2iivFJ0HLanEcIL1DVt0rAJZI5m0fUJJxArMLJTuyPd6BrktWCcQeyUojYB98mS6tSzmGmXV90jnGNqsQ5ZjXKZDZavfx6kWIUaHpy7qStPYc0y3kU7p+2BpWqC8lfBIfOE3k0BXaT5q0lcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763455541; c=relaxed/simple;
	bh=fLM+o/JsWSMat2hS23mO7Wct40lEssd/TrCdfJArPlY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=onMKRx8OdaKmugRjrKMXN+7L71CCNkoujy1ii8sLNnB66pKMsf5biU36XV8P1kunZPWUCSDPxWuya9gO5w2fy9a9K2/AkOboXvmZbBFgZdIoaxDpxSZEhdb6VMxa7KDCKvSs8k4sHrfw32W9xyt+lUxb3hyEk2DGJbTZJjo17e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSZ3mD3s; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ntLfOd4Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763455537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EeH7esf9DAprT3Wwab6GVJxBQKPkkelL/OieD6b8Pwo=;
	b=dSZ3mD3sd5wgkhXFST7fntVDBUeV67gSed3/3n+NUOXDhD511Fac7U/X2LcuD7wt5+O/jC
	Ojq2jW9mw8IBSwzbix97DNoDQWt0i0mBAwqdOwieZ9m7GeoQKfxJsOKErEm4LbvV5XFmGF
	JXZzVeNwZL4YNzG6WA7VHlJ1NKWhQJo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-UiqY_x9XN9OvEmqA4Jyqcw-1; Tue, 18 Nov 2025 03:45:35 -0500
X-MC-Unique: UiqY_x9XN9OvEmqA4Jyqcw-1
X-Mimecast-MFC-AGG-ID: UiqY_x9XN9OvEmqA4Jyqcw_1763455534
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b3086a055so3445035f8f.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 00:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763455533; x=1764060333; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeH7esf9DAprT3Wwab6GVJxBQKPkkelL/OieD6b8Pwo=;
        b=ntLfOd4QcJzH90rC7GkA3uFaKeBenHqgJwhX7KPvODbb9Xw4LRpWkdyDt7wuCRI+YU
         UoKVkSiNMU2KEVoh4C/dm0v3YjPo8oirEHzqLTi31OnJ1Vzr4L6k4FJ9B7OxYazsfgYi
         22PAZGurXvVknTXQDADXLX2lnfcF+PIN4rIyLAJ1ncQybB7zY/HeNTrfv5FSeSdsCOv0
         xGIBT00XtMk2onoVIqtATvl8pErzZghm8onwMJBA1vj6uI4nxW95BZzW21+busritw0V
         C/Ut0BDsfp8WeRMTJuEfDTsLFIzhspqLyW5PmS4OMtzOx9fK1ozSB7cXBYIV2tJJEdR6
         IyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763455533; x=1764060333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EeH7esf9DAprT3Wwab6GVJxBQKPkkelL/OieD6b8Pwo=;
        b=YP629zW2XCJ0Uu3NREw3KUXfHP4Hf4zmlxHD1+cTkF9tiJm3qKpM8O/hP2Sh8nSd22
         ORcHU2EkAy1VWTDrNpBzc+s9bLv6RqkI492TR8go+zN5XVw6VerbP/dTYDsy++MVFx6b
         1rrkZfzVZ35S8C7Gw9IfzkZRbZdoKXS1WkqN35T2eRJOwxej/1P+OJT15KxqlCk2+BW3
         1xFak64nxDmzPCvm54dcs78KIGvdqsqqWsrek6LIwdnUCAfB6wj8xXul5sZr6QJa/T/J
         3L/m4b/jRwP1imYD+wCYO185ecvbsxVYlab8jPHzElw6PakIGaqQcUbdNAAWEkAT6sr+
         M64w==
X-Forwarded-Encrypted: i=1; AJvYcCXSgNh2sqgl1QRqRJzJFkRoD8ZicBm1jJe8IIWAa+lT5ay9mX3srtXwOScX78gb5XveoR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAHYUw4TjOty2SVaiHRDcLtSR9u+maC/F2H5PRMGOGC1u/jPs5
	36dXz3QRxW/9XApFcehXY/Nem254RzLPyrXcKNub7/QoqdrGBzeivTmMhzCBFEdmWLS8d8Ejvov
	Wfn4iPiWSo7RJL/e+mbdWV7yuhhTkmX/PaWAmovLRglnhvAk5G1Nftrt4x4i1L6ziAp5pfi//r+
	aFWrrJSrVZt67pa2NmPnUb+O6qO9/Nyo/sfTIO
X-Gm-Gg: ASbGncvDUO48IOtWK83xnDAKVEvYQayQZQR+YRlma7+I2vqZYLoVXub3pkGG8I44OPM
	k5f20rs0yGXU7YMUxernF5VWJZgP0Ql2E3g5uqsRryqy4ENRJkl0Sh3iWE5ufPVeQdCOOyt/n5l
	7hIhGshbZ537Im/EuX2IcYArHQu2L4dcKgP8bE5e1ghn4GeykMUtiqw1ZlUa2Bml/eJbjPJzei0
	bcI8NpqsysQ8QbHnu338NltW8qajMQJqVQFRilbRFsVxYKhoCyRaFCVJjn2R5Gj/eBb72E=
X-Received: by 2002:a05:600c:138b:b0:477:7a95:b971 with SMTP id 5b1f17b1804b1-4778fe882d9mr157498015e9.31.1763455533322;
        Tue, 18 Nov 2025 00:45:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWrtB6FWUpiS02Ik6Y450zpyrbX5cajldKAKN3E1QGqYwiRM+8a4yPoFPG5LR7JaP0i8DbMeuNFrUI9/4JqOo=
X-Received: by 2002:a05:600c:138b:b0:477:7a95:b971 with SMTP id
 5b1f17b1804b1-4778fe882d9mr157497725e9.31.1763455532932; Tue, 18 Nov 2025
 00:45:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118065817.835017-1-zhao1.liu@intel.com>
In-Reply-To: <20251118065817.835017-1-zhao1.liu@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 18 Nov 2025 09:45:20 +0100
X-Gm-Features: AWmQ_bkgi0c0szQngSlsuQGAHJe64NW4a3ZmXTN_JYX47_A2Hyxk0ZyYVHFXbMw
Message-ID: <CABgObfZSBjNzhMrCVxXV1zRCsT47Hz31H-ER7Qv0S+Haw6Ds+A@mail.gmail.com>
Subject: Re: [PATCH 0/5] i386/cpu: Support APX for KVM
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	"Chang S . Bae" <chang.seok.bae@intel.com>, Zide Chen <zide.chen@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 7:36=E2=80=AFAM Zhao Liu <zhao1.liu@intel.com> wrot=
e:
>
> Hi,
>
> This series adds APX (Advanced Performance Extensions) support in QEMU
> to enable APX in Guest based on KVM.

Thanks for sending this out, I left some comments on the patch that
adds EGPRs but otherwise it's pretty simple---good.

Paolo

> This series is based on CET v4:
>
> https://lore.kernel.org/qemu-devel/20251118034231.704240-1-zhao1.liu@inte=
l.com/
>
> And you can also find the code here:
>
> https://gitlab.com/zhao.liu/qemu/-/commits/i386-all-for-dmr-v1.1-11-17-20=
25
>
> The patches for KVM side can be found at:
>
> https://lore.kernel.org/kvm/20251110180131.28264-1-chang.seok.bae@intel.c=
om/
>
>
> Thanks for your review!
>
>
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> Intel Advanced Performance Extensions (Intel APX) expands the Intel 64
> instruction set architecture with access to more registers (16
> additional general-purpose registers (GPRs) R16=E2=80=93R31) and adds var=
ious
> new features that improve general-purpose performance. The extensions
> are designed to provide efficient performance gains across a variety of
> workloads without significantly increasing silicon area or power
> consumption of the core.
>
> APX spec link (rev.07) is:
> https://cdrdv2.intel.com/v1/dl/getContent/861610
>
> At QEMU side, the enabling work mainly includes two parts:
>
> 1. save/restore/migrate the xstate of APX.
>    * APX xstate is a user xstate, but it reuses MPX xstate area in
>      un-compacted XSAVE buffer.
>    * To address this, QEMU will reject both APX and MPX if their CPUID
>      feature bits are set at the same (in Patch 1).
>
> 2. add related CPUIDs support in feature words.
>
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (2):
>   i386/cpu: Support APX CPUIDs
>   i386/cpu: Mark apx xstate as migratable
>
> Zide Chen (3):
>   i386/cpu: Add APX EGPRs into xsave area
>   i386/cpu: Cache EGPRs in CPUX86State
>   i386/cpu: Add APX migration support
>
>  target/i386/cpu.c          | 68 ++++++++++++++++++++++++++++++++++++--
>  target/i386/cpu.h          | 26 +++++++++++++--
>  target/i386/machine.c      | 24 ++++++++++++++
>  target/i386/xsave_helper.c | 14 ++++++++
>  4 files changed, 128 insertions(+), 4 deletions(-)
>
> --
> 2.34.1
>


