Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BBB414F36
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 19:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhIVRhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 13:37:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236781AbhIVRhE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 13:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632332133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xWIShvsg2b/ofTSKntT8mh5AyqIJnIP55cDcnHuZNYU=;
        b=U81ggE0obh6Z97cGZOXxe0r07vD59KYGhqIokDdDx989s1OJlk2u37riPE2XfJKkUkNXhU
        CEjrgx9N0KwGocI11gL+sYwgwL3yJ+GdmazbBxwa4ngXxh3tIydSy+Wu8S6mmCJLDi9rw0
        EVfTWg3Whdojr27Jxjpgix5fHMNhiiA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-M1lJlLRvOhSCGm3XOR1W1g-1; Wed, 22 Sep 2021 13:35:32 -0400
X-MC-Unique: M1lJlLRvOhSCGm3XOR1W1g-1
Received: by mail-wr1-f72.google.com with SMTP id x7-20020a5d6507000000b0015dada209b1so2805530wru.15
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 10:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xWIShvsg2b/ofTSKntT8mh5AyqIJnIP55cDcnHuZNYU=;
        b=plen/njd8ygeJiH0xByLr9q2kcdGwV6mS0E3wucxFXH2dxH5ND9HxwuPt0g/AblIF+
         /Xyj07WjMlo/2iJwi8PgufUPyj2YBVZ9BuhJ+oWRAvQ5KhKnnl7mKVBs3kQfYsWL6IRz
         vzIbWgbU8FbiG24zV+WN3RT14ZOVn1f4ofp5yBnTGlJo7ipDbnfUjuCqPizziwCOXU6i
         aMSqTP07DdzaG4z8Yss3rOIf+LpVx2afIHHQLzLTCGLPqFYyXYTVSbGAmGp1pj2i5otP
         c2HIzgegdJsOqj8r96bavXyGdoegukXPFBLkttqKN6ehfMpLRj1/44fFFcp0n+0gSrhG
         76og==
X-Gm-Message-State: AOAM531iVuCk0D83MUSV9H9L8gX9yBXncOVLv2GVpyiwRf84qRz7CcGa
        ytncB9FrFSRXIr+jlOyqksza7ybklJcR4/B+1M7x1+qKZKHQcLS7n+2FE89ssbQGKVl968LexRR
        oG2bPJG+DHlJT
X-Received: by 2002:a1c:2289:: with SMTP id i131mr9625640wmi.179.1632332131380;
        Wed, 22 Sep 2021 10:35:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqnKL+ZgwiMxGzSCfu4ZAfHm1Q0SKHjEzyTgy3FjXj67OFQileopxoY1xHtq3c4ytxH2PgRA==
X-Received: by 2002:a1c:2289:: with SMTP id i131mr9625602wmi.179.1632332131154;
        Wed, 22 Sep 2021 10:35:31 -0700 (PDT)
Received: from work-vm (cpc109011-salf6-2-0-cust1562.10-2.cable.virginm.net. [82.29.118.27])
        by smtp.gmail.com with ESMTPSA id s15sm2876783wrb.22.2021.09.22.10.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:35:30 -0700 (PDT)
Date:   Wed, 22 Sep 2021 18:35:27 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 16/45] crypto: ccp: Add the SNP_PLATFORM_STATUS
 command
Message-ID: <YUtpX5q7WQ9RJISf@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-17-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-17-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> The command can be used by the userspace to query the SNP platform status
> report. See the SEV-SNP spec for more details.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  Documentation/virt/coco/sevguest.rst | 27 +++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c         | 45 ++++++++++++++++++++++++++++
>  include/uapi/linux/psp-sev.h         |  1 +
>  3 files changed, 73 insertions(+)
> 
> diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
> index 7acb8696fca4..7c51da010039 100644
> --- a/Documentation/virt/coco/sevguest.rst
> +++ b/Documentation/virt/coco/sevguest.rst
> @@ -52,6 +52,22 @@ to execute due to the firmware error, then fw_err code will be set.
>                  __u64 fw_err;
>          };
>  
> +The host ioctl should be called to /dev/sev device. The ioctl accepts command
> +id and command input structure.
> +
> +::
> +        struct sev_issue_cmd {
> +                /* Command ID */
> +                __u32 cmd;
> +
> +                /* Command request structure */
> +                __u64 data;
> +
> +                /* firmware error code on failure (see psp-sev.h) */
> +                __u32 error;
> +        };
> +
> +
>  2.1 SNP_GET_REPORT
>  ------------------
>  
> @@ -107,3 +123,14 @@ length of the blob is lesser than expected then snp_ext_report_req.certs_len wil
>  be updated with the expected value.
>  
>  See GHCB specification for further detail on how to parse the certificate blob.
> +
> +2.3 SNP_PLATFORM_STATUS
> +-----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_platform_status
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
> +status includes API major, minor version and more. See the SEV-SNP
> +specification for further details.
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 4cd7d803a624..16c6df5d412c 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1394,6 +1394,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	return ret;
>  }
>  
> +static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_data_snp_platform_status_buf buf;
> +	struct page *status_page;
> +	void *data;
> +	int ret;
> +
> +	if (!sev->snp_inited || !argp->data)
> +		return -EINVAL;
> +
> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +	if (!status_page)
> +		return -ENOMEM;
> +
> +	data = page_address(status_page);
> +	if (snp_set_rmp_state(__pa(data), 1, true, true, false)) {
> +		__free_pages(status_page, 0);
> +		return -EFAULT;
> +	}
> +
> +	buf.status_paddr = __psp_pa(data);
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
> +
> +	/* Change the page state before accessing it */
> +	if (snp_set_rmp_state(__pa(data), 1, false, true, true)) {
> +		snp_leak_pages(__pa(data) >> PAGE_SHIFT, 1);
> +		return -EFAULT;
> +	}

Could we find a way of returning some of these errors into the output,
rather than interepreting them from errno values?

Dave

> +	if (ret)
> +		goto cleanup;
> +
> +	if (copy_to_user((void __user *)argp->data, data,
> +			 sizeof(struct sev_user_data_snp_status)))
> +		ret = -EFAULT;
> +
> +cleanup:
> +	__free_pages(status_page, 0);
> +	return ret;
> +}
> +
>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  {
>  	void __user *argp = (void __user *)arg;
> @@ -1445,6 +1487,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  	case SEV_GET_ID2:
>  		ret = sev_ioctl_do_get_id2(&input);
>  		break;
> +	case SNP_PLATFORM_STATUS:
> +		ret = sev_ioctl_snp_platform_status(&input);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		goto out;
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index bed65a891223..ffd60e8b0a31 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -28,6 +28,7 @@ enum {
>  	SEV_PEK_CERT_IMPORT,
>  	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
>  	SEV_GET_ID2,
> +	SNP_PLATFORM_STATUS,
>  
>  	SEV_MAX,
>  };
> -- 
> 2.17.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

