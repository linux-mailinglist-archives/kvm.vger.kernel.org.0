Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03877C51F7
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 13:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbjJKLZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 07:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjJKLZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 07:25:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F16F9D
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 04:25:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FB9iYc42hTditvyMmypyTMzC4F68WvIW9nEKKdKgX5qmbBIETXDNLEEWa9vzGuh8DZeUhgQodprJtibHtA+NbYKe/60PNVI2a5wP6iHkYSzvZrg37SncDDUfBgldaNicyRH2RLg3Vexe4xW6bby0QEpxAInIjSy6AV2d8ehE2hzh9VAfgO81RKKMgnpzvyBAEgeL5fotxJ62tF9aNJcschlGfrJV4D2y0SSPLZjDOih2lOQnjWMPg8nkizZTez6OeQPmHI6yppTR7IOGIR+7zGC6c3/tBMP+Er9EuEP77qr1+cG0LVbe5v5+rZ1dnW0fFaFm71nvI5ISVFPlEt58IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rKRYbL/mVXPTRzVdI6+ppF4u5YkiaQ9PlMCzbk1MX9I=;
 b=adLUrbxr80aBPcCixCZ19RGKTKEhbXZeJcHkr9Hm5QUTbil3zl8vNwcmplSSX+Lz3BtIoKA3I/hbP+SOAE2PpWoqsYHDV1kB3/n9k8MDOGvMB4u0wcoe1TuNRB0a/BrRbK+CTHnnIciSHd+sC80nUUo8CoR0xINKY4giHD4GTkPKnd4wCSewqB6DS2fw3lT7DQmvc1iil61qLU4RyHOqJC+tphwUKFuiq98n6Av7FRRgzUWi4MLrrVgTjziQLWUaYtdiztILF6q0/mczrLOvrSei/l7BvsSFRNMF6nqPfHdyEGGk7DB3YaDXcG3cq5+jtHRbFAdt3r0tGngBpeJEFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKRYbL/mVXPTRzVdI6+ppF4u5YkiaQ9PlMCzbk1MX9I=;
 b=l3YEz2pCs+lkRyzc/U/FXRGfR84hOK4tZS8KKBFCDORbPmjJPhlBFC/UfGv34gWLNV13LG2YpKRZOJwxUSxpa4X0Gdzg5PbIaf2UbJIXvhI0PrlEP1ew/GGYohaQzPTm+sJURmA0nbbImyqqtzvLm6zrceDwwIq4a+1eF66oCIBPl3PdLGAa6hjTvgm35Dmny1nFjvbh7GAEzERiCTAjzEsTjwsfKJa9rNh6g5l0Y2z0X7fbz+Hi1pH5pFhGeH1pZoabGHp9DaCjLe6IZdtCj+YLTk7wGSoucgpMjzDJLBV8diZJ2n9sO+8GAwCU2I2lGxdndGW5ZtFVzo5ya4WILQ==
