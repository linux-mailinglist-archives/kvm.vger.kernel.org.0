Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7623A1385
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 13:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239589AbhFIL4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 07:56:44 -0400
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:63361
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239571AbhFIL4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 07:56:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcRvLBnjo/JqLzHKt7q9KHdSLodEztUr1DCGdBggM+ugDDQKROcQq21crn3j/N4sleKLkNVxf1hkgvYEY/Bi7YYxzD9gMxalNJxq+fge06FoAw6eqGT3421Vvzx0R0MO6SbsJKE1RRBssTTvCKDl+CpO14zMv6QOR8J2VI/8AxneYojNTiy0R7aj7slZB6P1yriOqw8PaGMTqy1yYwOiZ6VemdPmbAGasfYPn5yezPN8ys+DaxLjsvPmx+kh1SNNE5wBV2JbX8a7DdsLh6uSBxbdXU1G8zkamWmxSvSTD4/1BqXiRqZWTSD3pao4MOTo3Z6TA5T0VpdkOIy39Reufg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZOHBVw+CQnGZTCP/vGYEqd0YQ9EDpjdoQewIjXNN5o=;
 b=SUzyc+MdwqIgc/YSKgxeuYftJ4RCuSab0Sk5A1LwvBXn0Xkb6jmKzWT/w35SOe+4XcvngXu9lA6OPwSQDTN2kv7K52lOc6McVaVY9rgwtmVyFTskcB95uZgieBorImkHACC3mSP4pVFUspzXadDkWSaaMjNpA40Gw6jHX5CUF4WDf8zDLHfbMBdddt4ZUjGXhLhjg78c8/MgHQEwgEVN/IswAtkVI1cMACzhMGZVgClEBGJtMJYQQwW08XSHXFNLkx+9Gvox81aIoRQ4IROOew0YjgyhO58kApYGLMCXL7zT6MBaVWtz3DAs3CFdLnsWBTSZg9JEV92EfXnWYqjOQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZOHBVw+CQnGZTCP/vGYEqd0YQ9EDpjdoQewIjXNN5o=;
 b=uXsNAxQjn0YZH2Ziw3GldOzXP1orBPmZtFeLi1qeYd9XuEHDIBT09qLxzKcenodpZ066TPCw17sYmJgavPBBOGdG7AgVJlXUT06zAdWYSiOP6WgAAmF5hGJppS0vKyLaPYobZIyR9Et8Z2dkR66lskXNni1jBMQS6zf59DRs5NyKZkj50MCHHonSbmNlsRqxLL5ZCc4gAkq1/kZt3xD0A6E0UZQd29JVrTzYkyVW9KxQF/iWUOlsJIq0SngQie3i4AfPRYs85r2HzDl6nwf5MZ02ys4C2gHi7O//aCnhiJstUIiI4CyxFwQQzWamlvHbjYaYOz5vbTgx+xTu6yLz7g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 11:54:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 11:54:47 +0000
