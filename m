Return-Path: <kvm+bounces-24352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E55DD9541A2
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 08:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73728282246
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 06:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DF28063C;
	Fri, 16 Aug 2024 06:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xzr8nGcf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BA510E6
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 06:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723789295; cv=none; b=A0iuGt42aA4W5ow0H53f7dME6XMyUUao/09r9Rn6WV75yzEJPEkF6S/PFaQe+Gri8CXR9MEYZ9wq4PmptYYO77kwDLwfSx9+pPi96JV7PfL/s8eGmR+yT98wWmZr/7dBmFBnJT7HowqiTNzlMaaAJ7f/4TaBPmoHi8nbYVNwqW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723789295; c=relaxed/simple;
	bh=YevXxj7zc/iXq+uoWkst4jsOzgvOpPjgx4xyyCj/0TY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RWePJLmGz1nMk3FD3nYHl/8O5BlcXFOsqtwP7SuzTwTzq9DYOMwt+G62rbrIdbquPP4y6wT5wBpjR+FHUeONRReyLBj92abH50tFL7iqyhEiYNnfet6Y/GfEeTRz84wIxe8t1F6UagxRCArVwdg8/63l9eN13zx5m2U5/d2186M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xzr8nGcf; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2f3bfcc2727so8137591fa.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 23:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723789292; x=1724394092; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gN/IDNnIVqePOUl3+INdjUuo1e/RhZoKy6s/qPCWKbQ=;
        b=Xzr8nGcf/GC09zXF6y2Lmont8ViByzNInT0jQv3pDJN4B24NWja7Pu4ZVXxuAtfx+P
         miljut6hXMEjwZNS00zrZouCNrU4X1KMLFjWXIRd1NykljkOPnxXawQwHnSbTQlA75vY
         zZ5M7Ju2s2My7AEIIyVmtAg+DK2bLj0h8LjJhI8WiO8RWdEdur23W+Ky0tcm13dfucbB
         r+AeqyJiy+JUorcWWsW7LC59x0rKecObNHeptAzTNLhkWujf1uULIfAp2N5ZsjVev2WW
         gv+fGTRR95EQTlwsHNK9mA6TfxBEz028aJL5QqDt9IvlWNuRICpZxEvXoOGAn4ICeCX1
         IARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723789292; x=1724394092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gN/IDNnIVqePOUl3+INdjUuo1e/RhZoKy6s/qPCWKbQ=;
        b=I4aN2WzQiRS9DfN6L1trK7klKsDVJbbmL8xcicUeTL4BzJgg4VUNP3BjMQiM8KkVqs
         jkw026LTP147EFTFkyw5/uPK8lFty3Q2BgTRyPqgCfQ7Mf/stEM3FXWjiI3yoNVW5HFu
         MI4ppZA7MPXiVTUxox/iayhnZpr1kcxvkfLC3aymdY2568sFEn3jzsgFUCNSNX8oy9Ye
         apM5+XDL7NqTT0Uh38gW9OAo0HzRft3kkcFT7TcQpVSFXyuSS1h88gsTQGlRzCcNFqlm
         gg6p2EXYHBf0+0BlOpjz+tBt+W84QK9wqqzrRVFoOqUGnMBkH8cZjUA2CvP/fnA32sT3
         M9jw==
X-Forwarded-Encrypted: i=1; AJvYcCVQsaqx6FmybeGtiRBQ0Zt8KG71MI3+LMLSv6k/ECrp5stDqSokLdeIr5jkJEav048mHHHlSIJ598e6P7XhC57JeXj0
X-Gm-Message-State: AOJu0YzUOfWLku2AaiDcUH6YYienYz0hQPewEZcRDI5US70CP3sTmOxM
	FDBsczXhkswZog5DZh7jNpXim0Xig30fFLlbLlVd4RL/XSvdtgi1ux2+y5SHXOhuIXdgMqXFp7z
	E5Po=
