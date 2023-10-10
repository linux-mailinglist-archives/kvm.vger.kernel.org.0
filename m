Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941E87C0090
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 17:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjJJPoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 11:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbjJJPoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 11:44:04 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2C997
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:44:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACXWfsHyI/gJkVH/Tc33IV4J7bPD8hG1TmjSflryDnyM9zOhqiJXTTwt3TZlEIp+PE8jlFod4vkdJXWY0JQqBg6nQoTnuapu+BLfC8U111NBoaYp5lxcPnfwZyTOQB9cZkJa8wzt77Y5qPmZ8VCUnJ+LezEk5e+VKbi/BuuhtpyiKxICIxao6RXVPezisAj3u2O8OaXf8rI5KB7HJjeprA5+dh1vsuvjmBAniwYmJxg8R+zTgkNuYMWIDwEHJh33d6CB+7xZ9VOIS+42pH7E6aNoYYqkdTjm20PVC4t8Wb4QGqyK1tb/zJf8jb9qn66tYCEeFexi54uVLe0RhQ6GqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4lJgNW4zW0XNR3jC09dWxc5eOw/x6aUImPu79Ok5Ag=;
 b=Cq1XIStA77/o2eg0LMFSXAoXkY/otgJrzhYFTjMEDuO6ZAaES/4MbiR7bd3ehmRHBpLfI7c7GHUNKxWRK4y9FhP7QiPDeYsB8JlpmAe0aMbMWgeptRRxU1esD8gJ2qNYCe3nRiS6BvfjyluBi6/4+3XmIiw0YiihLMasOKNjff/nhEKmHr+f+3mYp+UCGx/B/hh2kudQg2FI5fLJpREplvXR47Zm5sfNc7RAW8B3nvzpj2hJhd+lfSXwjc+0gp6INvIuGCrvnf5oSZpIdj2jUThqX06txNrSlZQqhrREPJM2n+qwLXWnXoyDQo1Q+8hFkmADnR5R82IbfXBoPdd/Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4lJgNW4zW0XNR3jC09dWxc5eOw/x6aUImPu79Ok5Ag=;
 b=qsHwlsa8gojHmtcKmMgyhrbuv5T8jvqL4Cn2N5z8Y3O7ZxYrSquoz1XAmdkkmhjWJ5oGH0kyV8imJTPwKQSeY8w3khqEubpULPP/ohkjRHEzuCg7fX2ObR2MNx+F7KH5SO47H5A4bxchhiONJImQZcGYLLsUR4vnmYC8TfMeJDKJsUuySVGK7GHF0DvNUu+yQfGbuwkPvp5lrHKR7vbrUQu8kleSgbAn/CX8lwWlfAiybgBLD2WWu/8oGm4osqEKrtzqqszZX5bzg1dpwboaV30fRtM4EB0IKhx0uhpudzmT0CDMUkRutWnU5rxYLCLAGeJtFihdHJ7LP29+haOuzg==