Received: from SN6PR05CA0028.namprd05.prod.outlook.com (2603:10b6:805:de::41)
 by PH8PR12MB7351.namprd12.prod.outlook.com (2603:10b6:510:215::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Wed, 11 Oct
 2023 11:25:53 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:805:de:cafe::b) by SN6PR05CA0028.outlook.office365.com
 (2603:10b6:805:de::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.23 via Frontend
 Transport; Wed, 11 Oct 2023 11:25:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Wed, 11 Oct 2023 11:25:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 11 Oct
 2023 04:25:39 -0700
Received: from [172.27.15.31] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 11 Oct
 2023 04:25:34 -0700
Message-ID: <3bd6e56a-d6c2-4e84-99ad-f30b57a96f39@nvidia.com>
Date:   Wed, 11 Oct 2023 14:25:31 +0300
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
References: <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
 <20231010115649-mutt-send-email-mst@kernel.org>
 <5d83d18a-0b5a-6221-e70d-32908d967715@nvidia.com>
 <20231010163914-mutt-send-email-mst@kernel.org>
 <f4247e59-19cd-0d6b-7728-dd1175c9d968@nvidia.com>
 <20231011035737-mutt-send-email-mst@kernel.org>
 <0ae3b963-f4fe-19c2-ea79-387a66e142ab@nvidia.com>
 <20231011050014-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231011050014-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|PH8PR12MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: 6299f8c8-7198-471f-96b0-08dbca4cd423
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wl93OgxIIhPXSfQJJRTVwdgTPLaoiryj9mLgaV9CaVVBdR/ZnIj+e536kyvGyiQdpZCWegNhr+AgBsK7UvCjfmUAitbGfWBZeJrmRjG5hto0KL+yuWf9Jf4q9UlaM8webLIxMRydUT0ecK7B5/mj7hJ2vVeDpatiKPn6Aty/TLVDfACnL0dQTpcJ33WHOq+1/URkqQLKGObYSquXM53odhDcLiJRaGobg3SEDnB83B4RQ3/ORhk+opCvohAG1vXE7HxXvxCEvUsDnYqdF6uq+9VLN7Pxmp8h5RNHBR+Kuzljd3gjc4Zt+7tX/QLV2yX/JgldnlO9BlhzrLe8+nXOxxhNzjV485ENTl5Jawa+3k/gtYQqWn52NKuxsy9QAz5Tfi6qdQF8shbkRlOvwP9L1Dp8xC3nzTBRUaD3Q1y3jtk9hPUFg+o+dWCYaNSOeYIo/2lqWrBxDVUvaeWULg+c2OBqJQdesLgH0RDJkC0e/Kllo7Y83PJE6Ud1lx13ofoolTjsfXxWkhlHZ33l8c9zgQ9DkNOSCNRTXYH1RieIEWsdjaWmfF/ISRKw5W7Hymzi1hqowSxxnwHR5jSMlrMukZ6IgF5S3bCxxbDy+7ll1/55dN4V5VmT6JcOBMe4+maNGxIUXo71p73TelG1YY6g3YR3g8q5312lE6T8+EnBliIPuxvG6v9xC1A/1DMnd5pyw/SGY6EcCZeltBJUJ6DhDz7jac8aojhkUYn0b7YfHnDfrpKc9bCbEs8H7Uyx4BpL4dCbjZgi4eCOpwh9noVCog==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(82310400011)(36840700001)(40470700004)(46966006)(31696002)(356005)(86362001)(36756003)(7636003)(31686004)(66899024)(53546011)(40480700001)(6916009)(2906002)(41300700001)(478600001)(5660300002)(82740400003)(8936002)(4326008)(316002)(2616005)(336012)(47076005)(83380400001)(107886003)(426003)(40460700003)(16526019)(16576012)(70586007)(70206006)(8676002)(6666004)(54906003)(26005)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 11:25:52.6921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6299f8c8-7198-471f-96b0-08dbca4cd423
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7351
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/2023 12:03, Michael S. Tsirkin wrote:
> On Wed, Oct 11, 2023 at 11:58:11AM +0300, Yishai Hadas wrote:
>> On 11/10/2023 11:02, Michael S. Tsirkin wrote:
>>> On Wed, Oct 11, 2023 at 10:44:49AM +0300, Yishai Hadas wrote:
>>>> On 10/10/2023 23:42, Michael S. Tsirkin wrote:
>>>>> On Tue, Oct 10, 2023 at 07:09:08PM +0300, Yishai Hadas wrote:
>>>>>>>> Assuming that we'll put each command inside virtio as the generic layer, we
>>>>>>>> won't be able to call/use this API internally to get the PF as of cyclic
>>>>>>>> dependencies between the modules, link will fail.
>>>>> I just mean:
>>>>> virtio_admin_legacy_io_write(sruct pci_device *,  ....)
>>>>>
>>>>>
>>>>> internally it starts from vf gets the pf (or vf itself or whatever
>>>>> the transport is) sends command gets status returns.
>>>>>
>>>>> what is cyclic here?
>>>>>
>>>> virtio-pci depends on virtio [1].
>>>>
>>>> If we put the commands in the generic layer as we expect it to be (i.e.
>>>> virtio), then trying to call internally call for virtio_pci_vf_get_pf_dev()
>>>> to get the PF from the VF will end-up by a linker cyclic error as of below
>>>> [2].
>>>>
>>>> As of that, someone can suggest to put the commands in virtio-pci, however
>>>> this will fully bypass the generic layer of virtio and future clients won't
>>>> be able to use it.
>>> virtio_pci would get pci device.
>>> virtio pci convers that to virtio device of owner + group member id and calls virtio.
>> Do you suggest another set of exported symbols (i.e per command ) in virtio
>> which will get the owner device + group member + the extra specific command
>> parameters ?
>>
>> This will end-up duplicating the number of export symbols per command.
> Or make them inline.
> Or maybe actually even the specific commands should live inside virtio pci
> they are pci specific after all.

OK, let's leave them in virtio-pci as you suggested here.

You can see below [1] some scheme of how a specific command will look like.

Few notes:
- virtio_pci_vf_get_pf_dev() will become a static function.

- The commands will be placed inside virtio_pci_common.c and will use 
locally the above static function to get the owner PF.

- Post of preparing the command we may call directly to 
vp_avq_cmd_exec() which is part of vfio-pci and not to virtio.

- vp_avq_cmd_exec() will be part of virtio_pci_modern.c as you asked in 
the ML.

- The AQ creation/destruction will still be called upon probing virtio 
as was in V0, it will use the underlay config->create/destroy_avq() ops 
if exist.

- virtio_admin_cmd_exec() won't be exported any more outside virtio, 
we'll have an exported symbol in virtio-pci per command.

Is the above fine for you ?

By the way, from API namespace POV, are you fine with 
virtio_admin_legacy_io_write() or maybe let's have '_pci' as part of the 
name ? (i.e. virtio_pci_admin_legacy_io_write)

[1]

int virtio_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode, u8 
offset,
                  u8 size, u8 *buf)
{
     struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
     struct virtio_admin_cmd_legacy_wr_data *in;
     struct virtio_admin_cmd cmd = {};
     struct scatterlist in_sg;
     int ret;
     int vf_id;

     if (!virtio_dev)
         return -ENODEV;

     vf_id = pci_iov_vf_id(pdev);
     if (vf_id < 0)
         return -EINVAL;

     in = kzalloc(sizeof(*in) + size, GFP_KERNEL);
     if (!in)
         return -ENOMEM;

     in->offset = offset;
     memcpy(in->registers, buf, size);
     sg_init_one(&in_sg, in, sizeof(*in) + size);
     cmd.opcode = opcode;
     cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
     cmd.group_member_id = vf_id + 1;
     cmd.data_sg = &in_sg;
     ret = vp_avq_cmd_exec(virtio_dev, &cmd);

     kfree(in);
     return ret;
} EXPORT_SYMBOL_GPL(virtio_admin_legacy_io_write);

