Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FD642A3CB
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 14:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhJLMHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 08:07:10 -0400
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:50368
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233045AbhJLMHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 08:07:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPISxM4VBniBWHrL2HWvtQRpGA0AbuWA7650PyXg+VviaCgTgl4zqNIW4gAcvPf03uhITjgO+eIKpmu45XRwKPuC6DMD5WKWouVRpSphqjUAimDiOCnGhghjemysdefXO3Was40RoKUDbguMWwf8LoN1HRVzG20CwiD0CjJz1gbu84nKQVizgO296Agvkadv+gcElYrh81aamV86/V1hXFG0yRU2xED3TAZaUQqfXvQ3iYW0J4XjtoBbZIVp/5mcMEo6sGDEghWlZOr1M0dEZdxCPN1w0xRAskeTKDEBacyihYokUUnTQNQ2LteS/1XldinwPggmoFIJvOF2yI+Xcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ujlSrQgGnSdH+p896qPdUuJ2fQ8zIltb3LNEgcJg0I=;
 b=EaM9t3kqoGuzoJbTolcat0UUnKPlLMB8O5VYytnZgfH4q6RXRC/L9gcscVnC1BESrkCXfSNz23yaeOWOwGPFUfEywqmB1F1iA8asnL5cIQj2/tszXHOeCipA3ye9letNObfLBtR7c8tmQCSx1TIr6n6cekFf5TkYQm6BwDmq/0Xbxw5HO2ZCKc6R1aLSGr7wER2q6KuC86Gy8mP91riweo/oEm+bBwwoq7MF7nbO34dVkIc5nTVj0PiXrl1mmScPO7Pa6G22MBCM7XfGRBx5dSVeZxfh14sDm/33TA0TVP0YdeV7h/m3OthOstBxCWYYdVltUeco/t2bC9JEGC89Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ujlSrQgGnSdH+p896qPdUuJ2fQ8zIltb3LNEgcJg0I=;
 b=DzQ8dIqRvjVfkL6JqbmeioEn00oqXJr/kPgVELorlJ5fXkqLr/xWcsxuKJgzZOfXLb10vG04tMZ8TTPOFO+EHITVzd9mHrOShOXniAJ0MOmI6pvZWvungAMxz8+h3nDV6O4oq7YWMEZlXLTMU6P+AvZSGGYiaCgEIsuTqDoFu1Ct4aLd1pYB+MGDry1NwM0sq5nV7qnyMnm2xdh4dZIRyGKgzBkwMgMTyz/tYUn9YWpr/TgrFinypurhR2VTuIMV1JdfZNYl+zRQ+Gc9PpV5y0c19mtKeuvPqokg/RB2n/TZ8Ma91VQ5EUfSKX8UOKON6iW28ViMmBYMHsB4gW+xsg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5378.namprd12.prod.outlook.com (2603:10b6:208:31d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 12:05:06 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.014; Tue, 12 Oct 2021
 12:05:06 +0000
Date:   Tue, 12 Oct 2021 09:05:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Message-ID: <20211012120505.GT2744544@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <BN9PR11MB5433538884DA4EB3B5BF89628CB69@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433538884DA4EB3B5BF89628CB69@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR22CA0017.namprd22.prod.outlook.com
 (2603:10b6:208:238::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR22CA0017.namprd22.prod.outlook.com (2603:10b6:208:238::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 12:05:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1maGWn-00DtrJ-3J; Tue, 12 Oct 2021 09:05:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0bf8797-8231-4eac-cba3-08d98d7887cb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5378:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53788850087FA5B8C2B66263C2B69@BL1PR12MB5378.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oL/bQD0XltZkl+Heir0jddD1usN9jxiuP8wqp5aASokc7Y1+56bmB3wUo/JuwrESqgiX0GfTdDy/KW9qGK/OKDnCJDFRmBjgaVE3MEuG+KCRgsMQgkaVcjPTGtj6cV2AuQW1QfQlwbFmQLiRz51HSIYiFeoZrlkGZOKZVe3ToryMhapYZ88TN3zoL456jQWFSLIKoimu9fxpMF+lhJ/jvLzJafl82hI9yyTo+hQaawiqsLeEaLEn5vdeRwiG/E67YPh30pKfxC4Ehcu4JcC1PnHnlG1eL0JEd1CZ3LLyOp9BoBfis+KkNraMtCGJ+F2YD/ksUUTb3HHniBBRyI4smqSDf/BsREMD1buwRuk+2s9GNT9eOToQH5GuldvnUQJsx7NO02nysoPVtuOLBkIwn1d5PXKlq0sEuWtJ7osD0toIStsQaHyQjBgQntAIDrmlsoUSxb3CAv82LCyN1ROXdlChtDr3BSgYPR//zmuutBDF6Fv1iFtfsdsW1AL+MXRXM88Eeb28632lIrOJRop18xsE0uWc0pm+t5FNVhwO3lDxThA7Gcgy5/ZmmsqYawEjnZ/nOdpd4oJD1b46++nP88k0N9BpM1jcQbZJZlNTTsBNUJZAJyrAfI8vHTZLdrgOW9P4JOHCrJEn7xBboDudew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(33656002)(6916009)(316002)(186003)(5660300002)(9786002)(8676002)(38100700002)(9746002)(54906003)(2906002)(83380400001)(508600001)(36756003)(86362001)(2616005)(1076003)(4326008)(8936002)(426003)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FI2+dykixcMZIKmspiVOPWyvH6RY2rcIk7bnmpOyuQQ/AZ82G/ffWAYAIBgg?=
 =?us-ascii?Q?J6gb1aUBfkAG5Vx+pPdYqrN/7sEQOdSQLKoXc1PfrLR2vcXczgct/Ro9Xbjo?=
 =?us-ascii?Q?Q38SJQpLHurBIszZV62I75JlG0P2RLIpF0q1YrRgR3YPkgd4KXcKdDzh4dFl?=
 =?us-ascii?Q?JLvJ5bVJsKrGK0S2RQRaG1uou0NYigUo93G2iR6MOZedSNt9Pp3dzEAsuN8B?=
 =?us-ascii?Q?Ab70cntXYj7ghCVBWveIV7pRBG+CUqylceryU3yazTY7kngo88F9kOZS+8cF?=
 =?us-ascii?Q?HILKh1lseNR/0ejejCyzhcab2rdJVEhHhN9cx/YwC6AzmuCkoFPxxO0TnuO+?=
 =?us-ascii?Q?+fJdhHkmSFTSyp+jg8IwWqKI6YII7ZOwuPe+TARCfAnk857xYQgSNG6HpmHD?=
 =?us-ascii?Q?DBtfuNxJ4DtZ+BWY7+eaM3NBpa+4nSI7GUH1iHnPt/FRbznuTmuoGb5rGC3C?=
 =?us-ascii?Q?vaUxMLgB9uYSb2Q1lIJF/Zf3sJCqAOgokJtZ4aXcXb1dcqD8qSDn8C/muqEW?=
 =?us-ascii?Q?K9HmHi8zhGonOFB1nmENYfqyBIo0VpjB+5qu36UhwTsL1uMr/yggZwgARk+L?=
 =?us-ascii?Q?9aT1GFcplmoMTt65IMAPCMQiwr3WJZXsn3g3lwzBoMgTYn086U29pF+7uQh8?=
 =?us-ascii?Q?Smlh/ZdGlsklCybunDynjxoTllA4x7D76OpfEwGO8Qf8HMzricqUt295sc+X?=
 =?us-ascii?Q?qK6EpOPS79JbTFfD/JzEydmejsRx6hIfa/YN937p66V0QIBRzqiF+Ca6Mqx+?=
 =?us-ascii?Q?pN6UAtUBJ+RXX9OltpZBcRESKp1buM98II0yjhPCzZGFlGYcJiPpTYgNoJYi?=
 =?us-ascii?Q?bVEzriIQZtSl8lB5r9FBCQpkKtUNSOLDqsjvf1m9lsinjjI22NbIhJe4kjc/?=
 =?us-ascii?Q?9PyPJVtHOIaDEhK0NrUxua3k89S65PeBC1LTubSK816BxrgmLaT2uDRf8H9m?=
 =?us-ascii?Q?oofd8wDBCH7kc4hhq7HtADzTv77zKymMsSDBEBRTPFzSkOHMJw5GkKyhnMhz?=
 =?us-ascii?Q?on/KyB1X/XND+fTa4QBTfbHSKMlPe4Mop7dDV2CaFAzx3ReB5vwMKKLmf5oO?=
 =?us-ascii?Q?UFb2/NBJqrE3qqJhVXozpiKJnOBL7Z4h7Wd6X0jDFVsazFQVHf4asuEThf7v?=
 =?us-ascii?Q?xmoiXilb5qfm1e7jHoinHAqDHIxQPdT0tTRTg+kWmrVQwFfXOmhWx9ZdtePS?=
 =?us-ascii?Q?bBXRzg5sHg7Aw5hr3FL4eF9Ne6cd5wc/YJbd9N9Wn9Gf7b9QuoAs/iukRU2Y?=
 =?us-ascii?Q?jfNfkVj/4P3Q8rvdEDNmoIrGQ+Z843OonVoLBybbjKyScyZEqHOtE1dpsCOn?=
 =?us-ascii?Q?fwomNMwI31wY7bbYLCn410pQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bf8797-8231-4eac-cba3-08d98d7887cb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:05:06.5588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THdcCfP4WorpnB0cnfREphO8lKrdP8MTGGLTj10nkPgGTgxDFD7tn5hv3g6SHA+z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5378
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 08:33:49AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, October 2, 2021 7:22 AM
> >
> [...]
>  
> > +static void vfio_group_release(struct device *dev)
> >  {
> > -	struct vfio_group *group, *existing_group;
> > -	struct device *dev;
> > -	int ret, minor;
> > +	struct vfio_group *group = container_of(dev, struct vfio_group, dev);
> > +	struct vfio_unbound_dev *unbound, *tmp;
> > +
> > +	list_for_each_entry_safe(unbound, tmp,
> > +				 &group->unbound_list, unbound_next) {
> > +		list_del(&unbound->unbound_next);
> > +		kfree(unbound);
> > +	}
> 
> move to vfio_group_put()? this is not paired with vfio_group_alloc()...

Lists are tricky for pairing analysis, the vfio_group_alloc() creates
an empty list and release restores the list to empty.

> >  static int vfio_group_fops_open(struct inode *inode, struct file *filep)
> >  {
> > -	struct vfio_group *group;
> > +	struct vfio_group *group =
> > +		container_of(inode->i_cdev, struct vfio_group, cdev);
> >  	int opened;
> 
> A curiosity question. According to cdev_device_del() any cdev already
> open will remain with their fops callable. 

Correct

> What prevents vfio_group from being released after cdev_device_del()
> has been called? Is it because cdev open will hold a reference to
> device thus put_device() will not hit zero in vfio_group_put()?

Yes, that is right. The extra reference is hidden deep inside the FS
code and is actually a reference on the cdev struct, which in turn
holds a kobject parent reference on the struct device. It is
complicated under the covers, but from an API perspective if a struct
file exists then so does the vfio_group.

Jason
