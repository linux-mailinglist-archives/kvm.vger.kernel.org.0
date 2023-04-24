Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C4D6ED3CF
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjDXRnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjDXRnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:43:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C46A41;
        Mon, 24 Apr 2023 10:43:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9zH6MIhbeZMhvsRLP/X86N0HvHuRNYl0ZAvuYg1I8yaZKTdT2gcnNIfNDB81D0npRnrEKyWpbeWdlTO/j3wd4kmwMPkd13t0R/aFhylV884dynpKDKq6plO+phdCbvJTGEFJkGblNREOc+BcxzL2BEriaiO0Tu6sazNYVzjgBxji41uBB/WooLGnVpRn/DmxgoFGOFB/i8zQf2WuBiHsDyOqQOoDM0LEaaKzlN1IExpgDMcFUkRTCG2YETsxhSI21A2QKLA/tEgcLwv81+OurOcYPb8hIWaKzyBFlhIZcQSETduiHWOd5ly+4ige7sekj59eJDfeIpgdWphLNgMfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X67y5HEXd7ceWQtV6Vb67T2ud9LQxbdhN2L54seR3lI=;
 b=UXlLu/uFGJk2vmo+zmenBAQ4vBelKBgujQAiGUkW06aNIXbkl7dDhib1sgytxXToEj3p6IpzFGatU7zFoLPf2OEHDb9Vd7dNsSMVJ9QQ6lWKLcGuyP0GoRnapZRVsIRH/9gYqvhoiFBF52TN183iR/J4fKdAed4g3fUYt0iJK5hXGeGOAECPV1adjWyCKJ2n4KX2GrklCUzlmtUz68+UlyW+I9niAPjaYIHb+9362DwgrFZr+g5IEAi7ywUxjiu1shEJajI4IeqgkAmOmyHsiumDOZ3MKt91V+lB7a5+DysbegQWSoRNkJvS5knHTYWzl6LzqGhj0/NPrHJDwY2nVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X67y5HEXd7ceWQtV6Vb67T2ud9LQxbdhN2L54seR3lI=;
 b=dcEdO2DIpHCgahCjnMs7iY/577oGlC1BwZJM1fG7EIZHmlnLMEXEqwT/bPjWLUqiBTiN6kIJcS17e2wTB4Fl3OrP7YJ1OO1ZPtePXq3bqsjmVW5yPxwId4S6DoNXD7RS+hIKbZiN4ec3ueXdqwkiIn4ggVRBgWH/4Nfb9dmLUimM0gwRjuVmKMWLAtlLpxXiTNNbQSCZXiJ2Uhafa2jduCVLBPPpaxHYfqnFZnl8JU1Hw6DnCWR6k8wxAXpcxvMhRPHyU2x6mxG4rPV2huy4jjFTEfLZYHk+k1+C5107dI7KfWuR13NGn8pcMZtzorUA7jpVDkXifJhXg3ImltPbuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6772.namprd12.prod.outlook.com (2603:10b6:510:1c7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 17:43:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 17:43:12 +0000
Date:   Mon, 24 Apr 2023 14:43:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 08/10] vfio/pci: Probe and store ability to support
 dynamic MSI-X
Message-ID: <ZEa/rTKja3Xpy/j5@nvidia.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
 <0da4830176e9c4a7877aac0611869f341dda831c.1681837892.git.reinette.chatre@intel.com>
 <20230418163803.46a96fdc.alex.williamson@redhat.com>
 <64b99d1c-073f-cbc3-6c5a-100fa23bcb13@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64b99d1c-073f-cbc3-6c5a-100fa23bcb13@intel.com>
