Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444897D3B1F
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjJWPnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjJWPnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:43:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB68610D
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:43:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxGjqcJyo6pPDXsF51WOv6XAxwfwANFpnCtcJRkd6UxeLcOStB/UFTkCfGQ+FZqqZ6FgHGYfq72HAnwaeL6IA2iSW/CyiSOUHnFYriw8RuIYCM1tgpxdCBM0LQ7GkuIwwYqo1B5g/2ynPyo5zePhREpkFKFIfu/xhhT37U30psnGkq5MN4ab2y2nS8DB1xyhLKakznv9M0VAY0FWAiAqwvigE36pyiG0oQFlnOtc2S4hgCHi7akCSe5eCvg8NaaE+QMPuW6wGdxrZZLEMxNQoajgvVj4LLGJy0WtnuOUiBN3VUvTa+OYjRZ9h1+Uh3R9ha5+3yEJ2PkPT39b2Bqk0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5rhaly6cXHcyIVOBIrAon6khHs2nkYCGBPuPmpVKNw=;
 b=VAL1Xf0QUze3YMstEvpF5dZvtF/5gClIvsP40q1IAxEujm1QlYaHZOjWr3mBH34kJhfmbT0tnnifVcX4cihtvRW9oswbmkL5OnrtN9iOMLAe0n6mMfDfqvvxWE/lCj6DLMUf4h2Lk9GvNqmnPKmm8MM0GyfkmFA6lGL/EpurIuInG9RKzuhzKZ5ITRCPqZzHiQvrkg3m9S/coKt63jabEfNjroBD3p/EYn8WpQtCckLdw1YXpzilC9HFbLe0hE5qY2CbTkLwvYc5uwwzgPRid5OXp7rTGEEzfK9wtOShfLRMwm43K143kIvv2cVD/0054DbNUW9/WqWER8QIVunhaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5rhaly6cXHcyIVOBIrAon6khHs2nkYCGBPuPmpVKNw=;
 b=tVkpdoWHfZMzzh20YbIHV0AIGvkU8elhWH123Z+1/PT2pSGKazrgG2sdlHwv0bnPpkC+XtMsBXGsUYVDZ2ZQcdalx+a7VIEeQ1m2YQd4UEDopPsePoXAC6WMX7OvpgR/k9dPiV0xAwzHcvQV+ivgywrQWeYIRjfP7z6bMMEmddERyhoGAC3Ng2HM6FFIHeAsEBQ7UqTzNgI6wsv3ubGzSdEqIqXQJop6RB7Q5lGW9R/EZ24PllzY7bvMaGvGFpbOfxwPJvRQqC9doHRFZkjMFDkol0kQrf/7QUMIASl1SgnW6e8XMllyOg0IeZx8RJzZrhsJ05YJB6LS5ZQRdtKoWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8019.namprd12.prod.outlook.com (2603:10b6:8:14e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Mon, 23 Oct
 2023 15:43:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 15:42:59 +0000
Date:   Mon, 23 Oct 2023 12:42:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com,
        si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com,
        jasowang@redhat.com
Subject: Re: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231023154257.GZ3952@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
 <20231023093323.2a20b67c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023093323.2a20b67c.alex.williamson@redhat.com>
X-ClientProxiedBy: DM6PR21CA0009.namprd21.prod.outlook.com
 (2603:10b6:5:174::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB8019:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b6dce7d-54a6-42bc-68aa-08dbd3debc0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8shDm2nUmAL1CpKeZAtFcMxWdcnUOUMIylljTksMiOCRNziMe2UWZlmpLy/qp6qxQz+jwHciPnaqVH0nR3UTERny7j8Svt7rbJi1XYgU+ol4MIpJRr0FAPAANIxYctKoRZT4Eeis9Xfh0iOg3c9yohqDYYHav7uDIMCLsgeBD3RZl8omxrxT5go64J6ysPXjP6GUA4qveAKnLKMm5L+6oEH2wQu+PEnpw7qlImqHxCjdi/gozmSnc78Q/QwHhXNgC3vkFKm4VDUQ24YN44B/3vf2kAgb9ynpgKZz3fzlw3FjCaBjnFiuUQZu8kUl+l/JfOu+advvpMt9muskyKHOg7rvJTY9pOPIPrzP8t3w0tZJoqnorPOW37GuJB7P2TfX7wLORyFSwOkMV/OrP8b5FVhQhHm1CGyrCohJuoEKaYv7qBFq69tPhYFGnfc9+wb7mXfhkAhmPbCQTUYG8R3XpkVsI2B+u3NdGhH6DzjJ81DIlbLl5jJBJRTe6RqtJJFx9LdBXOQWI+8mjmil3MCs4XX6IC0n8nqQPcR5ybtNGXTPXkV9pObxrqhrmD4ACYWd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(136003)(376002)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(4744005)(2906002)(38100700002)(316002)(6916009)(66556008)(66476007)(66946007)(6506007)(2616005)(478600001)(1076003)(6512007)(6486002)(36756003)(86362001)(5660300002)(33656002)(8936002)(8676002)(4326008)(41300700001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LMUTG3hM+8CckwvSlMP2caUGI/e/I5jquCCTYogMAqeZZXZ9Imi1a5McwLmW?=
 =?us-ascii?Q?7gDt8Tht1dqRSESrsSRR2EHOH2DOwl98j1d3tR1rMuCJajFomT47rEcO9cwA?=
 =?us-ascii?Q?lxdqbDjllDpX09A2bRVyv5cLid4NBT5gywprFY8H0b3JTChSJ7wY8On4B+Lc?=
 =?us-ascii?Q?bHB5DDFBHZHF+mHdb1CRgHJGhx/25cSjs7tFkk/wtiigUyMSwpdmm+Yy+Ck6?=
 =?us-ascii?Q?bVDgQP96NWUWo2T3L7Vg8ugObOvzx9dVz++MhkGmV0S4w3M4Q1BBoJGmt9E6?=
 =?us-ascii?Q?YocJTtaAnxNh5khoVIRjSbwnHQj11+ed3sRcRluHDLutQmeSHJmZFTH6g8TW?=
 =?us-ascii?Q?/4thuokbZea4upJFI0QEJeRSjYbKdsER32Zv6Rgil09dhPtUO5jAC6wlnRWq?=
 =?us-ascii?Q?gHvJaLrHIpERG+0kEgDN0JMbXy5YhYucRoOOp6sQkYmjDDRd7R3/uC/FggBB?=
 =?us-ascii?Q?Ks1e9bkbwwMqeSSQWJn8OsUtQrBJyKmavYBzuYUk59JLsfCw2+w7dzz45H1S?=
 =?us-ascii?Q?aVa1bYnk/fKSNWlmpTOC8tL7vKNRIvSnhpjx1g8PFkYLw8+nXeM/MWc01uQ1?=
 =?us-ascii?Q?iyfmkelaJGg6T1rsTFTsUozF3roZbs7O29ObR/hw4WG37tCT/kC7idx03hUC?=
 =?us-ascii?Q?PBQ6xdopgosoN3pffoECoBUPU1AubNtzoSrSjQfQfOHEA4FOjP7kgBO8vuia?=
 =?us-ascii?Q?mxPX7OHL4MbH6ndLJS0lowSza8MZI6dSJPb55jdnasfe1ffxx3umFfgAijOG?=
 =?us-ascii?Q?F/8/ukiqKtobX3XrxKn4TCaEpcVD6w7Zy1Q045NHajwFZ/wgY4mYzLfaTR/3?=
 =?us-ascii?Q?gKsfZRarVgMIKFoPqS+9FFjwnpCMTepJpSlSp8ukxqYWa/qSG2ObEOmNRM2O?=
 =?us-ascii?Q?kO+ybWY9R19R7hXoWK9ZZf/D44HGW4CN5NwqrQEtXIZKlFyqMBClh8FfklXw?=
 =?us-ascii?Q?f8uw6aYSfIEZ5kDuMy6hyq3oPyMKyDSpVFzDxyMbV1wiFFzawtiPApuYis2w?=
 =?us-ascii?Q?+bFCDnZT/V0Dx/OO7JVBh5ww4BqbTNqhovEj8ci4hQ5G9eFdJsEJoeCqUxt6?=
 =?us-ascii?Q?IhIKfZmsjOuFTBiYndBD930LmyLaqX/8phvw2r9fu3dK4hnCZ5cytCsQqdt1?=
 =?us-ascii?Q?SqphL6fQUwZMz/xyZ3pU2KYkrHhocGXHjZogDd8fdU3MjMtQsa4MMoLE19IJ?=
 =?us-ascii?Q?nZbb3aOeBvXGWCDlaGbeOvHRjA2pX23RYktMOCWTsDNeutH2Vo0BF5pdlISJ?=
 =?us-ascii?Q?X59/oGKxham0buk0vysaUgQlE1S1x59Ohj/zfpTd1Uu+XDVLcXwfMtRcK3d4?=
 =?us-ascii?Q?o4H4lqMW1ElSADzg3LEXRF4ag9bleDpsALmA34HT65/LQt4ZS0FQdR64BKyW?=
 =?us-ascii?Q?kFWX0R2rMVW2yV0nSOQgnLiVawlrxTSk/wpqqxKo/5aNjslgTP/P/wGH8lcj?=
 =?us-ascii?Q?rPdWQLfUTF6sXoGhMQJfwf2UXTKVK4PzTa3+XJ5fGyFbYIviXjk+0pWFNFhF?=
 =?us-ascii?Q?rdx8tp+FQXr8aaXG/4KrcNFGOvDX91YnrRR7SUIYYekhimpn2bOajyle8lM5?=
 =?us-ascii?Q?nVLJkuKANQDbW8ojeskDk4j07ywellmJ0COO467b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6dce7d-54a6-42bc-68aa-08dbd3debc0d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 15:42:59.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZehS6frVnJSHiHskmJcNfaOF2fse1C65I85nkteuRa5FlXgFvVlAcgvfskaWV31
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8019
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 09:33:23AM -0600, Alex Williamson wrote:

> > Alex,
> > Are you fine to leave the provisioning of the VF including the control 
> > of its transitional capability in the device hands as was suggested by 
> > Jason ?
> 
> If this is the standard we're going to follow, ie. profiling of a
> device is expected to occur prior to the probe of the vfio-pci variant
> driver, then we should get the out-of-tree NVIDIA vGPU driver on board
> with this too.

Those GPU drivers are using mdev not vfio-pci..

mdev doesn't have a way in its uapi to configure the mdev before it is
created.

I'm hopeful that the SIOV work will develop something better because
we clearly need it for the general use cases of SIOV beyond VFIO.

Jason
