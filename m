Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96E23C6549
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 23:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhGLVMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 17:12:07 -0400
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:49376
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230087AbhGLVMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 17:12:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUfY2mstwWKJY1C9LD4x8p0nDljp9oWC0Sq1MAP3Oeun/c3zKczCuo8SXLAqtyInXqU9EefBqtWwLeKfWo+iCTbFBq2JZh6PlLsSyrqZnvSOa22AyyFyagnYvYwd8uDXgXcJSWzpfUNVNsl5c4FrnJWq6Xue+E2KouQbxYmp4uak9JSIGviPvDgArLgFSSz7UmZ2Rfc0IZFxecynD4XcqHvJrCo4B5UaJ7tmbKr7ecMGn9C2S7c9+m6NMqksjackwiZj7i29xutiXHd3N5hfZiCiZxxfG0BITF6Pgdlps5cc0z/h8LpLJMFO7fGUG1husju5LuhmFDgfQmw65QAPXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReN3Mr6f8LANxO58byxnMJY/vRqJik3RSL0UR8LDtFE=;
 b=hAj6Q4HxcUaNQwgtuANU/XOlbSBy6r0SSJtiEy+gQ3uSqG9nPDsbt+2pYtlVjKC6GBskDuhUPH5BrCOLwQByTbNeNiab6ubFgLIrYu9lFy/nAyGkloqKT4xwpeJin8ryEVn+7eRr1i2uEkaYEsIFQVjWWYsPpHjM+27DxgxswSBs5Bmxki/qN/RM+58jdZXAvmrL3oJy9TPK9I1oWGc8G9NQyXM2ZbmiHu9EppV4P4+l0jW8I9Ei/siuk6+1Pt+e5m4C2rs/G7CVNtkct9jEPlI9RDfJTUsREtlE/8CGgNsGGDN6x1SfCUfny3gls8Yube58L/1yw1FdGysJZ1FndQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReN3Mr6f8LANxO58byxnMJY/vRqJik3RSL0UR8LDtFE=;
 b=enLVgJRT8vXdK+n2rzCfCxGe3zI53/cwDXZbu7CQwJfN2vP7sPo5avuXrro2CjOugOzGrnJp8ynffWa7NE/e9s8tanpqBVBOh0AGfQL5OQGvOwkQ8EmeGkn3qJBXEaK3XFPVTqxlkbymZHLx3GVSyvBbMW2AsoF+O/X2ywCJf7g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 21:09:16 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 21:09:16 +0000
Cc:     brijesh.singh@amd.com, Lars Bull <larsbull@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM, SEV: Add support for SEV local migration
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
References: <20210621163118.1040170-1-pgonda@google.com>
 <20210621163118.1040170-3-pgonda@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <3f4a1b67-f426-5101-1e07-9f948e529d34@amd.com>
