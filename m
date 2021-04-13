Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8729935D43F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344217AbhDMAEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243704AbhDMAEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:04:48 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA27DC061756
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:04:27 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r5so4434355ilb.2
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p6IckBE1LGhj5jhSwbz/B3sx7IuS+wP3iwwX3r/RBIg=;
        b=ChGVRjJ3oj84fNCt9XfZvHM+RyXfZpASJkD9z9jHttGHl8MJEABhFABlaPcVNrrMyd
         Sf8XoOua+W7c2rucsmFirCxeQxLNyJ0bXa4VjVy5Lro0ZOy95pPu5PFWw1g1OGt6rel/
         bfGq4XOIxzwcCKntwf3iH44QImrfQLTQ9ubdzGrEbIzCw/TiEgPy3HlKP+2o3k+NnhfI
         LI9EZ2ReFhC30sC91zQdg1SbVRAYdZ/Jg8SIzQ8Eqn25IsR4EozKwXvUjVduSoum34HH
         sBqmqfubOc6A1zYV9qWKPEkhF4V/pgNuFidYb+74cacZDui0pl0HdJlVk/ITTvnR2RbT
         kvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6IckBE1LGhj5jhSwbz/B3sx7IuS+wP3iwwX3r/RBIg=;
        b=N0dvdZ6az5/SFV9QQyPSaGyFWcjxRMshq/ICP+BWacKTOdNDboKyDhHc1kjJwIFAD0
         CjzfFgP8YybBT4eWw4MhhroZoTHx2y10jnw7QRftwbJx8+bynWjlCb4C2O5jAEt1qBDI
         LnQ0W8tgfSrcAwiUrB6aCcEMm/GdWb/Na+CTpw8RilMZyntfB8nf8SCZEavzSoUYXPGA
         GRvcn8Qh29jZ81aPKVHTW3ug+ZWcUIaeI9nM8XaDeV2SsYCEZ6QC6P3G1yPenW0b5J5I
         rhjREPhFBl7I4jV14EWcpOS32myNDbhn0bwt0h4Y6Yx40D/qcvuX11YC5CNHN0JG4EMI
         rvOQ==
X-Gm-Message-State: AOAM530MgFcbMvuK0lgOrJfnkn2icM8EZ7xjGykgsnrsClGlljSgeUzv
        mJfhgeyjWce17NO9TEN8VbMNlnbmqlbcfyfjnmWp8g==
X-Google-Smtp-Source: ABdhPJzq8+0mgicwyIBGTk1RkAnUEipQNwjP8fPJkVNv0BJ6pvZKXvEIDKmNRd73Zj6wrrt4F0GqI56OVkCYC31K1Wg=
X-Received: by 2002:a05:6e02:12c4:: with SMTP id i4mr1794471ilm.79.1618272267012;
 Mon, 12 Apr 2021 17:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <c7400111ed7458eee01007c4d8d57cdf2cbb0fc2.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <c7400111ed7458eee01007c4d8d57cdf2cbb0fc2.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:03:50 -0700
Message-ID: <CABayD+e4Avc0D4oRANeW_GajvTrhLe2RQWnifYfQ1dm27=fV9w@mail.gmail.com>
Subject: Re: [PATCH v12 04/13] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:44 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The command is used to create the encryption context for an incoming
> SEV guest. The encryption context can be later used by the hypervisor
> to import the incoming data into the SEV guest memory space.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        | 29 +++++++
>  arch/x86/kvm/svm/sev.c                        | 81 +++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  9 +++
>  3 files changed, 119 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 26c4e6c83f62..c86c1ded8dd8 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -343,6 +343,35 @@ issued by the hypervisor to delete the encryption context.
>
>  Returns: 0 on success, -negative on error
>
> +13. KVM_SEV_RECEIVE_START
> +------------------------
> +
> +The KVM_SEV_RECEIVE_START command is used for creating the memory encryption
> +context for an incoming SEV guest. To create the encryption context, the user must
> +provide a guest policy, the platform public Diffie-Hellman (PDH) key and session
> +information.
> +
> +Parameters: struct  kvm_sev_receive_start (in/out)
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_receive_start {
> +                __u32 handle;           /* if zero then firmware creates a new handle */
> +                __u32 policy;           /* guest's policy */
> +
> +                __u64 pdh_uaddr;        /* userspace address pointing to the PDH key */
> +                __u32 pdh_len;
> +
> +                __u64 session_uaddr;    /* userspace address which points to the guest session information */
> +                __u32 session_len;
> +        };
> +
> +On success, the 'handle' field contains a new handle and on error, a negative value.
> +
> +For more details, see SEV spec Section 6.12.
> +
>  References
>  ==========
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 92325d9527ce..e530c2b34b5e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1370,6 +1370,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_receive_start *start;
> +       struct kvm_sev_receive_start params;
> +       int *error = &argp->error;
> +       void *session_data;
> +       void *pdh_data;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       /* Get parameter from the userspace */
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +                       sizeof(struct kvm_sev_receive_start)))
> +               return -EFAULT;
> +
> +       /* some sanity checks */
> +       if (!params.pdh_uaddr || !params.pdh_len ||
> +           !params.session_uaddr || !params.session_len)
> +               return -EINVAL;
> +
> +       pdh_data = psp_copy_user_blob(params.pdh_uaddr, params.pdh_len);
> +       if (IS_ERR(pdh_data))
> +               return PTR_ERR(pdh_data);
> +
> +       session_data = psp_copy_user_blob(params.session_uaddr,
> +                       params.session_len);
> +       if (IS_ERR(session_data)) {
> +               ret = PTR_ERR(session_data);
> +               goto e_free_pdh;
> +       }
> +
> +       ret = -ENOMEM;
> +       start = kzalloc(sizeof(*start), GFP_KERNEL);
> +       if (!start)
> +               goto e_free_session;
> +
> +       start->handle = params.handle;
> +       start->policy = params.policy;
> +       start->pdh_cert_address = __psp_pa(pdh_data);
> +       start->pdh_cert_len = params.pdh_len;
> +       start->session_address = __psp_pa(session_data);
> +       start->session_len = params.session_len;
> +
> +       /* create memory encryption context */
> +       ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, start,
> +                               error);
> +       if (ret)
> +               goto e_free;
> +
> +       /* Bind ASID to this guest */
> +       ret = sev_bind_asid(kvm, start->handle, error);
> +       if (ret)
> +               goto e_free;
> +
> +       params.handle = start->handle;
> +       if (copy_to_user((void __user *)(uintptr_t)argp->data,
> +                        &params, sizeof(struct kvm_sev_receive_start))) {
> +               ret = -EFAULT;
> +               sev_unbind_asid(kvm, start->handle);
> +               goto e_free;
> +       }
> +
> +       sev->handle = start->handle;
> +       sev->fd = argp->sev_fd;
> +
> +e_free:
> +       kfree(start);
> +e_free_session:
> +       kfree(session_data);
> +e_free_pdh:
> +       kfree(pdh_data);
> +
> +       return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -1432,6 +1510,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_SEND_FINISH:
>                 r = sev_send_finish(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_RECEIVE_START:
> +               r = sev_receive_start(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d45af34c31be..29c25e641a0c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1750,6 +1750,15 @@ struct kvm_sev_send_update_data {
>         __u32 trans_len;
>  };
>
> +struct kvm_sev_receive_start {
> +       __u32 handle;
> +       __u32 policy;
> +       __u64 pdh_uaddr;
> +       __u32 pdh_len;
> +       __u64 session_uaddr;
> +       __u32 session_len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.17.1
>
Reviewed-by: Steve Rutherford <srutherford@google.com>
