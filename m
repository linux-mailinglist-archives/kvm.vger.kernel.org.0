Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA0B7CA8B7
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjJPM7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjJPM7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:59:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D32FF7
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:59:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9NSFabHocBGmqtijCfRQmuh9wBeEfFyc70MieNFbd3kdzWAtyC6u8Ao95QJEkXDm5f6ZaMoS97Wo/nYPYLvGSr5rBp06pP6yiNQardVMqbeH2JJp94C58UfWb/64l7E+JtEDzguAZ3ZM7gJyLitwFfZ+gPy/HSDa1lb1ANSBANrQtZNDHf3mMuI0/qOQEDyTdlNKDup9zY32wQDgDfUGALs1N7OH8MV4qrefulP7m7LhZNSVX7l+AMbn8TWPoLaIqbh8v7KoFMZvecQ7dRuwlreR7bErYyr7TmpH2NUM+xWsujnx6M+x95Ofhtg/IWREjGYjgwecBjWE56VOo0Q0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLAIOMu04rujdt+h1Ci+VUTp+6lkbGWNHpDaeGikeCE=;
 b=XQez5SNQX0GzWBFgm6xF8QdkPxYBRE9L+szkFEEUGYr9V7UF4Ess/2qBpEXsRPaYCgLAse+jlywy/qMMJx7H2/Rro/ICh5xLKX03TcPU34sf5QkWHe+BYGpQclci4ADkzLdoixJT1tYCVPFG2H8mXhzJOfsgMR0OcZ/hXjcxPKbWxFTAo8WjJeL+QI0y35YIYdgcg4+mNq2TK0mubFZ3jgnn0O9sKq7inZwwJlJ8hfohqZ+xrEYa4v4p6aDDDSwjXiK8grd8wQocP1smxgYpoUcVN+mrfhaAO/Bxsgcx8LDlYzMc5S58Lng1ihCl1xSBFgvFnuAjsJjPpoZpEuXHzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLAIOMu04rujdt+h1Ci+VUTp+6lkbGWNHpDaeGikeCE=;
 b=lBRKSpA8EoSBz/ko8aLCXg5xUENi0plrFQF7rTuYoptUvs0eDB667sFaI3JLNIsNqyOGW8XThtosbAp+C6XphxMpyid+y/JEWfRA/sJcE0+XoQg5v7P0jsOAuhMaNinW/1kqJTOAlpZ3UzPNetmgDcrQzcRcrJC5PNsbCcCK+foAMRL/xYWl1QNsDL+zTp+ms40Od39VdkOMxtk7/5yLr2RDP44fVMSx3WJ7nwjkjMe/yK++SWNj/AolC9Y/jnjom7tN2+2OjPK4Oo+oGEq89sfpZhkvr0ER2r80zUMEijBqX4XAUTH8G+XOgmwe3TiUPMsGI2F+GlzxlK5lRWWY3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 12:59:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Mon, 16 Oct 2023
 12:59:44 +0000
Date:   Mon, 16 Oct 2023 09:59:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Message-ID: <20231016125941.GT3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
 <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
 <20231016114210.GM3952@nvidia.com>
 <037d2917-51a2-acae-dc06-65940a054880@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037d2917-51a2-acae-dc06-65940a054880@linux.intel.com>
