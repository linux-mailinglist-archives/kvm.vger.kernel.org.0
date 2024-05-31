Return-Path: <kvm+bounces-18534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4976F8D61D0
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 14:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 040EF285A56
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 12:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A65158859;
	Fri, 31 May 2024 12:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZzfHS6AP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978EB1586C4
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717158838; cv=none; b=q6xO2x+A+DSuACrYKQkPDDtCmFoEht8m2bQfXYovKjprpfRtqL92asle1a4W/iKfYHZ9h5PicRF0e4iwQw9v018ExJBA+1q8Ytff6PbTktK5Ltby05dKlFRDObEPZD9t+Y17/GR41vpCwOUEZv7BZqqCt6na8w8Q874I8OBeX3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717158838; c=relaxed/simple;
	bh=FWgECsGfJI9v74xMXI+WJ3NI1fwkq1VdiaF/g31OUbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZQ5pbSF2oZJmTnYDmMdx8UijRhsZsgARdfUdKb8nSg0N3AxCVnN9sRpPkp9QxWWWOfQWOsERnVBiJM0lcD+FIzwsrTU3c1MMFeoBB7uHQ75GnYwTboGrDhB4SecYFleYrV3IsKjRgM43plXj7F+Jg/g5IQrqP7Oj2wSamvNzuR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZzfHS6AP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717158835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0Up6NdBkRgjmDLWyJob6XY0DIAMH1Tn7MWcPIWCuTY=;
	b=ZzfHS6APiQn1h05EYcSi0Zwbb2dBWbF53VletLIi6Rpmb6eAQa6S7uK6vJf4lswrRvNJ/C
	N2MfXnSAp+jFBcgDLRJXk68CFSAOj8/MUAJ9rmitxHf+p+TzXxr6cPEAyMgqE7gip0ML/A
	ge+Gtbc2MJ1yvX4STd8QFj7ZXhfoDV0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-GTduY3mIOziuCOhbYrkHhA-1; Fri, 31 May 2024 08:33:54 -0400
X-MC-Unique: GTduY3mIOziuCOhbYrkHhA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35dcb574515so984625f8f.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 05:33:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717158833; x=1717763633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0Up6NdBkRgjmDLWyJob6XY0DIAMH1Tn7MWcPIWCuTY=;
        b=U46+egu/KG7WaUd0t++whFynD1uUKkOcPTzSrtmyboJhrDrG5ovwojtK1MaZpsv06v
         lIAZXsj6Ky4CKHGZl67fn1QWdpW79oMLwoF0/Jy4ZCBfNZSGktZoPhPcMTbTtC/jYLVp
         ndUiiWadPcxkUkNwW231v+1iIoL6KOG/giaikzO3QJhlrXra9cdpQmEJFmLxYPAiLEZj
         sr3o2702JzyXF3FWVuHq9JilgRwp1Fl05yL/yeGjgIX96CEzFuG/A6MoXXJPflwrH0Fb
         GgjL0F05IzXUa9j7ZGUMBLLIdHi1nBe8CwLaSuukRHkM48gbbDLwFn3P6IdviGyGL1IF
         C1Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVkT0Li1npVFctmNgJVD41WMPdhbB5dHCyuZ2/etqoRTUkmzogbi6Y51OlgkRar5IeecpctuGSdRuAe72jYwChQcCJ8
X-Gm-Message-State: AOJu0Yxn6cSujhT6ZR/ZbGElBa98XiaNNHNmyGIafZl6S0kdx9we5irL
	0gvgnV9TrfgKHa4tL2RHnnN0l/pWO9Z9fsC+80Xq3ahATHsYmA/kaymsWBIwxV9hrOMsL7kCjH9
	N70kNl97NbBYQGYBNy5IcL1SXdmdiXzLwMq45jqqbk4Lf34QgbJaUsuo+MPDUpjNDMsT7JfJzhq
	qen8KG/yjULL2S+8hbOLTXZgoZ
X-Received: by 2002:adf:cd8b:0:b0:355:161:b7e6 with SMTP id ffacd0b85a97d-35e0f2879abmr1254336f8f.41.1717158833060;
        Fri, 31 May 2024 05:33:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAbWZ++3Kxz8loXJ5rJzTrFeHLsmVYmj/RgQdDDla4kiYPvCN4bCqa/jqdkI7z3R7Gfzt/kunUuX4KP22LeBw=
X-Received: by 2002:adf:cd8b:0:b0:355:161:b7e6 with SMTP id
 ffacd0b85a97d-35e0f2879abmr1254316f8f.41.1717158832634; Fri, 31 May 2024
 05:33:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-30-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-30-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 14:33:39 +0200
Message-ID: <CABgObfbMBdm5_vr36aX9cYYRaaLWp6+Y1AKo9YtUbVbKX897sQ@mail.gmail.com>
Subject: Re: [PATCH v4 29/31] hw/i386/sev: Allow use of pflash in conjunction
 with -bios
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index def77a4429fb24e62748
> +static void pc_system_flash_map(PCMachineState *pcms,
> +                                MemoryRegion *rom_memory)
> +{
> +    pc_system_flash_map_partial(pcms, rom_memory, 0, false);
> +}
> +
>  void pc_system_firmware_init(PCMachineState *pcms,
>                               MemoryRegion *rom_memory)
>  {
> @@ -238,9 +248,12 @@ void pc_system_firmware_init(PCMachineState *pcms,
>          }
>      }
>
> -    if (!pflash_blk[0]) {
> +    if (!pflash_blk[0] || sev_snp_enabled()) {
>          /* Machine property pflash0 not set, use ROM mode */
>          x86_bios_rom_init(X86_MACHINE(pcms), "bios.bin", rom_memory, fal=
se);
> +        if (sev_snp_enabled()) {
> +            pc_system_flash_map_partial(pcms, rom_memory, 3653632, true)=
;
> +        }

This number is a bit too specific. :)

The main issue here is that we want to have both a ROM and a
non-executable pflash device.

I think in this case (which should be gated by
machine_require_guest_memfd(MACHINE(pcms)), just like in earlier
patches), we need to:

1) give an error if pflash_blk[1] is specified, i.e. support only one
flash device

2) possibly, give a warning if -bios is _not_ specified.

3) map pflash_blk[0] below the BIOS ROM and expect it to be just the variab=
les

The need to use -bios for code and pflash0 (if desired) for variables
also needs to be documented of course.

Some parts of this patch can be salvaged, others are not needed
anymore... I'll let you figure it out. :)

Paolo


