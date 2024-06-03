Return-Path: <kvm+bounces-18662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEFC8D84D3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CAB41C2168F
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845ED12EBE7;
	Mon,  3 Jun 2024 14:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VXt2TIsx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F64E12E1DC
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717424549; cv=none; b=DuSu0fbxxBRDZOob0G6/fnDgMBHYhKQjR8X6Qk54YDa5wwDXqwhMytCNScRxRSqYIQ2PYFfYXhVRZKB2NW3eP3WGcdOIU+0VxSSetuSyM1jgAyfx0naPLd0Qglg2ezL59vN29briLaznmB6+qsIMzRp06Hj9CVY4VQR6qEZJPzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717424549; c=relaxed/simple;
	bh=KQvYYPZVusE+Uvlt8F63g/RCDoWSfgOSxIlNUzzcSQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HXYMvcKXihGtGMBm7r8pwI8+nfkdD3fQQLiNFlQ4ew3fvRdEU9dgkx6OZjFQn/PS/WM4CV7js9ax1sfNg9+CHxn5J5jVssF5bx6lLIprzCUXJvZt8Z1FldmHGRparGlfs+c0VJc3ZWx42R5ranxH/HSxeVuI287v1d+taaNHYJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VXt2TIsx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717424547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=efLqh7H5R1H2MCstarX4MnmJFfDoGl/LnoB3y6f71Jo=;
	b=VXt2TIsx8UHO3laOEdmErNj89gV8b4GLohyIKPJgX9Oid7dmW6QaeEgEZGKz/2mJTTPAgh
	T4TNS8GaFDNfndde/CYvRYFx6bYG6Hh0ksOulhSD4ZT5fpMcGRh3ivma1DeEoT8u9yU5cm
	h+hsoOZPoncgx5PukQPAWW5AkzSDAik=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-A2HAInZIPR--HyCWigzi-w-1; Mon, 03 Jun 2024 10:22:25 -0400
X-MC-Unique: A2HAInZIPR--HyCWigzi-w-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3580f213373so2931552f8f.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 07:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717424544; x=1718029344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=efLqh7H5R1H2MCstarX4MnmJFfDoGl/LnoB3y6f71Jo=;
        b=N9H7TfPj9qg4+srWoYjOXx2JWl/DzJw2TtYLOWR2fCHWeV0lkI4zsVhfv2TvNZ8EfH
         qPaIemQ38EUHgM1kkZdu6RPhiKy82hL852P+2/Guy/DH5lFFu+cPKy0THf5m/QXXdYRP
         8HQlStdaYQXIPCkp3T0SjPMDUccnsiTK2LCjKxnbFu+sgBKAyoE1njs/69lyh1iGtoPV
         dL8FzIlY9Ck1H+wULNoXblfTAobCyXJEC2t5lj6XRxqb0JIqQ/tZ4n3dE5tsQ5alB/GN
         rQF4kMv2DW74lV74l7xRYZRVphQpgXxKuBjcCTZnSZwNEd2+h75ix0wZETXwSTUlI6Ar
         lChw==
X-Forwarded-Encrypted: i=1; AJvYcCVK5zvSFIv3JSnIdN0mNrkjRPhQE/ph5TA/idB5uRTC39rXox9gqpKzTKOLcTrji2vAQ+BOlHybKila7L6QJXKP50bn
X-Gm-Message-State: AOJu0Yxy1DeRj30B56fxBaCuVt51S9Ceu+zFygPs1W7om+7zbGUzhstC
	0k40E1j6peM30sc1XJWd6oBs7IGMJ3mue0dwkw/nMqTcQnr47I0RW5tMZ4cuAEO3hlLOFvWDlXX
	3ovQAKo6oOOn8N341KTLsz3nYhxEITAFdCo+BOar33tjh1X9GS+ffL9UyaM82d0bm20e+axMOAv
	ervznlJtx4NaUF9rzuvdTIsdJZ