X-ClientProxiedBy: BYAPR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:a03:80::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: c33e687a-1eb6-4966-ecc4-08dbce47c519
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dqYS9ZKHYvRwGBK3uVQjGdY38bbYmrAv50q2pqJJBm8Q9qPZq+kBpP0RZFRfPyQFv/gs+cTNYH1xDnjyweUbN8WB2xdE0UjrRF5c0zYjagv4RBHG4RLL9S1Izhw1ZkvrW5pUm6pQZoZzkuFqOi1urJOBEahDmAebvWFhZ4urbO24PSUqtgMzTCotLDyOqdqBcxHDUFIgQgsBL8iwC3o2G1hnDwloGeVYJd2/SskRy9oKErxcut8uQVS34wRJ/eQ9WB8aPI15KhyB3lgBn3YH4opaXgnw7C/LRGCL4gS9j31EFrqJwfodVsq6hzBHOVbKgqCb6c79Z6megR1MoSrKYlCIGvxKcezduO7lOtPVmNZzk4ZJGUBc246TdfB8RIj5zx9Yus0cMh5npIL0GjDV97vnxZuElVgSt0F8kjXjkFFuYph6LobpdQRFDHtkvW3gTsadQzC5XQiq/IU9yguB4LE/ol5wlz5iX2oFSFws6bPP4Qg0luqvnXNMV5zYJIkEaj5gdwYvsGYffRe7D/K+1p/AdhWRmKogLV4smyma6ftMQkmoAfmzzc4Gcxftsxmx89TZhSP2LbPrGMUDrI6f26CF8Uj17yLoSMfy4gkMfNU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(1076003)(26005)(2616005)(8676002)(8936002)(4326008)(33656002)(5660300002)(38100700002)(41300700001)(478600001)(86362001)(6486002)(4744005)(7416002)(2906002)(316002)(6666004)(6506007)(6512007)(53546011)(66946007)(36756003)(66556008)(66476007)(54906003)(6916009)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qXqH4SBcNKHqgUS2V9rraYhA+zw2ieQjSjIsnsEvXgBpq5VfYSgmKg3hUXiZ?=
 =?us-ascii?Q?8Au6bHu72EL/6fdTwuIVsjtJFRCUULo6HG1b8LBCdlgSk9/Gdc882MT4h2o8?=
 =?us-ascii?Q?hwuqEp0wo5nFUvTMamSxsUAjF+hbPIxQOlqtbGdn5/5igkc7fHYfNkkHx6bE?=
 =?us-ascii?Q?l7tGTHnrlUg36LvYPMMRXDkNS6beQc2+HPETigX6ysAEx74/zl7ji3ISurDL?=
 =?us-ascii?Q?CRyU3YGFzQN4SvEGdzT9btce6ga8q9uDr0C7xjY9nCf3GMlLP7jQyP42cvHt?=
 =?us-ascii?Q?6a6G3lwYd5asbe4XsuYKMpFcJgduX7Vl5VJ0Tt6z9O9AO0DS1/r2EdzxUbyn?=
 =?us-ascii?Q?EHnbNQ5yW4Pmzkvg0imZUp8B4lO80F3+/zugabA5lg9jNl/6H4wVLViOdmph?=
 =?us-ascii?Q?x3GBsdBP9iEjkQqQ/SoUGTR+DZWuiL0k1xN7muZxbhfzSO/GD4Tw133G+fQp?=
 =?us-ascii?Q?tWi6SJhf0lORktT+Mr0oy5AEWAqqE+RzQkHQdmGj4gKYRY4yOu6BkGVYvOHE?=
 =?us-ascii?Q?78jQzEmpA4z3YoCcsPGrZAC3o18Mln0ofMw2OJcdmU6ePjTCqJxByrXCAtgz?=
 =?us-ascii?Q?VN9lh8yMYhmTwaw1isiqixH216SUR6eHSnCb1aTP6qBF8a/fYCN9IN1wavGR?=
 =?us-ascii?Q?Koowxz99Wox/drhTkIBosEri398NrXsiejcJnvery3irMwiZdpqap1cV9aJp?=
 =?us-ascii?Q?RYK6LqIKXk+hmEvoNk+HftnqqvPXdIu4B3N/38juU4ssaqI692WihvERZpdQ?=
 =?us-ascii?Q?hkoc2aVV32E6TUHmBvQKInIMz7El40qUKwLeIP1yVoYHxFqzHNrcIlsG0LMg?=
 =?us-ascii?Q?3eAav87ZTX74pD5C0idsBPLRbEon8Vtu2eAOXTFm6mhdIQG79buw4t6K1Q+t?=
 =?us-ascii?Q?1XiPYco4YqxnFWmtH0wSS8wSFXubw1MouK7vxTrGkFIz642i4lcLf5RFAq07?=
 =?us-ascii?Q?wUV1uA1E8EdHuQh7GkCnokugKLEI7Nn9QPv2SfV/K83HmM048htKxctlYDr1?=
 =?us-ascii?Q?QOLHIZEADi9D1szjOxM+qMp+JVBiANOAEqCakguek7YXN6F2NVp25TOaf9E5?=
 =?us-ascii?Q?sWcDaPlCxS2hMa+zz1Y7uaUunoEp48i9Vrn5qWqzzuHShTEtYg6FuCIIUK5c?=
 =?us-ascii?Q?9YP+qGV56WUjOYNX2ecvPkUjVXoinG1UpLOJm/XDnMmcIbnHzON4qxkfHW+V?=
 =?us-ascii?Q?UxFqfWdDD4y0KcWRYnmnmefWlCT01b4dvCyxtxvPu1KoV5van9UdCuNHc1Qe?=
 =?us-ascii?Q?sCmX3bvZWwkKEivXPtsWJsL7l6CQ+ZcYXO9MP+6iccT8XcoL1Kib85jeL9kN?=
 =?us-ascii?Q?Pre/tMNWThijylqabFzMDVaMjBz3tb9K/WHdMMVUhmBbmkSB09GZUQ/Z6KGv?=
 =?us-ascii?Q?Nt6nzd9xLSP6FGKfmp5UGnpS8QxbRGMAjLfrRsQt//fifVx841/AGPNSmVXk?=
 =?us-ascii?Q?MshXdN6It0IXCfyeuabL8ALz2hkJPRKsjdfhF0tc3Ah+ib5g3S+c2Yfac05g?=
 =?us-ascii?Q?gnTVrl48NrtDPw+o1FM+pzsMQp1JaCnVf7btuqXx711RmDPteAbzeBILcBhy?=
 =?us-ascii?Q?5EvG8URvps1zPy1Kblxi0wP4V2YOAvtrGBetLiwL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33e687a-1eb6-4966-ecc4-08dbce47c519
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 12:59:44.9023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3YGFVu3WaskzEQNonhBvaEFiySxQa4FZ/mrnLZqRbrE2ofxhESyLRzZGKzYE6uRK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 08:58:42PM +0800, Baolu Lu wrote:
> On 2023/10/16 19:42, Jason Gunthorpe wrote:
> > On Mon, Oct 16, 2023 at 11:57:34AM +0100, Joao Martins wrote:
> > 
> > > True. But to be honest, I thought we weren't quite there yet in PASID support
> > > from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the wrong
> > > impression? From the code below, it clearly looks the driver does.
> > I think we should plan that this series will go before the PASID
> > series
> 
> I know that PASID support in IOMMUFD is not yet available, but the VT-d
> driver already supports attaching a domain to a PASID, as required by
> the idxd driver for kernel DMA with PASID. Therefore, from the driver's
> perspective, dirty tracking should also be enabled for PASIDs.

As long as the driver refuses to attach a dirty track enabled domain
to PASID it would be fine for now.

Jason
