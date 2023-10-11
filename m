Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9D67C4DD3
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345742AbjJKI6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343913AbjJKI6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:58:37 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECF798
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpI+0+iy6SeHbowZxVdrctgh8cXXRcy7ZV+atcD17XirdR8BQwJC7XrdBGOwtQ5CM/twWaMLIyYsahO0PHA8IgvSTkQrJyuBlUzRKWunQnyb5GSreCFqomW63fB530l4iyXpCEGP5ozif84H5dEAfatcsb9VRt5MywH0azB1gqsfXO10jyDmKRd1ot7EFBKHt35tQ9crCogCaDmakW7atXf3PHQmi8wEFXv9qiOGnFS8QeZTT0daP3lXTEjsTWcUuVb6pdYiiDNR4xwDcp0B7vR2BCoav7bCnMeAL7ndYFNAfKWSJI/eWwCLAgWwagCEofCqxAIK/+E7QZnl2eg1rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJbYKk7lfhT0twYV+CFhTtdXoHwEQr0SxMJiLqZFprY=;
 b=BBpBtf5WwxE/rmY8rfmFGJlIdPgxIqGdemtazCxE5cxctRQKIg/QWbrbYQEDlXdE8R7F2CfY1aoOjMx7v3UWIZCFiViFfCvD9urHYT/cog3qb+SXkcVSWvMCK2LEAmZmSi+lV4HynERHT2rqBELlf2HJZX3EKObSTiGxRZUmO+Zt/HNKnRUz/YHePJ6Oq6gcIm2bIF3GCuFH6I6qess+Dc3wfbG3J/nIBQNYJQ4QEr/SUJPJbzv9PnpKC7km/WP5veNhnzPrbI/xmOwjgAe3gGMGxAjZpJ0S0fdyforUFNT5ScXd5yCvh9SZHofvdddRfexM3c4qYM9CUaIYRp0ZTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJbYKk7lfhT0twYV+CFhTtdXoHwEQr0SxMJiLqZFprY=;
 b=Ja+l+VXA4uA4ZgnMjW7dnLYw7k64NF8r+rxYzsEIkF25lk6G9MhCwX1G/1gn7LHDjw5g5pHrBzJ8lLITe17PZn9z8pyZoRXwYzf/gUdUWivx4PzQ9MRLP1yBxvi/tttlrSdwlmgGyhAiDkZD+oAuX6CNhenN83VAIJdcJeto77sWFJ5PIVAGLGdM20R6DFvyrVOS1VOZDACTCXUc9fsUBdL++5BOJf8nvfmEg74IiJl4LZAL6Fu7zxYSDDEuU1zvRAvvw0+tf6rpBs0wm4PKYCIl34X4mbRRA0a3iy4Qv1x9go/bPFIxNO+hSpCq5ey9B4DAnflWg+zarvBBIuajLA==
