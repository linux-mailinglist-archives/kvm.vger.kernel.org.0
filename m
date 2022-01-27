Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE8249D6F2
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 01:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiA0As3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 19:48:29 -0500
Received: from mail-dm6nam11on2082.outbound.protection.outlook.com ([40.107.223.82]:25568
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229510AbiA0As2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 19:48:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4lOMjcdSX9XuSMhGgTVGHkoZzGHgn5MycMlZ8S+2WjU9ZLAG9jseptH0XDZGRlIY7R36CYyE69dPgRWEXQkxjeIdwS4CD8m3x27QDbUVrT4Q8OuoiK61w8Jh+Ur9ogCtfEpbnap/vZ4jm9rskycOZNmct5U8xlf4pQzDZQ93uzfEBw2F8IRb93316WzQKEQE4tGMi5J71ZQW16Rnk2zQGo798gN1ED4umytYxGZlHZ+tr57EA6wWWMkM0PmTdx22hRPkE1fnFtVDjugRd42AJqxJBr4OG3Dc3S6RQ1chXJZYZEVt115HyebAvxDBgQendcINobDAVIUGQyvo+6ruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJYGIIdg2DF3HE9aF6d5GzULmzLzFOHaed0x1ZGnyaw=;
 b=oUc/297IKszH7DV5+GplztxGpyRlOjf/3y0OzTzgnHaWPZ3XfZg1HquFyEPA3Becmo++1ye+gcEURPBfeUeRBdzc6jGJyJGt2KggjYaN+0yD242hxS0gyvevtvUqKbHkWILovwi47oRg9I973zy52QXLCzdefP5TEz7SNt40cAlWZKZQ3UwxoP4qNliP25KL6TxDRzSwIFT/w+2+ykHzLe21VCS3mUsl5RvypnndjB32CD9jxFUqy7Kup5BYGrDSVv8QIVIYyxoLit56gfJc9neSzLYNCkYfSmzTmpVQbqvyUgyaZVcjFG73GXJaV2rXEvKxSZi9kBFvHEtE6QGP+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJYGIIdg2DF3HE9aF6d5GzULmzLzFOHaed0x1ZGnyaw=;
 b=TqarbiuZkX1+xY5IEk+T6orjut4hgQyNdO/rgV6SAby4GLFeZPDa5t7AyJODXyA5f+2SiZwNpGz9MdeFeod8CNWgCoxV8kiDGuji1vNNXH1dk2L/kMhDDhOvgMBj8qUCJdrBq4pIQR653RsRfr/Lk9Nb50Bn8HnNswE7o5k4JtiOpAfJ5Y/+2mB9FqA6ub4P+ce6bIx3LyKlzB1JKW+Ynysc8qycndosB+7uXxo3kGnpniEynGWLFb1IZQrDuYjnt36B+07yYWAQrOGTq/hupvkabcQHWnQio/WsKD3u6PUH7wRU4y50L5hYn3bXxYEacb45T8BbL+ETCd+oz1cahA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM8PR12MB5495.namprd12.prod.outlook.com (2603:10b6:8:33::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 00:48:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 00:48:26 +0000
Date:   Wed, 26 Jan 2022 20:48:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220127004825.GV84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
 <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126121447.GQ84788@nvidia.com>
 <20220126153301.GS84788@nvidia.com>
 <BN9PR11MB5276826AC416E13B62AD99568C219@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276826AC416E13B62AD99568C219@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0175.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1175367b-d10c-4f45-5769-08d9e12eba9f
X-MS-TrafficTypeDiagnostic: DM8PR12MB5495:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB5495ACFE41A94AEC60BF3477C2219@DM8PR12MB5495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F4nu3/JkDA/e7N7oV4dFlMkEuCG2NnnjO7tYT9Txq5dbYh3agwnCUnsaHoPiWGTON5BOouLpr5KyPAklInCTjqXrHxWVK5smb2QIdpyggYEtmORSldl+AcQRoYaLdwmMd5tAADMRpcaWO4xZ+vCz16CIn3PwvGzcSfkzRZ8t8iiKxeus+WPJaZhT5WXFAkmA7ju5bw4SzVGYeUlI9Qf0/ISrUKZwkO8/Wa4Ad9aidZ/e8YCBbHnFDONFyvL9mnRpxiPa0F7iemkPfYAhgjZwXunE7BlBS4EbFB+Qcsi2qpunT6VVug7tx65V/zRJ/P867gSsCBOVevrmJsvokrqAUKGrEdj9WsS7PGpqH05Mo/wC1sQ5rNHmd1qQ4JbVsU8O8bFmpox0hpmcTTRp2qTDIxep2Vp8aQib0G1MazdAO4lUKIa1iy9bgJrttPEEWqx+9n+XyBtVw2AVH/AJFRNyYazHq/VFuZJ7V40sspd+2kaZSGlkB1zjiKNwa8xYpV4UlOVFOYQ/yZeFopzREjtiT4MhVsH45RKS4GSjJcMMj84X23mLq9NMLSExFyYm7hL1nzoIoCWzQXmPkzUQkpv/IWIuljEXvdn15Nybt37N/klFgeArl6q4yxABm2M4jBvFFc4swmtj+eXx6tPQCosYEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2906002)(4326008)(8936002)(8676002)(1076003)(6486002)(5660300002)(316002)(6506007)(2616005)(186003)(26005)(36756003)(54906003)(508600001)(6916009)(6512007)(83380400001)(33656002)(38100700002)(107886003)(66556008)(66946007)(66476007)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XYS7x7btwl/a29mQkhbzO5rjjca5gATAN+cK+2/Fam1kVJCA9VzGlIMkbuie?=
 =?us-ascii?Q?AtvZsjSwBtjKRu83oVU+26qMnab1wq2vywHW5pC1e6IMpxVJHtb5V5TrXr9O?=
 =?us-ascii?Q?EDY7JVEuNoKyASV3DWec2ErB7Ni++iQAxlj72QyX+6mpQ6pZW5/EYZ4oxVhI?=
 =?us-ascii?Q?CAP6aHw0xdhKZ26j/i9J3CCMtIs0Mcj2Wkec0TEG4UjaBz6ehmxcDRwbgjRa?=
 =?us-ascii?Q?AMswfSZnZOsMesPxjnDkWTCBUU4liOTT2eSaK6tKN/5aCY15h/h47XoKz3w1?=
 =?us-ascii?Q?S2My0jZavJTIBSqWZ54R+3bThacIoobe2idArPBlos1fGMw3xL2EWZKyKQc3?=
 =?us-ascii?Q?Isj6tbyh8RuUhbEJVQ90yYcluLnxJ3w6v9NrZc4IRySnUotzrC+AXMkgN7tv?=
 =?us-ascii?Q?dLsXjiwSFk72fb4qbQg9lToxueHGreRPmN3P4qQeKUpq9hH4DnHzPIWwwafF?=
 =?us-ascii?Q?AFDOEC/Y9a7TM9fw8VhMr5ah/ZrDZ4O3TnqL32Y6P6OusSVVDoDHc5cYjZD4?=
 =?us-ascii?Q?iR0JYa11vZyaAa7oaZuXa+eiArkgCk9e3YWXH7QaA6bkILrdgZ2UoE38oyMM?=
 =?us-ascii?Q?Q5U6nOZFpwEO9+rBJhFA+CKO5x4mFSdSARApdacC25SnG+2t6cVfy5SrvZfT?=
 =?us-ascii?Q?7kYIBO6l21uJomv0wC6s3VZ57wFzitxGlGZNbelCkDGzgaTtLyE4qoPCPzGk?=
 =?us-ascii?Q?srrAbg38m5oOjCFPqZ73C0Sdvd9FOwieWLGelt7U5p1p3EMbts8gyBzSVPON?=
 =?us-ascii?Q?G5g8FZM96EquAVygMMgu8OfYWqNtWbotIj4AGQDXzHMQbYYvWkhsx1dNplLR?=
 =?us-ascii?Q?zwZwOSiD+sapHi3zpjwKXF8ggp28HzWq85Xe0PFDfDNNORMysDu06aSJlK36?=
 =?us-ascii?Q?QYGBQTR/Up98sQW7MEE0LfoPOqFDuSUzhFa6Kh0BHYNtEq9uZfe78tM+m4/7?=
 =?us-ascii?Q?NZ6pO8LP+Z/tw6ZLvXR3TR3aPwXrQwgJjhHyBJzl38y7uUf7AASg2qv1tvq6?=
 =?us-ascii?Q?EBnv/q8SeJ2pOj8TbRIoO9kOsRK2jk+EN9azK8Hw1j466qVNl954gnEQMrNv?=
 =?us-ascii?Q?wOdyM1cNY+uGl/pkHbCh8tgmbvI+WSNtWbkmNYJ2uid25V5tVWZh14jnq4eu?=
 =?us-ascii?Q?/LEe9NoqskqtpWio2gpoQlFQDslwPpth2e742hZURD81jrcdeORt8VYfMysK?=
 =?us-ascii?Q?QKj/VRyO7oCnqlA6dTTWu5nFd5O1PDGa+6bjpNJn9qYpl37GgbXUvqF9e3wX?=
 =?us-ascii?Q?rcAAuHncSVUj8EIB3x+4c5Vvp1G4TMCeAkcaQkO+OkBTXEPYh8vy1fhwu8q1?=
 =?us-ascii?Q?Lqd95WfU4qEylH/AhHf1igxmNvoBJH2MRDt/w+Em3DHMTdKdEjFbMFIk4GmW?=
 =?us-ascii?Q?7sjwuJYbROh63wfQLoDIFjMX/QwfUoFkVatc6KDS2E1Wm99ZuMAddOft2Syy?=
 =?us-ascii?Q?i5I9C+siV2NbmKXJ6/JmL3y56Tulzq6H+5ML7pGiY/vBBvVnXN4ZF4W+7m2H?=
 =?us-ascii?Q?ZW08WZDr3f5Hil9MfdJGbwlRLCyD5TRFZ181pOzFLmV68UAXBXpimWwxdF10?=
 =?us-ascii?Q?kJfVH3jzGTovXw2wJnI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1175367b-d10c-4f45-5769-08d9e12eba9f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 00:48:26.6323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOdKvJYpvrByS4iTI3u8bSuuJCxLlSRK+NzNDMn98TBCpglquma3rQAWwkI+AP7a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022 at 12:38:24AM +0000, Tian, Kevin wrote:
> > So.. this vPRI requirement is quite a big deviation. We can certainly
> > handle it inside the FSM framework, but it doesn't seem backward
> > compatible. I wouldn't worry too much about defining it now at least
> 
> Now I see your point. Yes, we have to do some incompatible way to
> support vPRI. In the end we need part of arc in FSM can run with 
> active vCPUs.

I still think the right answer is a new state that stops new PRIs from
coming, I'm just not sure what that means. If the device can't
actually stop PRIs until it has completed PRIs - that is pretty messed
up - but it means at least we have this weird PRI state that might
timeout on some devices, and better devices might immediately return.

This is even quite possibly the same HW function as NDMA..

Anyhow, due to this discussion I redid our v2 draft to use cap bits
instead of the arc_supported ioctl, as it seems like it is more robust
against the notion in future some devices won't even support the basic
mandatory transitions. So we'd turn off old bits and turn on new bits
for these devices..

Jason
