Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5BB35D43D
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242473AbhDMAEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239114AbhDMAEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:04:35 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A902EC061756
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:04:16 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id 6so12606048ilt.9
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ea18y28l3YX2gvgE5E4K39NKsgQumVKltpE9KYNGCIE=;
        b=Kwi9jiYocCoKchje8t4n/zzcIXXo/8pmVfsqrneIt4rKPMc+OY87Wy66oiaJeQvoz0
         kBhA93tkpBuGRV7RiI4Y+2vqec5e2XYI2J/LVzIXPMO/xosQ8jTjjBD5LPlF6WY4cZ63
         qxK5XDSNS8oG+NWoU26cRn/V16ipbXZ88rZ4EgFnzVB0mWuDYp9E5gqqE2zSip+H1UkF
         6UiiQaiw1GRu6QjC4gxsABIzouNHqb2lKcgNWbg/AJ8aA0WblV2FFpttk+WuCpMuZDlS
         +/5/6pokHIevBzJhjEy0BzWr47vwpAq/h3frHiR4DES4kj/lkIBgoSZYl2kxjvSd61We
         ea8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ea18y28l3YX2gvgE5E4K39NKsgQumVKltpE9KYNGCIE=;
        b=GpyYIruR7djf4URUQsVDZrrcqfmHzV6tdwbDrnbub4bpr+FvjwCMwCGUYb4ybXHbh2
         KvstkZZ81tLDTaiLxooKOEanr9vgPh7PnQovCSh+K5Rp/LWs9tsOwm2L6u1E439RU16p
         nvHIoYhtiFbJKBrYbbH4PEIszAk5oHNWqJtlHOItzrlVbMqV1eQk+ivWH5Mrc8FGY8Be
         gqIjlsYDUZCUfHxznJ/Od8TMukfYNVP018srOf4EuS6bWWRwvkSF/YWxVrRLub3tWdmb
         zCKwRC7aVAVma+neT0djs5cZdCLs1dzH9AW6GM0NKV1n4t73glTrdbKRLJ7XnfeGmZcs
         65NQ==
X-Gm-Message-State: AOAM533/Crv4FxJgD6DBab4I319LE5XoTUbYOmGfbxsW88EnmU52MiXL
        p/XWCMS8+QFccZKP5MZ5CuCUbJgfpziqOuWjDeb/uQ==
X-Google-Smtp-Source: ABdhPJyDHmARxXJCeffxa4G4n1laMz0jLdBqSwm/RdTbjspbGcqb/HNhx5e5ZReu+TrU0qgRIIheAX4bXSv77Ayvugo=
X-Received: by 2002:a05:6e02:1e08:: with SMTP id g8mr25426604ila.176.1618272255769;
 Mon, 12 Apr 2021 17:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <5082bd6a8539d24bc55a1dd63a1b341245bb168f.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <5082bd6a8539d24bc55a1dd63a1b341245bb168f.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:03:39 -0700
Message-ID: <CABayD+eTGXL+EcTF0vm2-ORhZxbELqZo27b6HrMjnrmyY8DrZw@mail.gmail.com>
Subject: Re: [PATCH v12 03/13] KVM: SVM: Add KVM_SEV_SEND_FINISH command
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
> The command is used to finailize the encryption context created with
> KVM_SEV_SEND_START command.
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
>  .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
>  arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 3c5456e0268a..26c4e6c83f62 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -335,6 +335,14 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>
> +12. KVM_SEV_SEND_FINISH
> +------------------------
> +
> +After completion of the migration flow, the KVM_SEV_SEND_FINISH command can be
> +issued by the hypervisor to delete the encryption context.
> +
> +Returns: 0 on success, -negative on error
> +
>  References
>  ==========
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 30527285a39a..92325d9527ce 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1350,6 +1350,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_send_finish *data;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       data->handle = sev->handle;
> +       ret = sev_issue_cmd(kvm, SEV_CMD_SEND_FINISH, data, &argp->error);
> +
> +       kfree(data);
> +       return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -1409,6 +1429,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_SEND_UPDATE_DATA:
>                 r = sev_send_update_data(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_SEND_FINISH:
> +               r = sev_send_finish(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> --
> 2.17.1
>
Reviewed-by: Steve Rutherford <srutherford@google.com>