>
>>> no cycles and minimal transport specific code, right?
>> See my above note, if we may just call virtio without any further work on
>> the command's input, than YES.
>>
>> If so, virtio will prepare the command by setting the relevant SG lists and
>> other data and finally will call:
>>
>> vdev->config->exec_admin_cmd(vdev, cmd);
>>
>> Was that your plan ?
> is vdev the pf? then it won't support the transport where commands
> are submitted through bar0 of vf itself.

Yes, it's a PF.
Based on current spec for the existing admin commands we issue commands 
only on the PF.

In any case, moving to the above suggested scheme to handle per command 
and to get the VF PCI as the first argument we now have a full control 
for any future command.

Yishai

>>>> In addition, passing in the VF PCI pointer instead of the VF group member ID
>>>> + the VIRTIO PF device, will require in the future to duplicate each command
>>>> once we'll use SIOV devices.
>>> I don't think anyone knows how will SIOV look. But shuffling
>>> APIs around is not a big deal. We'll see.
>> As you are the maintainer it's up-to-you, just need to consider another
>> further duplication here.
>>
>> Yishai
>>
>>>> Instead, we suggest the below API for the above example.
>>>>
>>>> virtio_admin_legacy_io_write(virtio_device *virtio_dev,  u64
>>>> group_member_id,  ....)
>>>>
>>>> [1]
>>>> [yishaih@reg-l-vrt-209 linux]$ modinfo virtio-pci
>>>> filename: /lib/modules/6.6.0-rc2+/kernel/drivers/virtio/virtio_pci.ko
>>>> version:        1
>>>> license:        GPL
>>>> description:    virtio-pci
>>>> author:         Anthony Liguori <aliguori@us.ibm.com>
>>>> srcversion:     7355EAC9408D38891938391
>>>> alias:          pci:v00001AF4d*sv*sd*bc*sc*i*
>>>> depends: virtio_pci_modern_dev,virtio,virtio_ring,virtio_pci_legacy_dev
>>>> retpoline:      Y
>>>> intree:         Y
>>>> name:           virtio_pci
>>>> vermagic:       6.6.0-rc2+ SMP preempt mod_unload modversions
>>>> parm:           force_legacy:Force legacy mode for transitional virtio 1
>>>> devices (bool)
>>>>
>>>> [2]
>>>>
>>>> depmod: ERROR: Cycle detected: virtio -> virtio_pci -> virtio
>>>> depmod: ERROR: Found 2 modules in dependency cycles!
>>>> make[2]: *** [scripts/Makefile.modinst:128: depmod] Error 1
>>>> make[1]: *** [/images/yishaih/src/kernel/linux/Makefile:1821:
>>>> modules_install] Error 2
>>>>
>>>> Yishai
>>> virtio absolutely must not depend on virtio pci, it is used on
>>> systems without pci at all.
>>>

