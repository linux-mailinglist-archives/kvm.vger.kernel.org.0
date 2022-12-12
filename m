Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6707364A3B7
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 15:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiLLOtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 09:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLLOtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 09:49:32 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F213D02;
        Mon, 12 Dec 2022 06:49:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1tMzTSeiVn8dDsiH+leGXPR0JOSOVI1d17fMyoRVozXXYQprKW8GCmgaN/RSbS2nYVYpOE+BHFIkT9WVpCA6emj76o9w5t7F8fz97vyplaAcB5+JvMzca7JBzuPEK7nS62XvrjtyFNcCZR/7iodgehWN4sslFzbBwJ5yC3lui1/EbdNuCXKUVuWhS0rxzi555UYm7BlbpdKiYHQDyoo5I1C1pl+lXizyoSR+Y5FjaxVy8xhTBTglUvubsNzSH7nPJ8Fr0Q8h3FRqBHydJFgrYkDaDZeGSp/h4cgWjkfLVg3MjW52jPSm//fzGBqvXFUPvotdLDJY+WxiHjSHYes5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UVND6nMICg84qUkr/FXv9fXh4J9CCfjx3I7HFJ7H6w=;
 b=YzZvYng54kPLpPn7VTHs4N6y6PDIR/Q6DcnwN7/TUdMEnMQW1GOQKHlbSVTr4fcMp3nxhOJzF0Jk0mL53gZJCMKeuohOOzDkmeiYRtWSRYwn9tWRia/XcoyIWvlWbo+Yi7O7PUBJRcRIQuNtL/zEG2WdjT+CZfsFix6mtvR3eLuU3WTSyJxjBN+cNphRhQCySZ25G0UumFGZgqmT87DVYk0q97siAyJlJ0UvFC+2Ls1WGuJpNs0nth8F6xR4Uo4x3OD73VY+nY4Zneonf4oXjp9c5uFfltvmnfVTxM7YvWIiZQzXtUU7gGqGNLtODs2CZRiGyZ0q6AngbmjvgkWJ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UVND6nMICg84qUkr/FXv9fXh4J9CCfjx3I7HFJ7H6w=;
 b=gPwQLrHFitWd0MlDfaw1I1G79mZwPg1aoM/+PpTNIxV84V0iDQRmjrXwH9rLnxRObiCQqtPNQzg2H9W546xu3MkLP3hkHW8zIUafAKRE83m4uyeA8W9ZdtXQ/bHJvDqgkFlGdkVKv7Xzh74a0biS8GPgOkpMtiqEDFTntVcP3qmnXOIPxMfsKWCMwpzI3NbvAGWVkMKTfArXpN1qiY3KlipII7R3TngkwqtFk5MDyi2tMNt0Gj0bZNPVMaD0OiqCk1GxTxdCKxpfpI51S37zP5jmW08Bcos4g078OzTf/dM7Cj6fnr8USn60MW1dP+bqRpbOzcdnDNu4A6KbInYxMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by MW4PR12MB7360.namprd12.prod.outlook.com (2603:10b6:303:22b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 14:49:30 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 14:49:30 +0000
Message-ID: <588a8c42-b597-1c9b-f7d3-2ac10ead7ac2@nvidia.com>
Date:   Mon, 12 Dec 2022 16:49:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Lei Rao <lei.rao@intel.com>,
        kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Oren Duer <oren@nvidia.com>
References: <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de>
 <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de>
 <Y5CsH5PqMYAWYatw@ziepe.ca> <20221207163857.GB2010@lst.de>
 <Y5DOAKArjyfb6Mcz@ziepe.ca> <20221207183333.GA7049@lst.de>
 <Y5DyorZJPdtN5WcX@ziepe.ca> <b2ade627-0abb-08a0-c28b-2bf8eb8e4973@nvidia.com>
 <20221212075541.GC11162@lst.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20221212075541.GC11162@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0120.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::13) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|MW4PR12MB7360:EE_