Date:   Wed, 9 Jun 2021 08:54:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210609115445.GX1002214@nvidia.com>
References: <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <20210608190022.GM1002214@nvidia.com>
 <ec0b1ef9-ae2f-d6c7-99b7-4699ced146e4@metux.net>
 <671efe89-2430-04fa-5f31-f52589276f01@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <671efe89-2430-04fa-5f31-f52589276f01@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0242.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::7) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0242.namprd13.prod.outlook.com (2603:10b6:208:2ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Wed, 9 Jun 2021 11:54:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqwnF-004axk-Tl; Wed, 09 Jun 2021 08:54:45 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69f31606-bb39-45ec-0e12-08d92b3d60e4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5143724E6A3F4E788F77F0E9C2369@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EETB170v9aq6IMCCiJsaQNZHvTtUO6DYz2tHsDflY1DMVw+FoNKx8kT+ofOqr/Bb9sRaabhD0qa5WGbLTbZcIJ6Mm/Vtz3mpnWHL14g8frr34WaNCVTA1LsHxPzhME5TfSxc7ENPPGYG7BO0aPWS1TLF//Sc/pVKHIwrqRE94AE3GYkPC6aKcBoDmRIZIgrU6PthqI6fQ8sB4VGmuhEPq+mjejpd3TB2KuwvYauuLea3GvqfmAkpfAHdl4+mADC/F0X9csPkdYUVEU1d0wktA6hG6djYWx85R4v0oG4+iIql1LIYg0m7W1RxSbCSbwBwBlfbc1H8gDxAWDlmxpgwyUPL9QpfmVpxGLb0LLV8+86rsBooYjjJffDXFoWGiF3r6VWhy89EPRE2HIB7l2Y/nMrU6XxU4oL3x9bx13WhelQkL58az0dGjGlXAXaH91f4T+PJ7xeI8kKe77NdNnpVryy5zJwIaiC1sPuUzNtHjx6RbuVEhHwn26RwedHu4SRjGBAJu+J4XXAJVUnhcooWWDL4KW1NBIIGCknpGA0b23s+8/QmoVKszyYcV4bw7/dnOM96+NDS8jof2X+MkKKRJ+g6f08pKX2S3/490kudxuI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(5660300002)(8936002)(4326008)(36756003)(33656002)(66946007)(53546011)(38100700002)(86362001)(66556008)(66476007)(83380400001)(54906003)(8676002)(186003)(9746002)(316002)(2616005)(9786002)(1076003)(478600001)(2906002)(26005)(7416002)(6916009)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BFNe7nv9qZ9dobv7Ctn9zByXrSAQtx5rOKdoYkSKmEofxyt0cos5l+kDmWY4?=
 =?us-ascii?Q?U4iGHbg2EkJxjORA81WiTSIo97GchtMvRWcgqwhVFHgkkvJbMiLYbsR3qyDi?=
 =?us-ascii?Q?67wwSEm4AHXHlB7N7c+2p08nRjAzAVHKpSmD0EX46WGSgAbgKxOw6On1q/wa?=
 =?us-ascii?Q?2ZYHTIsnDoaS41Af2/iZPYkK+X33YU8kG7Px72mLVHWdxFDti8uYc8Jc08eI?=
 =?us-ascii?Q?AQDrwds38zWDD8xlBG5MKWSOT78+mlfCTbjvbsk6/tj0YWsPfvKUP8fh7vih?=
 =?us-ascii?Q?u0rlkewWVfM7HSnSLgSQ0glbOyek169ANyhJFyRf4nOCe8qre32pJn6aw9y7?=
 =?us-ascii?Q?NaAirfKcTKFMabRHSYT7aawF48YcaRha76xmDy+2azLEbFfRns/gSWaZKsXh?=
 =?us-ascii?Q?aH6pg9dPGoCk4sDHW9xJwsfzb4ua+CEaYcUZ0ZsciuaLGFodzdKds1ooB5mu?=
 =?us-ascii?Q?i77cCj8NK4OSBz3s/PbDnlzm629V+TkI30fb13XbluscECvy0KKMikF6HfcK?=
 =?us-ascii?Q?ZlkVdqTsv5Oi83ltNgVxfE6iY7YiJ9hzj/G3mBHc4ORCTlkO7XKm0OEoUGa3?=
 =?us-ascii?Q?iRAGMSBq+Nct6ONR456r7OlOslIF1kksFBeIJuDk+JZo0SIX2cNHzZ2D6Sek?=
 =?us-ascii?Q?au5v8ruOuKKAK4jTeFL40GnEkNg1p61P6n8HeYLlggTCAeYeiNaHUQTurOKr?=
 =?us-ascii?Q?FGJT7KUAFBBye2jyB/leagvP0QnaWEQCLbia1BtHc6Pp8cGzk/ofLKLcOYWl?=
 =?us-ascii?Q?fDefBp/kz0dhmf3rnLxaL5v/oMytSD8pBDp+t944mE4Em/ey3NiuAgs9nMXD?=
 =?us-ascii?Q?Z7XzOP+Q7WXndlj63oac4J6nslqhq67T2A1shQGAVA1yLCOnsSXqfWq5aKPf?=
 =?us-ascii?Q?WtA1V/QgNwkffd6swJdbkJ9VNdUuTcdjgFvGyYh3EaIb+l+fZ3FL5EkjFPVN?=
 =?us-ascii?Q?Srq2JuB3x81Odee5T2V71ylKe581Beqed2IzajL5uR+rCDqnPOszjM8WSxPs?=
 =?us-ascii?Q?Bia6FEIdoKREALfuoZh5x4z+uMnM6U25iE251ze7ZDAH5A7RVx71iURwlRaQ?=
 =?us-ascii?Q?V+vsM1IqFFKF3fcY030uCWfe/bZbTRU41UY5AlA0usPqeErXiWIGe6Ldgls/?=
 =?us-ascii?Q?WdMePJbVV6qeBv72zogkjh43rUyxrAM3VVoQUXji7qWL1CUZTKN/gMAUug6i?=
 =?us-ascii?Q?HumbAG3oqRJEF6X/0EiZhlBn4zq3GWXqqyy/ERfT7kbZEHWWqkut6Exm5AXI?=
 =?us-ascii?Q?8ef7V7ebRdCFA7mxQm5gajUrs0dKdyVBI8zmzzZC1hf6kiTWp1sX0BNFk2wU?=
 =?us-ascii?Q?fgEqCV6AcED+YMUEUeTN0h3a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f31606-bb39-45ec-0e12-08d92b3d60e4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 11:54:46.9756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITOvXHn315u88bJIZP9WWqycyANNfEX1ICEdEH7JUfiPbJrYi1GUWc8f8SAXSxAB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 11:11:17AM +0200, Paolo Bonzini wrote:
> On 09/06/21 10:51, Enrico Weigelt, metux IT consult wrote:
> > On 08.06.21 21:00, Jason Gunthorpe wrote:
> > 
> > > Eg I can do open() on a file and I get to keep that FD. I get to keep
> > > that FD even if someone later does chmod() on that file so I can't
> > > open it again.
> > > 
> > > There are lots of examples where a one time access control check
> > > provides continuing access to a resource. I feel the ongoing proof is
> > > the rarity in Unix.. 'revoke' is an uncommon concept in Unix..
> > 
> > Yes, it's even possible that somebody w/ privileges opens an fd and
> > hands it over to somebody unprivileged (eg. via unix socket). This is
> > a very basic unix concept. If some (already opened) fd now suddenly
> > behaves differently based on the current caller, that would be a break
> > with traditional unix semantics.
> 
> That's already more or less meaningless for both KVM and VFIO, since they
> are tied to an mm.

vfio isn't supposed to be tied to a mm.

Jason