Received: from MW4PR03CA0198.namprd03.prod.outlook.com (2603:10b6:303:b8::23)
 by CY5PR12MB6645.namprd12.prod.outlook.com (2603:10b6:930:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Wed, 11 Oct
 2023 08:58:33 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:303:b8:cafe::6) by MW4PR03CA0198.outlook.office365.com
 (2603:10b6:303:b8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44 via Frontend
 Transport; Wed, 11 Oct 2023 08:58:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Wed, 11 Oct 2023 08:58:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 11 Oct
 2023 01:58:18 -0700
Received: from [172.27.15.31] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 11 Oct
 2023 01:58:13 -0700
Message-ID: <0ae3b963-f4fe-19c2-ea79-387a66e142ab@nvidia.com>
Date:   Wed, 11 Oct 2023 11:58:11 +0300
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
References: <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
 <20231010115649-mutt-send-email-mst@kernel.org>
 <5d83d18a-0b5a-6221-e70d-32908d967715@nvidia.com>
 <20231010163914-mutt-send-email-mst@kernel.org>
 <f4247e59-19cd-0d6b-7728-dd1175c9d968@nvidia.com>
 <20231011035737-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231011035737-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|CY5PR12MB6645:EE_
X-MS-Office365-Filtering-Correlation-Id: de93e79c-0fae-42bd-22dd-08dbca383fa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qsd94v8oPOubzE+qQRsXtmwXx8wBNIHmfiD5MajrQIygDIpe06jU13z2oE76zDeFLGQ03F+qy55hstPINc7xdjeTBcg9fLRMVaAImoKWFLzEBHBol3fMF4RH8U1Lm21ZJowfTPPbUjpc9ercPa2ERG0wG3Tpj/Phz6HXRjWJ3Dum3JT6oMnZrQvQHfatJUN3iyfFp389J8jHSaYk0FtDXPPJnaqAlPPJDzgbXnjrV8qhG4UgPC7neQf7hR8HSx08dRpHHpDqLZ7PkOdCw/vY39rMXXwkmJ24He09YGp00sNdHsfTR2wF2/04UxbPDWq9igl0mSLHL7x5i2VnIqRsEqhh15kgzIK57Y3V1iqydLROFXNMbDJBdU7hlDTMbV7U/xihSD5fD6N+ntmM4wBFBjFIATbEK1sf/MC1y2/lNObZEnkf9S0uffvqScb0kAzaTc+t181ZLqFWO2+RJHDg6VywZAzO5uPYv80QR1gVgNkgayI7pBKxQX9eDEeUdz2A2UKy9T/6IHUuN9JZqgVlPej9SMyZP9gja1socsKwifyWm5rqW7t5YJtxxX1T+CLO4dOHbrR6Mo2WWtl89o1iIdocWu4UQIZ4j9vkcItBzVkxKGlsgSDkQTW8SBBEkbVgVAQShuDDdybRRiC6FRTm1jNyapAvcI6SWBB/Yho0DbwB8EdIwiDgf2iKgHUdA6EUt/Zrt0/PxvsbDeTtjoi2R83KfTo/N/awsBSuURbxfTsPvhHaWlbczA4kDtbyBTSJtaiO5c+pefilxeF1S97oIA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(376002)(396003)(346002)(230922051799003)(82310400011)(1800799009)(451199024)(186009)(64100799003)(46966006)(36840700001)(40470700004)(7636003)(86362001)(356005)(36756003)(31696002)(31686004)(16526019)(66899024)(40480700001)(53546011)(8676002)(5660300002)(82740400003)(41300700001)(8936002)(478600001)(2906002)(83380400001)(426003)(26005)(107886003)(16576012)(336012)(2616005)(70206006)(40460700003)(36860700001)(316002)(4326008)(70586007)(47076005)(54906003)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 08:58:33.5933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de93e79c-0fae-42bd-22dd-08dbca383fa0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6645
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/2023 11:02, Michael S. Tsirkin wrote:
> On Wed, Oct 11, 2023 at 10:44:49AM +0300, Yishai Hadas wrote:
>> On 10/10/2023 23:42, Michael S. Tsirkin wrote:
>>> On Tue, Oct 10, 2023 at 07:09:08PM +0300, Yishai Hadas wrote:
>>>>>> Assuming that we'll put each command inside virtio as the generic layer, we
>>>>>> won't be able to call/use this API internally to get the PF as of cyclic
>>>>>> dependencies between the modules, link will fail.
>>> I just mean:
>>> virtio_admin_legacy_io_write(sruct pci_device *,  ....)
>>>
>>>
>>> internally it starts from vf gets the pf (or vf itself or whatever
>>> the transport is) sends command gets status returns.
>>>
>>> what is cyclic here?
>>>
>> virtio-pci depends on virtio [1].
>>
>> If we put the commands in the generic layer as we expect it to be (i.e.
>> virtio), then trying to call internally call for virtio_pci_vf_get_pf_dev()
>> to get the PF from the VF will end-up by a linker cyclic error as of below
>> [2].
>>
>> As of that, someone can suggest to put the commands in virtio-pci, however
>> this will fully bypass the generic layer of virtio and future clients won't
>> be able to use it.
> virtio_pci would get pci device.
> virtio pci convers that to virtio device of owner + group member id and calls virtio.

Do you suggest another set of exported symbols (i.e per command ) in 
virtio which will get the owner device + group member + the extra 
specific command parameters ?

This will end-up duplicating the number of export symbols per command.

> no cycles and minimal transport specific code, right?

See my above note, if we may just call virtio without any further work 
on the command's input, than YES.

If so, virtio will prepare the command by setting the relevant SG lists 
and other data and finally will call:

vdev->config->exec_admin_cmd(vdev, cmd);

Was that your plan ?

>
>> In addition, passing in the VF PCI pointer instead of the VF group member ID
>> + the VIRTIO PF device, will require in the future to duplicate each command
>> once we'll use SIOV devices.
> I don't think anyone knows how will SIOV look. But shuffling
> APIs around is not a big deal. We'll see.

As you are the maintainer it's up-to-you, just need to consider another 
further duplication here.

Yishai

>
>> Instead, we suggest the below API for the above example.
>>
>> virtio_admin_legacy_io_write(virtio_device *virtio_dev,  u64
>> group_member_id,  ....)
>>
>> [1]
>> [yishaih@reg-l-vrt-209 linux]$ modinfo virtio-pci
>> filename: /lib/modules/6.6.0-rc2+/kernel/drivers/virtio/virtio_pci.ko
>> version:        1
>> license:        GPL
>> description:    virtio-pci
>> author:         Anthony Liguori <aliguori@us.ibm.com>
>> srcversion:     7355EAC9408D38891938391
>> alias:          pci:v00001AF4d*sv*sd*bc*sc*i*
>> depends: virtio_pci_modern_dev,virtio,virtio_ring,virtio_pci_legacy_dev
>> retpoline:      Y
>> intree:         Y
>> name:           virtio_pci
>> vermagic:       6.6.0-rc2+ SMP preempt mod_unload modversions
>> parm:           force_legacy:Force legacy mode for transitional virtio 1
>> devices (bool)
>>
>> [2]
>>
>> depmod: ERROR: Cycle detected: virtio -> virtio_pci -> virtio
>> depmod: ERROR: Found 2 modules in dependency cycles!
>> make[2]: *** [scripts/Makefile.modinst:128: depmod] Error 1
>> make[1]: *** [/images/yishaih/src/kernel/linux/Makefile:1821:
>> modules_install] Error 2
>>
>> Yishai
> virtio absolutely must not depend on virtio pci, it is used on
> systems without pci at all.
>

