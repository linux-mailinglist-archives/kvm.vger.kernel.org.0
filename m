Return-Path: <kvm+bounces-62483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 450C0C44EE9
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 05:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 95F1A4E6671
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D415D23B62B;
	Mon, 10 Nov 2025 04:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="geke9eFc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ABC18C31
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 04:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762750490; cv=none; b=b83gtRhyJlYNf1GKgjIyvGO5hd0zSkammI0aYAp0GRJzfCxFGqpHmClJnZyemUwlwBadiZ46EIebn3Zoe5Py8FbeLARygJyw72ITwJwiwnQqcVNIXmEm/QMIAezT6qdu/ccANSjxOJFyYCet4BBaasp3pX3ryuAJXdO8lH8Anag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762750490; c=relaxed/simple;
	bh=+ADw/NKu8bLv/bHZ//dWF7yM0OuiWyEwOUxVQQPdd/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L2K1J/neKTezRkeVfqa2GGbVOS5WXRxKncHzRW8hu33dPQFinogIyt372uNhCqSGNg4LoRasKM84ubbPH6cAvuEdLcVWkGlxfR2hJdvcCLjvWZazb+2EVAnegPL47Y4O/Tc2hvrLshwsppjC20SlTd8Cy8eCwxr+TqEs020IqO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=geke9eFc; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed6ca52a0bso381141cf.1
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 20:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762750487; x=1763355287; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6iMcslIvoGeK2ivHIbP/bwE4kKToPkBygPUdlLLCs7s=;
        b=geke9eFcitXOHMdKWYRuiNTYnRRsix4XJuEcs7GfqmUKKsWiMdUQ7wENiwkGEk68Lb
         DE5EUN9YJDBGQB6e5V2BJgJlN2ctFYKMOllAfbz7EAVwLIdbQ14ugCvMG2/FqisLvjcO
         BEfwjkWJ3107QOaSUN7xGTRFbLRQx90hR6e8VxD12Q/Uzxb1Zf/ZkFwNyVyVq/06YE8E
         4EHspR5Oe8m9tg4WdC7Yc/K7Q3CVW97YRas05MYUsjGIDsv12bbCIo2/z3A/hSOXsSBL
         Lr9V7EaV4Y/7OEPH/Fy+c3uLffbOCEJ6S25k+7T8DSI25Ht2Vladp4cxG3y4r0otgQJo
         DTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762750487; x=1763355287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6iMcslIvoGeK2ivHIbP/bwE4kKToPkBygPUdlLLCs7s=;
        b=TIP+aFWsGZinX0jh1LhzSwZlBwiFqdUWbm5NtsqfrGwn7Fh9VFjhQL5Lc/DhVK8uzM
         ZrWv+uZQr4ObkF9gatL6Vy+eC11DOm1KcMXYGqYuyieFL/5dSNAvjB9A6XeCMUc1K2w9
         pxjRmYY/tIrQ++QaPm09Rd3oFgEp6VfqC1zbc2BbFBk5HqkmYzFvDUfAYLdqO0xCG1Jx
         +KGVkJhV9udU1VpclDBv0/7nlq4qpxBAH+675mmT5aSM/gGZ+k8lDmdYJ4jNT0Q/y9wN
         +QXiczLovkVeryoAsfdSXnqfhOWUUmMuBOyxaHpT3F+G57zkIbXNh8ihxwnAd3viYeT4
         /BQQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1Xdif2MTTMGvOYz6igJHsJA/jH7LnH04qcuWGR6gu3t5y+1dVLcOtiBCBYKLPiG83Hg8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWujHIEj2dw0O4udTyN8M+YuwUXtvT8EGsqPf7pLQkbLIhE0IZ
	bpJV9z4J9DGmT9vDFLpkro5glYv4n8q7q+QVo3RUTjHbCNg3msZO+fNMo/zAMsPUkrGA8sYrq7r
	i6vwMQqnGoJbCTUaP3OSXJVrXYWPfA+AroNXtUOjM
