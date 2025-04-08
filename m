Return-Path: <kvm+bounces-42900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 794BEA7FBDB
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85F967A4D54
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241EE26E159;
	Tue,  8 Apr 2025 10:22:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD9126773D;
	Tue,  8 Apr 2025 10:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744107761; cv=none; b=HK2iIvXsSKjV3MOIxxIExOo5NOOZgj80yfVxy5sTIxsg9uUGUMdinyy340eqaEgfdbrsRJPfrPOsVpLvkYlI/m7kttEQx7MU9jCtZt8HIrG0vbQBarEjPYORFqdg+XQsNZd5Bulj6iA/qgZo7kmLJUQXcVH6VuYirHAdyiBkh5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744107761; c=relaxed/simple;
	bh=/m6+Ua66NFMhg2vNP8D7cOPQD3B82lw7pQYHz/7iMJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HSiD01YNpH6X2SE1D/G+Y3Q9bcIQ5r/ZTouGz0OcCaDdw5o7UXL2iHJD91nnZMUQBO+uZLdUxfqOrt0/MSKNPl5+TDlDEp9z07KBe55yF0fhfq5ijsjjw6lW2/HJ5/+tIXIHz7+L3pU/IpggU5OrL3JEN0BQSw/wUV9lkbaLRyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5262475372eso2472016e0c.2;
        Tue, 08 Apr 2025 03:22:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744107756; x=1744712556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SsrLZDcWMMgz5qw73ZarBN4RUT9hrtTKFIK6rblk8+Q=;
        b=tNPbBNVTJmxqGy0jBa5sryPPvZLd0AjZOY0EW6x4j9gRJqFYclTVMaO8LW8gQVB/bM
         bCdh58TuAH+1hrn/ISO5odB4hHO61djPWuWoWENQIC0LIXX6BlqjygiitdYA1EDMOZUR
         9RpFqxi415LWTHGgFYyDB3NP1jF0Y8izKd/2K6fiEnQzspzY4mNvlLUgDvaVJHxpBiKZ
         nI+EDZ4LdXMQh3WuHBxZcABhkbCWON8e9oIm32B3Qwgw8A0QjfQ4WojfovjD1VkpP1PU
         pV2hvo680JDC9QbJGvzj8k9U0qS3J4+gOZtAdR3/b91yjqgzdVcBh2GhA448a+TF04Lk
         BKmw==
X-Forwarded-Encrypted: i=1; AJvYcCVEA7qZAB3B0+kezkpOZpgk0SjQS40gZIxIESzH6D96qXVuMsUdgj6PHG88X971uVF5Rt8=@vger.kernel.org, AJvYcCVRBPWT8uBLQ2pIieSkrrdi36CASGl8wCATxc6NI5iOk2qS/IYbUIGn6hDRHxEmnKi2ocaf5/3VC2zk@vger.kernel.org, AJvYcCW4xIx1cdV944/IAeq2vpuEttUCkcpuBoBB5o+t0Xew1hIBPH/HlPJtcDjT76BPj1/KlmjTrYHP@vger.kernel.org, AJvYcCXOCCN05UNs0iOndHkTYX+x4JXPpo2PLSCzgfTpwcOi3bL/S8S5j0kF0nPxO5zDKvu87YQsDDCNLBr1TI5g/A==@vger.kernel.org, AJvYcCXPev8CqdRxG+Xu7jPmhtJRUOXcaZgCQ0a0mYGFYyaw/3tkMlw1a1lqY2iL/mCg1YX8AQMxnK5oqfvudA==@vger.kernel.org, AJvYcCXt+8xciHm8SAu+5DzuIYLk8qwPUHogEMjh6Ttay/FPrxE5evCGYor+AchUy94/KXPgc8YyRGu7YqZynbui@vger.kernel.org
X-Gm-Message-State: AOJu0YwBAB2zPTiiZS6jqcTOuZf7APe9hr8vImIqU+EMuNMm2hkugeCU
	gd4x1r+J7db561RAyE3/W/Rbq4rrTlC0IVrh6YJ2KBfWyMmEtVER10rWdlBG
X-Gm-Gg: ASbGncvjQ73/IidO/NQ91NS5qtSO59m6IlrsKIyjjtFcRJibIbPVoiENieSRxpNp+lh
	uRbwUG1185gFeP3POHRwcsvZ7d0q+f0rUUCtbU0ljkiA5HO78C4ESWTSmjCtOBRt0bVlGd+f/7V
	RQbRr4aHtdzeEUozREP4Gft8OiAZMjfQd0Y3eQ3eqbyQY+TslQQ0NiaZEW+RgY/HOyalBydLZ16
	ps38/LX6b2C4E0oFLy6APwz8Z+K5nV6qebkIUY2J2wCnvusCGUuwpz2anup3cSnE6//DzZMHfc/
	KWX33HFL457WVh4Dw2K292QuOQvAMbO8pB8LMJ8Eiw5R2q21IROSNRkyq0sgcyLrh3Rl9xTbOuS
	92F89+JU=
