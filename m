Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1214338FD9
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 15:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhCLOXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 09:23:51 -0500
Received: from mail-dm3nam07on2070.outbound.protection.outlook.com ([40.107.95.70]:10080
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232159AbhCLOXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 09:23:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHNdb5w+Yrn4pzcGZr7tPol3lRqvGwqCQA0FugCPJoX67t/ypRgXxvRyEelXdSXs0Njsrai/dq+oDFth3xDRaGl74CQYy28KxfviH3nl1Rk4KGnR6YxHzIKK10uz4teJ7VgEcZUS982yGp+XUNcSVbNoA+SMAYTC2awYT1ghVVQSpE+3aHjNO8stgJRqhHsMziIAIeMlKNAjzaC6uaxpRjpaGH31ZialSVwfqisotczdhcEP7kdSnY/aDjMqF9olHP72+lSO2Fvju3Mgw4YTuAWFBIVBxklJxHhmaMo+rH4nZILEIsEN0xgkx9HhpFVaZvskIfkGpyfuHcdNHLN2rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zin0nLDZCugQcu6jejjKaxd5ji4T/ZMNvYtylkp996o=;
 b=cQ1qi8HipYmv1KITmvXbFHLT/m2yEQAssFIktFn9yCGStp7/jZ/CExTUHNlun6OiPRU1VkLh1aEQPi9ldqcmZ+qpqQ2qiQaJlKeLsEiuONJVsk0mfPf2a4etkLU40LkL0emtasb1LQ+0ry2dQS3TTnuHufaY3kPbqEjLScdliE71889C7VHp4H+hnewtYfJePYVxLGAGAwwODGTkwZ3xCsZVLY53TxnDRjabP+veX416qQ7oQFFCARAIEIE4WA9526agIE/SkJ78XH4GarMy9U/KABjZ4GdT9SLrWlW9ZRKoSm6lBPC09rDzkYk5KZRfGpXzhW4DtI745wnhVATHkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zin0nLDZCugQcu6jejjKaxd5ji4T/ZMNvYtylkp996o=;
 b=P4/5P9nmHMe/Nbe4kpiwrwYQX7xx6vzAEwWdPAllFAkAPj2xQXssmze0jPdTfszyKxzf3/06xqelDUxhR9Qr8NyPH5iEsNshwXToXLX0hhmFjbpIg74AAHZrD3mQ2ArktaveMWYV8CSBJNZJTMzBJuNkzeHCWZbrsg/om5KYgK6jApWDkoMgybdvDNDbdLUBubg+2lFAF0REIcglUktIG+tALxSwmi1Y6rlTUl82jPGuFHP6X6eFi4YAocbT4br2LjvyPSf6r/1gr+BkaDXZXyaWNGwAR98I1AxeT8NesMUtg5YRVE87oBEgZYHOwYxcpPv1p0zg9B9TgNz+qKsaEg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1514.namprd12.prod.outlook.com (2603:10b6:4:f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Fri, 12 Mar 2021 14:23:27 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 14:23:27 +0000
Date:   Fri, 12 Mar 2021 10:23:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 02/10] vfio: Split creation of a vfio_device into init
 and register ops
Message-ID: <20210312142326.GA2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <2-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <BN6PR11MB4068BDE65D5AA2A3E0A1200BC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR11MB4068BDE65D5AA2A3E0A1200BC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:2d::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR03CA0011.namprd03.prod.outlook.com (2603:10b6:208:2d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 14:23:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKihK-00BvIp-6r; Fri, 12 Mar 2021 10:23:26 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 933743b0-c1ca-4917-2c9d-08d8e5626754
X-MS-TrafficTypeDiagnostic: DM5PR12MB1514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1514528194B723B54C20E5BFC26F9@DM5PR12MB1514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHMATy1e6xH/BicCLTFhU/xEhzAj3obxAPE9QHQLqQresK3r6s91IH4OXh9En0nzFA1UGJTNpJT1RKq1muSEFQVBNfP6N1Hc6BNvnxQoU0YSQnB8k20R1JMrb50qu2IkVQjErXOe0IgypLP6m9kVXenFn4BY7nKdu4p2CwqKdvEqeu/bd5D1H/Bxt4ZWDAv5Q0XmI2P+4/ubNOdvk+zNyFQRP1+DiDPjrSChMgd6BI0N6Jtu8BEGLP7XtEC4ZNwAz2JvKPgTnc/smEZptWmbargNJZaIwwIYzL2PUD25Ll8Z6ZksNUR6P/NOkuSMVJwNfOJYU5v/VSwJ9OhjaiNLlterDRM62cKwqm3rXP7VO5XPjrX3/7vm89NSr+gD8BKrJ0ebZrvrdAl1BTSbyHIkHLC+5LkiKErFgZVJeoAK5iPXGwOK7NaUXCashR/Pxvgj0TRPeNp3EqS2RzKr2/70zWms7/DLyjAT/dVpIIEpxTkSP6jxgNpBOffA+t2vsltUxPezb/KmnQHBKWlybvkXpap0vQuuEuPG+N1Bc7GI3mwP73qGN+7z/lIvDABp5dky
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(6916009)(8676002)(54906003)(7416002)(316002)(107886003)(2906002)(5660300002)(9786002)(9746002)(26005)(478600001)(4326008)(186003)(8936002)(426003)(2616005)(1076003)(36756003)(33656002)(86362001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lVK/22l9jG2jIaYkrrmGywG3oKPUIEHOuZjaDyYj0TDG7MdYcUwcApSBomPQ?=
 =?us-ascii?Q?v2eeBLazhtMVprMwdNMUQRQ4W3Y3tVj+C0dPS+tpKh3IWy7krUAOyxiRMPMd?=
 =?us-ascii?Q?dwtJJEK5oDOZD28n0hQiz16357K7XBgQnSHNH0Ko5blLlyqr5gvhWHFfYaMK?=
 =?us-ascii?Q?uQicnSwz9sLBCf4viuTT3No9ph1uKen4ENsTi+f6BMztGjEVgAfKvnylNCLO?=
 =?us-ascii?Q?s0mYKDb0lN3+GJ9hYQyiOa8psIgKGY4/0kyaTpOVxe/W6ZjI2x+KBUyQ6USz?=
 =?us-ascii?Q?NH+TYsA9Z1y924HKJDwO6GGFOX93WuN92NQg8BKDlMDMRGVEk5bTHSeEkMGk?=
 =?us-ascii?Q?5m5h6w6otEE2LtN5GzppKeqj8nZqE6HonfCjBEgNBgKKl0Q/s39EukDl+u3/?=
 =?us-ascii?Q?7MJ1gR1bhnXXt6rkBhnx9RlRpjkjqQeNCZI2zxCTREC5Jtb9ZdrJ4pScZLC3?=
 =?us-ascii?Q?izOnX0QbzCjO48Subn6OCHPVf3itLqjJh7RdN2FtRbr8mn7Lknpa6F6ndywy?=
 =?us-ascii?Q?iqK00oeV6/EGMnyWT/1z+dnJVpyU6TjpzzaKyDpldjSM7KCe4OsHRMz5mVBX?=
 =?us-ascii?Q?6cLcD1aJmjdladfQMHQk4UPdgMebK6elxvl2Sg4eVFD4+7OHeStrr3ECnZXb?=
 =?us-ascii?Q?7ZIjhQ0Kzme7nSqNag+ySvEmGkilnp+uRaPKT/gnbsYTnVwow3SRK+E2dRRf?=
 =?us-ascii?Q?VYWnF+3r4YfMSO0ZxjtngoIc1Xnqp89zazrKeoppoXwy2ec+UkHU53syOhC3?=
 =?us-ascii?Q?n5JwW7AFt7qqRlFEyKXhYga61gxETdvl4n9T9k4vfTxoKOD37RLWX4hhA3rV?=
 =?us-ascii?Q?ZI1JMr+4YxUiJZ2xysGwV83WWkzdz/UlZ4C3CYktCA61TvPX8LNTSnASmWTf?=
 =?us-ascii?Q?NLum9os9sAsDf97irK7m4Jn/PFfgmVOzN/li0ZkHuVNPtob+OAZ6fDxtMi2X?=
 =?us-ascii?Q?Mcg0xl09G40CA4MbAt5uUY9PGBa08MKRAJRf8aov+AXP/MZiFnF7WMW9BIYc?=
 =?us-ascii?Q?CBaPyVwx5hFveig0Ecmr4vHDEbTALEbmTz/0QItq338yfL5yNaDHTBjzyU+t?=
 =?us-ascii?Q?cbFTtEBxBLSd5Zo9/gRAtosXBZCzZ/0IVkM2ZrceSuOCeyge8qzqJF3FFAfU?=
 =?us-ascii?Q?z+4iKVXCppPfygHBP7ty+2trKRm4ICRzNK0EsTGvXLSrqRWaRK8k5IIqlCnJ?=
 =?us-ascii?Q?UiRF84n2uaeyj2eYPxozRyzJhiRBKFBJa3fxgYNCrayIaF2mXfE/qvuJDHue?=
 =?us-ascii?Q?ZYx6KDRKTlE4Q+mv1tiCzmdY+U6u+fM2EceY0KFp5pmsgUaAJDcyzRE5e0AT?=
 =?us-ascii?Q?TDP0AlVU99T8+K21thUQkZbphR+DPuGA/VXpwNrzmsk5Eg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933743b0-c1ca-4917-2c9d-08d8e5626754
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 14:23:27.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BynunQl+/1k8pRLVFIwtVPIkq3r+GpyV5zbBjNETcFZrXQEpYOPc4m9Iap4YhT2O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1514
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 01:04:29PM +0000, Liu, Yi L wrote:
> Hi Jason,
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, March 10, 2021 5:39 AM
> > 
> [...]
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index b7e18bde5aa8b3..ad8b579d67d34a 100644
> > +++ b/include/linux/vfio.h
> > @@ -15,6 +15,18 @@
> >  #include <linux/poll.h>
> >  #include <uapi/linux/vfio.h>
> > 
> > +struct vfio_device {
> > +	struct device *dev;
> > +	const struct vfio_device_ops *ops;
> > +	struct vfio_group *group;
> > +
> > +	/* Members below here are private, not for driver use */
> > +	refcount_t refcount;
> > +	struct completion comp;
> > +	struct list_head group_next;
> > +	void *device_data;
> 
> A dumb question. If these fields are not supposed to be used by
> "external modules" like vfio_pci driver, how about defining a private
> struct vfio_dev_prive within vfio.c and embed here?

This is rarely done, there should be a good reason to do it, as making
a private structure in a container_of system requires another memory
allocation.

'struct device' has this for instance, look at the 'p' member.

In this case I can't see much value

Jason