X-Gm-Gg: ASbGncs3mzz/olsJIXxP6G5lytCtdWFk8sBOAIIzyQX+FpxIcwcPzKfDFD1aDcGk62m
	giOOj930Bl59BKYzpcXAlSpiZcrt/gW2nWaJkxXKRKKOQjWiDuvIMho423F356V3MasFSIOOE7l
	UjfeY1G9lsCmDUIR8T42q6HVSZevbtaMQo6Ee0EBDXG14BrU9Hvyg7w3SHlg9sixtcxYuJzcJ8+
	mamuLhnCULXOzhdYFEkmhOz7DgFQ8SimGbPlsOCbElEugSBe2uZsiwW/1qA2R1w2q3iQ9TxRq5L
	x9cWT1IzLJfZK/QffIYgwcJtF9cLbw==
X-Google-Smtp-Source: AGHT+IEQDHf9C9gWBdUCo8EHStOQDaQ+1db1WUHKj7RPNy6G6/xrYVcJmvgs3fmjZ1Mzj+yg83rSLse2ZG+aMQ4QlZ4=
X-Received: by 2002:a05:622a:203:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4edc20eb651mr1000141cf.8.1762750486923; Sun, 09 Nov 2025
 20:54:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com> <20251008232531.1152035-8-dmatlack@google.com>
