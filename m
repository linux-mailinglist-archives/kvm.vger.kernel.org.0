Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C461E9E7B3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 14:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfH0MTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 08:19:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:51056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfH0MTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 08:19:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6FF3DACD9;
        Tue, 27 Aug 2019 12:19:22 +0000 (UTC)
Date:   Tue, 27 Aug 2019 14:19:21 +0200
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
Subject: Re: [PATCH v3 06/11] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Message-ID: <20190827121921.GD27871@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-7-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710201244.25195-7-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:13:07PM +0000, Singh, Brijesh wrote:
> The command finalize the guest receiving process and make the SEV guest
> ready for the execution.
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
> index f0ec0cbe2aaf..b3319f0221ee 100644
> --- a/Documentation/virtual/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virtual/kvm/amd-memory-encryption.rst
> @@ -350,6 +350,14 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>  
> +15. KVM_SEV_RECEIVE_FINISH
> +------------------------
> +
> +After completion of the migration flow, the KVM_SEV_RECEIVE_FINISH command can be
> +issued by the hypervisor to make the guest ready for execution.
> +
> +Returns: 0 on success, -negative on error
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ea084716f966..3089942f6630 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7337,6 +7337,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_receive_finish *data;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->handle = sev->handle;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, data, &argp->error);
> +
> +	kfree(data);
> +	return ret;
> +}

sev_receive_finish
sev_send_finish
sev_launch_finish

all three are almost identical. Please aggregate them into a single
__sev_send_finish_cmd() and make all three wrappers pass in the
respective SEV_CMD_*.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 247165, AG München
