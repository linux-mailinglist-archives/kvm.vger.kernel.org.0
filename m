Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3123C7696
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 20:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhGMSoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 14:44:01 -0400
Received: from mail-mw2nam12on2087.outbound.protection.outlook.com ([40.107.244.87]:57409
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229478AbhGMSoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 14:44:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2IzN/tDM37GG+xuSnYd8BubdXGjTzqOamBafqV90GZhRwnDgxSPbhfjWagkE7MYpu1iFMKoF1vf8QGBSTaj/duyqDK2WhwWwCnRfahquTVT641PtrxM+WU34KUSdK6efbBpFKKeh+9dQHkcSGMDwdf14nLsmPSxNBV3FKyAddX3Bw59nGdXXylagu0b08Z+5nSPGkhemhrGxLsvc9F2kq0ETmYsLqv/lpbGzx0bA7qYLhwHptUmy/X5HXnCLtchXgceYZPrvfS62P+uQzmST7uFD8cVUpAezAKRK1xesoPh3gC88NE8Jpw+RCHWXpdPSEU4pXd5ttzx+2UAeZ3zBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSOiIt2a4xt59UGP5tVRqwkjcQMwailiy/c970hnt8o=;
 b=EqLTrzQw2/Zlg/vSTWxkVxTcLlKvMQRBjNrI36OgXKpO4B/soqkPFV6Md4sHN0I8uzL8BfsXV2gCUJrz+rvsXrMO2JHR9rznqRT+ZHPz0qT7ioUSqoAIAFh/f8GjKEp5C07XGbLVzHHLFYfLsHOyvnxQJLu9cSIOW3Oj9Om3gIxHN85ZkmH1HzCfWfHsYopoabLDsrIoFbYgOinW6pBgnrz+ImdAR+6TPVvghDOH3L3wWkLinNsjsB5rdY2Qpq8FHk7H5KIwZidvDZb6BEAMpeZTQep6FLr0CO0E/DKFnHCTt0rhjKMrvzZjNBZX/ElOdAtPVBUeVX11r/O/yt8Gvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSOiIt2a4xt59UGP5tVRqwkjcQMwailiy/c970hnt8o=;
 b=2FEJY+T+9eECj4e7bgFzyF0lklYgU/Kzr/OpuASjr8Tn62bHO+z9YJOl+7JGwK68dqD4rR9S5otK6ejmySYZQ5bv3NlObOB2w5uLE01O62e7K38vmvsMSR+BW2lv0LQtpYjD6weCFrzo/k0Ro6V0TwQIzHS3Y5CrVC6+TZXyrgw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 13 Jul
 2021 18:41:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 18:41:08 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH 3/3] KVM, SEV: Add support for SEV-ES local migration
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
References: <20210621163118.1040170-1-pgonda@google.com>
 <20210621163118.1040170-4-pgonda@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <71d3fdc2-7866-1486-d8e4-5a6469982cd7@amd.com>