In-Reply-To: <20251008232531.1152035-8-dmatlack@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 10 Nov 2025 10:24:34 +0530
X-Gm-Features: AWmQ_bnt6Hixtk2L1hfdnREwOXlYp6Ik_jiZKg3hy8TNdfo1TM_p5kkiSYlWqTU
Message-ID: <CAJHc60zH4x98uCDEveGf3Lr+b0RaiBUC+r9ZdwpNxu9wTAPptQ@mail.gmail.com>
Subject: Re: [PATCH 07/12] vfio: selftests: Prefix logs with device BDF where relevant
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 4:56=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> Prefix log messages with the device's BDF where relevant. This will help
> understanding VFIO selftests logs when tests are run with multiple
> devices.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/vfio/lib/drivers/dsa/dsa.c      | 34 +++++++++----------
>  .../selftests/vfio/lib/drivers/ioat/ioat.c    | 16 ++++-----
>  .../selftests/vfio/lib/include/vfio_util.h    |  4 +++
>  .../selftests/vfio/lib/vfio_pci_device.c      |  1 +
>  4 files changed, 30 insertions(+), 25 deletions(-)
>
> diff --git a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c b/tools/t=
esting/selftests/vfio/lib/drivers/dsa/dsa.c
> index 0ca2cbc2a316..8d667be80229 100644
> --- a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
> +++ b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
> @@ -70,7 +70,7 @@ static int dsa_probe(struct vfio_pci_device *device)
>                 return -EINVAL;
>
>         if (dsa_int_handle_request_required(device)) {
> -               printf("Device requires requesting interrupt handles\n");
> +               dev_info(device, "Device requires requesting interrupt ha=
ndles\n");
>                 return -EINVAL;
>         }
>
> @@ -91,23 +91,23 @@ static void dsa_check_sw_err(struct vfio_pci_device *=
device)
>                         return;
>         }
>
> -       fprintf(stderr, "SWERR: 0x%016lx 0x%016lx 0x%016lx 0x%016lx\n",
> +       dev_err(device, "SWERR: 0x%016lx 0x%016lx 0x%016lx 0x%016lx\n",
>                 err.bits[0], err.bits[1], err.bits[2], err.bits[3]);
>
> -       fprintf(stderr, "  valid: 0x%x\n", err.valid);
> -       fprintf(stderr, "  overflow: 0x%x\n", err.overflow);
> -       fprintf(stderr, "  desc_valid: 0x%x\n", err.desc_valid);
> -       fprintf(stderr, "  wq_idx_valid: 0x%x\n", err.wq_idx_valid);
> -       fprintf(stderr, "  batch: 0x%x\n", err.batch);
> -       fprintf(stderr, "  fault_rw: 0x%x\n", err.fault_rw);
> -       fprintf(stderr, "  priv: 0x%x\n", err.priv);
> -       fprintf(stderr, "  error: 0x%x\n", err.error);
> -       fprintf(stderr, "  wq_idx: 0x%x\n", err.wq_idx);
> -       fprintf(stderr, "  operation: 0x%x\n", err.operation);
> -       fprintf(stderr, "  pasid: 0x%x\n", err.pasid);
> -       fprintf(stderr, "  batch_idx: 0x%x\n", err.batch_idx);
> -       fprintf(stderr, "  invalid_flags: 0x%x\n", err.invalid_flags);
> -       fprintf(stderr, "  fault_addr: 0x%lx\n", err.fault_addr);
> +       dev_err(device, "  valid: 0x%x\n", err.valid);
> +       dev_err(device, "  overflow: 0x%x\n", err.overflow);
> +       dev_err(device, "  desc_valid: 0x%x\n", err.desc_valid);
> +       dev_err(device, "  wq_idx_valid: 0x%x\n", err.wq_idx_valid);
> +       dev_err(device, "  batch: 0x%x\n", err.batch);
> +       dev_err(device, "  fault_rw: 0x%x\n", err.fault_rw);
> +       dev_err(device, "  priv: 0x%x\n", err.priv);
> +       dev_err(device, "  error: 0x%x\n", err.error);
> +       dev_err(device, "  wq_idx: 0x%x\n", err.wq_idx);
> +       dev_err(device, "  operation: 0x%x\n", err.operation);
> +       dev_err(device, "  pasid: 0x%x\n", err.pasid);
> +       dev_err(device, "  batch_idx: 0x%x\n", err.batch_idx);
> +       dev_err(device, "  invalid_flags: 0x%x\n", err.invalid_flags);
> +       dev_err(device, "  fault_addr: 0x%lx\n", err.fault_addr);
>
>         VFIO_FAIL("Software Error Detected!\n");
>  }
> @@ -256,7 +256,7 @@ static int dsa_completion_wait(struct vfio_pci_device=
 *device,
>         if (status =3D=3D DSA_COMP_SUCCESS)
>                 return 0;
>
> -       printf("Error detected during memcpy operation: 0x%x\n", status);
> +       dev_info(device, "Error detected during memcpy operation: 0x%x\n"=
, status);
>         return -1;
>  }
>
> diff --git a/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c b/tools=
/testing/selftests/vfio/lib/drivers/ioat/ioat.c
> index c3b91d9b1f59..e04dce1d544c 100644
> --- a/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
> +++ b/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
> @@ -51,7 +51,7 @@ static int ioat_probe(struct vfio_pci_device *device)
>                 r =3D 0;
>                 break;
>         default:
> -               printf("ioat: Unsupported version: 0x%x\n", version);
> +               dev_info(device, "ioat: Unsupported version: 0x%x\n", ver=
sion);
>                 r =3D -EINVAL;
>         }
>         return r;
> @@ -135,13 +135,13 @@ static void ioat_handle_error(struct vfio_pci_devic=
e *device)
>  {
>         void *registers =3D ioat_channel_registers(device);
>
> -       printf("Error detected during memcpy operation!\n"
> -              "  CHANERR: 0x%x\n"
> -              "  CHANERR_INT: 0x%x\n"
> -              "  DMAUNCERRSTS: 0x%x\n",
> -              readl(registers + IOAT_CHANERR_OFFSET),
> -              vfio_pci_config_readl(device, IOAT_PCI_CHANERR_INT_OFFSET)=
,
> -              vfio_pci_config_readl(device, IOAT_PCI_DMAUNCERRSTS_OFFSET=
));
> +       dev_info(device, "Error detected during memcpy operation!\n"
> +                "  CHANERR: 0x%x\n"
> +                "  CHANERR_INT: 0x%x\n"
> +                "  DMAUNCERRSTS: 0x%x\n",
> +                readl(registers + IOAT_CHANERR_OFFSET),
> +                vfio_pci_config_readl(device, IOAT_PCI_CHANERR_INT_OFFSE=
T),
> +                vfio_pci_config_readl(device, IOAT_PCI_DMAUNCERRSTS_OFFS=
ET));
>
>         ioat_reset(device);
>  }
> diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools=
/testing/selftests/vfio/lib/include/vfio_util.h
> index 8a01bcaa3ee8..b7175d4c2132 100644
> --- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
> +++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> @@ -47,6 +47,9 @@
>         VFIO_LOG_AND_EXIT(_fmt, ##__VA_ARGS__);                 \
>  } while (0)
>
> +#define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__V=
A_ARGS__)
> +#define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bd=
f, ##__VA_ARGS__)
> +
nit: For all the dev_info() replacements in this patch, the messages
sound like something went bad/wrong. Shouldn't they be dev_err()
instead, or were you just aiming for a 1:1 conversion?

Thank you.
Raghavendra

