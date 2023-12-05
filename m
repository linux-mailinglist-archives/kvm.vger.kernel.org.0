Return-Path: <kvm+bounces-3610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79105805AF4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28D41281405
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95933692AF;
	Tue,  5 Dec 2023 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wJSyk1pq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71609D46
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:13:55 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40b35199f94so88635e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 09:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701796434; x=1702401234; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGmB7fOBDsiFtQxeHcNdo23pFy6CE+aGJT/A4Crl31c=;
        b=wJSyk1pqDa8goj++I32XwpyE8J/BNUhfiu9CJZKar+zswHUk4T4YZQJe6W3gvVrucx
         s3/ls8st5dpDPYIKTHZRM9//LxPwmSe9SzITJRR8tcHAuTZjdw77b9BUnBUxplnlzk+a
         TdSoe+Qvg2y7g0bX+1CpD2e0V2U2tQ3QtWQhs52bER4bjHG/XFs36dOei3DACqaGlnDd
         VOOqDlyJVAyH/tzB+roHKKJ+x0Ic1BSaOGJ1Hy1fqwbtNhOiihE1s65y3Po+FexwtJi/
         d6ihZFB8qYjcDFnk3WnG3QPJZ3CrAuSz+dRya2gOVkJ4ALqLdKFr4Cwo4VsXPyUl4sOr
         hSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701796434; x=1702401234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KGmB7fOBDsiFtQxeHcNdo23pFy6CE+aGJT/A4Crl31c=;
        b=CFD6rp7TChn/Nkx5UEx3Gv5LdOTb/H+Wsj3JPrEd/oIu6ifxuAGcfXAMTxJ7NMb0Uj
         f82jK3tv0eTlEyHQfUqlGy7LnTa8jrKtVk8pnA6loWyjyimhtrp8+71sbqra2va+BzoN
         e70RjDQKZNiGzlU9yeGC3X/ANQgWilpk+HLqH/68775eZfGjw7H/rBtR4n7Jmf452gwq
         Sc+zIbAgQ2kw48j/d0CljEURLuydWiSGF6v2XeQVTrHP+zvLX0LZJ1LOQ5b9FBHZNgqA
         YSHjX/xK+We8l8NDdvbXPAUlj9iofizQTzUzDInA7tGAESsy5Ok4vH6Jt+Oi6edQp+va
         jjcQ==
X-Gm-Message-State: AOJu0YzPn7WNIr6s028nsqYsfebH6UfrtfVIJ9C6gJs1iG7MSR56Jfj5
	SLrjPGOfCi5kdWIpHnaOrUfNSOxTkKkurmxx7sLEsw==
X-Google-Smtp-Source: AGHT+IFntn/pDoDGWYaPvk4C5TZEYmwlGX1gDVc69Wxm07yHnptxOxwre5L4Im10WyT+Hm8gJLrjIygoN/NJXPxcVAI=
X-Received: by 2002:a05:600c:511a:b0:40b:2ec6:2a87 with SMTP id
 o26-20020a05600c511a00b0040b2ec62a87mr557432wms.5.1701796433224; Tue, 05 Dec
 2023 09:13:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128125959.1810039-1-nikunj@amd.com> <20231128125959.1810039-8-nikunj@amd.com>
