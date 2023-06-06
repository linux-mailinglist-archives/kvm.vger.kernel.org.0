Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AA3724C8B
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 21:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbjFFTI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 15:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239501AbjFFTIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 15:08:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218912722;
        Tue,  6 Jun 2023 12:05:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAQyMSHd5GB59cGBg275S+eTZ/F7PNFtT2hM63Is+SvctUvJUcmjFPpLaGDfIpBO3Wg/zIcZ2bsnIHkntAtXMN/VTS9cMFsa/QDdZFLCAcoZdXTOFxBbSf4ExOTq8psnIOsJuFxP/H8SvhjpXf+G3xiOqR85crPn0C1POEUMiWxN+bq34yNPSFAPMRw8YGNbf10gn4N/QUCa9kqsAWqnClpPhRMZ2lBmCE5DrUL26o5YE4k5xND/WfgLHZAcBewPjnUvC/QFsQinRLYY1A6+wQyl5CL3+cbodjCHj0RMdLI0n6zsrtjitY1AvmoV9lCZxtKj0+lKpk1b5vnQTgGghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhs8bbNa6Hm7Lim8sTbivvRRD0ic1gIqNWCzrWeioHo=;
 b=dgd/TduKhcisgm3oC1T/HlwFahWJthlpZn9yCKvAJFs/sg3LqmXMyOvtyEG4jjXS7hyplptMUJBvuXJv2cXNl1r0kGkdL7ZA5JtdBTy1ubLU6PRvqdP5GUoUHz+eO6SoAaBDl46P261kcyvm2MfH5i4YrhNYRe3ZU3lsEdCJb/7iIQokfnYaGogTweC8q6CsAKeW1ACfTXYjqvz9gPH/CI+8+gfrcLTWseOoqlkn9yfkdfl9To4aHBANqvuBgPubWhAAqujZ2sa/BabO38MFaAr4wnxyRzPWb2jvObZAMvmsJbN+yWlXmY4MlMVTgzuiIFEAgg/R+Id1uWeUMA/Kiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhs8bbNa6Hm7Lim8sTbivvRRD0ic1gIqNWCzrWeioHo=;
 b=KUFm7hzcziNdGgRrWD3RBE+tehTu10dympxVIy9WNHUIU02srUuWlGkI7fO1asecxAwIpBNiU6HzDm5q3KZafVMtLvtAI3PvqBtwdd8YI6UkpmnSQ0Rgl4Jj/js06ir4WSgHmx3gBXa0hjISzqK+wkBkidObjqrBEn3zFawU8rdCTjIVzeMdmpEtTu8jM2/nK7c6KwtRYzdCLJcd9pNHAMtL3MxYCty9jUGFn/Two8NBH4kM+qijn9v/2FFknistSaMKjfiDYUmXSIV4FQmREpom1fT/riuBhtnM0HY2ec0WiVQ6AGsajcsDCI7He1S0Qx1PslxLVRXNrfLARvIShA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB8081.namprd12.prod.outlook.com (2603:10b6:8:e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 19:05:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 19:05:29 +0000
Date:   Tue, 6 Jun 2023 16:05:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZH+DdVIyZ6hHCDaK@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
 <20230606083238.48ea50e9.alex.williamson@redhat.com>
 <ZH9RfXhbuED2IUgJ@nvidia.com>
 <20230606110510.0f87952c.alex.williamson@redhat.com>
 <ZH9p+giEs6bCYfw8@nvidia.com>
 <20230606121348.670229ff.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606121348.670229ff.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 727b5d57-1ff7-41de-bedb-08db66c0fe34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e6faFmc83rI8Jhgr5INIqTTty+LMH4BbJ0dqRGi8h6KEVUoPGnr/EU5h+3z86bsR7USXbvojQYUSmST4en8o5HCYOtZS0qqAXrlJysOuZpzBGDGVpX2nuxViQbL1+k0vZDPQqlmFhn442KmGLvxzGp4V8iZfJ/AXm8v0tFG/YuZ7LDPGHT1SNT5s0HZH+M9zQ5O9V3hzeyAOPUKDZLleeyGWMvOc99pty2cVEC4QkPFslBi4tOm3d5onX+wc3oqJehzHR8L+i3jOC2FlgImub6hn6WzgkNe85xuj+tgx4z/y+3/+TeI6nPkGtg1v1vTRJWHHrMThHt11Hl2sdDYrIvwpPINwQnv9xDeqeTkn/Gx+uX8uU4sTr0Acb0ZEl9h8IBT+qcG2ngnbPoJ7AinYDvw8YqE8N/sou4qgBV12QMAimPoD4O5NL2RkvJPY1gictQ4DTQAi4os3mM0lwO85567Z1GUhAIecJ+n5zXAV4M6otJohYN8knB9YraDLc30NoE0WiXHk3mV6vcoeWr5oPUmJqoAv+I2epvQm0F4QviuThPaKdtsizxHp8A65O1dFVc9ewUsWL3WHGGDZffJDgogifCO020mm4SBqG85RlEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199021)(83380400001)(38100700002)(86362001)(478600001)(41300700001)(6666004)(6486002)(66476007)(8676002)(66556008)(5660300002)(8936002)(4326008)(6916009)(66946007)(2906002)(316002)(2616005)(26005)(6512007)(6506007)(36756003)(186003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x3BQeuMrl9g98+DPM34jTspL8zRLI+tmwP3GcCTjOGW6oR7HGHkkngXPGmby?=
 =?us-ascii?Q?LIBxB807ATGdaGHpch6z4Hmu1OAd6rDL/1M8z/xs5to2Rq7F7LnK84aNGkeS?=
 =?us-ascii?Q?g8ZGvFzk7Kg/GxuuSewnO9D4lnJLsRiOMA5ySMBwUzcCq1q9HP07i+VL/B1f?=
 =?us-ascii?Q?l7Bv2vF3vegJEhro6zLOxZulm8HnqVDhJ51rlKNSO4OyMkB5bS6qKBeHxZPD?=
 =?us-ascii?Q?tX3qAai27JqN0TLF/YFUAOHWgXxydbBryVyJt9f99c3Un+f9YTbwkTDqTHQm?=
 =?us-ascii?Q?xqMIAnKy8ec9CDj8wxtqFIYY53tqEi31tR+9ovmsx2DewPYG9YlBHjwt1kdj?=
 =?us-ascii?Q?qX3qiRckW1M9LKX3VqWkI4TgxKMJsTYaKbySr71jC7lQ3RTM3kEn/zRTJUeY?=
 =?us-ascii?Q?+0FiTtlvVE4yGp0ysvFFF6iWZ5iSLy+oDMdzOAgSuOZtY/yHnBFhC2GO2XC6?=
 =?us-ascii?Q?Kelk2J8qjM/obgk1QMJM6Aqj6aih8gdULBhB6Qyau4Pdpj+lGQ/yAoqv6N3v?=
 =?us-ascii?Q?Ja8vYXwHyf9bEgAe2G7lBqAHA7xIQaBgWOp9Rxaj2urWUmyWaQ3+vM9kSM9T?=
 =?us-ascii?Q?2Ul5sCx1zHTxt+0W6IXufKQTPUVEsQ6hxyOMqNMgaHx/seqG9YlP8woJf39a?=
 =?us-ascii?Q?M5HNn7cbs8ckJCBTPCb2dmF5wQQ82iD1S0smI8rGyhdgvyAGWCNJz0o0uAY3?=
 =?us-ascii?Q?FLjdcGGry1QQVBwPWzD7gJPUIfZ4WC6wnehey8Y2fRTDdRqy0vhURrIPxXeT?=
 =?us-ascii?Q?q0IOyQpxcC+rs1tLVZkpozrFptXAiZVy9XJBLPIEShdRsfMSP0ezyKkCb2kZ?=
 =?us-ascii?Q?rhjGVSp+hLXUJScIB9qrOF01cdltD7Qfps5N6M6igUyk6YS5rZKMdZElq3DX?=
 =?us-ascii?Q?E3wNpnFOPkiIbkZqq67rgt0c7Iys2iVJjckTtToNkSiWk5zcXYnOfFo0x/yH?=
 =?us-ascii?Q?I9tT+/FfJ5CIjgrdv+XzFHPFuOb7oWGp2BLL52utnN57d/VCHoi98RJikd00?=
 =?us-ascii?Q?+6YxXrwuI6iBPUJlxZBOMQNiEeDS/D3uDMxw+yiYoqGCiLGunU97hhE46pRK?=
 =?us-ascii?Q?k62RrhGEoxa+Le0aI3xwy16vjASLK+JFZDmhBhGdauTrmE4VuqJseASMhFLb?=
 =?us-ascii?Q?Sn1PQJVyOUntjTC7EOK5eC8V84dPbrD3t4P3jopzHCiyHRV9hMn55O05jH6P?=
 =?us-ascii?Q?4KVj/34YMTz2J4/lW4OxZqTiCa5RCVTDBflZk6YYw6tkC4Wj16za0Os+l4LE?=
 =?us-ascii?Q?Y70XRmBgAJK1cvoJSKdn2tw9dbDvebU2xBjDWsgBEEKH1i9I6yzk8/8Fr+29?=
 =?us-ascii?Q?ugNjA3MzK+SDl/weu3pF3LLME983kVvlPk0f5GYSG86T9aDPRkYfp6Ivjtvh?=
 =?us-ascii?Q?hZbKLkk1qOPNIchXLHMDugBuSq9irTch9/iprz3mo7YepQ+t1jvBksLEeMX3?=
 =?us-ascii?Q?s+dtqWXpgpoMSXyQzWHV8kP322jBW4sOayK9nFljEiJ/83NGU9eh+DifPOlM?=
 =?us-ascii?Q?VWFr1TtfozmnyLcXjCPBJyJuB27Dt1T28Hc6+LV50DbqJNc1ywEW6aUUGQ3U?=
 =?us-ascii?Q?bqkrimbpviPaXxMCv9dUoBfdGUagbkVODaoEKeg/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727b5d57-1ff7-41de-bedb-08db66c0fe34
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 19:05:29.2792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgCuD+HQz38JlUWSwCHhkNZjmrDHZy+OnbAot6qRv3m0McAoZjoWrOizJJJj/MFI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8081
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 12:13:48PM -0600, Alex Williamson wrote:
> On Tue, 6 Jun 2023 14:16:42 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jun 06, 2023 at 11:05:10AM -0600, Alex Williamson wrote:
> > 
> > > It actually seems more complicated this way.  We're masquerading this
> > > region as a BAR, but then QEMU needs to know based on device IDs that
> > > it's really not a BAR, it has special size properties, mapping
> > > attributes, error handling, etc.    
> > 
> > This seems like something has gone wrong then. ie the SIGUBS error
> > handling stuff should be totally generic in the qemu side. Mapping
> > attributes are set by the kernel, qemu shouldn't know, doesn't need to
> > know.
> 
> You asked me to look at the v1 posting to see why there's so much more
> going on here than a quirk.  That's what I read from the first public
> posting, a coherent memory region masqueraded as a BAR which requires
> different memory mapping and participates in ECC.  I agree that the
> actual mapping is done by the kernel, but it doesn't really make a
> difference if that's a vfio-pci variant driver providing a different
> mmap callback for a BAR region or a device specific region handler.

The ECC stuff is generic too.

Even the non-power-2 size thing is *generic*, even if isn't following
PCI SIG.

> > The size issue is going to a be a problem in future anyhow, I expect
> > some new standards coming to support non-power-two sizes and they will
> > want to map to PCI devices in VMs still.
> 
> Ok, but a PCI BAR has specific constraints and a non-power-of-2 BAR is
> not software compatible with those constraints.  That's obviously not
> to say that a new capability couldn't expose arbitrary resources sizes
> on a PCI-like device though.  I don't see how a non-power-of-2 BAR at
> this stage helps or fits within any spec, which is exactly what's
> being proposed through this BAR masquerade.

To emulate PCI, someone, somewhere, has to fix this mismatch up.

So given choices
  1) Qemu sees a special NVIDIA thing and fixes it
  2) Qemu sees a VFIO_PCI_BAR0_REGION with an odd size and fixes it
  3) Kernel lies and makes a power-2 size and it fixes it

