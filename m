Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9BA2D3C84
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 08:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgLIHww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 02:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbgLIHww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 02:52:52 -0500
X-Gm-Message-State: AOAM532CyUJejyv/56a4eKV6r93lkUDiwhRTc4MhYB3LH+X7WeahVDMt
        h8PKLIYOiCWCJOw2ia7uSPtis2mWcD0BWpH4bwk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607500293;
        bh=OEQSYtYb9NVegyVw846n4Oj+FsIUHUrywKo9JP+Mzxk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Sum/Mv9KTKsuXnyljn+CR2uqjs3V8AAGrxYc3UxzU6vr6fhlgw1vr1TyrYTW4cZpw
         fesxqOqeu5BK0zYg+Jr+uSryZSZY0BAufyEXWeKSwy4pnnAEC+dlHaLBQKdaTs3bB4
         AiWjIC3zRoqjsHOJDAFpLzowzZQJsqYXMiUCsCdOEc1UZIR09miqTy+pS4NndVwv+d
         /dz1lphsikuxvwoZKakZEls5khqXPy2znmOpgzGUDV99kHZP+d5Wo3t9NV/g8dKV5S
         fD7nq6ZspYmBHjqJNydTtypd1TfUKYscG0jt94l+cGjyGMwn8nnUpqP/cSxzGWS/0T
         EGW5cD56jh7Jg==
X-Google-Smtp-Source: ABdhPJxW0H5yIBMW0GtzKADzByU+brtAwQ+8wQSMZwDc6hliuCHMHu4QzBZWYSE5pcmAZ+nmWyAfPGd4XL5ysSRkLwg=
X-Received: by 2002:aca:5ec2:: with SMTP id s185mr896367oib.33.1607500292653;
 Tue, 08 Dec 2020 23:51:32 -0800 (PST)
MIME-Version: 1.0
References: <20201204212847.13256-1-brijesh.singh@amd.com>
In-Reply-To: <20201204212847.13256-1-brijesh.singh@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 9 Dec 2020 08:51:21 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFkyJwZ4BGSU-4UB5VR1etJ6atb7YpWMTzzBuu9FQKagA@mail.gmail.com>
Message-ID: <CAMj1kXFkyJwZ4BGSU-4UB5VR1etJ6atb7YpWMTzzBuu9FQKagA@mail.gmail.com>
Subject: Re: [PATCH] KVM/SVM: add support for SEV attestation command
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Dec 2020 at 22:30, Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> The SEV FW version >= 0.23 added a new command that can be used to query
> the attestation report containing the SHA-256 digest of the guest memory
> encrypted through the KVM_SEV_LAUNCH_UPDATE_{DATA, VMSA} commands and
> sign the report with the Platform Endorsement Key (PEK).
>
> See the SEV FW API spec section 6.8 for more details.
>
> Note there already exist a command (KVM_SEV_LAUNCH_MEASURE) that can be
> used to get the SHA-256 digest. The main difference between the
> KVM_SEV_LAUNCH_MEASURE and KVM_SEV_ATTESTATION_REPORT is that the later

latter

> can be called while the guest is running and the measurement value is
> signed with PEK.
>
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: John Allen <john.allen@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        | 21 ++++++
>  arch/x86/kvm/svm/sev.c                        | 71 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 17 +++++
>  include/uapi/linux/kvm.h                      |  8 +++
>  5 files changed, 118 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 09a8f2a34e39..4c6685d0fddd 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -263,6 +263,27 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>
> +10. KVM_SEV_GET_ATTESATION_REPORT

KVM_SEV_GET_ATTESTATION_REPORT

> +---------------------------------
> +
> +The KVM_SEV_GET_ATTESATION_REPORT command can be used by the hypervisor to query the attestation

KVM_SEV_GET_ATTESTATION_REPORT

