Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C859333CA7
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 13:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhCJMcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 07:32:09 -0500
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:37130
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229948AbhCJMbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 07:31:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afogz8bxTHFBVs3FRMinB2eWYFy2kl/DHZGsY3lMi/H/Zei8ZVx/r09Ev514NXRBF24f39WAxGb/d163jS3nXI2Rw6j2toVp/Yr1HQzLeIFKCt85tDZosvik89N8pde2xcAskgInMjm/S6RsYmVVUze7JEpfWjGO6Y9xnrICoKQPw8HVJUvv30rvcTpbvJb6PB+6N6K1NeZw3zgrWT6tOo0G7O0X5pf0hu1CKhadO6o+ugq6Cl/ozyMO7dqFRlw3+xIWw21ryTfZT52wMgvRJjnuv/EuYTSB2dswRnlv+tYdgTwnCMJT8RiNhUxaYkBWpXGLxoP4h0130ZroqAe3bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODvT5sFr+akw6q7u+WOjIvDTZg23ZJ8GM19ai0zmPRs=;
 b=I3zO42D4oKNMzAXsXZksPdvA5VeINsxyyMPDbRtg67PwM04D0nWmUjekedRDvgYl68sRDcY8ZDaw2GZVfQNr8LvqmppRWnQABmlFB3vWEJOceNeSW/tALuPsCxiJQ0iinrjeQ/Hd5LIXD3OZ6aQmFhmIJHw2gBDfAnqgKUEf4XSA3aoZoNtn2cPRdnddNF6Vo26sIu510Q8ZOXlGZL1Pfbldqsn8Zr9A5Vk8e7HoSgpvxFDWKJq5C/fz6Tdcg17xbGJuWYAGBP3HeLPrCzS3EuE1YRCSjkB1BI8zNFRDUQn06p3drbuTqvenmrYG7Yxb3JMqXuNAHC7nHlkwJsu/Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODvT5sFr+akw6q7u+WOjIvDTZg23ZJ8GM19ai0zmPRs=;
 b=owTgdNRRMHMeRONXdRaSXP22XFadUgf+tAsODzAshXJ6//BB3w3jHTMoDixIz61tyhGU5ncLf31KrD2BMYtUUg/YHJU1N9c5AkMWBOSuFeUWLqxlkW7gXL+INQYD3i6MMmTJNOCnv7ZZQryuHuvEY3Uje4z3spltugfbVu1U8FbwzY2flHdtzsPMoSn6wEyS2vyrf1eBLY+ipQ+rzecT8NG8Xn/20LuITtykQFOvHtZcmjbrwu30bBjfe4OxHoTqREupjC+HyfJitpuLxG4SQ3MEXlyYwHwKvxqNu0MGPrX0XiX9h8AUUHjIB2UlBoroT9BD75L9OFmf3r9wAGE2uw==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4012.namprd12.prod.outlook.com (2603:10b6:5:1cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Wed, 10 Mar
 2021 12:31:30 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 12:31:29 +0000
Date:   Wed, 10 Mar 2021 08:31:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, aik@ozlabs.ru
Subject: Re: [PATCH 9/9] vfio/pci: export igd support into vendor vfio_pci
 driver