Date:   Mon, 12 Jul 2021 16:09:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210621163118.1040170-3-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0198.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::23) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SA0PR11CA0198.namprd11.prod.outlook.com (2603:10b6:806:1bc::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 21:09:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a7e1eee-6b61-4dae-8b2c-08d945794ea2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45571B39BDE8073E054E2AC9E5159@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +mENNKQ5UwGS7wLgR2pVcuFFseu6HwRdzXLrBruebsMvTzOAZmCUBZjrnMiFiHBCVyI1CxRXe1vYSjrpLgTupXj1HMJEhyZUG8dKXpGu5NpCJDYHDxjNHvbTtDynUoxREbADTp8sh82FbKA/5MnOYeHjLq+xqkhDCUFbd/DUH/LowDSeaKy+nuNb9qE01O9XaxCkcdGZIzbXxLKDrIa8OigPicXBtA+xidZhWE2RyxrgZVmEZODsX5WBWpw5QS56Mp3eFI4jIh5/Lo2AEbrVyjLQYVNEaWiNSZ8h1HqADPxSaaQEZLkgezKsiUkR1p24sfs2aKccZ3XbpaqoKkMaz34BK7I0giVEfeolBZxMTA8jhxzFyW631CIdahoCimJo3W8xyMSHgkK/AlakRCUWewf6pAnwa/6YehwFHxSLBE9+74Y3eAB6xk4wD4ulSt7MweYrBwmVxa3V5YNFmeog1AGtnwk5yahSr+p9QQ00r1pD+Qg2Wq219NowT0hJO7z3K5J4QFnZT/fFWNWEz7taKAJoTKBTLDlrAZQHhOFCGiINnLIdOR+6Ob8a3cui3WCHA8HdfPGz8PSPFjpmBVg06AijnrotKTPw3KXko0VrIFmECvVfIO+PtFDds84v049hjDJxk0IQKvIo7GlEx0Azox860mMJphDmNr0BwmJUfuLetzc07qVR1ZVLAA45N9HHgX6LARzEm782IvgU/FNdj4T1M8MuYy3lg5lOxOXq7nhcA+q7KmvChrsv7Q7Zp7JXuz3rJ1v4d6joOwAhld3fSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(38350700002)(38100700002)(316002)(7416002)(36756003)(83380400001)(66476007)(66946007)(53546011)(4326008)(5660300002)(478600001)(86362001)(31696002)(6486002)(8676002)(52116002)(186003)(16576012)(54906003)(26005)(31686004)(8936002)(66556008)(956004)(2616005)(44832011)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGlhMmg2dFhBSHJDUWIxZTVlSVdCdFE4WWVacGU0TUhncGttVC9hUVMvRUgv?=
 =?utf-8?B?WHc4bytIeGxaOXlCUzF2MUJoT0ZBaEhNU29TV3lXT1hqUWlXckMvT0YxbFF4?=
 =?utf-8?B?enVQYkpwaU9XUXVDK2UxSnRyeFpoRDUvSXExL3pkZk40NEdNeXJ3cG9LWElk?=
 =?utf-8?B?V0F4ZDlUMEE4bXNzNmVtbVpKcjZSZXZ0ZlZmMXQvZnRNZWFXMW1ZNG9JTDBM?=
 =?utf-8?B?aFQ3Q3lNUW1TZUQ0dTlSQWtxOTh3dUlrb3J1M3ZsdVlOT1J4bzU5b3IwYjlu?=
 =?utf-8?B?SVRoMWlheWNjVm5mRnhldUI3ZWwrV0hlVXZUUzVqMG40N053N0RaeXJYb0dU?=
 =?utf-8?B?b2dzRU1ueUtnKzZ1YWtZMFJFVGkrbmRDaEp2ckJvYjZjNndWaTJYWXJTNFdu?=
 =?utf-8?B?SmVrYXJOcXd6b3BxZE51NG1zWTFrRHQxdUUyQnQ5VFNxclNuOXhPM3pPSCs0?=
 =?utf-8?B?RFFXVGt1MTliNmtpbEZyQVg4RWtyVnVuRWR2SERTeUpqVzcrQkM0OVBhSk1G?=
 =?utf-8?B?T3YwRllyMTZzYS9SY1BlVkhDcWZGRnRrbWdDVWM4aksxa3pwUm9MUk5IZEhX?=
 =?utf-8?B?NCtnVGV4Yk1ZN3ZxYi95VnA2V2VHWEJzaUtzeitDamg0YW1aRVJMdUVDdXhL?=
 =?utf-8?B?K3B0cnZaU2hEWkM0c0lDM1V2aW5Pd0xGdVVnbWN0OUhJTUFJUHBZQ255T0Rj?=
 =?utf-8?B?TzExVjlPa2dRbk4rTHpQR01ZbitxaUdaRlNPcnNKMGQxR0kxb1VKRElpMFBw?=
 =?utf-8?B?MTB4M3BHTVBVQ3ZYZlhtSU9waURmV0cvQ2lyRmV1UjZxaDBvNFlYRWYwWXla?=
 =?utf-8?B?RW8vbGJ2RzR3T0svN3JHbEJsSFdza2wzazdseTM0dlQwbTFwT296OWNualpC?=
 =?utf-8?B?dVZ5OEpsU095TUtaTGpod3gyMUZhb2dkYmVIR0MvcHI3SHZLeFRlZkdUOTY3?=
 =?utf-8?B?TVkxR3pnUzRyWjZ2MTFqU1doMHplTDEyaHdjN2pkaW9hUnRtTmdJSUoxT3p2?=
 =?utf-8?B?cFI0UEw1UlRZaTlGSWE5Rk8yclF2MDJPWGdLMFBpZzRZQjlOWGlldFlSNFBx?=
 =?utf-8?B?aHdaVlZ6UjFNMFc4Q2NDM2JyNDZmNnlsTnFJNXdleExLaitPK2ZxblQwWm5s?=
 =?utf-8?B?RzRsU3NsbUVmcTFHZW51aVNuamUySDNMK09Kajd0OWFFVnZqanlJRzZ2cXpM?=
 =?utf-8?B?ek9rYk00U3pzQ2hLaTMwZlZkcHVOZXdYYkNqNFFqajEvTnY1TmVIdEkrT04r?=
 =?utf-8?B?eFJ4NFNzN3QwVUZZalBJWFhlY2cxY0dDU283M25aQXdxVmRNcDRFVUtyT2Nx?=
 =?utf-8?B?YWYrdzNzZytJUkx1bW1vWFViM3pRZFJSTlhmcGJINm5sWm5JWUhORDNyS0JQ?=
 =?utf-8?B?d2FKR3pBMGdGNWhBYkZ4VStZWEI5c2FTUVdFdWkwbW9ZWUdUTTVhVXVOdnU2?=
 =?utf-8?B?M3NVTkVaZmFKZERadDg3NytvS3BTNXZOa0VMZmlIZ0UrZDBmcmhEZ20wL2xs?=
 =?utf-8?B?bDNpVUNEcnh4UjNJSHRQQkt6WnJaZkZwSGZoQUM1QWVaemJTR1A2VStsUjB4?=
 =?utf-8?B?WmVmeXI5clBuU0w1S2dyMDlKQythcmxzZ2VEc3VIN0ZidFBwOGpmelVlb1U0?=
 =?utf-8?B?bnVCRUJudENNZHJjYTY1anRkMi9tRktrdVQ4Y3p0YjJ1NEFuamQ1VnMyVEV2?=
 =?utf-8?B?bDlhMUlEUS9YNUJTZG1FZ21GckVjUjFlemtXNTlXQ3hlZTVlSWc0K05QZTFK?=
 =?utf-8?Q?N4xNBqB907r04CDMFTjniT1157JN4KfJBOxLjkA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7e1eee-6b61-4dae-8b2c-08d945794ea2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 21:09:16.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/mE5Htqy/Na+O6nynvnTZ83+4EZaEqPCQhPjRorcHnLrn5ql9gCEkbvomoVvltG5l0S6U/XVJR3Zk7Uj6fAoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/21/21 11:31 AM, Peter Gonda wrote:

> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (sev->es_active)
> +		return -EPERM;
> +
> +	if (sev->info_token != 0)
> +		return -EEXIST;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			   sizeof(params)))
> +		return -EFAULT;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	entry->asid = sev->asid;
> +	entry->handle = sev->handle;
> +	entry->pages_locked = sev->pages_locked;
> +	entry->misc_cg = sev->misc_cg;
> +
> +	INIT_LIST_HEAD(&entry->regions_list);
> +	list_replace_init(&sev->regions_list, &entry->regions_list);

I believe the entry->regions_list will be NULL if the command is called 
before the memory regions are registered. The quesiton is, do you need 
to check whether for a valid sev->handle (i.e, LAUNCH_START is done)?


> +
>   /* Userspace wants to query session length. */
>   static int
>   __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
> @@ -1513,6 +1711,18 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   		goto out;
>   	}
>   
> +	/*
> +	 * If this VM has started exporting its SEV contents to another VM,
> +	 * it's not allowed to do any more SEV operations that may modify the
> +	 * SEV state.
> +	 */
> +	if (to_kvm_svm(kvm)->sev_info.info_token &&
> +	    sev_cmd.id != KVM_SEV_DBG_ENCRYPT &&
> +	    sev_cmd.id != KVM_SEV_DBG_DECRYPT) {
> +		r = -EPERM;
> +		goto out;
> +	}

Maybe move this check in a function so that it can later extended for 
SEV-SNP (cmd ids for the debug is different).

Something like:

static bool is_local_mig_active(struct kvm *)
{
	....
}

Once the migration range hypercall is merged, we also need to preserve 
any metadata memory maintained by KVM for the unencrypted ranges.

-Brijesh