X-Google-Smtp-Source: AGHT+IEa2KUSICyrEZCI46tZGlAlao5lx1DfUbEZ5609WVaQc4E2Td19rNhAnjAalT5tjPNh2pYAaQ==
X-Received: by 2002:a05:6512:118e:b0:52c:76ac:329b with SMTP id 2adb3069b0e04-5331c6bdaeemr1283662e87.35.1723789291403;
        Thu, 15 Aug 2024 23:21:31 -0700 (PDT)
Received: from [192.168.69.100] (cor91-h02-176-184-30-185.dsl.sta.abo.bbox.fr. [176.184.30.185])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a838396d4b2sm205670166b.220.2024.08.15.23.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 23:21:30 -0700 (PDT)
Message-ID: <31202ec6-d108-4dd9-a103-f534f36c2821@linaro.org>
Date: Fri, 16 Aug 2024 08:21:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] kvm: replace fprintf with error_report/printf() in
 kvm_init()
To: Ani Sinha <anisinha@redhat.com>, Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>, kvm@vger.kernel.org,
 qemu-devel <qemu-devel@nongnu.org>
References: <20240809064940.1788169-1-anisinha@redhat.com>
 <8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org>
 <CAK3XEhM+SR39vYxG_ygQ=hCj_bmDE3dOH6EPFQZbLYrE-Yj-ow@mail.gmail.com>
 <CAK3XEhPZ8X1-Ui6pJ+kYY3Er-N-zW0f5MqpLyaU7t2d3qaQXkA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAK3XEhPZ8X1-Ui6pJ+kYY3Er-N-zW0f5MqpLyaU7t2d3qaQXkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/8/24 11:59, Ani Sinha wrote:
