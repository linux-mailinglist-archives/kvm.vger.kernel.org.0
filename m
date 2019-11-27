Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA73510B554
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfK0SMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:12:00 -0500
Received: from mail-eopbgr800077.outbound.protection.outlook.com ([40.107.80.77]:10633
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726576AbfK0SMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:12:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVA03c1CQ8Pg9QsCofsePiNcrTkkb2wjWIVGz7HQraLsfg4J6ifiFs3GASejVvp7fTuKY3B9HEft4k9cXGFqUYXEpbnO7Kk9S+rkHpvafqm/A9Y6BC0LtgBKywaBblhbPB5pnf2Umoa1YbMAkL+7bAjAnmml8wvH7JoqD+Pqi0Q6YEDNpGk3WBaogPns3C2DH/Ftm4jOQXVQCi59Ev3NKBR99SMODA5/fGdcOAcS8cPzcRYVCRDI77c6e0mWMX1T4Wpinj6JQhaqxMvZS6+pMzC0WX/tSOrippBPDfcO86qoVlZXzwzQ1a0IYd9PldFaIqJC04yhnsSa/DpNr/Ll7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvFbPB7U32hKj02gTPM8D9eeOuLK2sRIs5lkF/5PlDE=;
 b=PlYZE0sHlrAn9I5AEtcVzRgRhVAjB0zSV3ZfOk8ZdH3x27Dfr0udKVuFSLELU/IMK7a6bGPo0tkVADQBAtsaIBAUmpl2wPyd+zBkaKMqNT37+lgKqtYugSwuzfhJ1NAWlNzr/oTfuupT46Q7Ah70cCtm+n9uxRYAH4ByGg+HjqzeVV6qtc4pxhdn1Xeg/ryTKS+CRANZfeQ0eDUr1rJjFmwy9h6ELXkyr4TUh0BRMP5SndNvzxpjiucTCzJUpRn45UBWmD6wnXrEJii+X3qQw9VDzcyDff7aKo+WdGqSJ6KpqAuu1DT9it/R6pZWN2ro3GN4wYd/VuCaAZ/c+8GQAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvFbPB7U32hKj02gTPM8D9eeOuLK2sRIs5lkF/5PlDE=;
 b=wt8W7IdfcP0y3mICS5gzLiem0heYarz4chqSm0llGP3EGoH4UFWclX6d6Mhm5TjmkS6FT8kJmYKdYtNo5oJ2Bvl8+IL+m9ctWN7C/LafIYIMQAkfbXEwCNYz0X7/pcKJHvvgiCkixVjmpN8XwqQUfyyPSRTu/09ke+y52iydhWM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB4042.namprd12.prod.outlook.com (10.141.185.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Wed, 27 Nov 2019 18:11:57 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::dd0c:8e53:4913:8ef4]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::dd0c:8e53:4913:8ef4%5]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 18:11:56 +0000
Subject: Re: [PATCH v2] KVM: SVM: Fix "error" isn't initialized
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        gary.hook@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
References: <2967bd12-21bf-3223-e90b-96b4eaa8c4c2@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <1b0b053a-66cd-c712-4bba-732084075e97@amd.com>
Date:   Wed, 27 Nov 2019 12:11:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
In-Reply-To: <2967bd12-21bf-3223-e90b-96b4eaa8c4c2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0083.namprd05.prod.outlook.com
 (2603:10b6:803:22::21) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60459dc9-1cd4-48d9-22dd-08d7736549dc
X-MS-TrafficTypeDiagnostic: DM6PR12MB4042:|DM6PR12MB4042:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4042EB4C91B0557D3D47A631EC440@DM6PR12MB4042.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-Forefront-PRVS: 023495660C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(199004)(189003)(5660300002)(52116002)(6486002)(8676002)(3846002)(2486003)(14454004)(31696002)(47776003)(36756003)(2501003)(81166006)(66066001)(229853002)(86362001)(66556008)(6116002)(23676004)(14444005)(66946007)(66476007)(76176011)(50466002)(316002)(446003)(81156014)(99286004)(478600001)(53546011)(305945005)(6506007)(26005)(7736002)(4326008)(58126008)(110136005)(6512007)(54906003)(186003)(7416002)(65956001)(65806001)(6436002)(25786009)(11346002)(31686004)(386003)(2616005)(2870700001)(2906002)(8936002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4042;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0GD3HYz9wKvvaFWqEBWTW/tlGOnab5l1tCUke4AgrvuZ/Gq4K7JQtp2vlHUkiM3R53IAaOJoqMgQ20nrxCAlfIQ/MFQtoCcjzDRfiIEFZqUYY+9ohqU4aJ6VKv8ZUWIo7TQwP0JuCRdk/qU86ZNSrJR64tM03EUl4SqJHgZlt7tRlm4G2VHQh778Q147oJtuJoElGcEURKCSmGwjIMPKUCdxOLiTYajuPoPC2O2VFwo7a9/JSZavX+md6Myv8q/BkvDwFUOaB8tq0lj5U3+QKao9Vi7EL/udRA+jTMZJn8sSRe5peHsgRPqCeWc4tJdu/1tKc4chrtRFV/Ww1jI0/Mrad6T6miZeDGLr77oOgYh4NsN+jRVKDgvoAJCXhGS5GvCmJAT0YVtCjfPm1bF2RyC6mPF0pjB81PXFpkx51j9H8JlnKeUf+P1o7VF8YJh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60459dc9-1cd4-48d9-22dd-08d7736549dc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2019 18:11:56.8396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMR62l+GPt85zJTvXi052M49C6uvwX3VTOHNtMIV8phQ05CLngu61LsAV6HVVxOGu6eWeihMR5+AVjsUOqi6ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/27/19 1:23 AM, Haiwei Li wrote:
>  From e7f9c786e43ef4f890b8a01f15f8f00786f4b14a Mon Sep 17 00:00:00 2001
> From: Haiwei Li <lihaiwei@tencent.com>
> Date: Wed, 27 Nov 2019 15:00:49 +0800
> Subject: [PATCH v2] fix: 'error' is not initialized
> 
> There are a bunch of error paths were "error" isn't initialized.

Please provide a better patch commit message and just fix the actual
problem, which is error is uninitialized in sev_flush_asids(). Please
just initialize error to zero.

Thanks,
Tom

> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   arch/x86/kvm/svm.c           | 3 ++-
>   drivers/crypto/ccp/psp-dev.c | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 362e874..9eef6fc 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6308,7 +6308,8 @@ static int sev_flush_asids(void)
>       up_write(&sev_deactivate_lock);
> 
>       if (ret)
> -        pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
> +        pr_err("SEV: DF_FLUSH failed, ret=%d. PSP returned error=%#x\n",
> +               ret, error);
> 
>       return ret;
>   }
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 39fdd06..c486c24 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -155,6 +155,8 @@ static int __sev_do_cmd_locked(int cmd, void *data, 
> int *psp_ret)
>       unsigned int phys_lsb, phys_msb;
>       unsigned int reg, ret = 0;
> 
> +    *psp_ret = -1;
> +
>       if (!psp)
>           return -ENODEV;
> 
> -- 
> 1.8.3.1
