Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AADE3E13E1
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 13:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241078AbhHEL1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 07:27:33 -0400
Received: from mail-bn7nam10on2074.outbound.protection.outlook.com ([40.107.92.74]:32608
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241022AbhHEL1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 07:27:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xdq8JHUG9KU7c3qn0WP24uYxcoshQjuXWe+rSsr/EDLfSrUf07ZUOcEsPM9G72vi7sucdQu8GKQmVFwUIHC753+tIZ/+a/HI+ADN0wdxmS2alDIIAbqSjjqGxSWTwIVwdORqQbVaig1wPBapR7+IxlRuS4lWLNgtqSDH2nK7ugkp/+nGN33gqv/amfPVdSlQ3J+7v4pyBr751rN7RgfPmhtZUxjgjmb93a1xeHS/eyXStnJQ+tyIz6vc2+O7ciq4WFAS6EOeZRD5TLRpu00WwC0nAmwwgLharTPVIAeipDY66FjUR5o9WNbROfLq9wO+EvLBsjzFLBNLATIc5+JTIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ABRnOqvn6Pyo06AlJXTr47rHRrubGpQns2+C1Oqcyw=;
 b=lGublZaKZUDukJFGyxFN38LBU7SqZGr4wOwDmxqe0cI5rTBDV4iqEEmXrlwMeM+fJ2IUfy5EaxMpK5mTRto1bJRwq+mCgS9XeEBFRy3mXUw6QVeUn6E5/m9DRx+T1usaUDqWfUSn6EemsuB1p/EFmqJWWfrs7ixhoDnon/FCTpovG0xxYd4MWvk6HIliZAHadEVk2zIAXJtD8vOEyH/7bO6Wta8PD1NbRl9+7VsB1yjDxVcE3+JPmPVA8ZzRyfv7QtihckeGPAW01kPzZTKE9ELFcJnz+WOdVfEab7mq0m02tD6sTe4iKbN03gQEt1IVmP9PUd7BUJDs4bAlBVoPTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ABRnOqvn6Pyo06AlJXTr47rHRrubGpQns2+C1Oqcyw=;
 b=jfQfSSo7Devzo9CRUyeJDX2gsn9Sy2IWO8pzuOC4hQqzLvkI1fECQeaRnkqY4drZxocBZKAQCHsg8xBYmBD+xp45YyeeanoQ/5K4rNOr+qEwSkEQI8n383iawmMaAVEnhB8WUV35nY38HFi+9qvxjTkZwxPxmcRYs7kZuJrAsXcZ0e7yUGQg9F1W2fVqdyn9ZYbMrpPSV/+a6EL3BMub0iKehB5zsnZ2pTL6Qt27OXQ6U1kIQWUqIbp3K2A8OiT2eAdxknlPVRLfCqWHTE8ZgKvgKfcUKkK8B/CEOnb3J/wq/Rnxly/rk6HTBOl/vR4tdjrI+xTNCL4hKrTONedk7g==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Thu, 5 Aug
 2021 11:27:15 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%7]) with mapi id 15.20.4394.018; Thu, 5 Aug 2021
 11:27:15 +0000
