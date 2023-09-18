Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319AE7A5141
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjIRRtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjIRRtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:49:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0068BFB;
        Mon, 18 Sep 2023 10:49:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0hOXHW6Wo00BW/0zBJNBsQUPkS5GzbG56VCyNt/z6Krc+NKA+J9Qayriu6Ev4V/l/s4JuRaTrmo7Ax6MM1eEGmfB4zCmRkjNNWXQL4wC5GWZkD2bhCksBZ5kkFls10/atw99gkxu8Q85ZZQhTvQdKfXV2/HgTaQNChOSHQQlpyP8hS/s7vbbKENurWjeFVY/MLZcmAnZXdpZGpmQ1CauArPyYt2OKjbqhJj/cGheV/pTEmUorhBSigC0Jj8S7BsTdESprdm85/QEi3sOb1ApBJK4/+uwdqj60rS3OowB++8m9q27fAp5VxMdHakkCBEE/poN6fKFqnWrnqzdYs7gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGejlX7abNao2bGUK6xmmZRgOfphhurdzL91j19YSDQ=;
 b=O1ZtLvqfc38Ze2nfuu56utLDgwMWzmw2MWUP8I61jtpPTYR2A0A4qap5tWDOAnyfyMEx2UEbTCtk9EC8eNkV4k6Ia+fgLr8xS0F3zlJO/R+MU7mHsFLXsSvc92G4H/F8Cc3V8+pRhF2waK2IvcnsG26RgkBSLNuO/uuosyQT0wA3W2wh556t3aa3SX/SnTCbRg5Iqp8xlUyJZ/m+b4noBZ2V3DR9vYSCP0hSUbGn64D5ibPtbtIxlWEjPWeeS/buW046SH22dMSiCTaHPwHvkKsPWUpReS1omeOmio7B3xCyP+8msV5cKxLcZlhcPB9oNHxFGxpy7Mw90NL08bUJwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGejlX7abNao2bGUK6xmmZRgOfphhurdzL91j19YSDQ=;
 b=rdjwP5b6kE6HN5qne1zZmX7IPTlsD99tw4JAW3RHg9blSWkYYnrvTvyTTu5AyZNfWGLFGSmgNJzYnLxO0iJIi26jrzCqgYiMYqBIk+O3QAImY0NkETNueZmhINHSxKrcED4F9KdN0chcWBqg5Elm5Kx2CLiQJqoRgiOJ69MRoEc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH2PR12MB4890.namprd12.prod.outlook.com (2603:10b6:610:63::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.27; Mon, 18 Sep 2023 17:48:58 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::5c9:9a26:e051:ddd2]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::5c9:9a26:e051:ddd2%7]) with mapi id 15.20.6792.020; Mon, 18 Sep 2023
 17:48:58 +0000