> 
> 
> On Mon, 12 Aug, 2024, 3:23 pm Ani Sinha, <anisinha@redhat.com 
> <mailto:anisinha@redhat.com>> wrote:
> 
>     On Fri, Aug 9, 2024 at 2:06 PM Philippe Mathieu-Daudé
>     <philmd@linaro.org <mailto:philmd@linaro.org>> wrote:
>      >
>      > Hi Ani,
>      >
>      > On 9/8/24 08:49, Ani Sinha wrote:
>      > > error_report() is more appropriate for error situations.
>     Replace fprintf with
>      > > error_report. Cosmetic. No functional change.
>      > >
>      > > CC: qemu-trivial@nongnu.org <mailto:qemu-trivial@nongnu.org>
>      > > CC: zhao1.liu@intel.com <mailto:zhao1.liu@intel.com>
>      >
>      > (Pointless to carry Cc line when patch is already reviewed next line)
>      >
>      > > Reviewed-by: Zhao Liu <zhao1.liu@intel.com
>     <mailto:zhao1.liu@intel.com>>
>      > > Signed-off-by: Ani Sinha <anisinha@redhat.com
>     <mailto:anisinha@redhat.com>>
>      > > ---
>      > >   accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
>      > >   1 file changed, 18 insertions(+), 22 deletions(-)
>      > >
>      > > changelog:
>      > > v2: fix a bug.
>      > > v3: replace one instance of error_report() with error_printf().
>     added tags.
>      > >
>      > > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>      > > index 75d11a07b2..5bc9d35b61 100644
>      > > --- a/accel/kvm/kvm-all.c
>      > > +++ b/accel/kvm/kvm-all.c
>      > > @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>      > >       QLIST_INIT(&s->kvm_parked_vcpus);
>      > >       s->fd = qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>      > >       if (s->fd == -1) {
>      > > -        fprintf(stderr, "Could not access KVM kernel module:
>     %m\n");
>      > > +        error_report("Could not access KVM kernel module: %m");
>      > >           ret = -errno;
>      > >           goto err;
>      > >       }
>      > > @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>      > >           if (ret >= 0) {
>      > >               ret = -EINVAL;
>      > >           }
>      > > -        fprintf(stderr, "kvm version too old\n");
>      > > +        error_report("kvm version too old");
>      > >           goto err;
>      > >       }
>      > >
>      > >       if (ret > KVM_API_VERSION) {
>      > >           ret = -EINVAL;
>      > > -        fprintf(stderr, "kvm version not supported\n");
>      > > +        error_report("kvm version not supported");
>      > >           goto err;
>      > >       }
>      > >
>      > > @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
>      > >       } while (ret == -EINTR);
>      > >
>      > >       if (ret < 0) {
>      > > -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d
>     %s\n", -ret,
>      > > -                strerror(-ret));
>      > > +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
>      > > +                    strerror(-ret));
>      > >
>      > >   #ifdef TARGET_S390X
>      > >           if (ret == -EINVAL) {
>      > > -            fprintf(stderr,
>      > > -                    "Host kernel setup problem detected.
>     Please verify:\n");
>      > > -            fprintf(stderr, "- for kernels supporting the
>     switch_amode or"
>      > > -                    " user_mode parameters, whether\n");
>      > > -            fprintf(stderr,
>      > > -                    "  user space is running in primary
>     address space\n");
>      > > -            fprintf(stderr,
>      > > -                    "- for kernels supporting the
>     vm.allocate_pgste sysctl, "
>      > > -                    "whether it is enabled\n");
>      > > +            error_report("Host kernel setup problem detected.
>      >
>      > \n"
>      >
>      > Should we use error_printf_unless_qmp() for the following?
> 
>     Do you believe that qemu_init() -> configure_accelerators() ->
>     do_configure_accelerator,() -> accel_init_machine() -> kvm_init()  can
>     be called from QMP context?
> 
> 
> To clarify, that is the only path I saw that calls kvm_init()

We don't know whether this code can end refactored or not.
Personally I rather consistent API uses, since snipped of
code are often used as example. Up to the maintainer.

>      >
>      > " Please verify:");
>      > > +            error_report("- for kernels supporting the
>     switch_amode or"
>      > > +                        " user_mode parameters, whether");
>      > > +            error_report("  user space is running in primary
>     address space");
>      > > +            error_report("- for kernels supporting the
>     vm.allocate_pgste "
>      > > +                        "sysctl, whether it is enabled");
>      > >           }
>      > >   #elif defined(TARGET_PPC)
>      > >           if (ret == -EINVAL) {
>      > > -            fprintf(stderr,
>      > > -                    "PPC KVM module is not loaded.
>      >
>      > \n"
>      >
>      > Ditto.
>      >
>      > " Try modprobe kvm_%s.\n",
>      > > -                    (type == 2) ? "pr" : "hv");
>      > > +            error_report("PPC KVM module is not loaded. Try
>     modprobe kvm_%s.",
>      > > +                        (type == 2) ? "pr" : "hv");
>      > >           }
>      > >   #endif
>      > >           goto err;
>      > > @@ -2526,9 +2522,9 @@ static int kvm_init(MachineState *ms)
>      > >                           nc->name, nc->num, soft_vcpus_limit);
>      > >
>      > >               if (nc->num > hard_vcpus_limit) {
>      > > -                fprintf(stderr, "Number of %s cpus requested
>     (%d) exceeds "
>      > > -                        "the maximum cpus supported by KVM
>     (%d)\n",
>      > > -                        nc->name, nc->num, hard_vcpus_limit);
>      > > +                error_report("Number of %s cpus requested (%d)
>     exceeds "
>      > > +                             "the maximum cpus supported by
>     KVM (%d)",
>      > > +                             nc->name, nc->num, hard_vcpus_limit);
>      > >                   exit(1);
>      > >               }
>      > >           }
>      > > @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
>      > >       }
>      > >       if (missing_cap) {
>      > >           ret = -EINVAL;
>      > > -        fprintf(stderr, "kvm does not support %s\n%s",
>      > > -                missing_cap->name, upgrade_note);
>      > > +        error_printf("kvm does not support %s\n%s",
>      > > +                     missing_cap->name, upgrade_note);
>      >
>      > Similarly, should we print upgrade_note using
>     error_printf_unless_qmp?
>      >
>      > >           goto err;
>      > >       }
>      > >
>      >
> 