Received: from SA9PR13CA0117.namprd13.prod.outlook.com (2603:10b6:806:24::32)
 by SJ0PR12MB5424.namprd12.prod.outlook.com (2603:10b6:a03:300::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 15:43:59 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:24:cafe::63) by SA9PR13CA0117.outlook.office365.com
 (2603:10b6:806:24::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.17 via Frontend
 Transport; Tue, 10 Oct 2023 15:43:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Tue, 10 Oct 2023 15:43:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 10 Oct
 2023 08:43:45 -0700
Received: from [172.27.14.100] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 10 Oct
 2023 08:43:41 -0700
Message-ID: <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
Date:   Tue, 10 Oct 2023 18:43:32 +0300
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
References: <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com> <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com> <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231010111339-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|SJ0PR12MB5424:EE_
X-MS-Office365-Filtering-Correlation-Id: 44ee8550-34cc-4e8f-4686-08dbc9a7b85b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPAvPIe4gl942alT1+iYGsVizhWTwWnOxiqvMoAWMGTGX0YnnoUNGErO5IqhFb9Zu8YWm6qMNT4HzBRI8MMbqwIXija56ajpOlQnliA9wS9LSM7u17n5Oy6XoqB+vvsuve3e4YnIm0AHP1W9TR1MevrFkjHHBukMSVjPrgNphiP1/JuplylLdYfqDK0nGilmnjAwsvVvtn2s9oL7EL0ON6ERUihTWYWmn+5i8zbWr7h8bUsTCp1frOR0zMUFbenpDwWzhGkhHXjmyCOXSkupvFV8hrno/013CVFtAMy8TYyNAHnX1E4QndDDh5zCxLWkD9VCwLLzja8WioLMD327szYwk000dCD5KiisFTqfxl8qABpTvStmANStWAgiKo3Du88KhrpuxelRP8daoYqp1aH51Xes0q5ziHHhE4kEsQD3cpM88JrfsFDZ9QqdxcW0XjxZvw4spgyoV2baFPyTafb9nsCox4ihFxWBy3I3IKLzSy6ZCe8BSdFgG3n67Vy6xZh9NJIN29ydYofcZCiSa444qqkAaNPhxK5n6Iap7Ox34pKuBqDbhY5H2axg+0KiTmEooWrmf7Aru7CTYuNydWaFI4Wn1DaMZD3AGL5Kz0ShoXl+5CWCc1CcBzW+1XWVfXtkYfOxrIIwDT9pgyZCfijaT9bhgbeYNw0EguDoaAqEO6GuUNeMURvdE+N/TXo0qz+Ydn7r3y4MkAc7QXXNVx5xF2WUOQX3GmlhbtGsN9OgJxFskR4QwnJS7E7WSXglKRJscqIFo1aT44IdexHALg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(346002)(39860400002)(376002)(230922051799003)(82310400011)(451199024)(64100799003)(186009)(1800799009)(36840700001)(40470700004)(46966006)(40460700003)(5660300002)(41300700001)(8676002)(8936002)(7636003)(4326008)(356005)(86362001)(31696002)(82740400003)(2906002)(40480700001)(53546011)(47076005)(478600001)(6666004)(107886003)(83380400001)(36860700001)(31686004)(36756003)(16576012)(426003)(16526019)(2616005)(336012)(26005)(316002)(6916009)(70586007)(70206006)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 15:43:59.1205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ee8550-34cc-4e8f-4686-08dbc9a7b85b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5424
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/2023 18:14, Michael S. Tsirkin wrote:
> On Tue, Oct 10, 2023 at 06:09:44PM +0300, Yishai Hadas wrote:
>> On 10/10/2023 17:54, Michael S. Tsirkin wrote:
>>> On Tue, Oct 10, 2023 at 11:08:49AM -0300, Jason Gunthorpe wrote:
>>>> On Tue, Oct 10, 2023 at 09:56:00AM -0400, Michael S. Tsirkin wrote:
>>>>
>>>>>> However - the Intel GPU VFIO driver is such a bad experiance I don't
>>>>>> want to encourage people to make VFIO drivers, or code that is only
>>>>>> used by VFIO drivers, that are not under drivers/vfio review.
>>>>> So if Alex feels it makes sense to add some virtio functionality
>>>>> to vfio and is happy to maintain or let you maintain the UAPI
>>>>> then why would I say no? But we never expected devices to have
>>>>> two drivers like this does, so just exposing device pointer
>>>>> and saying "use regular virtio APIs for the rest" does not
>>>>> cut it, the new APIs have to make sense
>>>>> so virtio drivers can develop normally without fear of stepping
>>>>> on the toes of this admin driver.
>>>> Please work with Yishai to get something that make sense to you. He
>>>> can post a v2 with the accumulated comments addressed so far and then
>>>> go over what the API between the drivers is.
>>>>
>>>> Thanks,
>>>> Jason
>>> /me shrugs. I pretty much posted suggestions already. Should not be hard.
>>> Anything unclear - post on list.
>>>
>> Yes, this is the plan.
>>
>> We are working to address the comments that we got so far in both VFIO &
>> VIRTIO, retest and send the next version.
>>
>> Re the API between the modules, It looks like we have the below
>> alternatives.
>>
>> 1) Proceed with current approach where we exposed a generic API to execute
>> any admin command, however, make it much more solid inside VIRTIO.
>> 2) Expose extra APIs from VIRTIO for commands that we can consider future
>> client usage of them as of LIST_QUERY/LIST_USE, however still have the
>> generic execute admin command for others.
>> 3) Expose API per command from VIRTIO and fully drop the generic execute
>> admin command.
>>
>> Few notes:
>> Option #1 looks the most generic one, it drops the need to expose multiple
>> symbols / APIs per command and for now we have a single client for them
>> (i.e. VFIO).
>> Options #2 & #3, may still require to expose the virtio_pci_vf_get_pf_dev()
>> API to let VFIO get the VIRTIO PF (struct virtio_device *) from its PCI
>> device, each command will get it as its first argument.
>>
>> Michael,
>> What do you suggest here ?
>>
>> Thanks,
>> Yishai
> I suggest 3 but call it on the VF. commands will switch to PF
> internally as needed. For example, intel might be interested in exposing
> admin commands through a memory BAR of VF itself.
>
The driver who owns the VF is VFIO, it's not a VIRTIO one.

The ability to get the VIRTIO PF is from the PCI device (i.e. struct 
pci_dev).

In addition,
virtio_pci_vf_get_pf_dev() was implemented for now in virtio-pci as it 
worked on pci_dev.
Assuming that we'll put each command inside virtio as the generic layer, 
we won't be able to call/use this API internally to get the PF as of 
cyclic dependencies between the modules, link will fail.

So in option #3 we may still need to get outside into VFIO the VIRTIO PF 
and give it as pointer to VIRTIO upon each command.

Does it work for you ?

Yishai

