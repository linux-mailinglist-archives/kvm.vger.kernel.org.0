Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F5323CF92
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgHETWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbgHERlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:41:49 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::624])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC072C008694
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 07:34:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRfVRAGKIsp2yA4si5D90REUtbs+VBRf7/dpn/Yk8ol1jiovuoVyfieAY+AXGJaGr5BebFaUsuOZdHn8rIcpGffoEhePocCgOEGQV19HIsQqCsS3nBZErNJhveAFNpWHz88eav81HwYcz1p5gkiDURuTQSTf7H5e3mQH6FZ4T47Mo800BfLOnyHs0z95CXkfBCTxYNdpAbLkKC9fxB0e+xesiSfZbUZc4x20Yz8qp8LvBG5GFuuDc763VsAHzah2OQWvzJeF6MZ3q09z3FfZRIoVgTzGRME0IezDjINiXM1h2neabSR3xzB34n0i014gf32Sb0XYMETgAkUWnZUiqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfkT8do/kbOgLCMtyVg3es7mghFtXsbz5vTkRN91GpI=;
 b=RPHDP4FIBrI0XLKaoBcNYw06j8qC6L/5p0cj423wczrp5RdVqknHYBO+GgFR2OVPiX8g9MOkqpAP2WcidXp+jT8LgnwpGbjPACw9Mt+DPBTgJ8yKa0yujGyZxUkI9ROTCzL1VgfwJyZ8jvUNyb9rFW9XJn8CiP/OujY7XEHm/ENMcGhx6qlpRRESiTaIxoc1i1XH88bO7h7XtXv4DK8lOpgSnai6233CXs6gBXT8d7oMovT4TGlupPhw8rGyOed9kptJjRvYsVLXVLNZpzdnL6UZNBdNEaFSh1RFk9NjNAEBqDXTJwrM3oGCaJpX/KrW/raMLd45yuQFeskRZYcqxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfkT8do/kbOgLCMtyVg3es7mghFtXsbz5vTkRN91GpI=;
 b=JkcIvkKaO1+Q0IwmKB3khjL5K7CbGGdL45yNVgIi7LToaUuml9CaT4yADanrT4eoE5dk1JyBFyktNhh0SeNDZkhz6w5tFR6IZYt+QaJWsaw1sK80do8E2oSnNdAj5J2b4+UDE/IFg1jq8I0OIPB6Y2hKpwAMANWCmgOVB4o9ZeY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from DBBPR05MB6364.eurprd05.prod.outlook.com (2603:10a6:10:cc::22)
 by DB6PR05MB3175.eurprd05.prod.outlook.com (2603:10a6:6:1a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Wed, 5 Aug
 2020 10:53:23 +0000
Received: from DBBPR05MB6364.eurprd05.prod.outlook.com
 ([fe80::6510:4e88:1d64:18ae]) by DBBPR05MB6364.eurprd05.prod.outlook.com
 ([fe80::6510:4e88:1d64:18ae%6]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 10:53:23 +0000
Date:   Wed, 5 Aug 2020 12:53:19 +0200
From:   Jiri Pirko <jiri@mellanox.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        berrange@redhat.com, dinechin@redhat.com, devel@ovirt.org,
        Parav Pandit <parav@mellanox.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200805105319.GF2177@nanopsycho>
References: <20200727072440.GA28676@joy-OptiPlex-7040>
 <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <20200804183503.39f56516.cohuck@redhat.com>
 <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
 <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200805093338.GC30485@joy-OptiPlex-7040>
X-ClientProxiedBy: FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::14) To DBBPR05MB6364.eurprd05.prod.outlook.com
 (2603:10a6:10:cc::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nanopsycho (85.163.43.78) by FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.12 via Frontend Transport; Wed, 5 Aug 2020 10:53:21 +0000
X-Originating-IP: [85.163.43.78]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b41274d-ec81-4dc9-5688-08d8392dc5d4
X-MS-TrafficTypeDiagnostic: DB6PR05MB3175:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB31753C6A751E091733E805E8BD4B0@DB6PR05MB3175.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PEzo+jy7cQh7gPwTjkb4PfOzl538yMIcb0Zio+6j/Nyt9ajYiVsoxHk9waJjARBSI+AIujFHXiSbb7DYhrxN0pfjB2oopn1JVRRcwzP6Tu3kHG0FjnE2ir30tOrHbJ8ysCAekV1YxnQa65cHc90yikrlKr6B4ALC3n2J//Xz74EkzH3VyeLUk9QanzsopiG13Ey9U0iF22mZ/hznMJEkeXI2t9ukcKtPhCag9m0XUAzjTRcSObOlQ1b7DXCm5Bm22neU4uCYXU17Zw6XRgPa5y6nOrqv/tI+2bIQcvoJGbEpR25r1mCi42j23Jq+h7G3+CL7/nI6WEKnMp5AfSYgbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB6364.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(52116002)(1076003)(6496006)(33656002)(83380400001)(186003)(6916009)(33716001)(4326008)(7416002)(16526019)(8676002)(66946007)(107886003)(66556008)(9686003)(316002)(55016002)(956004)(54906003)(9576002)(26005)(66476007)(2906002)(5660300002)(86362001)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: V96vhdqQ4MTMABcXDnfQo40/+OYfUg+WQU0PgNQR/Gxc8R12jRL0w+rePsvH4xKK1nZKJrV5Q+jZz7o/r49W5Ur8aY852FWxv55co5nsYIYq8686GgH9SeXWuZ4nG803LXg1XSHC7Ae+4KwX2AGwrBBzFLpSYlmhxpc86bdxdDvv58K+vpME3Efcky6qc5bcYEAn0mTE1dG7LmtWcCcvhuqEed9X/dow6FEaV77O8hF7f1lyNwHc3VH1BkEguHe6KYoRQry6mSRSZO1/4HzLcZfVVqFYq/G7++/k7/8QpkzGxTU6/SP2be662LsVntIKInmymhOLIEMp7kW8eT5lTz3G/0OyclkB9ORYEHyslZOLS7eFy1qf03t1S2eJZoS2CiTSCRDAwl+cpJUsAezR4yXE/2rVLJ5HQMec+GyJjRfyHYUzeqruYbIzehEzv8w9KBLdH2e1oyVJgQnGGQhMsAU5hRUzGhK+TfHyoD8EudnOMbd/prFzWfLE5O/5UUUQ+nC01PlPhmWfYiIi/sNTvxOQeeGbpnCOFxrJ6xakQfVfkZZSoHbrIRGeVAXb1a3m5ehMaFVyO0PCLUb05zupcD1YaJRuJGJSLpcThK/61G4WYRnFpkcGPNxGvRiV6m2LDkuQQnuHHJfonurq7Z+ywQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b41274d-ec81-4dc9-5688-08d8392dc5d4
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB6364.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 10:53:23.0582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dl/e0IjnfkRKlFA97H04T2InDckrrLp2n3JtIKYirwpkWT2VPFeaLJ3LsKM4dz7eXj26G5npCJjMuH9CTYVbNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB3175
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wed, Aug 05, 2020 at 11:33:38AM CEST, yan.y.zhao@intel.com wrote:
>On Wed, Aug 05, 2020 at 04:02:48PM +0800, Jason Wang wrote:
>> 
>> On 2020/8/5 下午3:56, Jiri Pirko wrote:
>> > Wed, Aug 05, 2020 at 04:41:54AM CEST, jasowang@redhat.com wrote:
>> > > On 2020/8/5 上午10:16, Yan Zhao wrote:
>> > > > On Wed, Aug 05, 2020 at 10:22:15AM +0800, Jason Wang wrote:
>> > > > > On 2020/8/5 上午12:35, Cornelia Huck wrote:
>> > > > > > [sorry about not chiming in earlier]
>> > > > > > 
>> > > > > > On Wed, 29 Jul 2020 16:05:03 +0800
>> > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
>> > > > > > 
>> > > > > > > On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:
>> > > > > > (...)
>> > > > > > 
>> > > > > > > > Based on the feedback we've received, the previously proposed interface
>> > > > > > > > is not viable.  I think there's agreement that the user needs to be
>> > > > > > > > able to parse and interpret the version information.  Using json seems
>> > > > > > > > viable, but I don't know if it's the best option.  Is there any
>> > > > > > > > precedent of markup strings returned via sysfs we could follow?
>> > > > > > I don't think encoding complex information in a sysfs file is a viable
>> > > > > > approach. Quoting Documentation/filesystems/sysfs.rst:
>> > > > > > 
>> > > > > > "Attributes should be ASCII text files, preferably with only one value
>> > > > > > per file. It is noted that it may not be efficient to contain only one
>> > > > > > value per file, so it is socially acceptable to express an array of
>> > > > > > values of the same type.
>> > > > > > Mixing types, expressing multiple lines of data, and doing fancy
>> > > > > > formatting of data is heavily frowned upon."
>> > > > > > 
>> > > > > > Even though this is an older file, I think these restrictions still
>> > > > > > apply.
>> > > > > +1, that's another reason why devlink(netlink) is better.
>> > > > > 
>> > > > hi Jason,
>> > > > do you have any materials or sample code about devlink, so we can have a good
>> > > > study of it?
>> > > > I found some kernel docs about it but my preliminary study didn't show me the
>> > > > advantage of devlink.
>> > > 
>> > > CC Jiri and Parav for a better answer for this.
>> > > 
>> > > My understanding is that the following advantages are obvious (as I replied
>> > > in another thread):
>> > > 
>> > > - existing users (NIC, crypto, SCSI, ib), mature and stable
>> > > - much better error reporting (ext_ack other than string or errno)
>> > > - namespace aware
>> > > - do not couple with kobject
>> > Jason, what is your use case?
>> 
>> 
>> I think the use case is to report device compatibility for live migration.
>> Yan proposed a simple sysfs based migration version first, but it looks not
>> sufficient and something based on JSON is discussed.
>> 
>> Yan, can you help to summarize the discussion so far for Jiri as a
>> reference?
>> 
>yes.
>we are currently defining an device live migration compatibility
>interface in order to let user space like openstack and libvirt knows
>which two devices are live migration compatible.
>currently the devices include mdev (a kernel emulated virtual device)
>and physical devices (e.g.  a VF of a PCI SRIOV device).
>
>the attributes we want user space to compare including
>common attribues:
>    device_api: vfio-pci, vfio-ccw...
>    mdev_type: mdev type of mdev or similar signature for physical device
>               It specifies a device's hardware capability. e.g.
>	       i915-GVTg_V5_4 means it's of 1/4 of a gen9 Intel graphics
>	       device.
>    software_version: device driver's version.
>               in <major>.<minor>[.bugfix] scheme, where there is no
>	       compatibility across major versions, minor versions have
>	       forward compatibility (ex. 1-> 2 is ok, 2 -> 1 is not) and
>	       bugfix version number indicates some degree of internal
>	       improvement that is not visible to the user in terms of
>	       features or compatibility,
>
>vendor specific attributes: each vendor may define different attributes
>   device id : device id of a physical devices or mdev's parent pci device.
>               it could be equal to pci id for pci devices
>   aggregator: used together with mdev_type. e.g. aggregator=2 together
>               with i915-GVTg_V5_4 means 2*1/4=1/2 of a gen9 Intel
>	       graphics device.
>   remote_url: for a local NVMe VF, it may be configured with a remote
>               url of a remote storage and all data is stored in the
>	       remote side specified by the remote url.
>   ...
>
>Comparing those attributes by user space alone is not an easy job, as it
>can't simply assume an equal relationship between source attributes and
>target attributes. e.g.
>for a source device of mdev_type=i915-GVTg_V5_4,aggregator=2, (1/2 of
>gen9), it actually could find a compatible device of
>mdev_type=i915-GVTg_V5_8,aggregator=4 (also 1/2 of gen9),
>if mdev_type of i915-GVTg_V5_4 is not available in the target machine.
>
>So, in our current proposal, we want to create two sysfs attributes
>under a device sysfs node.
>/sys/<path to device>/migration/self
>/sys/<path to device>/migration/compatible
>
>#cat /sys/<path to device>/migration/self
>device_type=vfio_pci
>mdev_type=i915-GVTg_V5_4
>device_id=8086591d
>aggregator=2
>software_version=1.0.0
>
>#cat /sys/<path to device>/migration/compatible
>device_type=vfio_pci
>mdev_type=i915-GVTg_V5_{val1:int:2,4,8}
>device_id=8086591d
>aggregator={val1}/2
>software_version=1.0.0
>
>The /sys/<path to device>/migration/self specifies self attributes of
>a device.
>The /sys/<path to device>/migration/compatible specifies the list of
>compatible devices of a device. as in the example, compatible devices
>could have
>	device_type == vfio_pci &&
>	device_id == 8086591d   &&
>	software_version == 1.0.0 &&
>        (
>	(mdev_type of i915-GVTg_V5_2 && aggregator==1) ||
>	(mdev_type of i915-GVTg_V5_4 && aggregator==2) ||
>	(mdev_type of i915-GVTg_V5_8 && aggregator=4)
>	)
>
>by comparing whether a target device is in compatible list of source
>device, the user space can know whether a two devices are live migration
>compatible.
>
>Additional notes:
>1)software_version in the compatible list may not be necessary as it
>already has a major.minor.bugfix scheme.
>2)for vendor attribute like remote_url, it may not be statically
>assigned and could be changed with a device interface.
>
>So, as Cornelia pointed that it's not good to use complex format in
>a sysfs attribute, we'd like to know whether there're other good ways to
>our use case, e.g. splitting a single attribute to multiple simple sysfs
>attributes as what Cornelia suggested or devlink that Jason has strongly
>recommended.

Hi Yan.

Thanks for the explanation, I'm still fuzzy about the details.
Anyway, I suggest you to check "devlink dev info" command we have
implemented for multiple drivers. You can try netdevsim to test this.
I think that the info you need to expose might be put there.

Devlink creates instance per-device. Specific device driver calls into
devlink core to create the instance.  What device do you have? What
driver is it handled by?


>
>Thanks
>Yan
>
>
>
