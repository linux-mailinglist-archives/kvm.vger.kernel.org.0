Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5017C0142
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjJJQJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjJJQJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:09:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F1EB6
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:09:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbIILN+8Qgn3NjlnGKQQ1csrVVdyWWzwm/xWG8mSo4wTs3ZwMCrdLXXgvDUOiDQ8SyfZqvOvZhn1TE93id8/Vl3gge7ovjqvH2ZZA41c/UNhWPbUIeL8oG/lU0DSn7K9aXPwoW61kf+7y55ik64c7WPp8RbP9z4TfrdizaPcWTPMIoP1mgqX03Kkmng8JGRoGGexz8cMVcsTy8sQahPgPFv6NclPjlMJCOVtkuaoRX/UjggIzP2KWbe7jUl1Wr6QkvalHF5I9g4nfM0a43JXNOWx1c+0voVZQujZGFu2/87lMWPNiSuSIrSzNxFYSA23x304zh8OgNOLv/MNx6diuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4b5TLYVRx31fXlYEAb4BE403qP8kBxVWZki7gpf7ofY=;
 b=Q53uAerDI8uyoN8tgrtGjqta2avyd9NtmkDYOwpvKU30VM0Wi3gTGhtZtwc2OAE9yVqwQyRjM6q7rsAFE/ExAB82U1HlzUZeHdsLL4/sEOTCdwewPtrC9NJPhePtDrPWzo7hSv8k6+BvrRDr8H4hRb6q0VgGuNzhqV3kcViMX1ZA+zlLLZdbdG6zsPeFc6ezu2RfN9OKHfRvmqOuNKE0mhj4pD0rFsVnFTrxqEOGaX3YSUlT06E13KcSPcqlqvGm3+Gvdemi0EzGra26GmI8LwRqeNZ12IoimwI9bzBE+z5QZuz+TYS5p2DVU/BjSjn/ZmWkmD/uaK+2gIfr98Rkvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4b5TLYVRx31fXlYEAb4BE403qP8kBxVWZki7gpf7ofY=;
 b=KOy8QsZPzS9If5sCu6CbXN7vTBM5yiK+OLuw5jTpUgdrwSKZj5YCMSLuznLupUsAucA0bM8E1HWNHP8UPPZyb8V8hJq4RnX3ssvBC9AVSd/Znpw/4VPg++kDRU4djh5wSn3+d4ScvR9eJI0B9tdKju28c0AK8SWKbl62yPRahA2R0PWSdeCXIdQtXQ0vUW/xQSteynWtQtEYS+ObIZLKTi9zrE+Fbsy8YqUCPU/CTbHdX6NprxkawtXnqsclFLGyiCC9n2QV971M1Sqdv8vybIZpCLXkUsSt2gg+l7VP6bEQbkIWI0+Uxl6siEOIosEo/B+WNjrKSdB4DmSH9F9iuQ==