X-Google-Smtp-Source: AGHT+IFDb9okRj1xGl+mVbJRxzLLI3huCAhu6Vj0/hapZGGpzzktInrb/NA1bjOvWmUDk4T9v4AhDg==
X-Received: by 2002:a05:6122:30a0:b0:520:64ea:c479 with SMTP id 71dfb90a1353d-52765db445cmr10786694e0c.10.1744107756603;
        Tue, 08 Apr 2025 03:22:36 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5279b58aa78sm312255e0c.14.2025.04.08.03.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 03:22:35 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-86fbb48fc7fso2206333241.2;
        Tue, 08 Apr 2025 03:22:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU26zpE9mOwfcgFM6aU88kNEV5kwikJtj5z06kE2m/+57CVUHgY2V3uGPlYiGvtoyaVg7Jdo2WN+xQ2AHxK@vger.kernel.org, AJvYcCULmQuRAkXtLcIQO9HqD147pHXbhjEapTsJJUzpHy/kQYYr2Qm9Gh+sVVwAhgGmrSQ3EKBbjB3Y@vger.kernel.org, AJvYcCUM6Ee5Vc6o+EkKdsHAYGqA/Kefeyg55IhkJDIDmmb9iZtTa2z9F2cnfZBjzIyb30NlpMY=@vger.kernel.org, AJvYcCVpbCYx6DzQfXfmR1XhJxQBheurbgqdyuVMGzAyeoePydwz5AIwmy9UX7arvVrPnzEq2XLxiqX1VTlz//9HIA==@vger.kernel.org, AJvYcCXIHfyUViYpbZ0KEhCmcG0S90hiMl8oL/txVZ/G+HRfdTa3+OZR/DqYCL6f79RwtUA6uGTNIpIg43d0aA==@vger.kernel.org, AJvYcCXqgXc0+D7YC4+PSbm+1wmQWFqVWmNbZ0Ics+DQRTK5MNh2TQaDeZdzv0NUneaO61AzUF59TMa0xrCZ@vger.kernel.org
X-Received: by 2002:a05:6102:2b91:b0:4c4:e415:6737 with SMTP id
 ada2fe7eead31-4c856a8cf46mr12241766137.23.1744107755579; Tue, 08 Apr 2025
 03:22:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250407104025.3421624-1-arnd@kernel.org>
In-Reply-To: <20250407104025.3421624-1-arnd@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 8 Apr 2025 12:22:23 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWN=wurw7qz0t2ovMkUNu0BJRAMv_0U63Lqs2MGxkVnHw@mail.gmail.com>
X-Gm-Features: ATxdqUE9l7FjkqlZMDiGBpUM7CUSkyfcARh2bgkw-zOenNlQ3qLl0OOY1x_PRRI
Message-ID: <CAMuHMdWN=wurw7qz0t2ovMkUNu0BJRAMv_0U63Lqs2MGxkVnHw@mail.gmail.com>
Subject: Re: [RFC] PCI: add CONFIG_MMU dependency
To: Arnd Bergmann <arnd@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>, Carl Vanderlip <quic_carlv@quicinc.com>, 
	Oded Gabbay <ogabbay@kernel.org>, Takashi Sakamoto <o-takashi@sakamocchi.jp>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Dave Airlie <airlied@redhat.com>, Jocelyn Falempe <jfalempe@redhat.com>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Xinliang Liu <xinliang.liu@linaro.org>, 
	Tian Tao <tiantao6@hisilicon.com>, Xinwei Kong <kong.kongxinwei@hisilicon.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Yongqin Liu <yongqin.liu@linaro.org>, 
	John Stultz <jstultz@google.com>, Sui Jingfeng <suijingfeng@loongson.cn>, 
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Zack Rusin <zack.rusin@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, Javier Martinez Canillas <javierm@redhat.com>, 
	Jani Nikula <jani.nikula@intel.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
	Lijo Lazar <lijo.lazar@amd.com>, Niklas Schnelle <schnelle@linux.ibm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, linux-arm-msm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	linux1394-devel@lists.sourceforge.net, amd-gfx@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, virtualization@lists.linux.dev, 
	spice-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	netdev@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	kvm@vger.kernel.org, Greg Ungerer <gerg@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"

Hi Arnd,

CC Gerg

On Mon, 7 Apr 2025 at 12:40, Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> It turns out that there are no platforms that have PCI but don't have an MMU,
> so adding a Kconfig dependency on CONFIG_PCI simplifies build testing kernels
> for those platforms a lot, and avoids a lot of inadvertent build regressions.
>
> Add a dependency for CONFIG_PCI and remove all the ones for PCI specific
> device drivers that are currently marked not having it.
>
> Link: https://lore.kernel.org/lkml/a41f1b20-a76c-43d8-8c36-f12744327a54@app.fastmail.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for your patch!

> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -21,6 +21,7 @@ config GENERIC_PCI_IOMAP
>  menuconfig PCI
>         bool "PCI support"
>         depends on HAVE_PCI
> +       depends on MMU
>         help
>           This option enables support for the PCI local bus, including
>           support for PCI-X and the foundations for PCI Express support.

While having an MMU is a hardware feature, I consider disabling MMU
support software configuration.  So this change prevents people from
disabling MMU support on a system that has both a PCI bus and an MMU.
But other people may not agree, or care?

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

