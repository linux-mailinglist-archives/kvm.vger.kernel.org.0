Return-Path: <kvm+bounces-37004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BC2A2428B
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 19:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F394188A8DB
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 18:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0401F12F6;
	Fri, 31 Jan 2025 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NpIaPWIC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938C11386C9
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738348060; cv=none; b=rPMp0quyHrIrxSxbtwvvNiJy22sIZEkmNy/HcG6a2UFw6z+4vdnGAV8NBaDsnw/r+c1efadMw1zqoepU3hYzLuXHv5EMaG7Lm6TZd5jgWNSbWA9XATLDOeNQFbNt//4nZcieJ+TlBTkmXNmZdf+0sQt5DSel3/fWXT9aPKZ+dc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738348060; c=relaxed/simple;
	bh=E3SSmBOuq6nxgCnunfdAZNobY0GQrjjcCKMWy6VKj5g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B8Qat+fDxMwkiChrqcELc9/MNdpHEB8eqqK4aCSksiHVC6jgmRdmOq7o/dOKrlwoNCARj/MmcM/ug8TapYe5AnKtAXYDJvnV35SBPiA80BBowTqb7Sac592paxuS53GCoQBgE+flTULitQmSW+Vn2v8P/qM0DWamMDUPx8CvGjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NpIaPWIC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738348057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fgF0oxOuv/c51hzbPAf4dzHnxocuQUHifZqvhBl13E=;
	b=NpIaPWICaKqMKcv7oW3pHdWl38WFZXMM4fibFhyxWfPcDOXBLK4Dlc/IFuAUpqCkM0D4Tj
	rffdA+8JhHd07fuSqmsxxLRx5g13a9KyS1ylLi7goVqPQKGpAJ1R3FdKao1fym4n/VrOTQ
	q82CGFKR3nbNXbMkWcfZxOcykD/RWn8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-Hxn_Gl3zO-G9uf5HghmK6w-1; Fri, 31 Jan 2025 13:27:35 -0500
X-MC-Unique: Hxn_Gl3zO-G9uf5HghmK6w-1
X-Mimecast-MFC-AGG-ID: Hxn_Gl3zO-G9uf5HghmK6w
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43628594d34so11626355e9.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 10:27:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738348054; x=1738952854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fgF0oxOuv/c51hzbPAf4dzHnxocuQUHifZqvhBl13E=;
        b=ncJH1wi5f7fQ7iu5p+F5Da/A7+kb7OsqkIB02r2ztVOdLGdHFCQEpo9xXUCBXm2Fw6
         17qx5XYzAoo/GxuwqeyfWOMjFtE7JQMc/+Hdpw96ARGYIjbRoZKPk5TcRPN2R+VSOhDn
         oExwX9yq+hq/hruDThWEOz8ZEiboOWSUvApHYWAT5Rvhan0VBahN23ntSujEzbZ4NPvU
         j5sisC0N8zYqDr9fthVTMpxBU16kwJfes6uvB6Glhdy21D3g27RglehAM39K8bAmklHG
         0R8YebFfXdwyd64W4efbvt7iYePhPtmnaZ1btqXaby6IEXx3bzezlliQPq1Lxv9Soeps
         n1oA==
X-Forwarded-Encrypted: i=1; AJvYcCVH8cg66T88/oB4DRX1RLILlUxYHJiemRvGgfgBYxi1DaKIjHMOsU0mTntSTsd0p5NsKa8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDFIgWBKqfmOxi4pphZYzPeIHYKsR6YAG6P7b9WlDT3itNlA0S
	Inz1aVKCKdpZu1TkDtKywp6YIsBlgd2reSP9Vb+F2zSaj9vI/SrfxmgnIjbQE1znmRywxrvajtb
	5I2DS7rvfEiz2j35o25BuGH4O8IQ8Uaa1J2AiZcYibV3HjLSsaG8rfEPRjMZxLALYN+jaahZZVy
	xsmeYUOhPmAWeUO4yWxe0RAl6E
X-Gm-Gg: ASbGncsgI84NtJWoo2h8V0lLkK/Lo0BZDgIZlg6+a+wMn0Hi/LDWuRjLCzdkTUMLwCc
	am3tubynN8Z1pG5yIByTtJursz7TH3Mgjcd13nUsuhVLRtbKkGU/RDAjRaJGe
