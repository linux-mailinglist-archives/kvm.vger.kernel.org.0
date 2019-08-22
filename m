Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571059905D
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbfHVKIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:08:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:53134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732938AbfHVKIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:08:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F080AC64;
        Thu, 22 Aug 2019 10:08:23 +0000 (UTC)
Date:   Thu, 22 Aug 2019 12:08:18 +0200
From:   Borislav Petkov <bp@suse.de>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/11] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20190822100818.GB11845@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-2-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710201244.25195-2-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:13:00PM +0000, Singh, Brijesh wrote:
> The command is used to create an outgoing SEV guest encryption context.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  .../virtual/kvm/amd-memory-encryption.rst     |  27 +++++
>  arch/x86/kvm/svm.c                            | 105 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  12 ++
>  3 files changed, 144 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/amd-memory-encryption.rst b/Documentation/virtual/kvm/amd-memory-encryption.rst
> index d18c97b4e140..0e9e1e9f9687 100644
> --- a/Documentation/virtual/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virtual/kvm/amd-memory-encryption.rst

Do a

s/virtual/virt/g

for the next revision because this path got changed recently:

2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")

> @@ -238,6 +238,33 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>  
> +10. KVM_SEV_SEND_START
> +----------------------
> +
> +The KVM_SEV_SEND_START command can be used by the hypervisor to create an
> +outgoing guest encryption context.
> +
> +Parameters (in): struct kvm_sev_send_start
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +        struct kvm_sev_send_start {
> +                __u32 policy;                 /* guest policy */
> +
> +                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
> +                __u32 pdh_cert_len;
> +
> +                __u64 plat_cert_uaddr;        /* platform certificate chain */
> +                __u32 plat_cert_len;
> +
> +                __u64 amd_cert_uaddr;         /* AMD certificate */
> +                __u32 amd_cert_len;
> +
> +                __u64 session_uaddr;         /* Guest session information */
> +                __u32 session_len;
> +        };

SEV API doc has "CERT" for PDH members but "CERTS" for the others.
Judging by the description, you should do the same here too. Just so that
there's no discrepancy from the docs.

> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 48c865a4e5dd..0b0937f53520 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6957,6 +6957,108 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	void *amd_cert = NULL, *session_data = NULL;
> +	void *pdh_cert = NULL, *plat_cert = NULL;
> +	struct sev_data_send_start *data = NULL;

Why are you initializing those to NULL?

Also, SEV API text on SEND_START talks about a bunch of requirements in
section

"6.8.1 Actions"

like

"The platform must be in the PSTATE.WORKING state.
The guest must be in the GSTATE.RUNNING state.
GCTX.POLICY.NOSEND must be zero. Otherwise, an error is returned.
..."

Where are we checking/verifying those?

> +	struct kvm_sev_send_start params;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +				sizeof(struct kvm_sev_send_start)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;

Move that allocation...

> +
> +	/* userspace wants to query the session length */
> +	if (!params.session_len)
> +		goto cmd;
> +
> +	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> +	    !params.session_uaddr)
> +		return -EINVAL;
> +
> +	/* copy the certificate blobs from userspace */
> +	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr, params.pdh_cert_len);
> +	if (IS_ERR(pdh_cert)) {
> +		ret = PTR_ERR(pdh_cert);
> +		goto e_free;
> +	}

... here so that it doesn't happen unnecessarily if the above fail.

> +
> +	data->pdh_cert_address = __psp_pa(pdh_cert);
> +	data->pdh_cert_len = params.pdh_cert_len;
> +
> +	plat_cert = psp_copy_user_blob(params.plat_cert_uaddr, params.plat_cert_len);
> +	if (IS_ERR(plat_cert)) {
> +		ret = PTR_ERR(plat_cert);
> +		goto e_free_pdh;
> +	}
> +
> +	data->plat_cert_address = __psp_pa(plat_cert);
> +	data->plat_cert_len = params.plat_cert_len;
> +
> +	amd_cert = psp_copy_user_blob(params.amd_cert_uaddr, params.amd_cert_len);
> +	if (IS_ERR(amd_cert)) {
> +		ret = PTR_ERR(amd_cert);
> +		goto e_free_plat_cert;
> +	}
> +
> +	data->amd_cert_address = __psp_pa(amd_cert);
> +	data->amd_cert_len = params.amd_cert_len;
> +
> +	ret = -EINVAL;
> +	if (params.session_len > SEV_FW_BLOB_MAX_SIZE)
> +		goto e_free_amd_cert;

That check could go up where the other params.session_len check is
happening and you can save yourself the cert alloc+freeing.

> +
> +	ret = -ENOMEM;
> +	session_data = kmalloc(params.session_len, GFP_KERNEL);
> +	if (!session_data)
> +		goto e_free_amd_cert;

Ditto.

...

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
