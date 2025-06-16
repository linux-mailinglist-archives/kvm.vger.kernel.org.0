Return-Path: <kvm+bounces-49638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0897DADBD55
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CCB1173121
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 22:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02352264B6;
	Mon, 16 Jun 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4lk8YjTz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2542192E4
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 22:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750114564; cv=none; b=sE6rHzHflWqqMqSNKvOlYXzOuzi5fHfW197p9+YObYT1sSqtEdXrfJM/s+AoWlSbcJ3TDUTPDYQm7lPMJ0o1ahaZA1H5ezZa+e/SN2drXGCOWRnux/roxeVBgXIaQmBzK1QpyuHfqa9Oo7nNjWExCTkPkxA+14AAydt0W1haF8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750114564; c=relaxed/simple;
	bh=p0HFxJV+lPrVl3IsetQGPScX9Z2eu4Nipb7a6kuWLmU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VzNFIQfQ1eCoTHPICMlbzwd0/yjZ3VJGeJqphLvmiRpk1Vx6ZiAILYe+IlZHE2vfARKYshmYniTAjVlPh8TaWV21mjNm8vcyHAuigxZPQ5S0UwrVLYlKSaiepxsffBQl+kEVfz69FIFCI6HmZy5bLUMRW0gYbG2xUFdqAYEto5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4lk8YjTz; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4a58197794eso44231cf.1
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 15:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750114561; x=1750719361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9sxJZ0FF/SMaJHy2nT2/WKSEvvRwEArRwRBCF/xeEms=;
        b=4lk8YjTzBnW0lpqCzyYjqYxvv5ROpc3pLil1UI02P0yMQfPPAimvJjhAwe+I5UjvC1
         BcWcMwhGMyWCB6GROHsH737hgy5DIX6VpRevO/iygiqm41un5fuFgYokz5ritTjz0YMJ
         x683oFez2b7epmZoXQK4FgRw0w6MBtS21+QTal8Ir9EsSuiwE+kcbpFavmBQxIaIzpoi
         VTY6SxvmKI7DjICCKYoQU3M7oZQR7ZoI/R1lfhyGnhg/atfPWSRmLtUI+6CFiMH7X4oJ
         SWABhOARmoelrgSr5q1pQDwkmM6XHwRg9FcFcqK1Ti0bTTorQbY1/ydBjSGVvw1Fkt5b
         gREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750114561; x=1750719361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9sxJZ0FF/SMaJHy2nT2/WKSEvvRwEArRwRBCF/xeEms=;
        b=f5QMENmMbH8O0Qtq15XDb7O2bBkZNvq6uvCCFufKNVKASbEtiLRtfq00HJ/cRZwP2z
         iJIaw+WoV48Sk8CL4Ph1PLDKD9KByiK3INBRXTsGsYant9LmY2SxE0kT9hQIEFQ1NY0f
         VK+ebq6KvdLQ3e+DhfwoYcnJK3+KHCCa6ltLk72wT0iR6Y4+xwowynA4yUwOjyJfkAkM
         qWO+X5E7A7UqG2EjOfWsWeQ4mVCJ3TVRj7c0J6Q0MzB0Q5KwifvHnilufOE0XRuK0pZR
         CAC4fUUATEsZuk/kaxsloIuQtFDjG2vYtkQXNClb6HlXAZHaYf7NNqb99Ze3cD1h5mIV
         N+hQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgAP7KwDbl36IbSqbfoye1OFFAFGdB5Br2JzpArzy+vpbqi9LjVotLrH4qQ50V6oQYvJ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFI+EUx2wqdRYwNu/mvsfVmro5NS/x9s1jqHt31wC56u9MNs1T
	x4NWOjVHyzeN2+uQBFcNMXlP8VXy1s8apUrG77SgLjJJKz/+psmAKOz6UxIt7tAS84g5coBZ7dk
	Umsn2POw2naCK7Aik4xWfSm+b8GstcJrh180XqSC+
X-Gm-Gg: ASbGncv8qy5mPfzj83YhqB0f2p/DdH9SqATSy2iWxg+tXxV4fbANIFd/ai3EFhFTDGf
	zqwdf84psIapM2896MwGkthduDkPf+QFIm2el/dyxwUWeH143q6XTfQDBFrzhJx9GNB01t1GANI
	qxG7VL/qV+95Z7WcZocVi+WlGED1L+0K85o71iez6KrUZPjNsuk7tsjWR1NeXHwjgzkcH5Z0Kk2
	Q==