X-Received: by 2002:a5d:5288:0:b0:385:ed16:c91 with SMTP id ffacd0b85a97d-38c51b5df32mr7816830f8f.24.1738348054495;
        Fri, 31 Jan 2025 10:27:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjuSbM/qrVKiJ05icQUERlIhJRq8RcsL/5gDAvCAbWvG68rjTFDEsT514JBExK6jOm9Ro8GRryOPSZjNzpsHo=
X-Received: by 2002:a5d:5288:0:b0:385:ed16:c91 with SMTP id
 ffacd0b85a97d-38c51b5df32mr7816808f8f.24.1738348054184; Fri, 31 Jan 2025
 10:27:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124132048.3229049-1-xiaoyao.li@intel.com> <20250124132048.3229049-52-xiaoyao.li@intel.com>
In-Reply-To: <20250124132048.3229049-52-xiaoyao.li@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 Jan 2025 19:27:23 +0100
X-Gm-Features: AWEUYZkOCXHaRFghbH3lPJIDTaOq5XDRPgCRkvXwg6ltj_mr-tmQcXbYqf1FsWk
Message-ID: <CABgObfb5ruVO2sxLCbZobiaqX-3h9Q+UKOZnp_hhxfJA=T-OJA@mail.gmail.com>
Subject: Re: [PATCH v7 51/52] i386/tdx: Validate phys_bits against host value
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2025 at 2:40=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> For TDX guest, the phys_bits is not configurable and can only be
> host/native value.
>
> Validate phys_bits inside tdx_check_features().

Hi Xiaoyao,

to avoid

qemu-kvm: TDX requires guest CPU physical bits (48) to match host CPU
physical bits (52)

I need options like

-cpu host,phys-bits=3D52,guest-phys-bits=3D52,host-phys-bits-limit=3D52,-kv=
m-asyncpf-int

to start a TDX guest, is that intentional?

Thanks,

Paolo

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/host-cpu.c | 2 +-
>  target/i386/host-cpu.h | 1 +
>  target/i386/kvm/tdx.c  | 8 ++++++++
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
> index 3e4e85e729c8..8a15af458b05 100644
> --- a/target/i386/host-cpu.c
> +++ b/target/i386/host-cpu.c
> @@ -15,7 +15,7 @@
>  #include "system/system.h"
>
>  /* Note: Only safe for use on x86(-64) hosts */
> -static uint32_t host_cpu_phys_bits(void)
> +uint32_t host_cpu_phys_bits(void)
>  {
>      uint32_t eax;
>      uint32_t host_phys_bits;
> diff --git a/target/i386/host-cpu.h b/target/i386/host-cpu.h
> index 6a9bc918baa4..b97ec01c9bec 100644
> --- a/target/i386/host-cpu.h
> +++ b/target/i386/host-cpu.h
> @@ -10,6 +10,7 @@
>  #ifndef HOST_CPU_H
>  #define HOST_CPU_H
>
> +uint32_t host_cpu_phys_bits(void);
>  void host_cpu_instance_init(X86CPU *cpu);
>  void host_cpu_max_instance_init(X86CPU *cpu);
>  bool host_cpu_realizefn(CPUState *cs, Error **errp);
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index bb75eb06dad9..c906a76c4c0e 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -24,6 +24,7 @@
>
>  #include "cpu.h"
>  #include "cpu-internal.h"
> +#include "host-cpu.h"
>  #include "hw/i386/e820_memory_layout.h"
>  #include "hw/i386/x86.h"
>  #include "hw/i386/tdvf.h"
> @@ -838,6 +839,13 @@ static int tdx_check_features(X86ConfidentialGuest *=
cg, CPUState *cs)
>          return -1;
>      }
>
> +    if (cpu->phys_bits !=3D host_cpu_phys_bits()) {
> +        error_report("TDX requires guest CPU physical bits (%u) "
> +                     "to match host CPU physical bits (%u)",
> +                     cpu->phys_bits, host_cpu_phys_bits());
> +        exit(1);
> +    }
> +
>      return 0;
>  }
>
> --
> 2.34.1
>


