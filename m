Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EDA23F60A
	for <lists+kvm@lfdr.de>; Sat,  8 Aug 2020 04:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHHCxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 22:53:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49060 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHCxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 22:53:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 077NqoSK174205;
        Sat, 8 Aug 2020 00:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pRss8K84ABZhW+aCcIYrAd7OGGKvba8jWPFZbS6GPjs=;
 b=FtXVTd8aOYb4zRtenSiHSQNkfm2nsBUN0eE7SnF+3fJaWxc5d3NFPzy71gYnMy9v6s9F
 aZJbyP2WyS1aWGyVszPfiCZITejQotp9BM/QwkCaxWSEDEbvBfrsDcra2/U9XXueaPs6
 DKAHSZYgv+mkcg35mt5Wpm9hvbugW7aGmSH2aNZ71ZQLOSpBwib3kr4dDLqvZhhnNH2T
 kLlgWucPtnCr1kiYV2hA6jBjvhusPBLobNJQqaZRUfuPjX5kyLmWYNxTA7R5PlHVkBti
 +4t/cLoKqgXk97p15xfpk+wn8y9Vt1igXt7qXs49L4d3ypNHuxWVGZdbCNyXZOrOeE7s kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32r6epb636-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 08 Aug 2020 00:02:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 077NrFM0173446;
        Sat, 8 Aug 2020 00:02:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32qy8rmw5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Aug 2020 00:02:33 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07802L38016066;
        Sat, 8 Aug 2020 00:02:21 GMT
Received: from localhost.localdomain (/10.159.159.21)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Aug 2020 17:02:21 -0700
Subject: Re: [PATCH] KVM: SVM: Mark SEV launch secret pages as dirty.
To:     Cfir Cohen <cfir@google.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>,
        Singh Brijesh <brijesh.singh@amd.com>
Cc:     Grimm Jon <Jon.Grimm@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20200807012303.3769170-1-cfir@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <dc4f24b2-2b7f-f7a2-eef9-6e40dc6f3797@oracle.com>
Date:   Fri, 7 Aug 2020 17:02:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200807012303.3769170-1-cfir@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9706 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9706 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 malwarescore=0 clxscore=1011 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/6/20 6:23 PM, Cfir Cohen wrote:
> The LAUNCH_SECRET command performs encryption of the
> launch secret memory contents. Mark pinned pages as
> dirty, before unpinning them.
> This matches the logic in sev_launch_update().
sev_launch_update_data() instead of sev_launch_update() ?
>
> Signed-off-by: Cfir Cohen <cfir@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5573a97f1520..37c47d26b9f7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -850,7 +850,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	struct kvm_sev_launch_secret params;
>   	struct page **pages;
>   	void *blob, *hdr;
> -	unsigned long n;
> +	unsigned long n, i;
>   	int ret, offset;
>   
>   	if (!sev_guest(kvm))
> @@ -863,6 +863,14 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	if (!pages)
>   		return -ENOMEM;
>   
> +	/*
> +	 * The LAUNCH_SECRET command will perform in-place encryption of the
> +	 * memory content (i.e it will write the same memory region with C=1).
> +	 * It's possible that the cache may contain the data with C=0, i.e.,
> +	 * unencrypted so invalidate it first.
> +	 */
> +	sev_clflush_pages(pages, n);
> +
>   	/*
>   	 * The secret must be copied into contiguous memory region, lets verify
>   	 * that userspace memory pages are contiguous before we issue command.
> @@ -908,6 +916,11 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   e_free:
>   	kfree(data);
>   e_unpin_memory:
> +	/* content of memory is updated, mark pages dirty */
> +	for (i = 0; i < n; i++) {
> +		set_page_dirty_lock(pages[i]);
> +		mark_page_accessed(pages[i]);
> +	}
>   	sev_unpin_memory(kvm, pages, n);
>   	return ret;
>   }
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