> +report containing the SHA-256 digest of the guest memory and VMSA passed through the KVM_SEV_LAUNCH
> +commands and signed with the PEK. The digest returned by the command should match the digest
> +used by the guest owner with the KVM_SEV_LAUNCH_MEASURE.
> +
> +Parameters (in): struct kvm_sev_attestation
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_attestation_report {
> +                __u8 mnonce[16];        /* A random mnonce that will be placed in the report */
> +
> +                __u64 uaddr;            /* userspace address where the report should be copied */
> +                __u32 len;
> +        };
> +
>  References
>  ==========
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 566f4d18185b..c4d3ee6be362 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -927,6 +927,74 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       void __user *report = (void __user *)(uintptr_t)argp->data;
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_attestation_report *data;
> +       struct kvm_sev_attestation_report params;
> +       void __user *p;
> +       void *blob = NULL;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +               return -EFAULT;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       /* User wants to query the blob length */
> +       if (!params.len)
> +               goto cmd;
> +
> +       p = (void __user *)(uintptr_t)params.uaddr;
> +       if (p) {
> +               if (params.len > SEV_FW_BLOB_MAX_SIZE) {
> +                       ret = -EINVAL;
> +                       goto e_free;
> +               }
> +
> +               ret = -ENOMEM;
> +               blob = kmalloc(params.len, GFP_KERNEL);
> +               if (!blob)
> +                       goto e_free;
> +
> +               data->address = __psp_pa(blob);
> +               data->len = params.len;
> +               memcpy(data->mnonce, params.mnonce, sizeof(params.mnonce));
> +       }
> +cmd:
> +       data->handle = sev->handle;
> +       ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, data, &argp->error);
> +       /*
> +        * If we query the session length, FW responded with expected data.
> +        */
> +       if (!params.len)
> +               goto done;
> +
> +       if (ret)
> +               goto e_free_blob;
> +
> +       if (blob) {
> +               if (copy_to_user(p, blob, params.len))
> +                       ret = -EFAULT;
> +       }
> +
> +done:
> +       params.len = data->len;
> +       if (copy_to_user(report, &params, sizeof(params)))
> +               ret = -EFAULT;
> +e_free_blob:
> +       kfree(blob);
> +e_free:
> +       kfree(data);
> +       return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -971,6 +1039,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_LAUNCH_SECRET:
>                 r = sev_launch_secret(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_GET_ATTESTATION_REPORT:
> +               r = sev_get_attestation_report(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 476113e12489..cb9b4c4e371e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -128,6 +128,7 @@ static int sev_cmd_buffer_len(int cmd)
>         case SEV_CMD_LAUNCH_UPDATE_SECRET:      return sizeof(struct sev_data_launch_secret);
>         case SEV_CMD_DOWNLOAD_FIRMWARE:         return sizeof(struct sev_data_download_firmware);
>         case SEV_CMD_GET_ID:                    return sizeof(struct sev_data_get_id);
> +       case SEV_CMD_ATTESTATION_REPORT:        return sizeof(struct sev_data_attestation_report);
>         default:                                return 0;
>         }
>
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 49d155cd2dfe..b801ead1e2bb 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -66,6 +66,7 @@ enum sev_cmd {
>         SEV_CMD_LAUNCH_MEASURE          = 0x033,
>         SEV_CMD_LAUNCH_UPDATE_SECRET    = 0x034,
>         SEV_CMD_LAUNCH_FINISH           = 0x035,
> +       SEV_CMD_ATTESTATION_REPORT      = 0x036,
>
>         /* Guest migration commands (outgoing) */
>         SEV_CMD_SEND_START              = 0x040,
> @@ -483,6 +484,22 @@ struct sev_data_dbg {
>         u32 len;                                /* In */
>  } __packed;
>
> +/**
> + * struct sev_data_attestation_report - SEV_ATTESTATION_REPORT command parameters
> + *
> + * @handle: handle of the VM
> + * @mnonce: a random nonce that will be included in the report.
> + * @address: physical address where the report will be copied.
> + * @len: length of the physical buffer.
> + */
> +struct sev_data_attestation_report {
> +       u32 handle;                             /* In */
> +       u32 reserved;
> +       u64 address;                            /* In */
> +       u8 mnonce[16];                          /* In */
> +       u32 len;                                /* In/Out */
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>
>  /**
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..d3385f7f08a2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1585,6 +1585,8 @@ enum sev_cmd_id {
>         KVM_SEV_DBG_ENCRYPT,
>         /* Guest certificates commands */
>         KVM_SEV_CERT_EXPORT,
> +       /* Attestation report */
> +       KVM_SEV_GET_ATTESTATION_REPORT,
>
>         KVM_SEV_NR_MAX,
>  };
> @@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
>         __u32 len;
>  };
>
> +struct kvm_sev_attestation_report {
> +       __u8 mnonce[16];
> +       __u64 uaddr;
> +       __u32 len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.17.1
>
