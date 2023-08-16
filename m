Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A432277E63C
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 18:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344643AbjHPQUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 12:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344686AbjHPQUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 12:20:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E05D2715;
        Wed, 16 Aug 2023 09:20:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0AC+F2GWB3HvZdJBy/X69Ntqi/NxmfRGs5hpvSOhTY4kjtAQXVYhj7OLHFVNtSA+F0nUZ51ng/M9OvLJTz4TeJakOBF+uNC8XXB+Y4mhBPdkwM5zvARSSp4x+B2MUIrl4tuZ15auDzn6FTy4Lqf83aL3gbMv2GgF3mC+a19CBj8vzX5BePDesuC3Q+44Rnq4LK4CvBvefkUH4Kjr6xdTC4DHqTpeDHnuRIghiOI01QFp7iVJiMlaal8h0z1FsMI6txlAgnOSzhTAzvYkhmdQESeBalYdJXXEcnJmxSAbpvGbpUm8CNsFu0NODY0zW/FWnjDLPmCE63ZqoMd14Y4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LzNoNp8dyrcaIGW/SwIs39DbYoiq69XaZ2DJZIYs9a0=;
 b=RyZ1XBzBunQMumzA1HdH+FKXwuRN8jvb50muwLb2iXzIJJS1Ze/vmiUnEHwynl7l3ySgCUxnn1fQ50+ldYoDgPgaA5txXyAxLJaIKNSYUxX67tMMqwdEvyEI4cd8nvWNgA9maCLtSkMQvIydOW7e1YjBfZsPV8k7o3dhaJ3j+9DyPnJGESTvmO6sJisxRKo0B6REO9NsV871ygJ2Rno4OhqlQJ7tkQASUPfTm1iTwgNDfjcd84w81BdoDqVe4oufvJZDXnLBc9CmtjW0xgxKUnnSotE+8WzeAzu2W6tDuMqun581QFBpyv5h6A0e7WPK4CK6fmumDVlRjzyEhKbbZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzNoNp8dyrcaIGW/SwIs39DbYoiq69XaZ2DJZIYs9a0=;
 b=A8vASIJT1lMPPNn2i2RlQdwUogjMm7vqTGgik7pZ5oHGb0pMnXkneuhY32Ws26of/ca/DLUtOHGeXH6JvN743mYDCsBsWIyhiTDSWePraUaYrlrEX0PvLq5XxhSnSHgDcDccikFbY0ObYJ59kbz6DmtVG9S3cDVotyVYIIHaj1s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH7PR12MB6467.namprd12.prod.outlook.com (2603:10b6:510:1f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Wed, 16 Aug
 2023 16:20:10 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 16:20:10 +0000
Message-ID: <10f3159d-62ae-0e4c-8ba4-6f7819a47ecb@amd.com>
Date:   Wed, 16 Aug 2023 09:20:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Content-Language: en-US
To:     Xin Zeng <xin.zeng@intel.com>, linux-crypto@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     giovanni.cabiddu@intel.com, andriy.shevchenko@linux.intel.com,
        Yahui Cao <yahui.cao@intel.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-6-xin.zeng@intel.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230630131304.64243-6-xin.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::10) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH7PR12MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: c824da64-de18-48bb-fb8e-08db9e74a962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqaBnWAM+BmyTAO3lHtn425cCqbSfmPqt2Vuie2o/8+QjTS0DZMS8DQz+gsbOwCdPXFm9dNLdyf97PkO7BZZPZ1OCOTQC/Qdd/HNN5Vgolo5qvSAD7kmTBWAqf1tcBiBqJN7D2gOvrZ95JKAwJM0732moU5xdeEj6zBg5ifN15kPcuEFF+CutOhAne0rFzkmNcoWop6a2HV/Q81XutIlWUDm+f4tTL/QCQLg67bZfnFaog4/kPSCPd+TKrXpSBzYz4PZx3P/k+eSL3YKeExyxGm5mTxJHUyWXm+6kpIRz2RDmtVgCOGzAUd9u8MprGZ7Uo0gNyQ8El2P5k2I0mxj+6wP3GQqPOY91cgMnyz4XkNL7tHcdllRl5VmRp6JgDjZsCaBBes2WglHngE8TMZkq4htIcRNrN2ndPKHQ2LfHRDdUhO4mr3VAYB1ZDIZo8G8CzCbSPhzmqjj9WfeeckGJ9CqhxQEvxQjQDHGkRtPCbSZjzyuZLuGr1myTjQSM+LicDVjlLYu9xIoWD2I3lxKwV+HDCc75FJhv1zXfa7iwa6d3NegDWgYumOfnlMN1jBPWwY4oFFJRrE+ptYvu+KjDVpoJxOH6DE6bbC+2t3X6i/Bwkv4zm1Tv7ul8VGHru6yxd77dpHzgyKQwhDTTwK1yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(366004)(376002)(136003)(1800799009)(451199024)(186009)(316002)(66946007)(66476007)(66556008)(41300700001)(5660300002)(38100700002)(31686004)(8676002)(4326008)(8936002)(2906002)(83380400001)(26005)(478600001)(31696002)(6512007)(53546011)(6506007)(36756003)(6666004)(2616005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGZxOEV6bHplbnVUNlBqTVhTejNvVGI2ZzlMeXlqY09yaEhwc25UNG5OaVgv?=
 =?utf-8?B?WklCbFoyU3RtMmVHTmkreStQN1JHemhoeGk2cUExV2JKVjRrYUMrYXB0bGxB?=
 =?utf-8?B?eDAzV0YwZzI3cXhLQVF5Yk1mbHlQTU8vcEc2YkVvdzdrUzV6dnpoYzl3bUtk?=
 =?utf-8?B?T0Q4M1l3OTVrRTdNQ1RVV2U3T2FROTlMT3Y1N0VpWnZZZ0lIUUF5STM4NmQ4?=
 =?utf-8?B?dUNDaG1FZkxTOVVyRnNzak5IeU1RM05WWDN0eDhzNTZJbkc4OU9FWGhTZHc5?=
 =?utf-8?B?aDQwRW5xS1VuVCtCR0crTk1VZG0vU3d5MUw5MTkxRENLbDlqZitDdHJydHMy?=
 =?utf-8?B?ZWpQQW1rOC9aWmxmUGxubFU1cW1aQlNNaVF4TVdQbFJ1S0RGT05lemhFcTdT?=
 =?utf-8?B?OGdFN0UrSzZNU2N3cmEvblNHRDQ3Mk81MXVDek1MV1QwV2laNkE4WE9tRmYy?=
 =?utf-8?B?QW85dWtxL3ZvZlR5QUtIRjVMcS9vSTJLNHl3VS9BNHZPd0Z4VkorM0VxWXla?=
 =?utf-8?B?UUdYbzdiMnZlVnVVZDBQWkRDSzh0Q2hmWXRLT0RBRnBsN3Rja3l6RzVJV1l4?=
 =?utf-8?B?eC81UmNZbTdrdXBqMTFNSFlYUXRzVzd0RGJGOWlualdwd0svMmZpT1RFb0lH?=
 =?utf-8?B?S2N6VnRLZWNLZzNuU0Y0WUpUUzhnNXhZK3NBajYwajVKelVTMXlNcDFRK09L?=
 =?utf-8?B?bEZhc3VJd3dLbVNGancwbllZMUhFb0FvYVZLK0J1aVpWdWVxZ1UxbzRDUHE5?=
 =?utf-8?B?ck9hTmhDNFIyRUNTN1lxZkpIQ0lvUEdFdnYxYXVzWk9QSitNVjd4T2RYb2hq?=
 =?utf-8?B?QWZPdWZHZ25wajRpTXNnN0wwTklqWE51NU96dUlLOFlYa1crYklPMGpNSE9Q?=
 =?utf-8?B?TVBFRGlURk1zUXZqSllrc2lHOXNVc0tmUkxnZGdJV1BhbGtsMS8rd0xlaU4v?=
 =?utf-8?B?QU1HcmNnSllJa2krcWZ2V0lNV0dyRlpTQ0pCWUlFY2ZWaUgvclBoVVJJZnA3?=
 =?utf-8?B?R1pUbktnTDFtMGxkZUtzQkpkS1ZRYTczQzZ4bytQTUxNaXNZSnoxemZtQVpN?=
 =?utf-8?B?a2ZsNVg4NmRvMjQ5c3RNRG5ta0xCZUJtZFIzN0hPSjJJN0JQTXM4N1A1NERQ?=
 =?utf-8?B?Vlo1V2J3MTdVdTdJTmdmLzY2T2FObTM0SkE2R2duM2ZlMWk0SUhRT3crbHVl?=
 =?utf-8?B?NmJzTDErNjFTL2hYc3BtanQrZHc0ZU14Mnlva0hOY1VjaWhncXU0MmhBQm85?=
 =?utf-8?B?MVJ5K2RRNEw3QmwxR2p1eE5LeWR2T3Nib0JTWEMrdnlEaVIzL0tpbWoxVVFy?=
 =?utf-8?B?S251cTBHblg4TUY0bS80M2FIR0pRYTdiblM0WmFNRWRJMFZZZmEyRnI1MWtO?=
 =?utf-8?B?VHFzQ25jVGlnMjR6ZVF1TUh1M1M5WXNINWx6QmYyM08zYVRkbFN6NkNmdlZ4?=
 =?utf-8?B?WGVSRXZpcitYS1FkR3NocEtXdGlPUmZXT25zOEQ4NVk4RW9BNXE1N3FJcjhI?=
 =?utf-8?B?d3FwbGI1cXA1N2VjVWl6YVp0QXBnKzE2Y2U3NlBiSzhiclJIWHkyYU1QU20x?=
 =?utf-8?B?alBGWkpKbGlrTUlkTXFVV2JSQmE5R2R1dUJOaWRIM3pDOUJGUndaeE9pSllV?=
 =?utf-8?B?MEhDSjM0TWNzM2FLVWZsQS9EZ050VlFQVC9WbjR2eFhaYWtLZUtXSjdLOWhp?=
 =?utf-8?B?b0xvWXgxOTFkWkNSVi82NHFhQUVPUVIvK0Zsa2VDSy93b2taTmJXYUE3am50?=
 =?utf-8?B?TDc0cUpXYUhSKy9zdEVKemFiWHpKM2cvcldwQ1FjdXZaUXZ2L3lKRERrbDY0?=
 =?utf-8?B?YVc1bmIwYUN4YW1COEw5bDdtVytMTnBzQnl1dzlkYVV1QVB1a3FmREQzVkhF?=
 =?utf-8?B?M0NKSWNPSEdXZzBSQ0swUGlwNVlkbmJpbXRUSXBsR3gvY0VIWE9BQktreUl1?=
 =?utf-8?B?bG12VmVrVGtubFRBQmdJNlhES2dkQ01ncDQrb3hBNEdNbFhNVFB2UnhmRWo2?=
 =?utf-8?B?RnlrdkRheXY5UTFUWjN6cVFKQ0F3aitya0RNQ2lKV2NMQ1N4aE5ub2hhSjZq?=
 =?utf-8?B?TG1HYWVVTVBQWU43QVVUTTl6ZmRYalliQWQ1cllreWhzUVprN3FsS1h4NWFV?=
 =?utf-8?Q?kx03eAr/r0Ldy83X7+bKFNoFl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c824da64-de18-48bb-fb8e-08db9e74a962
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 16:20:09.9765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orFm5uR8YRJs/6uQpKhCvWYwh2VBMufjvaAMCPMJA3DJvCjWioG2mbBwlQ2FtoqCDZ8dAJ10UjSAGIDpjq024Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6467
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/2023 6:13 AM, Xin Zeng wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> Add vfio pci driver for Intel QAT VF devices.
> 
> This driver uses vfio_pci_core to register to the VFIO subsystem. It
> acts as a vfio agent and interacts with the QAT PF driver to implement
> VF live migration.
> 
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> ---
>   drivers/vfio/pci/Kconfig                 |   2 +
>   drivers/vfio/pci/Makefile                |   1 +
>   drivers/vfio/pci/qat/Kconfig             |  13 +
>   drivers/vfio/pci/qat/Makefile            |   4 +
>   drivers/vfio/pci/qat/qat_vfio_pci_main.c | 518 +++++++++++++++++++++++
>   5 files changed, 538 insertions(+)
>   create mode 100644 drivers/vfio/pci/qat/Kconfig
>   create mode 100644 drivers/vfio/pci/qat/Makefile
>   create mode 100644 drivers/vfio/pci/qat/qat_vfio_pci_main.c
> 

[...]

> +
> +static int
> +qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct qat_vf_core_device *qat_vdev;
> +       int ret;
> +
> +       qat_vdev = vfio_alloc_device(qat_vf_core_device, core_device.vdev, dev, &qat_vf_pci_ops);
> +       if (IS_ERR(qat_vdev))
> +               return PTR_ERR(qat_vdev);
> +
> +       qat_vdev->vf_id = pci_iov_vf_id(pdev);
> +       qat_vdev->parent = pdev->physfn;
> +       if (!qat_vdev->parent || qat_vdev->vf_id < 0)
> +               return -EINVAL;

Since vfio_alloc_device() was successful you need to call 
vfio_put_device() in this error case as well.

> +
> +       pci_set_drvdata(pdev, &qat_vdev->core_device);
> +       ret = vfio_pci_core_register_device(&qat_vdev->core_device);
> +       if (ret)
> +               goto out_put_device;
> +
> +       return 0;
> +
> +out_put_device:
> +       vfio_put_device(&qat_vdev->core_device.vdev);
> +       return ret;
> +}
> +
> +static struct qat_vf_core_device *qat_vf_drvdata(struct pci_dev *pdev)
> +{
> +       struct vfio_pci_core_device *core_device = pci_get_drvdata(pdev);
> +
> +       return container_of(core_device, struct qat_vf_core_device, core_device);
> +}
> +
> +static void qat_vf_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +       struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
> +
> +       vfio_pci_core_unregister_device(&qat_vdev->core_device);
> +       vfio_put_device(&qat_vdev->core_device.vdev);
> +}
> +
> +static const struct pci_device_id qat_vf_vfio_pci_table[] = {
> +       /* Intel QAT GEN4 4xxx VF device */
> +       { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4941) },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
> +
> +static struct pci_driver qat_vf_vfio_pci_driver = {
> +       .name = "qat_vfio_pci",
> +       .id_table = qat_vf_vfio_pci_table,
> +       .probe = qat_vf_vfio_pci_probe,
> +       .remove = qat_vf_vfio_pci_remove,
> +       .driver_managed_dma = true,
> +};
> +module_pci_driver(qat_vf_vfio_pci_driver)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration support for Intel(R) QAT device family");
> --
> 2.18.2
> 
