Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB91A5E662C
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiIVOwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiIVOwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:52:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A335FB4EA4
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:51:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOSQwfozkQgxgD8kEWLHRhREPRkkFLA5CdDjyt3IG7cUYmB5EEhO7kT3Z9CQW5/xGN0pVdNK+tsNTMfBUCW6158qWms5xCchFjHPiEoZujp7Ly+1Ha1N+M/SsumOdCmM9kzSmQnG+cfXfR/kn+l7CpSeiwFcPe+6rw7uBJB1OPl4UkbjeKrDifZVNvQu4CgsEeGzNeNkL+F2SWkM8HDsi1WIE5v3zIDU3Y72lnwkyc+puVPR2laRzNe4B18cgDPvhGm0aiOzzWesHvTOMDEPokQVasAJailsx5xvhBPhqHH47LewYVHiGKIrDyO+QodK3OEUryLsw8yIiJyoZw+fnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=On/knqmCbmKP3taNEAL6YAo9Sg0v3H5x0GSU6LyiMUw=;
 b=M2mhzMDTasR02JZvSqDPlaBnNcYMX9XiYoPaQq9p0nj5bGhzXeD5mtqxFfKm8jtpPxy9vk1SvM8n6/L0Ph828CHVucgolEhNWHtASnFMOXgmPy8b3bDZvYhw3oiTQ2LF9ze821ZOOGYNOt+YCVOP8RoSpW76blLXoGopvmDxYcZuwzSHnC5N3BZEzd2ysGoaZjnyF0qsX6hA20xXm9Hwub37ooAhN8hLxndtSrZ+TO1UeJ1DBFHLU6yasH3A9qImmJMBPTT8hJRmulwWpMavViY+TTnW6DTt9uG8t7SYK6jDdMV9LBn1yRmo9CkdAqAbSl+D77f+sRTAK+1CFa/Dcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=On/knqmCbmKP3taNEAL6YAo9Sg0v3H5x0GSU6LyiMUw=;
 b=CUq8TNH0T1wfbj2zbCLCPFPjSqfos/BmV9gHsia9u/SDhjrKGQtpgKOA1gSwElDSszf5o3V8tdXUTLopPUC/g8KkXyqLFywE9UE2bwDkYRbsWpp5OybSHTBaKwDdWraZc7AOeStuDsZ1L9GU9RlZrOKp2JaP9Ex81awyVc2OVRQt3sW3AOHIAEL0MNdNAKR+wFowXRQuOisMbg2rRHTsatonxSttzmKzy1D1EkPGmbLolG6Y+m5os2ILgTEC6l50TlBWkKKnh6tryogkfKu9CJm+mW1d2k2Vm/0sMXRY1hQWPRRMu2Bo3qPfXs5cyFhedXupybu+TAI5AgpyszyTSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6609.namprd12.prod.outlook.com (2603:10b6:510:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Thu, 22 Sep
 2022 14:51:56 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 14:51:56 +0000
Date:   Thu, 22 Sep 2022 11:51:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Yyx2ijVjKOkhcPQR@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <YyxFEpAOC2V1SZwk@redhat.com>
 <YyxsV5SH85YcwKum@nvidia.com>
 <Yyx13kXCF4ovsxZg@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yyx13kXCF4ovsxZg@redhat.com>
X-ClientProxiedBy: BL1PR13CA0248.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|PH7PR12MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: eec96f58-91bf-4f42-4df0-08da9ca9fe75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: amZg73sTZej+gie2yBTDp3Tjx+9PfNCeIEb6qWQrZ8EIyspgSB70guMGptN7Ck2q6HVXgrY+KjxtCKe8e3ntvY3AYxbBn8haK4M3Ags47DkA8gJeXvmEfcJQ2AcFoqpDB2Jtm8SGq0WP9QvhHuqs9uHrBEWbMw7AW8RU1y9zPbHd2hgGCV7solejTQox8KC8yjp1vNPmSWJ1yIYSAhTScuEhZw8aCCVhOc+vBM1GwYmsFBnWErH11STVbWbvmhH6CpyQ1POXmyVUUmpBazTg306dJXtBL+EDg7NrdwCH43SQQeQFt6DYk57ud5GutGZbLgJknLM2Y8xPrOE0B8/ZUnAgKHHw5JpEZueco17xApxfRdluBxKE9cR9X+C8VKH9Fy6uoH+Yda9xK4HBBY940QuobASI0vXoXceuH0ZCiWzu/VE7vThOFKDS/6Ggapld0ZDZ/7nf9Yk4GxnMi9ooEarL1X1aSSB/r2KBmyKhIKLMRcA7kW+e4Z8utmrtK7m2DR2kDHf9dvA7cmM9QZr+w3G+PuKFc/xHeeLR5hZPpsAWtXM3jnJxJSsKJKlT9kQlLNRU9yEWzwlugWuTSVPHvOTUvY26HTbizD4XaHA0jfY9cQOQKW6BFBasm0wxSpchMfIa5aUWe+A7mcS2a4YdJben2l82MNtyPG8GmbQVE++PM6Q7bzetv0J31fa/Pjis9LaR7fFY9cFmBzVapZUbuWdswtHOMvFMiTRFcu1fchbRAsZPO2PsywMMnBG3y+F3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199015)(66476007)(6506007)(478600001)(86362001)(36756003)(38100700002)(6486002)(2906002)(7416002)(5660300002)(66556008)(6916009)(4326008)(316002)(186003)(8676002)(54906003)(8936002)(41300700001)(83380400001)(66946007)(2616005)(6512007)(26005)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmUxaCtKejI5TDNCWVpKWS9uZkora1FRaTRlUllkcVVybnBXZlpDR2VVaElq?=
 =?utf-8?B?RWptanBYaS95aE8wR090WTU3cmNHNVJTZzlQRGFpYkM1OWVCN3RjR0J0N3pN?=
 =?utf-8?B?cmZ1aldGKzQ4Y3RKRnk5d3BSM0M4RGdyQ0dHUFVKY2poSGlGcENQc2xucjZw?=
 =?utf-8?B?YVpBWTFGVVZxK2tqL2dtZmVmVlFhMnNGeEhoWkUxbk9YbDljMGMzN01NWUpn?=
 =?utf-8?B?OG9ISzNQbE9UbTVBQXBjMmZQOXF4Ymx6cEN3ZU1ZM2t2WGRZYzBwa2pXZUd2?=
 =?utf-8?B?WnEwU0M5d1BPNFVUaU12T0hmcmNzWjRKbE10aXlPVUl1TW9Uc0RnMDVpeG9u?=
 =?utf-8?B?aFVIaWsrQ1RLWVUzTm43eE12V2QrcHd2NnZMcEh1allEVXNRNW1aVENvZzVM?=
 =?utf-8?B?bnlmVXVURnBPaS93dWFtRFJqMkN5NjNJR0ZCbWN1ZVZ3UEc4dks0S0tHM3JF?=
 =?utf-8?B?ZzFtRDJ2MkRwOUNWWTliOGJPeXppS1FCazM0SWZzeVkxZ3d5WWtTVnc3eVEv?=
 =?utf-8?B?N2VsWlNQcmJkMm9QS04zSEwwdkE1UHJNYWcxd1JCOS9yT05hRmFkYUh0eVV3?=
 =?utf-8?B?ODlzUUhQS2RDRFBLWks1SUlQNUk0WVhTYTZPNHBqSm9zUkcvUCtmWTFLSVBG?=
 =?utf-8?B?UnJsTlVxRXAyUWk3WE84ZW1GSDhGaWY1NXFubXFOUTZnekNuVFlrQlB5MkZM?=
 =?utf-8?B?SUJEVWR6eWwxODV4ZmpqSUwza2VMVEdLRFcwVFRvTlVRRW45dyttdFRxSHZq?=
 =?utf-8?B?elcvRGZwdWhxZEdmKzlXTW5NOHNmUVJGNngrVlhlZndDbmZtY2doTCttYW94?=
 =?utf-8?B?bkZpSU9jbnVmWGJCZVVPUng2UkZLUFcyRHhsWEZPVk9MMzcvQkltNU1aeVNo?=
 =?utf-8?B?ZUo2RFN6VDcwSWcwTVBqMkVubEtWRHhyaEFxNnBBZlJoNG1WTG9wR3BoeUht?=
 =?utf-8?B?SWh6NDJ5TnJIQXBFZG9sV2xXMFE1Y2QrYzdYLzZZOUQrNEJBQ25PTk5WcVY0?=
 =?utf-8?B?TmgrdmUyWEp4UStmeTJNa0hrS0hJcVhoV3Z5aE8rUlptcGp2WUhiQjdrY1ZL?=
 =?utf-8?B?blU4QlppKzlWbS85bFFoYTZCWFFHeGIzcHFBUWc0Zks3amQ4aktEK052Yklq?=
 =?utf-8?B?cU85aThnOGxPM2VuWHNaUUF0WHJ0d0tGVmdSMXFwcTh1TElwN0JwTmtodThx?=
 =?utf-8?B?OFhubW8rMktVN0xBbngwSG1oLzFSTHJBempxNnd3eTdNaGtjL0E1QU16RFlu?=
 =?utf-8?B?SmlvVTVmdFI3M2FoazlxN2lMUDJtbEhvVmZ4eVlqZkxMM09LNHZJdzFTT2F5?=
 =?utf-8?B?d0JHb1lRZFViZlZ0TjcvTFlSSTdzSnMzWlNoQXNwWnJNaWpGTWFObmFZcmpO?=
 =?utf-8?B?RVQ0aEc0UkpLa0kwU0NOQVliaDBHNWVJSiswQzdUTjBtUE5kR0NvbHJuVTlI?=
 =?utf-8?B?cXNHeFNtS1hXcnBzNjlneHg0NzROSXp4UlJIMlphaGtpdUprMHhSRWpLSnFG?=
 =?utf-8?B?d1VHeXg0Ty9GaXVKWWhrRmt1eGsrMnJGRGEraGFKTFFMemlWaUVDemp5RHoy?=
 =?utf-8?B?c1lFUTh6ZVArVDRLYnZZS29MSk13YWxGem5vZWtBMUUrM0RLVk5GOFNTWkZP?=
 =?utf-8?B?Y3ZWL1d1a0pHTjZQV29uVE8yR1JmMFkzWHhuaEM4NlZnZEZPampyUjl5Q1Ry?=
 =?utf-8?B?ZnhHVGF6eGhyaVJraXUrdTFjbXNUOHB5bVdLaXVvZWN1aHp0OEMxVG5vQlln?=
 =?utf-8?B?K3oxVzJrcjlnTm0xODYvb1RQclhTSEU2S3FzNVpSc1JoTjNRNFhhMnIyN2Mx?=
 =?utf-8?B?cERRSWlLT0RTdGRURmdnVGVPME1NdTU1cS9sZHFNV09jb0RzRTdHQ2JXelp5?=
 =?utf-8?B?RzBRaUlzVUxDZFFUSG1yd29aejJKMHU1WWdFTnhLUWd4ZHdYZlRGZDU0T1Mx?=
 =?utf-8?B?QUFIOTF3ZDNVV3ZMVlJrczcxM3ZXeG40ZFdPclhpbDZvWTNJQ0VISE8reXZM?=
 =?utf-8?B?YTV1WjR6REd4UGU1RVJ0TmRKWGh0MkROTWV2dTd5cVFLOFN3QllQQ2psdWVK?=
 =?utf-8?B?OStSU2xmZ0VrVU83VFgxN0VDUTUvTCtiZDM5NkVsbndkdmRmcENaR3daNS9F?=
 =?utf-8?Q?eNRaM5pCBW8Q4n+xxXcohYkFG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec96f58-91bf-4f42-4df0-08da9ca9fe75
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 14:51:56.0259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Nsb5mgd8gAFT3nO+wdZ9kTXOVGKNkaZREkEdqsGySxCmNKDrsXDypyRMiA/g5ie
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6609
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 03:49:02PM +0100, Daniel P. Berrangé wrote:
> On Thu, Sep 22, 2022 at 11:08:23AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 22, 2022 at 12:20:50PM +0100, Daniel P. Berrangé wrote:
> > > On Wed, Sep 21, 2022 at 03:44:24PM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Sep 21, 2022 at 12:06:49PM -0600, Alex Williamson wrote:
> > > > > The issue is where we account these pinned pages, where accounting is
> > > > > necessary such that a user cannot lock an arbitrary number of pages
> > > > > into RAM to generate a DoS attack.  
> > > > 
> > > > It is worth pointing out that preventing a DOS attack doesn't actually
> > > > work because a *task* limit is trivially bypassed by just spawning
> > > > more tasks. So, as a security feature, this is already very
> > > > questionable.
> > > 
> > > The malicious party on host VM hosts is generally the QEMU process.
> > > QEMU is normally prevented from spawning more tasks, both by SELinux
> > > controls and be the seccomp sandbox blocking clone() (except for
> > > thread creation).  We need to constrain what any individual QEMU can
> > > do to the host, and the per-task mem locking limits can do that.
> > 
> > Even with syscall limits simple things like execve (enabled eg for
> > qemu self-upgrade) can corrupt the kernel task-based accounting to the
> > point that the limits don't work.
> 
> Note, execve is currently blocked by default too by the default
> seccomp sandbox used with libvirt, as well as by the SELinux
> policy again.  self-upgrade isn't a feature that exists (yet).

That userspace has disabled half the kernel isn't an excuse for the
kernel to be insecure by design :( This needs to be fixed to enable
features we know are coming so..

What would libvirt land like to see given task based tracking cannot
be fixed in the kernel?

Jason
