Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB357A5680
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 02:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjISAOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 20:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjISAOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 20:14:04 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062.outbound.protection.outlook.com [40.107.100.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED590;
        Mon, 18 Sep 2023 17:13:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4o1dz4JiwPCnbc18PcssmzHd7tk+wHZGK59VYvBrk7apZ605JUPmpbybs33xT7r5/J83QUYZoZaoOEes5AiXEPWHe0VPDFxJ8dLWQZAULaqPZUuCsKqt3dsKzVfrgCVLqNm2u5M8hB8CVCU+IE52rG+B/8rd7HfjK9BFuT12VkYDPelsZ0TYJuRyM/jjias2zNiBgOQSVVtfeihsPSS7cj9kfvWM3VFb1VjsdG9uZpRtUw8YzciveOQzL/0vHRHteuCBdUjAT/NdJ8SbTyJwix2NG5u/Hxyrc0N+joiAik+b8Yy5Co3kcyvoyeP8Wvnl5e6DGkWlfU5E9lMHWmitQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCMwGY2Kiq+Gg6zIzSePalKikQ6D/7OFsySJfmYK3KA=;
 b=CSbDJMovKWfTYi+iVLcHUT4PfW1UG6MHm+XXZGuOWm0s6HbvAtAGBZk4xx4eUFEWi55D869kG9rW4TWp3EuEFx4gP/glBu4lLpINQoHJraUcF3eZ6LBXnPYVSXnIZxsE4F2Z7wMxcySxZwTjzlPBT/m7wrLSZucJtthnYYZDJI/YSMROb/TDjocmUF43ghadkPvunp6yFoVDzhCL5sfycCNluRhlM8N94Q6jGq86ldbvmF45l+t704TLJjzqOyM5m0supCeOS2uZYZkCMSs36CkoilPrJYNdwvix9zXlsG1P+qjlnh0ZarrNWuHlU1dI5kg5Ij3TKE+pmSfs88Nf0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCMwGY2Kiq+Gg6zIzSePalKikQ6D/7OFsySJfmYK3KA=;
 b=GFi8SjA38Hy4gkPPOrtwRbY0ConNLkkl/Q9N7wiirodzumtqFeMD+mcIoe2D0poh4ijJXnUCWYzlo1wZqfAw/RBHEHw4yQytKApV6A7RWYnp3xPJS1CamEcFLdpGtjcCPQ35AZi2I1hMB8e6yPxvP4KiEGdQN2BKeiz+x0gz1ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MN0PR12MB5788.namprd12.prod.outlook.com (2603:10b6:208:377::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.34; Tue, 19 Sep 2023 00:13:54 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::5c9:9a26:e051:ddd2]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::5c9:9a26:e051:ddd2%7]) with mapi id 15.20.6792.020; Tue, 19 Sep 2023
 00:13:53 +0000
Message-ID: <91e0842c-1ba1-449d-b2d8-a3e2fc5ac95a@amd.com>
Date:   Mon, 18 Sep 2023 17:13:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, tglx@linutronix.de, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca>
 <acfa5d59-242b-4b31-a3ef-b4163972f26b@amd.com>
 <20230918233219.GO13795@ziepe.ca>
