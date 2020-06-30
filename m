Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0687E20EBDA
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 05:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgF3DKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 23:10:44 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18267 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgF3DKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 23:10:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5efaad020001>; Mon, 29 Jun 2020 20:09:54 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 29 Jun 2020 20:10:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 29 Jun 2020 20:10:43 -0700
Received: from [10.2.91.207] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 30 Jun
 2020 03:10:42 +0000
Subject: Re: [PATCH 1/2] KVM: SVM: fix svn_pin_memory()'s use of
 get_user_pages_fast()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Souptick Joarder <jrdr.linux@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H . Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>
References: <20200526062207.1360225-1-jhubbard@nvidia.com>
 <20200526062207.1360225-2-jhubbard@nvidia.com>
 <87imgj6th4.fsf@vitty.brq.redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <c7fa9c34-2d4e-9f1b-9afd-7f4132cdd35c@nvidia.com>
Date:   Mon, 29 Jun 2020 20:10:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87imgj6th4.fsf@vitty.brq.redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593486594; bh=TNPJf3HsBwEnQUF6wdtHb8Wkjntp5E/Y8QIFRdOi/cE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GJfQz8fM6prclbfKWGDx93swr/zvjCbIRJ70f0jyWsMwbYmuXhhGztZnI3dm9JMER
         UGqiHGS49qqXGEZNKEq8cqlok0NeLIrTBjgh9PGZ82/a1AjE05r+vAyQfXM1VtXqkQ
         XZXca4tqzSskv9ao1DnxFvD4hSybO2fixNXPFRaVXAmIeLf6oO+l6eXpd/imcTa++3
         5dMCASVZ7Vi5B3hModoO0QCHQHFHxRRdTw/bRQcQgYE/X566aDEcVxgLrySTa1U5hr
         5GJGk+0pxQSBUIcp4GYHX13dTCkayRsJR1UW/MGCHFXfJk8zbNFBh/HPNL8dBHG9eS
         DS6gGYtniQKeg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-26 00:33, Vitaly Kuznetsov wrote:
...
> I bit unrelated to this patch, but callers of sev_pin_memory() treat
> NULL differently:
> 
> sev_launch_secret()/svm_register_enc_region() return -ENOMEM
> sev_dbg_crypt() returns -EFAULT
> 
> Should we switch to ERR_PTR() to preserve the error?
> 
>>   	/* Avoid using vmalloc for smaller buffers. */
>>   	size = npages * sizeof(struct page *);
>>   	if (size > PAGE_SIZE)
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 

Thanks for the review, Vitaly. If anyone is able to do any run-time
testing of this patch and also patch 2/2, then I think a maintainer
would be more willing to pick them up.

Any testing help there is greatly appreciated!


thanks,
-- 
John Hubbard
NVIDIA