Message-ID: <acfa5d59-242b-4b31-a3ef-b4163972f26b@amd.com>
Date:   Mon, 18 Sep 2023 10:48:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, tglx@linutronix.de, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca>
Content-Language: en-US
From:   "Nelson, Shannon" <shannon.nelson@amd.com>
In-Reply-To: <20230918141705.GE13795@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR15CA0016.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::26) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH2PR12MB4890:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e10ab84-d0fd-4dd9-ffef-08dbb86f88d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05dXcq2rYyUujSfpadsNenS8ILdsU/e9aFfPmMF43P3N3wL7qn0bp7L8BEouS2kuPYqR5Ody7x6Gg+U7HIkiieylhbqxnF58M5YaNAJu8BGk63h8bWoqksRGNTYDbJOoXKJV2LukIBOj9xqFJoUo0UCUO2MAmhpmUlKNAW17R+wszYAZcLeqx3+4csvWarOOI707c6SIf18YCZ3OZCGBHAdMjgSopDCsRvb8Ekg8fhqHP/1Q0NI4EHo+V4cleThG7HNnY76+HGl5c3xz6EN5H0vMcbcMcsBXlQb2prC8892pmOus2uyC3pl1kgCQ7wjFoHzdvR1/Rb0EGfURDxTy6tnL/dfANUVInrxw6IbkepwmPLN7guVPcKr1OtpkPInTQfuWnNQ8YRA063iviTR96tknkv8vVu8rzbF3fJJsIE4Ti53ckI3cbCLUn4AE1iEy9PCi0rCgQmAFvx3Ca/7mH2Uj55+0vM5O3EenkPjENOXE8LrtzjQNG2VfM5MfnJtAQVhdMUtmcv95UBO9o0eEsAG1H/wrlFeZHQfPG3azegNqTJRLAFf5w/+I2LI4KB1G9Wo8+Y/vj9Nchf9Cel4SACie3qyTzoUMlE0sOB/jzDSSUujOFucI1MoT9k74wYM1oIsIOdlYbUFb+qWvn17YUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(186009)(1800799009)(451199024)(2616005)(26005)(6506007)(6486002)(53546011)(6512007)(36756003)(86362001)(31696002)(38100700002)(83380400001)(5660300002)(478600001)(41300700001)(6916009)(66946007)(66556008)(66476007)(316002)(8676002)(8936002)(31686004)(4326008)(6666004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzV6b3U2Zi9BRmlGQlZhaWdwaDhsdHM0c3BVd3JwOFdjUFJuNG9qR0x3dGR6?=
 =?utf-8?B?bXowNEpaSzgrSk1TTXM2eDR5Q2NCZHhQMzIzYk5YZ0lSODNWWklGekFacWxp?=
 =?utf-8?B?TDhvOHFnM2N5dnJlL1pjbUlLcUtONkNwTzVDUTY5dTBvYlpzR3JHMFdsSDZp?=
 =?utf-8?B?VVkxM2JzNWFzditubUltK3E3RjdvZ0wvSkdWNG8rK2IyS2poYlAxd2hSWmJl?=
 =?utf-8?B?MFhpczdMQ1dybERWVFM0eEtvZmlmdnBqS3l5amdXVEVENk5WWm9NSHp3SldY?=
 =?utf-8?B?TW5weUZhNk5IRmJxMWJQTnNEUGhOL3VDaDhZc0xIUkZGQnZ6SDVOc3JHZURz?=
 =?utf-8?B?dmNrUHNMSnVUOVY0ZkRzUC8zektYbGNSSjRMSlowbHNiTU5kMEJUSlI1aWh3?=
 =?utf-8?B?NEhPS2FjaXZmQjl1TldobDVNUitucXhwV3lZT1d4VFpEWGZ5S3AwVlg1YitY?=
 =?utf-8?B?a3NUQW9JSzFIRlJKb1kzVDluY0FyOWY5NnlMUmFKOFV3MFhxekd3ZGQzT2Qx?=
 =?utf-8?B?NWx2V3k0ZytEOGJvdHNYWHVEcW1HeDZBZFhYVGRaUjZENGR0a2RwYUxzOVFG?=
 =?utf-8?B?SXpZN1F6eDdPN2U2LzFRczlJOFZ0eXgzRWt3cklFQ3JQdUExQ1RwVGFFaG0y?=
 =?utf-8?B?ODNhNm1WWGh4OXE3bGdBWTljVkhLSkRKS1R3MThMbFJDbGduY3JRTkF0aFdF?=
 =?utf-8?B?S1VqK1NBL3ZvZnNscU53bGZnVWlTU24xUGxERlRORnVyN1FCOUFReGlram1Z?=
 =?utf-8?B?Yk85aDA1c0p2VnVtdmNiNTdjMklYdnBDKzUvdjBKRFQ1UVFuR3QwTEs1VWxa?=
 =?utf-8?B?OWtQOFY4Q2ovU2I3em9uT0ZlRnh1dmdpazhZOG1TVGMzYWdmRnhzb205bGtn?=
 =?utf-8?B?RlRHdmVLSkpWUC8rdCtHeWxVeXp3aGtCOUlXQ0NvSzcwUmEyV08xVDdJRjd1?=
 =?utf-8?B?UFhjNDF3RW02L3dhZEZoanRwZHN3TlFJS05adHJnbDdvWUxrNVJhajlSR2RG?=
 =?utf-8?B?aEp6bWRHaU1ybTJhYWlqKzR1clBzUktYK2ozUXI4TERDSlFOT2FsaGNVSjBN?=
 =?utf-8?B?L0hFbTVrYTNwVTRwblpWR3hZb3pabVVoMHp6eXNlNnVEcFVvWUdOR28yUkxs?=
 =?utf-8?B?aEdSZTFKNldzVEdDT3QweHZIUW8zVWZHSlNSbFlCVmROTkV3OHh4ck5UMnVW?=
 =?utf-8?B?YklvVCtWZVlRUmZFdzJGelYzdmJsNVZHcEQ0bkdGWTdDbkwzQjU3bmJtQStG?=
 =?utf-8?B?eGdERWJFeWRBdlFRdE5oUUFiK3oxZ1k5bVZrQW90eTAySXRSd1dQT0k1dWJG?=
 =?utf-8?B?ZGQyMVJJUEZ2MitES25VQzMzUkkrUXFJbThBNEg2SzFKbWNNWXF5NUdnaU9W?=
 =?utf-8?B?T3UxUDBiQTUwU21RQ3FZR2Z1ejZEZzFMK0Q5SUFiZEdyLzBXaThUOTV1RFM1?=
 =?utf-8?B?VDM0b29ZczFibzhVVDBJaDNWakR4WnM0aVFybUJ0cVBod2R4YVJkQitFcmVa?=
 =?utf-8?B?dElrNGw2MXFsSUE1QyswVHZYVFFXcVZRQ05lbStpeXBrUG0yc2JmZXRjYjlF?=
 =?utf-8?B?Kzc1L2Nuck4rR3BQMlQyeGJBbitEVGxwbGxuS2I0MStqaXVUQmxCUUF2SjVW?=
 =?utf-8?B?Y2t5OG92UnF3UTJuVWx3T1JCZWttZEd6MENzdkJsUEZwcVVLc3VkQkI2UWMx?=
 =?utf-8?B?OG5UaGp6NHl0N2QxVUs5TXYwd01YNDZuTGxVVEYzTlFHNjdzamJFUmpmdlhR?=
 =?utf-8?B?dlRkeVZjY0JFaEN6bWIrSW9Tb3VENGc1UTZUME9IS01mN09ZTGRyNXk1WmRC?=
 =?utf-8?B?bUg1b21vTnpleFh1Qlo4NnUrcEhRTkJhUzVXM1l4Y2pFUno3VE9aSGwzWWJ4?=
 =?utf-8?B?SjEvSlg0MGpxN29xUnZqZVE1a0V3M3pFY3hIS05rbnY3aml5d1BzUEU3bmxv?=
 =?utf-8?B?L2hQbUNvWkJ3QmxGSDIyRlQwY0tTV0pyRThXWHhoeTRSdnA1NGhVTFZybXdi?=
 =?utf-8?B?L0UrZGFoK1h3Z2ZqeTFQY05ONndVZXllbEExQUhWRmxEWldwTG1UTWQ2L0dH?=
 =?utf-8?B?WW5QSVNiZ3paVFJPOWRiZkQ5NU44bmt4RXVpTTBNYm8wdjAvczVkZWE5SzdI?=
 =?utf-8?Q?j/v5sQbrFqFYYag7/t2KJHDkV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e10ab84-d0fd-4dd9-ffef-08dbb86f88d3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 17:48:58.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcq3thksHoblEsp5k5mBS1yECQnAK8yM0ulD/GrggljD7/N9+QtuZCdlX/ra4/f7sa+a/gsZyyBEflELYoUnYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4890
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/18/2023 7:17 AM, Jason Gunthorpe wrote:
> 
> On Thu, Sep 14, 2023 at 12:14:06PM -0700, Shannon Nelson wrote:
>> The new MSI dynamic allocation machinery is great for making the irq
>> management more flexible.  It includes caching information about the
>> MSI domain which gets reused on each new open of a VFIO fd.  However,
>> this causes an issue when the underlying hardware has flexible MSI-x
>> configurations, as a changed configuration doesn't get seen between
>> new opens, and is only refreshed between PCI unbind/bind cycles.
>>
>> In our device we can change the per-VF MSI-x resource allocation
>> without the need for rebooting or function reset.  For example,
>>
>>    1. Initial power up and kernel boot:
>>        # lspci -s 2e:00.1 -vv | grep MSI-X
>>                Capabilities: [a0] MSI-X: Enable+ Count=8 Masked-
>>
>>    2. Device VF configuration change happens with no reset
> 
> Is this an out of tree driver problem?

No, not an out-of-tree driver, this is the vfio pci core.

> 
> The intree way to alter the MSI configuration is via
> sriov_set_msix_vec_count, and there is only one in-tree driver that
> uses it right now.
> 
> If something is going wrong here it should be fixed in the
> sriov_set_msix_vec_count() machinery, possibly in the pci core to
> synchronize the msi_domain view of the world.
> 
> Jason

The sriov_set_msix_vec_count method assumes
  (a) the unbind/bind cycle on the VF, and
  (b) VF MSIx count change configured from the host
neither of which are the case in our situation.

In our case, the VF device's msix count value found in PCI config space 
is changed by device configuration management outside of the baremetal 
host and read by the QEMU instance when it starts up, and then read by 
the vfio PCI core when QEMU requests the first IRQ.  The core code 
enables the msix range on first IRQ request, and disables it when the 
vfio fd is closed.  It creates the msi_domain on the first call if it 
doesn't exist, but it does not remove the msi_domain when the irqs are 
disabled.

The IRQ request call trace looks like:
QEMU: vfio_msix_vector_do_use->ioctl()
   (driver.vfio_device_ops.ioctl = vfio_pci_core_ioctl)
   vfio_pci_core_ioctl
     vfio_pci_ioctl_set_irqs
       vfio_pci_set_irqs_ioctl
         vfio_pci_set_msi_trigger
           vfio_msi_enable
             pci_alloc_irq_vectors
               pci_alloc_irq_vectors_affinity
                 __pci_enable_msix_range
                   pci_setup_msix_device_domain
                         return if msi_domain exists
                     pci_create_device_domain
                       msi_create_device_irq_domain
                         __msi_create_irq_domain - sets info->hwsize
		  msi_capability_init
		    msi_setup_msi_desc
		      msi_insert_msi_desc
                         msi_domain_insert_msi_desc
                           msi_insert_desc
			    fail if index >= hwsize

On close of the vfio fd, the trace is:
QEMU: close()
   driver.vfio_device_ops.close
     vfio_pci_core_close_device
       vfio_pci_core_disable
         vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
				VFIO_IRQ_SET_ACTION_TRIGGER,
				vdev->irq_type, 0, 0, NULL);
           vfio_pci_set_msi_trigger
             vfio_msi_disable
               pci_free_irq_vectors

The msix vectors are freed, but the msi_domain is not, and the 
msi_domain holds the MSIx count that it read when it was created.  If 
the device's MSIx count is increased, the next QEMU session will see the 
new number in PCI config space and try to use that new larger number, 
but the msi_domain is still using the smaller hwsize and the QEMU IRQ 
setup fails in msi_insert_desc().

This patch adds a msi_remove_device_irq_domain() call when the irqs are 
disabled in order to force a new read on the next IRQ allocation cycle. 
This is limited to only the vfio use of the msi_domain.

I suppose we could add this to the trailing end of callbacks in our own 
driver, but this looks more like a generic vfio/msi issue than a driver 
specific thing.

The other possibility is to force the user to always do a bind cycle 
between QEMU sessions using the VF.  This seems to be unnecessary 
overhead and was not necessary when using the v6.1 kernel.  To the user, 
this looks like a regression - this is how it was reported to me.

sln