X-Google-Smtp-Source: AGHT+IGIjS7iz+3YUbT9aghigQKmYQHtJkyMv5yyQ87XHTe9Ys39TLz90+dSPL7I7r0PdxINhIxF/1TBdd12QyHY53U=
X-Received: by 2002:ac8:5f07:0:b0:4a6:fc57:b85a with SMTP id
 d75a77b69052e-4a73d6b7478mr8535751cf.14.1750114561181; Mon, 16 Jun 2025
 15:56:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523095322.88774-1-chao.gao@intel.com> <20250523095322.88774-9-chao.gao@intel.com>
In-Reply-To: <20250523095322.88774-9-chao.gao@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Mon, 16 Jun 2025 17:55:50 -0500
X-Gm-Features: AX0GCFvVbiaWGgCRII3OE08Te9sdtG7W4jpMtQeF78bEqoHGPUs-MDM7_o1KaSg
Message-ID: <CAAhR5DGFxidA=MuhLrixdHv+D_=KYQquBE2quNCNMZvzijXLiw@mail.gmail.com>
Subject: Re: [RFC PATCH 08/20] x86/virt/seamldr: Implement FW_UPLOAD sysfs ABI
 for TD-Preserving Updates
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, x86@kernel.org, kvm@vger.kernel.org, 
	seanjc@google.com, pbonzini@redhat.com, eddie.dong@intel.com, 
	kirill.shutemov@intel.com, dave.hansen@intel.com, dan.j.williams@intel.com, 
	kai.huang@intel.com, isaku.yamahata@intel.com, elena.reshetova@intel.com, 
	rick.p.edgecombe@intel.com, Farrah Chen <farrah.chen@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 4:55=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrote=