X-MS-Office365-Filtering-Correlation-Id: 14675c9c-def5-4fec-8bf5-08dadc5012b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: myolgMUUOodi5FLGwHOisMtdY06B1HWqDM7C2hK25NBcG1HZbFOXIiHYp325wWAVB8SjKgm9daWyh/dziAAqGaBWsE6sge5FyJrd71kQfrVMWtyXHIePkJrQVS7zDTn4El4a+Ig8mF6EUgymPiUBgbN8JQ66kYLMcOtgOaHcsLIzgV0fXB5HTHARX6OryMxZDWQjLlKeIWWPXsY6e0udcN5IK6/SFbbyXoSLMmhl/LR85/CKISsi/AfnGWDsRwHop3y51t3vLiI7CeYW14KP6A3D5rc/qmmjLmHomMkMCetOI7yIYHk2EZLSV4OY7/MltVE+6dN9suw69pPZBfE+eUs5+ICBy6QUff7y0qOdhQ6L0leRKiUTYNtEGahiDie498x6yLYryykIgnGimtuhfQ1j34j+3o77Hw6p1Ui8fA9PxCQ8IE8zN7LVNMx3usAbdJ/NDP/9Q4nnXyhwqOB7J6c0gjL+VJmSG93p9EKvfgyqc5L15g3QdsQJq8Q9dziWeGgU53rbldhwWlnkj+2Gnuiw6K40DE6Xd33tSkVJBBV/Bm2tfbDxOsmIfBCFMdkByl39oZpIPk0+mPlUtRad4UW77u0otsvtqoD/mxjewKSTdz+aeLD4vy5POHsCODeWpj3d9UwHnjIJLYqjTQUpmL3BzNMVwCvxcRd1I78kd0JGmOQl3ws5TZdxc0MyEDC57IRNspAavcRbJERVAvXqSKABb4vJtliim29ShUIypicnAnQAaucVyXMt7gz5rFv0uMlaszgZsGoCWJLJ43pCNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(31686004)(38100700002)(2906002)(478600001)(66476007)(7416002)(5660300002)(6666004)(31696002)(66556008)(53546011)(107886003)(41300700001)(36756003)(4326008)(8676002)(26005)(6506007)(8936002)(86362001)(6512007)(186003)(6486002)(83380400001)(316002)(54906003)(6916009)(2616005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTRmbkdHajllUnRVcWxXK2FiRkZ2ZkMrMkdaUXNnUGdxS2prZWFzRnZibWlt?=
 =?utf-8?B?QW1aRVAyME9vOGpDbXdkOGZwY2I5REpSN3NYZCs3VGpPVzU1QXlubVhLTHFi?=
 =?utf-8?B?RGdaK1pTYnFGZy9Dc3o2dFZ0dDZlR1ZvYVF1RXIzaDQzZTU0Q2U5NHFla3RG?=
 =?utf-8?B?Q0VEZUNHaDBBSFAvWFA5OEJEQ2dQNmtPNFNFeGREOWNJUUV6U2ljMXUvZ3Rn?=
 =?utf-8?B?R0VoVkwxMHNhcGZhRkRUbWZWMGlFR28wQVVsc0lCZ1dqZGxYeWQ3SHl1dFcv?=
 =?utf-8?B?M3dqQVZ0K0pXL2l6ZzdPbDVvblVudE9KTytGeis4UHFzUldpcWRGTnFab2t3?=
 =?utf-8?B?OU5GMkF0Q1F0ajM4Y3ZUOXhPY2xrd05OYURrZ1Zqb2xEb3FiZGpjYUh3cktN?=
 =?utf-8?B?a2lPZ05KZEJSdTg2cFExZlZZN2tXMG9Vc200cXFUTC9VR2V2b1REUW1sek1v?=
 =?utf-8?B?aWhreFRKdVNqL0M0dFgzei81dXVGM2NoRnRna3dFNnh3YnFtRm4vQnhuc0xJ?=
 =?utf-8?B?R1d6ZnNkeWhMc2srL1FlejU5d1g3eU9BTEpvVTc4dENyaDZjZXFCVStuVjZz?=
 =?utf-8?B?QlQxWEdaTlRJUkFPUEtjNDRURHp6OFJIUnJwTGUzeS9UQ0p0WkZZZEdaTGVr?=
 =?utf-8?B?NUFuNEQ1cGloMCt5NDJwR3p6NTMyTDRJbDNEV1dqaTg2ZFYvZ21hTnd6cTMw?=
 =?utf-8?B?NS9VUFNoNFBoYkZPVFlhU3lFUkphZ2lCYVpHNFJkTnpSUXZmOFE1cUlSUG9V?=
 =?utf-8?B?WkRaNEdPcWZ4Q0EyRXhSU2tQaENuZUtpMzQ4N2hHWUZaRm1ZMUNaSEpQbHpN?=
 =?utf-8?B?ZGNUUjJNN3dOZ0pDRFRreVdkcVUrUHh0U3ZLQU9YL2xtOGpDNWN3K2xqQkgz?=
 =?utf-8?B?SVB1UmY3SkI1M3ZQbnJXeEM1OXFMN2FMaTdRV2hEWDVtKzdCMVpPSmsrMElM?=
 =?utf-8?B?M3hydTQ2OFFOY09STUdkY1c0M0kzMVU3RzNlOHV4Wjc1MU1NTkJDYzU5Zmpw?=
 =?utf-8?B?MWRYckRBWHZKWXZTa2owQlgxNEVmcEw5WTRVUkNuYWM5MzJ1Sm03VU1wTURp?=
 =?utf-8?B?eU5JMGVjUGl0ZTUxcktwYXlIUEppZjd1R09XRDJybDBPMHhqcFFiWUF0NFFk?=
 =?utf-8?B?ZG93U0V6UU13T0k3UFpTT2Q3bFdwSzQ1YTB1c203b25aOGdBYlFVMUE5Y2ZT?=
 =?utf-8?B?SWhNdlYvSlUvQ2hEbHBzZ3owVTBwRElacXlVQkVkNHBZQ0dzendCaE1hcHk2?=
 =?utf-8?B?YnZmTlBidjIydWhPSFVCcWNucjZIYy9qRjZTc0ZEb2FQbE5DWG1JOWdTMmV2?=
 =?utf-8?B?NEpuNUJvd1JCVG9wbEd5ZEpJc0pEWkttYkc5ZmozVG1qcmtuME5lQzhjbWVN?=
 =?utf-8?B?S1dQSHExSlI3a3FaMGh6bkFwUWJHaDFSWGFZeU8weHB5YTZJYkptUktqSUx1?=
 =?utf-8?B?T0MrK201UWVtYjY3Vm9DbHZnVjFzM1JDaERMRTczMkZVSTVaeG1JYXlOdVRZ?=
 =?utf-8?B?eWFnSFBCMlpIZ2lzd2NPeG5WYlBkOU0vbmtsZUdkaXdvNU5sQkFMb3RJVUhz?=
 =?utf-8?B?ejhiT3dURjNDUkgrbHo3VG9Xd2JYZWdxRnc2MFVjVGdTeSt0bkpKclVlNGRj?=
 =?utf-8?B?SFI2OWVOVXZXelpGcHFCVGhleTA0MVNuWTI3NnMwdElLa3JFUGRpVktOMWNF?=
 =?utf-8?B?QlpyYzRGV2JhbW9SZXNDRzhUKzRPZmt1ZytlZDUxeUpkQXQrYmY2Vi9MOTRj?=
 =?utf-8?B?dkZFa3NpVWNNeGNiNkJCZi8zdFdJdUIvTXh3d3VDaGZVa1F0S29ueVlVR1ZE?=
 =?utf-8?B?QThPWlc2QlY1bzFZVlhhOUNUT3I5dGN1TjR3VDBqNUtoNnZRWmozeWpYSjV1?=
 =?utf-8?B?cW9ubU9ZZ2haajg2Z3JGVUVzSXhOYUNJelp4TW1lK0xZTlBRd2VmUW05S09Y?=
 =?utf-8?B?emVvTzhkN0tPQUw5dENJWEcxd2NkKzVienQwaTNtd2Jib1FXWTYwNlBiVU02?=
 =?utf-8?B?VURQdmZoTnpkTzNXODBDbERSeVhrVmpaVEJxYUNIcEZSR0ZpTy9XbmhKekhP?=
 =?utf-8?B?cVpjNS9aSnBJZ1VEQTBkZ2liTHRrRGtBVjIzeGlYdmlFN05nZkE3NXBLekcy?=
 =?utf-8?Q?T26g9vWYv7I9kKQQlpQsI/uZ8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14675c9c-def5-4fec-8bf5-08dadc5012b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 14:49:29.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eh1zXKoL8+d6Pl3x1IudSa4lf5l2edjrv2MBPBes+pT4jIsxviGvyDMmuBsHszDHGOCb3xvTMX8DZcoRNJPGUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7360
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/12/2022 9:55 AM, Christoph Hellwig wrote:
> On Sun, Dec 11, 2022 at 01:39:37PM +0200, Max Gurtovoy wrote:
>> 1. Need to define a concept of a "virtual subsystem". A primary controller
>> will be able to create a virtual subsystem. Inside this subsystem the
>> primary controller will be the master ("the controlling") of the migration
>> process. It will also be able to add secondary controllers to this virtual
>> subsystem and assign "virtual controller ID" to it.
>> something like:
>> - nvme virtual_subsys_create --dev=/dev/nvme1 --virtual_nqn="my_v_nqn_1"
>> --dev_vcid = 1
>> - nvme virtual_subsys_add --dev=/dev/nvme1 --virtual_nqn="my_v_nqn_1"
>> --secondary_dev=/dev/nvme2 --secondary_dev_vcid=20
> Yes. Note that there is a bit more state than just the NQN.  You also
> need at least a serial number, and also probably a different vendor
> ID (the PCI vendor ID that is also mirror in Identify Controller and
> the IEEE OUI), and new unique namespace identifier.

Yes for sure there is more bits we should consider.

I wanted to describe the high level.

I think that we can maybe say the when a secondary function is moved to 
a virtual subsystem its feature set of the virtual ctrl is narrowed to 
mandatory NVMe features set.
And we'll provide an API to set/extend it's feature set to a maximum of 
the feature set that the original ctrl of the secondary function had.
Then the sys admin will configure the virtual ctrl in both src/dst hosts.

The high level idea is to have a programmable way to set the features of 
a virtual controller inside a virtual subsystem that is also programmable.