Date:   Tue, 13 Jul 2021 13:41:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210621163118.1040170-4-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0601CA0022.namprd06.prod.outlook.com
 (2603:10b6:803:2f::32) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0601CA0022.namprd06.prod.outlook.com (2603:10b6:803:2f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 18:41:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8e191c5-70af-4453-dd0d-08d9462dc790
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45570B144C72A71BDC4C4DF4E5149@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JAHmt67HAOmJF/jLnqWJ67dbWIUzJjnglntkqG/aMy41bRLZnnlLOf+fWXkIEFkTYHSAe/jDlXPt+e4ii87sej1Iip22SPLDNtAaeHm/mw7W/HvsQOz6iJo18/eF7nSOJQHPwQhfIY5kZCZoMzfrNNY5v7nPlGmZmRmr5wzee9dktX+NaXjzEiMUTAi2oZIxo++3GgX3r7LHviBs1gOtiaXDDaubLX+y1A1Vc8HXzBAPcu7b7IFsGw06rqqK5Oje/GfM7sZP76sU88R3FWQbyirTgazm9dQycZX1kYBUj1CxkARozcNi28GpeRcMNCPL498D7OBHSgvkg2t+nDPp62gsCqarr3HbeVZ2913NsHoMNpWgzJXSnxo/cZQU/ezWiSpu7Pvc8sikYyOw6HYvV5qAdk4yeZnkArCifHQB0zNd9Zu4yRokeVNv+dsCnKCAPJFjCD8RXxtOI6ipAyiNa1/NmACfx3zJoiD+pZGhGb933UyjDJwL/1/af0bVaVBobAPXvpZu6GX/1UTpdJ8w7DRwPtKrhAIN6W/ljTwZr/Dp1GUVaq5LHoa8QtQJ/y3EuoF2vtIItCLAzLVDo8GPW2Vj9iF5EY7rC8zPkrf3vsx4tmEfauiqMeNpVMxnPCHYaTr5sQSyZm1jTPNBjmn0gNCUhPkS/vYtkw/8JrqPPaYo5Z77Y2nFkTY/G2UITZVbH48Tu6I6lnaHYxyIKOLlcVhNDQeRdNAWtv/U8sxMktDLyyUa2vE7Ve7AuE2jH3e/lBbOpWOoD48kDUTsrpQXWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(8936002)(66476007)(6486002)(38350700002)(83380400001)(66556008)(5660300002)(4744005)(2906002)(44832011)(26005)(31686004)(36756003)(38100700002)(53546011)(478600001)(86362001)(2616005)(316002)(7416002)(956004)(186003)(4326008)(8676002)(54906003)(52116002)(66946007)(16576012)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXNTSGR2cTJLa013eFlKZGxVY3ZOQ0xHMDJ5ejJxY2tUamhTa0xXcHVSWGJX?=
 =?utf-8?B?REFLa3FOMlN0L3BCQWFoeVpqc0xwdWx5RURrRWpXMytPeUlaemU0SDgwbVBT?=
 =?utf-8?B?b2M1a2RYZWg3cnRsSnNhZXNIWjg2cWZxY0VsMDRIOHprZG1FRlFFMytsOFBX?=
 =?utf-8?B?WkYrL1dYeDh5alJ3RkV3RE9ZNnFrRXBHaGdySUtLMExkeExOL250N2F6QTFs?=
 =?utf-8?B?aEZZVVhueUYwc0hsT01XNWlnVXErQWhSZExaM0J1eVFTWVJWeWlXQldHb01Z?=
 =?utf-8?B?R054d0pJeC9tZVZsd3loMERzeTdzei8xK2VFV040V3lKcFNmMGlaejlJSTB1?=
 =?utf-8?B?YmlQL0NwMEwyT2hMam1aQldYdFBMY29NWTRJR3dVVERDaG4vZjBFVHpDUDZ1?=
 =?utf-8?B?c3ErUTlRdktKYXJRVnFoenNMVXcweGE1Q0pGQ1FXUEVvZjFPRlNYN1FUUy8w?=
 =?utf-8?B?V1laeVJjNVNiZ2JzNnhPZVFDWXpNZmhZcXZTd0N3RUVkVUZGVzZFUFltbUgv?=
 =?utf-8?B?bkNsN3F6OUZrUUJpalh3aFd3VEJGeTdPSFgvVVUyK004cGFLTURDMklGSzJL?=
 =?utf-8?B?TTBBVHl2aFBiVHRUaSswejEvMGJ0RUd2OFJ6Z0M0SlBDUUFINWhqdDVNZkRG?=
 =?utf-8?B?SVNpaXlNdStyVGliYmxxblo2d3k0ZCtUS2YvTkpEV0ptc0V0MERQWnJ0WnZQ?=
 =?utf-8?B?QWViejBnWmNHenVZQTVkMHlHVWh1UTVKYzJ0Zzk2cStXWm94aGtUV0RIUSt3?=
 =?utf-8?B?Z0ZjRXpBLzZRUFYzM3pORDkza3hLT09kSlJ5OWppUU1HaDVGcVN1d0Fia2sr?=
 =?utf-8?B?NTN0NGh6RDZwTEVyVThScks0L3krNWt1UFVqdmJOWUYwZFprbVFnNzF1UlBm?=
 =?utf-8?B?UWI5VnFZRUYrcnUvcGNtd2p6MGRMM0pmZ0xqUmk3NjRaL20yUDZZamNkeHlM?=
 =?utf-8?B?cUpaL1Q0c0ZvWmp6S241ejZieFoyOFBGSDhhS3ZnRnhWdW1lQlFoWHVlaEtS?=
 =?utf-8?B?RE1IaEpvbmtIczljUXdScWd3OXRzZ1lmTC9VNlpSZ3ErN3lVSFQ0a09nRUNw?=
 =?utf-8?B?dHdnaytJMzBMS2tKVGpuZ2M3R29VTjRnNUhMb1dxcFZTS1ArcWZ3eDNpbnFw?=
 =?utf-8?B?NEJwSU0vcEJmcG85MTJ4b3RaZnc3eGRSR09JSE1OQmFiWG1GWU93S3pjVndL?=
 =?utf-8?B?K3RVZDlJeTUyQTJwdnFhZkF5YXl2bGVUdDNtSElicjFETnJ0bllaUUdSeW1Y?=
 =?utf-8?B?WlVQVzV1TDBrMmJuWEJSVWp5NTRZa2hLUW1qRHpxcDQ3WmJZNE9JYnB0eTRv?=
 =?utf-8?B?UXMxTkVKY0pvK014RWhxTVcxRjZIcVo5elVyMFJMVVBNUG5kcURiWGpZSzhr?=
 =?utf-8?B?Vi9mY0ZlZjEzTDNyNk01aThEc1BaMFkvMTc0OVRCallBVEtMMXhyWFVTbEpE?=
 =?utf-8?B?MnZDZG5aeWN2NngrK0hYTDE0LzlSRVpjd0VzSmRIWHFYNTVrNnB5Z0c3WlBY?=
 =?utf-8?B?Wko0OUJOVExTUmI1cW5nOWhodTFNbFN4OWE0dFRXbG1VT0VyVjlTRUIxV0k0?=
 =?utf-8?B?Y0hFdEI3cUQ4Z24vWGUwRjhlVVorZzB1YXJtci9kMDhaSHl0ZzNZOTY4M0pY?=
 =?utf-8?B?UlB6UFlDTlFqeGNPczQxV3hhSnI4L1BwUWpNZDZmeWZzTjBqNUo3NlpXN0Jv?=
 =?utf-8?B?YXJra1gzaE85Uy9pbXFkTm83dFZqY2FrYVhYazFoV0xSZ3N4WUczUHVHcUFm?=
 =?utf-8?Q?URtYEzX0lJDqj1w/D1kMX4YkDF4v46ytpVbW8VN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e191c5-70af-4453-dd0d-08d9462dc790
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 18:41:08.7137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8LMVI/kGF/8iOhqMA9kJYqDgBJQQYwhKEXccXCRPh5225m+yzQww96IDhIqrB1r+SS+/ClVtf9etV0UTXRW5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/21/21 11:31 AM, Peter Gonda wrote:

> @@ -1196,8 +1299,19 @@ static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	INIT_LIST_HEAD(&entry->regions_list);
>   	list_replace_init(&sev->regions_list, &entry->regions_list);
>   
> +	if (sev_es_guest(kvm)) {
> +		/*
> +		 * If this is an ES guest, we need to move each VMCB's VMSA into a
> +		 * list for migration.
> +		 */
> +		entry->es_enabled = true;
> +		entry->ap_jump_table = sev->ap_jump_table;
> +		if (create_vmsa_list(kvm, entry))
> +			goto e_listdel;
> +	}
> +

the patch looks good. Similar to the previous patch, do we need to check 
for the SEV guest state >= LAUNCH_UPDATE to be sure that VMSA's are 
encrypted before we go about sharing it with the new VMM ?

-Brijesh