Content-Language: en-US
From:   "Nelson, Shannon" <shannon.nelson@amd.com>
In-Reply-To: <20230918233219.GO13795@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:510:325::22) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MN0PR12MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: cdcfc84a-a579-4c60-e539-08dbb8a54ebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f0pXSYUG+bL49Di8Lt8N7LGcclTXdIQWlBSE9zqvQi284rg2AS7wtH8QHlwqk7LOrgiaLtWULpuSfhHm7tDlAX2ycGHrcpH3QKPCfixlikU6VVx/C9jP7Q/HnlC6uajfhNiIBmri61UBr7OTGGano1zDAKGJH07TmzcRrJJFMz/XQky8UwYaQFHYpT7Z6nUK8ZNKop9+/EJTIhSSLqj1zVRteuYUbdWXvZQfa2hPMLb+UiCJacZdtEDGM+ZF2/FLOQ23wDpAYQjwL6lABb2+Na9M4icW48Rxx5yTadS0CP/EdB+3z1k3V3YAuqU68QddnvpvLCaFz7cgmFCHeMNzAeUjlIbRXge6pAGWPaQRMn/DorwpIDISpPjeOYyK5GRYS1X6uBxzFZN/GyEYTmXDNCqqjcS07dR4TRIYZJAI+5YNdB0+UqNpqD5VDU0uatxpX6it3D42IOKulJjfnLS+TLWvKphrPNPNcJXpDt33dM+eiT/dwQXQ5Jna0Juzp9w3pgILzOFDAEfpACBQCXe+UPgxH00+XeqrSG/9TnttGTkPhAIT/OYUWxY3mLxCyGtPo/7w8xjkxiJgaPqDlWo0tz3/F5X4lo3B87kq/JcjbCKIhqUTB0J4jVaKRCBXMPeUjfwQ76sNUsjeIF/M9pxr2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199024)(1800799009)(186009)(38100700002)(31696002)(41300700001)(86362001)(4326008)(36756003)(66556008)(66476007)(66946007)(2906002)(8936002)(4744005)(316002)(6916009)(8676002)(26005)(53546011)(83380400001)(5660300002)(6512007)(6506007)(6486002)(31686004)(2616005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUVST2o0blZBZzd1YUpqRXR0YmplTWxWTEVab3E4K2JaaFFjRkNCb1FDTk5w?=
 =?utf-8?B?WXMremZtdmxIUDFWSmo4WlA3VGxNSkRPcGRsc1F6ZmV1YmxldnF2UEZWMmo4?=
 =?utf-8?B?Q0pCSmpmY3JWU250YzZRVkwwVHFUV2xkTXlLRzkyVVhyOXJwYm9RREJyN0Iw?=
 =?utf-8?B?aFcvNmJQNDZRTmZXNGNQUm1OMmtLUXBVLyt2VVBhVDloL2tiMUZtRlRpaVZK?=
 =?utf-8?B?THdubFAwV3RxL0cxZEoxcUQ5bUx1ckVJL0tKRy80NmQ0djBMT0x5c1hqNGwx?=
 =?utf-8?B?WUloQ2ZWd1JyelZ4Q0Jvcno1VitiNW1QV3p4c2s0elU1WG5EU2tuWk13TEZr?=
 =?utf-8?B?SjJHUjRWbG5vbDdpNjBzeWtBUFMydDVqcEt3ZVo2cEJuaGpLdWliL1VaeTg5?=
 =?utf-8?B?dTZuR1lpNGNNRHE0N0RxR1hVcUVFdTdKSzczUlZYY1RzdlhJTHFzUW8yRlN4?=
 =?utf-8?B?T3p5bE14R25DdzdsTzdrQWdkdHZQazlvemRaLzBwdGtNd2IyVzFwSmp4MGF4?=
 =?utf-8?B?Y2JzRTRpR1pSVzNoS3RHVE00OHNPSWFGWm9YeFVkNDdDS1FSS0prYnVqWDB4?=
 =?utf-8?B?N0Z0NDlqV3N1TTA0MklNOXFUWExHUnhrNlRLcUVKcDJjbnpsbFBqZzZ2YlNu?=
 =?utf-8?B?b25GTE55bXgxNXF1YkU4Uy9zU1ExVTl0Q0N2QlpWR2RjNlhuWDRaSzM1SGNT?=
 =?utf-8?B?QUpIU2lSK1JzV2pmY29rWjJPZUdMcFdaT2IzSmNWTzhZZWRDdjladUFNZEx0?=
 =?utf-8?B?VHNSTnNGTm84b3hqbHdhNVkwSmdkZzY3cWUwMVZFNWRIMGt3TE1WT2dPYkFH?=
 =?utf-8?B?MGR4TlQ0ZzVwbmVCZDBvdVVlazBTczk3UWN5WVV0QlNxbnQvL3ltY3ZLM1Br?=
 =?utf-8?B?c21kOTVGUHVlYm45SFFuQmZKa2Y2RGk0UXNGclhtemhERlNwdUFOK0NSOUpo?=
 =?utf-8?B?Wm9xL2FXUkd0bkwrVTczSDdHYnZOOHNXSmt0QVhpZW12ckdibC9vU1VWc1Ni?=
 =?utf-8?B?RXlqOE8vemVJMDhya1ZTYTh1QzBoZ0UrTHdNYzBwNkg2K0JHaWJoRksyT2Ex?=
 =?utf-8?B?L0cwZmxqQk1ISFFoZ0trYmdZODVhVzMxNW5odEdDV1B1TTlLbXJvQ0lsclVB?=
 =?utf-8?B?UnFKNUtrT2VKTWM2bUUxTmRCOHNsNGgxcFBSR1JEWm10Y2c2SDJHS01TZTRV?=
 =?utf-8?B?RVpTNjNZcThOek9ZTkF6NE9yMXFXWTUwQXZIT1pxMEhScVBsRkdDVTljSThX?=
 =?utf-8?B?OWdLWkllVXorU1o2OG1PbU50NzVxYXo2eG8rSTAzQVgvSGpNL3hZSDlXaWJl?=
 =?utf-8?B?Y3RsdnRoQkJ5aUtWcDFjTEJ4NHFkNXRrY2dDbG1ON2dEK3huZkRUdFUxMzBE?=
 =?utf-8?B?MHh0d0VMeHRmTDBEZis0R0lQQ1hXZ2huQUdkWlovUTROZGJxVFhSaXZQOUx3?=
 =?utf-8?B?WUZWUFJ2UGthS01EQ2w1QXczZkZ4SGlaMlp3aHJRVng1NVNwWWxTYmNONTd4?=
 =?utf-8?B?bTB1dkdxV0tyWjRORlFsbVBFWnRzbTRCeXFVd3NTYTRkSEs5S1Z6N0RIeks4?=
 =?utf-8?B?REw3VE43MEJybzZDckU2YThBcXduWDdBakJOQW1xYVNSVXUrN1BlQnRXZUJv?=
 =?utf-8?B?WkFJOGlseCtsM2s3UnJSd2s4cEpzZ2UyWDBUNzFDT3VxOEdnb2l6VHVITWk0?=
 =?utf-8?B?eUxiTnMwOGx0NmQ2TnRNOGhLN3ZwVE1ZTXd2bzVicmlLM08rVnNGQ0Myc2gz?=
 =?utf-8?B?cGtwRlVxQU1aQVAxWk10MGFucUlkMFJmMjlNOWJZd2lTMjAzOEhrZXlTTHRX?=
 =?utf-8?B?UXRPQ0JCZXZoR0o5VmdvSHh5Q0k4ckpPc2tSUmk0VS80cWdvOW8xUENqRHBw?=
 =?utf-8?B?cVhSbzJYOC8zRFNNN2gxUzliU1JLWTdBYllHTGRqUGtrSXRWdEExYkwvbmQw?=
 =?utf-8?B?SEJsbzJXWnZxb1pMWXdnU0cwSDBMYVh6SXpReUlzaHJmVElqaWJUdlNsUGVJ?=
 =?utf-8?B?LzBFVHBGQkZqRGNrTDFwWFdoajVGcGNxbU14WG91QVN2R2ZlTUdXNkJYVFUx?=
 =?utf-8?B?bXozVEVEWVBSc2dzYW9PQ1FLK09icStBcHdXbkZTdGZtb3k1THRXUk4rajFZ?=
 =?utf-8?Q?on8Dwv3w1FU8SC96mjXvcp5nT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcfc84a-a579-4c60-e539-08dbb8a54ebb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2023 00:13:53.6771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R5dDQXIdX8/gEw0a4aZimhLaTg68ur+S3drRTBAcurzXgkPF25gsEv1wRGuGEDkV3Mr8aqRjCStJlNwdwD/GOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5788
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/18/2023 4:32 PM, Jason Gunthorpe wrote:
> 
> On Mon, Sep 18, 2023 at 10:48:54AM -0700, Nelson, Shannon wrote:
> 
>> In our case, the VF device's msix count value found in PCI config space is
>> changed by device configuration management outside of the baremetal host and
>> read by the QEMU instance when it starts up, and then read by the vfio PCI
>> core when QEMU requests the first IRQ.
> 
> Oh, you definitely can't do that!
> 
> PCI config space is not allowed to change outside the OS's view and we
> added sriov_set_msix_vec_count() specifically as a way to provide the
> necessary synchronization between all the parts.
> 
> Randomly changing, what should be immutable, parts of the config space
> from under a running OS is just non-compliant PCI behavior.

Hmmm... I guess I need to have a little chat with my friendly HW/FW folks.

Thanks,
sln




