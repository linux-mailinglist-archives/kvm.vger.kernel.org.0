Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5684240507
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 13:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgHJLFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 07:05:52 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:33376
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbgHJLFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 07:05:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKG8qznQUQ9aNLcnn+ZgLDTQpFUpnBrc6M7D991B4jkbySlf5xMIyIKQjjq3kCVPOJwY5pRBUTHk6n+RObdpLCo5lg1lwPWSm/e8X7B80iEy0yfjzSzea/bYSI097CMzD9DKmd8VtHC+h9L25uy/XRrWL5fP/HRyGLR8ZGeprVMg6gtCzBgMngfVPoYmvnoiDTv1htvKa3K9bcgWVw4dMDqrHC9aYbbTpEAys0KJoLwKOH2QDzsnn7BkbXAWU70CuyNBHWi/OWCDQy+SggdjWrx0BuM+GSZSpwDXCoGVVU1TdVlzYG+NFEmSOJAAH9yVM0uCACq7pktlYG+GxeWfBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUbqAxzQFbEfi1q4HvXd4yYb59AsUbGKybWeL1Hj1gY=;
 b=TX5Yq5gSXueObd5QGrK1H3dcf0ThCcobXjjzmGpGM+iIkW1ALbK8cza16eHWz/aGMwLvlq5ovaEqq/rGkl10SdHMKQ+x1zmKSd9X/12A/W7CHOol5huER4efgRTaUu6pCpz+fJJ2WC5wnYwfFGY3X1gzvVQfbaPHfa1Ishv+/lKJ/sJU/t0qOxVbf59couYQBtnd3ZbQ+1ylFSWf8COVFWrYY4WFFGX7HoJ3kTcj9ywgyw5cj8qEjdCFjexqoBtJ49te6xVlDojD9tlb0BL5H1ltMVCyc4hiSk6Ig7Nq0HNgJB/OLi0hpm1PSzF77pxSSjCbxQTO9GLu6wwn8Njrnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUbqAxzQFbEfi1q4HvXd4yYb59AsUbGKybWeL1Hj1gY=;
 b=it+XKKHvHyhaXIwVc7XYKYjPVwkHpQlp4Lw8t3PHY+3ECKgdIw7W389fLGldjNmKEyvzboGxZH4g4aQyQ8dxTO6EceUJ96ot5N/V45bl88iTssWM1fp4dG1zC/3D8xYqL/n0x0YTdVVvFtvz3gFq2Zk+kDIfHCsv/W5CvokaUXY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Mon, 10 Aug
 2020 11:05:37 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::f148:6389:3524:e91c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::f148:6389:3524:e91c%7]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 11:05:37 +0000
Cc:     brijesh.singh@amd.com, Grimm Jon <Jon.Grimm@amd.com>,
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
Subject: Re: [PATCH v2] KVM: SVM: Mark SEV launch secret pages as dirty.
To:     Cfir Cohen <cfir@google.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>
References: <20200807012303.3769170-1-cfir@google.com>
 <20200808003746.66687-1-cfir@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <6f07f8b8-8608-e03c-e8c8-ddf20cd07930@amd.com>
