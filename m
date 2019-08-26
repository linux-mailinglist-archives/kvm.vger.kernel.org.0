Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A1E9D090
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbfHZN32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 09:29:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:38488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727095AbfHZN32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 09:29:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3A5C2AD31;
        Mon, 26 Aug 2019 13:29:26 +0000 (UTC)
Date:   Mon, 26 Aug 2019 15:29:20 +0200
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
Subject: Re: [PATCH v3 03/11] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Message-ID: <20190826132920.GD28610@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-4-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710201244.25195-4-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:13:03PM +0000, Singh, Brijesh wrote:
> The command is used to finailize the encryption context created with
> KVM_SEV_SEND_START command.
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
>  .../virtual/kvm/amd-memory-encryption.rst     |  8 +++++++
>  arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/amd-memory-encryption.rst b/Documentation/virtual/kvm/amd-memory-encryption.rst
> index 060ac2316d69..9864f9215c43 100644
> --- a/Documentation/virtual/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virtual/kvm/amd-memory-encryption.rst
> @@ -289,6 +289,14 @@ Returns: 0 on success, -negative on error
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
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 8e815a53c420..be73a87a8c4f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7168,6 +7168,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_send_finish *data;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;

Almost all sev_ command functions do that check, except
sev_guest_init(). You could pull up that check, into svm_mem_enc_op()
and save yourself the repeated pattern:

---
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 273ad624b23d..950282c8c4f7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7225,6 +7225,11 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
 		return -EFAULT;
 
+	if (sev_cmd.id != KVM_SEV_INIT) {
+		if (!sev_guest(kvm))
+			return -ENOTTY;
+	}
+
 	mutex_lock(&kvm->lock);
 
 	switch (sev_cmd.id) {
---

> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);

Btw, since

  1ec696470c86 ("kvm: svm: Add memcg accounting to KVM allocations")

gfp flags should be GFP_KERNEL_ACCOUNT now.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 247165, AG München
