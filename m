Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D2C4BBC7A
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 16:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiBRPvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 10:51:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiBRPvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 10:51:42 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92462E088;
        Fri, 18 Feb 2022 07:51:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvT5mITkAsl7mws9Yuw+8vN+p8XiKk79pXVOAjZbQ8NxZ1Ji2I6RHgz46Q4G1EkIABvjpWCc2ai6Cd4xGrT9KO1JKC5uhKziIJDWVHIdTFP8z6Nvpxy8kmw63v6u3m9ifdRCkWs3tv1IJsbIaDWaM1dFObVToOGydm4dgZK6rAe403IN5XxAnY2z1kstwf5jfYh+vcjjPxMIEPFJsFZRtMWbiO+t4W942nzkSzjMQegBlpwlRrY9PsH3oCrSFktgpQIH5dK9M+h0jAmg4nMs34f+t1tMUjuOLdfI0+GuQmUTXRr5N7Yc6D151A5Y7weZHfAT4ESF8ghvLqM79AecuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtxlQa5iLhCE0E4YJfAkC6l3iSo1wJqE9HIu7L2K5t4=;
 b=ab7OCFyooYYHpohPRZfyPt/FKA/9+RlK1tQ5PbWTE0IOEo6u4+NhUKiPGUebOSfDJV5gIwHwsYHY8yKaxcOMsJryKXUf0zuG3kjirXNjiYn87nJFaXkQkdsV0klAlNjkF8Dlr+S4bm8x0ZZR1nRXiUEPDXkk474wVVlh9pD+4ydvOh1YxkQJ/cYQpnC3st6kT7lyrohNFYAnTWYfHH2Iv4aSxOV2gkZuoW6R6hqsW2wJaiXsd4kXNf7r2IyCVDNrRobQgWeAoyVn07NbqoptCkqhVDPd8tIL9dt/pRBx7LRwsoST4MfAF897Eyi1j5QFChAQEFq58kBvLUkIfY6xcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtxlQa5iLhCE0E4YJfAkC6l3iSo1wJqE9HIu7L2K5t4=;
 b=ozWctIEL8A5mOTaE2bDcsFb1v9CVD9CXeNEHEi2gU7K5uoK4WW8GD1nk4SX/ecfrz+ItUUN9+GK/GWXicuWdgafxvXMjG/l4wmoj2SoU7kfv7/jmh+P7oBreNaASm0iyS3YR7K1ocmD5Z7RtmIqfAFANhLjS4ypv1zNTWseFKdHrP3ex9cDMdrQx40gOeZyaxM7mGY0nV5EcvNesbTEl6gKKg2tOLqkyC9GB55nPxfnD88sYEQN2ZkaFozaD3bInkWl9jwNbStJe1ExaDXOvQvmdEk9cgglZ+lNxidyZrVTHTCTue24tyjSXE4LRwhGTiwTjmTYkCj5P46ppn0WTnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4746.namprd12.prod.outlook.com (2603:10b6:5:35::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Fri, 18 Feb
 2022 15:51:23 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 15:51:23 +0000
Date:   Fri, 18 Feb 2022 11:51:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Message-ID: <20220218155121.GU4160@nvidia.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218005521.172832-1-baolu.lu@linux.intel.com>
X-ClientProxiedBy: MN2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:208:234::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b9fc67e-21c2-4672-a8c9-08d9f2f68338
X-MS-TrafficTypeDiagnostic: DM6PR12MB4746:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB474604376B48BF34FAC62591C2379@DM6PR12MB4746.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3rBBryg6u3PtZZa4hS3/14APltmOaD0CbjkQcBiG4OONW6rVqoJDuZlf1Al3B7MxwKIcZxveBOmw87MCHMtP21U0kOHC5doP3aYuWbYZVkqdHcubVh3Khi0KYJGWwtFdRXdmAuL5buki0hFaOJoly9LUNHRAmkHG/mgOmAekKRn1Op0ZHSeIGkXNqvvJxKzsXJBa2wAvrKZrwx92c6eExH9EXMrMKoOX3h5lDUB00sEXSnfsOTKu3xEdzoXZR6PFvdnm5Y5pLJQXpl9xNMeWYRMH/a1f4sDPFNjSmCkx5jn2tLiUNGZEr/pTdJkVp94nc5G7FAD10vqWR0FP/Hc3ROAuNGUwd+WvWcHzukuwJ+A9kwfcPEwmwvTQ0z7z/db5EeHnX4Qcxgl0jxyjZR79gK00p9wdW+99TOXaEALkj8+zpXoXxl/+17urPDDWHX23L/IMJWmwpQHg//319G3Kiq7gc0riACa/0L7znbGO/6pIOsY5n74xsuZCEa+OkBYu5JfF51uVxiHpoSIq0ocDl6N/T+hZswTQi33KL/ogxPM6hBlEE9CCHMIZE1FChxeJ9m4wqY6gqmRn34x3dcTwjTemF81j6lisKeEfW12czmCYlbTUtTmhjfk8YhXZ9l+nszaTtTCswmDfmL8FmyH3aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(36756003)(2616005)(38100700002)(316002)(66946007)(66556008)(6486002)(66476007)(6916009)(186003)(1076003)(33656002)(26005)(86362001)(7416002)(6512007)(2906002)(508600001)(54906003)(8936002)(8676002)(6506007)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gxMerCbYFWN0oAmu2Bnrcp+RiwPW/VSPhWkhcKrQcDOD3UVRBRVyl+ND2Nqe?=
 =?us-ascii?Q?tTsgV50Q2x8BqC4/6aCHL1qc8v5lGadQK1MoU0Osm97odmsUZyQFvfnzMD3S?=
 =?us-ascii?Q?K0SMKjiwRCvyiUjRtnmroJgJK3Crb02X3FybPtqgrnSrxI8Ne1Kv+lCH2KdV?=
 =?us-ascii?Q?412thtrJptFJprSj43s9lJ+CLfYKAn2lW0aq+ddU0sqY/qJI1Ui6rsvzIOm/?=
 =?us-ascii?Q?yQP5Gsl1fPBSJMObUhaEZs9lrcQTvSUcEl5ECh+2LNM8a5NVoktXZDq3d5Z4?=
 =?us-ascii?Q?HbU79tiA5VVu3FZL+hyeUtQcpkAIyscaX4E7FMe5A/qc37XKAwhlTy/2rn+/?=
 =?us-ascii?Q?sz5XySCC3uPI801tQjdvE4ZPeIugKOoPpsDZ4wiA63Tqh2udfv7FQswBLn3V?=
 =?us-ascii?Q?4WePv5FlLj/YYMG8O+V9ytmpH8QyM3HivQY/wg+lNKXx27OrOrVkhBYlOFWK?=
 =?us-ascii?Q?XReZ5SMPzuxZARjB5Gy1g8AbugmCtT8nnQVJWmxk13P7rJXMnYbTx4sMZVTM?=
 =?us-ascii?Q?oJclMRBxvA3Z2IUNU0u+qmwtN8I8SFVCmA77d77MsBjJrVHH1fzugVUr6d+W?=
 =?us-ascii?Q?QSbvY8G81CTAntMRudc+Afjh8v7epVmNc7WTRbQr4Bo+/TjbKhetCjMI4vpK?=
 =?us-ascii?Q?9ZWPIGaZgA6FzjVisutm612TSXr5sFTI9NYIO5H0CanO9MgjzAjeqb2rFqSB?=
 =?us-ascii?Q?k79xCj54yK/3Tjigvz5b/5+2Es54DJujPlQGEG0zG7tu4IfP+k7MJxtcA15o?=
 =?us-ascii?Q?NYGgM9SO4D3REKnQfFJb29/iaeVXfySTLOnGkibSrLBQqpSL1xp+YXhe9YfH?=
 =?us-ascii?Q?3tyWwfLr9R9FtPJm6e51AK1KWJT7cgypP0YTYisR2N8RiXqvsWgBSu10UuJv?=
 =?us-ascii?Q?LHEuZKWm02sAJSII5/VMAvbHXh9MeW7i2nT2cxTgh7BEZ+NhW/l/KZP+AN5y?=
 =?us-ascii?Q?aVRfUk+y7f7LSf0nREoL7bIM5ZrG55BfPC/ueTiGSupGqgKw3E7rA/QHFz1N?=
 =?us-ascii?Q?u4ahhKIuBxocraX67W/aDaPr26Ve40czMDfqOKBcvHddsQ4u6Y1n2HL7cFE2?=
 =?us-ascii?Q?FyfSMLq0pCS/POFmKqfKcleqKcVdwBbcz9FVJsF1XaXdUq712CgaWT+Lb1UQ?=
 =?us-ascii?Q?qj17i1nmUqjt07jiy5BBMKpB1gvto3JRfQkcHWbbj4HwvDK4H4wkFv52/dIW?=
 =?us-ascii?Q?H4B7vMcoPZSGkex/whv80TAgzQtywjTCDxxlZ455Iz3L/Oe+bQCsVjAdzQu5?=
 =?us-ascii?Q?Ma1rqrcaspJz9s7oYCk4f+DqDY5/iCee3ClfIdbj9Guum7q+HHE4TZj1F7nr?=
 =?us-ascii?Q?VX4Ka6C2Clvm18RZA2xdZUrRq5cNA9KgZSiHO+LbEdalF0DOhNLvPgsPXyf9?=
 =?us-ascii?Q?Hf6su5IDclaXiiJRwkpg5h+TPIDZDuTYN0qYnbCtJ/4Yvd1SEsEmS23pHv2L?=
 =?us-ascii?Q?PHx9QfIBAsi2W2EkI6pLO1E3zMsj7yZBHl3zc5TzfIMLR6TKeLLLUs9x7vEO?=
 =?us-ascii?Q?Zb8A1dlPZfhoygKQiOe+AXIlXteiZpg50uXLQwrbKWbhTFALggi8mt3bVeDm?=
 =?us-ascii?Q?C94Cod1RawrhuWYSB5k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9fc67e-21c2-4672-a8c9-08d9f2f68338
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 15:51:22.9207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbgIjW2I0m/9DRa7cVCDhB00MfO3dPsZva7keqsEnthywCYl5J1sPdTGj1SVTvjn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4746
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18, 2022 at 08:55:10AM +0800, Lu Baolu wrote:
> Hi folks,
> 
> The iommu group is the minimal isolation boundary for DMA. Devices in
> a group can access each other's MMIO registers via peer to peer DMA
> and also need share the same I/O address space.
> 
> Once the I/O address space is assigned to user control it is no longer
> available to the dma_map* API, which effectively makes the DMA API
> non-working.
> 
> Second, userspace can use DMA initiated by a device that it controls
> to access the MMIO spaces of other devices in the group. This allows
> userspace to indirectly attack any kernel owned device and it's driver.

This series has changed quite a lot since v1 - but I couldn't spot
anything wrong with this. It is a small incremental step and I think
it is fine now, so 

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I hope you continue to work on the "Scrap iommu_attach/detach_group()
interfaces" series and try to minimize all the special places testing
against the default domain

Thanks,
Jason