X-Received: by 2002:adf:fecb:0:b0:357:ff92:aae7 with SMTP id ffacd0b85a97d-35e0f25c3e6mr6739795f8f.2.1717424544717;
        Mon, 03 Jun 2024 07:22:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH67uOr9eOqicMCPNEhJhZpPzutpMuvtEFRvQ9siWY62a4sbnmkxWF/LwmjxcRZntnhm0yGRx+NDnbedJ/adBI=
X-Received: by 2002:adf:fecb:0:b0:357:ff92:aae7 with SMTP id
 ffacd0b85a97d-35e0f25c3e6mr6739776f8f.2.1717424544320; Mon, 03 Jun 2024
 07:22:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <CABgObfYFryXwEtVkMH-F6kw8hrivpQD6USMQ9=7fVikn5-mAhQ@mail.gmail.com>
 <CABgObfbwr6CJK1XCmmVhp83AsC2YcQfSsfuPFWDuxzCB_R4GoQ@mail.gmail.com>
 <621a8792-5b19-0861-0356-fb2d05caffa1@amd.com> <CABgObfbrWNB4-UzHURF-iO9dTTS4CkJXODE0wNEKOA_fk790_w@mail.gmail.com>
 <05d89881-bdbd-8b85-3330-37eae03e6632@amd.com> <3j2llxlh3gzyn33n6uo7o5jdx4dmi4rzbax5buluof5ru2paii@2ze452jtocth>
In-Reply-To: <3j2llxlh3gzyn33n6uo7o5jdx4dmi4rzbax5buluof5ru2paii@2ze452jtocth>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Jun 2024 16:22:10 +0200
Message-ID: <CABgObfa5Bnm2vNcHqyo+DbXET2aZrmH5C6h7HV=6Qio7bKVTsw@mail.gmail.com>
Subject: Re: [PATCH v4 00/31] Add AMD Secure Nested Paging (SEV-SNP) support
To: Michael Roth <michael.roth@amd.com>
Cc: "Gupta, Pankaj" <pankaj.gupta@amd.com>, qemu-devel@nongnu.org, brijesh.singh@amd.com, 
	dovmurik@linux.ibm.com, armbru@redhat.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 4:16=E2=80=AFPM Michael Roth <michael.roth@amd.com> =
wrote:
> Paolo mentioned he dropped the this hunk from:
>
>   hw/i386: Add support for loading BIOS using guest_memfd
>
>   diff --git a/hw/i386/x86.c b/hw/i386/x86.c
>   index de606369b0..d076b30ccb 100644
>   --- a/hw/i386/x86.c
>   +++ b/hw/i386/x86.c
>   @@ -1147,10 +1147,18 @@ void x86_bios_rom_init(MachineState *ms, const =
char *default_firmware,
>        }
>        if (bios_size <=3D 0 ||
>            (bios_size % 65536) !=3D 0) {
>   -        goto bios_error;
>   +        if (!machine_require_guest_memfd(ms)) {
>   +            g_warning("%s: Unaligned BIOS size %d", __func__, bios_siz=
e);
>   +            goto bios_error;
>   +        }
>
> without that, OVMF with split CODE/VARS won't work because the CODE
> portion is not 64KB aligned.
>
> If I add that back the split builds work for qemu-coco-queue as well.
>
> We need to understand why the 64KB alignment exists in the first place, w=
hy
> it's not necessary for SNP, and then resubmit the above change with prope=
r
> explanation.

I think it was only needed to make sure that people weren't using
"unpadded" BIOS (not OVMF) binaries. I think we can delete it
altogether, and it can be submitted separately from this series.

> However, if based on Daniel's comments we decide not to support split
> CODE/VARS for SNP, then the above change won't be needed. But if we do,
> then it goes make sense that the above change is grouped with (or
> submitted as a fix-up for):

Yes, I think we want to go for a variable store that is not "right
below BIOS". The advantage of something that isn't pflash-based is
that it can be used by any code-only firmware binary.

Paolo


