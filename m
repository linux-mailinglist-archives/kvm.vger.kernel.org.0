Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0633668D8E4
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjBGNOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjBGNNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:13:46 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::60e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6769F3B0C4
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 05:13:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0C/DaLAPLTNTpKC1/Trsi+HPYk+eccKlumiLEXuaUTuPuNioYvF5P8AFaR5bthpRYOmfbBV8Q+S4vLgVIHM/Y5+iwpWHVHyfApBGKXV4jkIsBGM+qzPvCCWlUjP3k38As4qt7HkpI06nGjoDNcshSkFvPn9hQRSXsoVkvf3f9bJYaUhgHOzkgDez63ubRdBCiK+as1bB6R1k6OSj6j0U05ts4jBxX0dUql6fCYuGANCasHKlk32TpK6oYqpYtvbqH/9mcsUOByzEeyhI3xNCCIZbzA3l2m6SVXa7jL6EYsrIFo+noMySk8DUTvDls4j/dSTlboZu2s+4fkzbs1H8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uChaeRTnadVVjeAr0JKwkHpVQCIv4hWI8T1CWnKtTA=;
 b=oZkNt11uT7J//3d4vTLjGyHJ85uyxxoe8611MONi8l4+z9ZDHuDH207NvWhiS7mCX5eHUoym0fB6gxTuu4qCC2bchaHRBl49/uGnArophLUy04yjFmoGPBd8+4clUAwHRfOImBQ+QlbGvtxBrlYfTkC5dgGutvVy2z4knXjhRPPyEq1A6VmatLutbAdsZ32H2GncF1yyPPPKQnCy4AhHoJ1PDWKOb1Ky2fZWNqmWhfVnRDZI0EYu1dHkg0JFHbvhbODRIGnXr9TARk9w+IDZm5aRtgEoZWn17TNk+nU7qnYH1Thl1fVzQ9MSGiucb+EpnJbqL7EFVG6ojSidoilgBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uChaeRTnadVVjeAr0JKwkHpVQCIv4hWI8T1CWnKtTA=;
 b=UAbVP0QcZeLkkumAzrXPCUCqpwvHGYrRuTJLH2gT/l3wX9DAvHdXWtP/GqDByrNJccdSnqdpdjnptldWUJ++obuZRego4VcT3VaBdWwk7DuH16S9A3bdo4Q+0yabtYa2Ki487uka+seSdDETePwvL/KcqD2i3PwfNH8u1U1GzuAnNWg7+y88DpaQXB3a0qLmUq/de+u8joUZMTMvYWwDlEptGheQJ94NQ2qUnYsvMl6b9RRjKuW/LofXaPWzxQyTZNJkcZJb/ovu0EXNA4g6GmNgJJ3x/4c7Po36JBABVH3v8e//LDRZTYi8e1nBGzJWE8Zjnx+aPui4KS3qHfHsug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7784.namprd12.prod.outlook.com (2603:10b6:806:317::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 13:12:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Tue, 7 Feb 2023
 13:12:32 +0000
