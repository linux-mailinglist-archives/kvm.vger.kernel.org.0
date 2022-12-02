Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E778163FD34
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 01:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiLBAkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 19:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiLBAkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 19:40:18 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E99CB211
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 16:40:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSCCvckNxCSP+CuXqbR5menCvOxrwHT2zobFMEomFNDmfoNfBbRqkNJjGZx3oAuWstOEz3vsIV4gksS4/iHjY9Nmw6O22VzQsl42Eml8eGGGWvNj6WipuKkSrokGcaPYBeCbF2r8k9rWUlPRJm6DiSOn/I6UXNHwQ11pbpxqraqezzW2faRSfFYq8LzVYzaWiDkvU5p4MASWpAJn4fRu18PoST1XhjbLwIqijajzGGpG82/BSFV/T3yOmE7vfa+6DR8jMNk16mS88GXKONX8wG5P1EGg2LW+KokoGEAgT0zKNmlYMmW8yivSD3evNPCjIA6LGGkMmPClTTzSEGXMLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7zaGGz1rBl6josMkB8B2wl0wQUk9eTHyZDJEA8eqSo=;
 b=R49uOsB7VVa0DmS6FO+oguzDNHBhjLM551JpGrdrT+wRM6oL3Ax3i4s8bLh2Yoqxgeno+NFQaHNjN66hSyyoUh3SFfPrCisrfR/VOa2l0Jk85t75IlYNnZr9FW19AkRzZ20sBAYk2MWxiBV1dTKNqxAH9mh3RpZ8KkOVTKVDxVfHfbWEAXc849DYja52UcAf03Lt0plRzu6R34cG21fvzkH/INs2sMp6AEIxh/pa82DoP/yAX4RHeftumbYH15RWp+bPQ8wRSGmw4QwMmskb3XNpNn3vrwHazQ/I5rNkVjAxLwPkU2wHw4dUSYi5bib8FDjnE2R1t+Vl9HXmM5aDtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7zaGGz1rBl6josMkB8B2wl0wQUk9eTHyZDJEA8eqSo=;
 b=Xk6HhgN1bDvDtuFXt88b6tgZfUhKXC841UNBDfZ7Z/i5dXLcqXlxZFhmeGqQkcRUFujSIVEwbnonFVV4NJze/3QCBfBjXfXEiZF9RK8ytfXf9ffhr+I8ygJ5fpIvfmrtK/sPZpwVKDDPvnAwZKF+ALSe/nXkVYEV6DbMLkSTmF0g7nc2T3Zp+MAQ8ILsD/sjgvUSxMPTz5nBh9+wYbWVELIAlPmgX7PBZBCV6AdVGWU8CFfEh8JxAjWxZ0V1Nnaw5aI5U/E96bR3R73gRvTR4e3To2jV+1HmlmEz9DhsXhzH3SDhnKV5Z5sRfqGYWGR9slkMU8TDCXmcHkleI7MbIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8; Fri, 2 Dec 2022 00:40:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 00:40:12 +0000
Date:   Thu, 1 Dec 2022 20:40:11 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v4 1/5] vfio/pci: Move all the SPAPR PCI specific logic
 to vfio_pci_core.ko