2 seems the most forward looking and reusable.

I definately don't think this is important enough to stick a vendor
label on it.

Broadly, we are looking toward a way for the kernel VFIO variant
driver to provide the majority of the "PCI emulation" and the VMM can
be general. It is not nice if every PCI emulation type driver needs
unique modifications to the VMM to support it. We are planning more
than one of these things already, and there are industry standards
afoot that will widly open the door here.

> > It seems OK to me if qemu can do this generically for any "BAR"
> > region, at least creating an entire "nvidia only" code path just for
> > non power 2 BAR sizing seems like a bad ABI choice.
> 
> Have you looked at Ankit's QEMU series? 

Not well, I haven't seen any versions of it till it was posted

> It's entirely NVIDIA-only code paths.  Also nothing here precludes
> that shared code in QEMU might expose some known arbitrary sized
> regions as a BAR, or whatever spec defined thing allows that in the
> future.

It should not be like that. From a kernel perspective this is
basically all generic VMM code that can apply to any VFIO driver. The
kernel side was ment to be a general purpose API for the VMM.

The only special bit is emulating the weird Grace FW ACPI stuff.

> > > coherent memory which requires use of special mapping attributes vs a
> > > standard PCI BAR and participates in ECC.  All of which seems like it
> > > would be easier to setup in QEMU if the vfio-pci representation of the
> > > device didn't masquerade this regions as a standard BAR.  In fact it
> > > also reminds me of NVlink2 coherent RAM on POWER machines that was
> > > similarly handled as device specific regions.    
> > 
> > It wasn't so good on POWER and if some of that stuff has been done
> > more generally we would have been further ahead here..
> 
> Specifics?  Nothing here explained why masquerading the coherent memory
> as a BAR in the vfio-pci ABI is anything more than a hack that QEMU
> could assemble on its own with a device specific region.  Thanks,

Well, we deleted all the POWER stuff and got nothing general out of
it. Isn't that enough to say it was a bad idea? Here we are again with
the same basic CXLish hardware design and the answer should not be
keep making more vendor ABI.

I think this is the direction things are trending in the
industry. There is nothing particuarlly special, and certainly nothing
*nvidia specific* about these things.

So lets find a way to give these things appropriate generic names at
the ABI level please..

Jason