Received: from AM0PR07CA0027.eurprd07.prod.outlook.com (2603:10a6:208:ac::40)
 by MW4PR12MB7263.namprd12.prod.outlook.com (2603:10b6:303:226::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 16:09:42 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10a6:208:ac:cafe::95) by AM0PR07CA0027.outlook.office365.com
 (2603:10a6:208:ac::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.21 via Frontend
 Transport; Tue, 10 Oct 2023 16:09:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 16:09:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 10 Oct
 2023 09:09:21 -0700
Received: from [172.27.14.100] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 10 Oct
 2023 09:09:17 -0700
Message-ID: <5d83d18a-0b5a-6221-e70d-32908d967715@nvidia.com>
Date:   Tue, 10 Oct 2023 19:09:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        <alex.williamson@redhat.com>, <jasowang@redhat.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>
References: <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com> <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
 <20231010115649-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231010115649-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|MW4PR12MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: ad1f24ab-ed0a-4c2a-e4d7-08dbc9ab4ecd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6rFdb3/nox7trbkgXbwgVdtVHsiU6Tqae8OLA+R8cD1Ek7qZPVGFYxmdq9XV4NQYwy2/Pz0NJvSpp8dM/7m8gCZ9dlz0AoJjbCm3zL4jC/Zt8zzdp5H8vguwKI32St0f1GJMasj0353TFaUdK4Gk2fLOLXNICTFy/QiKDfGwiDTteq6iKKyYBAZCAxwX3dYHQEo8TuIa2IjC1t4A+WmwRMVwLOz2BiWEMVQaI3T3mE356vx3J4emVDWd9d+3tFNQe264fuqmpAzwzxpzM4GDigfhl29hkm4/Zkl87zyBc3wLVb6M/S6RPI/WJxJ4dOVDidMssHH9X1vId1iPQ0bevuCo6Ol/IbawpeIrv9U1o7j/voh4P3wkBsZMyD13dbQ9pE9zEkv9tykr/Pug2m+TnTa51zWZZM+na6yWQ1+RHDaglw9XammckXzR3eF2QkyqVU3UsWG3tc10JlBnnLCrBnjFssJviPIvILJSCkOcf5quI9/v9dDy9UfqNqBTab3/qNHxx+1cPVqhraGRdhjb2suRJ94M0fmgca28I/JmAnZgcJWY/d7C/2B5Hb0Bh2V3Ac728pgNtMom+gWEbsnhI14ApIuEbtJwRno6SgAeLYLTjUwzGOOGd+QHjQfcAiwGOGDUpIYe4JZw/4YWhvL6oFlglPQzWINTn2f0rfXlOuoh4Viwmxsq39GgiCpb5atRwE5Ic8E7UFrmSPVYhnf4sKqtVic8yiBzHNdkp/MQJluY8dWNSDD1yelEBIQVGqaSj+x5d05KfLQw0fAz/fw6g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(1800799009)(186009)(82310400011)(451199024)(64100799003)(46966006)(40470700004)(36840700001)(40460700003)(36860700001)(7636003)(82740400003)(356005)(478600001)(47076005)(26005)(6666004)(36756003)(426003)(16526019)(336012)(83380400001)(31696002)(86362001)(2616005)(107886003)(40480700001)(2906002)(53546011)(5660300002)(41300700001)(70206006)(316002)(16576012)(6916009)(54906003)(8936002)(4326008)(31686004)(70586007)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 16:09:40.0201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1f24ab-ed0a-4c2a-e4d7-08dbc9ab4ecd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7263
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/2023 18:58, Michael S. Tsirkin wrote:
> On Tue, Oct 10, 2023 at 06:43:32PM +0300, Yishai Hadas wrote:
>> On 10/10/2023 18:14, Michael S. Tsirkin wrote:
>>> On Tue, Oct 10, 2023 at 06:09:44PM +0300, Yishai Hadas wrote:
>>>> On 10/10/2023 17:54, Michael S. Tsirkin wrote:
>>>>> On Tue, Oct 10, 2023 at 11:08:49AM -0300, Jason Gunthorpe wrote:
>>>>>> On Tue, Oct 10, 2023 at 09:56:00AM -0400, Michael S. Tsirkin wrote:
>>>>>>
>>>>>>>> However - the Intel GPU VFIO driver is such a bad experiance I don't
>>>>>>>> want to encourage people to make VFIO drivers, or code that is only
>>>>>>>> used by VFIO drivers, that are not under drivers/vfio review.
>>>>>>> So if Alex feels it makes sense to add some virtio functionality
>>>>>>> to vfio and is happy to maintain or let you maintain the UAPI
>>>>>>> then why would I say no? But we never expected devices to have
>>>>>>> two drivers like this does, so just exposing device pointer
>>>>>>> and saying "use regular virtio APIs for the rest" does not
>>>>>>> cut it, the new APIs have to make sense
>>>>>>> so virtio drivers can develop normally without fear of stepping
>>>>>>> on the toes of this admin driver.
>>>>>> Please work with Yishai to get something that make sense to you. He
>>>>>> can post a v2 with the accumulated comments addressed so far and then
>>>>>> go over what the API between the drivers is.
>>>>>>
>>>>>> Thanks,
>>>>>> Jason
>>>>> /me shrugs. I pretty much posted suggestions already. Should not be hard.
>>>>> Anything unclear - post on list.
>>>>>
>>>> Yes, this is the plan.
>>>>
>>>> We are working to address the comments that we got so far in both VFIO &
>>>> VIRTIO, retest and send the next version.
>>>>
>>>> Re the API between the modules, It looks like we have the below
>>>> alternatives.
>>>>
>>>> 1) Proceed with current approach where we exposed a generic API to execute
>>>> any admin command, however, make it much more solid inside VIRTIO.
>>>> 2) Expose extra APIs from VIRTIO for commands that we can consider future
>>>> client usage of them as of LIST_QUERY/LIST_USE, however still have the
>>>> generic execute admin command for others.
>>>> 3) Expose API per command from VIRTIO and fully drop the generic execute
>>>> admin command.
>>>>
>>>> Few notes:
>>>> Option #1 looks the most generic one, it drops the need to expose multiple
>>>> symbols / APIs per command and for now we have a single client for them
>>>> (i.e. VFIO).
>>>> Options #2 & #3, may still require to expose the virtio_pci_vf_get_pf_dev()
>>>> API to let VFIO get the VIRTIO PF (struct virtio_device *) from its PCI
>>>> device, each command will get it as its first argument.
>>>>
>>>> Michael,
>>>> What do you suggest here ?
>>>>
>>>> Thanks,
>>>> Yishai
>>> I suggest 3 but call it on the VF. commands will switch to PF
>>> internally as needed. For example, intel might be interested in exposing
>>> admin commands through a memory BAR of VF itself.
>>>
>> The driver who owns the VF is VFIO, it's not a VIRTIO one.
>>
>> The ability to get the VIRTIO PF is from the PCI device (i.e. struct
>> pci_dev).
>>
>> In addition,
>> virtio_pci_vf_get_pf_dev() was implemented for now in virtio-pci as it
>> worked on pci_dev.
> On pci_dev of vf, yes? So again just move this into each command,
> that's all. I.e. pass pci_dev to each.

How about the cyclic dependencies issue inside VIRTIO that I mentioned  
below ?

In my suggestion it's fine, VFIO will get the PF and give it to VIRTIO 
per command.

Yishai

>> Assuming that we'll put each command inside virtio as the generic layer, we
>> won't be able to call/use this API internally to get the PF as of cyclic
>> dependencies between the modules, link will fail.
>>
>> So in option #3 we may still need to get outside into VFIO the VIRTIO PF and
>> give it as pointer to VIRTIO upon each command.
>>
>> Does it work for you ?
>>
>> Yishai