Message-ID: <Y4lJaw8pr/Q2Sv1S@nvidia.com>
References: <1-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
 <87tu2fwe5y.fsf@redhat.com>
 <20221201165908.3a21a1c7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201165908.3a21a1c7.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0294.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: 49a3d86d-4268-4432-950f-08dad3fdc5c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7aQ4I81cz7+ENcJnvoevYfZ/IFpGdNc5ptN3Tuquew63AMDp0WA0qAuWRinAou0YgEjJS5BR5Hsh781eHk94wJsnPnVXCovpdP+dtVVHuz+VhqUAFIRzTw6ufKWxyBuHUPdUIpjA8M1cHpLgniQRsLGC1HoPRUibrdMNT/xSbqX266dT8c3AxGm3JmxB7VLpCYyGNCG4tiK1DSPm5Ux/kIVuAxg/Ij0FGZ0m5IxmKiLFCytvPmMWDOhpIbnvczAg4seZDRRUJCW1Z5QLKFefIqew0UArZTM1i/bZ2OpFr1whidLzDMIgT/YfYlP9Ne3leGrjNQlOLpkAg4I9PHitb/TxRJ6puuukVzeV9i05+MBegyrSWFtOVqD5rzl0V6L461kexabRYTJN7J24favy+yWmW8MjlUKxUp7XnshTbYYJEkj6Wj2H1onfHpmLZUAVpqRVNtuGE0iWkGw/iQ6Dt7y0/yaa+BTT9FjajnX3pEQK0jO7lHwUwGhssXIAjeW43vwEtkctftobTkj1A3cR/13ohL7hZQOPW7g2bHWztCjD8wtGUOrO7PDNfGuLU+vnP36fj36TYSp5yH6t0L0jLkpteEIO6cocwCmEg8bGl9MmwLU3rvpbZOAqKEHhyHbxvjMkMktuJnmdrviZMsiNhCS6GyknwMM44s69DqSZ5SznvQZFdjUHZZy+L6c+dm7TUA2XjpUbrzjUJ53lbICIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199015)(54906003)(2616005)(6486002)(6916009)(316002)(36756003)(86362001)(38100700002)(83380400001)(186003)(2906002)(26005)(6512007)(6506007)(4744005)(5660300002)(8936002)(41300700001)(66556008)(66476007)(478600001)(4326008)(66946007)(8676002)(33290500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V6NGhivsfBEfRRUcLFsO0V1kPeKcTZ1gkAxw+5COjEk+exx5pU0P3hlGsACk?=
 =?us-ascii?Q?TUOhUSjHYwDYPo3fvxkF9vdjEG/C2n5POA2oYi7DemThyvLb7MenaLAl4rCb?=
 =?us-ascii?Q?Q1DjPwi6pqLVZF6xqXCGWv1ldNSAGKdxRQkqmqUccVtFNlODBLNuf7vpqad1?=
 =?us-ascii?Q?G0qmVytuwCaJRudQ7FT41WGHnL94Ji3yLfROh65mriPxOXmZK5no88AHZ6WT?=
 =?us-ascii?Q?giSObe1YcaI1R5gKarwILo3oo1g4RNg/5CzIRLZQ6yrRIQWaFydPpA6SGsdU?=
 =?us-ascii?Q?tdE2wt5n+d+qVhOyHOyS1HH8oCy8c5qJekckIs1G6j/TOcQRMnBQamf0Uva2?=
 =?us-ascii?Q?tKgupjkowDz+PiSHKtawLq2Avt6+C0oOivxzZyb2jB/xV+LejCxz67BoTQDa?=
 =?us-ascii?Q?4xfG7nz9q3KI4WHCbTa1tPOLX2h6rWyg+X1KSMP7sfYN4Dd1FjI0oSlKNLX/?=
 =?us-ascii?Q?EWEej8nCCkR20NfwdX3gssUpVF02PZjB2Z+7rCm8CmD54Dm6rUAJca8pkOWi?=
 =?us-ascii?Q?9VgkgXHn5eKhmeWqSRDuMBdnfM6JaEcXIr3qyncZFi5s0W7E4meXmjLvqYt7?=
 =?us-ascii?Q?LeXYYLHX4ytst90aX4F56EDvdpv4TP+LZT9B2D5WWnPReQur6ZC8d3kBWe3F?=
 =?us-ascii?Q?2Vkt1s0s6X5wkykEsKqGUXM1p/4Ap5IcV9Wmd+fDqVfOsPBtJM4P17oXs/Pr?=
 =?us-ascii?Q?4ISlDhs/TcAnyex4htDHdOeJbg78GGhSZhiBPAcDbHmLWbbsryJsD+YcEHmS?=
 =?us-ascii?Q?eRjP+UcVKNdh9BreO8yXrccmBG+fVkBQ9MXNZv5/wjtDmK2XEUEnZRW+m6aN?=
 =?us-ascii?Q?JbFxlEkV1o7j8BW5V3rYCQDEI0esEXye7Ht2MQBlidjNQveMjo08qwUBCwcU?=
 =?us-ascii?Q?cP/uMppu0q1+J3QmeHHNHgC9uGl5OFGzmVhKu1IkDy4DHqHjl8FR82FaRF1X?=
 =?us-ascii?Q?UpJgu4YVN5yvWH3QOkfufuvDhNTDc0djB+puhkSEAqt6tBuHmhKR2zoYgGhQ?=
 =?us-ascii?Q?v3FS9Qy48R64WRRBSFFdIMx8mbP4X5DYxSipo4gtjsqZHn2Y5HSF7PzQaW3E?=
 =?us-ascii?Q?QxZrSVgwLNaOygeGuZAz6qcb4AFqr+ZqmRaX6royNM8gSqwWl1KyO5jzIpxi?=
 =?us-ascii?Q?6OCMrkdF66sJevyS4kv6FpP1+T3R6EPJpjQDVJ18lzi/Ch6wT/8RwCWZR9gn?=
 =?us-ascii?Q?UOXLK2NvXoZpbq11bim13qrgDrF7Pn6zS0EWYS65MAfDCptHggHHzQBNc62G?=
 =?us-ascii?Q?cclwVZ9DcE1qB+3/LXOpKlXG/G+tjT7ugxdEjrIKnDiyx9i5TtBFzh/zeHyo?=
 =?us-ascii?Q?SCJfh+0oqy4i32ZWhlJOcWfG7wPM0NPNLI34x9UUTVf311G9T8Cq/3IlW6ox?=
 =?us-ascii?Q?z2IPLo/qe3WDIspiCr+7LLSrE3Y8YEinlS/enYrE8FFDqzmClUJ5SxCHycrO?=
 =?us-ascii?Q?mKo5Wjt06kv6u9Yz95tvODSh+eYmeRI2xsAze5a+CU0XDm0ouOSzXxCGQDux?=
 =?us-ascii?Q?eu6Y5gcZ1uazPo3A40WErOVbqxij1syYKqdCK3I1dco4vXQTK6wq2163+aQ8?=
 =?us-ascii?Q?vMHIy1eNrkaK2HKYzAo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a3d86d-4268-4432-950f-08dad3fdc5c7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 00:40:12.6130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gFylJpX0dcyKP1LXsZao9GCnqgVV3YdPh90unRNQPc1GQuuBCdzBU0pN0uFBLcW6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 04:59:08PM -0700, Alex Williamson wrote:
> On Thu, 01 Dec 2022 12:34:33 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Tue, Nov 29 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
> > > around an arch function. Just call them directly and move them into
> > > vfio_pci_priv.h. This eliminates some weird exported symbols that don't  
> > 
> > Hm, that doesn't seem to match the current patch -- the only change to
> > vfio_pci_priv.h is removing an empty line :)
> 
> s/ and move them into vfio_pci_priv.h//?

Yes, and drop this:

> > >  drivers/vfio/pci/vfio_pci_priv.h |  1 -

It is a rebase error, I didn't notice it.

I made the two notes from Cornelia in my branch, I can send a v5
tomorrow.

Thanks,
Jason
