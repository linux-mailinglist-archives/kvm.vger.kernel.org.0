Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0E273AE3C
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 03:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjFWBP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 21:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjFWBP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 21:15:26 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E841BD8;
        Thu, 22 Jun 2023 18:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8Sg9PXw/gY/Q2aPKhe7MuLgaGtshdksvnmvDO+IAbwqmAGdsmpHRHppqLpH/gMGVwBvzkl/YtYYi1TzRjGHLRKLdI6LznAWREvOd2LnlonD0RZy79LBDjbeOxRqq/gqbG5n8l3yNomB7gbBxIjYLrSxfHSO7MN+vWUyUDdKd+Na+yYVFWy8ozHVx5bpqJSdSxXPn3r8rPwQxTm93ZEomBhkEvYXmIZui4VXcDSLVLC0npwuFePFSX1cN8MD2JwpC+MlLAMoCObUMzw292/QZylDPT50loPP4DEHqkLIifC5M3BYOmtExxmLAXTgldQQTRsEqt3A8ma3RJ2UoBrBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8bUE6C6jvgdhE+X1/Ul2HsfB2cstmY+npRZJFuaObk=;
 b=D92+VHKSHChRjZhvJNVAKWxP0FY70tsFshzpWQ6/iY5/67lipptdDOojDTl9uH4BGGk4YOUCto+8hlv9h8305d5cbxatyTiH3vdXKLS/QOspggVZOvLrhznvDGOL4mwkza6WDHb7TOrxbk+RXIPV9nZyKyG0PNRrzyX51roMIe7H1O942XHkUdTNAjgekGWuYEafoafS2Ug5hwZR4xJDI/axSoM5oSsl+gr8e9Fr8Zmu0JXGC5JPR7ablInhXSb32NSG13FmIPAVJIPEWihlx7yRxXjqStoQ+SyVzBPxfZSGBOfRVV5y3mJjcitHBFpCzuCSMFGHl2c1xSjOwZ4C0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8bUE6C6jvgdhE+X1/Ul2HsfB2cstmY+npRZJFuaObk=;
 b=ImaK7L+4vL5HF7nXJ87U7VU8nk/f/uWhSARI5pS4dP3O+S34YFKo1zDzfVfdMq9WHRgR1Z94GDsWiYpX5VBlQ3DNor0TbmIYRletpTt2RRBfCxcIpU5YIPwGDtzupNBsgP/TuU0YkkbkEJNZEeG7zA4XKXIr9kKs18RmTn2J3yw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CY8PR12MB7562.namprd12.prod.outlook.com (2603:10b6:930:95::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.23; Fri, 23 Jun 2023 01:15:22 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::1f96:31ad:7de0:2175]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::1f96:31ad:7de0:2175%5]) with mapi id 15.20.6521.023; Fri, 23 Jun 2023
 01:15:22 +0000
