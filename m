Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FC12B53EC
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 22:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgKPVoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 16:44:00 -0500
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:55300
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726235AbgKPVoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 16:44:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MufFQT5tWrr/0BNSKjJODF19KA3cFzI860vx1PTKZbFgNROkrKToOjQXYT0Nchf/sAP6SvpFZJWedMR+p+Ol5zeHMvid9kBYO8Jk9c+/UQGmypQPArDyNe1V/PwEPP5K4b7IrbutyzU2qEfI/2M1vkgB7w6/NxATEHAbFaszg8WOXk6rLdCTuG0z99jyeK4SZqF4RqjA+z/gfSu+iLkrCW4l1oRjoWTPabwTg2w9grWRVTFjpXmp9d2S91perMfvbLwMcDPQzzbvMpbPWh82BnTN829DHC6nL1OlSWf+3yr/v0pc9k2v6kDD8IImVnDIkiZfKrJtMvQ71W/nBcenxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQs7p82GluW2+sg18GuS78FbsUo7rmdcyxxxCa42nQQ=;
 b=L+7WrlsJwA40gp1ueWrXkJTOqou0znEjwCvyE5fQHAAwo8fBPh3uB+xT90Rh4nDLMWu1HO9ypIumc0wh7F9VCVNTJWxBKNbGfKVo75bH8VIb6NgHzEzMvt4mDGeh9aKVEhP4Rx1Sq2NT5paCvaF3F7e6Sd9mkAQuGZLwNY0cYjFZ7/fdZB5C6LJohqQbbDneenhHekcR7IK41HPx/lMfgMuZDQ+2hbuIkzl/XLeJe5ar4rqxGcnY2mM1xKL4afF8/Wvmk+Ri0NVT0OCZP7zExGfPNs874xZpKAxqzTYBmomZyWzUXd2zuPNYvv+EgDcH+yGbtMOshf81ndmKPxMcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQs7p82GluW2+sg18GuS78FbsUo7rmdcyxxxCa42nQQ=;
 b=U7VxG78dydRocMv2jjXwRywvVKAzk6MjZYyLwEPsSPEUYEjlZzdDWzA0mngcHSPDwrbFs/foxLpABQg+F80B3gxIHgluDC0KRiW+kpqNJMPmTyuLf5qxcmZOpXWp3LX96RbyaAQCwgEYmij1KzA8r1LECGjXIbu4knVsbRNtbe8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2828.namprd12.prod.outlook.com (2603:10b6:5:77::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Mon, 16 Nov 2020 21:43:54 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Mon, 16 Nov
 2020 21:43:54 +0000
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
To:     Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
Date:   Mon, 16 Nov 2020 15:43:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201116155341.GL917484@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:3:16::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR07CA0033.namprd07.prod.outlook.com (2603:10b6:3:16::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Mon, 16 Nov 2020 21:43:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61e62423-d07b-43f9-b774-08d88a78b6f5
X-MS-TrafficTypeDiagnostic: DM6PR12MB2828:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2828FEE9AD7621CF616B26E9ECE30@DM6PR12MB2828.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qtCUUvDTS7ZTEeNC3Dv6pWNMMH10gLhGiEwir+Q02LJHyiX4aVfdbqeIp6KQUd/iyCsGxA7EzQzjvkZrvFFW/vLdquaKUBOubMiGdeIBEs8Mbgyt2o3LjonZy8LcdFbAGi2qgC/0fmZrb8TpF8cB2qMjq+SVuFq1JhQBHhBwA8n9UsVJrsNKHdS25i+OUIoAjHqAiDzeSz0x4BhRPQTNZzEOdXja++ZqUyp08taOHSpwcBJI+ErUQBMsmOl+QAslHGycGI4KrCiuHLNdOI0NOAaLFyvcGwfDMQX6mWVCWxEU2TLpsSkHaYX7s5rlWQyBQVps79ZdsdBWOLT4W89m+XdGZXu7z1TqNbiw3vcpDOTzFX//fWm7xceRd2QrqB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(2616005)(956004)(316002)(5660300002)(36756003)(110136005)(53546011)(16576012)(52116002)(26005)(54906003)(478600001)(186003)(16526019)(86362001)(8676002)(8936002)(66476007)(66556008)(66946007)(6486002)(4326008)(31696002)(31686004)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nz5wOFzPevC2s4hZugpsLtk9wj0i3HBbIhEPc6EgWjC90hGXFGZsqth4ioDKRwvSFg15nkTStZ6Rir93Y7a+tvvduYG77dFi2caNSeE4Df/YzRXxo4tTsnuBl4cKTf9sv1h3HJ8EMp3ioNVJ7tVbktJHpe3rX8/PAoqdG7Jbwj3FlKOSFVAtbhMAbikiu3cOAc3n2BgvqmJQXIhD7goDCZ3yUuXBEacILAxLqg49A6n8MqJ5Pw7mCUcbFb+uB55WELvqjPrkqpVfXtYwkU/eK/I+whYBP3Jmty591MBjwLEYOMixNjjiDHpTNLs84vtloHWQPybOKZ26UYrmiKmfT4vXxw6ZxjhR7uVbU5vBexozklM2Ywsc6fIG5+4IqP9HSBDK32Cg3t8+3/RAzljz+2DyYa780tCkKs+zf6aZs1tmaxLkx8vfUc5glpMHXGtWezkl5uwbvJq8mAXfbvqFW1hs+iYgHBuoHgUvmluAD8udTfCZDoP6OkvUxVpKCz7R8tg0ZrAH5rScgE+qwe64wXSwYXYpeFbFi6YP1q8bxwO4g0iBJXVjXX58W4lf03fJ6zTE2AX2VhhozfpvGNhUbWr+iFdKGWR9lwjeX6SazhqjVyZYNE4gzs317e65TbbIZBFw/mJzmOdVW8OPlrRCUA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e62423-d07b-43f9-b774-08d88a78b6f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 21:43:54.5649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vU/is/oLZcEl/hv1HvnE5o6qH9sAjlwzLsSlH5jjA2/Ta0yLQ+zRVxKbNNwr+ygw3X19GHZGMQ4vXFCXi7BXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2828
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/20 9:53 AM, Jason Gunthorpe wrote:
> On Thu, Nov 05, 2020 at 06:39:49PM -0500, Peter Xu wrote:
>> On Thu, Nov 05, 2020 at 12:34:58PM -0400, Jason Gunthorpe wrote:
>>> Tom says VFIO device assignment works OK with KVM, so I expect only things
>>> like DPDK to be broken.
>>
>> Is there more information on why the difference?  Thanks,
> 
> I have nothing, maybe Tom can explain how it works?

IIUC, the main differences would be along the lines of what is performing
the mappings or who is performing the MMIO.

For device passthrough using VFIO, the guest kernel is the one that ends
up performing the MMIO in kernel space with the proper encryption mask
(unencrypted).

I'm not familiar with how DPDK really works other than it is userspace
based and uses polling drivers, etc. So it all depends on how everything
gets mapped and by whom. For example, using mmap() to get a mapping to
something that should be mapped unencrypted will be an issue since the
userspace mappings are created encrypted. Extending mmap() to be able to
specify a new flag, maybe MAP_UNENCRYPTED, might be something to consider.

Thanks,
Tom

> 
> Jason 
> 