In-Reply-To: <20231128125959.1810039-8-nikunj@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 5 Dec 2023 09:13:41 -0800
Message-ID: <CAAH4kHabej_mYshdBZsscpwfRASzD3U24+0wUNFLUUPubXDR+Q@mail.gmail.com>
Subject: Re: [PATCH v6 07/16] x86/sev: Move and reorganize sev guest request api
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2023 at 5:01=E2=80=AFAM Nikunj A Dadhania <nikunj@amd.com> =
wrote:
>
> For enabling Secure TSC, SEV-SNP guests need to communicate with the
> AMD Security Processor early during boot. Many of the required
> functions are implemented in the sev-guest driver and therefore not
> available at early boot. Move the required functions and provide
> API to the sev guest driver for sending guest message and vmpck
> routines.
>
> As there is no external caller for snp_issue_guest_request() anymore,
> make it static and drop the prototype from sev-guest.h.
>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/Kconfig                        |   1 +
>  arch/x86/include/asm/sev-guest.h        |  91 ++++-
>  arch/x86/include/asm/sev.h              |  10 -
>  arch/x86/kernel/sev.c                   | 451 +++++++++++++++++++++-
>  drivers/virt/coco/sev-guest/Kconfig     |   1 -
>  drivers/virt/coco/sev-guest/sev-guest.c | 479 +-----------------------
>  6 files changed, 550 insertions(+), 483 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 3762f41bb092..b8f374ec5651 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1534,6 +1534,7 @@ config AMD_MEM_ENCRYPT
>         select ARCH_HAS_CC_PLATFORM
>         select X86_MEM_ENCRYPT
>         select UNACCEPTED_MEMORY
> +       select CRYPTO_LIB_AESGCM
>         help
>           Say yes to enable support for the encryption of system memory.
>           This requires an AMD processor that supports Secure Memory
> diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-=
guest.h
> index 27cc15ad6131..16bf25c14e6f 100644
> --- a/arch/x86/include/asm/sev-guest.h
> +++ b/arch/x86/include/asm/sev-guest.h
> @@ -11,6 +11,11 @@
>  #define __VIRT_SEVGUEST_H__
>
>  #include <linux/types.h>
> +#include <linux/miscdevice.h>
> +#include <asm/sev.h>
> +
> +#define SNP_REQ_MAX_RETRY_DURATION    (60*HZ)
> +#define SNP_REQ_RETRY_DELAY           (2*HZ)
>
>  #define MAX_AUTHTAG_LEN                32
>  #define AUTHTAG_LEN            16
> @@ -58,11 +63,52 @@ struct snp_guest_msg_hdr {
>         u8 rsvd3[35];
>  } __packed;
>
> +/* SNP Guest message request */
> +struct snp_req_data {
> +       unsigned long req_gpa;
> +       unsigned long resp_gpa;
> +};
> +
>  struct snp_guest_msg {
>         struct snp_guest_msg_hdr hdr;
>         u8 payload[4000];
>  } __packed;
>
> +struct sev_guest_platform_data {
> +       /* request and response are in unencrypted memory */
> +       struct snp_guest_msg *request;
> +       struct snp_guest_msg *response;
> +
> +       struct snp_secrets_page_layout *layout;
> +       struct snp_req_data input;
> +};
> +
> +struct snp_guest_dev {
> +       struct device *dev;
> +       struct miscdevice misc;
> +
> +       /* Mutex to serialize the shared buffer access and command handli=
ng. */
> +       struct mutex cmd_mutex;
> +
> +       void *certs_data;
> +       struct aesgcm_ctx *ctx;
> +
> +       /*
> +        * Avoid information leakage by double-buffering shared messages
> +        * in fields that are in regular encrypted memory
> +        */
> +       struct snp_guest_msg secret_request;
> +       struct snp_guest_msg secret_response;
> +
> +       struct sev_guest_platform_data *pdata;
> +       union {
> +               struct snp_report_req report;
> +               struct snp_derived_key_req derived_key;
> +               struct snp_ext_report_req ext_report;
> +       } req;
> +       unsigned int vmpck_id;
> +};
> +
>  struct snp_guest_req {
>         void *req_buf;
>         size_t req_sz;
> @@ -79,6 +125,47 @@ struct snp_guest_req {
>         u8 msg_type;
>  };
>
> -int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_da=
ta *input,
> -                           struct snp_guest_request_ioctl *rio);
> +int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev);
> +int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_r=
eq *req,
> +                          struct snp_guest_request_ioctl *rio);
> +bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id);
> +bool snp_is_vmpck_empty(unsigned int vmpck_id);
> +
> +static inline void free_shared_pages(void *buf, size_t sz)
> +{
> +       unsigned int npages =3D PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +       int ret;
> +
> +       if (!buf)
> +               return;
> +
> +       ret =3D set_memory_encrypted((unsigned long)buf, npages);
> +       if (ret) {
> +               WARN_ONCE(ret, "failed to restore encryption mask (leak i=
t)\n");
> +               return;
> +       }
> +
> +       __free_pages(virt_to_page(buf), get_order(sz));
> +}
> +
> +static inline void *alloc_shared_pages(size_t sz)
> +{
> +       unsigned int npages =3D PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +       struct page *page;
> +       int ret;
> +
> +       page =3D alloc_pages(GFP_KERNEL_ACCOUNT, get_order(sz));
> +       if (!page)
> +               return NULL;
> +
> +       ret =3D set_memory_decrypted((unsigned long)page_address(page), n=
pages);
> +       if (ret) {
> +               pr_err("%s: failed to mark page shared, ret=3D%d\n", __fu=
nc__, ret);
> +               __free_pages(page, get_order(sz));
> +               return NULL;
> +       }
> +
> +       return page_address(page);
> +}
> +
>  #endif /* __VIRT_SEVGUEST_H__ */
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 78465a8c7dc6..783150458864 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -93,16 +93,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>
>  #define RMPADJUST_VMSA_PAGE_BIT                BIT(16)
>
> -/* SNP Guest message request */
> -struct snp_req_data {
> -       unsigned long req_gpa;
> -       unsigned long resp_gpa;
> -};
> -
> -struct sev_guest_platform_data {
> -       u64 secrets_gpa;
> -};
> -
>  /*
>   * The secrets page contains 96-bytes of reserved field that can be used=
 by
>   * the guest OS. The guest OS uses the area to save the message sequence
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 479ea61f40f3..a413add2fd2c 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -24,6 +24,7 @@
>  #include <linux/io.h>
>  #include <linux/psp-sev.h>
>  #include <uapi/linux/sev-guest.h>
> +#include <crypto/gcm.h>
>
>  #include <asm/cpu_entry_area.h>
>  #include <asm/stacktrace.h>
> @@ -2150,8 +2151,8 @@ static int __init init_sev_config(char *str)
>  }
>  __setup("sev=3D", init_sev_config);
>
> -int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_da=
ta *input,
> -                           struct snp_guest_request_ioctl *rio)
> +static int snp_issue_guest_request(struct snp_guest_req *req, struct snp=
_req_data *input,
> +                                  struct snp_guest_request_ioctl *rio)
>  {
>         struct ghcb_state state;
>         struct es_em_ctxt ctxt;
> @@ -2218,7 +2219,6 @@ int snp_issue_guest_request(struct snp_guest_req *r=
eq, struct snp_req_data *inpu
>
>         return ret;
>  }
> -EXPORT_SYMBOL_GPL(snp_issue_guest_request);
>
>  static struct platform_device sev_guest_device =3D {
>         .name           =3D "sev-guest",
> @@ -2227,22 +2227,451 @@ static struct platform_device sev_guest_device =
=3D {
>
>  static int __init snp_init_platform_device(void)
>  {
> -       struct sev_guest_platform_data data;
> -
>         if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
>                 return -ENODEV;
>
> -       if (!secrets_pa)
> +       if (platform_device_register(&sev_guest_device))
>                 return -ENODEV;
>
> -       data.secrets_gpa =3D secrets_pa;
> -       if (platform_device_add_data(&sev_guest_device, &data, sizeof(dat=
a)))
> +       pr_info("SNP guest platform device initialized.\n");
> +       return 0;
> +}
> +device_initcall(snp_init_platform_device);
> +
> +static struct sev_guest_platform_data *platform_data;
> +
> +static inline u8 *snp_get_vmpck(unsigned int vmpck_id)
> +{
> +       if (!platform_data)
> +               return NULL;
> +
> +       return platform_data->layout->vmpck0 + vmpck_id * VMPCK_KEY_LEN;
> +}
> +
> +static inline u32 *snp_get_os_area_msg_seqno(unsigned int vmpck_id)
> +{
> +       if (!platform_data)
> +               return NULL;
> +
> +       return &platform_data->layout->os_area.msg_seqno_0 + vmpck_id;
> +}
> +
> +bool snp_is_vmpck_empty(unsigned int vmpck_id)
> +{
> +       char zero_key[VMPCK_KEY_LEN] =3D {0};
> +       u8 *key =3D snp_get_vmpck(vmpck_id);
> +
> +       if (key)
> +               return !memcmp(key, zero_key, VMPCK_KEY_LEN);
> +
> +       return true;
> +}
> +EXPORT_SYMBOL_GPL(snp_is_vmpck_empty);
> +
> +/*
> + * If an error is received from the host or AMD Secure Processor (ASP) t=
here
> + * are two options. Either retry the exact same encrypted request or dis=
continue
> + * using the VMPCK.
> + *
> + * This is because in the current encryption scheme GHCB v2 uses AES-GCM=
 to
> + * encrypt the requests. The IV for this scheme is the sequence number. =
GCM
> + * cannot tolerate IV reuse.
> + *
> + * The ASP FW v1.51 only increments the sequence numbers on a successful
> + * guest<->ASP back and forth and only accepts messages at its exact seq=
uence
> + * number.
> + *
> + * So if the sequence number were to be reused the encryption scheme is
> + * vulnerable. If the sequence number were incremented for a fresh IV th=
e ASP
> + * will reject the request.
> + */
> +static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
> +{
> +       u8 *key =3D snp_get_vmpck(snp_dev->vmpck_id);
> +
> +       pr_alert("Disabling vmpck_id %u to prevent IV reuse.\n", snp_dev-=
>vmpck_id);
> +       memzero_explicit(key, VMPCK_KEY_LEN);
> +}
> +
> +static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
> +{
> +       u32 *os_area_msg_seqno =3D snp_get_os_area_msg_seqno(snp_dev->vmp=
ck_id);
> +       u64 count;
> +
> +       if (!os_area_msg_seqno) {
> +               pr_err("SNP unable to get message sequence counter\n");
> +               return 0;
> +       }
> +
> +       lockdep_assert_held(&snp_dev->cmd_mutex);
> +
> +       /* Read the current message sequence counter from secrets pages *=
/
> +       count =3D *os_area_msg_seqno;
> +
> +       return count + 1;
> +}
> +
> +/* Return a non-zero on success */
> +static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
> +{
> +       u64 count =3D __snp_get_msg_seqno(snp_dev);
> +
> +       /*
> +        * The message sequence counter for the SNP guest request is a  6=
4-bit
> +        * value but the version 2 of GHCB specification defines a 32-bit=
 storage
> +        * for it. If the counter exceeds the 32-bit value then return ze=
ro.
> +        * The caller should check the return value, but if the caller ha=
ppens to
> +        * not check the value and use it, then the firmware treats zero =
as an
> +        * invalid number and will fail the  message request.
> +        */
> +       if (count >=3D UINT_MAX) {
> +               pr_err("SNP request message sequence counter overflow\n")=
;
> +               return 0;
> +       }
> +
> +       return count;
> +}
> +
> +static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
> +{
> +       u32 *os_area_msg_seqno =3D snp_get_os_area_msg_seqno(snp_dev->vmp=
ck_id);
> +
> +       if (!os_area_msg_seqno) {
> +               pr_err("SNP unable to get message sequence counter\n");
> +               return;
> +       }
> +
> +       lockdep_assert_held(&snp_dev->cmd_mutex);
> +
> +       /*
> +        * The counter is also incremented by the PSP, so increment it by=
 2
> +        * and save in secrets page.
> +        */
> +       *os_area_msg_seqno +=3D 2;
> +}
> +
> +static struct aesgcm_ctx *snp_init_crypto(unsigned int vmpck_id)
> +{
> +       struct aesgcm_ctx *ctx;
> +       u8 *key;
> +
> +       if (snp_is_vmpck_empty(vmpck_id)) {
> +               pr_err("VM communication key VMPCK%u is null\n", vmpck_id=
);
> +               return NULL;
> +       }
> +
> +       ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
> +       if (!ctx)
> +               return NULL;
> +
> +       key =3D snp_get_vmpck(vmpck_id);
> +       if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
> +               pr_err("Crypto context initialization failed\n");
> +               kfree(ctx);
> +               return NULL;
> +       }
> +
> +       return ctx;
> +}
> +
> +int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev)
> +{
> +       struct sev_guest_platform_data *pdata;
> +       int ret;
> +
> +       if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {

Note that this may be going away in favor of an
cpu_feature_enabled(X86_FEATURE_...) check given Kirill's "[PATCH]
x86/coco, x86/sev: Use cpu_feature_enabled() to detect SEV guest
flavor"

> +               pr_err("SNP not supported\n");
> +               return 0;
> +       }
> +
> +       if (platform_data) {
> +               pr_debug("SNP platform data already initialized.\n");
> +               goto create_ctx;
> +       }
> +
> +       if (!secrets_pa) {
> +               pr_err("SNP secrets page not found\n");
>                 return -ENODEV;
> +       }
>
> -       if (platform_device_register(&sev_guest_device))
> +       pdata =3D kzalloc(sizeof(struct sev_guest_platform_data), GFP_KER=
NEL);
> +       if (!pdata) {
> +               pr_err("Allocation of SNP guest platform data failed\n");
> +               return -ENOMEM;
> +       }
> +
> +       pdata->layout =3D (__force void *)ioremap_encrypted(secrets_pa, P=
AGE_SIZE);
> +       if (!pdata->layout) {
> +               pr_err("Failed to map SNP secrets page.\n");
> +               goto e_free_pdata;
> +       }
> +
> +       ret =3D -ENOMEM;
> +       /* Allocate the shared page used for the request and response mes=
sage. */
> +       pdata->request =3D alloc_shared_pages(sizeof(struct snp_guest_msg=
));
> +       if (!pdata->request)
> +               goto e_unmap;
> +
> +       pdata->response =3D alloc_shared_pages(sizeof(struct snp_guest_ms=
g));
> +       if (!pdata->response)
> +               goto e_free_request;
> +
> +       /* initial the input address for guest request */
> +       pdata->input.req_gpa =3D __pa(pdata->request);
> +       pdata->input.resp_gpa =3D __pa(pdata->response);
> +       platform_data =3D pdata;
> +
> +create_ctx:
> +       ret =3D -EIO;
> +       snp_dev->ctx =3D snp_init_crypto(snp_dev->vmpck_id);
> +       if (!snp_dev->ctx) {
> +               pr_err("SNP crypto context initialization failed\n");
> +               platform_data =3D NULL;
> +               goto e_free_response;
> +       }
> +
> +       snp_dev->pdata =3D platform_data;
> +
> +       return 0;
> +
> +e_free_response:
> +       free_shared_pages(pdata->response, sizeof(struct snp_guest_msg));
> +e_free_request:
> +       free_shared_pages(pdata->request, sizeof(struct snp_guest_msg));
> +e_unmap:
> +       iounmap(pdata->layout);
> +e_free_pdata:
> +       kfree(pdata);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(snp_setup_psp_messaging);
> +
> +static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct =
snp_guest_req *guest_req,
> +                                 struct sev_guest_platform_data *pdata)
> +{
> +       struct snp_guest_msg *resp =3D &snp_dev->secret_response;
> +       struct snp_guest_msg *req =3D &snp_dev->secret_request;
> +       struct snp_guest_msg_hdr *req_hdr =3D &req->hdr;
> +       struct snp_guest_msg_hdr *resp_hdr =3D &resp->hdr;
> +       struct aesgcm_ctx *ctx =3D snp_dev->ctx;
> +       u8 iv[GCM_AES_IV_SIZE] =3D {};
> +
> +       pr_debug("response [seqno %lld type %d version %d sz %d]\n",
> +                resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_v=
ersion,
> +                resp_hdr->msg_sz);
> +
> +       /* Copy response from shared memory to encrypted memory. */
> +       memcpy(resp, pdata->response, sizeof(*resp));
> +
> +       /* Verify that the sequence counter is incremented by 1 */
> +       if (unlikely(resp_hdr->msg_seqno !=3D (req_hdr->msg_seqno + 1)))
> +               return -EBADMSG;
> +
> +       /* Verify response message type and version number. */
> +       if (resp_hdr->msg_type !=3D (req_hdr->msg_type + 1) ||
> +           resp_hdr->msg_version !=3D req_hdr->msg_version)
> +               return -EBADMSG;
> +
> +       /*
> +        * If the message size is greater than our buffer length then ret=
urn
> +        * an error.
> +        */
> +       if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp=
_sz))
> +               return -EBADMSG;
> +
> +       /* Decrypt the payload */
> +       memcpy(iv, &resp_hdr->msg_seqno, sizeof(resp_hdr->msg_seqno));
> +       if (!aesgcm_decrypt(ctx, guest_req->resp_buf, resp->payload, resp=
_hdr->msg_sz,
> +                           &resp_hdr->algo, AAD_LEN, iv, resp_hdr->autht=
ag))
> +               return -EBADMSG;
> +
> +       return 0;
> +}
> +
> +static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct =
snp_guest_req *req)
> +{
> +       struct snp_guest_msg *msg =3D &snp_dev->secret_request;
> +       struct snp_guest_msg_hdr *hdr =3D &msg->hdr;
> +       struct aesgcm_ctx *ctx =3D snp_dev->ctx;
> +       u8 iv[GCM_AES_IV_SIZE] =3D {};
> +
> +       memset(msg, 0, sizeof(*msg));
> +
> +       hdr->algo =3D SNP_AEAD_AES_256_GCM;
> +       hdr->hdr_version =3D MSG_HDR_VER;
> +       hdr->hdr_sz =3D sizeof(*hdr);
> +       hdr->msg_type =3D req->msg_type;
> +       hdr->msg_version =3D req->msg_version;
> +       hdr->msg_seqno =3D seqno;
> +       hdr->msg_vmpck =3D req->vmpck_id;
> +       hdr->msg_sz =3D req->req_sz;
> +
> +       /* Verify the sequence number is non-zero */
> +       if (!hdr->msg_seqno)
> +               return -ENOSR;
> +
> +       pr_debug("request [seqno %lld type %d version %d sz %d]\n",
> +                hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->ms=
g_sz);
> +
> +       if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload))=
)
> +               return -EBADMSG;
> +
> +       memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> +       aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr=
->algo,
> +                      AAD_LEN, iv, hdr->authtag);
> +
> +       return 0;
> +}
> +
> +static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct =
snp_guest_req *req,
> +                                 struct snp_guest_request_ioctl *rio,
> +                                 struct sev_guest_platform_data *pdata)
> +{
> +       unsigned long req_start =3D jiffies;
> +       unsigned int override_npages =3D 0;
> +       u64 override_err =3D 0;
> +       int rc;
> +
> +retry_request:
> +       /*
> +        * Call firmware to process the request. In this function the enc=
rypted
> +        * message enters shared memory with the host. So after this call=
 the
> +        * sequence number must be incremented or the VMPCK must be delet=
ed to
> +        * prevent reuse of the IV.
> +        */
> +       rc =3D snp_issue_guest_request(req, &pdata->input, rio);
> +       switch (rc) {
> +       case -ENOSPC:
> +               /*
> +                * If the extended guest request fails due to having too
> +                * small of a certificate data buffer, retry the same
> +                * guest request without the extended data request in
> +                * order to increment the sequence number and thus avoid
> +                * IV reuse.
> +                */
> +               override_npages =3D req->data_npages;
> +               req->exit_code  =3D SVM_VMGEXIT_GUEST_REQUEST;
> +
> +               /*
> +                * Override the error to inform callers the given extende=
d
> +                * request buffer size was too small and give the caller =
the
> +                * required buffer size.
> +                */
> +               override_err    =3D SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_I=
NVALID_LEN);
> +
> +               /*
> +                * If this call to the firmware succeeds, the sequence nu=
mber can
> +                * be incremented allowing for continued use of the VMPCK=
. If
> +                * there is an error reflected in the return value, this =
value
> +                * is checked further down and the result will be the del=
etion
> +                * of the VMPCK and the error code being propagated back =
to the
> +                * user as an ioctl() return code.
> +                */
> +               goto retry_request;
> +
> +       /*
> +        * The host may return SNP_GUEST_REQ_ERR_BUSY if the request has =
been
> +        * throttled. Retry in the driver to avoid returning and reusing =
the
> +        * message sequence number on a different message.
> +        */
> +       case -EAGAIN:
> +               if (jiffies - req_start > SNP_REQ_MAX_RETRY_DURATION) {
> +                       rc =3D -ETIMEDOUT;
> +                       break;
> +               }
> +               schedule_timeout_killable(SNP_REQ_RETRY_DELAY);
> +               goto retry_request;
> +       }
> +
> +       /*
> +        * Increment the message sequence number. There is no harm in doi=
ng
> +        * this now because decryption uses the value stored in the respo=
nse
> +        * structure and any failure will wipe the VMPCK, preventing furt=
her
> +        * use anyway.
> +        */
> +       snp_inc_msg_seqno(snp_dev);
> +
> +       if (override_err) {
> +               rio->exitinfo2 =3D override_err;
> +
> +               /*
> +                * If an extended guest request was issued and the suppli=
ed certificate
> +                * buffer was not large enough, a standard guest request =
was issued to
> +                * prevent IV reuse. If the standard request was successf=
ul, return -EIO
> +                * back to the caller as would have originally been retur=
ned.
> +                */
> +               if (!rc && override_err =3D=3D SNP_GUEST_VMM_ERR(SNP_GUES=
T_VMM_ERR_INVALID_LEN))
> +                       rc =3D -EIO;
> +       }
> +
> +       if (override_npages)
> +               req->data_npages =3D override_npages;
> +
> +       return rc;
> +}
> +
> +int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gue=
st_req *req,
> +                          struct snp_guest_request_ioctl *rio)
> +{
> +       struct sev_guest_platform_data *pdata;
> +       u64 seqno;
> +       int rc;
> +
> +       if (!snp_dev || !snp_dev->pdata || !req || !rio)
>                 return -ENODEV;
>
> -       pr_info("SNP guest platform device initialized.\n");
> +       pdata =3D snp_dev->pdata;
> +
> +       /* Get message sequence and verify that its a non-zero */
> +       seqno =3D snp_get_msg_seqno(snp_dev);
> +       if (!seqno)
> +               return -EIO;
> +
> +       /* Clear shared memory's response for the host to populate. */
> +       memset(pdata->response, 0, sizeof(struct snp_guest_msg));
> +
> +       /* Encrypt the userspace provided payload in pdata->secret_reques=
t. */
> +       rc =3D enc_payload(snp_dev, seqno, req);
> +       if (rc)
> +               return rc;
> +
> +       /*
> +        * Write the fully encrypted request to the shared unencrypted
> +        * request page.
> +        */
> +       memcpy(pdata->request, &snp_dev->secret_request, sizeof(snp_dev->=
secret_request));
> +
> +       rc =3D __handle_guest_request(snp_dev, req, rio, pdata);
> +       if (rc) {
> +               if (rc =3D=3D -EIO &&
> +                   rio->exitinfo2 =3D=3D SNP_GUEST_VMM_ERR(SNP_GUEST_VMM=
_ERR_INVALID_LEN))
> +                       return rc;
> +
> +               pr_alert("Detected error from ASP request. rc: %d, exitin=
fo2: 0x%llx\n",
> +                        rc, rio->exitinfo2);
> +               snp_disable_vmpck(snp_dev);
> +               return rc;
> +       }
> +
> +       rc =3D verify_and_dec_payload(snp_dev, req, pdata);
> +       if (rc) {
> +               pr_alert("Detected unexpected decode failure from ASP. rc=
: %d\n", rc);
> +               snp_disable_vmpck(snp_dev);
> +               return rc;
> +       }
> +
>         return 0;
>  }
> -device_initcall(snp_init_platform_device);
> +EXPORT_SYMBOL_GPL(snp_send_guest_request);
> +
> +bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
> +{
> +       if (WARN_ON(vmpck_id > 3))

This constant 3 should be #define'd, I believe.

> +               return false;
> +
> +       dev->vmpck_id =3D vmpck_id;
> +
> +       return true;
> +}
> +EXPORT_SYMBOL_GPL(snp_assign_vmpck);
> diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-=
guest/Kconfig
> index 0b772bd921d8..a6405ab6c2c3 100644
> --- a/drivers/virt/coco/sev-guest/Kconfig
> +++ b/drivers/virt/coco/sev-guest/Kconfig
> @@ -2,7 +2,6 @@ config SEV_GUEST
>         tristate "AMD SEV Guest driver"
>         default m
>         depends on AMD_MEM_ENCRYPT
> -       select CRYPTO_LIB_AESGCM
>         select TSM_REPORTS
>         help
>           SEV-SNP firmware provides the guest a mechanism to communicate =
with
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/=
sev-guest/sev-guest.c
> index 0f2134deca51..1cdf7ab04d39 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -31,130 +31,10 @@
>
>  #define DEVICE_NAME    "sev-guest"
>
> -#define SNP_REQ_MAX_RETRY_DURATION     (60*HZ)
> -#define SNP_REQ_RETRY_DELAY            (2*HZ)
> -
> -struct snp_guest_dev {
> -       struct device *dev;
> -       struct miscdevice misc;
> -
> -       /* Mutex to serialize the shared buffer access and command handli=
ng. */
> -       struct mutex cmd_mutex;
> -
> -       void *certs_data;
> -       struct aesgcm_ctx *ctx;
> -       /* request and response are in unencrypted memory */
> -       struct snp_guest_msg *request, *response;
> -
> -       /*
> -        * Avoid information leakage by double-buffering shared messages
> -        * in fields that are in regular encrypted memory.
> -        */
> -       struct snp_guest_msg secret_request, secret_response;
> -
> -       struct snp_secrets_page_layout *layout;
> -       struct snp_req_data input;
> -       union {
> -               struct snp_report_req report;
> -               struct snp_derived_key_req derived_key;
> -               struct snp_ext_report_req ext_report;
> -       } req;
> -       unsigned int vmpck_id;
> -};
> -
>  static u32 vmpck_id;
>  module_param(vmpck_id, uint, 0444);
>  MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with =
the PSP.");
>
> -static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
> -{
> -       return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LE=
N;
> -}
> -
> -static inline u32 *snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_d=
ev)
> -{
> -       return &snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
> -}
> -
> -static bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
> -{
> -       char zero_key[VMPCK_KEY_LEN] =3D {0};
> -       u8 *key =3D snp_get_vmpck(snp_dev);
> -
> -       return !memcmp(key, zero_key, VMPCK_KEY_LEN);
> -}
> -
> -/*
> - * If an error is received from the host or AMD Secure Processor (ASP) t=
here
> - * are two options. Either retry the exact same encrypted request or dis=
continue
> - * using the VMPCK.
> - *
> - * This is because in the current encryption scheme GHCB v2 uses AES-GCM=
 to
> - * encrypt the requests. The IV for this scheme is the sequence number. =
GCM
> - * cannot tolerate IV reuse.
> - *
> - * The ASP FW v1.51 only increments the sequence numbers on a successful
> - * guest<->ASP back and forth and only accepts messages at its exact seq=
uence
> - * number.
> - *
> - * So if the sequence number were to be reused the encryption scheme is
> - * vulnerable. If the sequence number were incremented for a fresh IV th=
e ASP
> - * will reject the request.
> - */
> -static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
> -{
> -       u8 *key =3D snp_get_vmpck(snp_dev);
> -
> -       dev_alert(snp_dev->dev, "Disabling vmpck_id %u to prevent IV reus=
e.\n",
> -                 snp_dev->vmpck_id);
> -       memzero_explicit(key, VMPCK_KEY_LEN);
> -}
> -
> -static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
> -{
> -       u32 *os_area_msg_seqno =3D snp_get_os_area_msg_seqno(snp_dev);
> -       u64 count;
> -
> -       lockdep_assert_held(&snp_dev->cmd_mutex);
> -
> -       /* Read the current message sequence counter from secrets pages *=
/
> -       count =3D *os_area_msg_seqno;
> -
> -       return count + 1;
> -}
> -
> -/* Return a non-zero on success */
> -static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
> -{
> -       u64 count =3D __snp_get_msg_seqno(snp_dev);
> -
> -       /*
> -        * The message sequence counter for the SNP guest request is a  6=
4-bit
> -        * value but the version 2 of GHCB specification defines a 32-bit=
 storage
> -        * for it. If the counter exceeds the 32-bit value then return ze=
ro.
> -        * The caller should check the return value, but if the caller ha=
ppens to
> -        * not check the value and use it, then the firmware treats zero =
as an
> -        * invalid number and will fail the  message request.
> -        */
> -       if (count >=3D UINT_MAX) {
> -               dev_err(snp_dev->dev, "request message sequence counter o=
verflow\n");
> -               return 0;
> -       }
> -
> -       return count;
> -}
> -
> -static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
> -{
> -       u32 *os_area_msg_seqno =3D snp_get_os_area_msg_seqno(snp_dev);
> -
> -       /*
> -        * The counter is also incremented by the PSP, so increment it by=
 2
> -        * and save in secrets page.
> -        */
> -       *os_area_msg_seqno +=3D 2;
> -}
> -
>  static inline struct snp_guest_dev *to_snp_dev(struct file *file)
>  {
>         struct miscdevice *dev =3D file->private_data;
> @@ -162,241 +42,6 @@ static inline struct snp_guest_dev *to_snp_dev(struc=
t file *file)
>         return container_of(dev, struct snp_guest_dev, misc);
>  }
>
> -static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
> -{
> -       struct aesgcm_ctx *ctx;
> -       u8 *key;
> -
> -       if (snp_is_vmpck_empty(snp_dev)) {
> -               pr_err("VM communication key VMPCK%u is null\n", vmpck_id=
);
> -               return NULL;
> -       }
> -
> -       ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
> -       if (!ctx)
> -               return NULL;
> -
> -       key =3D snp_get_vmpck(snp_dev);
> -       if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
> -               pr_err("Crypto context initialization failed\n");
> -               kfree(ctx);
> -               return NULL;
> -       }
> -
> -       return ctx;
> -}
> -
> -static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct =
snp_guest_req *guest_req)
> -{
> -       struct snp_guest_msg *resp =3D &snp_dev->secret_response;
> -       struct snp_guest_msg *req =3D &snp_dev->secret_request;
> -       struct snp_guest_msg_hdr *req_hdr =3D &req->hdr;
> -       struct snp_guest_msg_hdr *resp_hdr =3D &resp->hdr;
> -       struct aesgcm_ctx *ctx =3D snp_dev->ctx;
> -       u8 iv[GCM_AES_IV_SIZE] =3D {};
> -
> -       pr_debug("response [seqno %lld type %d version %d sz %d]\n",
> -                resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_v=
ersion,
> -                resp_hdr->msg_sz);
> -
> -       /* Copy response from shared memory to encrypted memory. */
> -       memcpy(resp, snp_dev->response, sizeof(*resp));
> -
> -       /* Verify that the sequence counter is incremented by 1 */
> -       if (unlikely(resp_hdr->msg_seqno !=3D (req_hdr->msg_seqno + 1)))
> -               return -EBADMSG;
> -
> -       /* Verify response message type and version number. */
> -       if (resp_hdr->msg_type !=3D (req_hdr->msg_type + 1) ||
> -           resp_hdr->msg_version !=3D req_hdr->msg_version)
> -               return -EBADMSG;
> -
> -       /*
> -        * If the message size is greater than our buffer length then ret=
urn
> -        * an error.
> -        */
> -       if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp=
_sz))
> -               return -EBADMSG;
> -
> -       /* Decrypt the payload */
> -       memcpy(iv, &resp_hdr->msg_seqno, sizeof(resp_hdr->msg_seqno));
> -       if (!aesgcm_decrypt(ctx, guest_req->resp_buf, resp->payload, resp=
_hdr->msg_sz,
> -                           &resp_hdr->algo, AAD_LEN, iv, resp_hdr->autht=
ag))
> -               return -EBADMSG;
> -
> -       return 0;
> -}
> -
> -static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct =
snp_guest_req *req)
> -{
> -       struct snp_guest_msg *msg =3D &snp_dev->secret_request;
> -       struct snp_guest_msg_hdr *hdr =3D &msg->hdr;
> -       struct aesgcm_ctx *ctx =3D snp_dev->ctx;
> -       u8 iv[GCM_AES_IV_SIZE] =3D {};
> -
> -       memset(msg, 0, sizeof(*msg));
> -
> -       hdr->algo =3D SNP_AEAD_AES_256_GCM;
> -       hdr->hdr_version =3D MSG_HDR_VER;
> -       hdr->hdr_sz =3D sizeof(*hdr);
> -       hdr->msg_type =3D req->msg_type;
> -       hdr->msg_version =3D req->msg_version;
> -       hdr->msg_seqno =3D seqno;
> -       hdr->msg_vmpck =3D req->vmpck_id;
> -       hdr->msg_sz =3D req->req_sz;
> -
> -       /* Verify the sequence number is non-zero */
> -       if (!hdr->msg_seqno)
> -               return -ENOSR;
> -
> -       pr_debug("request [seqno %lld type %d version %d sz %d]\n",
> -                hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->ms=
g_sz);
> -
> -       if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload))=
)
> -               return -EBADMSG;
> -
> -       memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> -       aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr=
->algo,
> -                      AAD_LEN, iv, hdr->authtag);
> -
> -       return 0;
> -}
> -
> -static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct =
snp_guest_req *req,
> -                                 struct snp_guest_request_ioctl *rio)
> -{
> -       unsigned long req_start =3D jiffies;
> -       unsigned int override_npages =3D 0;
> -       u64 override_err =3D 0;
> -       int rc;
> -
> -retry_request:
> -       /*
> -        * Call firmware to process the request. In this function the enc=
rypted
> -        * message enters shared memory with the host. So after this call=
 the
> -        * sequence number must be incremented or the VMPCK must be delet=
ed to
> -        * prevent reuse of the IV.
> -        */
> -       rc =3D snp_issue_guest_request(req, &snp_dev->input, rio);
> -       switch (rc) {
> -       case -ENOSPC:
> -               /*
> -                * If the extended guest request fails due to having too
> -                * small of a certificate data buffer, retry the same
> -                * guest request without the extended data request in
> -                * order to increment the sequence number and thus avoid
> -                * IV reuse.
> -                */
> -               override_npages =3D req->data_npages;
> -               req->exit_code  =3D SVM_VMGEXIT_GUEST_REQUEST;
> -
> -               /*
> -                * Override the error to inform callers the given extende=
d
> -                * request buffer size was too small and give the caller =
the
> -                * required buffer size.
> -                */
> -               override_err =3D SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVA=
LID_LEN);
> -
> -               /*
> -                * If this call to the firmware succeeds, the sequence nu=
mber can
> -                * be incremented allowing for continued use of the VMPCK=
. If
> -                * there is an error reflected in the return value, this =
value
> -                * is checked further down and the result will be the del=
etion
> -                * of the VMPCK and the error code being propagated back =
to the
> -                * user as an ioctl() return code.
> -                */
> -               goto retry_request;
> -
> -       /*
> -        * The host may return SNP_GUEST_VMM_ERR_BUSY if the request has =
been
> -        * throttled. Retry in the driver to avoid returning and reusing =
the
> -        * message sequence number on a different message.
> -        */
> -       case -EAGAIN:
> -               if (jiffies - req_start > SNP_REQ_MAX_RETRY_DURATION) {
> -                       rc =3D -ETIMEDOUT;
> -                       break;
> -               }
> -               schedule_timeout_killable(SNP_REQ_RETRY_DELAY);
> -               goto retry_request;
> -       }
> -
> -       /*
> -        * Increment the message sequence number. There is no harm in doi=
ng
> -        * this now because decryption uses the value stored in the respo=
nse
> -        * structure and any failure will wipe the VMPCK, preventing furt=
her
> -        * use anyway.
> -        */
> -       snp_inc_msg_seqno(snp_dev);
> -
> -       if (override_err) {
> -               rio->exitinfo2 =3D override_err;
> -
> -               /*
> -                * If an extended guest request was issued and the suppli=
ed certificate
> -                * buffer was not large enough, a standard guest request =
was issued to
> -                * prevent IV reuse. If the standard request was successf=
ul, return -EIO
> -                * back to the caller as would have originally been retur=
ned.
> -                */
> -               if (!rc && override_err =3D=3D SNP_GUEST_VMM_ERR(SNP_GUES=
T_VMM_ERR_INVALID_LEN))
> -                       rc =3D -EIO;
> -       }
> -
> -       if (override_npages)
> -               req->data_npages =3D override_npages;
> -
> -       return rc;
> -}
> -
> -static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct =
snp_guest_req *req,
> -                                 struct snp_guest_request_ioctl *rio)
> -{
> -       u64 seqno;
> -       int rc;
> -
> -       /* Get message sequence and verify that its a non-zero */
> -       seqno =3D snp_get_msg_seqno(snp_dev);
> -       if (!seqno)
> -               return -EIO;
> -
> -       /* Clear shared memory's response for the host to populate. */
> -       memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
> -
> -       /* Encrypt the userspace provided payload in snp_dev->secret_requ=
est. */
> -       rc =3D enc_payload(snp_dev, seqno, req);
> -       if (rc)
> -               return rc;
> -
> -       /*
> -        * Write the fully encrypted request to the shared unencrypted
> -        * request page.
> -        */
> -       memcpy(snp_dev->request, &snp_dev->secret_request,
> -              sizeof(snp_dev->secret_request));
> -
> -       rc =3D __handle_guest_request(snp_dev, req, rio);
> -       if (rc) {
> -               if (rc =3D=3D -EIO &&
> -                   rio->exitinfo2 =3D=3D SNP_GUEST_VMM_ERR(SNP_GUEST_VMM=
_ERR_INVALID_LEN))
> -                       return rc;
> -
> -               dev_alert(snp_dev->dev,
> -                         "Detected error from ASP request. rc: %d, exiti=
nfo2: 0x%llx\n",
> -                         rc, rio->exitinfo2);
> -               snp_disable_vmpck(snp_dev);
> -               return rc;
> -       }
> -
> -       rc =3D verify_and_dec_payload(snp_dev, req);
> -       if (rc) {
> -               dev_alert(snp_dev->dev, "Detected unexpected decode failu=
re from ASP. rc: %d\n", rc);
> -               snp_disable_vmpck(snp_dev);
> -               return rc;
> -       }
> -
> -       return 0;
> -}
> -
>  struct snp_req_resp {
>         sockptr_t req_data;
>         sockptr_t resp_data;
> @@ -607,7 +252,7 @@ static long snp_guest_ioctl(struct file *file, unsign=
ed int ioctl, unsigned long
>         mutex_lock(&snp_dev->cmd_mutex);
>
>         /* Check if the VMPCK is not empty */
> -       if (snp_is_vmpck_empty(snp_dev)) {
> +       if (snp_is_vmpck_empty(snp_dev->vmpck_id)) {
>                 dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>                 mutex_unlock(&snp_dev->cmd_mutex);
>                 return -ENOTTY;
> @@ -642,58 +287,11 @@ static long snp_guest_ioctl(struct file *file, unsi=
gned int ioctl, unsigned long
>         return ret;
>  }
>
> -static void free_shared_pages(void *buf, size_t sz)
> -{
> -       unsigned int npages =3D PAGE_ALIGN(sz) >> PAGE_SHIFT;
> -       int ret;
> -
> -       if (!buf)
> -               return;
> -
> -       ret =3D set_memory_encrypted((unsigned long)buf, npages);
> -       if (ret) {
> -               WARN_ONCE(ret, "failed to restore encryption mask (leak i=
t)\n");
> -               return;
> -       }
> -
> -       __free_pages(virt_to_page(buf), get_order(sz));
> -}
> -
> -static void *alloc_shared_pages(struct device *dev, size_t sz)
> -{
> -       unsigned int npages =3D PAGE_ALIGN(sz) >> PAGE_SHIFT;
> -       struct page *page;
> -       int ret;
> -
> -       page =3D alloc_pages(GFP_KERNEL_ACCOUNT, get_order(sz));
> -       if (!page)
> -               return NULL;
> -
> -       ret =3D set_memory_decrypted((unsigned long)page_address(page), n=
pages);
> -       if (ret) {
> -               dev_err(dev, "failed to mark page shared, ret=3D%d\n", re=
t);
> -               __free_pages(page, get_order(sz));
> -               return NULL;
> -       }
> -
> -       return page_address(page);
> -}
> -
>  static const struct file_operations snp_guest_fops =3D {
>         .owner  =3D THIS_MODULE,
>         .unlocked_ioctl =3D snp_guest_ioctl,
>  };
>
> -bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
> -{
> -       if (WARN_ON(vmpck_id > 3))
> -               return false;
> -
> -       dev->vmpck_id =3D vmpck_id;
> -
> -       return true;
> -}
> -
>  struct snp_msg_report_resp_hdr {
>         u32 status;
>         u32 report_size;
> @@ -727,7 +325,7 @@ static int sev_report_new(struct tsm_report *report, =
void *data)
>         guard(mutex)(&snp_dev->cmd_mutex);
>
>         /* Check if the VMPCK is not empty */
> -       if (snp_is_vmpck_empty(snp_dev)) {
> +       if (snp_is_vmpck_empty(snp_dev->vmpck_id)) {
>                 dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>                 return -ENOTTY;
>         }
> @@ -820,76 +418,43 @@ static void unregister_sev_tsm(void *data)
>
>  static int __init sev_guest_probe(struct platform_device *pdev)
>  {
> -       struct snp_secrets_page_layout *layout;
> -       struct sev_guest_platform_data *data;
>         struct device *dev =3D &pdev->dev;
>         struct snp_guest_dev *snp_dev;
>         struct miscdevice *misc;
> -       void __iomem *mapping;
>         int ret;
>
>         if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
>                 return -ENODEV;
>
> -       if (!dev->platform_data)
> -               return -ENODEV;
> -
> -       data =3D (struct sev_guest_platform_data *)dev->platform_data;
> -       mapping =3D ioremap_encrypted(data->secrets_gpa, PAGE_SIZE);
> -       if (!mapping)
> -               return -ENODEV;
> -
> -       layout =3D (__force void *)mapping;
> -
> -       ret =3D -ENOMEM;
>         snp_dev =3D devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev)=
, GFP_KERNEL);
>         if (!snp_dev)
> -               goto e_unmap;
> +               return -ENOMEM;
>
> -       ret =3D -EINVAL;
> -       snp_dev->layout =3D layout;
>         if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
>                 dev_err(dev, "invalid vmpck id %u\n", vmpck_id);
> -               goto e_unmap;
> +               ret =3D -EINVAL;
> +               goto e_free_snpdev;
>         }
>
> -       /* Verify that VMPCK is not zero. */
> -       if (snp_is_vmpck_empty(snp_dev)) {
> -               dev_err(dev, "vmpck id %u is null\n", vmpck_id);
> -               goto e_unmap;
> +       if (snp_setup_psp_messaging(snp_dev)) {
> +               dev_err(dev, "Unable to setup PSP messaging vmpck id %u\n=
", snp_dev->vmpck_id);
> +               ret =3D -ENODEV;
> +               goto e_free_snpdev;
>         }
>
>         mutex_init(&snp_dev->cmd_mutex);
>         platform_set_drvdata(pdev, snp_dev);
>         snp_dev->dev =3D dev;
>
> -       /* Allocate the shared page used for the request and response mes=
sage. */
> -       snp_dev->request =3D alloc_shared_pages(dev, sizeof(struct snp_gu=
est_msg));
> -       if (!snp_dev->request)
> -               goto e_unmap;
> -
> -       snp_dev->response =3D alloc_shared_pages(dev, sizeof(struct snp_g=
uest_msg));
> -       if (!snp_dev->response)
> -               goto e_free_request;
> -
> -       snp_dev->certs_data =3D alloc_shared_pages(dev, SEV_FW_BLOB_MAX_S=
IZE);
> +       snp_dev->certs_data =3D alloc_shared_pages(SEV_FW_BLOB_MAX_SIZE);
>         if (!snp_dev->certs_data)
> -               goto e_free_response;
> -
> -       ret =3D -EIO;
> -       snp_dev->ctx =3D snp_init_crypto(snp_dev);
> -       if (!snp_dev->ctx)
> -               goto e_free_cert_data;
> +               goto e_free_ctx;
>
>         misc =3D &snp_dev->misc;
>         misc->minor =3D MISC_DYNAMIC_MINOR;
>         misc->name =3D DEVICE_NAME;
>         misc->fops =3D &snp_guest_fops;
>
> -       /* initial the input address for guest request */
> -       snp_dev->input.req_gpa =3D __pa(snp_dev->request);
> -       snp_dev->input.resp_gpa =3D __pa(snp_dev->response);
> -
>         ret =3D tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_typ=
e);
>         if (ret)
>                 goto e_free_cert_data;
> @@ -900,21 +465,18 @@ static int __init sev_guest_probe(struct platform_d=
evice *pdev)
>
>         ret =3D  misc_register(misc);
>         if (ret)
> -               goto e_free_ctx;
> +               goto e_free_cert_data;
> +
> +       dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n=
", snp_dev->vmpck_id);
>
> -       dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n=
", vmpck_id);
>         return 0;
>
> -e_free_ctx:
> -       kfree(snp_dev->ctx);
>  e_free_cert_data:
>         free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> -e_free_response:
> -       free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg)=
);
> -e_free_request:
> -       free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg))=
;
> -e_unmap:
> -       iounmap(mapping);
> +e_free_ctx:
> +       kfree(snp_dev->ctx);
> +e_free_snpdev:
> +       kfree(snp_dev);
>         return ret;
>  }
>
> @@ -923,10 +485,9 @@ static int __exit sev_guest_remove(struct platform_d=
evice *pdev)
>         struct snp_guest_dev *snp_dev =3D platform_get_drvdata(pdev);
>
>         free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> -       free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg)=
);
> -       free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg))=
;
> -       kfree(snp_dev->ctx);
>         misc_deregister(&snp_dev->misc);
> +       kfree(snp_dev->ctx);
> +       kfree(snp_dev);
>
>         return 0;
>  }
> --
> 2.34.1
>


--=20
-Dionna Glaze, PhD (she/her)