Date:   Thu, 5 Aug 2021 08:27:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210805112713.GN1721383@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <20210730145123.GW1721383@nvidia.com>
 <BN9PR11MB5433C34222B3E727B3D0E5638CEF9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210804140447.GH1721383@nvidia.com>
 <BN9PR11MB54330D97D0935F1C1E0E346C8CF19@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54330D97D0935F1C1E0E346C8CF19@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH2PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:610:54::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR11CA0025.namprd11.prod.outlook.com (2603:10b6:610:54::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 11:27:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mBbWr-00DDeR-DN; Thu, 05 Aug 2021 08:27:13 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f356322-5653-4d21-0c94-08d95803fa06
X-MS-TrafficTypeDiagnostic: BL1PR12MB5222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52223122FD3CB2D6282DF3DDC2F29@BL1PR12MB5222.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xHSf+ufjFjS+4SectuZQg9MnQ2HtFg0OoFovC7s2xyrOZRdv/mvCkJR0izLwM9OyTNNuKt+H+Rm3JTyglfdjRxyBv4zrW5mYz/uT7qD9WuV4Z/DQRSfbPyB6Xw3uvDkEiKxn/gbO4DpMTpnw5e7KH0nRXxpj6Au9nbilkMzn7InU7pEUBdodSehYEVwQJPEscNyOS/B+KxGQB6q0gTEugA0iZw2RbNMZEI+bnwpegeHrDKk2rQcAU8BJ9c8TgHW89bjnOU5o1WBhb8LmDFnUJDPmsYkOJapVYZLFnAeHq49NU67UWc/jZF5CKV9QIqOZ4T+8vMmQ1eNhgXOcoGJxg6JIq1Zc7KnTAC6KOV5ryeZDjmpBHe2AwSPPZxkh+IMbxlpLoqMt086AFoSWCsgffFeoT08KlQ6JEWSZkxmFx7Qd7lUPtYJVxu09aFHP0C+vfW6Ios0AruIAK7rYCug4psVAvNBwkwsdSciduUa+XIY+xN+BRWquvXNPYjKvLKkLkMvwZOdy6noD46elnFR45ZBRkgRRv8BQLAexuf1SNUdmhMRGPbbTeL52PRRpnZ4q7Mu2tBLn4jvcWP3gYqeks3b5cThlEf2wmMo3xNlAMairmWnOxm9Llk5PD7po/kKtd4WaOK9z32NbFXwWlfRnsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(9786002)(36756003)(478600001)(9746002)(316002)(5660300002)(66946007)(7416002)(33656002)(66556008)(66476007)(86362001)(38100700002)(6916009)(2616005)(54906003)(426003)(2906002)(186003)(4326008)(26005)(1076003)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6+GvoW2Gy4+xr5HRNHFTdO+JHL6kSYKN7scCRIq/+GfnhH5yL+mFcwgCaba1?=
 =?us-ascii?Q?jtDyl5C2h5KsahOxMAmiRAe7WZstNGkbJRjGBVBKYeYZHv/CWxR1r8HgXOxK?=
 =?us-ascii?Q?rm9DrWxUIDWD2P4Hv83rimjAzQAjr6uouuxlzN9kXOjwoGOx5IiEPGesLZ6v?=
 =?us-ascii?Q?8fLQlBiyEgPEUNUWryw/kQpe6liH/E21OFYOMYZIZHup9h5Rhn+s+Jn0i0j1?=
 =?us-ascii?Q?IF2Hfp4yaVwBv1jG23kcgoAjGcuyD5ymuPRYt4jUSn74xhfG4+ZUUD8vXkw6?=
 =?us-ascii?Q?6ndLxsGnivFBCmnj2Fr/REp6mJLFqrhnFz/ao6c8L5Q3QvP9fQvVKbkws4Z2?=
 =?us-ascii?Q?wgOGDMA6uqSWaWzS2C3Zt+l/d3WwzNM5BURkv2AaznrY90NKEFimqnqP5e+y?=
 =?us-ascii?Q?iWABYnjFG0JxpNvao2arPzBEcGR1hJnwFxBH0E1TgOlhFdlaCQ48mOyKQD5i?=
 =?us-ascii?Q?GatkQacuwqnoltyIIBODrU/P2Q/iANvzDD7/f/lb7w4h6omnIUdLexHyAoDs?=
 =?us-ascii?Q?JfhBlGGdysNKfqfR7G30ZZ1FmfDhEDV0ogpgslYCWjhHwU1ee3chxD7+YZlI?=
 =?us-ascii?Q?v42OwKRRJEQAuEVuu7ZkMdTDQkkepJ41+sLGhYyM3fdydirqu9xwZrAhyqp5?=
 =?us-ascii?Q?EH3krMdqZ4T32fvB+nqVWg5HMtbmBeU6Cc+XwfYJQmXRC+4GtcuAnfMg+PTD?=
 =?us-ascii?Q?RFLlnNvKy5zdsNG4MYGGu6K8wNrbbuk+4KcJXg8dDVqadULhtoN3oCaZlhLB?=
 =?us-ascii?Q?dk5xHC3LfNmuml+xBM5AEbzR1EzXeaUxam7BvjluBTwS0l3s22ztKqbOdLsK?=
 =?us-ascii?Q?+uJL4UJv+4H37UFBWFuCYOMQg0XuWeyB5erLJhbgO2Wc126PkPOavSOxZX0b?=
 =?us-ascii?Q?TruoBXGc9+vBzqB6s4NpohFH71xPe9s7ZCy3hTQkBM+GNNkCFEKhWmx4PX1p?=
 =?us-ascii?Q?YhkU3avswLPWAMPZC01ujLwowsVxeus6xI0hJ9ReRAMrYGrEyTKBx3+CV1rU?=
 =?us-ascii?Q?ovoyG3GCvBsBe6LsyhE9zGJ+jr9mzw45YYFjRlCVqq+SWvUjl18OIcjC+bhV?=
 =?us-ascii?Q?dorH3fBw9sowlrEotnNXItuSa7j1SFlw5Ss4eTmKBDVzicbreQHFelkRcDZJ?=
 =?us-ascii?Q?wc62+v4wQXJJk8DDl9oECF1KxHNIw/U1Y9SGW1b7CCYK4XEoon96hyxN452B?=
 =?us-ascii?Q?gBzKkT//t2ZVYQ2D08L39OVZCMm2xdLDnNc4IRCg0KISGTD+UCEXjGKhA+rX?=
 =?us-ascii?Q?dXngHW5afQpn+95WMGgGoRUhiiZLZytlVhs9UCOX8flVqgej30Jer4SfICgS?=
 =?us-ascii?Q?zVxrdu6MFL9N1d6Uo2OOM1tx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f356322-5653-4d21-0c94-08d95803fa06
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 11:27:15.5180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qOLVmToY+/se2ulBewv84zqtYYPzvdX0zsoeGivaVv0du+vmLuQFzkb7MNUpkvx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 10:59:21PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 4, 2021 10:05 PM
> > 
> > On Mon, Aug 02, 2021 at 02:49:44AM +0000, Tian, Kevin wrote:
> > 
> > > Can you elaborate? IMO the user only cares about the label (device cookie
> > > plus optional vPASID) which is generated by itself when doing the attaching
> > > call, and expects this virtual label being used in various spots (invalidation,
> > > page fault, etc.). How the system labels the traffic (the physical RID or RID+
> > > PASID) should be completely invisible to userspace.
> > 
> > I don't think that is true if the vIOMMU driver is also emulating
> > PASID. Presumably the same is true for other PASID-like schemes.
> > 
> 
> I'm getting even more confused with this comment. Isn't it the
> consensus from day one that physical PASID should not be exposed
> to userspace as doing so breaks live migration? 

Uh, no?

> with PASID emulation vIOMMU only cares about vPASID instead of
> pPASID, and the uAPI only requires user to register vPASID instead
> of reporting pPASID back to userspace...

vPASID is only a feature of one device in existance, so we can't make
vPASID mandatory.

Jason