X-ClientProxiedBy: SJ0PR03CA0057.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: a05f9bf2-abc4-48a1-8403-08db44eb6051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 16IwaGcn5NTREe3sukPbR6rq5bL5z3byru7UPV3/2f1Lrn+M1fsTg3gy+23l6Rt6v3imsC9gBaMuiB/zjuvrotJJgUcVwRKOpgQmI4N9YP51L00v3LeOsHWG2sPEvaE6HvEARHhSghFMOeWhhrQ8n/0kDSkq90vXldXD7SFGf0n1MbfQuodQnBHt3tZwaFiU4hl6QF5QBGHjP2K3YdCR+IKk1oQ8fdvvr8+34GDa7+z+PjrAxFKcwgWfEhqYQipFjcsZjrCWI06D63CfrBRJm9xSAdxvAp+M3+Au1PXoWZnzVnCXBz7x5jw9TzMP/0bzYFSo59jpDNmnHUp/woOu9TG/rA06YUUmdgrfycP9UmaIkBp+tGHQO0OT9pdh4Ys9s0t+58RFITeCU3iVuh1UB0LLl4lqktLW+ansGo1T5uuoJknkdFl8cd4Ceskc5yFcaGlNKSUCUk3SwC8fJi3lPUPpiskptncw/yoVyInMgn7kSzSfa9XNjR14xTGvJOPl2/m/2/wq3B75A00XlDpFEJLW6kasN0YEVOecSPlzqcN09PLA+C5I6IbCTts33iL6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(2906002)(66476007)(66556008)(66946007)(6916009)(316002)(4326008)(7416002)(8676002)(8936002)(5660300002)(41300700001)(36756003)(86362001)(6512007)(26005)(186003)(53546011)(38100700002)(478600001)(6486002)(6666004)(83380400001)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lW03yCBezTTJ3zuzaS+gr041ONAa3+VKGi5Od1WxBFuHlSFhKwvI3hGR8NC0?=
 =?us-ascii?Q?4gjgmwUkrNEqpbtukoELvFYH5jEIC0eQ7R+/QoFM/42UxyJMJaETCP0Zfoif?=
 =?us-ascii?Q?GToggM38lqvyMtm2WBEXHN7nWGTnhscfDtUyutFpb95KHUovxqsMKk4DCMkg?=
 =?us-ascii?Q?/xENp5XQuc+bg9kBRiHafOb89TlKT/hTLwUK6augUhR/XGlMqNsczP+VriU/?=
 =?us-ascii?Q?jHH1KAkQBNf1TSer+uQAyrMLpUX3gRUR2ZyLgqwpsj9lYDoIQsJfsX3kxXIl?=
 =?us-ascii?Q?9SmDauPHaysJmJKQSR4AG5qittAOwHsDvNIU+LC+Te4v+PBAy/YWQGN1b0Zm?=
 =?us-ascii?Q?rJrDFfEmomlbGHi+AuL4MwNTk+aZefykBvlSeASRoZjoxPiTlQlOKSQjtCcI?=
 =?us-ascii?Q?JPWOQdXe5HXnpDk+w1wHBUH1vKYQUVTX+dzgUUznh4Iv2LOq68t0OqhDR2x+?=
 =?us-ascii?Q?80LVHp3eiUIAROgds1vWaj86z3CPct20amL9M8KHDXhuapKk024IpZC49BXH?=
 =?us-ascii?Q?BXzPw2Vrm+23IO4LnoV+2wc3KF5No7ifzO/wuiMqvUPhWwn8/h0aeH3l/+PG?=
 =?us-ascii?Q?M5pozRXowLQt8HR+5dByPxrbpS92R2ZKS3SEVSJXPyzgGl5in8OnbX7dn4OA?=
 =?us-ascii?Q?nUZQKbXGxK97pvjV7itnd56/yywxTQJuMBTMSSS1vVv97u3u7f/g3ks4aE6+?=
 =?us-ascii?Q?58PuyAjlOryWUCF7T1CgvmH3YbQjIXxjnwX21/3GCOVLJOPHNRGXvkwipVE6?=
 =?us-ascii?Q?I/bTXPQOsbdaXsyfn/YXHQVW3ox4KI9kbpV+2hZmDgzbRMeLQPUs1Kbb+Dfx?=
 =?us-ascii?Q?1oS6ZJbTtpJZ2iCBKlPyDjRD8ctCxA5xRn6P5IhNZ0bBL7oThpP8zYKCPxLq?=
 =?us-ascii?Q?D5F7JGLvEFaTzLrzTbXhU9XKD28X6HK845trvhPt93ne8VuTCbiJnmdReXGe?=
 =?us-ascii?Q?ShaeN4ifvJ66WsL5sISxPZBnCkEkcUAu5QcVR6CRNNU3NJ5/rJRxn4hJzgH9?=
 =?us-ascii?Q?aKbOY1xPveT1iOfOa54egCMGi8rQOcuT4N8YRQe+c7g1xBBZD6SE44DSLlOD?=
 =?us-ascii?Q?cxwwzdWmHdmJVhcdwMdHpqXAE1KH51wNPMmK73GqXri6XoI0OB9FWIO0cXFa?=
 =?us-ascii?Q?cbklOYqJSlZNK0eXitAQwa0tAgDeq99jY0QHJh7ymSyB60cljoCPK49SriEv?=
 =?us-ascii?Q?26INDxcxi6JEWmFrnjN+zPeffOW7RE7hSCKYT33AQPLeOhRCuzhXa1Kbxh8S?=
 =?us-ascii?Q?EwtFWvH1kXQ6nmzbGz8Z8Yl9kdRFF3tdBAOsFOxiAKpT5jo2GaFe1erq1Lqk?=
 =?us-ascii?Q?IE21aP2qV0lI5SlM6stte1n1vsSyoi+mxLpphEPIrqg7gfd2hqqqmSdQM/fY?=
 =?us-ascii?Q?/zFOMKftjgbl82Ku1OEcecv8VsB3PSjPALtPG54PkZto8fsu8bdNKEuat/xE?=
 =?us-ascii?Q?BBQF2z/o7/ip+kMHPzD+TI80vUQA8OmmH1Gk6UnlKZxiUAFFkGJjatYtmPXd?=
 =?us-ascii?Q?HEASfd/lDK7SbEEHKJRI6gbFuxgFivzET2zCi3LVfc6CrvXzZ9IKoriqRiZG?=
 =?us-ascii?Q?RLQO4LIhQj3oghDryLaI6LLCzOMuDYHm+XJa1/az?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a05f9bf2-abc4-48a1-8403-08db44eb6051
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 17:43:12.9117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VqazF1hhLbY4FPJEusoSUDBQR4XKSbad5sVq7LmUUdgVBjQw2Mhtv6+/GBCL2Sa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6772
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 11:11:48AM -0700, Reinette Chatre wrote:
> Hi Alex,
> 
> On 4/18/2023 3:38 PM, Alex Williamson wrote:
> > On Tue, 18 Apr 2023 10:29:19 -0700
> > Reinette Chatre <reinette.chatre@intel.com> wrote:
> > 
> 
> ...
> 
> >> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> >> index 148fd1ae6c1c..4f070f2d6fde 100644
> >> --- a/include/linux/vfio_pci_core.h
> >> +++ b/include/linux/vfio_pci_core.h
> >> @@ -67,6 +67,7 @@ struct vfio_pci_core_device {
> >>  	u8			msix_bar;
> >>  	u16			msix_size;
> >>  	u32			msix_offset;
> >> +	bool			has_dyn_msix;
> >>  	u32			rbar[7];
> >>  	bool			pci_2_3;
> >>  	bool			virq_disabled;
> > 
> > Nit, the whole data structure probably needs to be sorted with pahole,
> > but creating a hole here for locality to other msix fields should
> > probably be secondary to keeping the structure well packed, which
> > suggests including this new field among the bools below.  Thanks,
> 
> Thanks for catching this. Moving it one field lower as shown in the
> delta patch below seems to improve the layout:
> 
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 4f070f2d6fde..d730d78754a2 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -67,8 +67,8 @@ struct vfio_pci_core_device {
>  	u8			msix_bar;
>  	u16			msix_size;
>  	u32			msix_offset;
> -	bool			has_dyn_msix;
>  	u32			rbar[7];
> +	bool			has_dyn_msix;
>  	bool			pci_2_3;
>  	bool			virq_disabled;
>  	bool			reset_works;

Also, Linus on record as strongly disliking these lists of bools

If they don't need read_once/etc stuff then use a list of bitfields

bool abc:1;
bool xyz:1;

Jason
