Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D4D5294BC
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348978AbiEPXLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350232AbiEPXLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:11:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84A72C116;
        Mon, 16 May 2022 16:11:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iM3cjPMlzvXXV+7Ar24ZAdx0n2X37bl7foqjJCnyEkD9s+S5QHycdNXKxTtshd94vPzTY0AHzw3gqcnuAzdcaYIPyj0sXGORTvYsr7U+KEPx/EYgwCEBAqX4rH559FpX0fTIocbQniVZHJVb4qyfVlyauaqsdsrrrYz7VQklKZVirqLpDAGLf6M/iiZhYHBypCS7qeul8K2PhyrH5CyQhBDzNkdEjqWHLDqiuTTE3VS/J9HoUOapJpniePrIocb8/G1qgbPNOXqDUBflMGXdRYiaDQcInmTicdOjiJblbt3SANFraEs/piyhCLz2d4IWb2Kqjuw2Ffp5KRALYmSvOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hIQexNaTLuI1z9JTOao/JdZKEw2dmcKtSbiB7VgGabY=;
 b=JL/OqHQB9fffYgsrJGUu+FVxD/epQxpSIpPv39PWbgy04+q+pW1w9zvFa8tAgc85wtlwhpvrlX94CBzfNQH9195n+IdqjoosGgtk/dIpr/9h4BWqlx+1DgVtXZ8u8zo6rwdjbMLXri0oQWo0clWAkkXvHKn0MxZUM7oEvyhWqHY+IwkUEbDPpuiNhOAeFHZg2Auc6cyu9XWGDuK/cpW8N+uoP/+67ns7y+2hvwbpd0/tPsNcFMvylbSi+rtnKTfQ84+ZzbgqJDKy+woFwhE8cZcSD75kvqACyORISeZM64YTVPxQqg4iS3MbcVAZBu7rEZ7C51NdjdEzNE8JnxR5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIQexNaTLuI1z9JTOao/JdZKEw2dmcKtSbiB7VgGabY=;
 b=D+9Xvl22MZy7GKNIALAHW8lE4AMdF0JlVUJv7Frx3a6wpugjy0EX/du9nhtNNDXrkgaHIsMkzMEH7hWFi59rFR62xrWGPVkPDu4u+SAAAyu9OOfgZ6x1E1EmbtOC6NMylDdCp8FiJxe+KvRYLBvjjpYXCbb0+wltgViBZkugJx14/uZIFRDGb2GYsclsNrQC3EbDxG2QzTGsrgO4X/2D4AjTMuZU+EdDs57jEfU2333QVD7dyhYxbC0mjwNkkFabeOlhoRjErTkmc0ihz7RE0qDUxVEB2/Ys3uhEVT/dBQoyeJ8IGBuGy3+9S0xPnxZ/U5UP0VUM+9u9VJpdb32NEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5948.namprd12.prod.outlook.com (2603:10b6:208:39b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 23:11:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:11:07 +0000
Date:   Mon, 16 May 2022 20:11:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220516231106.GQ1343366@nvidia.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-18-mjrosato@linux.ibm.com>
 <20220516172734.GE1343366@nvidia.com>
 <7a31ec36-ceaf-dcef-8bd0-2b4732050aed@linux.ibm.com>
 <20220516183558.GN1343366@nvidia.com>
 <20220516133839.7e116489.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516133839.7e116489.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:208:d4::41) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed4726cd-f740-4899-f5ee-08da37915bc4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5948:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB59486B172D61B925CA6E2B82C2CF9@BL1PR12MB5948.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmnZLxx9IqvVA/4XGZXwmCJE+ECz8OwJdAOJPC4dp7hvcQlofugS9pFWIW6a3nHdLCrU5OFohgT7hoUPpWHNpFunU3mQkFj3zDojzQ+jM8i3QTu4ox0qvmvRXPA/dEzfjKblZ1d8hBvbegGR67VUpYm5FGwbNTQgSYUJYHPsdZz4Q/HBm7gEN43YGD32F9+ITd0iBsC0lm/IrW2oeTLy02YszCFr96ToIIACCMKN3iiTQuCLFyFR7RXUyOJ+emnBYysOWGWOncOKHt6e+BUMsHuAnpUFaZs/A3EiyQQmX2Wcq8KnCMPHYWxom/lso+2Pcp9b3RsgbzU6NLDMWq+6FYAe9fW5fxz/bhayS3Gt8xGyLmxh3O/FsSyefvqq+uME30E3q+k4PlMNEke9W/lAWHlbB94jI5J+C82jsr444xRZYgQiO46FPtXgEXI6YJKUgV5T6Zr/Nd/te8FHY5n+rTwHTdi3cwb8vCHFUAni0kFPmn0I37RiSNJcDQWKl2bKnE4WwZXwg/r+M1IaqqZ0C2SAF1aM1lZCsL0JE9n1jUIfGM594bQEr+thdRjHkT+ATjFPvVdP5akxd6W9Ud4h7hGYaPgLhV87rIoSexkDZuWqp8BRvpyQD6Mmc6BnWctlPFxD+noPnbB05SHklya6d39brMDCQDg0a9hTKp6rc1pGgGjPRQGWso/CN6smDBpOyYj8Yyms5EGIvRxG2tPK+Vux/bbAlo9+WT0caMID6Vg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(1076003)(6486002)(5660300002)(83380400001)(508600001)(26005)(8676002)(38100700002)(66946007)(316002)(66476007)(36756003)(2906002)(186003)(6506007)(66556008)(4326008)(86362001)(7416002)(966005)(33656002)(2616005)(6916009)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BKPAzHcLCP0NSizlKu6eRB/a9D1wCDxeVgchrHQud+/RcoLG0kYhhVZCJhiV?=
 =?us-ascii?Q?LjSIozloLEIhNiTN/xSI/2wF/n2jrRR3Z0JZbVMiUYtmMi5TzzMCBcYJnjvm?=
 =?us-ascii?Q?tQc0E6LlRwWq72Uq33V51YOID6JxVm/jkfem7ls2ze9W10Mi4xIfnBQ1W0Q+?=
 =?us-ascii?Q?otv5uobI1PI+0VjDIMa98bctqz7rVn9OYG97FRNIRotz9JHIsyE6RkD7j+in?=
 =?us-ascii?Q?rZ+di915Mb9k0tQnSXFzKlR234K45AWVuWy9NQa1zfeRsdfiraaDO4VFbNS/?=
 =?us-ascii?Q?7lyyWONR+bQAfRA2QQi55qaHFiIruwu6ZZGKac0ZhtARSajQdYbrkGNhKKQo?=
 =?us-ascii?Q?F99OrUQqHhHU/03R+ZSye7P5cBAtm/fNBG1HMhYd2lN3ahcqziGdgRS+Zrxj?=
 =?us-ascii?Q?96Z4Z4GV1mIEsZjFrlheCkuSO9W0F/PL7nS63OFKUFn+0zVa4TofRDeXiL/x?=
 =?us-ascii?Q?T6NtbWYmz0hYzhQRuat4Qp52WPbzzA645PhidZ8tcParn3mJR4T03FnSEe9v?=
 =?us-ascii?Q?bW0nHheJW+qS82vhkRQjwofKeGMJ/4sxcqOILx/tVEfUsGUOfR8L9ciXZylS?=
 =?us-ascii?Q?IDdR6SyzwvWQosb1z5ZpY94Q5zHfTTDwlVm+b4MSNiBfu4Q1K/DsYokZZMZR?=
 =?us-ascii?Q?kRqtFa86NFDeGKIy3YbPVEmzM4W+KjDGkz9CsYI5aF7gumHCxfkOLPBz84he?=
 =?us-ascii?Q?yVjTc4329EYtrPKsQR4Xv4WKeQgLxE3J0BE5RChCvuXiEf0T2Ke9RQBu4bOa?=
 =?us-ascii?Q?FPFTmLQp7Rukhb/5TXxwfAds66KLElsN5lkFfZSYyIlPe/rQhBxSzl2i1o1U?=
 =?us-ascii?Q?ZryYROk0uRmllSpbBbEyo8z2KMvIbnR7QXg5ChJSyq767nIqmaSUmceos6cj?=
 =?us-ascii?Q?tnxTkgFPChPfEkpGcLWbAILqpvLgjHd3kY4k0yLurfJjgnJ8yEdEbtXbq0VD?=
 =?us-ascii?Q?tb74Ey0CEc82YkDyw1ZxcZsGlHk267ecFj0i49By9OfEMDpwrRqiNon+DDfe?=
 =?us-ascii?Q?S2kIsrAFkXl7U7vB26FhJq1W1ws5pTGhnVhM8d/iigdVy3tymEqoUrrKh3yo?=
 =?us-ascii?Q?rgCRYBDKpA4DwIA0AEcJWF9wZ2v4mzA1IkcXD2eOu4/3OhLatf0t97ffezhv?=
 =?us-ascii?Q?6XmpPmMSBnc2WwMZzMEH14tDx3S9ptiKZzrNfpOLtTMlrENenLtKOEaD9x9D?=
 =?us-ascii?Q?67NAa1PZLR96SS8Y59RJUd63W1Kt5asBfHDruF7oTqKecF/HVovTYqV67ASj?=
 =?us-ascii?Q?CUGFGXZ2aj8qVVAkhpxc9tirtcY5n7hiByp5aSN0CT14Ntkap3HdmVD9/GVQ?=
 =?us-ascii?Q?vBbyroIoUXP3hsx2C7L1bkZWZjIZyZgDrK7an+nRHkx03ITUL+kWxFtJhkN9?=
 =?us-ascii?Q?D0vApRL79p1mU/dr9gg5uNxS3vDc8fQSjlgqz8ElLcas45ZvwtjGtKCJdIXW?=
 =?us-ascii?Q?pTle4ubBp3UNtIHwxOpGWahxZcppPRzVNiekKtO9riyBRMuh/oEZ5Lgme+r7?=
 =?us-ascii?Q?+h7wxXLRGcoBphh+vZPTMU6Z8KkQWi/VGVAJRYNi+u2LprRwcfaQFRIIG4iD?=
 =?us-ascii?Q?uPmBdLUuiXP72fmVymMwJ8mef9mJcIn8hlTxQgntrD65lOeo7aCwBmQpeLIO?=
 =?us-ascii?Q?VVmpDK79TLPvpIbKvGJnZ/Q75VEMqYCrref+hBp7mLxsDswZgvXwwdbP63+T?=
 =?us-ascii?Q?vqvIzF35oKcXAKFw2+hhPV3Hv8b/ieU2cnTtTKpUraakyMWrzTuOnd1hYeP2?=
 =?us-ascii?Q?3amA4t/eIg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed4726cd-f740-4899-f5ee-08da37915bc4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:11:07.7016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OR7DCa3+3G/v6/ZquAMcSosEgnl/1v2ucpZu1cwRy2ml+B9f09sriGoNOZoTqNGF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5948
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 01:38:39PM -0600, Alex Williamson wrote:
> On Mon, 16 May 2022 15:35:58 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, May 16, 2022 at 02:30:46PM -0400, Matthew Rosato wrote:
> > 
> > > Conceptually I think this would work for QEMU anyway (it always sets the kvm
> > > before we open the device).  I tried to test the idea quickly but couldn't
> > > get the following to apply on vfio-next or your vfio_group_locking -- but I
> > > understand what you're trying to do so I'll re-work and try it out.  
> > 
> > I created it on 8c9350e9bf43de1ebab3cc8a80703671e6495ab4 which is the
> > vfio_group_locking.. I can send you a github if it helps
> > https://github.com/jgunthorpe/linux/commits/vfio_group_lockin
> > 
> > > @Alex can you think of any usecase/reason why we would need to be able to
> > > set the KVM sometime after the device was opened?  Doing something like
> > > below would break that, as this introduces the assumption that the group is
> > > associated with the KVM before the device is opened (and if it's not, the
> > > device open fails).  
> > 
> > Keep in mind that GVT already hard requires this ordering to even
> > allow open_device to work - so it already sets a floor for what
> > userspace can do..
> 
> How is this going to work when vfio devices are exposed directly?  We
> currently have a strict ordering through the group to get to the
> device, and it's therefore a reasonable requirement for userspace to
> register the group with kvm before opening the device.  Is the notifier
> and async KVM registration necessary to support this dependency with
> direct device access?  I don't have as clear a picture of the ordering
> with with direct access.  Thanks,

With the device FD there is already a zombie state after open("/dev/...") but
before the internal open_device op is called. This state ends after
the iommufd is assigned, then we can go to open_device.

It is reasonable that the KVM would have to be setup before assigning
the iommfd to the device fd.

Jason