Date:   Mon, 10 Aug 2020 06:05:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200808003746.66687-1-cfir@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0601CA0004.namprd06.prod.outlook.com
 (2603:10b6:803:2f::14) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0601CA0004.namprd06.prod.outlook.com (2603:10b6:803:2f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Mon, 10 Aug 2020 11:05:36 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f86c72c3-cb78-4f75-fb3f-08d83d1d4f76
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB271728D773B08DF06690B5B3E5440@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:252;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7t65n158uO0d1Vei2aYC9n2dEXFuneWbUxsKDRIP6KSeRePeLJhE4ytH9Zj4YlKe2YwtbIz3jkJg0Ty2sEjgFAneMO3xD9nru+jD9Rw8yGHbpzP4tGmym6KzjRI+767JD5tTCwMftHG+YdKsO4UR5IPfC9xd5k+Xg5VVh6y/JrBI2akUOJVSwIfuXsCr5cBuhUtmaU0lHJGgIqHqvmf8VaeyREIgXYoZBllrIBkOTKGFp8qihzzb+/J/W9X9WqjXpm7EOhntxAyrPEsgLu3uzgdkSeTNIx87ztuUG6lMZS+na2WwAXJbPNiC//ZUoMgVMzfJ2Ulbe5Cn7dhD1S9V+PgzqYkYSo1FgCTBhpB0CofsjthyFgS/8ppnL/ig8qLC9Y3En9aCjcNYMu78J4YnGxw9y1ISXFTbmiRlCb4UJNyKNagqDA1ukAuFBdjN61IA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(86362001)(66476007)(66556008)(66946007)(5660300002)(44832011)(83380400001)(2906002)(31696002)(31686004)(6666004)(36756003)(478600001)(54906003)(6486002)(110136005)(6636002)(16526019)(2616005)(186003)(956004)(7416002)(26005)(6512007)(316002)(52116002)(8676002)(53546011)(6506007)(8936002)(4326008)(14143004)(219293001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SGaSLCbHstxTdg+dZupwFTNmgEXgSaRSV6HGOA7pWP38ZmEbdowOpJTTlZW2PsCQXJEJiotHFc7ciWWmDqhwwEJzIilTu7nnC8Jzxy3IrM+flsHPtoCUn40pPu+tgsZyXnKCIf+5WLULalmzsseDDWxuOEvSb5I8uNFKjqiSJ0n9EpgnmuPTpenNM2tnwbucW8b/PKhTRo0EoiOHei/ropo3hAtj4QRW3igh5yAE7APqVAAJdTWD5fA8NDIsqKDKK1kbTlxgm474Ot88NQskhD8mtmyKzpNT2CmuCsnT7gng8UrA5pHn4l2kaIpNoCCXpQY2CV+E+u7aRw4Mh7FknWIy7jI5KEMjO/lQilWI4EE5rMOPZoN7uLIRcjTE8Y/urUmBKoiql/BuQuGzcxxyRdDkjagbyOFN+m8b4aI/7LHeZai1sA1SB3c8+Cq/1b0YKQVNYWAbe6H0IBTBWE66JwhgW/0Pj0axLqyDBF9/1uTqXBslFRPSsEDTiMMShP+47bfAOKRL33grRf6ak/ErTxANCJn9fIucotLtgnKjDyN/N8ohQ7EH41ICUJ7yCUDyb9c2rS3NR7e8hZ3j242gzLeeWK0DjomrnDztzk0IVyafzWQydZ5KSoWQnZTDoKCfK8rU1rgfwomBWTmAbVthTA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f86c72c3-cb78-4f75-fb3f-08d83d1d4f76
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2020 11:05:37.2297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxZ8OLHOZUEAYPX8TV60fsEg9HUUJDuT7/DGPokRpXPVBqhfKw+7T3MBqMai+rw1fcJWJ2Cqsd+Xc5XwhZs7tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/7/20 7:37 PM, Cfir Cohen wrote:
> The LAUNCH_SECRET command performs encryption of the
> launch secret memory contents. Mark pinned pages as
> dirty, before unpinning them.
> This matches the logic in sev_launch_update_data().
>
> Signed-off-by: Cfir Cohen <cfir@google.com>
> ---
> Changelog since v1:
>  - Updated commit message.
>
>  arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)


Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5573a97f1520..37c47d26b9f7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -850,7 +850,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	struct kvm_sev_launch_secret params;
>  	struct page **pages;
>  	void *blob, *hdr;
> -	unsigned long n;
> +	unsigned long n, i;
>  	int ret, offset;
>  
>  	if (!sev_guest(kvm))
> @@ -863,6 +863,14 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (!pages)
>  		return -ENOMEM;
>  
> +	/*
> +	 * The LAUNCH_SECRET command will perform in-place encryption of the
> +	 * memory content (i.e it will write the same memory region with C=1).
> +	 * It's possible that the cache may contain the data with C=0, i.e.,
> +	 * unencrypted so invalidate it first.
> +	 */
> +	sev_clflush_pages(pages, n);
> +
>  	/*
>  	 * The secret must be copied into contiguous memory region, lets verify
>  	 * that userspace memory pages are contiguous before we issue command.
> @@ -908,6 +916,11 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  e_free:
>  	kfree(data);
>  e_unpin_memory:
> +	/* content of memory is updated, mark pages dirty */
> +	for (i = 0; i < n; i++) {
> +		set_page_dirty_lock(pages[i]);
> +		mark_page_accessed(pages[i]);
> +	}
>  	sev_unpin_memory(kvm, pages, n);
>  	return ret;
>  }