Message-ID: <7364628b-54b6-b7e3-b272-8f91198679f9@amd.com>
Date:   Thu, 22 Jun 2023 18:15:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [RFC PATCH 00/21] iommu/amd: Introduce support for HW accelerated
 vIOMMU w/ nested page table
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, joro@8bytes.org, robin.murphy@arm.com,
        yi.l.liu@intel.com, alex.williamson@redhat.com,
        nicolinc@nvidia.com, baolu.lu@linux.intel.com,
        eric.auger@redhat.com, pandoh@google.com, kumaranand@google.com,
        jon.grimm@amd.com, santosh.shukla@amd.com, vasant.hegde@amd.com,
        jay.chen@amd.com, joseph.chung@amd.com
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
 <ZJRQseaYkTJGHNsk@nvidia.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <ZJRQseaYkTJGHNsk@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR07CA0045.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::14) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|CY8PR12MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: 24e63d2e-9e1d-4a46-42ee-08db73875101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uw/x1E6iSafZIxqY7jqFmFG1HfxuZqo9EKumI9o4MAAyuCrQ381rCatNxp27WgnfmkZtYm3MMLgK8fnVnDypR1Dc6mk+bIiKpsQAwisJVqwNqkG3Hg9HWBWAe9ndni6DnmGKZXd0KBua+48/escQbHeSmKMowgzGlipogdcy6KV9sRZw/TSokpYrWSeG2C5enlnDyyAKFxWY4ANViDcCvDzxb2mSllh0hM2WRXh9tCcV8AUMLd/wqxrvgghqvz6og6/wWWxXndn+XVPnqoNWY3GeRPVNl6p/z/orte7uFT2CnkXg9AHiraMtZJs86/uFwjllDaKJInHoRCBcc2efCVkSWfY50xqkWb3/qlJ4P4asV7cZW1bpkH1Iyunfgx6+T/Y5/UuVtSK5nrgcrDku0d1n1oYuz+eRpbS8/d7mEOk+5sIH9ASxdXzgnHtoTOwh6j1CrHcf0uPccd4rYQwZv8Mjr7fHilE2LgtvigwyfG6HTH9nfpkG9rsWNG6uLbsMgPXXJxFsWMkVnRFjBAxXvYlL34XwTyh12ZGMVFNgm4vR6Jr6YD3dlmFVwmILq3wlbyIqfBgQr2wsdp3nzkz3qwWuwr4onVecpXWdQyvLGniJuCGT4H+S/NgJGRRh3dM09jIrXMaH6No2vhuuMxEuIql1DZGEgwB9Oxj9nt4Gpo5N5sZRRBlQA9ndxuXCt/yf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(5660300002)(7416002)(31686004)(8676002)(8936002)(41300700001)(316002)(66556008)(66946007)(66476007)(6916009)(4326008)(2906002)(6666004)(478600001)(6486002)(6506007)(53546011)(26005)(6512007)(38100700002)(186003)(83380400001)(86362001)(31696002)(2616005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjBSVTBNc3NmZy9IY3RzOWxvNzlyam15ZWJXbVVBOWZKamo2dGVWREZJWFdF?=
 =?utf-8?B?bndvZXRzdVh0RmV6YnczV0Qxeml2M1VnZnhvRGoxc2xsbFExUkRCazlDenJz?=
 =?utf-8?B?bG9Ca3U3bmlwTUtqTDZ3U3h3TEN4SGhMcjhiN0w2MzFhQ2ZBM2JHV2xxS0dK?=
 =?utf-8?B?YmhCS2IxWURtSDd0eEViejZjTFZmam4ybFRwZzRiUzFNYUUrVE1MZ0dkL2hk?=
 =?utf-8?B?M212c0NaMW84Q2JKM1JnRVNPR0J6Q2tzS0xkWDZSU1BIY3FIa0xWN01nblZo?=
 =?utf-8?B?STlJRUdUWTJob3BNcms1cGN3cXFNenNML3JnRFA0bCs1MDFmYUhqWENRcUFH?=
 =?utf-8?B?Ym1DeEhTeVlEWEF3YWZ4amVRTGNHRlFxdEZFeUtEYnlJdytHRVl3THJ6N2Nu?=
 =?utf-8?B?SWQrQ1BuTUJLTFZadXZaN0YvbThsMGVJRVJzaDVxRFBlcmpJaUowdkdVcGFK?=
 =?utf-8?B?WGZscld4QlhTaGEyNTlHTW5RMTN2ZUhWUHUydXh2QU1TTXZ3MGtJUnRIWXRY?=
 =?utf-8?B?MUhTazdMOForQ3VlOTZoWjRjSmFZK21ZQVJMd1NMbjlRc2pUZVJMUDhhL09V?=
 =?utf-8?B?cFROK1pJNU9rRURpNlhkZGRac2Q1RWE0Z0hLeDJXa05ZaVN5dUpsek1SUFRp?=
 =?utf-8?B?Zy84b01GbmVDS3dQYnFGNWVmcXhIWWZSMlZoTm56OWFuMkpKZzhCTGNnU3JC?=
 =?utf-8?B?ejBDUVRIZ2ZkcFNYTTExdk10T0VFcDh5dnVDMC9sd3JBd2NvaUQ2V1lwRXZV?=
 =?utf-8?B?dDNiZEVNK1BaSzlLTkd2Sjh4K3pSZ2I3NFhsbXZCSTVqQ0hDcTQ5WmxTR2dR?=
 =?utf-8?B?QW9BeGdLK3RVdTJCWmxHdHkxdjYwSk5YS3ZiSHRvSTlhdzlzSnpxR1cweGk4?=
 =?utf-8?B?Yi9wL0xRMnB0dnlpS2NTZko3QnhkOFRlSmsxaXl1T09MTFp1Skp0cGZDY3Z4?=
 =?utf-8?B?aDB1NndFMW16TFFwSm1ld0hQd3hLRC8rSWhrajVzWDJYZjg3dmUydlZzcWZK?=
 =?utf-8?B?ejZDcWRaVWR0YnFiZUlXK3Z3aGFBTDVsYUpYb3MxNXIxTHBEeXo5TmxpT1Yx?=
 =?utf-8?B?OFRZL1krZXYzblhmcGlCZ1J5bFo3VG0zRDlEVXVYSTBaajJMcmZHRWViSXZ1?=
 =?utf-8?B?NGwwZ2w4bldxdldDUDQ4aXJFbllQUkhuUndPVkliMm1Wc3NWYUhkNlBqTHZr?=
 =?utf-8?B?TGtESVBtTHpzZ3c3Zm5Xcm9YY09haUtENzVidVhzaGtVZTVqN21CdEtoMXkz?=
 =?utf-8?B?d25yWmdLdFdDeWJqSEM3OEo3MDczRC9wYlhNVTBRREo3cERwNVJXQ240M1VV?=
 =?utf-8?B?d09KTU5VZlBzK2FLU0hNelRRMTRMbjBMTnNHUTZHWkVtT2N3UmRZeGYrWVlo?=
 =?utf-8?B?bHNyMEF4TnVvNThSamNINjhQT0xoZkhNb3lHbVVQTzNCRHJicmlJTFo0S1lI?=
 =?utf-8?B?QU5IQnE5bDVXdHNtd3E1Z0I4ZkVhODBveUdwNDJkNFowcmUxZG9HVHo2VU8z?=
 =?utf-8?B?Q0lJNnAzZGxlbTNpTEEzUERBUWxDYXB3amN4VmRrZ1VUN0d4Y01taVh1UXpD?=
 =?utf-8?B?TG8vN3AzZ3pydHJnbUo3R2xtWkhyYzNJNEE3TU1vUGNPMVNsWkFML0hkT3ZE?=
 =?utf-8?B?dThqUFdTRWE0SklSNDl3enJPSmg1bnErM01KWUFVMGM0SEZIS3I0N0FTTS8x?=
 =?utf-8?B?am9sOXpNcEFwaitSU25Dc0VKR05ESmdWdlpnWnRpWWczM01tYWlESEN6elpl?=
 =?utf-8?B?dW5QZzUvYUxDczAzWFZBdllkU1F1MjR0bGUxQVMyQmhJUDM5bHdZbkVBK3Vo?=
 =?utf-8?B?d3ZWQWJxeGEvZDhKUGJ4M3FCTGY3Vm02LzhlYjFMazJoRnFJTlJzOExockxF?=
 =?utf-8?B?MnIyNnhIN2c1ZU84YklWSHFMRXJFakJySVRHY1NCaVJDUUJvUkhYdFBLdDJh?=
 =?utf-8?B?WGhXeEVBMDdMMTZhRHNleW5lbVdhT0ZTT2NFdlhvZU1leDE2VVoxWm1GZ1Yz?=
 =?utf-8?B?U083aTR3N2VTYlhlcEN2VXUzY1ZBVlNnUXJ6Sk4xQVE4ZGI2STFOTlk2SEFp?=
 =?utf-8?B?L2tsMEhjSFdObWlqRXZvVjh5aDk3QUdwV2lDYjM0d1VlVWpCelhETXhLRjFn?=
 =?utf-8?Q?W6hd5MmBlW/TfwzoU94x/9V8J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e63d2e-9e1d-4a46-42ee-08db73875101
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 01:15:22.1415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++NtpNmt+T6LVsSY3yNidIE0Q65SJeCZBhuEzVB0lGwMDv3DlOde4CJW/h/07Ppaoa9IVjRT495BVin85R8xMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7562
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason,

On 6/22/2023 6:46 AM, Jason Gunthorpe wrote:
> On Wed, Jun 21, 2023 at 06:54:47PM -0500, Suravee Suthikulpanit wrote:
> 
>> Since the IOMMU hardware virtualizes the guest command buffer, this allows
>> IOMMU operations to be accelerated such as invalidation of guest pages
>> (i.e. stage1) when the command is issued by the guest kernel without
>> intervention from the hypervisor.
> 
> This is similar to what we are doing on ARM as well.

Ok

>> This series is implemented on top of the IOMMUFD framework. It leverages
>> the exisiting APIs and ioctls for providing guest iommu information
>> (i.e. struct iommu_hw_info_amd), and allowing guest to provide guest page
>> table information (i.e. struct iommu_hwpt_amd_v2) for setting up user
>> domain.
>>
>> Please see the [4],[5], and [6] for more detail on the AMD HW-vIOMMU.
>>
>> NOTES
>> -----
>> This series is organized into two parts:
>>    * Part1: Preparing IOMMU driver for HW-vIOMMU support (Patch 1-8).
>>
>>    * Part2: Introducing HW-vIOMMU support (Patch 9-21).
>>
>>    * Patch 12 and 21 extends the existing IOMMUFD ioctls to support
>>      additional opterations, which can be categorized into:
>>      - Ioctls to init/destroy AMD HW-vIOMMU instance
>>      - Ioctls to attach/detach guest devices to the AMD HW-vIOMMU instance.
>>      - Ioctls to attach/detach guest domains to the AMD HW-vIOMMU instance.
>>      - Ioctls to trap certain AMD HW-vIOMMU MMIO register accesses.
>>      - Ioctls to trap AMD HW-vIOMMU command buffer initialization.
> 
> No one else seems to need this kind of stuff, why is AMD different?
> 
> Emulation and mediation to create the vIOMMU is supposed to be in the
> VMM side, not in the kernel. I don't want to see different models by
> vendor.

These ioctl is not necessary for emulation, which I would agree that it 
should be done on the VMM side (e.g. QEMU). These ioctls provides 
necessary information for programming the AMD IOMMU hardware to provide 
hardware-assisted virtualized IOMMU. This includes programing certain 
data structures i.e. Domain ID mapping table (DomIDMap), Device ID 
mapping table (DevIDMap), and certain MMIO registers for controlling the 
HW-vIOMMU feature.

> Even stuff like setting up the gcr3 should not be it's own ioctls,
> that is now how we are modeling things at all.

Sorry for miscommunication regarding the ioctl for setting up gcr3 in 
the commit log message for patch 20 and causing confusion. I'll update 
the message accordingly. Please allow me to clarify this briefly here.

In this series, AMD IOMMU GCR3 table is actually setup when the 
IOMMUFD_CMD_HWPT_ALLOC is called, which the driver provides a hook to 
struct iommu_ops.domain_alloc_user(). The AMD-specific information is 
communicated from QEMU via iommu_domain_user_data.iommu_hwpt_amd_v2. 
This is similar to INTEL and ARM.

Please also note that for the AMD HW-vIOMMU device model in QEMU, the 
guest memory used for IOMMU device table is trapped on when guest IOMMU 
driver programs the guest Device Table Entry (gDTE). Then QEMU reads the 
content of gDTE to extract necessary information for setting up guest 
(stage-1) page table, and calls iommufd_backend_alloc_hwpt().

There are still work to be done in this to fully support PASID. I'll 
take a look at this next.

> I think you need to take smaller steps in line with the other
> drivers so we can all progress through this step by step together.

I can certainly breakdown the patch series in to smaller parts to align 
with the rest.

> To start focus only on user space page tables and kernel mediated
> invalidation and fit into the same model as everyone else. This is
> approx the same patches and uAPI you see for ARM and Intel. AFAICT
> AMD's HW is very similar to ARM's, so you should be aligning to the
> ARM design.

I think the user space page table is covered as described above.

As for the kernel mediated invalidation, IIUC from looking at the patches:

* iommufd: Add nesting related data structures for ARM SMMUv3
(https://github.com/yiliu1765/iommufd/commit/b6a5c8991dcc96ca895b53175c93e5fc522f42fe)

* iommu/arm-smmu-v3: Add arm_smmu_cache_invalidate_user
(https://github.com/yiliu1765/iommufd/commit/0ae59149474ad0cb8a42ff7e71ed6b4e9df00204) 


it seems that user-space is supposed to call the ioctl 
IOMMUFD_CMD_HWPT_INVALIDATE for both INTEL and ARM to issue invalidation 
for stage 1 page table. Please lemme know if I misunderstand the purpose 
of this ioctl.

However, for AMD since the HW-vIOMMU virtualizes the guest command 
buffer, and when it sees the page table invalidation command in the 
guest command buffer, it takes care of the invalidation using 
information in the DomIDMap, which maps guest domain ID (gDomID) of a 
particular guest to the corresponding host domain ID (hDomID) of the 
device and invalidate the nested translation according to the specified 
PASID, DomID, and GVA.

The DomIDMap is setup by the host IOMMU driver during VM initialization. 
When the guest IOMMU driver attaches the VFIO pass-through device to a 
guest iommu_group (i.e domain), it programs the gDTE with the gDomID. 
This action is trapped into QEMU and the gDomID is read from the gDTE 
and communicated to hypervisor via the newly proposed ioctl 
VIOMMU_DOMAIN_ATTACH. Now the DomIDMap is created for the VFIO device.

> Then maybe we can argue if a kernel vIOMMU emulation/mediation is
> appropriate or not, but this series is just too much as is.

Sure, we can continue to discuss the implementation detail for each part 
separately.

> I also want to see the AMD driver align with the new APIs for
> PASID/etc before we start shovling more stuff into it. 

Are you referring to the IOMMU API for SVA/PASID stuff:
   * struct iommu_domain_ops.set_dev_pasid()
   * struct iommu_ops.remove_dev_pasid()
   * ...

If so, we are working on it separately in parallel, and will be sending 
out RFC soon.

Otherwise, could you please point me what "new APIs for PASID/etc" you 
are referring to in particular? I might have missed something here.

> This is going to be part of the iommufd contract as well, I'm very unhappy to see
> drivers pick and choosing what part of the contract they implement.

Sorry, didn't mean to disappoint :) Lemme look into this part more and 
will try to be more compliance with the contract in the next RFC.

Thanks,
Suravee