:
>
> Implement a fw_upload interface to coordinate TD-Preserving updates. The
> explicit file selection capabilities of fw_upload is preferred over the
> implicit file selection of request_firmware() for the following reasons:
>
> a. Intel distributes all versions of the TDX module, allowing admins to
> load any version rather than always defaulting to the latest. This
> flexibility is necessary because future extensions may require reverting =
to
> a previous version to clear fatal errors.
>
> b. Some module version series are platform-specific. For example, the 1.5=
.x
> series is for certain platform generations, while the 2.0.x series is
> intended for others.
>
> c. The update policy for TD-Preserving is non-linear at times. The latest
> TDX module may not be TD-Preserving capable. For example, TDX module
> 1.5.x may be updated to 1.5.y but not to 1.5.y+1. This policy is document=
ed
> separately in a file released along with each TDX module release.
>
> So, the default policy of "request_firmware()" of "always load latest", i=
s
> not suitable for TDX. Userspace needs to deploy a more sophisticated poli=
cy
> check (i.e. latest may not be TD-Preserving capable), and there is
> potential operator choice to consider.
>
> Just have userspace pick rather than add kernel mechanism to change the
> default policy of request_firmware().
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> ---
>  arch/x86/Kconfig                |  2 +
>  arch/x86/virt/vmx/tdx/seamldr.c | 77 +++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/seamldr.h |  2 +
>  arch/x86/virt/vmx/tdx/tdx.c     |  4 ++
>  4 files changed, 85 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 8b1e0986b7f8..31385104a6ee 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1935,6 +1935,8 @@ config INTEL_TDX_HOST
>  config INTEL_TDX_MODULE_UPDATE
>         bool "Intel TDX module runtime update"
>         depends on INTEL_TDX_HOST
> +       select FW_LOADER
> +       select FW_UPLOAD
>         help
>           This enables the kernel to support TDX module runtime update. T=
his allows
>           the admin to upgrade the TDX module to a newer one without the =
need to
> diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seam=
ldr.c
> index b628555daf55..da862e71ebce 100644
> --- a/arch/x86/virt/vmx/tdx/seamldr.c
> +++ b/arch/x86/virt/vmx/tdx/seamldr.c
> @@ -8,6 +8,8 @@
>
>  #include <linux/cleanup.h>
>  #include <linux/device.h>
> +#include <linux/firmware.h>
> +#include <linux/gfp.h>
>  #include <linux/kobject.h>
>  #include <linux/sysfs.h>
>
> @@ -32,6 +34,15 @@ struct seamldr_info {
>         u8      reserved1[224];
>  } __packed;
>
> +
> +#define TDX_FW_STATE_BITS      32
> +#define TDX_FW_CANCEL          0
> +struct tdx_status {
> +       DECLARE_BITMAP(fw_state, TDX_FW_STATE_BITS);
> +};
> +
> +struct fw_upload *tdx_fwl;
> +static struct tdx_status tdx_status;
>  static struct seamldr_info seamldr_info __aligned(256);
>
>  static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
> @@ -101,3 +112,69 @@ int get_seamldr_info(void)
>
>         return seamldr_call(P_SEAMLDR_INFO, &args);
>  }
> +
> +static int seamldr_install_module(const u8 *data, u32 size)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static enum fw_upload_err tdx_fw_prepare(struct fw_upload *fwl,
> +                                        const u8 *data, u32 size)
> +{
> +       struct tdx_status *status =3D fwl->dd_handle;
> +
> +       if (test_and_clear_bit(TDX_FW_CANCEL, status->fw_state))
> +               return FW_UPLOAD_ERR_CANCELED;
> +
> +       return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static enum fw_upload_err tdx_fw_write(struct fw_upload *fwl, const u8 *=
data,
> +                                      u32 offset, u32 size, u32 *written=
)
> +{
> +       struct tdx_status *status =3D fwl->dd_handle;
> +
> +       if (test_and_clear_bit(TDX_FW_CANCEL, status->fw_state))
> +               return FW_UPLOAD_ERR_CANCELED;
> +
> +       /*
> +        * No partial write will be returned to callers so @offset should
> +        * always be zero.
> +        */
> +       WARN_ON_ONCE(offset);
> +       if (seamldr_install_module(data, size))
> +               return FW_UPLOAD_ERR_FW_INVALID;
> +
> +       *written =3D size;
> +       return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static enum fw_upload_err tdx_fw_poll_complete(struct fw_upload *fwl)
> +{
> +       return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static void tdx_fw_cancel(struct fw_upload *fwl)
> +{
> +       struct tdx_status *status =3D fwl->dd_handle;
> +
> +       set_bit(TDX_FW_CANCEL, status->fw_state);
> +}
> +
> +static const struct fw_upload_ops tdx_fw_ops =3D {
> +       .prepare =3D tdx_fw_prepare,
> +       .write =3D tdx_fw_write,
> +       .poll_complete =3D tdx_fw_poll_complete,
> +       .cancel =3D tdx_fw_cancel,
> +};
> +
> +void seamldr_init(struct device *dev)
> +{
> +       int ret;
> +
> +       tdx_fwl =3D firmware_upload_register(THIS_MODULE, dev, "seamldr_u=
pload",
> +                                          &tdx_fw_ops, &tdx_status);
> +       ret =3D PTR_ERR_OR_ZERO(tdx_fwl);
> +       if (ret)
> +               pr_err("failed to register module uploader %d\n", ret);
> +}
> diff --git a/arch/x86/virt/vmx/tdx/seamldr.h b/arch/x86/virt/vmx/tdx/seam=
ldr.h
> index 15597cb5036d..00fa3a4e9155 100644
> --- a/arch/x86/virt/vmx/tdx/seamldr.h
> +++ b/arch/x86/virt/vmx/tdx/seamldr.h
> @@ -6,9 +6,11 @@
>  extern struct attribute_group seamldr_group;
>  #define SEAMLDR_GROUP (&seamldr_group)
>  int get_seamldr_info(void);
> +void seamldr_init(struct device *dev);
>  #else
>  #define SEAMLDR_GROUP NULL
>  static inline int get_seamldr_info(void) { return 0; }
> +static inline void seamldr_init(struct device *dev) { }
>  #endif
>
>  #endif
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index aa6a23d46494..22ffc15b4299 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1178,6 +1178,10 @@ static void tdx_subsys_init(void)
>                 goto err_bus;
>         }
>
> +       struct device *dev_root __free(put_device) =3D bus_get_dev_root(&=
tdx_subsys);

dev_root definition here causes compilation error:

arch/x86/virt/vmx/tdx/tdx.c:1181:3: error: cannot jump from this goto
statement to its label
                goto err_bus;
                ^
arch/x86/virt/vmx/tdx/tdx.c:1184:17: note: jump bypasses
initialization of variable with __attribute__((cleanup))
        struct device *dev_root __free(put_device) =3D
bus_get_dev_root(&tdx_subsys);

> +       if (dev_root)
> +               seamldr_init(dev_root);
> +
>         return;
>
>  err_bus:
> --
> 2.47.1
>
>