Date:   Tue, 7 Feb 2023 09:12:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Message-ID: <Y+JOPhSXuzukMlXR@nvidia.com>
References: <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0031.prod.exchangelabs.com (2603:10b6:208:10c::44)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7784:EE_
X-MS-Office365-Filtering-Correlation-Id: fa8fe85d-4c16-4bba-c89c-08db090cf89c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7kRgTjEmiQzXo7tx39iJCkJQgculVShxf8mikmVZ4pl4E4dp2stEB8o/qkvuKJZ4E1ZZ74209rJwnoB6RXyHc4HnaMlVM8cssv1kL5FKCkzwalfc78cM7PeQez2KrV4u0xLVKJNfewRqDKCRj3jI47dtNmQwjK+mGhukK/BIlmyeQZtQCglNCzdW+ipc8VVift6fG6qBPO7W3qdnhNohV8WmImxDtH0fQOfy59K5VyC+Whxd5BdJBcHZPxdCb1P/Lvt5RMDOnVbmcgwLk62ZkBVV1fyyEqVSMtCno9/H2VZlRLZHXghOtE+9P8FJOqzEA7N4VuEL3yEGg6GCU2JVSynuPkc3mm1J9UeLi9HK/wAn+282JUmUwTe/sm2rTcz7lL0t1cjvdOWLDTnnwpQNxOCX0ExwVDz7VSZ7uyuY631ShG8OeWHmK2xDqMvC5gpnGezWGuwRToqVceZH6P6m6E3uS1ceLyaNzDmlpeoZgH1ONhG6GTdTwVsvJ+DV6AzN21F5KFhncg95FXpFPm1lZGz2ueFdIvyyE3ZUe6cFvnY6YC6MC1h37bhDSxU+V7wTqweGwLapE8AoR5bJZwon1rfAjnqc8ox8gfrr95kf+B00cohWAvmH/bMWEauYVBIOJHrtlmc4D36ZOiCnWkTVz0j9JzYm5/ayYAl9j1e5bapge1xiUJp1rjsWfdJGU53T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199018)(4326008)(66556008)(38100700002)(6916009)(54906003)(6512007)(66476007)(66946007)(26005)(186003)(8676002)(478600001)(6506007)(6486002)(2616005)(316002)(5660300002)(4744005)(7416002)(86362001)(8936002)(41300700001)(36756003)(2906002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K4yeB/prNpvwLFst6Ubi9X36AiAmP8YtLSzfqihAnEDbf8c9PvaGD8idBmIz?=
 =?us-ascii?Q?pFzL4jafgXJpkZkr3qwdqBRD46NV/+6zjROYtjxicgoGOvb/WHyyf0f769/d?=
 =?us-ascii?Q?w5V5GH8ohqcu6iafMN2aRQPVl7f0aVie4M3X1XqJm7r9+ATxPG1UX8Wczdah?=
 =?us-ascii?Q?mvZUfXnm3DBD0eOnm1rSv2mN5iPJOn8XhhMG/r+sDoCsEMi/36xkvQzsy7Rq?=
 =?us-ascii?Q?NM9yYudsN8iT3/fDLV6dMAtrFdQVPpZY6IryOTkCKR8DvQ0jdG5aJG0ucKp7?=
 =?us-ascii?Q?bQ+hDX969Ru1pxSPXAz5M/IvuHS8100w9pFbPCfpmLHw4jFprnXUB08n27Mt?=
 =?us-ascii?Q?ULaWxssJiHafEg+RhxWFX7FIXbCjR9zLsHdikGXjbYI/2PIkcb50/93tGaqH?=
 =?us-ascii?Q?sRvptYUceG8eHtGQHfy/x3qV8NdgS3OeOmCdndBO5G8NoXobGJ3X0vZC70F+?=
 =?us-ascii?Q?S6vP3z8WtgQIeaIVOhvHRHOWc2daO4F/oSBbTyWV8aO4e4CpLcLbIcEYDl1a?=
 =?us-ascii?Q?ZxAQ+EfdunaEBw5huFcS51P9CBOruDMtNawUU22HKpgeFyCFs8HVZiL2usHS?=
 =?us-ascii?Q?qKc/hiyf7ML3cbk5jJorC+VvwFIZsYL0RXh02ZZVnBkwUn+JUjrC41LPAny/?=
 =?us-ascii?Q?VOQXdluRn2+yCHVmH81sxNWwiSBynOygB2MX+BsI0hENS0caa0VlR0ujdcyu?=
 =?us-ascii?Q?7Qj8xBpj7M9kIMy123olWmwHuHMdAt58uj7LxnlCwfkXpmZP0LTFuIMS5crq?=
 =?us-ascii?Q?4Y3P1yAOo/VuP/h9iYgVr2VW9d7xE3GeOZDUN+SjXZ5qP6mIKwdaehVTcfZD?=
 =?us-ascii?Q?s25nOAcd8iYFTP7emnDUOS253ywEz0nGma3UPx+9wMQzIaJmUKihvGxF9bA2?=
 =?us-ascii?Q?oMsHXwj5Gs3x9uNlXddpoMBe7fX7q9hLiY1UbGLZO5Pmef9cLmo+p9RmL4cp?=
 =?us-ascii?Q?AC2zQnyLdQlaCoX/GIXWQx9u59xcN/15JGebiVPeVIF90n8RK+MLLWsjCqc1?=
 =?us-ascii?Q?yxXCJepg2bA9FucVs0E72sC+1HJyOXstXyYR2vbrbkA/WpMwUyqs0c4TCmMN?=
 =?us-ascii?Q?h0jE4Fl9uT0mKJKPPFB0u8ME//KKnVju7tSWbu6tbryAmZ6XeMhM6B1KnBj5?=
 =?us-ascii?Q?NWbj/9FwBClD3kL4fduOlpUWNWOIlMhXATs5JmQiwpgIo5GB7Jn3ZZlE/jqZ?=
 =?us-ascii?Q?WDB3kM85JvPd7rNFECURP9M0oDP8aIBFwWipZseJ0fOOwVvyZFzP9V5niV4W?=
 =?us-ascii?Q?GsHDW1iVjaqmP5rJC3QxUXzT1fC9rq3zBDJnU8hlwbMPyu3ChLS7N+j1kd3Q?=
 =?us-ascii?Q?QbYtdepXxtov0HLIuBuINBVHeYptpm+maznIJe59sWl+JrYCRyHK84gTkAY1?=
 =?us-ascii?Q?6Y55+SbOU6tqZ7ZZRCUaxBEBjwbe0euu1HLorqz9ZswNfPI7rBIloI7dnXRr?=
 =?us-ascii?Q?qvxDvP59oyu4a5HrT7qUQ7T3YGuwBdsHbEpaklOPuWR93xP6FLg0DONRSJYK?=
 =?us-ascii?Q?W/olxFerkCo00qTzFjX6CH/eMQuI9whlBFIud9teDMmcreqnXQGHhD94kx9C?=
 =?us-ascii?Q?PZMZCu2S1USqqe6MvcMR8WtWYIiDMC/4bKiva1S2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8fe85d-4c16-4bba-c89c-08db090cf89c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:12:32.0214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9QZpf0B5P9r89ClBNTXHdFUHb8Sg5nHKE0Pmomn14HRVWkGSx9GiQ0TINCiyDleN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7784
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 12:35:48AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, February 6, 2023 11:51 PM
> > 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Monday, February 6, 2023 11:11 PM
> > >
> > > On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote:
> > > > It's probably simpler if we always mark DMA owner with vfio_group
> > > > for the group path, no matter vfio type1 or iommufd compat is used.
> > > > This should avoid all the tricky corner cases between the two paths.
> > >
> > > Yes
> > 
> > Then, we have two choices:
> > 
> > 1) extend iommufd_device_bind() to allow a caller-specified DMA marker
> > 2) claim DMA owner before calling iommufd_device_bind(), still need to
> >      extend iommufd_device_bind() to accept a flag to bypass DMA owner
> > claim
> > 
> > which one would be better? or do we have a third choice?
> > 
> 
> first one

Why can't this all be handled in vfio??

Jason
