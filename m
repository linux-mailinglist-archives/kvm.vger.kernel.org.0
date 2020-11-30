Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DF92C86E3
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgK3Ofp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:35:45 -0500
Received: from mail-co1nam11on2074.outbound.protection.outlook.com ([40.107.220.74]:50296
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbgK3Ofp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 09:35:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7MZL2y2Nx4iboytIP39F1seVpFUMbC0TrMD4rw/Vlusaibkg8SS7/Qw7EIwe9kfv9JvZ4ygOrUOIQlXzAGRFc0DEitrGQCx5FplRQYMSS1b1AuhR2XjDykZqBBXzuhWNaLDh5PxX+TOSyFDgkawZTro4Jdbl9yE+P1x9HyRehu4H7nq0jBOHKexO6uyElLwqBhlfesb1ye1mOOd5l5U762cshF9evefkYjES8FpbLHF/N466sluXrI9XFvXyL4qO9x9XtrRygr7DPuOmYR0pir7OXRAxPejnm/jnsKJROFdjX828hB3lev8IT81No0fVuVUfCjo+eCIcabZYyIOSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zEsFB6Wr0Kxu3CoN+H1sv7oV2ERgSlSUpQoYNhnSG4=;
 b=awXJLhL9q0pvbYeo8+oj8CFaeSnMyDOsBTjgde3MoPd94v7eL7ZadVQj9XWNx27Eju22wXyAWpJoFn3IjBZlDD/H1gVLaEnk9sYPzfWbGhJ7IpD7p/NXdQfOz/F4voanCIHETMUGcNMTLfu99J1KCfRZO1UqoQUUE7hfx7mvX1EZste6FbSE/tZzeN/SR4VfZpL9dG+/YzX7eG4P15auhaUUxAouCbyuuJVU7+d6dovBAQc9dWVdESJbcOdwtiHJN0JkvRSoNnQKkymdUKUvpmtwxoXbGTEywli4DFLQVyAqemT1okgFI7gIcvjBGzHMGIDtOGMvayMpKDM6BjA4GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zEsFB6Wr0Kxu3CoN+H1sv7oV2ERgSlSUpQoYNhnSG4=;
 b=jj6htOtfYXg5i0xhOz8mJbra/hETiLoKtXlkp4Nts/sugG4OpJqBuJKUoWSApdOsy38gxMy3FRMtwDBvq/0CCV9JmoL2sP/3DeIXV1lle+jj/QGJKp41UK2v6V2iPBL3njaW7W+sCaiQlQtSRg9c227G5jRpcddN0qZIbNJlO3U=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1866.namprd12.prod.outlook.com (2603:10b6:3:10c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.20; Mon, 30 Nov 2020 14:34:53 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 14:34:53 +0000
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
To:     Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
 <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com> <20201117155757.GA13873@xz-x1>
 <57f51f08-1dec-e3d6-b636-71c8a00142fb@amd.com> <20201117181754.GC13873@xz-x1>
 <20201126201339.GA552508@nvidia.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f7de6a25-8ace-3d51-d954-149752f9cf26@amd.com>
Date:   Mon, 30 Nov 2020 08:34:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201126201339.GA552508@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:806:27::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SA9PR13CA0147.namprd13.prod.outlook.com (2603:10b6:806:27::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.9 via Frontend Transport; Mon, 30 Nov 2020 14:34:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06ef3abf-6ca1-4cb9-3040-08d8953d19d4
X-MS-TrafficTypeDiagnostic: DM5PR12MB1866:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1866058C2121B9E6699075DCECF50@DM5PR12MB1866.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PhnqiCPAyyNFSBwzVJmfIxncByz33jDqRCGmSKUq9JApMgXQkryMCyK2faFPrQdui02pJvdtbVy3f/uUExE6iUzKimlR+Xxd41q7OAkcrlpamtsPttWPc7jcc9puU2oX28m84tjjreqNgXlkr/sKGb+fYQQKAuSjj6ym8ih+8mHPqDDDZOghWdU+Il/cmcEdLESCbukob5Hfl+mAVVeDTPfAOMkoyFXgF9iAtrUB7aVHGFzabYmfsjE4kgTqIcphMWPO4ZvRYQFV9w/O5ObMpaIS4JK6s1el0bYWBZtZ2IVFTIlfD5ze/bU+pbhpwE2X7WPVyAh5kFNjl/sjPc79z+Fy0hGRbMNUP7tGnMa/purezb1IkKuLyvk0Jcppwml3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(2616005)(31696002)(86362001)(956004)(31686004)(83380400001)(316002)(66556008)(66476007)(26005)(52116002)(16576012)(66946007)(54906003)(110136005)(4744005)(53546011)(186003)(6486002)(2906002)(16526019)(36756003)(8676002)(5660300002)(8936002)(4326008)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U0VPK0ROaWFVeERqdDdXRXJFT2kweGx0cCtva1lISzZXUmtKeFVTZm5hL0c5?=
 =?utf-8?B?Y3JDRjBFbjJpZ3dzY1VJMmNVbDhYdldwK092S2dKRVdwOXlEemhibVlzZ2xV?=
 =?utf-8?B?Tm9sOUZZNHdRQzJEOEdWWUJYS0tMZWwyUnVGT05lckxBNHBobGJKc052VTR4?=
 =?utf-8?B?d3YrWWVocUMrdnFDVElYbDFxVEJTOG5ZVS9jNDNOSzRvUDRicUl1Q3V4RDRD?=
 =?utf-8?B?cjd2OE9pL2lvRlB0L1pYVjhmQTZRRi9vZkNOVGJtMXpyWnNQeXErS0hoV3JE?=
 =?utf-8?B?SE93Wm5Hb3hjWnZERXcxRVZ2cWxIUU5Gc0tZcEZRWk1IZGNKZ2cza1Y4R01m?=
 =?utf-8?B?cFFPUnBleXdxVWtsQkFHczRRTzVqNnZzME5WT2s5Rlo5a3I4eElMMmlvSnlK?=
 =?utf-8?B?OWIvQy9rY3JUOWk4Zzh0Yk9LR3VheHVHUGdTYXFtSVFrMFg5NHU2VVIyWEpH?=
 =?utf-8?B?TndxMHluS1NJYzI2S1NvdndWNmJreFpUSlFKTDRxclhQMzRPTnVObjZ5V3BO?=
 =?utf-8?B?Q2xIZGpTSzR0MkNmMEJPbkZJckVCK0NLbkdJT2NsM0UyVzkvbXQvZWNsQ2dI?=
 =?utf-8?B?d2NrMlRVWkVyM1g0dlVFMXZIWnJ5WjFNcjBTSVpNdUh1M1Awdmg1VVhZZk9E?=
 =?utf-8?B?SWI2aVVzb0d2V09ZcE1aREJTOGFyN3lQK2gwUHd2MU9YYzBhWXpJbnRpVEQw?=
 =?utf-8?B?WWRtUmR2RFN5NWFBdUExSk92cmU3L1FXN3piemE5cnJTU3hCc3doL1gxWUxt?=
 =?utf-8?B?UDhFQmY0QjVaOTNPaXhoQ1kxeHlUQlE3ZnRQWWpJbDhyRStXY3F2N0w1WWc4?=
 =?utf-8?B?dGdYSVFnZTg5aHhGU3I4dnVVN3Fxd0hUbHZMUVVoQVNrYWRFaFNoUGpiREZn?=
 =?utf-8?B?OCtXdWh3SjE5amUzWUdHNVU3Mm1sU1QrOFJEYytIbG9QdDFZNXhTRmNXdlRQ?=
 =?utf-8?B?VlppNmVPaEU1TEk4c3FGQ2VyTnhnU2loaUdZRGhQM29ZUDNRdkUzNi9SYVBV?=
 =?utf-8?B?bHc5dEZjKzlTaXgzM2Q0U21zbUFEaU1qK2xqcTdlUDBDVWpIb2ZoeVdmZjZr?=
 =?utf-8?B?VDVSVzFRTm1CZ2xnK3FDVjY5ZDMxeThETEhQZW5OR0hhZi9mc0o5WkY4Q3hw?=
 =?utf-8?B?Z0I0VXFLalVuZk1kUDFhKzlYUmhUV2Y0alhscFhGTGpaL2JVelhjOUZYTnN3?=
 =?utf-8?B?aytFR1ZpZUYzVGhYVTJ1NTlWa01WM0ZkZ1Z0Z2FaVUhkcDh4SVNMNTdKRldT?=
 =?utf-8?B?MmN1SlpjVzcvNGRJVy9pY0RsZDFBbGJtbiswSjhzYWM2akhJS2FmTGdsTUZX?=
 =?utf-8?Q?25SRORyK+kRXY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ef3abf-6ca1-4cb9-3040-08d8953d19d4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 14:34:53.3394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrOrvDppmIp20qsu5ds5Mieh7q5AguooqPSwIjJVFVP+cJhA6VuNp2s9wA3AFTroSTPKuBG9eEjo5KQvPVH2kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1866
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/26/20 2:13 PM, Jason Gunthorpe wrote:
> On Tue, Nov 17, 2020 at 01:17:54PM -0500, Peter Xu wrote:
>  
>> Logically this patch should fix that, just like the dpdk scenario where mmio
>> regions were accessed from userspace (qemu).  From that pov, I think this patch
>> should help.
>>
>> Acked-by: Peter Xu <peterx@redhat.com>
> 
> Thanks Peter
> 
> Is there more to do here?

I just did a quick, limited passthrough test of a NIC device (non SRIOV)
for a legacy and an SEV guest and it all appears to work.

I don't have anything more (i.e. SRIOV, GPUs, etc.) with which to test
device passthrough.

Thanks,
Tom

> 
> Jason
> 