Message-ID: <20210310123127.GT2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-10-mgurtovoy@nvidia.com>
 <20210310081508.GB4364@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310081508.GB4364@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0393.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0393.namprd13.prod.outlook.com (2603:10b6:208:2c2::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Wed, 10 Mar 2021 12:31:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJxzr-00Ahin-T9; Wed, 10 Mar 2021 08:31:27 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9a7af43-c5a4-43f7-20da-08d8e3c06e03
X-MS-TrafficTypeDiagnostic: DM6PR12MB4012:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4012A81587A509DEA028A4C1C2919@DM6PR12MB4012.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4InAaKmWI4iiMisCjxLtegCWKhhKrnc1WU4SgOHic+ojnwZpNfGQRXPN6oXUYAWMrFBvLgUUTFHU4vK2KGbETJDBn58fko5NjTZlSzjPmtH+zZSrArasz2aPyjbXHHQszLw9Rm9jdDHjmjZ0KipSJF8DgIu6oM5UfCAXy3Jfk+SBartDGBEDmyHkBo7vc+9oXOW/N+OH6xQnrBxaQtPFWATylW+wtH3NNU+a3w6Jhp05KD/sNkKpXE8DcTLMGDDA0hZQwjeT0iuh9mbPuYlI1WzA3zwV9R+7o/JsRxnFfA8erBW6WO1uShzRJJ2/CvHbmfujvBB/S6CiEgEieHqdSeFeqWyRazU5I8S2VxEX3k+opN3MLV7q/eNaIG7ID1lHohGSanFGv1OsxM7z+DAV7ALxvav0bLoEEdgRHJ38i9NgAqz13KHAZnuGR3OfwbAAFzFZ0738tqqGqLnfsF26GUZS+jpAmAvwmQhYe0Ilpyab8Ueh1JDze4wRn9BMwr21aHZC1NG6sp2OgJRgYewVSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(9746002)(2906002)(8676002)(478600001)(4326008)(66946007)(6916009)(83380400001)(1076003)(36756003)(186003)(86362001)(9786002)(26005)(33656002)(66556008)(5660300002)(66476007)(2616005)(316002)(426003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?M22nmN4bm1OPGpMhdiJfU72FAr5zj7pKLglTv0cYbPknmH/RVw4Eswjc3Xi2?=
 =?us-ascii?Q?muZ9PkH/kaNe0IBcuCDQiEoXNj4RrsxTry5cpNOKIHjCH5YUMJ2/zulxMrY9?=
 =?us-ascii?Q?D4GJP+ZrXbS2dX8sneD0UYTQJ+5Rltx8sVPNFFAHwRIInMjepRaEOwCY0CZ9?=
 =?us-ascii?Q?bQHJir8yGX8I67gzcADyVM8CwPyyDMViP3hRFOdcQc5ZpI/x8N/9eS7zGVRh?=
 =?us-ascii?Q?l8jGoylcfPk6SQZwIMqTokJhGqeq+BKII69FkePzGu56xq5/ghY2k2f9Lfa5?=
 =?us-ascii?Q?9a3x99jHg+egyC5QUzqbOfQd0F32o5hRhPm7GPI64O/MLqagb5BtfSYX+bnY?=
 =?us-ascii?Q?hMD1c6sbFn0RUapwl76ADx0+e5mpBLXsXzPLu8liymvM38HhO2D1VaZ3bh2w?=
 =?us-ascii?Q?ft9BVU5zZ6Ib8ONlnNO6URQfT+SveC7oZQwN6RS2eMBzafsmJAZBgzFyEZgt?=
 =?us-ascii?Q?vSSCao84Sa6/UC9PHqupT1wIsGpTeEI1/ubKwyYvuw3c1VUrBRxjaQlhP9g8?=
 =?us-ascii?Q?Rbqus6KOe+PCIEkEBJUwt43c3btxvMtNoZ5Amq4TNNrZu7MZjxhB2G4cXm/x?=
 =?us-ascii?Q?ApofZrzcKIphJw2/vjqkoiwO05p3AOZCYAF9sa5V8qbndsEE+7bGc638kOtv?=
 =?us-ascii?Q?f6xDcMnszcUwQxHK/zzTK/MGcYy/X3gr5wQAc9FW+CjX24EXEAHosdpcOn3N?=
 =?us-ascii?Q?0Xb8XeHsMvWzZPu2ooDly/rixLVlsL5bZC3tS9sjCjuRp49hFp5QvxZelWO0?=
 =?us-ascii?Q?h2j8HHlJION9egDujHiYbwhKY6esZsNCg99e1GjjFnK+/LP3j9pti0boEjQK?=
 =?us-ascii?Q?xImm/JxsIr6sasHI5r/oUlzBs1RPha2ZJnkT8efF4xioIysu5ds4mC3MTiC3?=
 =?us-ascii?Q?eEPhw6SMWtuH3Hs+PsbC8D4AnfFlGfc8EkJSAZ5Hi3DJNWgP2iiEg3hkaQ4+?=
 =?us-ascii?Q?XA3OLSYdg4qnB+cLWgkszkMb6nQ8giT47vP8R1z+9hOL8klrui228cA5YLh7?=
 =?us-ascii?Q?glX950iDU2tuMBcleEHJJE5hDL7aP+8JC9TCMzDoKQpM7jIsxzSaCnYR61Sm?=
 =?us-ascii?Q?pE0FFygfkKkI7sPJ3B5xQRSE9n+GKe2DMieIytkZsW2HlYptm58kCmlLI7dD?=
 =?us-ascii?Q?KVrNlPALdapQid7snoq2pEovpryZV0FjU8C2NtYvsLHO4rJjmi9MZGQ3i8+c?=
 =?us-ascii?Q?lY4NQg8QZ7LfLW/FQ5G4ccfLPvKSdJ/+1BvTYTPoHxWxOiZbmhZN3DRxsV7T?=
 =?us-ascii?Q?fhb5VmqCMuWqkd9nJO4GjUAQsm5fbzN2vB3x+0D9BBUqGORFGvYRjmliMFW2?=
 =?us-ascii?Q?fu/tQd6MhXW3lNSey1DjqmgVFisixY9UOVLboLrv25msdA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a7af43-c5a4-43f7-20da-08d8e3c06e03
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 12:31:29.6617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hs5YXVVTEKtAKxRSowY81No4BEENZrp7zxHnMCca9Yq/OqdrZc/DuNJkLsr6pe5C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4012
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 09:15:08AM +0100, Christoph Hellwig wrote:
> > +		vfio_pci_vf_token_user_add(vdev, -1);
> > +		vfio_pci_core_spapr_eeh_release(vdev);
> > +		vfio_pci_core_disable(vdev);
> > +	}
> > +	mutex_unlock(&vdev->reflck->lock);
> 
> But more importantly all this code should be in a helper exported
> from the core code.

Yes, that needs more refactoring. I'm viewing this series as a
"statement of intent" and once we commit to doing this we can go
through the bigger effort to split up vfio_pci_core and tidy its API.

Obviously this is a big project, given the past comments I don't want
to send more effort here until we see a community consensus emerge
that this is what we want to do. If we build a sub-driver instead the
work is all in the trash bin.

> > +	module_put(THIS_MODULE);
> 
> This looks bogus - the module reference is now gone while
> igd_vfio_pci_release is still running.  Module refcounting always
> need to be done by the caller, not the individual driver.

Yes, this module handling in vfio should be in the core code linked to
the core fops driven by the vfio_driver_ops.

It is on my list to add to my other series, this isn't the only place
in VFIO drivers are doing this..

> > +	case PCI_VENDOR_ID_INTEL:
> > +		if (pdev->class == PCI_CLASS_DISPLAY_VGA << 8)
> > +			return get_igd_vfio_pci_driver(pdev);
> 
> And this now means that the core code has a dependency on the igd
> one, making the whole split rather pointless.

Yes, if CONFIG_VFIO_PCI_DRIVER_COMPAT is set - this is a uAPI so we
don't want to see it broken. The intention is to organize the software
layers differently, not to decouple the two modules.

Future things, like the mlx5 driver that is coming, will not use this
COMPAT path at all.

Jason
